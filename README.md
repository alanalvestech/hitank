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
- **[clickup](skills/clickup)** — Manage ClickUp workspaces, spaces, lists, tasks, comments and time tracking. Search tasks, create/update/delete with filters and pagination. Supports bulk operations and task hierarchy navigation. `hitank add clickup`
- **[jira](skills/jira)** — Manage Jira Cloud issues, projects, sprints and boards. Search with JQL, create/update issues, transition statuses, assign, comment. Supports Agile boards and sprint management. `hitank add jira`
- **[linear](skills/linear)** — Manage Linear issues, projects, teams, cycles and labels via GraphQL API. Create/update issues, search, comment. Supports team filtering and cycle management. `hitank add linear`

### :bar_chart: CRM & Sales
- **[hubspot](skills/hubspot)** — Manage HubSpot CRM contacts, companies, deals and pipelines. Search across objects, create/update records, list owners and notes. Cursor-based pagination for large datasets. `hitank add hubspot`

### :cloud: Platform & Infrastructure
- **[heroku](skills/heroku)** — Manage Heroku apps, dynos, config vars, releases, add-ons, domains and formation. View logs, restart dynos, scale processes. Full Platform API coverage. `hitank add heroku`
- **[hostinger](skills/hostinger)** — Manage Hostinger domains, DNS records, hosting websites, subscriptions and VPS. Check domain availability, update nameservers, manage DNS snapshots and WHOIS privacy. `hitank add hostinger`

### :speech_balloon: Communication
- **[discord](skills/discord)** — Manage Discord servers, channels and messages via Bot API. Send/edit/delete messages, react, pin, create threads, list members and roles. `hitank add discord`
- **[resend](skills/resend)** — Send transactional emails via Resend API. Manage domains with DNS verification, contacts, broadcasts and API keys. Schedule emails, track delivery status and send newsletters. `hitank add resend`
- **[rewrite](skills/rewrite)** — Send SMS messages via Rewrite API. Manage templates with variables, webhooks for delivery events, API keys and projects. Cursor-based pagination for large datasets. `hitank add rewrite`
- **[slack](skills/slack)** — Manage Slack channels, messages, users, reactions and files via Bot API. Post messages, search, upload files, pin messages and manage reactions. `hitank add slack`

### :credit_card: Payments
- **[abacatepay](skills/abacatepay)** — Manage AbacatePay payments, PIX QR codes, customers, coupons, withdrawals and revenue. Create charges, check payment status, manage discount coupons and track MRR. `hitank add abacatepay`
- **[stripe](skills/stripe)** — Manage Stripe payments, customers, subscriptions, invoices and products via REST API. Create charges, payment intents, manage prices and check account balance. `hitank add stripe`

### :chart_with_upwards_trend: Monitoring
- **[appsignal](skills/appsignal)** — Monitor AppSignal apps — graphs, markers, samples and sourcemaps via REST API. View performance metrics, create deploy/custom markers, inspect error and performance samples, upload sourcemaps. `hitank add appsignal`
- **[honeybadger](skills/honeybadger)** — Monitor errors, uptime and deployments on Honeybadger. List projects, browse faults with filters, view fault details, resolve issues, track deploys and check uptime sites. `hitank add honeybadger`

### :page_facing_up: Office & Productivity
- **[google-sheets](skills/google-sheets)** — Read and write Google Sheets via REST API. List tabs, read ranges, write data and append rows. Supports RAW and USER_ENTERED input modes for formulas and dates. `hitank add google-sheets`
- **[notion](skills/notion)** — Manage Notion pages, databases, blocks and users via REST API. Search, query databases, create/update pages, append blocks. Supports all block types. `hitank add notion`

### :shopping_cart: E-commerce
- **[shopify](skills/shopify)** — Manage Shopify products, orders, customers, inventory and collections via Admin API. Create/update products, track orders, manage inventory levels and custom collections. `hitank add shopify`

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
