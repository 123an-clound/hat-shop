import { redirect } from 'next/navigation';
import { currentUser } from '@/lib/repository';
import AdminShell from '@/components/admin/AdminShell';
export const dynamic='force-dynamic';
export const metadata={title:'Quản trị cửa hàng',robots:{index:false,follow:false}};
export default async function Layout({children}:{children:React.ReactNode}){const user=await currentUser();if(!user||user.role!=='admin')redirect('/auth/login');return <AdminShell email={user.email}>{children}</AdminShell>;}
