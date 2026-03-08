---
name: vercel
description: Manage Vercel projects, deployments, domains and environment variables via API
user-invocable: true
argument-hint: [project name or ID]
---

# /vercel

Connect to the Vercel API to manage projects, deployments, domains, environment variables and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Bearer token + vercel_request helper (required by all scripts)
├── check_setup.rb   # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate an API token
├── projects.rb      # List all projects
├── project.rb       # Get project details
├── deployments.rb   # List deployments for a project
├── deployment.rb    # Get deployment details
├── domains.rb       # List domains
├── env_vars.rb      # List env vars (masked by default)
├── logs.rb          # Get deployment logs
└── redeploy.rb      # Redeploy a deployment
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/vercel/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need a Vercel API token. Go to **Account Settings > Tokens** on the Vercel Dashboard:
> https://vercel.com/account/tokens
>
> Click **Create** to generate a new token. Give it a descriptive name like "hitank".
>
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/vercel/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a project name or ID.

### Step 1: List projects

```bash
ruby ~/.claude/skills/vercel/scripts/projects.rb
```

Present the projects to the user. If `$ARGUMENTS` matches a project name, use that project. Otherwise ask which project to work with.

### Step 2: Show project details

```bash
ruby ~/.claude/skills/vercel/scripts/project.rb PROJECT_NAME_OR_ID
```

Present the project info and ask what the user wants to do.

### Step 3: Actions

**List deployments:**
```bash
ruby ~/.claude/skills/vercel/scripts/deployments.rb PROJECT_ID
```

**Get deployment details:**
```bash
ruby ~/.claude/skills/vercel/scripts/deployment.rb DEPLOYMENT_ID
```

**List domains:**
```bash
ruby ~/.claude/skills/vercel/scripts/domains.rb
```

**List env vars (masked):**
```bash
ruby ~/.claude/skills/vercel/scripts/env_vars.rb PROJECT_ID
```

**Reveal env vars:**
```bash
ruby ~/.claude/skills/vercel/scripts/env_vars.rb PROJECT_ID --reveal
```

**Get deployment logs:**
```bash
ruby ~/.claude/skills/vercel/scripts/logs.rb DEPLOYMENT_ID
```

**Redeploy a deployment (requires user confirmation):**

Show current deployment details first, then ask: "Do you want to redeploy this deployment?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/vercel/scripts/redeploy.rb DEPLOYMENT_ID PROJECT_NAME
ruby ~/.claude/skills/vercel/scripts/redeploy.rb DEPLOYMENT_ID PROJECT_NAME --target production
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token in Authorization header
- Token file: `~/.config/vercel/token` (outside the repo, never commit)
- Redeploying requires explicit user confirmation
- Base URL: `https://api.vercel.com`
