<!-- BEGIN:nextjs-agent-rules -->

## This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->

# TCL Shop - Agent Development Guide

## Project Overview

**TCL Shop** is a localized e-commerce platform for Tachileik, Myanmar, enabling local merchants to sell products online with Cash-on-Delivery (COD) payments. The platform supports dual-currency (MMK/THB) transactions and multi-language content (Myanmar/English).

### Key Characteristics
- **Target Market**: Tachileik township and surrounding areas
- **Payment Model**: COD only (manual merchant verification)
- **Delivery**: Merchant-managed delivery
- **Tech Stack**: Next.js 16, Prisma 7, PostgreSQL (Neon), Better Auth
- **Architecture**: React Server Components with feature-sliced organization

---

## Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Framework | Next.js | 16.4.5 |
| Runtime | Bun | 1.4.3 |
| Database ORM | Prisma | 7.10.1 |
| Database | PostgreSQL (Neon) | - |
| Authentication | Better Auth | 1.7.18 |
| UI Library | shadcn/ui (base-rhea) | - |
| Styling | Tailwind CSS v4 | - |
| Language | TypeScript | 5.x |
| Linting | Biome | 2.4.2 |

---

## Project Structure

```
tcl-shop/
├── docs/                    # Project documentation
│   ├── adr/                 # Architecture Decision Records
│   ├── DESIGN.md            # Design system guidelines
│   ├── GLOSSARY.md          # Domain terminology
│   ├── PHASES.md            # Development roadmap
│   ├── PROJECT_DESCRIPTION.md
│   └── TODO.md
├── prisma/
│   ├── schema/              # Modular Prisma schema files
│   │   ├── auth.prisma      # User, Session, Account, Verification
│   │   ├── shop.prisma      # Shop model
│   │   ├── product.prisma   # Product, ProductVariant
│   │   ├── category.prisma  # Category model
│   │   ├── order.prisma     # Order, OrderItem
│   │   ├── address.prisma   # UserAddress model
│   │   └── schema.prisma    # Generator + datasource config
│   ├── seed.ts              # Database seeding script
│   └── src/app/generated/prisma/  # Generated Prisma Client
├── src/
│   ├── app/
│   │   ├── api/auth/[...all]/route.ts  # Better Auth API route
│   │   ├── layout.tsx       # Root layout
│   │   ├── page.tsx         # Home page
│   │   └── globals.css
│   ├── components/
│   │   └── ui/              # shadcn/ui primitives
│   └── lib/
│       ├── auth.ts          # Better Auth server config
│       ├── auth-client.ts   # Better Auth client config
│       ├── prisma.ts        # Prisma client singleton
│       └── utils.ts         # Utility functions
├── next.config.ts
├── package.json
└── tsconfig.json
```

---

## Architecture Principles

### 1. Feature-Sliced Organization (Next.js App Router)

Follow the `nextjs-app-architecture` skill guidelines:

- **Pages compose, never fetch**: Pages are synchronous composition surfaces
- **Async server components**: Default pattern for data fetching
- **Feature folders**: Code organized by domain (`features/<domain>/`)
- **Client boundaries pushed deep**: `'use client'` only on leaf nodes

### 2. Data Layer Patterns

**Queries** (`features/<domain>/<domain>-queries.ts`):
```typescript
import 'server-only';

export async function getProducts(shopId: string) {
  return db.product.findMany({ where: { shopId, status: 'PUBLISHED' } });
}
```

**Actions** (`features/<domain>/<domain>-actions.ts`):
```typescript
'use server';

export async function createOrder(data: CreateOrderInput) {
  // 1. Verify auth
  // 2. Validate input
  // 3. Execute mutation
  // 4. Return result
}
```

### 3. Component Patterns

- **Skeletons in same file**: Export component + skeleton together
- **Stable shell outside Suspense**: Chrome/layout stays visible
- **Page owns Suspense boundary**: Features export skeletons, pages place boundaries

---

## Database Schema

### Core Models

#### User & Authentication
- **User**: id, name, email, phone, role (CUSTOMER/MERCHANT/ADMIN)
- **Session**: Token-based session management
- **Account**: OAuth provider accounts
- **Verification**: Email verification tokens
- **UserAddress**: Saved delivery addresses

#### Commerce Models
- **Shop**: Merchant storefront (slug, location, currency, delivery info)
- **Category**: Global product categories (Myanmar/English names)
- **Product**: Items with dual-currency pricing (MMK/THB)
- **ProductVariant**: Size/color/etc variants with separate stock
- **Order**: Customer orders (COD, manual merchant review)
- **OrderItem**: Line items with price snapshots

