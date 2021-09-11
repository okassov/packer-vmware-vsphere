# Maintainer: Okassov Marat
# Packer tenmplate for Ubuntu Server 18.04 LTS.

source "vsphere-iso" "ubuntu2004" {
  vcenter_server       = var.vcenter_server
  username             = var.vcenter_username
  password             = var.vcenter_password
  datacenter           = var.datacenter
  cluster              = var.cluster
  host                 = var.host
  resource_pool        = var.resource_pool
  datastore            = var.datastore
  vm_name              = "alabs-ubuntu2004-packer"
  guest_os_type        = var.vm_guest_id
  CPUs                 = var.cpu_cores
  RAM                  = var.vm_mem_size
  convert_to_template  = var.convert_to_template
  disk_controller_type = var.vm_disk_controller_type
  insecure_connection  = var.insecure_connection
  notes                = "Built by Packer on ${local.buildtime}."
  boot_command = [
      "<enter><wait2><enter><wait><f6><esc><wait>",
      " autoinstall<wait2> ds=nocloud;",
      "<wait><enter>"
  ]
  boot_order = "disk,cdrom"
  cd_files = [
      "../../configs/ubuntu/meta-data",
      "../../configs/ubuntu/user-data"]
  cd_label  = "cidata"
  boot_wait = "2s"
  http_directory         = "../../configs/ubuntu/"
  iso_paths              = ["[${var.datastore}] ${var.iso_path}"]
  shutdown_timeout       = "20m"
  ip_wait_timeout        = "20m"
  ssh_password           = var.build_password
  ssh_username           = var.build_username
  ssh_pty                = true
  ssh_port               = 22
  ssh_timeout            = "30m"
  ssh_handshake_attempts = "20"

  network_adapters {
    network      = var.vm_network
    network_card = var.vm_network_card
  }

  storage {
    disk_controller_index = 0
    disk_size             = var.disk_size_mb
    disk_thin_provisioned = true
  }
}


