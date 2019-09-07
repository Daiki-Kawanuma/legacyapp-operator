#!/bin/bash

check_crd() {	
	kubectl get crd legacyapp.hirarinslab.com > /dev/null 2>&1
}

create_crd() {	
	kubectl apply -f /tmp/legacyapp-crd.yaml
}

inject_finalizer(){
  local name=$1
  kubectl patch legacyapp $name --type merge -p '{"metadata":{"finalizers": ["finalizer.legacyapp.hirarinslab.com"]}}'
}

ensure_service() {
	local name=$1
	local db_hostname=$2
	local db_port=$3
	local db_dbname=$4
	local db_user=$5
  local db_password=$6

  # finalizer設定
  inject_finalizer $1

  # バッチサーバ起動
  sed s%postgresql://postgres.default.svc.cluster.local:5432/postgres%postgresql://$db_hostname:$db_port/$db_dbname%g /tmp/batch-server-deployment.yaml \
    | sed s%db.user=postgres%db.user=$db_user%g \
    | sed s%db.pass=password%db.pass=$db_password%g \
    | kubectl apply -f -

  # バッチタイマー起動
  kubectl apply -f /tmp/batch-timer-deployment.yaml

  # Web起動
  sed s%username=\"postgres\"%username=\"$db_user\"%g /tmp/web-deployment.yaml \
    | sed s%password=\"password\"%password=\"$db_password\"%g \
    | sed s%url=\"jdbc:postgresql://postgres.default.svc.cluster.local:5432/postgres\"%url=\"jdbc:postgresql://$db_hostname:$db_port/$db_dbname\"%g \
    | kubectl apply -f -
}

delete_service() {
	local name=$1
	local deletionTimestamp=$2

  if [-n deletionTimestamp]; then
      kubectl delete deployment,service web
      kubectl delete deployment batch-timer
      kubectl delete deployment,service batch-server
      kubectl patch legacyapp $name --type merge -p '{"metadata":{"finalizers": [null]}}'
  fi
}

echo "deploy_legacyapp.sh"

while true; do  
  if ! check_crd; then
    echo "Create CRD: LegacyApp";
    create_crd;
    sleep 1;
    continue
  fi

  for i in $(kubectl get legacyapp -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.end}'); do
    ensure_service $(kubectl get legacyapp $i \
      -o jsonpath='{.metadata.name}{"\t"}{.spec.db-hostname}{"\t"}{.spec.db-port}{"\t"}{.spec.db_dbname}{"\t"}{.spec.db-user}{"\t"}{.spec.db-password}{"\t"}');
  done

  for i in $(kubectl get legacyapp -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.end}'); do
    delete_service $(kubectl get legacyapp $i \
      -o jsonpath='{.metadata.name}{"\t"}{.metadata.deletionTimestamp}{"\t"}');
  done

  sleep 5;

done