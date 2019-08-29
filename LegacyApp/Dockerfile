FROM satoshi55d/legacy-tomcat:1.0.0
RUN mkdir -p /opt/apache-tomcat-6.0.53/webapps/legacy-app
COPY legacy-app.war /opt/apache-tomcat-6.0.53/webapps/legacy-app/
COPY start-batch-server.sh start-batch-timer.sh start-web.sh /
WORKDIR /opt/apache-tomcat-6.0.53/webapps/legacy-app
RUN jar -xvf legacy-app.war

