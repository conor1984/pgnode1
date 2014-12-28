
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
