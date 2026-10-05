import Link from 'next/link';
import { redirect } from 'next/navigation';
import { currentUser,list } from '@/lib/repository';
import { logout } from '@/lib/actions/auth';
import { OrderView } from '@/components/storefront/OrderView';
import type { Order } from '@/types';
export const metadata={title:'Tài khoản',robots:{index:false,follow:false}};
export default async function Account(){const user=await currentUser();if(!user)redirect('/auth/login');const orders=(await list<Order>('orders')).filter(o=>o.user_id===user.id);return <div className="container" style={{maxWidth:1000,paddingBottom:70}}><div className="page-heading"><span className="eyebrow">TÀI KHOẢN CỦA BẠN</span><h1>Chào {user.name}.</h1><p>{user.email}</p><div className="row">{user.role==='admin'&&<Link href="/admin" className="button">Vào trang quản trị</Link>}<form action={logout}><button className="button secondary">Đăng xuất</button></form></div></div><h2 style={{fontSize:27}}>Lịch sử đơn hàng</h2><div className="stack">{orders.length?orders.map(o=><OrderView key={o.id} order={o}/>):<div className="panel"><p>Bạn chưa có đơn hàng nào trong tài khoản này.</p><Link href="/shop" className="text-link">Khám phá sản phẩm</Link></div>}</div></div>;}
