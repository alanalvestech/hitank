---
name: cloudinary
description: Manage Cloudinary media assets, transformations and upload via REST API
user-invocable: true
argument-hint: [public ID or folder]
---

# /cloudinary

Connect to the Cloudinary REST API to manage media assets, folders, transformations, uploads and usage stats. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb             # Basic auth (api_key:api_secret) + cloudinary_request helper (required by all scripts)
├── check_setup.rb      # Check if credentials exist (outputs OK or SETUP_NEEDED)
├── save_token.rb       # Save and validate cloud name, API key and API secret
├── resources.rb        # List image resources
├── resource.rb         # Get single image details
├── upload.rb           # Upload image from URL
├── delete.rb           # Delete a resource by public ID
├── folders.rb          # List root folders
├── subfolders.rb       # List subfolders of a folder
├── transformations.rb  # List named transformations
└── usage.rb            # Get account usage stats
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/cloudinary/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user for their Cloudinary credentials:

> You need your Cloudinary **Cloud Name**, **API Key** and **API Secret**.
>
> Go to the **Cloudinary Console Dashboard**:
> https://console.cloudinary.com/settings/api-keys
>
> Copy the **Cloud Name**, **API Key** and **API Secret** and paste them here (all three, separated by spaces).

**Step 2** — When the user pastes the credentials, save them:

```bash
ruby ~/.claude/skills/cloudinary/scripts/save_token.rb 'CLOUD_NAME' 'API_KEY' 'API_SECRET'
```

If the script outputs an error, the credentials are invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a public ID or folder name.

### Step 1: List resources or folders

**List image resources:**
```bash
ruby ~/.claude/skills/cloudinary/scripts/resources.rb
ruby ~/.claude/skills/cloudinary/scripts/resources.rb --type upload
ruby ~/.claude/skills/cloudinary/scripts/resources.rb --type fetch
ruby ~/.claude/skills/cloudinary/scripts/resources.rb --prefix my_folder
```

**List root folders:**
```bash
ruby ~/.claude/skills/cloudinary/scripts/folders.rb
```

**List subfolders:**
```bash
ruby ~/.claude/skills/cloudinary/scripts/subfolders.rb FOLDER
```

Present the results to the user. If `$ARGUMENTS` matches a public ID, jump to Step 2. If it matches a folder, show its contents.

### Step 2: Show resource details

```bash
ruby ~/.claude/skills/cloudinary/scripts/resource.rb PUBLIC_ID
```

Present the resource info (format, dimensions, size, URL, tags, etc.) and ask what the user wants to do.

### Step 3: Actions

**Upload image from URL (requires user confirmation):**

Ask: "Do you want to upload this image?" Show the URL and target public ID. Only execute after a "yes".

```bash
ruby ~/.claude/skills/cloudinary/scripts/upload.rb --url 'https://example.com/image.jpg' --public_id 'my_image'
```

**Delete a resource (requires user confirmation):**

Show the resource details first, then ask: "Do you want to delete this resource?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/cloudinary/scripts/delete.rb PUBLIC_ID
```

**List transformations:**
```bash
ruby ~/.claude/skills/cloudinary/scripts/transformations.rb
```

**Get account usage stats:**
```bash
ruby ~/.claude/skills/cloudinary/scripts/usage.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via HTTP Basic with api_key:api_secret
- Config files: `~/.config/cloudinary/cloud_name`, `~/.config/cloudinary/api_key`, `~/.config/cloudinary/api_secret` (outside the repo, never commit)
- Uploading and deleting resources require explicit user confirmation
- Base URL: `https://api.cloudinary.com/v1_1/{cloud_name}`
