import type { MetadataRoute } from 'next';
import { getCatalog } from '@/lib/catalog';
export default async function sitemap():Promise<MetadataRoute.Sitemap>{const base=process.env.NEXT_PUBLIC_SITE_URL||'http://localhost:3000';const {products,categories}=await getCatalog();return [...['','/shop','/lookbook','/size-guide','/policies'].map(p=>({url:`${base}${p}`})),...categories.map(c=>({url:`${base}/shop/${c.slug}`})),...products.map(p=>({url:`${base}/product/${p.slug}`,lastModified:new Date(p.created_at)}))];}
