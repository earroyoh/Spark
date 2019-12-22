#!/bin/sh
kubectl delete svc,deployments,pods,pvc,pv --all -n spark
