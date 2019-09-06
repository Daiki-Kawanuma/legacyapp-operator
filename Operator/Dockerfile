FROM centos:7

# kubectl のインストール
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# psql のインストール
RUN yum install -y postgresql

# CRD のコピー
COPY legacyapp-crd.yaml /tmp

# Deployment のコピー
COPY batch-server-deployment.yaml /tmp
COPY batch-timer-deployment.yaml /tmp
COPY web-deployment.yaml /tmp

# Shell のコピー
COPY ./startup.sh /tmp
RUN chmod 755 /tmp/startup.sh
COPY ./deploy_legacyapp.sh /tmp
RUN chmod 755 /tmp/deploy_legacyapp.sh
COPY ./release_passwordlock.sh /tmp
RUN chmod 755 /tmp/release_passwordlock.sh
COPY ./release_passwordlock.sql /tmp
RUN chmod 755 /tmp/release_passwordlock.sql

# 実行
CMD /tmp/startup.sh