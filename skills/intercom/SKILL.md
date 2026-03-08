---
name: intercom
description: "Manage Intercom conversations, contacts, articles and help center via REST API"
user-invocable: true
argument-hint: [conversation ID or contact email]
---

# /intercom

Connect to the Intercom REST API to manage conversations, contacts, articles and your help center. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # Bearer token + intercom_request helper (required by all scripts)
├── check_setup.rb   # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate an API token
├── admins.rb        # List admins/teammates
├── conversations.rb # List conversations
├── conversation.rb  # Get conversation details
├── reply.rb         # Reply to a conversation
├── contacts.rb      # List or search contacts
├── contact.rb       # Get contact details
├── articles.rb      # List help center articles
└── article.rb       # Get article details
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/intercom/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an API token:

> You need an Intercom API access token. Go to your Intercom Developer Hub:
>
> 1. Navigate to **Settings > Integrations > Developer Hub** in your Intercom workspace
> 2. Create or select an app, then go to **Authentication**
> 3. Copy the **Access Token**
>
> Or visit: https://app.intercom.com/a/apps/_/developer-hub
>
> Copy the token and paste it here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/intercom/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a conversation ID or contact email.

### Step 1: Overview

If `$ARGUMENTS` looks like a conversation ID (numeric), jump to Step 2b.
If `$ARGUMENTS` looks like an email address, jump to Step 3b.
Otherwise, ask the user what they want to do: conversations, contacts, or articles.

### Step 2: Conversations

**List recent conversations:**
```bash
ruby ~/.claude/skills/intercom/scripts/conversations.rb
```

Present the conversations to the user and ask which one to view.

**Get conversation details:**
```bash
ruby ~/.claude/skills/intercom/scripts/conversation.rb CONVERSATION_ID
```

Present the conversation with its messages and ask if the user wants to reply.

**Reply to a conversation (requires user confirmation):**

First, list admins to get the admin ID:
```bash
ruby ~/.claude/skills/intercom/scripts/admins.rb
```

Then ask: "Do you want to reply to this conversation as ADMIN_NAME?" Show the reply body. Only execute after a "yes".

```bash
ruby ~/.claude/skills/intercom/scripts/reply.rb CONVERSATION_ID --admin_id ADMIN_ID --body "Reply text here"
```

### Step 3: Contacts

**List contacts:**
```bash
ruby ~/.claude/skills/intercom/scripts/contacts.rb
```

**Search contacts by email:**
```bash
ruby ~/.claude/skills/intercom/scripts/contacts.rb --email user@example.com
```

**Get contact details:**
```bash
ruby ~/.claude/skills/intercom/scripts/contact.rb CONTACT_ID
```

### Step 4: Articles

**List help center articles:**
```bash
ruby ~/.claude/skills/intercom/scripts/articles.rb
```

**Get article details:**
```bash
ruby ~/.claude/skills/intercom/scripts/article.rb ARTICLE_ID
```

### Step 5: Admins

**List admins/teammates:**
```bash
ruby ~/.claude/skills/intercom/scripts/admins.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token with `Intercom-Version: 2.11` header
- Token file: `~/.config/intercom/token` (outside the repo, never commit)
- Replying to conversations requires explicit user confirmation
- Base URL: `https://api.intercom.io`
