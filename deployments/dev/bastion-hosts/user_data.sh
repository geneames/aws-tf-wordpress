#!/usr/bin/env bash

yum -y update --security

# Generate system banner
figlet "${welcome_message}" > /etc/motd

# Setup local vanity hostname
echo '${hostname}' | sed 's/\.$//' > /etc/hostname
hostname `cat /etc/hostname`

##
## Setup SSH Config
##
if [[ -f /home/${ssh_user}/.ssh/config ]]; then
  chmod 600 /home/${ssh_user}/.ssh/config
fi

cat <<"__EOF__" > /home/${ssh_user}/.ssh/config
Host *
    StrictHostKeyChecking=no
    UserKnownHostsFile=/dev/null
__EOF__
chmod 400 /home/${ssh_user}/.ssh/config
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/config

