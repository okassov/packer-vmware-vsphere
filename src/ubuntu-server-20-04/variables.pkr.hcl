# Maintainer: Okassov Marat
# Packer tenmplate for Ubuntu Server 18.04 LTS.

variable "vcenter_server" {
  type        = string
  description = "DNS hostname of vCenter"
}

variable "vcenter_username" {
  type        = string
  description = "Username for login"
}

variable "vcenter_password" {
  type        = string
  description = "Password for login"
}

variable "datacenter" {
  type        = string
  description = "Name of vSphere Datacenter"
}

variable "cluster" {
  type        = string
  description = "Name of vSphere Cluster"
}

variable "host" {
  type        = string
  description = "Name of vSphere Esxi host"
  default     = ""
}

variable "resource_pool" {
  type        = string
  description = "Name of vSphere Resource Pool"
  default     = ""
}

variable "vm_name" {
  type        = string
  description = "Name of Virtual Machine"
  default = "alabs-ubuntu2004-packer"
}

variable "vm_network" {
  type        = string
  description = "Name of vSphere Network/PortGroup"
}

variable "vm_network_card" {
  type    = string
  description = "The virtual network card type. (e.g. 'vmxnet3' or 'e1000e')"
  default = "vmxnet3"
}

variable "datastore" {
  type        = string
  description = "Name of Datastore where ISO image is located"
}

variable "iso_path" {
  type        = string
  description = "Full path to ISO image at the Datastore"
  default     = "ubuntu-20.04.2-live-server-amd64.iso"
}

variable "vm_guest_id" {
  type        = string
  description = "Guest ID in vSphere"
  default     = "ubuntu64Guest"
}

variable "cpu_cores" {
  type        = string
  description = "Number of CPU cores for build"
  default     = "2"
}

variable "vm_mem_size" {
  type        = string
  description = "Number of RAM for build"
  default     = "2048"
}

variable "disk_size_mb" {
  type        = string
  description = "Size of main disk"
  default     = "30720"
}

variable "convert_to_template" {
  type        = bool
  description = "Convert to template VM after build and installing"
  default     = true
}

variable "insecure_connection" {
  type        = bool
  description = "Do not validate vCenter Server TLS certificate."
  default     = true
}

variable "vm_disk_controller_type" {
  type    = list(string)
  description = "The virtual disk controller types in sequence."
  default = ["pvscsi"]
}

variable "build_username" {
  type        = string
  description = "The username to login to the guest operating system."
  default     = "ansible"
}

variable "build_password" {
  type        = string
  description = "The password to login to the guest operating system."
  default     = "ansible"
}

locals { 
  buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}
