#Master Node1 

FROM ubuntu:14.04
#MAINTAINER conor.nagle@firmex.com

#Environment 
ENV PATH 		/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin:/usr/bin/pgbench
ENV PGDATA		/var/lib/postgresql/9.4/cluster
ENV PGCONFIG	/etc/postgresql/9.4/cluster
ENV PGBOUNCE    /etc/pcgbouncer
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
	
USER postgres
RUN  cd /var/lib/postgresql/9.4 &&\
     rm -rf *
     
USER root
RUN     adduser maximus --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password &&\
	echo "maximus:max" | chpasswd &&\
	usermod -d /var/lib/postgresql maximus &&\
	sudo chown -R maximus $PGHOME  $PGLOG /etc/postgresql /var/lib/postgresql /var/run/postgresql
	
	
	
RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R maximus /etc/ssl/private &&\
    mkdir /etc/postgresql/9.4/repmgr 

USER maximus
RUN	 cd /var/lib/postgresql/9.4 &&\
	 pg_createcluster 9.4 cluster &&\
#	 ssh-keygen -t rsa -f $PGHOME/.ssh/id_rsa -q -N "" &&\
#	 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys &&\
#	 chmod go-rwx ~/.ssh/* &&\
	 #cd ~/.ssh &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgnode2: &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgbouncer: &&\ 
     pg_ctl start -p 5433 -l $PGLOG/postgresql-9.4-cluster.log &&\
     createdb Repmgr &&\
     createdb Billboard &&\
     $PSQL "CREATE ROLE repmgr LOGIN SUPERUSER;" #&&\
 #    $PSQL "DROP SCHEMA public;" &&\
     #automate this for many logical shards >> $PSQL "CREATE SCHEMA shard1;" &&\
 #    repmgr -f $PGREP/repmgr.conf --verbose master register &&\
 #    mkdir ~/scripts


ADD postgresql.conf /etc/postgresql/9.4/cluster/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.4/cluster/pg_hba.conf
ADD pgbouncer.ini $PGBOUNCE/pgbouncer.ini
ADD repmgr.conf $PGREP/repmgr.conf
ADD userlist.txt $PGBOUNCE/userlist.txt
ADD failover.sh $PGHOME/scripts/failover.sh
#ADD run /usr/local/bin/run
#RUN chmod +x /usr/local/bin/run
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
EXPOSE 5433 6432
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/cluster", "-c", "config_file=/etc/postgresql/9.4/cluster/postgresql.conf"]
