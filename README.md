Postgreは以下のように簡易的に立ち上げ
```
kubectl run postgres --image=satoshi55d/postgres:1.0.0
kubectl expose deployment postgres --port=5432 --target-port=5432
```