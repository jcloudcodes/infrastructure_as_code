variable "vnet_name" {
  description = "Name of the virtual network created for this stack"
  type        = string
}

variable "vnet_cidr" {
  description = "Address space for the virtual network"
  type        = string

  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0))
    error_message = "vnet_cidr must be a valid CIDR block, for example 10.30.0.0/16."
  }
}

variable "aks_subnet_name" {
  description = "Name of the subnet the AKS node pool runs in"
  type        = string
  default     = "aks-subnet"
}

variable "aks_subnet_cidr" {
  description = "Address prefix for the AKS node subnet. With Azure CNI each node consumes (max_pods + 1) addresses, so size it accordingly."
  type        = string

  validation {
    condition     = can(cidrhost(var.aks_subnet_cidr, 0))
    error_message = "aks_subnet_cidr must be a valid CIDR block, for example 10.30.1.0/24."
  }
}

variable "ingress_subnet_name" {
  description = "Name of the subnet internal ingress load balancers are placed in"
  type        = string
  default     = "ingress-subnet"
}

variable "ingress_subnet_cidr" {
  description = "Address prefix for the ingress subnet. ingress_loadbalancer_ip must fall inside it."
  type        = string

  validation {
    condition     = can(cidrhost(var.ingress_subnet_cidr, 0))
    error_message = "ingress_subnet_cidr must be a valid CIDR block, for example 10.30.2.0/24."
  }
}

variable "ingress_nsg_name" {
  description = "Name of the network security group attached to the ingress subnet"
  type        = string
  default     = "ingress-nsg"
}

variable "devtools_vnet_cidr" {
  description = "Source CIDR allowed to reach the ingress load balancer on 80/443. Leave null to emit no allow rules."
  type        = string
  default     = null
}
