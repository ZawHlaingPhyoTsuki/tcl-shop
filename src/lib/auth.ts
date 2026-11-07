import { betterAuth } from "better-auth";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { nextCookies } from "better-auth/next-js";
import { UserRole } from "@/app/generated/prisma/enums";
import prisma from "@/lib/prisma";

export const auth = betterAuth({
  database: prismaAdapter(prisma, {
    provider: "postgresql",
  }),
  emailAndPassword: {
    enabled: true,
  },
  user: {
    additionalFields: {
      role: {
        type: "string",
        required: false, // Set to true if every user MUST have a role immediately
        defaultValue: UserRole.CUSTOMER, // Default role for new signups
        input: false, // Prevents users from setting this via the signUp API (security)
      },
    },
  },
  advanced: {
    database: {
      joins: true,
    },
  },
  plugins: [nextCookies()],
});
