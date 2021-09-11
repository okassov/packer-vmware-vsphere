# Maintainer: Okassov Marat
# Packer template for Ubuntu Server 18.04 LTS.

build {

  name = "build-ubuntu1804"

  sources = ["source.vsphere-iso.ubuntu1804"]

  provisioner "shell" {
    execute_command = "sudo {{.Vars}} sh '{{.Path}}'"
    environment_vars = [
      "BUILD_USERNAME=${var.build_username}",
    ]
    script = "../../scripts/ubuntu.sh"
  }
}
