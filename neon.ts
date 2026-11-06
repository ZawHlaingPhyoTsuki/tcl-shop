import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  buckets: {
    "tcl-shop-images": { access: "public_read" },
  },
});
