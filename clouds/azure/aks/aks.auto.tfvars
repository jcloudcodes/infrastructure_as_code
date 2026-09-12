azure_subscription_id = "f18faa82-efd2-439c-ae36-7f0ccd369e12"
azure_tenant_id       = "e12bc39a-61a0-40ad-baef-91b20ca4e856"
azure_location        = "centralus"
resource_group_name   = "jcloudcodes-aks-dev-rg"

cluster_name            = "jcloudcodes-dev-aks"
cluster_version         = null
private_cluster_enabled = false
private_dns_zone_id     = null
sku_tier                = "Free"

vnet_name = "jcloudcodes-aks-vnet"
vnet_cidr = "10.30.0.0/16"

aks_subnet_name = "aks-subnet"
aks_subnet_cidr = "10.30.1.0/24"

ingress_subnet_name = "ingress-subnet"
ingress_subnet_cidr = "10.30.2.0/24"

ingress_nsg_name = "jcloudcodes-aks-ingress-nsg"

devtools_vnet_cidr = "10.23.0.0/16"

service_cidr   = "172.20.0.0/16"
dns_service_ip = "172.20.0.10"

node_pool_name                        = "system"
node_pool_temporary_name_for_rotation = "systemtmp"
node_pool_vm_size                     = "Standard_D2s_v7"
node_pool_os_disk_size_gb             = 64
node_pool_os_disk_type                = "Managed"
node_pool_enable_auto_scaling         = true
node_pool_desired_size                = 1
node_pool_min_size                    = 1
node_pool_max_size                    = 2
node_pool_max_pods                    = 30
node_pool_zones                       = []

network_plugin    = "azure"
network_policy    = "azure"
load_balancer_sku = "standard"

admin_group_object_ids = []
acr_id                 = null