FROM rspamd/rspamd:latest

USER root
COPY --chown=_rspamd:_rspamd defaults/local.d/ /etc/rspamd/local.d/
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown _rspamd:_rspamd /etc/rspamd/local.d
USER _rspamd

EXPOSE 11332 11333 11334

# Probe with rspamc (shipped in the base image) rather than curl (which is
# not) — the previous curl-based check left the container permanently
# "unhealthy" even though rspamd was fully up.
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD rspamc stat >/dev/null 2>&1 || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
