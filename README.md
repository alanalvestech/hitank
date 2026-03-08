<div align="center">

# HiTank — Your skill operator for Claude Code
  <img src="assets/pilot-program.gif" alt="I need a pilot program for a B-212 helicopter" width="1280" />
  <br /><br />
  <a href="https://twitter.com/alanalvestech">
    <img src="https://img.shields.io/badge/Follow on X-000000?style=for-the-badge&logo=x&logoColor=white" alt="Follow on X" />
  </a>
  <a href="https://www.linkedin.com/in/alanalvestech/">
    <img src="https://img.shields.io/badge/Follow on LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="Follow on LinkedIn" />
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/LICENSE-MIT-2ea44f?style=for-the-badge" alt="MIT License" />
  </a>
</div>

<br />

<p align="center">
  <a href="#rocket-quick-start">Quick Start</a> &nbsp;&bull;&nbsp;
  <a href="#package-skills-catalog">Skills Catalog</a> &nbsp;&bull;&nbsp;
  <a href="#wrench-installation">Installation</a> &nbsp;&bull;&nbsp;
  <a href="#diamond_shape_with_a_dot_inside-why-ruby">Why Ruby</a> &nbsp;&bull;&nbsp;
  <a href="#gear-how-it-works">How It Works</a>
</p>

---

## :rocket: Quick Start

```bash
gem install hitank          # Install the CLI
hitank add google-sheets    # Add a skill (global)
```

Then use `/google-sheets` directly in Claude Code. That's it.

```bash
# More commands
hitank list                        # List available skills
hitank add honeybadger --local     # Install for current project only
hitank del google-sheets           # Remove a skill
```

## :package: Skills Catalog

### :briefcase: Project Management
- **[clickup](skills/clickup)** — Manage ClickUp workspaces, spaces, lists, tasks, comments and time tracking. Search tasks, create/update/delete with filters and pagination. Supports bulk operations and task hierarchy navigation.
- **[jira](skills/jira)** — Manage Jira Cloud issues, projects, sprints and boards. Search with JQL, create/update issues, transition statuses, assign, comment. Supports Agile boards and sprint management.
- **[linear](skills/linear)** — Manage Linear issues, projects, teams, cycles and labels via GraphQL API. Create/update issues, search, comment. Supports team filtering and cycle management.
- **[trello](skills/trello)** — Manage Trello boards, lists, cards, checklists, labels and members via REST API. Create/move/update cards, search, comment, manage checklists. Supports labels, due dates and member assignment.

### :bar_chart: CRM & Sales
- **[hubspot](skills/hubspot)** — Manage HubSpot CRM contacts, companies, deals and pipelines. Search across objects, create/update records, list owners and notes. Cursor-based pagination for large datasets.

### :cloud: Platform & Infrastructure
- **[cloudflare](skills/cloudflare)** — Manage Cloudflare zones, DNS records, Workers, Pages and cache via REST API. Create/delete DNS records, list Workers scripts, purge cache. Supports zone management and account-level resources.
- **[digitalocean](skills/digitalocean)** — Manage DigitalOcean droplets, domains, databases, App Platform and volumes via REST API. Create/reboot/power off droplets, manage DNS records, list managed databases and apps.
- **[flyio](skills/flyio)** — Manage Fly.io apps, machines, volumes and certificates via Machines API. Create/start/stop/delete machines, manage volumes with snapshots, request ACME certificates. Supports regions, scaling and health checks.
- **[heroku](skills/heroku)** — Manage Heroku apps, dynos, config vars, releases, add-ons, domains and formation. View logs, restart dynos, scale processes. Full Platform API coverage.
- **[hostinger](skills/hostinger)** — Manage Hostinger domains, DNS records, hosting websites, subscriptions and VPS. Check domain availability, update nameservers, manage DNS snapshots and WHOIS privacy.
- **[railway](skills/railway)** — Manage Railway projects, services, deployments, variables, domains and volumes via GraphQL API. Deploy, rollback, view logs, manage environments. Supports GitHub repos, Docker images and custom domains.
- **[vercel](skills/vercel)** — Manage Vercel projects, deployments, domains and environment variables via REST API. List/inspect deployments, view logs, redeploy. Supports environment variable management and domain configuration.

### :bird: Social Media
- **[x](skills/x)** — Post and manage tweets on X (formerly Twitter) via API v2. Post/delete tweets, search, view likes. OAuth 1.0a with HMAC-SHA1 signature, pure Ruby.

