# Post-provision runbook — jcloudcodes-dev-aks

Run top to bottom after `terraform apply` finishes. PowerShell, from this folder.

```powershell
$RG      = "jcloudcodes-aks-dev-rg"
$CLUSTER = "jcloudcodes-dev-aks"
$VNETNAME= "jcloudcodes-aks-vnet"
```

## 1. Credentials and the RBAC check

```powershell
az aks get-credentials -g $RG -n $CLUSTER --overwrite-existing
kubectl get nodes
```

Terraform creates the cluster identity's VNet grant now, but verify it — this is
the grant whose absence caused `AuthorizationFailed ... subnets/read`:

```powershell
$MI = az aks show -g $RG -n $CLUSTER --query identity.principalId -o tsv
az role assignment list --assignee $MI --all -o table
```

Expect `Network Contributor` scoped to the VNet. If it is missing, Terraform's
role-assignment step failed — create it by hand and wait 2-5 minutes for ARM's
authorization cache:

```powershell
$VNET = az network vnet show -g $RG -n $VNETNAME --query id -o tsv
az role assignment create `
  --assignee-object-id $MI `
  --assignee-principal-type ServicePrincipal `
  --role "Network Contributor" `
  --scope $VNET
```

## 2. ingress-nginx (public LB)

```powershell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx `
  --namespace ingress-nginx --create-namespace `
  -f ingress-nginx-values.yaml

kubectl -n ingress-nginx get svc ingress-nginx-controller -w
```

Wait for a real address in `EXTERNAL-IP`, then capture it:

```powershell
$LBIP = kubectl -n ingress-nginx get svc ingress-nginx-controller `
  -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
$LBIP
```

## 3. DNS — argocd.jcloudcodes.com

Find which resource group holds the zone:

```powershell
az network dns zone list --query "[?name=='jcloudcodes.com'].{name:name, rg:resourceGroup}" -o table
$DNSRG = "<resource group from above>"
```

Check for an existing `argocd` record and replace it:

```powershell
az network dns record-set a show -g $DNSRG -z jcloudcodes.com -n argocd -o json
# if one exists and points somewhere stale:
az network dns record-set a delete -g $DNSRG -z jcloudcodes.com -n argocd --yes

az network dns record-set a add-record -g $DNSRG -z jcloudcodes.com -n argocd -a $LBIP
az network dns record-set a update -g $DNSRG -z jcloudcodes.com -n argocd --set ttl=300
```

Confirm before moving on — cert issuance in step 5 depends on it:

```powershell
Resolve-DnsName argocd.jcloudcodes.com -Server 8.8.8.8
```

## 4. ArgoCD

```powershell
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd `
  --namespace argocd --create-namespace `
  -f argocd-values.yaml

kubectl -n argocd rollout status deploy/argocd-server
```

## 5. TLS, then expose it

ArgoCD's login page is about to be on the public internet. Install cert-manager
first so the Ingress comes up with a real certificate rather than serving
credentials over plain HTTP.

```powershell
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade --install cert-manager jetstack/cert-manager `
  --namespace cert-manager --create-namespace `
  --set crds.enabled=true

kubectl -n cert-manager rollout status deploy/cert-manager
```

Put your email in `cluster-issuer.yaml` (Let's Encrypt uses it for expiry
notices), then:

```powershell
kubectl apply -f cluster-issuer.yaml
kubectl apply -f argocd-ingress.yaml

# watch the certificate go READY - usually under two minutes
kubectl -n argocd get certificate -w
```

## 6. Log in

```powershell
kubectl -n argocd get secret argocd-initial-admin-secret `
  -o jsonpath="{.data.password}" |
  ForEach-Object { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_)) }
```

Open <https://argocd.jcloudcodes.com>, user `admin`. Change the password
immediately, then delete the bootstrap secret:

```powershell
kubectl -n argocd delete secret argocd-initial-admin-secret
```

## Going internal later

Uncomment the three internal annotations in `ingress-nginx-values.yaml`, then:

```powershell
kubectl -n ingress-nginx delete svc ingress-nginx-controller
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx `
  -n ingress-nginx -f ingress-nginx-values.yaml
```

The service has to be deleted rather than patched — Azure will not migrate a
frontend from a public LB to an internal one in place. Repoint the DNS A record
at `10.30.2.10` afterwards, and drop the cert-manager annotation, since HTTP-01
cannot reach a private address.
