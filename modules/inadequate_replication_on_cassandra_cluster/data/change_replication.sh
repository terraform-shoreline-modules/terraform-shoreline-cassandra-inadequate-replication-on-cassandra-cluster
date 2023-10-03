

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