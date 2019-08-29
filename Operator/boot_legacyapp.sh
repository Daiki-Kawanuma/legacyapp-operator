#!/bin/bash
kubectl apply -f /tmp/batch-server-deployment.yaml
#kubectl apply -f /tmp/batch-timer-deployment.yaml
#kubectl apply -f /tmp/web-deployment.yaml
while true; do
  date;
  sleep 1;
  echo ""
done