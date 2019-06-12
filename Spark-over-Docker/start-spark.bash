#!/bin/bash

#IFACE=enp0s3

curl -L https://github.com/kubernetes/kompose/releases/download/v1.17.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv kompose /usr/local/bin

kompose convert -f docker-compose.yml
kubectl create namespace spark
kubectl apply -f spark-master-deployment.yaml -n spark
kubectl apply -f spark-master-claim0-persistentvolumeclaim.yaml -n spark
kubectl apply -f spark-master-claim1-persistentvolumeclaim.yaml -n spark
kubectl apply -f spark-worker-1-deployment.yaml -n spark
kubectl apply -f spark-worker-1-claim0-persistentvolumeclaim.yaml -n spark
kubectl apply -f spark-worker-1-claim1-persistentvolumeclaim.yaml -n spark
kubectl apply -f mysql-pod.yaml -n spark

SPARK_MASTER_IP="<none>"
echo "Waiting for IP address..."
while [ $SPARK_MASTER_IP == "<none>" ]
do
        SPARK_MASTER_IP=`kubectl get pods -n spark -o wide | grep spark-master | awk '{print $6}'`
done
kubectl expose pod spark-master --port=7077,6066 --name=spark-master -n spark
#kubectl expose pod spark-master \
#  --port=8080,8081,4040,4041,6066,18080,8888,10000 \
#  --external-ip=`ifconfig -a | awk -v iface=$IFACE '/$iface/ {getline;print $2}'` \
#  --type=LoadBalancer \
#  --name=spark-master-ui \
#  -n spark
kubectl expose pod spark-master --port=8080,8081,4040,4041,6066,18080,8888,10000 --external-ip=192.168.0.167 --type=LoadBalancer --name=spark-master-ui -n spark
kubectl expose pod spark-worker-1 --port=8881 --type=LoadBalancer --name=spark-worker-1 -n spark
kubectl expose pod mysql --port=3306 --type=LoadBalancer --name=mysql -n spark
#kubectl exec spark-master -n spark -it mkdir -p /tmp/spark-events\
#kubectl exec spark-master -n spark -it $SPARK_HOME/sbin/start-thriftserver.sh

kubectl get all -o wide -n spark
#kubectl exec spark-worker-1 -n spark -it "echo $SPARK_MASTER_IP spark-master \>\> /etc/hosts"
kubectl run --generator=run-pod/v1 zeppelin --image=apache/zeppelin:0.8.0 --env="master=spark://spark-master:7077" --env="SPARK_HOME=/usr/local/spark-2.4.3-bin-hadoop2.7" -n spark
kubectl expose deployment zeppelin --port=8081 --target-port=8080 --external-ip=192.168.0.167 --name=zeppelin -n spark
