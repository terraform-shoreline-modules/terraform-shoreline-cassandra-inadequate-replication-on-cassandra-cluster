
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Inadequate Replication on Cassandra Cluster
---

Inadequate replication refers to a situation where there is an insufficient replication factor or replication strategy implemented on a distributed system like a Cassandra cluster. This can result in data loss if one or more nodes fail. Without adequate replication, the data stored on the failed nodes cannot be retrieved, leading to a substantial data loss. This incident requires immediate attention to ensure that the replication factor and strategy are optimized to prevent data loss in the future.

### Parameters
```shell
export NODE_IP="PLACEHOLDER"

export DATA_CENTER="PLACEHOLDER"

export CASSANDRA_PASSWORD="PLACEHOLDER"

export KEYSPACE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export DESIRED_REPLICATION_FACTOR="PLACEHOLDER"

export CASSANDRA_USERNAME="PLACEHOLDER"

export CASSANDRA_HOST="PLACEHOLDER"
```

## Debug

### Check the number of nodes in the Cassandra cluster
```shell
nodetool status
```

### Check the replication factor of the affected keyspace
```shell
nodetool getendpoints ${KEYSPACE_NAME} ${KEY}
```

### Check the replication strategy of the affected keyspace
```shell
nodetool describecluster | grep ${KEYSPACE_NAME}
```

### Check the logs for any warnings or errors related to inadequate replication
```shell
grep -i "inadequate replication" /var/log/cassandra/system.log
```

### Check the status of the affected node(s)
```shell
nodetool status ${NODE_IP}
```

### Check the status of the affected data center(s)
```shell
nodetool status --dc ${DATA_CENTER}
```

### Check the health of the Cassandra cluster
```shell
nodetool health
```

### Check the consistency level of the affected queries
```shell
grep -r "consistency" /etc/cassandra/
```

### Check the cluster and node configuration files for any replication-related issues
```shell
grep -r "replication" /etc/cassandra/
```

## Repair

### Increase the replication factor: Increase the number of replicas for each data center in the Cassandra cluster. This ensures that multiple copies of the data are stored across different nodes, which reduces the risk of data loss if a node fails.
```shell


#!/bin/bash



# Set the replication factor

REPLICATION_FACTOR=${DESIRED_REPLICATION_FACTOR}



# Set the keyspace and table names

KEYSPACE=${KEYSPACE_NAME}

TABLE=${TABLE_NAME}



# Connect to the Cassandra cluster

cqlsh ${CASSANDRA_HOST} -u ${CASSANDRA_USERNAME} -p ${CASSANDRA_PASSWORD}



# Alter the keyspace with the new replication factor

ALTER KEYSPACE $KEYSPACE_NAME WITH replication = {'class': 'SimpleStrategy', 'replication_factor': $REPLICATION_FACTOR};



# Alter the table with the new replication factor

ALTER TABLE $KEYSPACE_NAME.$TABLE WITH replication = {'class': 'SimpleStrategy', 'replication_factor': $REPLICATION_FACTOR};



# Exit cqlsh

exit


```