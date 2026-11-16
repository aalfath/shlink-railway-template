#!/bin/sh
# Writes the nginx site config (listening on $PORT) and the basic-auth file
# before nginx starts. Fails closed: no password, no start.
set -e

PORT="${PORT:-8080}"
WEB_USERNAME="${WEB_USERNAME:-admin}"

if [ -z "${WEB_PASSWORD}" ]; then
  echo "25-railway-auth.sh: WEB_PASSWORD is empty; refusing to start without a login" >&2
  exit 1
fi

mkdir -p /tmp/shlink-railway
# servers.json is a symlink into /tmp; the upstream 30-shlink-servers-json.sh
# fills it from SHLINK_SERVER_URL and SHLINK_SERVER_API_KEY.
echo '[]' > /tmp/shlink-railway/servers.json

# SHA-512 crypt hash with busybox mkpasswd (no extra packages needed).
hash=$(printf '%s' "${WEB_PASSWORD}" | mkpasswd -m sha512 -P 0)
case "${hash}" in
  '$6$'*) ;;
  *) echo "25-railway-auth.sh: could not hash WEB_PASSWORD" >&2; exit 1 ;;
esac
printf '%s:%s\n' "${WEB_USERNAME}" "${hash}" > /tmp/shlink-railway/htpasswd
sed "s/__PORT__/${PORT}/" /etc/shlink-railway/default.conf.template > /tmp/shlink-railway/default.conf
nginx -t -q
echo "25-railway-auth.sh: basic auth enabled for user ${WEB_USERNAME}, listening on ${PORT}"
