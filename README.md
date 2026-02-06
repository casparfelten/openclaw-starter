# OpenClaw Starter Kit

A minimal OpenClaw setup with:
- **GPT 5.2** as the default model
- **Telegram** as the chat interface
- **Dev agent** for coding tasks (sandboxed)
- **Research agent** for web browsing (isolated)
- **Internal knowledge graph** for persistent notes

## Prerequisites

1. **Node.js 20+** - [Install guide](https://nodejs.org/)
2. **OpenAI API key** - [Get one here](https://platform.openai.com/api-keys)
3. **Telegram bot** - Create via [@BotFather](https://t.me/BotFather)
4. **Docker** (optional but recommended) - For sandboxed code execution

## Installation

### Step 1: Install OpenClaw

```bash
npm install -g @anthropic/openclaw
```

### Step 2: Initialize

```bash
openclaw init
```

This creates `~/.openclaw/` with default config.

### Step 3: Configure

Copy the example config:

```bash
cp openclaw.example.json ~/.openclaw/openclaw.json
```

Edit `~/.openclaw/openclaw.json` and replace:
- `YOUR_OPENAI_API_KEY` → your actual OpenAI API key
- `YOUR_TELEGRAM_BOT_TOKEN` → token from BotFather
- `YOUR_TELEGRAM_USER_ID` → your Telegram user ID (get it from [@userinfobot](https://t.me/userinfobot))

### Step 4: Set up workspace

Copy the workspace templates:

```bash
cp -r workspace/* ~/.openclaw/workspace/
```

Edit `~/.openclaw/workspace/USER.md` and fill in your details.

### Step 5: Start

```bash
openclaw gateway start
```

Message your bot on Telegram. It should respond.

## What You Get

### Main Agent
Your primary assistant. Handles direct requests, coordinates workers.

### Dev Agent
Spawned for coding tasks. Runs in a sandbox with:
- File system access (workspace only)
- Shell execution
- No network access (safe from exfiltration)

To use: Ask the main agent to "spawn a dev agent to [task]" or it will do so automatically for complex coding.

### Research Agent
Spawned for web research. Runs isolated with:
- Web search and fetch
- Browser automation
- Network access enabled

To use: Ask "research [topic]" or "find information about [thing]".

**Important:** Research agent output is treated as "tainted" - it can read the web but shouldn't access your private files directly.

### Knowledge Graph
A simple markdown-based knowledge graph in `workspace/kg/`.

- `INDEX.md` - Entry point, links to topic notes
- Create topic notes as needed: `kg/topic-name.md`
- Link between notes with `[[topic-name]]`

The agent will read/write to the KG to maintain context across sessions.

## Configuration Reference

Key settings in `openclaw.json`:

| Setting | Purpose |
|---------|---------|
| `defaultModel` | Model for main agent (gpt-5.2) |
| `providers.openai.apiKey` | Your OpenAI API key |
| `channels.telegram.token` | Telegram bot token |
| `channels.telegram.allowList` | Your Telegram user ID |
| `sandbox.enabled` | Enable Docker sandbox for code |
| `agents.dev.model` | Model for dev worker |
| `agents.research.model` | Model for research worker |

## Troubleshooting

### Bot doesn't respond
1. Check `openclaw gateway status`
2. Verify bot token is correct
3. Ensure your user ID is in allowList

### Code execution fails
1. Install Docker: `docker --version`
2. Enable sandbox in config: `sandbox.enabled: true`
3. Check Docker is running

### Research agent can't browse
1. Verify network access in research agent config
2. Check web_search/web_fetch are in allowed tools

## Next Steps

1. **Customize SOUL.md** - Give your agent personality
2. **Build your KG** - Add topic notes as you work
3. **Install skills** - See `skills.md` for recommended additions

## Resources

- [OpenClaw Docs](https://docs.molt.bot)
- [GitHub](https://github.com/moltbot/moltbot)
- [Discord Community](https://discord.com/invite/clawd)
