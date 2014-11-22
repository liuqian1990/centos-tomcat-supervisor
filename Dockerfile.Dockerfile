FROM centos:centos6
MAINTAINER  aaron "aaron.docker@gmail.com"


#install java
RUN yum update -y && yum -y install java-1.6.0-openjdk
#Install supervisor
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y update  && yum -y install python-pip && /usr/bin/pip install supervisor
RUN mkdir -p /etc/supervisor/conf.d && mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf
VOLUME /var/log/supervisor

#install sshd 
RUN yum install -y openssh-server && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config


RUN echo "root:comall2014" | chpasswd && echo "root   ALL=(ALL)       ALL" >> /etc/sudoers
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN mkdir /var/run/sshd

#install tomcat
RUN java -version && yum -y install wget && yum -y install tar
RUN cd /tmp && wget http://www.us.apache.org/dist/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz && cd /tmp && tar xzf apache-tomcat-7.0.57.tar.gz &&  mv apache-tomcat-7.0.57 /usr/local/tomcat && mkdir /deploy && chmod +x /usr/local/tomcat/bin/*

ADD ./server.xml /usr/local/tomcat/conf/
ENV CATALINA_HOME /usr/local/tomcat

EXPOSE 22 8080
CMD ["/usr/bin/supervisord"]
