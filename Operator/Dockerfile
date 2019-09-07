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
COPY ./legacyapp_operator.sh /tmp
RUN chmod 755 /tmp/legacyapp_operator.sh

# 実行
CMD /tmp/legacyapp_operator.sh