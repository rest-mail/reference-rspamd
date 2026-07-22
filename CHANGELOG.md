# Changelog

Calver-tagged. Newest on top.

## Unreleased

### Fixed
- Healthcheck used `curl`, which the base image does not ship, leaving the
  container permanently `unhealthy` even though rspamd was up. Probe with
  `rspamc stat` instead (part of the base image). Verified: container reports
  healthy ~20s after start.

## 2026.04.28

- Initial release.
- Wraps upstream `rspamd/rspamd:latest` with rest-mail conventions: overlay config at `/etc/rspamd-overlay/`, `RSPAMD_LOG_LEVEL` env var, healthcheck via `/ping` endpoint.
- Multi-arch publish: linux/amd64, linux/arm64.
