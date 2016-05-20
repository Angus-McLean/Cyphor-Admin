## Install docker etc

# Create Cyphor Directory
mkdir ~/Cyphor
cd ~/Cyphor

# git clone latest into mounted directory with docker-machine
git clone https://github.com/Angus-McLean/Cyphor-Server.git
git clone https://github.com/Angus-McLean/Cyphor-Admin.git
git clone https://github.com/Angus-McLean/Cyphor-Website.git

# Build Docker images
docker-compose -f Cyphor-Admin/builds/docker-compose.yml build

# Start containers
docker-compose -f Cyphor-Admin/builds/docker-compose.yml up
