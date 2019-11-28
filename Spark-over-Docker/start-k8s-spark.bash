#!/bin/bash

IFACE=wlan0
EXTERNAL_IP=`ifconfig $IFACE | grep "inet " | awk '{print $2}'`
GIT_SPARK=Spark/Spark-over-Docker

#curl -L https://github.com/kubernetes/kompose/releases/download/v1.18.0/kompose-linux-amd64 -o kompose
#chmod +x kompose
#sudo mv kompose /usr/local/bin

#Run the first time to generate iniital yaml files
#kompose convert -f docker-compose.yml

# Absolute paths for PVCs
sudo ln -s $PWD/conf /mnt/conf
sudo ln -s $PWD/data /mnt/data

export KUBECONFIG=$HOME/.kube/config
kubectl create namespace spark
kubectl apply -f mysql-pod.yaml -n spark
kubectl expose pod mysql --port=3306 --type=LoadBalancer --name=mysql -n spark
kubectl apply -f spark-master-pv-conf.yaml -n spark
kubectl apply -f spark-master-pv-data.yaml -n spark
kubectl apply -f spark-worker-1-pv-conf.yaml -n spark
kubectl apply -f spark-worker-1-pv-data.yaml -n spark
kubectl apply -f spark-master-claim0-persistentvolumeclaim.yaml -n spark
kubectl apply -f spark-master-claim1-persistentvolumeclaim.yaml -n spark
kubectl apply -f spark-worker-1-claim0-persistentvolumeclaim.yaml -n spark
kubectl apply -f spark-worker-1-claim1-persistentvolumeclaim.yaml -n spark
kubectl apply -f spark-master-deployment.yaml -n spark
kubectl apply -f spark-worker-1-deployment.yaml -n spark

SPARK_MASTER_IP="<none>"
echo "Waiting for IP address..."
while [ $SPARK_MASTER_IP == "<none>" ]
do
        SPARK_MASTER_IP=`kubectl get pods -n spark -o wide | grep spark-master | awk '{print $6}'`
done
#kubectl expose pod spark-master --port=7077,6066 --name=spark-master -n spark
#kubectl expose pod spark-master \
#  --port=8080,8081,4040,4041,6066,18080,8888,10000 \
#  --external-ip=`ifconfig -a | awk -v iface=$IFACE '/$iface/ {getline;print $2}'` \
#  --type=LoadBalancer \
#  --name=spark-master-ui \
#  -n spark
#kubectl exec spark-master -n spark -it $SPARK_HOME/sbin/start-thriftserver.sh
#kubectl apply -f spark-master-service.yaml -n spark
#kubectl apply -f spark-worker-1-service.yaml -n spark
kubectl expose deployment spark-master --port=7077,8080,8081,4040,4041,6066,18080,8888,10000 --type=LoadBalancer --external-ip=$EXTERNAL_IP --name=spark-master -n spark
kubectl expose deployment spark-worker-1 --port=8881 --type=NodePort --name=spark-worker-1 -n spark

kubectl get all -o wide -n spark
#kubectl exec spark-worker-1 -n spark -it "echo $SPARK_MASTER_IP spark-master \>\> /etc/hosts"

# Zeppelin pod
kubectl run --generator=run-pod/v1 zeppelin --image=apache/zeppelin:0.8.0 --env="master=spark://spark-master:7077" --env="SPARK_HOME=/usr/local/spark-2.4.3-bin-hadoop2.7" -n spark
#kubectl expose deployment zeppelin --port=8081 --target-port=8080 --external-ip=<IP> --name=zeppelin -n spark
kubectl expose pod zeppelin --port=8082 --target-port=8080 --type=LoadBalancer --external-ip=$EXTERNAL_IP --name=zeppelin -n spark

# Jupyter notebook pod
kubectl run --generator=run-pod/v1 jupyter --image=spark-2:2.4.4 -n spark -- pyspark --master local[2]
kubectl expose pod jupyter --port=8888 --target-port=8888 --type=LoadBalancer --external-ip=$EXTERNAL_IP --name=jupyter -n spark
