---
name: openai
description: Manage OpenAI models, assistants, files and usage via REST API
user-invocable: true
argument-hint: [model or assistant ID]
---

# /openai

Connect to the OpenAI API to manage models, assistants, files, fine-tuning jobs and usage. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token + openai_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API token
├── models.rb            # List available models
├── assistants.rb        # List assistants
├── assistant.rb         # Get assistant details
├── files.rb             # List uploaded files
├── file.rb              # Get file details
├── delete_file.rb       # Delete a file
├── usage.rb             # Get usage stats (last 30 days)
└── fine_tuning_jobs.rb  # List fine-tuning jobs
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/openai/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API key:

> You need an OpenAI API key. Go to **API Keys** in the OpenAI Platform dashboard:
> https://platform.openai.com/api-keys
>
> Click **Create new secret key**, give it a name (e.g. "hitank"), and copy the key.
>
> Paste the key here.

**Step 2** — When the user pastes the key, save it:

```bash
ruby ~/.claude/skills/openai/scripts/save_token.rb 'PASTED_KEY'
```

If the script outputs an error, the key is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a model name or assistant ID.

### Step 1: List models

```bash
ruby ~/.claude/skills/openai/scripts/models.rb
```

Present the models to the user. If `$ARGUMENTS` matches a model name, highlight it.

### Step 2: List assistants

```bash
ruby ~/.claude/skills/openai/scripts/assistants.rb
```

Present the assistants. If `$ARGUMENTS` matches an assistant ID, show its details automatically.

### Step 3: Actions

**Get assistant details:**
```bash
ruby ~/.claude/skills/openai/scripts/assistant.rb ASSISTANT_ID
```

**List uploaded files:**
```bash
ruby ~/.claude/skills/openai/scripts/files.rb
```

**Get file details:**
```bash
ruby ~/.claude/skills/openai/scripts/file.rb FILE_ID
```

**Delete a file (requires user confirmation):**

Show the file details first, then ask: "Do you want to delete this file?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/openai/scripts/delete_file.rb FILE_ID
```

**Get usage stats (last 30 days):**
```bash
ruby ~/.claude/skills/openai/scripts/usage.rb
```

**List fine-tuning jobs:**
```bash
ruby ~/.claude/skills/openai/scripts/fine_tuning_jobs.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token in Authorization header
- Token file: `~/.config/openai/token` (outside the repo, never commit)
- Deleting files requires explicit user confirmation
- Assistants API requires the `OpenAI-Beta: assistants=v2` header
- Base URL: `https://api.openai.com/v1`
