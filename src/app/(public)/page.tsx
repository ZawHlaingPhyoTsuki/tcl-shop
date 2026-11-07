import Link from "next/link";

export default function Home() {
  return (
    <div>
      Hello
      <p>Welcome to the home page</p>
      <Link href="/login">Login</Link>
      <Link href="/m/dashboard">Merchant Dashboard</Link>
      <Link href="/admin">Admin Dashboard</Link>
    </div>
  );
}
