---
name: discord
description: Manage Discord servers, channels, messages and members via Bot API
user-invocable: true
argument-hint: [server name or channel]
---

# /discord

Connect to Discord to manage servers, send messages, read channels, react, pin, create threads and more. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb            # Bot token auth + discord_request helper (required by all scripts)
├── check_setup.rb     # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb      # Save and validate a bot token
├── guilds.rb          # List servers the bot is in
├── channels.rb        # List channels in a server
├── messages.rb        # Read messages from a channel
├── send_message.rb    # Send a message to a channel
├── edit_message.rb    # Edit a message
├── delete_message.rb  # Delete a message
├── react.rb           # Add a reaction to a message
├── pin.rb             # Pin a message
├── members.rb         # List members in a server
├── roles.rb           # List roles in a server
└── thread_create.rb   # Create a thread from a message
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/discord/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a Discord bot and get the token:

> You need a Discord Bot token. Go to the Discord Developer Portal:
> https://discord.com/developers/applications
>
> 1. Click **New Application**, give it a name
> 2. Go to **Bot** in the left menu
> 3. Click **Reset Token** and copy the token
> 4. Under **Privileged Gateway Intents**, enable **Server Members Intent** and **Message Content Intent**
> 5. Go to **OAuth2 > URL Generator**, select scope **bot**, then select permissions: **Read Messages/View Channels**, **Send Messages**, **Manage Messages**, **Read Message History**, **Add Reactions**
> 6. Copy the generated URL and open it to invite the bot to your server
>
> Paste the bot token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/discord/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a server name or channel reference.

### Step 1: List servers

```bash
ruby ~/.claude/skills/discord/scripts/guilds.rb
```

Present the servers. If there is only one, use it automatically. Otherwise ask which server to work with.

### Step 2: List channels

```bash
ruby ~/.claude/skills/discord/scripts/channels.rb GUILD_ID
ruby ~/.claude/skills/discord/scripts/channels.rb GUILD_ID --type 0
```

Show text channels (type 0) by default. Ask which channel to work with.

### Step 3: Actions

**Read messages:**
```bash
ruby ~/.claude/skills/discord/scripts/messages.rb CHANNEL_ID
ruby ~/.claude/skills/discord/scripts/messages.rb CHANNEL_ID --limit 50
```

**Send a message (requires user confirmation):**

Show the message content first, then ask to confirm before sending.

```bash
ruby ~/.claude/skills/discord/scripts/send_message.rb CHANNEL_ID "Hello from HiTank!"
```

**Edit a message (requires user confirmation):**
```bash
ruby ~/.claude/skills/discord/scripts/edit_message.rb CHANNEL_ID MESSAGE_ID "Updated content"
```

**Delete a message (requires user confirmation):**

Show the message first, then ask: "Do you want to delete this message?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/discord/scripts/delete_message.rb CHANNEL_ID MESSAGE_ID
```

**React to a message (requires user confirmation):**
```bash
ruby ~/.claude/skills/discord/scripts/react.rb CHANNEL_ID MESSAGE_ID "✅"
```

**Pin a message (requires user confirmation):**
```bash
ruby ~/.claude/skills/discord/scripts/pin.rb CHANNEL_ID MESSAGE_ID
```

**Create a thread (requires user confirmation):**
```bash
ruby ~/.claude/skills/discord/scripts/thread_create.rb CHANNEL_ID MESSAGE_ID "Thread Name"
```

**List members:**
```bash
ruby ~/.claude/skills/discord/scripts/members.rb GUILD_ID
ruby ~/.claude/skills/discord/scripts/members.rb GUILD_ID --limit 100
```

**List roles:**
```bash
ruby ~/.claude/skills/discord/scripts/roles.rb GUILD_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bot token (`Authorization: Bot TOKEN`)
- Token file: `~/.config/discord/token` (outside the repo, never commit)
- Sending, editing, deleting messages, reacting, pinning, and creating threads require explicit user confirmation
- Mention users as `<@USER_ID>` in message content
- Avoid Markdown tables in outbound Discord messages
- Rate limit: Discord uses per-route rate limits — check `X-RateLimit-*` headers
- Base URL: `https://discord.com/api/v10`
