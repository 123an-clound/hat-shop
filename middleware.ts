import { createServerClient } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';
export async function middleware(request:NextRequest) {
 let response=NextResponse.next({request});
 if(!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY)return response;
 const client=createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL,process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,{cookies:{getAll:()=>request.cookies.getAll(),setAll(values){values.forEach(({name,value})=>request.cookies.set(name,value));response=NextResponse.next({request});values.forEach(({name,value,options})=>response.cookies.set(name,value,options));}}});
 const {data:{user}}=await client.auth.getUser();
 if(request.nextUrl.pathname.startsWith('/admin')) {const {data}=user?await client.from('uc_admins').select('user_id').eq('user_id',user.id).maybeSingle():{data:null};if(!data){const target=new URL('/auth/login',request.url);target.searchParams.set('redirect',request.nextUrl.pathname);return NextResponse.redirect(target);}}
 return response;
}
export const config={matcher:['/admin/:path*','/account/:path*','/auth/:path*']};
