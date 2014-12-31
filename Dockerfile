#
# example Dockerfile for http://docs.docker.com/examples/postgresql_service/
#

FROM ubuntu:12.04
MAINTAINER conor.nagle@firmex.com

#Environment 
ENV PATH 		/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/postgresql/9.4/bin
ENV PGDATA		/var/lib/postgresql/9.4/main
ENV PGCONFIG	/etc/postgresql/9.4/main
ENV PGBOUNCE    /etc/pcgbouncer
ENV PGLOG		/var/log/postgresql
ENV PGREP		/etc/postgresql/9.4/repmgr
ENV PGHOME		/var/lib/postgresql
ENV PGRUN       /var/run/postgresql
ENV PSQL        psql --command 
#ENV PGRUN               /var/run/postgresql

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 &&\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update &&\
    apt-get install -y libc6 postgresql-9.4 \
    pgbouncer \
    repmgr 
    #python-software-properties software-properties-common postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 openssh-server  \
    

RUN echo "postgres ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  &&\
     cp /etc/postgresql/9.4/main/postgresql.conf $PGDATA/postgresql.conf


# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
#RUN    pg_ctl -c -D /var/lib/postgresql/9.4/main -l /var/log/postgresql/mylog.log start &&\
#cp /etc/postgresql/9.4/main/postgresql.conf $PGDATA/postgresql.conf &&\ 
     #pg_ctlcluster 9.4 main start &&\  
#     psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" 
    #pg_ctl  start &&\
    #cp /etc/postgresql/9.4/main/postgresql.conf $PGDATA/postgresql.conf  &&\
    
    #createdb -O docker docker 
    #pg_ctlcluster 9.4 main stop
   #cp $PGCONFIG/postgresql.conf $PGDATA/postgresql.conf
#/etc/init.d/postgresql start &&\

    #ssh-keygen -t rsa  -f $PGHOME/.ssh/id_rsa -q -N ""  &&\
    #cat $PGHOME/.ssh/id_rsa.pub >> $PGHOME/.ssh/authorized_keys &&\
    #chmod go-rwx $PGHOME/.ssh/* &&\
    #mkdir $PGDATA/repmgr 

#RUN repmgr -f $PGDATA/repmgr/repmgr.conf --verbose master register
#ADD postgresql.conf $PGCONFIG/postgresql.conf
ADD repmgr.conf $PGDATA/repmgr/repmgr.conf 
ADD pg_hba.conf $PGCONFIG/pg_hba.conf
ADD addsudo.sh $PGCONFIG/addsudo.sh

ADD .pgpass  $PGHOME/.pgpass
ADD pgbouncer.ini $PGBOUNCE/pgbouncer.ini
ADD userlist.txt $PGBOUNCE/userlist.txt
ADD failover.sh $PGHOME/scripts/failover.sh

#ADD run /usr/local/bin/run
#RUN chmod +x /usr/local/bin/run
EXPOSE  5432 6432 22
#CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf" ]
CMD ["/usr/lib/postgresql/9.4/bin/pg_ctl", "-D", "/var/lib/postgresql/9.4/main", "-c", "-l", "/var/log/postgresql/logg.log" ]

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
 #"-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf",
# Set the default command to run when starting the container
#CMD ["/usr/bin/pg_ctlcluster" , "9.4" , "main" , "start"]

#"/usr/local/pgsql/bin/pg_ctl start -l logfile -D /usr/local/pgsql/data"

