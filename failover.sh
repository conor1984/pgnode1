# this script should do the following 3 things, promote db , copy
# pgbouncer conf to pgbouncer server and restart the service
pg_ctl -D $PGDATA promote
rsync --delete -a -k --perms  $PGBOUNCE/pgbouncer.ini postgres@pgbouncer:$PGBOUNCE/
#reload
ssh postgres@pgbouncer pgbouncer -R -d $PGBOUNCE/pgbouncer.ini
#
