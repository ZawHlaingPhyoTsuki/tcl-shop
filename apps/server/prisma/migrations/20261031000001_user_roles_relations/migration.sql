-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('customer', 'merchant', 'admin');

-- DropIndex
DROP INDEX "shop_ownerId_idx";

-- AlterTable
ALTER TABLE "user" DROP COLUMN "role",
ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'customer';

-- CreateIndex
CREATE UNIQUE INDEX "shop_ownerId_key" ON "shop"("ownerId");

-- AddForeignKey
ALTER TABLE "shop_order" ADD CONSTRAINT "shop_order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shop" ADD CONSTRAINT "shop_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
