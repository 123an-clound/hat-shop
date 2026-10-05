import type { MetadataRoute } from 'next';
export default function robots():MetadataRoute.Robots{const base=process.env.NEXT_PUBLIC_SITE_URL;return {rules:{userAgent:'*',allow:base?'/':undefined,disallow:base?['/admin/','/auth/','/account','/cart','/checkout','/track-order','/order-success/','/api/']:'/'},...(base?{sitemap:`${base}/sitemap.xml`}:{})};}
