# VMWare templates for Packer

## Variables

vSphere variables:

 - (Required) **PKR_VAR_vsphere_server** - IP address or DNS of vSphere
 - (Required) **PKR_VAR_vsphere_username** - username for connect to vSphere
 - (Required) **PKR_VAR_vsphere_password** - password for connect to vSphere

Packer build variables:

 - (Optional) **PACKER_VM_IP** - static IP address for your Packer build
 - (Optional) **PACKER_VM_MASK** - subnet mask
 - (Optional) **PACKER_VM_GATEWAY** - gateway IP
 - (Optional) **PACKER_VM_DNS** - dns server IP

Packer SSH variables:
 - (Optional) **PKR_VAR_build_username** - (Default: ansible)
 - (Required) **PKR_VAR_build_password**

**Note: if you doesn't set PACKER_VM_IP environment variable, DHCP will be using for Packer.**


## How to build manual

### First you need to create variables file:

```console
cat <<EOF > variables.pkrvars.hcl
datacenter = "DC"
cluster = "dev"
resource_pool = "rp-name"
vm_network = "VM Network"
datastore = "Datastore"
iso_path = "ISO/ubuntu-18.04.5-server-amd64.iso"
insecure_connection = true
convert_to_template = true
EOF
```
### Set required secret variables

```
export PKR_VAR_vsphere_server="vcsa.example.com"
export PKR_VAR_vsphere_username="admin"
export PKR_VAR_vsphere_password="changeme"

export PKR_VAR_build_password="changeme"
```

### Download VMWare Packer repo with templates and build

```console
git clone https://gitlab.com/devops/packer/vmware.git
cd vmware/
./build.sh 1 ### For Ubuntu 18.04
or
./build.sh 2 ### For Ubuntu 20.04
```

## How to build with GitLab CI

First create secret environment variables at Group or Project level of GitLab

```console
Setting-CI/CD-Variables-Add variable

PKR_VAR_vsphere_server="vcsa.example.com"
PKR_VAR_vsphere_username="admin"
PKR_VAR_vsphere_password="changeme"
PKR_VAR_build_password="changeme"
```

Example of using CI/CD:

```yaml
include:
  - project: 'devops/ci/templates'
    ref: main
    file: 'packer/vmware/template-packer-pipeline-gitlab-ci.yaml'

stages:
  - prepare
  - template
  - build

image: alpine

variables:
  PACKER_VERSION: 1.7.4
  PLATFORM: vmware

  ### DEBUG environment variables
  PACKER_LOG: 1
  PACKER_KEY_INTERVAL: 300ms
  
  ### If you dont't have DHCP Server for VMs, you can set
  PACKER_VM_IP: 172.31.88.138
  PACKER_VM_MASK: 255.255.255.0
  PACKER_VM_GATEWAY: 172.31.88.1
  PACKER_VM_DNS: 8.8.8.8

ubuntu1804:
  extends: build_ubuntu_18_04
  only:
    - main
  when: manual
  tags:
    - test

ubuntu2004:
  extends: build_ubuntu_20_04
  only:
    - main
  when: manual
  tags:
    - test
```



