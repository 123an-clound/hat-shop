import type { Metadata } from 'next';
import { Outfit, Plus_Jakarta_Sans } from 'next/font/google';
import './globals.css';
const heading=Outfit({subsets:['latin'],variable:'--font-heading',display:'swap'});
const sans=Plus_Jakarta_Sans({subsets:['latin','vietnamese'],variable:'--font-body',display:'swap'});
const origin=process.env.NEXT_PUBLIC_SITE_URL||'http://localhost:3000';
export const metadata:Metadata={metadataBase:new URL(origin),title:{default:'Urban Caps Studio | Mũ cho phong cách của bạn',template:'%s | Urban Caps Studio'},description:'Khám phá mũ snapback, dad cap, bucket hat và beanie tại Urban Caps Studio. Chọn chiếc mũ hợp gu, đặt hàng dễ dàng và theo dõi đơn trực tuyến.',openGraph:{type:'website',locale:'vi_VN',siteName:'Urban Caps Studio',title:'Urban Caps Studio — Your head. Your rules.',description:'Khám phá bộ sưu tập mũ cho phong cách hằng ngày.',images:[{url:'/images/hero.webp',alt:'Mũ Urban Caps Studio'}]},twitter:{card:'summary_large_image'},robots:process.env.NEXT_PUBLIC_SITE_URL?{index:true,follow:true}:{index:false,follow:false}};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="vi" className={`${heading.variable} ${sans.variable}`}><body><a href="#main-content" className="skip-link">Chuyển đến nội dung</a>{children}</body></html>;}
