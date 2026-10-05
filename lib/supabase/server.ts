import 'server-only';
import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';
export const configured = () => Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY);
export async function db() {
 if (!configured()) throw new Error('Chưa kết nối cơ sở dữ liệu.');
 const jar = await cookies();
 return createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL!,process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,{cookies:{getAll:()=>jar.getAll(),setAll(values){try{values.forEach(({name,value,options})=>jar.set(name,value,{...options,sameSite:'lax',secure:process.env.NODE_ENV==='production'}));}catch{/* Server components only read cookies; middleware refreshes sessions. */}}}});
}
export async function getAdmin() { const client=await db();const {data:{user}}=await client.auth.getUser();if(!user)return null;const {data}=await client.from('uc_admins').select('user_id').eq('user_id',user.id).maybeSingle();return data?user:null; }
export async function requireAdmin() { const user=await getAdmin();if(!user)throw new Error('Bạn không có quyền quản trị.');return user; }
