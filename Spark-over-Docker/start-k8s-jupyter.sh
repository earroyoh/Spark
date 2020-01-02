#!/bin/sh
IFACE=wlan0
EXTERNAL_IP=`ifconfig $IFACE | grep "inet " | awk '{print $2}'`
#CoreDNS to accept connections
sudo iptables -w -P FORWARD ACCEPT

kubectl create namespace spark
kubectl create serviceaccount default -n spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=spark:default --namespace=spark
kubectl apply -f spark-k8s-jupyter-deployment.yaml -n spark
kubectl expose deployment spark-jupyter --port=8888 --type=LoadBalancer --external-ip=$EXTERNAL_IP --name=spark-jupyter -n spark
