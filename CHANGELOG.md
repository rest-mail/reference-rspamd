# Changelog

Calver-tagged. Newest on top.

## 2026.04.28

- Initial release.
- Wraps upstream `rspamd/rspamd:latest` with rest-mail conventions: overlay config at `/etc/rspamd-overlay/`, `RSPAMD_LOG_LEVEL` env var, healthcheck via `/ping` endpoint.
- Multi-arch publish: linux/amd64, linux/arm64.
