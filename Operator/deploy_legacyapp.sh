#!/bin/bash

check_crd() {	
	kubectl get crd legacyapp.hirarinslab.com > /dev/null 2>&1
}

create_crd() {	
	kubectl apply -f /tmp/legacyapp-crd.yaml
}

ensure_service() {
	local name=$1
	local db_hostname=$2
	local db_port=$3
	local db_dbname=$4
	local db_user=$5
  local db_password=$6

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

  sleep 5;

done