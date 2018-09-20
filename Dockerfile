FROM centos7-systemd:latest
MAINTAINER jaynpham

#Environment variables
ENV rabbitBinary=rabbitmq-server-3.7.7-1.el7.noarch.rpm 
ENV rabbitUrl=dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.7
ENV erlangBinary=erlang-solutions-1.0-1.noarch.rpm
ENV erlangUrl=packages.erlang-solutions.com

WORKDIR /tmp
#Create local user and group for rabbitmq
RUN useradd -u 1000 rabbitmq

#Create/install all pre-requisites
RUN yum update -y
RUN yum -y install epel-release socat make less nano && yum -y install pwgen wget logrotate && yum -y install nss_wrapper gettext && yum clean all
RUN chown -R rabbitmq:rabbitmq /home/rabbitmq && chmod -R 700 /home/rabbitmq

#Install Erlang Solutions
RUN curl -LOk https://${erlangUrl}/${erlangBinary}
RUN rpm -Uvh ${erlangBinary}
RUN yum install -y erlang

#Install RabbitMQ 3.7.7
RUN curl -LOk https://${rabbitUrl}/${rabbitBinary}
RUN rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
RUN rpm -iUvh rabbitmq-server-3.7.7-1.el7.noarch.rpm 

#Enable RabbitMQ Management Console
RUN /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

#Install OpenSSL
RUN yum install libtool perl-core zlib-devel -y
RUN curl -LOk https://github.com/openssl/openssl/archive/OpenSSL_1_1_0g.tar.gz
RUN tar -zxvf OpenSSL_1_1_0g.tar.gz 
RUN cd openssl-OpenSSL_1_1_0g && ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib && make

