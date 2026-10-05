import { getCatalog } from '@/lib/catalog';
import Catalog from '@/components/storefront/Catalog';
import { notFound } from 'next/navigation';
export async function generateMetadata({params}:{params:Promise<{category:string}>}){const {category}=await params;const data=await getCatalog();return {title:data.categories.find(c=>c.slug===category)?.name??'Danh mục',alternates:{canonical:`/shop/${category}`}};}
export default async function CategoryPage({params}:{params:Promise<{category:string}>}) {const {category}=await params;const data=await getCatalog();if(!data.categories.some(c=>c.slug===category))notFound();return <Catalog products={data.products} categories={data.categories} category={category}/>;}
