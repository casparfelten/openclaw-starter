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
| OpenAI API Key | https://platform.openai.com/api-keys |
| Telegram Bot Token | Message @BotFather on Telegram, say `/newbot` |
| Your Telegram User ID | Message @userinfobot on Telegram |

## 3. Configure

```bash
# Copy the example config
cp openclaw.example.json ~/.openclaw/openclaw.json

# Edit and replace the placeholders
nano ~/.openclaw/openclaw.json
```

Replace these three lines:
```json
"apiKey": "YOUR_OPENAI_API_KEY"        → "apiKey": "sk-..."
"token": "YOUR_TELEGRAM_BOT_TOKEN"     → "token": "123456:ABC..."  
"allowList": ["YOUR_TELEGRAM_USER_ID"] → "allowList": ["123456789"]
```

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
