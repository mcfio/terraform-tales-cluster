# For now, all DNS resources are in this resource group
data "azurerm_dns_zone" "cluster" {
  name                = var.cluster_parameters.api_domain
  resource_group_name = "mcf-infrastructure"
}

resource "azurerm_dns_a_record" "api_domain" {
  name                = "${var.location}-${var.cluster_name}"
  zone_name           = data.azurerm_dns_zone.cluster.name
  resource_group_name = data.azurerm_dns_zone.cluster.resource_group_name
  ttl                 = 300
  records = [
    cidrhost(var.cluster_parameters.host_subnet, 10)
  ]
}
