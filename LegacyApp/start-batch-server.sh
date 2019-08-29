#!/bin/bash
rmiregistry &
sleep 3

java -cp /opt/apache-tomcat-6.0.53/webapps/legacy-app/WEB-INF/classes/:/opt/apache-tomcat-6.0.53/webapps/legacy-app/WEB-INF/batch/:/opt/apache-tomcat-6.0.53/webapps/legacy-app/WEB-INF/lib/log4j-1.2.17.jar:/opt/apache-tomcat-6.0.53/lib/postgresql-8.1-415.jdbc3.jar -Djava.rmi.server.codebase=file:///opt/apache-tomcat-6.0.53/webapps/legacy-app/WEB-INF/classes/ labo.hirarins.legacy.app.batch.Server

