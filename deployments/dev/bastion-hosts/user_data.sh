#!/usr/bin/env bash

# Generate system banner
figlet "Sema  Bastion" > /etc/motd

# Setup DNS Search domains
echo 'search ${search_domains}' > '/etc/resolvconf/resolv.conf.d/base'
resolvconf -u

# Setup local vanity hostname
echo 'bastion-host' | sed 's/\.$//' > /etc/hostname
hostname `cat /etc/hostname`

##
## Setup SSH Config
##
cat <<"__EOF__" > /home/ec2-user/.ssh/config
Host *
    StrictHostKeyChecking no
__EOF__
chmod 600 /home/ec2-user/.ssh/config
chown ec2-user:ec2-user /home/ec2-user/.ssh/config

# Setup default `make` support
echo 'alias make="make -C /usr/local/include --no-print-directory"' >> /etc/skel/.bash_aliases
cp /etc/skel/.bash_aliases /root/.bash_aliases
cp /etc/skel/.bash_aliases /home/ec2-user/.bash_aliases

echo 'default:: help' > /usr/local/include/Makefile
echo '-include Makefile.*' >> /usr/local/include/Makefile
