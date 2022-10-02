#!/bin/bash

down="$1"
up="$2"

#KUBECONFIG="/vagrant/configs/config"

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e 's/mode: ""/mode: "ipvs"/' | \
kubectl apply -f - -n kube-system

kubectl apply -f metallb-native.yaml

sleep 2

envsubst < metallb-template.yaml | kubectl apply -f -
sleep 2

envsubst < ingress-controller.yaml | kubectl apply -f -