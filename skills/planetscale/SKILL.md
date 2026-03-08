---
name: planetscale
description: Manage PlanetScale databases, branches, deploy requests and backups via REST API
user-invocable: true
argument-hint: [database name]
---

# /planetscale

Connect to the PlanetScale REST API to manage databases, branches, deploy requests, backups and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb                # Basic auth + ps_request helper (required by all scripts)
├── check_setup.rb         # Check if credentials exist (outputs OK or SETUP_NEEDED)
├── save_token.rb          # Save and validate service token credentials
├── organizations.rb       # List organizations
├── databases.rb           # List databases for an organization
├── database.rb            # Get database details
├── branches.rb            # List branches for a database
├── branch.rb              # Get branch details
├── create_branch.rb       # Create a new branch
├── deploy_requests.rb     # List deploy requests for a database
├── create_deploy_request.rb # Create a deploy request
└── backups.rb             # List backups for a database
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/planetscale/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a service token:

> You need a PlanetScale service token. Go to your PlanetScale organization settings:
>
> 1. Open **Settings → Service tokens** in the PlanetScale dashboard
> 2. Click **New service token**
> 3. Name it (e.g. "hitank") and grant the desired database access permissions
> 4. Copy both the **Service token ID** and the **Service token** value
>
> https://app.planetscale.com
>
> Paste the **Service token ID** first.

**Step 2** — When the user pastes the token ID, ask for the token:

> Now paste the **Service token** value.

**Step 3** — When the user pastes the token, save both credentials:

```bash
ruby ~/.claude/skills/planetscale/scripts/save_token.rb 'PASTED_TOKEN_ID' 'PASTED_TOKEN'
```

If the script outputs an error, the credentials are invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a database name.

### Step 1: List organizations

```bash
ruby ~/.claude/skills/planetscale/scripts/organizations.rb
```

Present the organizations to the user. If there is only one, use it automatically. Otherwise ask which org to work with.

### Step 2: List databases

```bash
ruby ~/.claude/skills/planetscale/scripts/databases.rb ORG
```

Present the databases to the user. If `$ARGUMENTS` matches a database name, use that database. Otherwise ask which database to work with.

### Step 3: Show database details

```bash
ruby ~/.claude/skills/planetscale/scripts/database.rb ORG DATABASE
```

Present the database info and ask what the user wants to do.

### Step 4: Actions

**List branches:**
```bash
ruby ~/.claude/skills/planetscale/scripts/branches.rb ORG DATABASE
```

**Get branch details:**
```bash
ruby ~/.claude/skills/planetscale/scripts/branch.rb ORG DATABASE BRANCH
```

**Create a branch (requires user confirmation):**

Ask: "Do you want to create a new branch named BRANCH_NAME from PARENT_BRANCH?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/planetscale/scripts/create_branch.rb ORG DATABASE BRANCH_NAME
ruby ~/.claude/skills/planetscale/scripts/create_branch.rb ORG DATABASE BRANCH_NAME PARENT_BRANCH
```

**List deploy requests:**
```bash
ruby ~/.claude/skills/planetscale/scripts/deploy_requests.rb ORG DATABASE
```

**Create a deploy request (requires user confirmation):**

Show current branches first, then ask: "Do you want to create a deploy request from BRANCH to DEPLOY_TO?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/planetscale/scripts/create_deploy_request.rb ORG DATABASE BRANCH
ruby ~/.claude/skills/planetscale/scripts/create_deploy_request.rb ORG DATABASE BRANCH DEPLOY_TO
```

**List backups:**
```bash
ruby ~/.claude/skills/planetscale/scripts/backups.rb ORG DATABASE
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via service token: `Authorization: {service_token_id}:{service_token}`
- Config files: `~/.config/planetscale/token_id` and `~/.config/planetscale/token` (outside the repo, never commit)
- Creating branches and deploy requests require explicit user confirmation
- Base URL: `https://api.planetscale.com/v1`
