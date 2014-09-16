#!/bin/bash

set -e
set -x

./packer/ansible/install-ansible.sh

# ---------------
# Ansible
# ---------------

ansible-playbook playbooks/asgard-ubuntu.yml  -c local -e "asgard_start_service=false AWS_ACCOUNT_ID=N AWS_ACCESS_KEY_ID=N AWS_SECRET_ACCESS_KEY=N"
ansible-playbook playbooks/jenkins-ubuntu.yml -c local -e "jenkins_start_service=false"
# ansible-playbook playbooks/mysql-ubuntu.yml   -c local -e "mysql_start_service=false"
ansible-playbook playbooks/packer-ubuntu.yml  -c local

# ---------------
# Docker
# ---------------

for box in ansible:1.7.1 jenkins packer; do
  local name=$(echo $box | sed -r 's/:.+//')
  cp "docker/$name/Dockerfile" .
  docker build --rm --no-cache -t "evgenyg/$box" .
done
