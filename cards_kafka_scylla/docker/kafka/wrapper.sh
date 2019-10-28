#!/bin/bash


## now loop through the above array
for i in $(echo $KAFKA_TOPICS | tr ',' ' ')
do
   echo "$0: running $i" &&
  until kafka-topics --create --topic "$i" --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181; do 
                  >&2 echo "Unavailable: sleeping"; 
                  sleep 10; 
  done &
  echo
done &
echo

exec /etc/confluent/docker/run "$@"