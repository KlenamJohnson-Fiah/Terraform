#!/bin/bash

echo "Configuring ansible"
#
#
echo "update yum"
sudo yum -y update
#
#
#
echo "installing epel-release package"
sudo amazon-linux-extras install epel -y
#
#
echo "enable EPEL"
sudo yum-config-manager --enable epel -y
#
#
echo "install ansible"
sudo amazon-linux-extras install ansible2 -y
#
#
echo "Ansible version"
ansible --version

echo "SHUTTING DOWN ANSIBLE!"
sudo shutdown -r now
