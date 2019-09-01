FROM centos:7

# kubectl のインストール
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
#RUN kubectl version

# CRD のコピー
COPY legacyapp-crd.yaml /tmp

# Deployment のコピー
COPY batch-server-deployment.yaml /tmp
COPY batch-timer-deployment.yaml /tmp
COPY web-deployment.yaml /tmp

# Shell のコピー
COPY ./boot_legacyapp.sh /tmp
RUN chmod 755 /tmp/boot_legacyapp.sh

# 実行
CMD /tmp/boot_legacyapp.sh