### :speech_balloon: Communication
- **[discord](skills/discord)** — Manage Discord servers, channels and messages via Bot API. Send/edit/delete messages, react, pin, create threads, list members and roles.
- **[intercom](skills/intercom)** — Manage Intercom conversations, contacts, articles and help center via REST API. List/reply to conversations, search contacts, browse help center articles.
- **[resend](skills/resend)** — Send transactional emails via Resend API. Manage domains with DNS verification, contacts, broadcasts and API keys. Schedule emails, track delivery status and send newsletters.
- **[rewrite](skills/rewrite)** — Send SMS messages via Rewrite API. Manage templates with variables, webhooks for delivery events, API keys and projects. Cursor-based pagination for large datasets.
- **[slack](skills/slack)** — Manage Slack channels, messages, users, reactions and files via Bot API. Post messages, search, upload files, pin messages and manage reactions.
- **[twilio](skills/twilio)** — Send SMS, list messages and calls via Twilio REST API. Manage phone numbers, view usage records. Supports form-encoded API with Basic auth.
- **[zendesk](skills/zendesk)** — Manage Zendesk tickets, users, organizations and knowledge base via REST API. Create/update tickets, search, list users and browse help center articles.

### :credit_card: Payments
- **[abacatepay](skills/abacatepay)** — Manage AbacatePay payments, PIX QR codes, customers, coupons, withdrawals and revenue. Create charges, check payment status, manage discount coupons and track MRR.
- **[mercadopago](skills/mercadopago)** — Manage MercadoPago payments, customers, refunds and payment methods via REST API. Search payments, create charges, process refunds, check account balance. Supports PIX and boleto.
- **[stripe](skills/stripe)** — Manage Stripe payments, customers, subscriptions, invoices and products via REST API. Create charges, payment intents, manage prices and check account balance.

### :chart_with_upwards_trend: Monitoring
- **[appsignal](skills/appsignal)** — Monitor AppSignal apps — graphs, markers, samples and sourcemaps via REST API. View performance metrics, create deploy/custom markers, inspect error and performance samples, upload sourcemaps.
- **[datadog](skills/datadog)** — Monitor Datadog infrastructure — monitors, dashboards, events, metrics and hosts via REST API. Mute/unmute monitors, list dashboards, view events and active metrics.
- **[honeybadger](skills/honeybadger)** — Monitor errors, uptime and deployments on Honeybadger. List projects, browse faults with filters, view fault details, resolve issues, track deploys and check uptime sites.
- **[posthog](skills/posthog)** — Manage PostHog analytics — events, persons, feature flags, insights and annotations via REST API. Toggle feature flags, list events, view insights. Supports cloud and self-hosted.
- **[sentry](skills/sentry)** — Monitor Sentry errors — issues, events, releases and organizations via REST API. List/resolve issues, view events, track releases. Supports project and org-level queries.

### :page_facing_up: Office & Productivity
- **[google-sheets](skills/google-sheets)** — Read and write Google Sheets via REST API. List tabs, read ranges, write data and append rows. Supports RAW and USER_ENTERED input modes for formulas and dates.
- **[notion](skills/notion)** — Manage Notion pages, databases, blocks and users via REST API. Search, query databases, create/update pages, append blocks. Supports all block types.

### :shopping_cart: E-commerce
- **[shopify](skills/shopify)** — Manage Shopify products, orders, customers, inventory and collections via Admin API. Create/update products, track orders, manage inventory levels and custom collections.

### :floppy_disk: Databases
- **[planetscale](skills/planetscale)** — Manage PlanetScale databases, branches, deploy requests and backups via REST API. Create branches, submit deploy requests, list backups. Supports org-level and database-level operations.
- **[supabase](skills/supabase)** — Manage Supabase projects, edge functions, secrets and API keys via Management API. Pause/restore projects, list functions, manage secrets. Full project lifecycle management.

### :fire: Backend & BaaS
- **[firebase](skills/firebase)** — Manage Firebase projects, Firestore, Auth users and Hosting via REST API. List collections/documents, browse auth users, manage hosting sites and releases. Uses service account JWT auth.

### :art: Media & Storage
- **[cloudinary](skills/cloudinary)** — Manage Cloudinary media assets, transformations and upload via REST API. List resources/folders, upload images from URL, view usage stats. Supports transformations and folder navigation.

### :robot_face: AI & Machine Learning
- **[openai](skills/openai)** — Manage OpenAI models, assistants, files and usage via REST API. List models, manage assistants, upload/delete files, view usage stats and fine-tuning jobs.

### :gear: Automation
- **[n8n](skills/n8n)** — Manage n8n workflows, executions and credentials via REST API. Activate/deactivate workflows, list executions, view credentials. Supports cloud and self-hosted instances.

### :zap: Quick Install

