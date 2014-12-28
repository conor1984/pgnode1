#Master Node1 

FROM ubuntu:14.04
#MAINTAINER conor.nagle@firmex.com

#Environment 
ENV PATH 		/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin:/usr/bin/pgbench
ENV PGDATA		/var/lib/postgresql/9.4/main
ENV PGCONFIG	/etc/postgresql/9.4/main
ENV PGBOUNCE    /etc/pgbouncer
ENV PGLOG		/var/log/postgresql
ENV PGREP		/etc/postgresql/9.4/repmgr
ENV PGHOME		/var/lib/postgresql
ENV PSQL        psql --command 

USER root

RUN 	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&\
	echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN sudo apt-get update &&\
    sudo apt-get upgrade &&\
    sudo apt-get install -y python-software-properties software-properties-common postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 \
	 libxslt-dev libxml2-dev libpam-dev libedit-dev git expect wget \
	 pgbouncer repmgr #pgbench pgadmin zabbix-server-pgsql zabbix-frontend-php
	
RUN sudo adduser maximus --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password &&\
	echo "maximus:max" | sudo chpasswd &&\
	sudo usermod -d /var/lib/postgresql maximus
