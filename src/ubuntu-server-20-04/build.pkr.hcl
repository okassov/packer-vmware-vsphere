# Maintainer: Okassov Marat
# Packer template for Ubuntu Server 18.04 LTS.

build {

  name = "build-ubuntu2004"

  sources = ["source.vsphere-iso.ubuntu2004"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
    ]
  }
  
  provisioner "shell" {
    execute_command = "sudo {{.Vars}} sh '{{.Path}}'"
    environment_vars = [
      "BUILD_USERNAME=${var.build_username}",
    ]
    script = "../../scripts/ubuntu.sh"
  }
}
