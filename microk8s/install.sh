#!/usr/bin/env bash

VBOX_NAT=10.0.2.15
CONTROL_IP=192.168.1.190

vagrant up

sed -i "s/${VBOX_NAT}/${CONTROL_IP}/" config

echo "Bootstraping ArgoCD"

until kubectl apply -k ../argocd/bootstrap; do sleep 3; done
