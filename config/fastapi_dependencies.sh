#!/bin/bash
#
#
echo "Docker installation"
#
#
echo "update yum"
sudo yum update -y
#
echo "installing Docker from amazon-linux-extra"
sudo amazon-linux-extras install docker -y
#
#
echo "start Docker service"
sudo service docker start
#
#
echo "Adding ec2-user to the docker group"
sudo usermod -a -G docker ec2-user
#
#
echo "DOCKER INSTALL FINISHED this is the docker infor to confirm"
docker --version

echo "SHUTTING DOWN!"
sudo shutdown -r now