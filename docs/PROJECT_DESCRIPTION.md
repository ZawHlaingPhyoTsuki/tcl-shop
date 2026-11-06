# tcl-shop — Project Description

Mobile-first product discovery and storefront platform for social-commerce
merchants in Tachileik, Myanmar. Customers browse products across shops and
place cash-on-delivery (COD) orders. Merchants manage their own shop,
listings, inventory, and orders.

## Tech Stack

- **Framework**: Next.js 16 (App Router, Server Actions)
- **Database**: PostgreSQL (Neon) with Prisma ORM
- **Authentication**: Better Auth
- **Styling**: Tailwind CSS v4 + shadcn/ui
- **Runtime**: Bun
- **Storage**: Neon Object Storage (for images)

## Product goals

- Make products searchable across participating shops.
- Give every merchant a shareable public storefront.
- Show clear product details, pricing, variants, and availability.
- Let customers place COD orders without a complicated checkout.
- Give merchants a straightforward workflow for products and orders.
- Build trust through accurate listings, moderation, and eventually
  verified-purchase reviews.

## Initial scope

### Customer

- Browse and search published products.
- Filter by category and sort results.
- View product details and merchant storefronts.
- Share product and shop links.
- Place a COD order (requires account).
- View order confirmation and status.

### Merchant

- Create and manage a shop.
- Create, edit, publish, unpublish, and archive products.
- Upload product images.
- Manage basic stock and variants where needed.
- Review orders and update permitted order statuses.
- Configure basic delivery information.

### Platform administration

- Review and manage shops.
- Hide or moderate listings.
- Manage product categories.
- Investigate reports and suspend abusive accounts when necessary.

## Out of scope for the first release

- Online payments and payment processing.
- Delivery-provider integrations or live shipping quotes.
- Cross-merchant checkout.
- Automated TikTok scraping or importing.
- AI recommendations and complex personalization.
- Paid promotions, subscriptions, and transaction fees.
- Advanced analytics.

## Core product decisions

- Public product and shop pages work without signing in.
- Account required for checkout; no guest ordering.
- Each checkout initially belongs to one shop.
- Orders use COD. tcl-shop records order and payment status but does not
  process money.
- Product name and price are snapshotted into order items so later listing
  edits do not rewrite history.
- Merchant permissions are enforced on the server, not only in the UI.
- Reviews are restricted to eligible purchasers once reviews are implemented.
- Money is stored as whole integer units with an explicit currency: MMK or
  THB, both without decimals. There is no implicit FX conversion.
- The current schema stores English and Myanmar fields explicitly; adding
  Shan requires a reviewed schema migration.