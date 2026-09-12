variable "cluster_name" {
  description = "Name suffix for the AKS cluster"
  type        = string
  default     = "aksdemo"
}

variable "cluster_version" {
  description = "AKS Kubernetes version"
  type        = string
  default     = null
}

variable "private_cluster_enabled" {
  description = "Whether to create a private AKS cluster"
  type        = bool
  default     = false
}

variable "private_dns_zone_id" {
  description = "Optional private DNS zone ID when using a private AKS cluster"
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "AKS SKU tier"
  type        = string
  default     = "Free"
}

variable "dns_prefix" {
  description = "Optional AKS DNS prefix. Defaults to the computed cluster name."
  type        = string
  default     = null
}

variable "vnet_id" {
  description = "Resource ID of the VNet used by AKS. The AKS managed identity receives Network Contributor on this scope."
  type        = string
}

variable "vnet_subnet_id" {
  description = "Subnet ID where the AKS node pool will run"
  type        = string
}

variable "service_cidr" {
  description = "CIDR block for Kubernetes services"
  type        = string
  default     = "172.20.0.0/16"
}

variable "dns_service_ip" {
  description = "Cluster DNS service IP address. Must be inside service_cidr."
  type        = string
  default     = "172.20.0.10"
}

variable "node_pool_name" {
  description = "AKS default node pool name"
  type        = string
  default     = "system"
}

variable "node_pool_temporary_name_for_rotation" {
  description = "Temporary AKS node pool name used during default node pool rotation updates"
  type        = string
  default     = "systemtmp"
}

variable "node_pool_vm_size" {
  description = "Azure VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "node_pool_os_disk_size_gb" {
  description = "OS disk size for AKS nodes in GB"
  type        = number
  default     = 128
}

variable "node_pool_os_disk_type" {
  description = "OS disk type for AKS nodes"
  type        = string
  default     = "Managed"
}

variable "node_pool_type" {
  description = "AKS node pool mode"
  type        = string
  default     = "VirtualMachineScaleSets"
}

variable "node_pool_enable_auto_scaling" {
  description = "Whether to enable AKS node pool autoscaling"
  type        = bool
  default     = true
}

variable "node_pool_desired_size" {
  description = "Desired initial number of AKS worker nodes"
  type        = number
  default     = 2
}

variable "node_pool_min_size" {
  description = "Minimum number of AKS worker nodes"
  type        = number
  default     = 2
}

variable "node_pool_max_size" {
  description = "Maximum number of AKS worker nodes"
  type        = number
  default     = 4
}

variable "node_pool_max_pods" {
  description = "Maximum pods per node"
  type        = number
  default     = 30
}

variable "node_pool_zones" {
  description = "Optional list of availability zones for the default node pool"
  type        = list(string)
  default     = []
}

variable "network_plugin" {
  description = "AKS network plugin"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "AKS network policy"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Azure load balancer SKU for AKS"
  type        = string
  default     = "standard"
}

variable "admin_group_object_ids" {
  description = "Optional Microsoft Entra group object IDs with AKS admin access"
  type        = list(string)
  default     = []
}

variable "acr_id" {
  description = "Optional Azure Container Registry resource ID to attach to AKS"
  type        = string
  default     = null
}

variable "vnet_name" {
  description = "Name of the AKS virtual network"
  type        = string
  default     = "jcloudcodes-aks-vnet"
}

variable "vnet_cidr" {
  description = "Address space for the AKS virtual network"
  type        = string
  default     = "10.30.0.0/16"
}

variable "aks_subnet_name" {
  description = "Name of the AKS node subnet"
  type        = string
  default     = "aks-subnet"
}

variable "aks_subnet_cidr" {
  description = "CIDR for the AKS node subnet"
  type        = string
  default     = "10.30.1.0/24"
}

variable "ingress_subnet_name" {
  description = "Name of the dedicated ingress subnet"
  type        = string
  default     = "ingress-subnet"
}

variable "ingress_subnet_cidr" {
  description = "CIDR for the dedicated ingress subnet"
  type        = string
  default     = "10.30.2.0/24"
}

variable "ingress_nsg_name" {
  description = "Name of the NSG attached to the ingress subnet"
  type        = string
  default     = "jcloudcodes-aks-ingress-nsg"
}

variable "devtools_vnet_cidr" {
  description = "CIDR allowed to reach the AKS ingress subnet on HTTP/HTTPS"
  type        = string
  default     = "10.23.0.0/16"
}