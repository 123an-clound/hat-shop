import { getCatalog } from '@/lib/catalog';
import { CartPage } from '@/components/storefront/Checkout';
export const metadata={title:'Giỏ hàng',robots:{index:false,follow:false}};
export default async function Page(){return <CartPage settings={(await getCatalog()).settings}/>;}
