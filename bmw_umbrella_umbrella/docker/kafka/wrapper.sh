#!/bin/bash


t1="connect-dev"
# kafka-topics --create --topic dev-cloud --partitions 1 --replication-factor 1 --if-not-exists --zookeeper localhost:32181
echo "$0: running $t1" &&
until kafka-topics --create --topic "$t1" --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181; do 
                >&2 echo "Unavailable: sleeping"; 
                sleep 10; 
done &
echo

t2="connect-legacy-dev"
# kafka-topics --create --topic dev-cloud --partitions 1 --replication-factor 1 --if-not-exists --zookeeper localhost:32181
echo "$0: running $t2" &&
until kafka-topics --create --topic "$t2" --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:32181; do 
                >&2 echo "Unavailable: sleeping"; 
                sleep 10; 
done &
echo


exec /etc/confluent/docker/run "$@"