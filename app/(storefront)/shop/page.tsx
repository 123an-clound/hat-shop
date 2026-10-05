import { getCatalog } from '@/lib/catalog';
import Catalog from '@/components/storefront/Catalog';
export const metadata={title:'Tất cả mũ',alternates:{canonical:'/shop'}};
export default async function Shop({searchParams}:{searchParams:Promise<Record<string,string|undefined>>}) {const data=await getCatalog();const search=await searchParams;return <Catalog products={data.products} categories={data.categories} query={search.q} onlyNew={search.new==='1'} onlyWishlist={search.wishlist==='1'}/>;}
