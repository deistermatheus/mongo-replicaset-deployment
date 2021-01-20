#!/bin/bash
set -e

function main(){
    checkForLocalMongo 
    startReplicaSet
}

function checkForLocalMongo(){
    echo "Checking for port availaibility. You may need to disable locally running mongodb instances or containers that expose tcp/27017"
    if lsof -Pi :27017 -sTCP:LISTEN -t >/dev/null ; then
    echo "Local mongodb instance detected."
    read -p "Should the script stop it? Y/n" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
     then
        sudo service stop mongod
    fi
    exit 1
fi
}

function startReplicaSet(){
    echo "Starting docker ."
    docker-compose up -d --build
    echo -e "\nConfiguring the MongoDB ReplicaSet.\n"
    docker-compose exec mongodb-1 mongo --eval '''if (rs.status()["ok"] == 0) {
    rsconf = {
      _id : "rs0",
      members: [
        { _id : 0, host : "mongodb-1:27017", priority: 1.0 },
        { _id : 1, host : "mongodb-2:27017", priority: 0.5 },
        { _id : 2, host : "mongodb-3:27017", priority: 0.5 }
      ]
    };
    rs.initiate(rsconf);
}
rs.conf();
'''
}


function tearDown(){
    echo "Tearing down the docker environment for the mongodb replicaset..."
    docker-compose down -v
}

function mongoShell(){
    docker exec -it mongodb-1 mongo
}

eval "$@"