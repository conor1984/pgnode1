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

USER root

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN sudo adduser maximus --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password #&&\
#	echo "maximus:max" | sudo chpasswd &&\
#	sudo usermod -d /var/lib/postgresql maximus &&\
#	ssh-keygen -t rsa -f $PGHOME/.ssh/id_rsa -q -N ""
	

#Variables
PSQL="psql --command "
