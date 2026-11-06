import { betterAuth } from "better-auth";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { createAccessControl } from "better-auth/plugins/access";
import { admin } from "better-auth/plugins/admin";
import { defaultStatements } from "better-auth/plugins/admin/access";

import type { PrismaClient } from "./generated/client.js";
import { parseCorsOrigins } from "./utils/cors.js";

export type AuthConfig = {
  BETTER_AUTH_URL: string;
  BETTER_AUTH_SECRET: string;
  CORS_ORIGIN: string;
};

// Mirrors the UserRole enum in prisma/schema/auth.prisma.
const ac = createAccessControl(defaultStatements);
const roles = {
  customer: ac.newRole({ user: [], session: [] }),
  merchant: ac.newRole({ user: [], session: [] }),
  admin: ac.newRole(defaultStatements),
};

export function createAuth(env: AuthConfig, database: PrismaClient) {
  const trustedOrigins = parseCorsOrigins(env.CORS_ORIGIN);

  return betterAuth({
    database: prismaAdapter(database, {
      provider: "postgresql",
    }),
    trustedOrigins,
    emailAndPassword: { enabled: true },
    secret: env.BETTER_AUTH_SECRET,
    baseURL: env.BETTER_AUTH_URL, // API Server URL
    plugins: [admin({ defaultRole: "customer", roles })],
  });
}

export type Session = ReturnType<typeof createAuth>["$Infer"]["Session"];
