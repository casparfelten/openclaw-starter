#!/usr/bin/env bash
set -euo pipefail

# OpenClaw Starter Kit bootstrap (non-interactive)
#
# This script is intentionally strict: it REQUIRES Docker for sandboxing.
# If requirements are missing, it prints install commands and exits.
#
# Required env vars:
#   OPENAI_API_KEY
#   TELEGRAM_BOT_TOKEN
#   TELEGRAM_ALLOW_FROM   (numeric Telegram user id)

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    return 1
  fi
}

node_major() {
  node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0
}

print_reqs() {
  cat <<'TXT'
Requirements:
- node >= 20
- npm
- docker (daemon running)
- openclaw CLI (npm global install)

Install examples:

1) Install OpenClaw CLI:
   npm i -g @anthropic/openclaw

2) Install Docker:
   - Linux: https://docs.docker.com/engine/install/
   - macOS: https://docs.docker.com/desktop/install/mac-install/
   - Windows: https://docs.docker.com/desktop/install/windows-install/

3) Ensure Docker daemon is running:
   docker info
TXT
}

# --- Preflight ---

if ! need_cmd node; then
  echo "ERROR: node is not installed." >&2
  print_reqs
  exit 2
fi

MAJOR=$(node_major)
if [ "${MAJOR}" -lt 20 ]; then
  echo "ERROR: node >= 20 required (found node ${MAJOR})." >&2
  print_reqs
  exit 2
fi

if ! need_cmd npm; then
  echo "ERROR: npm is not installed." >&2
  print_reqs
  exit 2
fi

if ! need_cmd openclaw; then
  echo "ERROR: openclaw CLI not found." >&2
  echo "Run: npm i -g @anthropic/openclaw" >&2
  exit 2
fi

if ! need_cmd docker; then
  echo "ERROR: docker not found (required)." >&2
  print_reqs
  exit 2
fi

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: docker daemon not running or not accessible." >&2
  echo "Try: docker info" >&2
  exit 2
fi

: "${OPENAI_API_KEY:?Missing OPENAI_API_KEY}"
: "${TELEGRAM_BOT_TOKEN:?Missing TELEGRAM_BOT_TOKEN}"
: "${TELEGRAM_ALLOW_FROM:?Missing TELEGRAM_ALLOW_FROM}"

# 1) init
openclaw init >/dev/null

# 2) env file
mkdir -p ~/.openclaw
chmod 700 ~/.openclaw
cat > ~/.openclaw/.env <<EOF
OPENAI_API_KEY=${OPENAI_API_KEY}
EOF
chmod 600 ~/.openclaw/.env

# 3) install config + patch secrets
cp -f openclaw.example.json ~/.openclaw/openclaw.json
node - <<'NODE'
const fs = require('fs');
const path = require('path');

const cfgPath = path.join(process.env.HOME, '.openclaw', 'openclaw.json');
const cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8'));

const botToken = process.env.TELEGRAM_BOT_TOKEN;
const allowFrom = process.env.TELEGRAM_ALLOW_FROM;

cfg.channels = cfg.channels || {};
cfg.channels.telegram = cfg.channels.telegram || {};
cfg.channels.telegram.enabled = true;
cfg.channels.telegram.botToken = botToken;

// Lock down: allowlist mode, only the provided user id.
cfg.channels.telegram.dmPolicy = 'allowlist';
cfg.channels.telegram.allowFrom = [allowFrom];
cfg.channels.telegram.groupPolicy = 'disabled';

// Update meta timestamps best-effort.
cfg.meta = cfg.meta || {};
cfg.meta.lastTouchedAt = new Date().toISOString();

fs.writeFileSync(cfgPath, JSON.stringify(cfg, null, 2) + '\n');
NODE

# 4) workspace templates
mkdir -p ~/.openclaw/workspace
cp -R workspace/* ~/.openclaw/workspace/

# 5) sanity checks
openclaw gateway status >/dev/null || true

echo "NOTE: this starter kit expects a sandbox image named openclaw-sandbox:latest."
echo "If you don't have it yet, build/pull it before relying on sandboxed exec."
echo "Check: docker image ls | grep openclaw-sandbox"

# 6) start
openclaw gateway start

echo "OK: OpenClaw started. Message your Telegram bot."