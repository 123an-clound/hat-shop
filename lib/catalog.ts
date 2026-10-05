import 'server-only';
import { list } from './repository';
import type { Catalog, Product, Review, Category, Banner, Settings } from '@/types';
export async function getCatalog():Promise<Catalog> {
 const [products,categories,banners,settings]=await Promise.all([list<Product>('products'),list<Category>('categories'),list<Banner>('banners'),list<Settings>('settings')]);
 return {products:products.filter(p=>p.status==='active').sort((a,b)=>a.sku.localeCompare(b.sku)),categories:categories.sort((a,b)=>a.display_order-b.display_order),banners:banners.filter(b=>b.is_active).sort((a,b)=>a.display_order-b.display_order),settings:settings[0]};
}
export async function getReviews(productId:string):Promise<Review[]> {return (await list<Review>('reviews')).filter(r=>r.product_id===productId&&r.is_approved).slice(0,30);}
