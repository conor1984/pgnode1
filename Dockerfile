#Master Node1 

FROM ubuntu:14.04
#MAINTAINER conor.nagle@firmex.com

#Environment 
ENV PATH 		/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin
ENV PGDATA		/var/lib/postgresql/9.4/main
ENV PGCONFIG	/etc/postgresql/9.4/main
ENV PGBOUNCE    /etc/pcgbouncer
ENV PGLOG		/var/log/postgresql
ENV PGREP		/etc/postgresql/9.4/repmgr
ENV PGHOME		/var/lib/postgresql
ENV PGRUN               /var/run/postgresql
#ENV PGLOG		/var/log/postgresql/pglog.log
ENV PSQL        psql --command 


RUN     sudo adduser maximus --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password &&\
	echo "maximus:max" | chpasswd 
	#sudo chown -R maximus:maximus $PGHOME  $PGLOG $PGCONFIG $PGDATA $PGRUN
	
RUN 	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&\
	echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update &&\
    apt-get install -y python-software-properties software-properties-common postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 openssh-server \

#RUN sudo apt-get install -y libxslt1-dev \
#libxml2-dev \
#libedit-dev \
#libpam-dev \
#python-software-properties \
#software-properties-common \

#postgresql-9.4 \
#postgresql-client-9.4 \
#postgresql-contrib-9.4 \
#libxslt1-dev \
#libxml2-dev \ 
#libedit-dev \
pgbouncer \
repmgr \
sendmail \
mailutils


#workaround (maybe not required)
#RUN sudo mkdir /etc/ssl/private-copy #; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R maximus /etc/ssl/private &&\
    #mkdir /etc/postgresql/9.4/repmgr 
#ssh-keygen -t rsa -f  var/lib/.ssh/id_rsa -q -N ""  &&\

#Log issue fix (not working)
#ADD pg_ctl.conf $PGCONFIG/pg_ctl.conf
#RUN  sudo chown -R maximus:maximus $PGHOME  $PGLOG $PGCONFIG $PGDATA $PGRUN /etc/init.d #&&\
     #sudo chmod 751 $PGHOME  $PGLOG $PGCONFIG $PGDATA $PGRUN /etc/init.d

#$PGRUN

	

#USER postgres
#RUN	 rm /var/lib/postgresql/9.4/main/postmaster.pid 
	 
USER maximus
RUN	 mkdir /home/maximus/logs/ &&\
	 mkdir /home/maximus/cluster/ &&\
	 mkdir /home/maximus/cluster/data &&\
	 mkdir /home/maximus/sockets/ 

ADD postgresql.conf /home/maximus/cluster/postgresql.conf
ADD pg_hba.conf /home/maximus/cluster/pg_hba.conf

RUN	 pg_createcluster -c /home/maximus/cluster -s /sockets -D ~/cluster/data -l /logs/cluster.log 9.4 cluster
#&&\
        # pg_ctlcluster start &&\
	 #echo 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin export PATH' > .pam_environment &&\
	 #. ~/.pam_environment &&\ 
	 #/etc/init.d/postgresql start &&\
	 #mkdir $PGHOME/.ssh  &&\
	 #ssh-keygen -t rsa -f $PGHOME/.ssh/id_rsa -q -N ""  &&\
	 #cat $PGHOME/.ssh/id_rsa.pub >> $PGHOME/.ssh/authorized_keys &&\
	 #chmod go-rwx $PGHOME/.ssh/* &&\
	 #cd ~/.ssh &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgnode2: &&\
	 ######scp id_rsa.pub id_rsa authorized_keys maximus@pgbouncer: &&\ 
     #/etc/init.d/postgresql start &&\
     #pg_ctlcluster  9.4 main start  &&\
     #-l $PGLOG/postgresql-9.4-main.log &&\
    # createdb Repmgr &&\
     #createdb Billboard &&\
    # $PSQL "CREATE USER docker WITH SUPERUSER PASSWORD 'docker'" &&\
    # $PSQL "CREATE ROLE repmgr LOGIN SUPERUSER;" &&\
     #$PSQL "CREATE DATABASE Repmgr;" &&\ 
     #$PSQL "CREATE DATABASE Billboard;" &&\
    # mkdir $PGHOME/scripts
     #$PSQL "DROP SCHEMA public;" 
     
ADD repmgr.conf $PGREP/repmgr.conf
#RUN    repmgr -D $PGDATA -d Billboard -p 5432 -U repmgr -R postgres --verbose standby clone pgnode1 
#RUN 	repmgr -f $PGREP/repmgr.conf --verbose master register 
     #automate this for many logical shards >> $PSQL "CREATE SCHEMA shard1;" &&\
     
     

ADD addsudo.sh $PGCONFIG/addsudo.sh

ADD .pgpass  $PGHOME/.pgpass
ADD pgbouncer.ini $PGBOUNCE/pgbouncer.ini
ADD userlist.txt $PGBOUNCE/userlist.txt
ADD failover.sh $PGHOME/scripts/failover.sh
#ADD run /usr/local/bin/run
#RUN chmod +x /usr/local/bin/run
VOLUME  ["/home/maximus"]
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/home/maximus/cluster/data", "-c", "config_file=/home/maximus/cluster/postgresql.conf"]
