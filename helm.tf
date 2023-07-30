resource "helm_release" "cni" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.14.0"
  namespace  = "kube-system"

  values = [templatefile("${path.module}/templates/cilium-values.yaml.tmpl", {
    k8s_service_host = "${var.location}-${var.cluster_name}.${var.cluster_parameters.api_domain}"
    k8s_service_port = var.cluster_parameters.api_port
    pod_subnet       = var.cluster_parameters.pod_subnet
  })]

  depends_on = [
    talos_machine_bootstrap.cluster
  ]
}

resource "helm_release" "csr_approver" {
  name       = "kubelet-csr-approver"
  repository = "https://postfinance.github.io/kubelet-csr-approver"
  chart      = "kubelet-csr-approver"
  version    = "1.0.4"
  namespace  = "kube-system"

  set {
    name  = "providerRegex"
    value = "^talos-\\w*$"
  }

  set {
    name  = "bypassDnsResolution"
    value = "true"
  }

  depends_on = [
    talos_machine_bootstrap.cluster
  ]
}
