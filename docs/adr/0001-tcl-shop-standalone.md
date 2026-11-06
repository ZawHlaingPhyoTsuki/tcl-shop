# ADR-0001: Build tcl-shop as a standalone storefront project

## Status

Accepted (2026-10-31)

## Context

tcl-guide, an earlier map-first local directory of food-related places, is a
separate project and stays that way. The directory model made discovery the
product, but the businesses it listed had no way to transact, and the directory
competed with Telegram and social media rather than replacing them.

## Decision

This repository is tcl-shop: a mobile-first product discovery and storefront
platform for social-commerce merchants, built on its own with a fresh schema
baseline.

- Customers browse products across shops and place COD orders.
- Merchants own a shop, its products, stock, and orders.
- Platform admins moderate shops, listings, and categories.
- Public product and shop pages work without signing in.
- The map is no longer a primary surface.

## Consequences

- The schema starts a fresh migration baseline; migration history is
  append-only after the first deploy.
- Search, storefronts, and checkout become the core surfaces; maps become an
  optional detail-page element.
- tcl-guide and tcl-shop evolve independently; no shared branches or history.
