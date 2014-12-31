#!/bin/bash


service postgresql stop >/dev/null 2>&1
sudo -u postgres /usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf >/var/log/postgresql/logfile.log 2>&1 & 






