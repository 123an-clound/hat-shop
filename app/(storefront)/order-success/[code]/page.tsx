import { notFound } from 'next/navigation';
import { successOrder } from '@/lib/actions/store';
import { getCatalog } from '@/lib/catalog';
import { OrderSuccess } from '@/components/storefront/OrderView';
export const metadata={title:'Đặt hàng thành công',robots:{index:false,follow:false}};
export default async function Page({params}:{params:Promise<{code:string}>}){const {code}=await params;const order=await successOrder(code);if(!order)notFound();return <OrderSuccess order={order} settings={(await getCatalog()).settings}/>;}
