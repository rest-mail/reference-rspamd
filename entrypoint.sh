#!/bin/sh
set -eu

# Merge overlay config files on top of baked-in defaults.
# Files in $RSPAMD_OVERLAY_DIR override entries in /etc/rspamd/local.d/.
OVERLAY_DIR="${RSPAMD_OVERLAY_DIR:-/etc/rspamd-overlay}"
LOG_LEVEL="${RSPAMD_LOG_LEVEL:-info}"

if [ -d "$OVERLAY_DIR" ]; then
  cp -rf "$OVERLAY_DIR"/. /etc/rspamd/local.d/ 2>/dev/null || true
fi

# Translate log level into rspamd's logging.inc form. Only write if the
# overlay didn't supply its own logging.inc.
if [ ! -f "$OVERLAY_DIR/logging.inc" ]; then
  cat >/etc/rspamd/local.d/logging.inc <<EOF
level = "$LOG_LEVEL";
EOF
fi

# Hand off to rspamd's own entrypoint if present, else exec rspamd directly.
if [ -x /docker-entrypoint.sh ]; then
  exec /docker-entrypoint.sh "$@"
fi
exec rspamd -f "$@"
