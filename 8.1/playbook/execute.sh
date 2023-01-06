#!/bin/bash
docker run -dit --name centos7 pycontribs/centos:7
docker run -dit --name ubuntu pycontribs/ubuntu
docker run -dit --name fedora pycontribs/fedora

ansible-playbook --vault-password-file=vault_password.sh -i inventory/prod.yml site.yml

docker rm centos7 --force
docker rm ubuntu --force
docker rm fedora --force