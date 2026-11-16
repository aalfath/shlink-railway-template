# Shlink Web Client: https://shlink.io/documentation/shlink-web-client/
# Pinned by version and digest. Update both together (see CHANGELOG.md).
FROM shlinkio/shlink-web-client:4.9.0@sha256:9ea53f612d361de240555036065e2b8ea0cd0411b0125afaf2f7d39f2a928f18

USER root
# Replace the upstream site config with one that requires HTTP basic auth.
# The preconfigured servers.json contains the Shlink API key, so the whole
# web client must sit behind a login.
COPY default.conf.template /etc/shlink-railway/default.conf.template
COPY 25-railway-auth.sh /docker-entrypoint.d/25-railway-auth.sh
# The generated site config and password file live in /tmp, which is always
# writable whatever user the platform runs the container as.
RUN chmod 755 /docker-entrypoint.d/25-railway-auth.sh \
    && chmod 644 /etc/shlink-railway/default.conf.template \
    && rm -f /etc/nginx/conf.d/default.conf \
    && ln -s /tmp/shlink-railway/default.conf /etc/nginx/conf.d/default.conf \
    && ln -sf /tmp/shlink-railway/servers.json /usr/share/nginx/html/servers.json

USER 101