```bash
hitank add abacatepay      # Payments — PIX, customers, coupons
hitank add appsignal       # Monitoring — graphs, markers, samples
hitank add clickup         # Project management — tasks, comments, time tracking
hitank add cloudflare      # Infrastructure — zones, DNS, Workers, Pages
hitank add cloudinary      # Media — images, folders, transformations
hitank add datadog         # Monitoring — monitors, dashboards, metrics
hitank add digitalocean    # Infrastructure — droplets, domains, databases
hitank add discord         # Communication — messages, channels, threads
hitank add firebase        # Backend — Firestore, Auth, Hosting
hitank add flyio           # Infrastructure — machines, volumes, certificates
hitank add google-sheets   # Office — read/write spreadsheets
hitank add heroku          # Infrastructure — apps, dynos, config vars
hitank add honeybadger     # Monitoring — errors, uptime, deploys
hitank add hostinger       # Infrastructure — domains, DNS, hosting
hitank add hubspot         # CRM — contacts, companies, deals
hitank add intercom        # Communication — conversations, contacts, articles
hitank add jira            # Project management — issues, sprints, boards
hitank add linear          # Project management — issues, cycles, teams
hitank add mercadopago     # Payments — PIX, boleto, refunds
hitank add n8n             # Automation — workflows, executions, credentials
hitank add notion          # Office — pages, databases, blocks
hitank add openai          # AI — models, assistants, files, usage
hitank add planetscale     # Database — branches, deploy requests, backups
hitank add posthog         # Analytics — events, feature flags, insights
hitank add railway         # Infrastructure — projects, services, deployments
hitank add resend          # Communication — transactional emails, domains
hitank add rewrite         # Communication — SMS, templates, webhooks
hitank add sentry          # Monitoring — issues, events, releases
hitank add shopify         # E-commerce — products, orders, inventory
hitank add slack           # Communication — messages, files, reactions
hitank add stripe          # Payments — charges, subscriptions, invoices
hitank add supabase        # Backend — projects, functions, secrets
hitank add trello          # Project management — boards, lists, cards
hitank add twilio          # Communication — SMS, calls, phone numbers
hitank add x               # Social media — post tweets, search, likes
hitank add vercel          # Infrastructure — projects, deployments, domains
hitank add zendesk         # Support — tickets, users, knowledge base
```

## :wrench: Installation

### 1. Check if you have Ruby

Open the terminal and run:

```bash
ruby -v
```

If you see something like `ruby 3.x.x`, you're good — skip to step 3.

If the command is not found or the version is below 3.0, follow step 2.

### 2. Install Ruby (if needed)

**Mac** — Ruby comes pre-installed, but it's usually outdated. The easiest way to get Ruby 3+:

```bash
brew install ruby
```

Don't have Homebrew? Install it first: https://brew.sh

After installing, restart your terminal and run `ruby -v` again to confirm.

**Linux (Ubuntu/Debian)**:

```bash
sudo apt update && sudo apt install ruby-full
```

**Windows**:

Download the installer from https://rubyinstaller.org — pick the latest Ruby+Devkit version and follow the wizard.

### 3. Install hitank

```bash
gem install hitank
```

That's it. No other dependencies needed.

## :diamond_shape_with_a_dot_inside: Why Ruby

Ruby's stdlib is surprisingly powerful. `net/http`, `openssl`, `json`, `base64` — everything you need to talk to REST APIs is already there. No gem install, no bundler, no dependency hell.

These skills prove a point: you don't need Python or TypeScript to build useful AI tooling. Ruby works. And if you already have Ruby installed (you probably do), these skills just work.

**Token economy** — Less code for Claude to read means fewer tokens per session, which adds up fast if you're watching your usage.

For a skill that reads/writes a REST API with auth (like Google Sheets):

| | Ruby (hitank) | Python + deps | TypeScript (MCP) |
|---|---|---|---|
| Skill files | 8 | ~8-10 | ~12-15 |
| Config files | 0 | 2+ | 3+ |
| Lines of code | 185 ✱ | ~200-350 | ~400-600 |
| Dependencies | 0 | ~5-10 | ~10-20 |
| Est. tokens | **~2,750** ✱ | **~4,000-6,000** | **~6,000-9,000** |

✱ Measured from the Google Sheets skill. Other values are estimates based on minimum setup each stack requires.

## :gear: How It Works

Skills are stored in this repository under `skills/`. The `hitank` gem is a thin CLI that fetches individual skills from GitHub and installs them to `~/.claude/skills/` (or `.claude/skills/` with `--local`).

The skills themselves use **zero gems** — pure Ruby stdlib. The gem is just the installer.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=alanalvestech/hitank&type=Date)](https://star-history.com/#alanalvestech/hitank&Date)

## License

[MIT](LICENSE)
