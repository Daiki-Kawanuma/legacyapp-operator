FROM centos:5.11
ADD jdk1.5.0_22.tar.gz /usr/
ADD apache-tomcat-6.0.53.tar.gz /opt/
COPY postgresql-8.1-415.jdbc3.jar /opt/apache-tomcat-6.0.53/lib/
ENV JAVA_HOME=/usr/jdk1.5.0_22 PATH=$PATH:/usr/jdk1.5.0_22/bin CATALINA_HOME=/opt/apache-tomcat-6.0.53 LANG=ja_JP.UTF-8
COPY context.xml /opt/apache-tomcat-6.0.53/conf/
