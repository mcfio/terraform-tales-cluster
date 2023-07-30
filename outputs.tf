output "network_name" {
  value = vsphere_distributed_port_group.cluster[*].name
}

output "talosconfig" {
  value     = data.talos_client_configuration.cluster.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.cluster.kubeconfig_raw
  sensitive = true
}

output "cluster_name" {
  value = "${var.location}-${var.cluster_name}"
}

output "kubeconfig_host" {
  value = data.talos_cluster_kubeconfig.cluster.kubernetes_client_configuration["host"]
}

output "kubeconfig_client_certificate" {
  value     = data.talos_cluster_kubeconfig.cluster.kubernetes_client_configuration["client_certificate"]
  sensitive = true
}

output "kubeconfig_client_key" {
  value     = data.talos_cluster_kubeconfig.cluster.kubernetes_client_configuration["client_key"]
  sensitive = true
}

output "kubeconfig_ca_certificate" {
  value     = data.talos_cluster_kubeconfig.cluster.kubernetes_client_configuration["ca_certificate"]
  sensitive = true
}
