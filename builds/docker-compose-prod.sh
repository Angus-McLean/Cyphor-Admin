# Automated build shell script

### Prompt for variables ###
# Git password
echo -n Git Password :
read -s gitpassword
echo


### Install docker ###
# Prerequisites :
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo bash -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update -y
sudo apt-get purge lxc-docker
apt-cache policy docker-engine

# Install
sudo apt-get update -y
sudo apt-get install -y docker-engine
sudo service docker start

# Add user to docker group and reload permissions
sudo usermod -aG docker $(whoami)
. ~/.profile
## may need to manually log out and log back in if you can't connect to docker daemon

# Install docker compose
sudo /bin/bash -c "curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo /bin/bash -c "chmod +x /usr/local/bin/docker-compose"

# Change directory :
mkdir ~/Cyphor
cd ~/Cyphor

### Pull the git repos ###
# Cyphor-Admin
git clone https://angus-mclean:$gitpassword@github.com/Angus-McLean/Cyphor-Admin.git
# Cyphor-Server
git clone https://angus-mclean:$gitpassword@github.com/Angus-McLean/Cyphor-Server.git
# Cyphor-Website
git clone https://angus-mclean:$gitpassword@github.com/Angus-McLean/Cyphor-Website.git

# Install bower_components and node_modules
cd Cyphor-Website && bower install && cd ..
cd Cyphor-Server && sudo npm install && cd ..

# Build Docker images
docker-compose -f Cyphor-Admin/builds/docker-compose.yml build

# Start containers
docker-compose -f Cyphor-Admin/builds/docker-compose.yml up
