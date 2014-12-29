#Master Node1 

FROM ubuntu:14.04
#MAINTAINER conor.nagle@firmex.com

#Environment 
ENV PATH 		/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin:/usr/bin/pgbench
ENV PGDATA		/var/lib/postgresql/9.4/main
ENV PGCONFIG	/etc/postgresql/9.4/main
ENV PGBOUNCE    /etc/pcgbouncer
ENV PGLOG		/var/log/postgresql
ENV PGREP		/etc/postgresql/9.4/repmgr
ENV PGHOME		/var/lib/postgresql
ENV PGRUN               /var/run/postgresql
ENV PSQL        psql --command 

USER root
RUN 	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&\
	echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN  apt-get update && apt-get install -y libxslt1-dev \
libxml2-dev \
libedit-dev \
libpam-dev \
python-software-properties \
software-properties-common \
postgresql-9.4 \
postgresql-client-9.4 \
postgresql-contrib-9.4 \
libxslt1-dev \
libxml2-dev \ 
libedit-dev \
pgbouncer \
repmgr \
openssh-server

RUN     sudo adduser maximus --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password &&\
	echo "maximus:max" | chpasswd &&\
	sudo chown -R maximus $PGHOME/  $PGLOG/ $PGCONFIG/ $PGDATA/ $PGRUN

#workaround (maybe not required)
#RUN sudo mkdir /etc/ssl/private-copy #; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R maximus /etc/ssl/private &&\
    #mkdir /etc/postgresql/9.4/repmgr 
#ssh-keygen -t rsa -f  var/lib/.ssh/id_rsa -q -N ""  &&\
USER maximus
RUN	 ssh-keygen -t rsa -f >> $PGHOME/.ssh/id_rsa -q -N ""  &&\
	 cat $PGHOME/.ssh/id_rsa.pub >> $PGHOME/.ssh/authorized_keys &&\
	 chmod go-rwx $PGHOME/.ssh/* &&\
	 #cd ~/.ssh &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgnode2: &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgbouncer: &&\ 
     pg_ctl start -l $PGLOG/postgresql-9.4-main.log &&\
     createdb Repmgr &&\
     #createdb Billboard &&\
     $PSQL "CREATE ROLE repmgr LOGIN SUPERUSER;" &&\
     $PSQL "CREATE DATABASE Repmgr;" &&\ 
     $PSQL "DROP SCHEMA public;" &&\
     #automate this for many logical shards >> $PSQL "CREATE SCHEMA shard1;" &&\
     repmgr -f $PGREP/repmgr.conf --verbose master register &&\
     mkdir $PGHOME/scripts


ADD postgresql.conf /etc/postgresql/9.4/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
ADD pgbouncer.ini $PGBOUNCE/pgbouncer.ini
ADD repmgr.conf $PGREP/repmgr.conf
ADD userlist.txt $PGBOUNCE/userlist.txt
ADD failover.sh $PGHOME/scripts/failover.sh
#ADD run /usr/local/bin/run
#RUN chmod +x /usr/local/bin/run
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
EXPOSE 5432  6432
#CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
