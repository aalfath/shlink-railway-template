#!/bin/sh
# Waits for the database to accept TCP connections, then hands over to the
# upstream entrypoint. On a fresh template deploy Shlink and Postgres start at
# the same time, and `shlink-installer init` fails if the database isn't up.
set -e

if [ -n "${DB_HOST}" ]; then
  port="${DB_PORT:-5432}"
  i=0
  until php -r '$s=@fsockopen($argv[1],(int)$argv[2],$e,$m,3); exit($s?0:1);' "${DB_HOST}" "${port}"; do
    i=$((i+1))
    if [ "$i" -ge 60 ]; then
      echo "railway-start.sh: database ${DB_HOST}:${port} not reachable after 60 tries" >&2
      exit 1
    fi
    echo "railway-start.sh: waiting for database ${DB_HOST}:${port} (${i}/60)"
    sleep 3
  done
fi

exec /bin/sh /etc/shlink/docker-entrypoint.sh
