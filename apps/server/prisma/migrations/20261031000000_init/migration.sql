-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "ProductStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'CONFIRMED', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('UNPAID', 'PAID');

-- CreateEnum
CREATE TYPE "Currency" AS ENUM ('MMK', 'THB');

-- CreateEnum
CREATE TYPE "ShopStatus" AS ENUM ('ACTIVE', 'SUSPENDED');

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "role" TEXT,
    "banned" BOOLEAN DEFAULT false,
    "banReason" TEXT,
    "banExpires" TIMESTAMP(3),

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "userId" TEXT NOT NULL,
    "impersonatedBy" TEXT,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "idToken" TEXT,
    "accessTokenExpiresAt" TIMESTAMP(3),
    "refreshTokenExpiresAt" TIMESTAMP(3),
    "scope" TEXT,
    "password" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification" (
    "id" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "nameMy" TEXT NOT NULL,
    "nameEn" TEXT,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" TEXT NOT NULL,
    "shopId" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "nameMy" TEXT NOT NULL,
    "nameEn" TEXT,
    "descriptionMy" TEXT,
    "descriptionEn" TEXT,
    "categoryId" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "stock" INTEGER NOT NULL DEFAULT 0,
    "images" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "status" "ProductStatus" NOT NULL DEFAULT 'DRAFT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_variant" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "price" INTEGER,
    "stock" INTEGER NOT NULL DEFAULT 0,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "product_variant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shop_order" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "shopId" TEXT NOT NULL,
    "status" "OrderStatus" NOT NULL DEFAULT 'PENDING',
    "paymentStatus" "PaymentStatus" NOT NULL DEFAULT 'UNPAID',
    "customerName" TEXT NOT NULL,
    "customerPhone" TEXT NOT NULL,
    "deliveryAddress" TEXT NOT NULL,
    "deliveryNote" TEXT,
    "subtotal" INTEGER NOT NULL,
    "deliveryFee" INTEGER NOT NULL DEFAULT 0,
    "total" INTEGER NOT NULL,
    "currency" "Currency" NOT NULL,
    "userId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "shop_order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_item" (
    "id" TEXT NOT NULL,
    "orderId" TEXT NOT NULL,
    "productId" TEXT,
    "variantId" TEXT,
    "productName" TEXT NOT NULL,
    "variantLabel" TEXT,
    "unitPrice" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "lineTotal" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "order_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shop" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "nameMy" TEXT NOT NULL,
    "nameEn" TEXT,
    "descriptionMy" TEXT,
    "descriptionEn" TEXT,
    "phone" TEXT,
    "addressText" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "logoUrl" TEXT,
    "coverUrl" TEXT,
    "deliveryNote" TEXT,
    "deliveryFee" INTEGER NOT NULL DEFAULT 0,
    "currency" "Currency" NOT NULL DEFAULT 'MMK',
    "ownerId" TEXT NOT NULL,
    "status" "ShopStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "shop_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE INDEX "session_userId_idx" ON "session"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "session_token_key" ON "session"("token");

-- CreateIndex
CREATE INDEX "account_userId_idx" ON "account"("userId");

-- CreateIndex
CREATE INDEX "verification_identifier_idx" ON "verification"("identifier");

-- CreateIndex
CREATE UNIQUE INDEX "category_slug_key" ON "category"("slug");

-- CreateIndex
CREATE INDEX "product_categoryId_idx" ON "product"("categoryId");

-- CreateIndex
CREATE INDEX "product_status_createdAt_idx" ON "product"("status", "createdAt");

-- CreateIndex
CREATE INDEX "product_status_price_idx" ON "product"("status", "price");

-- CreateIndex
CREATE UNIQUE INDEX "product_shopId_slug_key" ON "product"("shopId", "slug");

-- CreateIndex
CREATE INDEX "product_variant_productId_idx" ON "product_variant"("productId");

-- CreateIndex
CREATE UNIQUE INDEX "product_variant_productId_label_key" ON "product_variant"("productId", "label");

-- CreateIndex
CREATE UNIQUE INDEX "shop_order_code_key" ON "shop_order"("code");

-- CreateIndex
CREATE INDEX "shop_order_shopId_status_idx" ON "shop_order"("shopId", "status");

-- CreateIndex
CREATE INDEX "shop_order_userId_idx" ON "shop_order"("userId");

-- CreateIndex
CREATE INDEX "shop_order_createdAt_idx" ON "shop_order"("createdAt");

-- CreateIndex
CREATE INDEX "order_item_orderId_idx" ON "order_item"("orderId");

-- CreateIndex
CREATE UNIQUE INDEX "shop_slug_key" ON "shop"("slug");

-- CreateIndex
CREATE INDEX "shop_ownerId_idx" ON "shop"("ownerId");

-- CreateIndex
CREATE INDEX "shop_status_idx" ON "shop"("status");

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "shop"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_variant" ADD CONSTRAINT "product_variant_productId_fkey" FOREIGN KEY ("productId") REFERENCES "product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shop_order" ADD CONSTRAINT "shop_order_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "shop"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "shop_order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_productId_fkey" FOREIGN KEY ("productId") REFERENCES "product"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_item" ADD CONSTRAINT "order_item_variantId_fkey" FOREIGN KEY ("variantId") REFERENCES "product_variant"("id") ON DELETE SET NULL ON UPDATE CASCADE;
