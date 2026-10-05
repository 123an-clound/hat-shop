import 'server-only';
import { headers } from 'next/headers';
import { createHash } from 'node:crypto';
import { localMode,localRateLimit } from './local';
import { db } from './supabase/server';
export async function throttle(action:string,max=10,windowMs=60000,identity='') {const h=await headers();const key=createHash('sha256').update(`${action}:${h.get('x-forwarded-for')?.split(',')[0]??'local'}:${identity}`).digest('hex');if(localMode()){localRateLimit(key,max,windowMs);return;}const c=await db();const {error}=await c.rpc('uc_rate_limit',{p_key:key,p_limit:max,p_window:Math.ceil(windowMs/1000)});if(error)throw new Error('Bạn thao tác quá nhanh. Vui lòng thử lại sau ít phút.');}
