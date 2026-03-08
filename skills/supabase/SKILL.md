---
name: supabase
description: Manage Supabase projects, edge functions, secrets and API keys via Management API
user-invocable: true
argument-hint: [project ref or name]
---

# /supabase

Connect to the Supabase Management API to manage projects, edge functions, secrets, API keys and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Bearer token + supabase_request helper (required by all scripts)
├── check_setup.rb   # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate an API token
├── projects.rb      # List all projects
├── project.rb       # Get project details
├── functions.rb     # List edge functions for a project
├── function.rb      # Get edge function details
├── secrets.rb       # List secrets (masked)
├── api_keys.rb      # List API keys for a project
├── pause.rb         # Pause a project
└── restore.rb       # Restore a paused project
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/supabase/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an access token:

> You need a Supabase access token. Go to **Account Settings > Access Tokens** on the Supabase Dashboard:
> https://supabase.com/dashboard/account/tokens
>
> Click **Generate new token**, give it a name (e.g. "hitank"), and copy the token.
>
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/supabase/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a project ref or name.

### Step 1: List projects

```bash
ruby ~/.claude/skills/supabase/scripts/projects.rb
```

Present the projects to the user. If `$ARGUMENTS` matches a project ref or name, use that project. Otherwise ask which project to work with.

### Step 2: Show project details

```bash
ruby ~/.claude/skills/supabase/scripts/project.rb PROJECT_REF
```

Present the project info and ask what the user wants to do.

### Step 3: Actions

**List edge functions:**
```bash
ruby ~/.claude/skills/supabase/scripts/functions.rb PROJECT_REF
```

**Get edge function details:**
```bash
ruby ~/.claude/skills/supabase/scripts/function.rb PROJECT_REF FUNCTION_SLUG
```

**List secrets (masked):**
```bash
ruby ~/.claude/skills/supabase/scripts/secrets.rb PROJECT_REF
```

**List API keys:**
```bash
ruby ~/.claude/skills/supabase/scripts/api_keys.rb PROJECT_REF
```

**Pause project (requires user confirmation):**

Show project status first, then ask: "Do you want to pause this project?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/supabase/scripts/pause.rb PROJECT_REF
```

**Restore project (requires user confirmation):**

Show project status first, then ask: "Do you want to restore this project?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/supabase/scripts/restore.rb PROJECT_REF
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token in Authorization header
- Token file: `~/.config/supabase/token` (outside the repo, never commit)
- Pausing and restoring projects require explicit user confirmation
- Base URL: `https://api.supabase.com/v1`
- Project ref is the unique identifier for each Supabase project (e.g. `abcdefghijklmnop`)
