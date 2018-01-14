#!/bin/bash

#IFACE=enp0s3

kubectl create namespace spark
kubectl create -f spark-master-pod.yaml
kubectl create -f spark-worker-1-pod.yaml
kubectl create -f mysql-pod.yaml

SPARK_MASTER_IP="<none>"
echo "Waiting for IP address..."
while [ $SPARK_MASTER_IP == "<none>" ]
do
        SPARK_MASTER_IP=`kubectl get pods -n spark -o wide | grep spark-master | awk '{print $6}'`
done
kubectl expose pod spark-master --port=7077,6066 --name=spark-master -n spark
#kubectl expose pod spark-master \
#  --port=8080,4040,6066,18080,8888,10000 \
#  --external-ip=`ifconfig -a | awk -v iface=$IFACE '/$iface/ {getline;print $2}'` \
#  --type=LoadBalancer \
#  --name=spark-master-ui \
#  -n spark
kubectl expose pod spark-master --port=8080,8081,4040,4041,6066,18080,8888,10000 --external-ip=192.168.0.167 --type=LoadBalancer --name=spark-master-ui -n spark
kubectl expose pod spark-worker-1 --port=8881 --type=LoadBalancer --name=spark-worker-1 -n spark
kubectl expose pod mysql --port=3306 --type=LoadBalancer --name=mysql -n spark
kubectl exec spark-master -n spark -it mkdir -p /tmp/spark-events\
kubectl exec spark-master -n spark -it $SPARK_HOME/sbin/start-thriftserver.sh

kubectl get all -o wide -n spark
#kubectl exec spark-worker-1 -n spark -it "echo $SPARK_MASTER_IP spark-master \>\> /etc/hosts"
kubectl run zeppelin --image=apache/zeppelin:0.7.3 --env="master=spark://spark-master:7077" --env="SPARK_HOME=/usr/local/spark-2.2.1-bin-hadoop2.7" -n spark
kubectl expose deployment zeppelin --port=8081 --target-port=8080 --external-ip=192.168.0.167 --name=zeppelin -n spark
