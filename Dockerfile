FROM ubuntu:14.04
MAINTAINER conor.nagle@firmex.com

#Environment 
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin:/usr/bin/pgbench
ENV PGDATA=/var/lib/postgresql/9.4/main
ENV PGCONFIG=/etc/postgresql/9.4/main
ENV PGBOUNCE=/etc/pgbouncer
ENV PGLOG=/var/log/postgresql
ENV PGREP=/etc/postgresql/9.4/repmgr

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

#Postgresql 9.4
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

#Zabbix
RUN wget http://repo.zabbix.com/zabbix/2.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.2-1+trusty_all.deb
RUN sudo dpkg -i zabbix-release_2.2-1+trusty_all.deb

#Variables
PSQL="psql --command "

RUN sudo apt-get update &&\
	sudo apt-get upgrade &&\
	sudo apt-get install -y python-software-properties software-properties-common postgresql-9.4-plproxy postgresql-client-9.4 postgresql-contrib-9.4 &&\
    libxslt-dev libxml2-dev libpam-dev libedit-dev git &&\ 
    pgbouncer repmgr pgbench pgadmin zabbix-server-pgsql zabbix-frontend-php
    #flex bison

#Create Postgres user
RUN sudo useradd maximus &&\
	sudo passwd maximus &&\
	"max" &&\
	"max" &&\
	sudo usermod -d /var/lib/postgresql maximus  
    
# /etc/ssl/private can't be accessed from within container for some reason
# (@andrewgodwin says it's something AUFS related)
RUN sudo mkdir /etc/ssl/private-copy; sudo mv /etc/ssl/private/* /etc/ssl/private-copy/; sudo rm -r /etc/ssl/private; sudo mv /etc/ssl/private-copy /etc/ssl/private; sudo chmod -R 0700 /etc/ssl/private; sudo chown -R maximus /etc/ssl/private &&\
    sudo mkdir /etc/postgresql/9.4/repmgr &&\
	sudo chown maximus $PGDATA $PGCONFIG $PGLOG

USER maximus
    
RUN	 ssh-keygen -t rsa &&\
	 "\n" &&\
	 "\n" &&\
	 "\n" &&\
	 "\n" &&\
	 cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys &&\
	 chmod go-rwx ~/.ssh/* &&\
	 #cd ~/.ssh &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgnode2: &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgbouncer: &&\ 
     pg_ctl start -l $PGLOG &&\
     createdb Repmgr &&\
     createdb Billboard
     $PSQL "CREATE ROLE repmgr LOGIN SUPERUSER;" &&\
     $PSQL "DROP SCHEMA public;" &&\
     #automate this for many logical shards >> $PSQL "CREATE SCHEMA shard1;" &&\
     repmgr -f $PGREP/repmgr.conf master register 


ADD postgresql.conf /etc/postgresql/9.4/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
ADD pgbouncer.ini $PGBOUNCE/pgbouncer.ini
ADD repmgr.conf $PGREP/repmgr.conf
ADD userlist.txt $PGBOUNCE/userlist.txt
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432 6432
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
