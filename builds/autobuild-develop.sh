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

# Change directory :
mkdir ~/Cyphor
cd ~/Cyphor

### Pull the git repos ###
# Cyphor-Server
git clone https://angus-mclean:$gitpassword@github.com/Angus-McLean/Cyphor-Server.git
# Cyphor-Website
git clone https://angus-mclean:$gitpassword@github.com/Angus-McLean/Cyphor-Website.git


### Build the images ###
docker build -f Cyphor-Server/Dockerfile --build-arg DB_URI=mongodb://$(docker-machine ip):27017 Cyphor-Server
docker build -f Cyphor-Website/Dockerfile -t Cyphor-Website


### Start and link the docker containers ###
# Start mongodb --expose=27017 -p 27017:27017
docker run --name mongodb --expose=27017 -p 27017:27017 -d mongo mongod

# Start Cyphor-Server
cd ~/Cyphor/Cyphor-Server && npm install
docker run --expose=3001 -p 3001:3001 -d -v ~/Cyphor/Cyphor-Server:/www/Cyphor-Server Cyphor-Server

# Start Cyphor-Website
cd ~/Cyphor/Cyphor-Website && npm install
docker run --expose=80 -p 80:80 -d -v ~/Cyphor/Cyphor-Website:/www/Cyphor-Website Cyphor-Website


### Run any commands in each container (environment variables etc)

# DB_URI="mongodb://192.168.99.100:27017/test" node server.js
