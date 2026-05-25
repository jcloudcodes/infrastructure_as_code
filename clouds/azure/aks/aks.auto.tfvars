azure_subscription_id = "b4839350-90c8-44f1-a077-af30199bbd11"
azure_tenant_id       = "38a4679a-7d5a-41d7-a4a6-45f661699acb"
azure_location        = "eastus"
resource_group_name   = "rg-ai-demo-aks-dev"

cluster_name            = "aksdemo1"
cluster_version         = null
private_cluster_enabled = false
private_dns_zone_id     = null
sku_tier                = "Free"

vnet_subnet_id = "/subscriptions/b4839350-90c8-44f1-a077-af30199bbd11/resourceGroups/rg-ai-demo-aks-dev/providers/Microsoft.Network/virtualNetworks/vnet-ai-demo-aks-dev/subnets/snet-aks"

service_cidr   = "172.20.0.0/16"
dns_service_ip = "172.20.0.10"

node_pool_name                        = "system"
node_pool_temporary_name_for_rotation = "systemtmp"
node_pool_vm_size                     = "Standard_DC2as_v5"
node_pool_os_disk_size_gb             = 128
node_pool_os_disk_type                = "Managed"
node_pool_enable_auto_scaling         = true
node_pool_desired_size                = 2
node_pool_min_size                    = 2
node_pool_max_size                    = 4
node_pool_max_pods                    = 30
node_pool_zones                       = ["1", "3"]

network_plugin    = "azure"
network_policy    = "azure"
load_balancer_sku = "standard"

admin_group_object_ids = []
acr_id                 = null
