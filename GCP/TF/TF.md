# https://github.com/GoogleCloudPlatform/terraform-google-examples

## https://developer.hashicorp.com/terraform

## Google  https://registry.terraform.io/providers/hashicorp/google/latest

## Installation on Ubuntu
### https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

apt-get update && apt-get install -y gnupg software-properties-common gpg wget  jq vim
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint


echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

apt -y update
apt-get install -y terraform


## Tips
*  tf taint resource # to recreate, followed by tf apply
