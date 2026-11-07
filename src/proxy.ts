import { headers } from "next/headers";
import { type NextRequest, NextResponse } from "next/server";
import { auth } from "@/lib/auth";

export async function proxy(request: NextRequest) {
  const pathname = request.nextUrl.pathname;

  // Define which paths require authentication
  const isProtected =
    pathname.startsWith("/checkout") ||
    pathname.startsWith("/orders") ||
    pathname.startsWith("/profile") ||
    pathname.startsWith("/m") ||
    pathname.startsWith("/admin");

  // Only perform DB checks if the user is trying to access a protected route
  if (isProtected) {
    const session = await auth.api.getSession({
      headers: await headers(),
    });

    if (!session) {
      return NextResponse.redirect(new URL("/login", request.url));
    }

    // Role-based checks
    if (pathname.startsWith("/m") && session.user.role !== "MERCHANT") {
      return NextResponse.redirect(new URL("/", request.url));
    }

    if (pathname.startsWith("/admin") && session.user.role !== "ADMIN") {
      return NextResponse.redirect(new URL("/", request.url));
    }
  }

  return NextResponse.next();
}

// This matcher ensures the proxy runs for all app routes but skips
// static assets, images, and API routes to prevent loops and improve speed.
export const config = {
  matcher: [
    "/((?!api|_next/static|_next/image|favicon.ico|sitemap.xml|robots.txt|.*\\.(?:png|jpg|jpeg|gif|svg|webp)$).*)",
  ],
};
