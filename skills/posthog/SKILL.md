---
name: posthog
description: Manage PostHog projects, events, feature flags and insights via API
user-invocable: true
argument-hint: [project ID or event name]
---

# /posthog

Connect to the PostHog API to manage projects, events, persons, feature flags, insights and annotations. Works with PostHog Cloud and self-hosted instances. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Bearer token + posthog_request helper (required by all scripts)
├── check_setup.rb   # Check if token and host are configured (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate an API token (+ optional host)
├── projects.rb      # List all projects
├── events.rb        # List recent events for a project
├── persons.rb       # List persons for a project
├── feature_flags.rb # List feature flags for a project
├── feature_flag.rb  # Get feature flag details
├── toggle_flag.rb   # Toggle a feature flag on/off
├── insights.rb      # List saved insights for a project
└── annotations.rb   # List annotations for a project
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/posthog/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a Personal API Key:

> You need a PostHog Personal API Key. Go to **Project Settings > Personal API Keys** in your PostHog dashboard:
>
> https://app.posthog.com/settings/user-api-keys
>
> Click **Create personal API key**, give it a label (e.g. "hitank"), and copy the key.
>
> Paste the key here.

**Step 2** — Ask if the user is on PostHog Cloud or self-hosted:

> Are you using **PostHog Cloud** (app.posthog.com) or a **self-hosted** instance?
>
> - If Cloud, just paste your token.
> - If self-hosted, also provide your PostHog URL (e.g. `https://posthog.yourcompany.com`).

**Step 3** — When the user pastes the token (and optional host), save it:

For PostHog Cloud:
```bash
ruby ~/.claude/skills/posthog/scripts/save_token.rb 'PASTED_TOKEN'
```

For self-hosted:
```bash
ruby ~/.claude/skills/posthog/scripts/save_token.rb 'PASTED_TOKEN' 'https://posthog.yourcompany.com'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a project ID or event name.

### Step 1: List projects

```bash
ruby ~/.claude/skills/posthog/scripts/projects.rb
```

Present the projects to the user. If `$ARGUMENTS` matches a project ID, use that project. Otherwise ask which project to work with.

### Step 2: Actions

Once a project is selected, ask what the user wants to do and run the appropriate script.

**List recent events:**
```bash
ruby ~/.claude/skills/posthog/scripts/events.rb PROJECT_ID
```

**Filter events by name:**
```bash
ruby ~/.claude/skills/posthog/scripts/events.rb PROJECT_ID --event '$pageview'
```

**List persons:**
```bash
ruby ~/.claude/skills/posthog/scripts/persons.rb PROJECT_ID
```

**List feature flags:**
```bash
ruby ~/.claude/skills/posthog/scripts/feature_flags.rb PROJECT_ID
```

**Get feature flag details:**
```bash
ruby ~/.claude/skills/posthog/scripts/feature_flag.rb PROJECT_ID FLAG_ID
```

**Toggle a feature flag (requires user confirmation):**

Show flag details first, then ask: "Do you want to toggle this flag to active/inactive?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/posthog/scripts/toggle_flag.rb PROJECT_ID FLAG_ID true
ruby ~/.claude/skills/posthog/scripts/toggle_flag.rb PROJECT_ID FLAG_ID false
```

**List saved insights:**
```bash
ruby ~/.claude/skills/posthog/scripts/insights.rb PROJECT_ID
```

**List annotations:**
```bash
ruby ~/.claude/skills/posthog/scripts/annotations.rb PROJECT_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (Personal API Key)
- Token file: `~/.config/posthog/token` (outside the repo, never commit)
- Host file: `~/.config/posthog/host` (defaults to `https://app.posthog.com` for Cloud)
- Toggling feature flags requires explicit user confirmation
- Base URL is read from the host file at runtime
