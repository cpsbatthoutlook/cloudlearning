#  How to install Docker in Ubuntu

## https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04

sudo apt install -y git tmux
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



docker pull gcr.io/google.com/cloudsdktool/google-cloud-cli:latest
mkdir ~/git
cd ~/git
cat > .env.sh << EOF
echo apt install -y vim
alias gc=gcloud
alias gcs='gcloud storage '
alias gcc='gcloud compute '
alias gcci='gcloud compute instances '
alias gciam='gcloud iam '
alias gciamr='gcloud iam roles '
alias gciamsa='gcloud iam service-accounts '

export PR=\$(gcloud config get-value project)
EOF

cd ~/git && sudo docker run -it --rm --name gcloud -v `pwd`:/git:z  gcr.io/google.com/cloudsdktool/google-cloud-cli:latest bash


