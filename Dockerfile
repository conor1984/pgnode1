#Master Node1 

FROM ubuntu:14.04
#MAINTAINER conor.nagle@firmex.com

#Environment 
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin:/usr/bin/pgbench
ENV PGDATA=/var/lib/postgresql/9.4/main
ENV PGCONFIG=/etc/postgresql/9.4/main
ENV PGBOUNCE=/etc/pgbouncer
ENV PGLOG=/var/log/postgresql
ENV PGREP=/etc/postgresql/9.4/repmgr
ENV PGHOME=/var/lib/postgresql

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

#Postgresql 9.4
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

#Zabbix
#RUN wget http://repo.zabbix.com/zabbix/2.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.2-1+trusty_all.deb
#RUN sudo dpkg -i zabbix-release_2.2-1+trusty_all.deb

#Variables
#PSQL="psql --command "
USER root

RUN sudo apt-get update &&\
	sudo apt-get upgrade &&\
	sudo apt-get install -y python-software-properties

ADD postgresql.conf /etc/postgresql/9.4/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
ADD pgbouncer.ini $PGBOUNCE/pgbouncer.ini
ADD repmgr.conf $PGREP/repmgr.conf
ADD userlist.txt $PGBOUNCE/userlist.txt
ADD failover.sh $PGHOME/scripts/failover.sh
#ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432 6432
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
