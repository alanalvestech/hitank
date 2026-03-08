---
name: x
description: "Post and manage tweets on X (formerly Twitter) via API v2"
user-invocable: true
argument-hint: [tweet text or ID]
---

# /x

Connect to the X (formerly Twitter) API v2 to post tweets, search, view timelines and manage likes. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb          # OAuth 1.0a signature + twitter_request helper (required by all scripts)
├── check_setup.rb   # Check if credentials exist (outputs OK or SETUP_NEEDED)
├── save_token.rb    # Save and validate API credentials
├── me.rb            # Get authenticated user info
├── tweets.rb        # List recent tweets for a user
├── tweet.rb         # Get tweet details by ID
├── post_tweet.rb    # Post a new tweet (requires confirmation)
├── delete_tweet.rb  # Delete a tweet (requires confirmation)
├── search.rb        # Search recent tweets
├── likes.rb         # List liked tweets
└── like.rb          # Like a tweet (requires confirmation)
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/x/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a Twitter Developer app:

> You need Twitter API credentials. Go to the Developer Portal and create a project and app:
>
> https://developer.x.com/en/portal/dashboard
>
> 1. Create a new Project (or use an existing one)
> 2. Create an App inside that project

**Step 2** — Ask the user to generate credentials:

> In your app settings, go to **"Keys and tokens"** and generate all 4 credentials:
>
> - **API Key** (also called Consumer Key)
> - **API Key Secret** (also called Consumer Secret)
> - **Access Token**
> - **Access Token Secret**
>
> Copy all 4 values.

**Step 3** — Ask the user to check permissions:

> Make sure your app has **Read and Write** permissions. You can check this under your app's **"User authentication settings"** in the Developer Portal.

**Step 4** — When the user pastes the credentials, save them:

```bash
ruby ~/.claude/skills/x/scripts/save_token.rb 'API_KEY' 'API_SECRET' 'ACCESS_TOKEN' 'ACCESS_TOKEN_SECRET'
```

If the script outputs an error, the credentials are invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain tweet text or a tweet ID.

### Step 1: Check account info

```bash
ruby ~/.claude/skills/x/scripts/me.rb
```

Present the account info to the user.

### Step 2: Present options

Ask the user what they want to do:

- **Post a tweet**
- **List recent tweets**
- **Search tweets**
- **View a tweet**
- **Delete a tweet**
- **View liked tweets**
- **Like a tweet**

If `$ARGUMENTS` looks like tweet text (not a number), offer to post it. If it looks like a tweet ID (numeric), offer to view it.

### Step 3: Actions

**Post a tweet (requires user confirmation):**

Ask the user to type the tweet text. Show a preview of the tweet and its character count. Ask: "Do you want to post this tweet?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/x/scripts/post_tweet.rb 'TWEET_TEXT'
```

**List recent tweets:**
```bash
ruby ~/.claude/skills/x/scripts/tweets.rb
ruby ~/.claude/skills/x/scripts/tweets.rb --user_id USER_ID
```

**View a tweet:**
```bash
ruby ~/.claude/skills/x/scripts/tweet.rb TWEET_ID
```

**Search recent tweets:**
```bash
ruby ~/.claude/skills/x/scripts/search.rb 'SEARCH_QUERY'
```

**Delete a tweet (requires user confirmation):**

Show the tweet details first, then ask: "Do you want to delete this tweet?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/x/scripts/delete_tweet.rb TWEET_ID
```

**View liked tweets:**
```bash
ruby ~/.claude/skills/x/scripts/likes.rb
ruby ~/.claude/skills/x/scripts/likes.rb --user_id USER_ID
```

**Like a tweet (requires user confirmation):**

Show the tweet details first, then ask: "Do you want to like this tweet?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/x/scripts/like.rb TWEET_ID
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils, openssl, base64, securerandom)
- **OAuth 1.0a with HMAC-SHA1 signature** — full signature generation implemented in auth.rb
- **Twitter API v2 endpoints** — all scripts use the v2 API
- **Free tier** allows 1,500 tweets/month (posting) and limited reads
- Token files stored at `~/.config/x/` (4 files, never commit)
- Post, delete, and like require explicit user confirmation
- Base URL: `https://api.twitter.com`
