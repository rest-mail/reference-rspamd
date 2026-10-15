# reference-rspamd

A thin convention-conforming wrapper around the upstream [`rspamd/rspamd`](https://hub.docker.com/r/rspamd/rspamd) image. Adds overlay-config support, a standard log-level env var, and a healthcheck. Multi-arch (`linux/amd64` + `linux/arm64`), MIT-licensed.

## Image

```
ghcr.io/rest-mail/reference-rspamd:latest          # newest master build; pin a release instead
ghcr.io/rest-mail/reference-rspamd:X.Y.Z          # a release: git tag vX.Y.Z publishes it
```

## Quick start

```bash
docker run --rm -p 11333:11333 -p 11334:11334 \
  ghcr.io/rest-mail/reference-rspamd:latest

# Check it's up:
curl http://127.0.0.1:11334/ping
# pong
```

The default config exposes:
- `11332` (proxy worker)
- `11333` (normal scanning worker)
- `11334` (controller / web UI)

## Adding config (overlay)

The entrypoint copies any files in `/etc/rspamd-overlay/` into `/etc/rspamd/local.d/` at startup, overriding the baked-in defaults. See [rspamd's local.d documentation](https://rspamd.com/doc/faq.html#what-are-the-locald-and-overrided-directories) for what to put there.

```bash
# my-rspamd-config/dkim_signing.conf
selector = "mail";
path = "/etc/rspamd/dkim/$domain.$selector.key";

# Run:
docker run --rm -p 11334:11334 \
  -v $(pwd)/my-rspamd-config:/etc/rspamd-overlay:ro \
  ghcr.io/rest-mail/reference-rspamd:latest
```

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `RSPAMD_OVERLAY_DIR` | no | `/etc/rspamd-overlay` | Directory of `local.d` snippets to merge over baked-in defaults |
| `RSPAMD_LOG_LEVEL` | no | `info` | `debug`, `info`, `notice`, `warning`, `error` (set in `local.d/logging.inc` if no overlay supplies one) |

## Healthcheck

```
curl -sf http://127.0.0.1:11334/ping || curl -sf http://127.0.0.1:11333/ping
```

The controller worker on `:11334` answers first; `:11333` is the fallback for setups that disable the controller.

## Signals

- **SIGTERM** → graceful shutdown (handled by upstream rspamd init)
- **SIGHUP** → reload configuration without restart

## Defaults

The baked-in `/etc/rspamd/local.d/`:

- `worker-normal.inc` — `bind_socket = "*:11333"`
- `worker-controller.inc` — `bind_socket = "*:11334"`

Overlay any of these to change bind sockets, add per-domain settings, DKIM keys, etc.

## License

MIT.

## See also

- [`rest-mail/conventions`](https://github.com/rest-mail/conventions) — the contract every `reference-*` image follows
- [`rest-mail/reference-mailserver`](https://github.com/rest-mail/reference-mailserver) — composer that uses this image alongside postfix + dovecot
