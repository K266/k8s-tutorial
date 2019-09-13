#!/bin/bash

docker build -t kitkatlite/multi-client:latest -t kitkatlite/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t kitkatlite/multi-server:latest -t kitkatlite/multi-worker:$SHA -f ./server/Dockerfile ./server
docker build -t kitkatlite/multi-worker:latest -t kitkatlite/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push kitkatlite/multi-client:latest
docker push kitkatlite/multi-server:latest
docker push kitkatlite/multi-worker:latest

docker push kitkatlite/multi-client:$SHA
docker push kitkatlite/multi-server:$SHA
docker push kitkatlite/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=kitkatlite/multi-server:$SHA
kubectl set image deployments/client-deployment client=kitkatlite/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=kitkatlite/multi-worker:$SHA
# kubectl rollout restart deployment/server-deployment
# kubectl rollout restart deployment/client-deployment
# kubectl rollout restart deployment/worker-deployment