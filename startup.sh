#!/bin/bash
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root

if [ ! -f /root/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
  cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
fi

echo "Starting SSH..."
service ssh start

echo "Formatting HDFS if not already done..."
if [ ! -d "/tmp/hadoop-root" ]; then
  $HADOOP_HOME/bin/hdfs namenode -format
fi

echo "Starting Hadoop..."
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

echo "Starting Spark..."
$SPARK_HOME/sbin/start-master.sh
sleep 5
$SPARK_HOME/sbin/start-worker.sh spark://localhost:7077

echo "All services started. Container is ready."

# Keep container alive
tail -f /dev/null
