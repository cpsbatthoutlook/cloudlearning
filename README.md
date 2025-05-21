# cloudlearning
#### TMUX
set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix

#### CentOS
sudo yum remove -y docker \
              docker-client \
              docker-client-latest \
              docker-common \
              docker-latest \
              docker-latest-engine \
              docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 tmux sqlite3
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-stable
yum list docker-ce --showduplicates | sort -r
#sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
sudo yum install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

#### Ubuntu

apt -y update
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release curl tmux  sqlite3
sudo mkdir -p /etc/apt/keyrings	
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt -y update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world
sudo systemctl enable docker.service
sudo systemctl start docker.service
echo curl -fsSL https://get.docker.com | sudo bash