### Key Relationships
- User → Shop (one-to-one, MERCHANT role)
- Shop → Products (one-to-many)
- Product → Variants (one-to-many)
- User → Orders (one-to-many)
- Order → Items (one-to-many)

---

## Business Rules

### 1. Currency Handling
- All prices stored as integers (smallest currency unit)
- Dual currency support: MMK (Myanmar Kyat) and THB (Thai Baht)
- Each shop selects default currency
- Order snapshots shop's currency at checkout

### 2. Product Pricing
- **Without variants**: Use `Product.priceMmk` / `Product.priceThb`
- **With variants**: Ignore product-level prices, use variant prices
- At least one price field must be set (validation in application code)

### 3. Order Flow
```
PENDING → CONFIRMED → DELIVERED
   ↓           ↓
CANCELLED   CANCELLED
```

- **Customer can cancel**: Only when status = PENDING
- **Merchant can reject**: With optional reason, restores stock
- **Payment**: COD only, merchant marks as PAID after receiving cash
- **No guest checkout**: All orders require authenticated user

### 4. Stock Management
- **Simple products**: Decrement `Product.stock`
- **Variant products**: Decrement `ProductVariant.stock`
- **On cancellation**: Restore stock automatically

### 5. Shop Approval
- New shops require admin approval before going live
- Shop status: ACTIVE or SUSPENDED

---

## Development Commands

```bash
# Development
bun dev                    # Start dev server

# Database
bunx prisma generate       # Generate Prisma Client
bunx prisma db push        # Push schema to database
bunx prisma studio         # Open Prisma Studio

# Code quality
bun run lint               # Biome linting
bun run format             # Biome formatting
```

---

## Important Conventions

### 1. Money as Integers
All monetary values stored as integers (see ADR 0002):
- 5000 = 5,000 MMK or 5,000 THB
- No decimal points in database
- Format for display in UI layer

### 2. Multi-Language Support
- Myanmar fields: `nameMy`, `descriptionMy` (required)
- English fields: `nameEn`, `descriptionEn` (optional)
- UI should support language switching

### 3. Image Storage
- **Current approach**: String arrays/fields storing URLs
- **Storage**: Neon Object Storage
- **Structure**: 
  ```
  shops/{shopId}/logo.jpg
  products/{productId}/img1.jpg
  users/{userId}/profile.jpg
  ```

### 4. Slug Generation
- Shop slugs: Unique, URL-friendly
- Product slugs: Unique per shop (`@@unique([shopId, slug])`)
- Category slugs: Globally unique

---

## Common Tasks

### Adding a New Feature

1. **Create feature folder**: `features/<domain>/`
2. **Define queries**: `<domain>-queries.ts` with `import 'server-only'`
3. **Define actions**: `<domain>-actions.ts` with `'use server'`
4. **Build components**: Async server components + skeletons
5. **Compose page**: Place Suspense boundaries in page.tsx
6. **Update schema**: Add models if needed, run `prisma generate`

### Database Schema Changes

```bash
# Edit schema files in prisma/schema/
# Then:
bunx prisma generate
bunx prisma db push
```

### Adding New Models

1. Create new `.prisma` file in `prisma/schema/`
2. Define model with relations
3. Update related models with reverse relations
4. Run `bunx prisma generate`

---

## Testing Strategy

- **End-to-end**: Playwright (future implementation)
- **Loading sequences**: Assert chrome renders before data
- **Mutations**: Test optimistic updates and rollbacks
- **Seeded database**: One worker, re-seed before runs

---

## Deployment Considerations

- **Database**: Neon PostgreSQL (serverless)
- **Object Storage**: Neon Object Storage for images
- **Environment Variables**: Use `.env.local` for secrets
- **Build**: `bun run build` → optimized production bundle

---

## Resources

- [Next.js 16 Docs](https://preview.nextjs.org/docs)
- [Prisma 7 Docs](https://www.prisma.io/docs)
- [Better Auth Docs](https://www.better-auth.com/)
- [shadcn/ui](https://ui.shadcn.com/)
- [Project ADRs](./docs/adr/)

---

## Quick Reference

### Role Permissions
- **CUSTOMER**: Browse, order, manage profile
- **MERCHANT**: Manage shop, products, view/review orders
- **ADMIN**: Approve shops, manage categories, platform oversight

### Order Statuses
- `PENDING`: Awaiting merchant review
- `CONFIRMED`: Merchant accepted, preparing delivery
- `DELIVERED`: Completed
- `CANCELLED`: Cancelled by customer or rejected by merchant

### Product Statuses
- `DRAFT`: Not visible to customers
- `PUBLISHED`: Live and purchasable
- `ARCHIVED`: Hidden but retained

---

*Last updated: November 2026*
