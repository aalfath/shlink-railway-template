# Shlink, the self-hosted URL shortener: https://shlink.io
# Pinned by version and digest. Update both together (see CHANGELOG.md).
FROM shlinkio/shlink:5.1.8@sha256:68a722f7677008a50ccf3a9e570966bc37d7627fe6a870b86be28c5dcf9085ee

# Fixed settings for Railway. Database credentials, the default domain and the
# initial API key come from the template's variables.
ENV DB_DRIVER=postgres \
    IS_HTTPS_ENABLED=true \
    LOGS_FORMAT=console

# railway-start.sh waits for the database, then runs the upstream entrypoint:
# `shlink-installer init` (creates or migrates the database, creates
# INITIAL_API_KEY on first start), then RoadRunner listening on $PORT.
COPY --chmod=755 railway-start.sh /etc/shlink/railway-start.sh
ENTRYPOINT ["/bin/sh", "/etc/shlink/railway-start.sh"]
