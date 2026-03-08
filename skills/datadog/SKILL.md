---
name: datadog
description: Monitor infrastructure, query metrics, manage monitors and events via Datadog API
user-invocable: true
argument-hint: [monitor ID or metric name]
---

# /datadog

Connect to the Datadog API to manage monitors, dashboards, events, metrics and hosts. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # API key + App key auth + dd_request helper (required by all scripts)
├── check_setup.rb   # Check if keys exist (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate API key + App key
├── monitors.rb      # List all monitors
├── monitor.rb       # Get monitor details
├── mute_monitor.rb  # Mute a monitor
├── unmute_monitor.rb# Unmute a monitor
├── dashboards.rb    # List dashboards
├── events.rb        # List events (last 24h by default)
├── metrics.rb       # List active metrics
└── hosts.rb         # List infrastructure hosts
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/datadog/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create API and Application keys:

> You need a Datadog API key and an Application key. You can create them in the Datadog Organization Settings:
>
> **API Keys:** https://app.datadoghq.com/organization-settings/api-keys
> **Application Keys:** https://app.datadoghq.com/organization-settings/application-keys
>
> Copy both keys and paste them here (API key first, then Application key).

**Step 2** — When the user pastes both keys, save them:

```bash
ruby ~/.claude/skills/datadog/scripts/save_token.rb 'API_KEY' 'APP_KEY'
```

If the script outputs an error, the keys are invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a monitor ID or metric name.

### Step 1: Overview

```bash
ruby ~/.claude/skills/datadog/scripts/monitors.rb
```

Present the monitors to the user. If `$ARGUMENTS` matches a monitor ID, use that monitor. Otherwise ask what the user wants to do.

### Step 2: Actions

**List all monitors:**
```bash
ruby ~/.claude/skills/datadog/scripts/monitors.rb
```

**Get monitor details:**
```bash
ruby ~/.claude/skills/datadog/scripts/monitor.rb MONITOR_ID
```

**Mute a monitor (requires user confirmation):**

Show monitor details first, then ask: "Do you want to mute this monitor?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/datadog/scripts/mute_monitor.rb MONITOR_ID
```

**Unmute a monitor (requires user confirmation):**

Show monitor details first, then ask: "Do you want to unmute this monitor?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/datadog/scripts/unmute_monitor.rb MONITOR_ID
```

**List dashboards:**
```bash
ruby ~/.claude/skills/datadog/scripts/dashboards.rb
```

**List events (last 24 hours by default):**
```bash
ruby ~/.claude/skills/datadog/scripts/events.rb
ruby ~/.claude/skills/datadog/scripts/events.rb --hours 48
```

**List active metrics:**
```bash
ruby ~/.claude/skills/datadog/scripts/metrics.rb
ruby ~/.claude/skills/datadog/scripts/metrics.rb --host myhost
```

**List infrastructure hosts:**
```bash
ruby ~/.claude/skills/datadog/scripts/hosts.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via DD-API-KEY and DD-APPLICATION-KEY headers
- API key file: `~/.config/datadog/api_key` (outside the repo, never commit)
- App key file: `~/.config/datadog/app_key` (outside the repo, never commit)
- Muting and unmuting monitors require explicit user confirmation
- Base URL: `https://api.datadoghq.com/api/v1`
