FROM rspamd/rspamd:latest

USER root
COPY --chown=_rspamd:_rspamd defaults/local.d/ /etc/rspamd/local.d/
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown _rspamd:_rspamd /etc/rspamd/local.d
USER _rspamd

EXPOSE 11332 11333 11334

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -sf http://127.0.0.1:11334/ping >/dev/null || curl -sf http://127.0.0.1:11333/ping >/dev/null || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
