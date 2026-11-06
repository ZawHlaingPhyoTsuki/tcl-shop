# TODO

## Open questions

- How far do variants go in v1: size/color only, or arbitrary option pairs?
- Can a guest look up an order by reference + phone, or is the confirmation link
  the only access?
- Do merchant accounts start as self-serve signup or admin-created in v1?
- Is a product limited to one category, or several?
- Do we need a separate shop location model now, or free-text delivery info?
- Shan language fields are deferred; the schema stores English and Myanmar
  explicitly until a reviewed migration adds Shan.

## Next up

- [x] Define the v2 Prisma schema: Shop, Product, Variant, Category, Order,
      OrderItem (single shop owner for now).
- [x] Decide order and payment status vocabularies (PENDING/CONFIRMED/
      DELIVERED/CANCELLED; UNPAID/PAID).
- [ ] Decide the money helper API (integer amount + currency, no FX).
- [ ] Set up Better Auth roles: customer (optional account), merchant, admin.
- [x] Seed a demo shop, categories, and products for local development.

## Merchant

- [ ] Shop creation rules:
  - Signup defaults to `customer`.
  - Customer creates a shop -> promoted to `merchant`.
  - Merchant already owns a shop -> 409 Conflict on a second create (enforced by DB unique constraint).
  - Admin attempts to create a shop -> 403 Forbidden.
  - Merchant actions verify `shop.ownerId === session.user.id`.
  - Admin demoting a merchant who still owns a shop must be blocked (admin rule).
- [ ] Shop setup and edit form.
- [ ] Product create/edit with publish, unpublish, archive.
- [ ] Product image upload and ordering.
- [ ] Basic stock and variant management.
- [ ] Order list and permitted status updates.
- [ ] Delivery information settings.

## Customer

- [ ] Browse published products.
- [ ] Category filter and sort, in the URL.
- [ ] Product search.
- [ ] Product detail with variant selector and availability.
- [ ] Shop storefront with share action.
- [ ] COD checkout, guest-capable.
- [ ] Order confirmation and status view.

## Admin

- [ ] Shop review and approval.
- [ ] Listing moderation (hide).
- [ ] Category management.
- [ ] Report handling and account suspension.

## Deferred (explicitly out of first release)

- Online payments and payment processing.
- Delivery-provider integrations and live shipping quotes.
- Cross-merchant checkout.
- Automated TikTok scraping or importing.
- AI recommendations and complex personalization.
- Paid promotions, subscriptions, transaction fees.
- Advanced analytics.
- Reviews (Phase 8) and verified-purchase checks.

## Codebase

- [x] Retire v1 server modules (places, areas).
- [ ] Retire v1 web pages and dashboard screens.
- [x] Update seeds and fixtures to the shop model.
