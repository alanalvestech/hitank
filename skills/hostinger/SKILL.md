---
name: hostinger
description: Manage Hostinger domains, DNS, hosting, subscriptions and VPS via REST API
user-invocable: true
argument-hint: [domain name]
---

# /hostinger

Connect to Hostinger to manage domains, DNS records, hosting websites, subscriptions and VPS data centers. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb                # Bearer token auth + hostinger_request helper (required by all scripts)
├── check_setup.rb         # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb          # Save and validate an API token
├── domains.rb             # List all domains in portfolio
├── domain.rb              # Get domain details
├── domain_availability.rb # Check domain availability across TLDs
├── nameservers.rb         # Update domain nameservers
├── domain_lock.rb         # Enable/disable domain lock
├── privacy.rb             # Enable/disable WHOIS privacy protection
├── dns_records.rb         # List DNS records for a domain
├── dns_update.rb          # Update DNS records
├── dns_delete.rb          # Delete DNS records
├── dns_snapshots.rb       # List DNS snapshots
├── dns_restore.rb         # Restore a DNS snapshot
├── websites.rb            # List hosting websites
├── subscriptions.rb       # List subscriptions
├── catalog.rb             # List catalog items available for order
└── vps_datacenters.rb     # List available VPS data centers
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/hostinger/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need a Hostinger API token. Go to your Hostinger panel:
>
> **hPanel > Account > API Tokens**
>
> Create a new token with the permissions you need (domains, DNS, hosting, billing).
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/hostinger/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a domain name.

### Step 1: Overview

```bash
ruby ~/.claude/skills/hostinger/scripts/domains.rb
```

Present the domains. If `$ARGUMENTS` matches a domain, use it. Otherwise ask what the user wants to do.

### Step 2: Actions

**Get domain details:**
```bash
ruby ~/.claude/skills/hostinger/scripts/domain.rb example.com
```

**Check domain availability:**
```bash
ruby ~/.claude/skills/hostinger/scripts/domain_availability.rb mysite com net io
```

**Update nameservers (requires user confirmation):**
```bash
ruby ~/.claude/skills/hostinger/scripts/nameservers.rb example.com ns1.example.com ns2.example.com
```

**Enable/disable domain lock (requires user confirmation):**
```bash
ruby ~/.claude/skills/hostinger/scripts/domain_lock.rb example.com --enable
ruby ~/.claude/skills/hostinger/scripts/domain_lock.rb example.com --disable
```

**Enable/disable WHOIS privacy (requires user confirmation):**
```bash
ruby ~/.claude/skills/hostinger/scripts/privacy.rb example.com --enable
ruby ~/.claude/skills/hostinger/scripts/privacy.rb example.com --disable
```

**List DNS records:**
```bash
ruby ~/.claude/skills/hostinger/scripts/dns_records.rb example.com
```

**Update DNS records (requires user confirmation):**
```bash
ruby ~/.claude/skills/hostinger/scripts/dns_update.rb example.com '[{"type":"A","name":"@","content":"1.2.3.4","ttl":3600}]'
```

**Delete DNS records (requires user confirmation):**
```bash
ruby ~/.claude/skills/hostinger/scripts/dns_delete.rb example.com '[{"type":"A","name":"@","content":"1.2.3.4"}]'
```

**List DNS snapshots:**
```bash
ruby ~/.claude/skills/hostinger/scripts/dns_snapshots.rb example.com
```

**Restore a DNS snapshot (requires user confirmation):**
```bash
ruby ~/.claude/skills/hostinger/scripts/dns_restore.rb example.com SNAPSHOT_ID
```

**List hosting websites:**
```bash
ruby ~/.claude/skills/hostinger/scripts/websites.rb
```

**List subscriptions:**
```bash
ruby ~/.claude/skills/hostinger/scripts/subscriptions.rb
```

**List catalog items:**
```bash
ruby ~/.claude/skills/hostinger/scripts/catalog.rb
ruby ~/.claude/skills/hostinger/scripts/catalog.rb --category hosting
```

**List VPS data centers:**
```bash
ruby ~/.claude/skills/hostinger/scripts/vps_datacenters.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token
- Token file: `~/.config/hostinger/token` (outside the repo, never commit)
- Updating nameservers, DNS records, domain lock, privacy, and restoring snapshots require explicit user confirmation
- Rate limit enforced by Hostinger (HTTP 429 when exceeded)
- Base URL: `https://developers.hostinger.com`
