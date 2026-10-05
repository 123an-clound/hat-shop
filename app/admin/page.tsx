import { list,adminUser } from '@/lib/repository';
import type { Order,Product } from '@/types';
import Dashboard from '@/components/admin/Dashboard';
export default async function Page(){await adminUser();const [orders,products]=await Promise.all([list<Order>('orders'),list<Product>('products')]);return <Dashboard orders={orders.sort((a,b)=>b.created_at.localeCompare(a.created_at))} products={products}/>;}
