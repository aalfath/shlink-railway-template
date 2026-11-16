# Shlink Web Client: https://shlink.io/documentation/shlink-web-client/
# Pinned by version and digest. Update both together (see CHANGELOG.md).
FROM shlinkio/shlink-web-client:4.9.0@sha256:9ea53f612d361de240555036065e2b8ea0cd0411b0125afaf2f7d39f2a928f18

USER root
# Replace the upstream site config with one that requires HTTP basic auth.
# The preconfigured servers.json contains the Shlink API key, so the whole
# web client must sit behind a login.
COPY default.conf.template /etc/shlink-railway/default.conf.template
COPY 25-railway-auth.sh /docker-entrypoint.d/25-railway-auth.sh
RUN chmod +x /docker-entrypoint.d/25-railway-auth.sh \
    && mkdir -p /etc/shlink-railway/run \
    && chown -R 101:0 /etc/shlink-railway /etc/nginx/conf.d \
    && rm -f /etc/nginx/conf.d/default.conf

USER 101
