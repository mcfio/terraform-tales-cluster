data "vsphere_datacenter" "cluster" {
  name = var.datacenter_name
}

data "vsphere_distributed_virtual_switch" "cluster" {
  name          = var.vds_name
  datacenter_id = data.vsphere_datacenter.cluster.id
}

data "vsphere_content_library" "content_library" {
  name = var.content_library
}

data "vsphere_content_library_item" "talos_image" {
  name       = var.talos_image
  type       = "ovf"
  library_id = data.vsphere_content_library.content_library.id
}

data "talos_machine_configuration" "node_pool" {
  for_each           = var.cluster_nodes
  cluster_name       = "${var.location}-${var.cluster_name}"
  cluster_endpoint   = "https://${var.location}-${var.cluster_name}.${var.cluster_parameters.api_domain}:${var.cluster_parameters.api_port}"
  machine_type       = each.value.machine_type
  machine_secrets    = resource.talos_machine_secrets.cluster.machine_secrets
  talos_version      = var.cluster_parameters.talos_version
  kubernetes_version = var.cluster_parameters.kubernetes_version
  docs               = false
  examples           = false

  config_patches = [
    templatefile("${path.module}/templates/${each.value.machine_type}.patch.yaml.tmpl", {
      hostname       = "talos-${each.key}"
      ipv4_address   = cidrhost(var.cluster_parameters.host_subnet, index(keys(var.cluster_nodes), each.key) + 40)
      ipv4_gateway   = cidrhost(var.cluster_parameters.host_subnet, 1)
      pod_subnet     = var.cluster_parameters.pod_subnet
      service_subnet = var.cluster_parameters.service_subnet
      vip_address    = cidrhost(var.cluster_parameters.host_subnet, 10)
    }),
  ]
}

data "talos_client_configuration" "cluster" {
  cluster_name         = "${var.location}-${var.cluster_name}"
  client_configuration = talos_machine_secrets.cluster.client_configuration
  endpoints = [
    cidrhost(var.cluster_parameters.host_subnet, index(keys(var.cluster_nodes), element(keys(var.cluster_nodes), 0)) + 40)
  ]
  nodes = [
    for node in tolist(keys(var.cluster_nodes)) : cidrhost(var.cluster_parameters.host_subnet, index(keys(var.cluster_nodes), node) + 40)
  ]

  depends_on = [
    talos_machine_bootstrap.cluster
  ]
}

data "talos_cluster_kubeconfig" "cluster" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  node                 = cidrhost(var.cluster_parameters.host_subnet, index(keys(var.cluster_nodes), element(keys(var.cluster_nodes), 0)) + 40)

  depends_on = [
    talos_machine_bootstrap.cluster
  ]
}
