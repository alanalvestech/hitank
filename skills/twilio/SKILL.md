---
name: twilio
description: Manage Twilio SMS, calls, phone numbers and usage via REST API
user-invocable: true
argument-hint: [phone number or SID]
---

# /twilio

Connect to the Twilio REST API to manage messages, calls, phone numbers, usage and account info. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Basic Auth (account_sid:auth_token) + twilio_request helper (required by all scripts)
├── check_setup.rb   # Check if credentials exist (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate Twilio credentials
├── messages.rb      # List messages (optional --to or --from filter)
├── message.rb       # Get message details by SID
├── send_sms.rb      # Send an SMS message (requires confirmation)
├── calls.rb         # List calls
├── numbers.rb       # List incoming phone numbers
├── account.rb       # Get account info
└── usage.rb         # Get usage records
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/twilio/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to get their credentials:

> You need your Twilio Account SID and Auth Token. You can find both on the Twilio Console dashboard:
>
> https://console.twilio.com/
>
> Look for **Account SID** and **Auth Token** near the top of the page. Copy both values.

**Step 2** — When the user pastes the credentials, save them:

```bash
ruby ~/.claude/skills/twilio/scripts/save_token.rb 'ACCOUNT_SID' 'AUTH_TOKEN'
```

If the script outputs an error, the credentials are invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a phone number or message/call SID.

### Step 1: Show account info

```bash
ruby ~/.claude/skills/twilio/scripts/account.rb
```

Present the account info to the user and ask what they want to do.

### Step 2: Actions

**List messages:**
```bash
ruby ~/.claude/skills/twilio/scripts/messages.rb
ruby ~/.claude/skills/twilio/scripts/messages.rb --to '+15551234567'
ruby ~/.claude/skills/twilio/scripts/messages.rb --from '+15559876543'
```

**Get message details:**
```bash
ruby ~/.claude/skills/twilio/scripts/message.rb MESSAGE_SID
```

**Send SMS (requires user confirmation):**

Ask the user to confirm: "Do you want to send an SMS from FROM_NUMBER to TO_NUMBER with this message?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/twilio/scripts/send_sms.rb --from '+15551234567' --to '+15559876543' --body 'Hello from hitank!'
```

**List calls:**
```bash
ruby ~/.claude/skills/twilio/scripts/calls.rb
```

**List phone numbers:**
```bash
ruby ~/.claude/skills/twilio/scripts/numbers.rb
```

**Get usage records:**
```bash
ruby ~/.claude/skills/twilio/scripts/usage.rb
```

If `$ARGUMENTS` looks like a phone number, search messages with `--to` or `--from` that number. If it looks like a message SID (starts with `SM`), get message details. If it looks like a call SID (starts with `CA`), mention it.

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via HTTP Basic Auth (Account SID as username, Auth Token as password)
- Credentials file: `~/.config/twilio/credentials` (outside the repo, never commit)
- Stores credentials as `account_sid:auth_token`
- Sending SMS requires explicit user confirmation
- Twilio API uses form-encoded POST bodies (not JSON)
- Base URL: `https://api.twilio.com/2010-04-01`
