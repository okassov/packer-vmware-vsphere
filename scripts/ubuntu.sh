#!/bin/bash
# Maintainer: Marat Okassov
# Prepares a Ubuntu Server guest operating system.

### Update the guest operating system.
echo '[INFO] Updating and upgrading the guest operating system ...'
sudo apt-get update
sudo apt-get -y upgrade

### Install additional packages. 
echo '[INFO] Installing base packages ...'
sudo apt-get install -y vim
sudo apt-get install -y git
sudo apt-get install -y htop
sudo apt-get install -y curl
sudo apt-get install -y wget
sudo apt-get install -y strace
sudo apt-get install -y iftop
sudo apt-get install -y jnettop
sudo apt-get install -y iotop
sudo apt-get install -y nload
sudo apt-get install -y ioping
sudo apt-get install -y reptyr
sudo apt-get install -y tree
sudo apt-get install -y ncdu
sudo apt-get install -y zip
sudo apt-get install -y unzip
sudo apt-get install -y apt-utils
sudo apt-get install -y python-pip
sudo apt-get install -y python3-pip
sudo apt-get install -y dnsutils
sudo apt-get install -y telnet
sudo apt-get install -y tcpdump
sudo apt-get install -y traceroute
sudo apt-get install -y mtr
sudo apt-get install -y lsof
sudo apt-get install -y apt-transport-https
sudo apt-get install -y ca-certificates
sudo apt-get install -y net-tools
sudo apt-get install -y rsync
sudo apt-get install -y jq
sudo apt-get install -y sysstat

### Clearing apt-get cache.
echo '[INFO] Clearing apt-get cache ...'
sudo apt-get clean

### Add After=dbus.service to open-vm-tools.
echo '[INFO] Adding After=dbus.service to open-vm-tools ...'
sudo sed -i '/^After=vgauth.service/a\After=dbus.service' /lib/systemd/system/open-vm-tools.service

### Disable SSH Password authentication
echo '[INFO] Disabling SSH Password authentication ...'
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no\nPermitRootLogin prohibit-password/g' /etc/ssh/sshd_config

### Fix multipath flood messages
echo "[INFO] Fix multipath flood messages ..."
sudo cat<<EOF > /etc/multipath.conf
defaults {
    user_friendly_names yes
}
blacklist {
    devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
}
EOF

### Deploy ansible user authorized_keys
echo "[INFO] Deploy ansible user authorized_keys ..."
sudo mkdir /home/ansible/.ssh
sudo cat<<EOF > /home/ansible/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEg2DKXRBRfeoHGYJF+xGniqLpzdkJMylfWySPYZV0W5cq8RRWX1R904m8XalmbIVry/0y/74MZV6Ssx+SjYHgO/j6NM6YjJo/ovgnfAvNG0uPXF8cZsCE4p+7zDc5rFEm1ANMvHXHGI57rZ2YrZl7sYRVFVZ/XvSIjzWS40QuxpHFaaoCiH2/B7a53CWUm27RXsgBK5AO4r8e/BgWWO1E0zaaB0Y2EofYlmdO612CP3MU7WH5vmNUo8DmtFpAofxMIwFSUFSn0yOk1KN9UO1wgJiRBSc8IVjJ8Tgly6SgpTVW3o4pt+FwoRI2XbT74qoMjbzwmcK45JC29B/tskdwvyS9CxX1mS30U2flPQVyb8ydb+qn0q75xr6wIC27cvrIbBTePdF+E0dWAVcWfOQhg7kjl7dxnPC6XMikb0PlO3gZk0E9ZAWkS4TdYCbmrqXsjO+guW2/yKeRAy/sSW4sSWWh5tgOcX9QTE172GlaLkzj3oMO1lY1ajmKhpnFPOU= ansible@localhost
EOF

### Create a cleanup script.
echo '[INFO] Creating cleanup script ...'
sudo cat <<EOF > /tmp/cleanup.sh
#!/bin/bash
# Cleans all audit logs.
echo '[INFO] Cleaning all audit logs ...'
if [ -f /var/log/audit/audit.log ]; then
cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
cat /dev/null > /var/log/lastlog
fi
# Cleans persistent udev rules.
echo '[INFO] Cleaning persistent udev rules ...'
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
rm /etc/udev/rules.d/70-persistent-net.rules
fi
# Cleans /tmp directories.
echo '[INFO] Cleaning /tmp directories ...'
rm -rf /tmp/*
rm -rf /var/tmp/*
# Cleans SSH keys.
echo '[INFO] Cleaning SSH keys ...'
rm -f /etc/ssh/ssh_host_*
# Sets hostname to localhost.
echo '[INFO] Setting hostname to localhost ...'
cat /dev/null > /etc/hostname
hostnamectl set-hostname localhost
# Cleans apt-get.
echo '[INFO] Cleaning apt-get ...'
apt-get clean
# Cleans the machine-id.
echo '[INFO] Cleaning the machine-id ...'
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
# Clean IP address
echo '[INFO] Cleaning IP address'
sudo rm -rf /etc/netplan/*.yaml
# Cleans shell history.
echo '[INFO] Cleaning shell history ...'
unset HISTFILE
history -cw
echo > ~/.bash_history
rm -fr /root/.bash_history
EOF

### Change script permissions for execution.
echo '[INFO] Changeing script permissions for execution ...'
sudo chmod +x /tmp/cleanup.sh

### Runs the cleauup script.
echo '[INFO] Running the cleanup script ...'
sudo /tmp/cleanup.sh

### Generate host keys using ssh-keygen
echo '[INFO] Generating host keys ...'
sudo ssh-keygen -A

### All done.
echo '[INFO] Done.'  

