---
name: heroku
description: Manage Heroku apps, dynos, config and deployments via Platform API
user-invocable: true
argument-hint: [app name or ID]
---

# /heroku

Connect to the Heroku Platform API to manage apps, dynos, config vars, releases and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Bearer token + heroku_request helper (required by all scripts)
├── check_setup.rb   # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate an API token
├── apps.rb          # List all apps
├── app.rb           # Get app details
├── dynos.rb         # List dynos for an app
├── config_vars.rb   # List config vars (masked by default)
├── releases.rb      # List releases for an app
├── addons.rb        # List add-ons for an app
├── domains.rb       # List domains for an app
├── formation.rb     # List formation (process types/scaling)
├── logs.rb          # Create log session and return URL
├── restart.rb       # Restart all dynos
└── scale.rb         # Scale a process type
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/heroku/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need a Heroku API token. You can create one with the Heroku CLI:
>
> ```
> heroku authorizations:create -d "hitank"
> ```
>
> Or go to **Account Settings** on the Heroku Dashboard and find the **API Key** section:
> https://dashboard.heroku.com/account
>
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/heroku/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an app name or ID.

### Step 1: List apps

```bash
ruby ~/.claude/skills/heroku/scripts/apps.rb
```

Present the apps to the user. If `$ARGUMENTS` matches an app name, use that app. Otherwise ask which app to work with.

### Step 2: Show app details

```bash
ruby ~/.claude/skills/heroku/scripts/app.rb APP_NAME
```

Present the app info and ask what the user wants to do.

### Step 3: Actions

**List dynos:**
```bash
ruby ~/.claude/skills/heroku/scripts/dynos.rb APP
```

**List config vars (masked):**
```bash
ruby ~/.claude/skills/heroku/scripts/config_vars.rb APP
```

**Reveal config vars:**
```bash
ruby ~/.claude/skills/heroku/scripts/config_vars.rb APP --reveal
```

**List releases:**
```bash
ruby ~/.claude/skills/heroku/scripts/releases.rb APP
```

**List add-ons:**
```bash
ruby ~/.claude/skills/heroku/scripts/addons.rb APP
```

**List domains:**
```bash
ruby ~/.claude/skills/heroku/scripts/domains.rb APP
```

**List formation (scaling info):**
```bash
ruby ~/.claude/skills/heroku/scripts/formation.rb APP
```

**Get log session URL:**
```bash
ruby ~/.claude/skills/heroku/scripts/logs.rb APP
ruby ~/.claude/skills/heroku/scripts/logs.rb APP --lines 200
```

**Restart all dynos (requires user confirmation):**

Show current dynos first, then ask: "Do you want to restart all dynos for this app?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/heroku/scripts/restart.rb APP
```

**Scale a process type (requires user confirmation):**

Show current formation first, then ask: "Do you want to scale TYPE to QUANTITY?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/heroku/scripts/scale.rb APP TYPE QUANTITY
ruby ~/.claude/skills/heroku/scripts/scale.rb APP TYPE QUANTITY SIZE
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token with custom Heroku Accept header
- Token file: `~/.config/heroku/token` (outside the repo, never commit)
- Restarting dynos and scaling require explicit user confirmation
- Base URL: `https://api.heroku.com`
