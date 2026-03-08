---
name: firebase
description: "Manage Firebase projects, Firestore, Auth users and Hosting via REST API"
user-invocable: true
argument-hint: [project ID]
---

# /firebase

Connect to Firebase and Google Cloud APIs to manage projects, Firestore databases, Authentication users and Hosting deployments. Pure Ruby, zero gems — stdlib only (json, net/http, uri, openssl, base64, fileutils).

## Structure

```
scripts/
├── auth.rb              # JWT-based OAuth2 + firebase_request helper (required by all scripts)
├── check_setup.rb       # Check if service account JSON exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Copy a service account JSON file to the config directory
├── projects.rb          # List Firebase projects
├── firestore_collections.rb  # List top-level Firestore collections
├── firestore_documents.rb    # List documents in a Firestore collection
├── firestore_document.rb     # Get a single Firestore document
├── auth_users.rb        # List Firebase Auth users (requires confirmation — contains PII)
├── hosting_sites.rb     # List Hosting sites for a project
└── hosting_releases.rb  # List releases for a Hosting site
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/firebase/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create a service account key:

> You need a Google Cloud service account key with Firebase access.
>
> 1. Go to the **Google Cloud Console** > **IAM & Admin** > **Service Accounts**:
>    https://console.cloud.google.com/iam-admin/serviceaccounts
>
> 2. Select your project (or create one).
>
> 3. Click **Create Service Account**. Give it a name like `hitank-firebase`.
>
> 4. Grant it the **Editor** role (or more restrictive roles: `Firebase Admin`, `Cloud Datastore User`, `Firebase Hosting Admin`).
>
> 5. Click on the created service account, go to **Keys** > **Add Key** > **Create new key** > **JSON**.
>
> 6. A `.json` file will be downloaded. Tell me the path to that file.

**Step 2** — When the user provides the path to the JSON key file, save it:

```bash
ruby ~/.claude/skills/firebase/scripts/save_token.rb '/path/to/downloaded-key.json'
```

If the script outputs an error, the file is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a Firebase project ID.

### Step 1: List projects

```bash
ruby ~/.claude/skills/firebase/scripts/projects.rb
```

Present the projects to the user. If `$ARGUMENTS` matches a project ID, use that project. Otherwise ask which project to work with.

### Step 2: Actions

**List top-level Firestore collections (documents at root):**
```bash
ruby ~/.claude/skills/firebase/scripts/firestore_collections.rb PROJECT_ID
```

**List documents in a Firestore collection:**
```bash
ruby ~/.claude/skills/firebase/scripts/firestore_documents.rb PROJECT_ID COLLECTION_NAME
```

**Get a single Firestore document:**
```bash
ruby ~/.claude/skills/firebase/scripts/firestore_document.rb PROJECT_ID COLLECTION_NAME DOCUMENT_ID
```

**List Firebase Auth users (requires user confirmation — this returns PII):**

Before running, ask: "This will list Firebase Auth users which contains personal information (emails, phone numbers). Do you want to proceed?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/firebase/scripts/auth_users.rb PROJECT_ID
```

**List Hosting sites:**
```bash
ruby ~/.claude/skills/firebase/scripts/hosting_sites.rb PROJECT_ID
```

**List Hosting releases:**
```bash
ruby ~/.claude/skills/firebase/scripts/hosting_releases.rb PROJECT_ID SITE_NAME
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, openssl, base64, fileutils)
- Auth via Google OAuth2 using a service account JSON key and JWT (RS256)
- Service account key file: `~/.config/firebase/service_account.json` (outside the repo, never commit)
- Access token cached at `~/.config/firebase/access_token` with expiry check
- The JWT is signed locally using the service account's private key, then exchanged for an access token via `https://oauth2.googleapis.com/token`
- Listing Auth users requires explicit user confirmation because it returns PII
- OAuth2 scope: `https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/firebase`
