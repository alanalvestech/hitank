---
name: mercadopago
description: Manage MercadoPago payments, customers and account via API
user-invocable: true
argument-hint: [payment ID or search query]
---

# /mercadopago

Connect to the MercadoPago API to manage payments, refunds, customers and payment methods. Pure Ruby, zero gems — stdlib only.

## Structure

```
scripts/
├── auth.rb              # Bearer token + mp_request helper (required by all scripts)
├── check_setup.rb       # Check if token exists (outputs OK or SETUP_NEEDED)
├── save_token.rb        # Save and validate an API token
├── payments.rb          # List/search payments (optional --status flag)
├── payment.rb           # Get payment details by ID
├── create_payment.rb    # Create a new payment (requires confirmation)
├── refund.rb            # Refund a payment (requires confirmation)
├── customers.rb         # List/search customers
├── customer.rb          # Get customer details by ID
├── payment_methods.rb   # List available payment methods
└── account_balance.rb   # Check account balance
```

## Setup (check before using)

```bash
ruby ~/.claude/skills/mercadopago/scripts/check_setup.rb
```

If the output is `OK`, proceed to the Flow section.

If the output is `SETUP_NEEDED`, guide the user step by step. Present ONE step at a time, wait for the user to confirm before moving to the next.

**Step 1** — Ask the user to create an access token:

> You need a MercadoPago Access Token. Go to the developer panel to get one:
>
> https://www.mercadopago.com.br/developers/panel/app
>
> Select your application (or create one), then go to **Credentials** and copy your **Access Token** (production or test, depending on your needs).
>
> Paste the token here.

**Step 2** — When the user pastes the token, save it:

```bash
ruby ~/.claude/skills/mercadopago/scripts/save_token.rb 'PASTED_TOKEN'
```

If the script outputs an error, the token is invalid. Ask the user to double-check and try again.

**If setup is not complete, DO NOT proceed to the Flow. Complete all steps first.**

## Flow

The argument `$ARGUMENTS` may contain a payment ID or search query.

### Step 1: Identify intent

If `$ARGUMENTS` looks like a numeric ID, show payment details. Otherwise, list payments or ask the user what they want to do.

### Step 2: Actions

**List/search payments:**
```bash
ruby ~/.claude/skills/mercadopago/scripts/payments.rb
ruby ~/.claude/skills/mercadopago/scripts/payments.rb --status approved
ruby ~/.claude/skills/mercadopago/scripts/payments.rb --status pending
```

**Get payment details:**
```bash
ruby ~/.claude/skills/mercadopago/scripts/payment.rb PAYMENT_ID
```

**Create a payment (requires user confirmation):**

Ask the user for the payment details (amount, description, payment method, payer email). Confirm before executing.

```bash
ruby ~/.claude/skills/mercadopago/scripts/create_payment.rb '{"transaction_amount":100.0,"description":"Product","payment_method_id":"pix","payer":{"email":"buyer@example.com"}}'
```

**Refund a payment (requires user confirmation):**

Show payment details first, then ask: "Do you want to refund this payment?" Only execute after a "yes".

```bash
ruby ~/.claude/skills/mercadopago/scripts/refund.rb PAYMENT_ID
```

**List customers:**
```bash
ruby ~/.claude/skills/mercadopago/scripts/customers.rb
ruby ~/.claude/skills/mercadopago/scripts/customers.rb --email user@example.com
```

**Get customer details:**
```bash
ruby ~/.claude/skills/mercadopago/scripts/customer.rb CUSTOMER_ID
```

**List available payment methods:**
```bash
ruby ~/.claude/skills/mercadopago/scripts/payment_methods.rb
```

**Check account balance:**
```bash
ruby ~/.claude/skills/mercadopago/scripts/account_balance.rb
```

## Notes

- **Pure Ruby, zero gems** — stdlib only (json, net/http, uri, fileutils)
- Auth via Bearer token in Authorization header
- Token file: `~/.config/mercadopago/token` (outside the repo, never commit)
- Creating payments and refunding require explicit user confirmation
- Base URL: `https://api.mercadopago.com`
