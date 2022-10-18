# variables.tf

variable "vsphere_user" {
  description = "vSphere user name"
}

variable "vsphere_password" {
  description = "vSphere password"
}

variable "vsphere_vcenter" {
  description = "vCenter server FQDN or IP"
}

variable "vsphere_unverified_ssl" {
  description = "Is the vCenter using a self signed certificate (true/false)"
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  default     = ""
}

variable "vsphere_host" {
  description = "vSphere Compute Host"
}


variable "vm_datastore" {}
variable "vm_network" {}
variable "vm_name" {}

variable "local_ovf_path" {
  description = "Path on local filesystem to OVF file"
}

variable "deploy_password" {}
variable "deploy_product_company" {}
variable "deploy_proxy_url" {}
variable "deploy_ipaddress" {}
variable "deploy_netmask" {}
variable "deploy_gateway" {}
variable "deploy_hostname" {}
variable "deploy_dns1" {}
variable "deploy_dns2" {}
variable "deploy_searchDomains" {}