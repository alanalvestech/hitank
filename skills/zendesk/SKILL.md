---
name: zendesk
description: Manage Zendesk tickets, users, organizations and knowledge base via REST API
user-invocable: true
argument-hint: [ticket ID or search query]
---

# /zendesk

Connect to the Zendesk REST API to manage tickets, users, organizations and knowledge base articles. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb           # Basic auth + zendesk_request helper (required by all scripts)
├── check_setup.rb    # Check if credentials exist (outputs OK or SETUP_NEEDED)
├── save_token.rb     # Save and validate subdomain, email, API token
├── tickets.rb        # List tickets (optional --status filter)
├── ticket.rb         # Get ticket details
├── create_ticket.rb  # Create a new ticket
├── update_ticket.rb  # Update ticket status/assignee
├── search.rb         # Search across tickets, users, organizations
├── users.rb          # List users
├── organizations.rb  # List organizations
└── articles.rb       # List knowledge base articles
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/zendesk/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user for their Zendesk subdomain:

> What is your Zendesk subdomain? This is the part before `.zendesk.com` in your URL.
>
> For example, if your Zendesk is at `https://mycompany.zendesk.com`, the subdomain is `mycompany`.

**Step 2** — Ask the user for their Zendesk email:

> What is the email address you use to log in to Zendesk?

**Step 3** — Ask the user to create an API token:

> You need a Zendesk API token. Go to **Admin Center > Apps and integrations > Zendesk API > Zendesk API Settings** and create a new token:
>
> `https://YOUR_SUBDOMAIN.zendesk.com/admin/apps-integrations/apis/zendesk-api/settings`
>
> Copy the token and paste it here.

**Step 4** — When the user provides all three values, save them:

```bash
ruby ~/.claude/skills/zendesk/scripts/save_token.rb 'SUBDOMAIN' 'EMAIL' 'API_TOKEN'
```

If the script outputs an error, the credentials are invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a ticket ID or a search query.

### Step 1: List tickets

```bash
ruby ~/.claude/skills/zendesk/scripts/tickets.rb
```

**Filter by status:**
```bash
ruby ~/.claude/skills/zendesk/scripts/tickets.rb --status open
ruby ~/.claude/skills/zendesk/scripts/tickets.rb --status pending
ruby ~/.claude/skills/zendesk/scripts/tickets.rb --status solved
```

Present the tickets to the user. If `$ARGUMENTS` matches a ticket ID, skip to Step 2. If it looks like a search query, skip to Search.

### Step 2: Show ticket details

```bash
ruby ~/.claude/skills/zendesk/scripts/ticket.rb TICKET_ID
```

Present the ticket info and ask what the user wants to do.

### Step 3: Actions

**Create a ticket (requires user confirmation):**

Ask the user for the subject and description, then confirm: "Do you want to create a ticket with subject 'X'?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/zendesk/scripts/create_ticket.rb 'SUBJECT' 'BODY'
```

**Update a ticket (requires user confirmation):**

Show current ticket details first, then ask: "Do you want to update ticket #ID?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/zendesk/scripts/update_ticket.rb TICKET_ID --status open
ruby ~/.claude/skills/zendesk/scripts/update_ticket.rb TICKET_ID --status pending
ruby ~/.claude/skills/zendesk/scripts/update_ticket.rb TICKET_ID --status solved
ruby ~/.claude/skills/zendesk/scripts/update_ticket.rb TICKET_ID --assignee USER_ID
ruby ~/.claude/skills/zendesk/scripts/update_ticket.rb TICKET_ID --comment 'Internal note text'
ruby ~/.claude/skills/zendesk/scripts/update_ticket.rb TICKET_ID --status solved --comment 'Resolved the issue'
```

**Search across tickets, users and organizations:**
```bash
ruby ~/.claude/skills/zendesk/scripts/search.rb 'QUERY'
```

**List users:**
```bash
ruby ~/.claude/skills/zendesk/scripts/users.rb
```

**List organizations:**
```bash
ruby ~/.claude/skills/zendesk/scripts/organizations.rb
```

**List knowledge base articles:**
```bash
ruby ~/.claude/skills/zendesk/scripts/articles.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils, base64)
- Auth via Basic authentication: `{email}/token:{api_token}` (Base64 encoded)
- Config files in `~/.config/zendesk/` — subdomain, email, token (outside the repo, never commit)
- Creating and updating tickets require explicit user confirmation
- Base URL: `https://{subdomain}.zendesk.com/api/v2`
