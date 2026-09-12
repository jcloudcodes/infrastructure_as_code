azure_subscription_id = "f18faa82-efd2-439c-ae36-7f0ccd369e12"
azure_tenant_id       = "e12bc39a-61a0-40ad-baef-91b20ca4e856"
azure_location        = "centralus"
resource_group_name   = "jcloudcodes-aks-dev-rg"

# Keep the AKS cluster name exactly as written below.
cluster_name            = "jcloudcodes-dev-aks"
cluster_version         = null
private_cluster_enabled = false
private_dns_zone_id     = null
sku_tier                = "Free"

# Existing BYO VNet/subnet used by the AKS node pool.
vnet_id = "/subscriptions/f18faa82-efd2-439c-ae36-7f0ccd369e12/resourceGroups/jcloudcodes-aks-dev-rg/providers/Microsoft.Network/virtualNetworks/jcloudcodes-aks-vnet"
vnet_subnet_id = "/subscriptions/f18faa82-efd2-439c-ae36-7f0ccd369e12/resourceGroups/jcloudcodes-aks-dev-rg/providers/Microsoft.Network/virtualNetworks/jcloudcodes-aks-vnet/subnets/aks-subnet"

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
