---
name: resend
description: Send emails, manage domains, contacts and broadcasts via Resend API
user-invocable: true
argument-hint: [action or email address]
---

# /resend

Connect to Resend to send transactional emails, manage domains, contacts, broadcasts and API keys. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token auth + resend_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API key
├── send_email.rb        # Send an email
├── email.rb             # Get email details
├── emails.rb            # List sent emails
├── cancel_email.rb      # Cancel a scheduled email
├── domains.rb           # List domains
├── domain.rb            # Get domain details with DNS records
├── create_domain.rb     # Create a domain
├── verify_domain.rb     # Verify a domain
├── delete_domain.rb     # Delete a domain
├── contacts.rb          # List contacts
├── create_contact.rb    # Create a contact
├── delete_contact.rb    # Delete a contact
├── broadcasts.rb        # List broadcasts
├── create_broadcast.rb  # Create a broadcast
├── send_broadcast.rb    # Send a broadcast
├── delete_broadcast.rb  # Delete a broadcast
├── api_keys.rb          # List API keys
├── create_api_key.rb    # Create an API key
└── delete_api_key.rb    # Delete an API key
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/resend/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their API key:

> You need a Resend API key.
>
> 1. Go to https://resend.com/api-keys
> 2. Click **Create API Key**
> 3. Choose a name and permission level (full-access or sending-access)
> 4. Copy the key (starts with `re_`)
>
> Paste the API key here.

**Step 2** — When the user pastes the key, save it:

```bash
ruby ~/.claude/skills/resend/scripts/save_token.rb 'PASTED_KEY'
```

If the script outputs an error, the key is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain an action or email address.

### Step 1: List domains

```bash
ruby ~/.claude/skills/resend/scripts/domains.rb
```

Present the domains and ask what the user wants to do.

### Step 2: Actions

**Send an email (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/send_email.rb "Me <me@example.com>" "user@example.com" "Hello" --html "<h1>Hi!</h1>"
ruby ~/.claude/skills/resend/scripts/send_email.rb "me@example.com" "user@example.com" "Hello" --text "Plain text body"
```

**Get email details:**
```bash
ruby ~/.claude/skills/resend/scripts/email.rb EMAIL_ID
```

**List sent emails:**
```bash
ruby ~/.claude/skills/resend/scripts/emails.rb
```

**Cancel a scheduled email (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/cancel_email.rb EMAIL_ID
```

**Create a domain (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/create_domain.rb example.com
ruby ~/.claude/skills/resend/scripts/create_domain.rb example.com --region sa-east-1
```

Regions: `us-east-1` (default), `eu-west-1`, `sa-east-1`, `ap-northeast-1`

**Get domain details:**
```bash
ruby ~/.claude/skills/resend/scripts/domain.rb DOMAIN_ID
```

**Verify a domain:**
```bash
ruby ~/.claude/skills/resend/scripts/verify_domain.rb DOMAIN_ID
```

**Delete a domain (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/delete_domain.rb DOMAIN_ID
```

**List contacts:**
```bash
ruby ~/.claude/skills/resend/scripts/contacts.rb
```

**Create a contact (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/create_contact.rb "user@example.com" --first-name "John" --last-name "Doe"
```

**Delete a contact (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/delete_contact.rb CONTACT_ID
```

**List broadcasts:**
```bash
ruby ~/.claude/skills/resend/scripts/broadcasts.rb
```

**Create a broadcast (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/create_broadcast.rb SEGMENT_ID "Me <me@example.com>" "Newsletter" --html "<h1>News</h1>" --name "March Newsletter"
```

Add `--send` to send immediately after creation.

**Send a broadcast (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/send_broadcast.rb BROADCAST_ID
ruby ~/.claude/skills/resend/scripts/send_broadcast.rb BROADCAST_ID --scheduled-at "2026-03-10T10:00:00Z"
```

**Delete a broadcast (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/delete_broadcast.rb BROADCAST_ID
```

**List API keys:**
```bash
ruby ~/.claude/skills/resend/scripts/api_keys.rb
```

**Create an API key (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/create_api_key.rb "my-key" --permission sending-access --domain-id DOMAIN_ID
```

**Delete an API key (requires user confirmation):**
```bash
ruby ~/.claude/skills/resend/scripts/delete_api_key.rb API_KEY_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token (API key starting with `re_`)
- Token file: `~/.config/resend/token` (outside the repo, never commit)
- Requires `User-Agent` header (included automatically in auth helper)
- Rate limit: 2 requests/second per team
- Sending emails, managing domains/contacts/broadcasts, and API key operations require explicit user confirmation
- Sender address format: `"Name <email@domain.com>"` or plain `"email@domain.com"`
- Scheduled emails support ISO 8601 or natural language dates
- Base URL: `https://api.resend.com`
