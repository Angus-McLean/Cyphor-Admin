## Install docker etc

mkdir ~/Cyphor
cd ~/Cyphor

# git clone latest into mounted directory with docker-machine


# cd into folders and build images
cd ~/Cyphor/Cyphor-Server && docker build -t anguscyphor/server .
cd ~/Cyphor/Cyphor-Website && docker build -t anguscyphor/nginx .

# Start mongodb container
docker run --name mongodb --expose=27017 -p 27017:27017 -d mongo mongod
docker run -d --name nginx -p 80:80 --link server:server angus/nginx

# Start the server container from anguscypho/test image
docker run -d --name server -p 3001 --link mongodb:mongodb -e DB_URI=mongodb://$(docker-machine ip):27017\
 -e NODE_ENV=development anguscyphor/test
