### Docker Environment for a MongoDB Replica Set

### Why is this Useful?

Even though most deployments nowadays run in the cloud, in services such as [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) and it is highly unlikely that you need to manage this yourself in 2021,  Replica sets are the default configuration for most production MongoDB deployments. This configuration enables high availability and ensures safe failover of the database, by running a 3-node redudancy system. This also enables newer MongoDB features, such as transactions and change streams, and connecting Apache Spark (big data processing) and Apache Kafka (event queue). Running a replicaset locally enables more features in development and is usually a good way to increase dev-prod parity.


### How do I run it?

Note: These instructions assume a working installation of [Docker Compose](https://docs.docker.com/compose/install/) and an available bash interpreter.

This is a standard 3-node replicaset deployed locally by a docker-compose file. 

Clone this repository:
```bash
  git clone https://github.com/deistermatheus/mongo-replicaset-deployment
```

 To setup the environment, run from project root:
```bash
  setup.sh main
```

To remove everything but your data volumes:
```bash
  setup.sh tearDown
```
To shell into the primary and run db commands:
```bash
  setup.sh mongoShell
```

### This is too complex for my use case. Do I really need three containers?

If your requirements are simpler, then use a [standalone config](https://docs.mongodb.com/manual/tutorial/convert-standalone-to-replica-set/). The three-node setup is required for simulating some production scenarios, such as one of the nodes becoming unresponsive and requiring another node to become the primary database. For other features, a standalone will be enough.

### How Does It Work?

Refer to the Official MongoDB Docs on [replication](https://docs.mongodb.com/manual/replication/). 
