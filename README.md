# TCL Shop 🛒

Local e-commerce platform for Tachileik, Myanmar.

**Stack**: Next.js 16, Prisma 7, PostgreSQL (Neon), Better Auth, Bun.

## Quick Start

```bash
bun install
bunx prisma generate
bunx prisma db push
bun dev
```

## Key Decisions

- **COD Only**: No payment gateway. Merchants verify manually.
- **Integer Money**: Prices stored as integers (MMK/THB). No decimals.
- **No Guest Checkout**: Users must authenticate to order.
- **Feature-Sliced**: Code organized by domain (`features/<domain>/`).
- **RSC First**: Server components by default; `'use client'` only for leaves.

## Docs

- [Architecture Decisions](./docs/adr/)
- [Development Roadmap](./docs/PHASES.md)
- [Agent Guide](./AGENT.md)
