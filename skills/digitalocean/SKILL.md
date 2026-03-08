---
name: digitalocean
description: Manage DigitalOcean droplets, domains, databases, apps and volumes via API v2
user-invocable: true
argument-hint: [droplet name or ID]
---

# /digitalocean

Connect to the DigitalOcean API v2 to manage droplets, domains, DNS records, managed databases, App Platform apps and volumes. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb            # Bearer token + do_request helper (required by all scripts)
├── check_setup.rb     # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb      # Save and validate an API token
├── account.rb         # Get account info
├── droplets.rb        # List all droplets
├── droplet.rb         # Get droplet details
├── create_droplet.rb  # Create a new droplet
├── droplet_action.rb  # Perform droplet action (reboot, power_off, power_on, etc.)
├── domains.rb         # List all domains
├── dns_records.rb     # List DNS records for a domain
├── databases.rb       # List managed databases
├── apps.rb            # List App Platform apps
└── volumes.rb         # List block storage volumes
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/digitalocean/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a Personal Access Token:

> You need a DigitalOcean Personal Access Token. Go to the **API** section in the DigitalOcean Control Panel:
>
> https://cloud.digitalocean.com/account/api/tokens
>
> Click **Generate New Token**, give it a name (e.g. "hitank"), select the scopes you need (read or read+write), and copy the token.
>
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/digitalocean/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a droplet name or ID.

### Step 1: Show account info

```bash
ruby ~/.claude/skills/digitalocean/scripts/account.rb
```

Present the account info to the user.

### Step 2: List droplets

```bash
ruby ~/.claude/skills/digitalocean/scripts/droplets.rb
```

Present the droplets to the user. If `$ARGUMENTS` matches a droplet name or ID, use that droplet. Otherwise ask which droplet to work with.

### Step 3: Show droplet details

```bash
ruby ~/.claude/skills/digitalocean/scripts/droplet.rb DROPLET_ID
```

Present the droplet info and ask what the user wants to do.

### Step 4: Droplet actions

**Perform a droplet action (requires user confirmation):**

Show current droplet status first, then ask: "Do you want to perform ACTION on this droplet?" Only execute after a "yes".

Supported actions: `reboot`, `power_off`, `power_on`, `shutdown`, `enable_backups`, `disable_backups`, `enable_ipv6`, `password_reset`, `snapshot`.

```bash
ruby ~/.claude/skills/digitalocean/scripts/droplet_action.rb DROPLET_ID ACTION
ruby ~/.claude/skills/digitalocean/scripts/droplet_action.rb DROPLET_ID snapshot --name "my-snapshot"
```

**Create a new droplet (requires user confirmation):**

Ask the user for name, region, size, and image. Confirm all details before creating.

```bash
ruby ~/.claude/skills/digitalocean/scripts/create_droplet.rb NAME REGION SIZE IMAGE
```

Example:
```bash
ruby ~/.claude/skills/digitalocean/scripts/create_droplet.rb my-server nyc1 s-1vcpu-1gb ubuntu-24-04-x64
```

### Step 5: Other resources

**List domains:**
```bash
ruby ~/.claude/skills/digitalocean/scripts/domains.rb
```

**List DNS records for a domain:**
```bash
ruby ~/.claude/skills/digitalocean/scripts/dns_records.rb DOMAIN_NAME
```

**List managed databases:**
```bash
ruby ~/.claude/skills/digitalocean/scripts/databases.rb
```

**List App Platform apps:**
```bash
ruby ~/.claude/skills/digitalocean/scripts/apps.rb
```

**List block storage volumes:**
```bash
ruby ~/.claude/skills/digitalocean/scripts/volumes.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token in Authorization header
- Token file: `~/.config/digitalocean/token` (outside the repo, never commit)
- Creating droplets and performing droplet actions require explicit user confirmation
- Base URL: `https://api.digitalocean.com/v2`
