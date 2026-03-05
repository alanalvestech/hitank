---
name: appsignal
description: Monitor AppSignal apps — graphs, markers, samples and sourcemaps via REST API
user-invocable: true
argument-hint: [action or app id]
---

# /appsignal

Connect to AppSignal to monitor application performance, manage deploy markers, inspect error/performance samples and upload sourcemaps. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Token auth + appsignal_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API key
├── graphs.rb            # Get graph data (mean, count, exceptions, percentile)
├── markers.rb           # List markers (deploy/custom)
├── marker.rb            # Get marker details
├── create_marker.rb     # Create a deploy or custom marker
├── update_marker.rb     # Update a marker
├── delete_marker.rb     # Delete a marker
├── samples.rb           # List samples (all, performance or errors)
├── sample.rb            # Get sample details
└── upload_sourcemap.rb  # Upload a sourcemap file
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/appsignal/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their personal API key:

> You need an AppSignal personal API key.
>
> 1. Go to https://appsignal.com/users/edit
> 2. Copy your **Personal API token**
>
> Paste the API key here.

**Step 2** — When the user pastes the key, save it:

```bash
ruby ~/.claude/skills/appsignal/scripts/save_token.rb 'PASTED_KEY'
```

If the script outputs an error, the key is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or app id.

All endpoints require an `app_id`. Ask the user for it if not provided. The app_id is visible in AppSignal URLs (e.g. `appsignal.com/org/sites/APP_ID`).

### Step 1: List markers to confirm connectivity

```bash
ruby ~/.claude/skills/appsignal/scripts/markers.rb APP_ID --limit 5
```

Present the markers and ask what the user wants to do.

### Step 2: Actions

**Get graph data:**
```bash
ruby ~/.claude/skills/appsignal/scripts/graphs.rb APP_ID --timeframe day --fields mean,count
ruby ~/.claude/skills/appsignal/scripts/graphs.rb APP_ID --action "BlogPostsController-hash-show" --fields mean,pct --from "2025-01-01T00:00:00Z" --to "2025-01-02T00:00:00Z"
ruby ~/.claude/skills/appsignal/scripts/graphs.rb APP_ID --kind web --fields mean,count,ex_count,ex_rate
```

**List markers:**
```bash
ruby ~/.claude/skills/appsignal/scripts/markers.rb APP_ID
ruby ~/.claude/skills/appsignal/scripts/markers.rb APP_ID --limit 10 --kind custom
ruby ~/.claude/skills/appsignal/scripts/markers.rb APP_ID --from "2025-01-01T00:00:00Z" --to "2025-02-01T00:00:00Z"
ruby ~/.claude/skills/appsignal/scripts/markers.rb APP_ID --count_only true
```

**Get marker details:**
```bash
ruby ~/.claude/skills/appsignal/scripts/marker.rb APP_ID MARKER_ID
```

**Create a deploy marker (requires user confirmation):**
```bash
ruby ~/.claude/skills/appsignal/scripts/create_marker.rb APP_ID --kind deploy --repository "git@github.com:company/repo.git" --revision "abc123" --user "deployer"
```

**Create a custom marker (requires user confirmation):**
```bash
ruby ~/.claude/skills/appsignal/scripts/create_marker.rb APP_ID --kind custom --icon "🚀" --message "Released v2.0"
```

**Update a marker (requires user confirmation):**
```bash
ruby ~/.claude/skills/appsignal/scripts/update_marker.rb APP_ID MARKER_ID --message "Updated deploy note"
```

**Delete a marker (requires user confirmation):**
```bash
ruby ~/.claude/skills/appsignal/scripts/delete_marker.rb APP_ID MARKER_ID
```

**List samples:**
```bash
ruby ~/.claude/skills/appsignal/scripts/samples.rb APP_ID
ruby ~/.claude/skills/appsignal/scripts/samples.rb APP_ID --type performance --limit 5
ruby ~/.claude/skills/appsignal/scripts/samples.rb APP_ID --type errors --action "AccountsController-hash-index" --exception "NoMethodError"
ruby ~/.claude/skills/appsignal/scripts/samples.rb APP_ID --since 1374843246 --before 1374929646
ruby ~/.claude/skills/appsignal/scripts/samples.rb APP_ID --count_only true
```

**Get sample details:**
```bash
ruby ~/.claude/skills/appsignal/scripts/sample.rb APP_ID SAMPLE_ID
```

**Upload a sourcemap (requires user confirmation):**
```bash
ruby ~/.claude/skills/appsignal/scripts/upload_sourcemap.rb --push_api_key PUSH_KEY --app_name "MyApp" --environment production --revision "abc123" --name "https://example.com/app.min.js" --file /path/to/app.js.map
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via personal API token passed as `?token=` query parameter
- Token file: `~/.config/appsignal/token` (outside the repo, never commit)
- Base URL: `https://appsignal.com/api`
- All endpoints use `.json` suffix
- Action names must escape `#` → `-hash-`, `/` → `-slash-`, `.` → `-dot-`
- Sourcemap uploads use a different auth method (Push API key, not personal token)
- Creating, updating and deleting markers requires explicit user confirmation
- Uploading sourcemaps requires explicit user confirmation
