terraform {
  required_version = "~> 1.5"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.4"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

resource "talos_machine_secrets" "cluster" {}

resource "vsphere_folder" "cluster" {
  datacenter_id = data.vsphere_datacenter.cluster.id

  path = "talos-${var.location}-${var.cluster_name}"
  type = "vm"
}

resource "vsphere_distributed_port_group" "cluster" {
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster.id

  count       = var.network_name == null ? 1 : 0
  name        = var.network_name == null ? "vds-${var.location}-${var.cluster_name}" : var.network_name
  type        = "ephemeral"
  auto_expand = false
  vlan_id     = var.network_vlan_id
}

module "node_pool" {
  for_each = var.cluster_nodes
  source   = "github.com/mcfio/terraform-vsphere-generic-vm.git?ref=v0.0.5"

  name               = "talos-${each.key}"
  folder             = vsphere_folder.cluster.path
  cpus               = each.value.cpus
  memory             = each.value.memory
  memory_share_level = "low"
  os_image_name      = data.vsphere_content_library_item.talos_image.name
  network_name       = var.network_name == null ? vsphere_distributed_port_group.cluster[0].name : var.network_name
  disk_size_gb       = [each.value.disk_size]
  datastore_name     = "local-datastore"
  tags = [
    data.vsphere_tag.cp_tag.id,
    data.vsphere_tag.talos_tag.id
  ]
  vapp_properties = {
    "talos.config" = base64encode(data.talos_machine_configuration.node_pool[each.key].machine_configuration)
  }
  depends_on = [
    data.vsphere_tag.talos_tag,
    data.vsphere_content_library_item.talos_image,
    vsphere_distributed_port_group.cluster
  ]
}

resource "talos_machine_bootstrap" "cluster" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  node                 = cidrhost(var.cluster_parameters.host_subnet, index(keys(var.cluster_nodes), element(keys(var.cluster_nodes), 0)) + 40)
  depends_on = [
    module.node_pool
  ]
}
