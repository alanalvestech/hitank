---
name: sentry
description: Monitor and manage Sentry issues, events, releases and projects via API
user-invocable: true
argument-hint: [org or project slug]
---

# /sentry

Connect to the Sentry API to monitor issues, browse events, manage releases and resolve errors. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Bearer token + sentry_request helper (required by all scripts)
├── check_setup.rb   # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate an API token
├── organizations.rb # List organizations
├── projects.rb      # List projects for an organization
├── issues.rb        # List issues for a project (optional --query flag)
├── issue.rb         # Get issue details
├── events.rb        # List events for an issue
├── resolve.rb       # Resolve an issue (requires confirmation)
└── releases.rb      # List releases for an organization
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/sentry/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need a Sentry Auth Token. Go to **User Settings > Auth Tokens** in Sentry:
>
> https://sentry.io/settings/account/api/auth-tokens/
>
> Create a new token with the following scopes:
> - `project:read`
> - `org:read`
> - `event:read`
> - `issue:admin` (needed to resolve issues)
>
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/sentry/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an org slug or project slug.

### Step 1: List organizations

```bash
ruby ~/.claude/skills/sentry/scripts/organizations.rb
```

Present the organizations to the user. If `$ARGUMENTS` matches an org slug, use that org. Otherwise ask which org to work with.

### Step 2: List projects

```bash
ruby ~/.claude/skills/sentry/scripts/projects.rb ORG_SLUG
```

Present the projects to the user. If `$ARGUMENTS` matches a project slug, use that project. Otherwise ask which project to work with.

### Step 3: Actions

**List issues (most recent, unresolved by default):**
```bash
ruby ~/.claude/skills/sentry/scripts/issues.rb ORG PROJECT
```

**Search issues with a query:**
```bash
ruby ~/.claude/skills/sentry/scripts/issues.rb ORG PROJECT --query "is:unresolved level:error"
```

**Get issue details:**
```bash
ruby ~/.claude/skills/sentry/scripts/issue.rb ISSUE_ID
```

**List events for an issue:**
```bash
ruby ~/.claude/skills/sentry/scripts/events.rb ISSUE_ID
```

**Resolve an issue (requires user confirmation):**

Show the issue details first, then ask: "Do you want to resolve this issue?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/sentry/scripts/resolve.rb ISSUE_ID
```

**List releases for an organization:**
```bash
ruby ~/.claude/skills/sentry/scripts/releases.rb ORG_SLUG
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token
- Token file: `~/.config/sentry/token` (outside the repo, never commit)
- Resolving issues requires explicit user confirmation
- Base URL: `https://sentry.io/api/0`
