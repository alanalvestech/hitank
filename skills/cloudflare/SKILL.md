---
name: cloudflare
description: Manage Cloudflare zones, DNS records, Workers, Pages and cache via API
user-invocable: true
argument-hint: [zone name or account ID]
---

# /cloudflare

Connect to the Cloudflare API to manage zones (domains), DNS records, Workers, Pages projects and cache purging. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb            # Bearer token + cf_request helper (required by all scripts)
├── check_setup.rb     # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb      # Save and validate an API token
├── zones.rb           # List all zones (domains)
├── zone.rb            # Get zone details
├── dns_records.rb     # List DNS records for a zone
├── create_dns.rb      # Create a DNS record
├── delete_dns.rb      # Delete a DNS record
├── workers.rb         # List Workers scripts for an account
├── pages_projects.rb  # List Pages projects for an account
└── purge_cache.rb     # Purge all cache for a zone
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/cloudflare/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need a Cloudflare API token. Go to the Cloudflare dashboard and create one:
>
> https://dash.cloudflare.com/profile/api-tokens
>
> Click **Create Token**. You can use the **Edit zone DNS** template for DNS management, or create a custom token with the permissions you need (Zone:Read, DNS:Edit, Workers:Read, Pages:Read, Cache Purge).
>
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/cloudflare/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a zone name or account ID.

### Step 1: List zones

```bash
ruby ~/.claude/skills/cloudflare/scripts/zones.rb
```

Present the zones to the user. If `$ARGUMENTS` matches a zone name, use that zone. Otherwise ask which zone to work with.

### Step 2: Show zone details

```bash
ruby ~/.claude/skills/cloudflare/scripts/zone.rb ZONE_ID
```

Present the zone info and ask what the user wants to do.

### Step 3: Actions

**List DNS records:**
```bash
ruby ~/.claude/skills/cloudflare/scripts/dns_records.rb ZONE_ID
```

**Create a DNS record (requires user confirmation):**

Ask the user for the record type, name, content and whether it should be proxied. Then confirm: "Do you want to create a TYPE record for NAME pointing to CONTENT?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/cloudflare/scripts/create_dns.rb ZONE_ID TYPE NAME CONTENT
ruby ~/.claude/skills/cloudflare/scripts/create_dns.rb ZONE_ID TYPE NAME CONTENT --proxied
ruby ~/.claude/skills/cloudflare/scripts/create_dns.rb ZONE_ID TYPE NAME CONTENT --ttl 300
```

**Delete a DNS record (requires user confirmation):**

Show the record details first, then ask: "Do you want to delete this DNS record?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/cloudflare/scripts/delete_dns.rb ZONE_ID RECORD_ID
```

**Purge all cache (requires user confirmation):**

Ask: "Do you want to purge the entire cache for this zone? This will remove all cached files." Only execute after a "yes".

```bash
ruby ~/.claude/skills/cloudflare/scripts/purge_cache.rb ZONE_ID
```

**List Workers (requires account ID):**

The account ID can be found in the zone details output. If not available, ask the user.

```bash
ruby ~/.claude/skills/cloudflare/scripts/workers.rb ACCOUNT_ID
```

**List Pages projects (requires account ID):**

```bash
ruby ~/.claude/skills/cloudflare/scripts/pages_projects.rb ACCOUNT_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token
- Token file: `~/.config/cloudflare/token` (outside the repo, never commit)
- Creating DNS records, deleting DNS records, and purging cache require explicit user confirmation
- Base URL: `https://api.cloudflare.com/client/v4`
