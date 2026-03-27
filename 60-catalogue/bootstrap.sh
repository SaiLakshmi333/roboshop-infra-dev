#!/bin/bash

component=$1
environment=$2
dnf install ansible -y

cd /home/ec2-user
git clone https://github.com/SaiLakshmi333/roboshop-ansible-roles-tf.git

cd roboshop-ansible-roles-tf
git pull
ansible-playbook -e component=$component -e env=$environment roboshop.yaml