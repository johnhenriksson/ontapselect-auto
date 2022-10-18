# main.tf

## Collect vSpherer Data

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

 
data "vsphere_datastore" "datastore" {
  name          = var.vm_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
 
data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Data source for the OVF to read the required OVF Properties
data "vsphere_ovf_vm_template" "ovf" {
  name             = var.vm_name
  disk_provisioning = "thin"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  local_ovf_path   = var.local_ovf_path
  ovf_network_map = {
    "ONTAP Select Deploy VM Network" = data.vsphere_network.network.id
  }
}
 
# Deployment of VM from Local OVA
resource "vsphere_virtual_machine" "ontapdeploy" {
  name                 = var.vm_name
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_ovf_vm_template.ovf.datastore_id
  host_system_id       = data.vsphere_ovf_vm_template.ovf.host_system_id
  resource_pool_id     = data.vsphere_ovf_vm_template.ovf.resource_pool_id
  num_cpus             = data.vsphere_ovf_vm_template.ovf.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovf.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovf.memory
  guest_id             = data.vsphere_ovf_vm_template.ovf.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.ovf.scsi_type
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
 
  wait_for_guest_net_timeout = 5
 
  ovf_deploy {
    allow_unverified_ssl_cert = true
    local_ovf_path            = var.local_ovf_path
    disk_provisioning         = "thin"
  }

  vapp {
    properties = {
      "password"               = var.deploy_password,
      "product_company"        = var.deploy_product_company,
      "proxy_url"              = var.deploy_proxy_url,
      "ipAddress"              = var.deploy_ipaddress,
      "netMask"                = var.deploy_netmask,
      "gateway"                = var.deploy_gateway,
      "hostName"               = var.deploy_hostname,
      "primaryDNS"             = var.deploy_dns1,
      "secondaryDNS"           = var.deploy_dns2,
      "searchDomains"          = var.deploy_searchDomains
    }
  }

  lifecycle {
    ignore_changes = [
      vapp[0].properties
    ]
  }
}