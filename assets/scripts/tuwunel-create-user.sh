#!/usr/bin/env bash
set -euo pipefail

SERVICE="tuwunel"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <username>" >&2
    exit 1
fi

USERNAME="$1"

# Get the Tuwunel config from the service definition.
CONFIG="$(
    systemctl cat "$SERVICE" |
    sed -n 's/.*TUWUNEL_CONFIG=\([^[:space:]]*\)".*/\1/p' |
    head -n1
)"

if [[ -z "$CONFIG" ]]; then
    echo "Error: TUWUNEL_CONFIG not found in $SERVICE.service" >&2
    exit 1
fi

# Get the Tuwunel binary from ExecStart.
BINARY="$(
    systemctl cat "$SERVICE" |
    sed -n 's/^ExecStart=\([^[:space:]]*\).*/\1/p' |
    head -n1
)"

if [[ -z "$BINARY" ]]; then
    echo "Error: Tuwunel binary not found in $SERVICE.service" >&2
    exit 1
fi

echo "Creating Tuwunel user: $USERNAME"
echo "Config: $CONFIG"

sudo systemctl stop "$SERVICE"

cleanup() {
    if [[ -n "${TUWUNEL_PID:-}" ]] && kill -0 "$TUWUNEL_PID" 2>/dev/null; then
        sudo kill -INT "$TUWUNEL_PID" 2>/dev/null || true
        wait "$TUWUNEL_PID" 2>/dev/null || true
    fi

    sudo systemctl start "$SERVICE"
}

trap cleanup EXIT INT TERM

sudo env TUWUNEL_CONFIG="$CONFIG" \
    "$BINARY" \
    --execute "!admin users create-user $USERNAME" &

TUWUNEL_PID=$!

# Wait for the one-shot command to finish.
# Tuwunel continues running after --execute, so interrupt it.
sleep 2

sudo kill -INT "$TUWUNEL_PID" 2>/dev/null || true
wait "$TUWUNEL_PID" 2>/dev/null || true

echo "User '$USERNAME' created."