-- DropIndex
DROP INDEX "product_status_price_idx";

-- AlterTable
ALTER TABLE "product" DROP COLUMN "price",
ADD COLUMN     "priceMmk" INTEGER,
ADD COLUMN     "priceThb" INTEGER;

-- AlterTable
ALTER TABLE "product_variant" DROP COLUMN "price",
ADD COLUMN     "priceMmk" INTEGER,
ADD COLUMN     "priceThb" INTEGER;

-- CreateIndex
CREATE INDEX "product_status_priceMmk_idx" ON "product"("status", "priceMmk");

-- CreateIndex
CREATE INDEX "product_status_priceThb_idx" ON "product"("status", "priceThb");

-- AddCheckConstraint: At least one price must be specified for products
ALTER TABLE "product" ADD CONSTRAINT "product_price_present_check"
CHECK ("priceMmk" IS NOT NULL OR "priceThb" IS NOT NULL);
