#!/bin/bash -xe
yum update -y
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_dns_name}:/ /var/www/html
chown -R apache:apache /var/www/html
