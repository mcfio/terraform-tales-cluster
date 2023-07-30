variable "cluster_name" {
  type        = string
  description = "Cluster name to identify it in infrastructure."
}

variable "location" {
  type        = string
  description = "Location where the cluster is hosted."
}

variable "network_name" {
  type        = string
  description = "Name of the vSphere distribute network. Defaults to `vds-{var.name}`."
  default     = null
}

variable "network_vlan_id" {
  type        = string
  description = "VLAN ID of the vSphere distribute network."
  default     = null
}

variable "datacenter_name" {
  type        = string
  description = "vSphere Datacenter in which to place the VM"
  default     = "Milton"
}

variable "vds_name" {
  type        = string
  description = "vSphere VDS Name"
  default     = "vds-01"
}

variable "cluster_parameters" {
  # !!IMPORTANT!!
  # These are defaults when values have not been specified. Any changes
  type = object({
    name               = optional(string)
    domain             = optional(string)
    host_subnet        = optional(string)
    pod_subnet         = optional(string)
    service_subnet     = optional(string)
    api_domain         = optional(string)
    api_port           = optional(string)
    talos_version      = optional(string)
    kubernetes_version = optional(string)
  })
  description = "cluster parameters object"
  default = {
    name               = "cluster-01"
    domain             = "cluster.local"
    host_subnet        = "192.168.1.0/24"
    pod_subnet         = "10.244.0.0/18"
    service_subnet     = "10.244.64.0/20"
    api_domain         = "milton.mcf.io"
    api_port           = "6443"
    talos_version      = "v1.4.7"
    kubernetes_version = "v1.27.3"
  }
}

variable "cluster_nodes" {
  type = map(object({
    cpus         = optional(number)
    memory       = optional(number)
    disk_size    = optional(number)
    machine_type = optional(string)
  }))
  description = "Map of virtual machines, cluster role and configurations"
  default = {
    default = {}
  }
}

variable "content_library" {
  type        = string
  description = "vSphere Content Library to look for the os-image iso/ova"
  default     = "os-images"
}

variable "talos_image" {
  type        = string
  description = "Talos image to use for talos cluster"
  default     = "talos-latest"
}
