resource "shoreline_notebook" "inadequate_replication_on_cassandra_cluster" {
  name       = "inadequate_replication_on_cassandra_cluster"
  data       = file("${path.module}/data/inadequate_replication_on_cassandra_cluster.json")
  depends_on = [shoreline_action.invoke_change_replication]
}

resource "shoreline_file" "change_replication" {
  name             = "change_replication"
  input_file       = "${path.module}/data/change_replication.sh"
  md5              = filemd5("${path.module}/data/change_replication.sh")
  description      = "Increase the replication factor: Increase the number of replicas for each data center in the Cassandra cluster. This ensures that multiple copies of the data are stored across different nodes, which reduces the risk of data loss if a node fails."
  destination_path = "/agent/scripts/change_replication.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_change_replication" {
  name        = "invoke_change_replication"
  description = "Increase the replication factor: Increase the number of replicas for each data center in the Cassandra cluster. This ensures that multiple copies of the data are stored across different nodes, which reduces the risk of data loss if a node fails."
  command     = "`chmod +x /agent/scripts/change_replication.sh && /agent/scripts/change_replication.sh`"
  params      = ["CASSANDRA_HOST","CASSANDRA_USERNAME","CASSANDRA_PASSWORD","TABLE_NAME","KEYSPACE_NAME","DESIRED_REPLICATION_FACTOR"]
  file_deps   = ["change_replication"]
  enabled     = true
  depends_on  = [shoreline_file.change_replication]
}

