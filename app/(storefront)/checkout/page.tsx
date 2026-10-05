import { getCatalog } from '@/lib/catalog';
import Checkout from '@/components/storefront/Checkout';
export const metadata={title:'Thanh toán',robots:{index:false,follow:false}};
export default async function Page(){return <Checkout settings={(await getCatalog()).settings}/>;}
