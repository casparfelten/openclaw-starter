# Quick Start (5 minutes)

## 1. Install OpenClaw

```bash
npm install -g @anthropic/openclaw
openclaw init
```

## 2. Get Your Credentials

You need three things:

| What | Where to Get It |
|------|-----------------|
| OpenAI API Key | https://platform.openai.com/api-keys (store in `~/.openclaw/.env`) |
| Telegram Bot Token | Message @BotFather on Telegram, say `/newbot` |
| Your Telegram User ID | Message @userinfobot on Telegram |

## 3. Configure (non-interactive)

Requirements: node>=20, npm, docker (daemon running), openclaw CLI.

```bash
export OPENAI_API_KEY=sk-...
export TELEGRAM_BOT_TOKEN=123456:ABC...
export TELEGRAM_ALLOW_FROM=123456789
./setup.sh
```

(Manual alternative: copy `openclaw.example.json` to `~/.openclaw/openclaw.json` and fill in placeholders.)

Create `~/.openclaw/.env`:

```bash
chmod 700 ~/.openclaw
cat > ~/.openclaw/.env <<'EOF'
OPENAI_API_KEY=sk-...
EOF
chmod 600 ~/.openclaw/.env
```

If you don’t use `./setup.sh`, then in `~/.openclaw/openclaw.json` you must set:
- `channels.telegram.botToken`
- `channels.telegram.allowFrom` (your numeric Telegram user id)

## 4. Set Up Workspace

```bash
cp -r workspace/* ~/.openclaw/workspace/
```

Edit `~/.openclaw/workspace/USER.md` with your name and preferences.

## 5. Start

```bash
openclaw gateway start
```

## 6. Test

Message your bot on Telegram. Say "hello".

If it responds, you're done! 🎉

## What Now?

- Ask it to research something: "Research the best Python web frameworks"
- Ask it to write code: "Write a script that counts words in a file"
- Build your knowledge graph: "Create a note about [topic]"

See README.md for full documentation.
