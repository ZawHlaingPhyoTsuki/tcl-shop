# ADR-0001: Build tcl-shop as a standalone storefront project

## Status

Accepted (2026-10-31)

## Context

Previous local directory projects focused on map-based discovery, but businesses
listed had no way to transact, and the directory competed with Telegram and
social media rather than replacing them.

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
- The project evolves independently as a dedicated e-commerce platform.