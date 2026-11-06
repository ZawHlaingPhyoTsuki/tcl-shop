// Demo catalog for local development. Myanmar strings deserve a
// native-speaker review pass before production use.
import "varlock/auto-load";

import { PrismaPg } from "@prisma/adapter-pg";

import { PrismaClient } from "../src/generated/client.js";
import { ENV } from "../src/env.server.js";

const db = new PrismaClient({
  adapter: new PrismaPg({ connectionString: ENV.DATABASE_URL }),
});

type SeedCategory = { slug: string; nameMy: string; nameEn: string };

const categories: SeedCategory[] = [
  { slug: "drinks", nameMy: "အအေးနှင့် အချိုရည်", nameEn: "Drinks" },
  { slug: "snacks", nameMy: "မုန့်နှင့် သရေစာ", nameEn: "Snacks" },
  { slug: "clothing", nameMy: "အဝတ်အစား", nameEn: "Clothing" },
  { slug: "cosmetics", nameMy: "အလှကုန်", nameEn: "Cosmetics" },
  { slug: "home", nameMy: "အိမ်သုံးပစ္စည်း", nameEn: "Home" },
];

type SeedProduct = {
  slug: string;
  nameMy: string;
  nameEn: string;
  descriptionMy?: string;
  category: string;
  priceMmk?: number;
  priceThb?: number;
  stock: number;
  variants?: { label: string; stock: number; priceMmk?: number; priceThb?: number }[];
};

const products: SeedProduct[] = [
  {
    slug: "shan-noodle-pack",
    nameMy: "ရှမ်းခေါက်ဆွဲ ထုတ်ပိုးခြောက်",
    nameEn: "Shan Noodle Dry Pack",
    descriptionMy: "အိမ်တွင် ချက်စားနိုင်သော ရှမ်းခေါက်ဆွဲခြောက်",
    category: "snacks",
    priceMmk: 3500,
    priceThb: 40,
    stock: 40,
  },
  {
    slug: "myanmar-green-tea",
    nameMy: "မြန်မာ လက်ဖက်ရည်ခြောက်",
    nameEn: "Myanmar Green Tea",
    descriptionMy: "နို့ထည့်ပြီး သောက်နိုင်သော လက်ဖက်ရည်ခြောက်",
    category: "drinks",
    priceMmk: 4500,
    stock: 25,
    variants: [
      { label: "200g", stock: 15 },
      { label: "500g", stock: 10, priceMmk: 9000, priceThb: 100 },
    ],
  },
  {
    slug: "cotton-t-shirt",
    nameMy: "ချည်သား တီရှပ်",
    nameEn: "Cotton T-Shirt",
    descriptionMy: "နေ့စဉ်ဝတ်ဆင်နိုင်သော ချည်သား တီရှပ်",
    category: "clothing",
    priceMmk: 12000,
    priceThb: 130,
    stock: 0,
    variants: [
      { label: "Size: S", stock: 4 },
      { label: "Size: M", stock: 6 },
      { label: "Size: L", stock: 3 },
    ],
  },
  {
    slug: "thanaka-cream",
    nameMy: "သနပ်ခါး လိမ်းဆေး",
    nameEn: "Thanaka Cream",
    descriptionMy: "မြန်မာ့ သနပ်ခါးမှ ထုတ်လုပ်ထားသော လိမ်းဆေး",
    category: "cosmetics",
    priceMmk: 6500,
    stock: 18,
  },
  {
    slug: "bamboo-basket",
    nameMy: "ဝါးခြင်းတောင်း",
    nameEn: "Bamboo Basket",
    descriptionMy: "လက်လုပ်ဝါးခြင်းတောင်း",
    category: "home",
    priceThb: 90,
    stock: 7,
  },
];

async function main() {
  const adminEmail = ENV.ADMIN_EMAIL;
  const admin = await db.user.findUnique({ where: { email: adminEmail } });
  if (!admin) {
    throw new Error(
      `ADMIN_EMAIL ${adminEmail} has not signed up yet. Sign up first, then re-run the seed.`,
    );
  }
  await db.user.update({ where: { id: admin.id }, data: { role: "admin" } });
  console.log(`admin: ${adminEmail} promoted`);

  const merchantEmail = "merchant@example.com";
  const merchant = await db.user.upsert({
    where: { email: merchantEmail },
    update: { role: "merchant" },
    create: {
      id: "demo-merchant-id",
      email: merchantEmail,
      name: "Demo Merchant",
      role: "merchant",
      emailVerified: true,
    },
  });
  console.log(`merchant: ${merchant.email} ready`);

  const categoryIds = new Map<string, string>();
  for (const category of categories) {
    const saved = await db.category.upsert({
      where: { slug: category.slug },
      update: { nameMy: category.nameMy, nameEn: category.nameEn },
      create: category,
    });
    categoryIds.set(saved.slug, saved.id);
  }
  console.log(`categories: ${categoryIds.size} upserted`);

  const shop = await db.shop.upsert({
    where: { slug: "demo-shop" },
    update: { ownerId: merchant.id },
    create: {
      slug: "demo-shop",
      nameMy: "သရုပ်ပြဆိုင်",
      nameEn: "Demo Shop",
      descriptionMy: "စမ်းသပ်ရန် သရုပ်ပြဆိုင်",
      descriptionEn: "Demo storefront for local development",
      phone: "09971234567",
      deliveryNote: "Tachileik in-town delivery, 1-2 days.",
      deliveryFee: 1000,
      currency: "MMK",
      ownerId: merchant.id,
      status: "ACTIVE",
    },
  });
  console.log(`shop: ${shop.slug} ready`);

  for (const product of products) {
    const categoryId = categoryIds.get(product.category);
    if (!categoryId) throw new Error(`unknown seed category: ${product.category}`);

    const saved = await db.product.upsert({
      where: { shopId_slug: { shopId: shop.id, slug: product.slug } },
      update: {
        priceMmk: product.priceMmk,
        priceThb: product.priceThb,
        stock: product.stock,
        categoryId,
        status: "PUBLISHED",
      },
      create: {
        shopId: shop.id,
        slug: product.slug,
        nameMy: product.nameMy,
        nameEn: product.nameEn,
        descriptionMy: product.descriptionMy,
        categoryId,
        priceMmk: product.priceMmk,
        priceThb: product.priceThb,
        stock: product.stock,
        status: "PUBLISHED",
      },
    });

    for (const [index, variant] of (product.variants ?? []).entries()) {
      await db.productVariant.upsert({
        where: { productId_label: { productId: saved.id, label: variant.label } },
        update: {
          stock: variant.stock,
          priceMmk: variant.priceMmk,
          priceThb: variant.priceThb,
          sortOrder: index,
        },
        create: {
          productId: saved.id,
          label: variant.label,
          stock: variant.stock,
          priceMmk: variant.priceMmk,
          priceThb: variant.priceThb,
          sortOrder: index,
        },
      });
    }
  }
  console.log(`products: ${products.length} upserted`);
}

await main()
  .catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => db.$disconnect());
