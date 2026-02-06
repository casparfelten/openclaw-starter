#!/usr/bin/env bash
set -euo pipefail

# OpenClaw Starter Kit bootstrap (non-interactive)
# Requires env vars:
#   OPENAI_API_KEY
#   TELEGRAM_BOT_TOKEN
#   TELEGRAM_ALLOW_FROM   (numeric Telegram user id)

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

# 5) start
openclaw gateway start

echo "OK: OpenClaw started. Message your Telegram bot."