############ Install Docker ######################################################
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo usermod -aG docker $USER
############## Docker Swarm #####################################################

sudo docker swarm init

# create overlay network

sudo docker network create -d overlay swarm-net --attachable

sudo docker build --tag proxy-reverse/nginx ./nginx/

#Backend:

sudo docker build --tag backend/app-node ./backend/app-node/

# map app-node service to overlay network
sudo docker service create --name backend-app-node-swarm --replicas 2 --network swarm-net backend/app-node

#Frontend: 

#sudo docker build --tag frontend/app-node ./frontend/app-node/

# map app-node service to overlay network
#sudo docker service create --name frontend-app-node-swarm --replicas 2 --network swarm-net frontend/app-node

# map nginx service to overlay network and expose ports 80 and 443
#sudo docker service create --name nginx-swarm --replicas 1 -p 80:80 -p 443:443 --network swarm-net proxy-reverse/nginx

sudo docker service ls


