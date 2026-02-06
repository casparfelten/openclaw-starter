# Recommended Skills

Skills extend what your agent can do. Install from [ClawHub](https://clawhub.com).

## Installing Skills

```bash
# Install the ClawHub CLI
npm install -g clawhub

# Install a skill
clawhub install skill-name
```

## Recommended for This Setup

### coding-agent
Run coding CLIs (Codex, Claude Code) via background process control.
```bash
clawhub install coding-agent
```

### github
Interact with GitHub via the `gh` CLI - issues, PRs, runs.
```bash
clawhub install github
```

### weather
Get weather and forecasts (no API key needed).
```bash
clawhub install weather
```

## Optional

### session-logs
Search and analyze past session transcripts.
```bash
clawhub install session-logs
```

### tmux
Control tmux sessions for interactive CLI work.
```bash
clawhub install tmux
```

### web-fetch (built-in)
Already included - fetches and extracts content from URLs.

### web-search (built-in)
Already included - searches via Brave API (needs BRAVE_API_KEY in env).

## Checking Installed Skills

Skills live in `~/.openclaw/skills/`. Each has a `SKILL.md` that the agent reads when needed.

```bash
ls ~/.openclaw/skills/
```

## Creating Custom Skills

See [skill-creator skill](https://clawhub.com/skills/skill-creator) for how to make your own.
