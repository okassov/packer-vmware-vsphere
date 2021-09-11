### VMWare vSphere Variables
vcenter_server = ""        ### (Secret) Must to set in GitLab CI Variables as PKR_VAR_vcenter_server
vcenter_username = ""      ### (Secret) Must to set in GitLab CI Variables as PKR_VAR_vcenter_username
vcenter_password = ""      ### (Secret) Must to set in GitLab CI Variables as PKR_VAR_vcenter_password
datacenter = "DC"
cluster = "dev"
resource_pool = "rp-name"  ### Instead of, you can use: host = "esxi-01.example.com"
vm_network = "VM Network"  ### Network or PortGroup
datastore = "Datastore"    ### Datastore where your ISO is located
iso_path = "ISO/ubuntu-18.04.5-server-amd64.iso" ### Full path to ISO file (without datastore name)
insecure_connection = true ### Need if vSphere with Self-Signed TLS
convert_to_template = true ### Need to convert builded VM to template

### SSH Variables
build_username = "ansible" ### (Secret) Must to set in GitLab CI Variables as PKR_VAR_build_username
build_password = ""        ### (Secret) Must to set in GitLab CI Variables as PKR_VAR_build_password

