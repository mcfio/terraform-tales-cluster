data "vsphere_tag_category" "category" {
  name = "kubernetes"
}

data "vsphere_tag" "cp_tag" {
  name        = "control plane"
  category_id = data.vsphere_tag_category.category.id
}

data "vsphere_tag" "talos_tag" {
  name        = "talos"
  category_id = data.vsphere_tag_category.category.id
}
