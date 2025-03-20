import './globals.css'
import { Inter, Unbounded } from 'next/font/google'

const inter = Inter({ 
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
})

const unbounded = Unbounded({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-unbounded',
  weight: ['400', '700', '800'],
})

export const metadata = {
  title: 'fun.pump',
  description: 'Pump Tokens',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={`${inter.variable} ${unbounded.variable}`}>
      <body>{children}</body>
    </html>
  )
}
