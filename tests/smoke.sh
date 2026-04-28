#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-reference-rspamd:smoke}"
PORT="${PORT:-21334}"
NAME="reference-rspamd-smoke"

cleanup() {
  docker rm -f "$NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker build -t "$IMAGE" .
docker run -d --rm --name "$NAME" -p "$PORT:11334" "$IMAGE"

for i in $(seq 1 30); do
  if curl -sf "http://127.0.0.1:$PORT/ping" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

RESULT=$(curl -sf "http://127.0.0.1:$PORT/ping" || echo FAIL)
if [ "$RESULT" != "pong" ] && [ "$RESULT" != "pong"$'\r' ]; then
  echo "FAIL: expected 'pong', got '$RESULT'"
  docker logs "$NAME" 2>&1 | tail -30
  exit 1
fi

echo "OK: rspamd /ping returns '$RESULT'"
