#!/bin/bash

release_passwordlock() {	
	local db_hostname=$1
	local db_port=$2
	local db_dbname=$3
	local db_user=$4
  local db_password=$5

  # パスワードロック解除
  export PGPASSWORD=$db_password
  psql -h $db_hostname -p $db_port -d $db_dbname -U $db_user < "/tmp/release_passwordlock.sql"
}

echo "release_passwordlock.sh"

while true; do  

  for i in $(kubectl get legacyapp -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.end}'); do
    release_passwordlock $(kubectl get legacyapp $i \
      -o jsonpath='{.spec.db-hostname}{"\t"}{.spec.db-port}{"\t"}{.spec.db-dbname}{"\t"}{.spec.db-user}{"\t"}{.spec.db-password}{"\t"}');
  done

  sleep 30;

done