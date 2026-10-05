import { NextResponse } from 'next/server';
import { randomUUID } from 'node:crypto';
import { mkdir,writeFile } from 'node:fs/promises';
import path from 'node:path';
import sharp from 'sharp';
import { adminUser } from '@/lib/repository';
import { localMode } from '@/lib/local';
import { db } from '@/lib/supabase/server';
import { throttle } from '@/lib/security';
export const runtime='nodejs';
export async function POST(request:Request){try{await adminUser();const origin=request.headers.get('origin');if(!origin||origin!==(process.env.NEXT_PUBLIC_SITE_URL||new URL(request.url).protocol+'//'+request.headers.get('host')))return NextResponse.json({error:'Yêu cầu không hợp lệ.'},{status:403});await throttle('upload',20,60000);if(Number(request.headers.get('content-length'))>9*1024*1024)return NextResponse.json({error:'Tệp quá lớn.'},{status:413});const form=await request.formData();const file=form.get('file');if(!(file instanceof File)||file.size>8*1024*1024||!['image/jpeg','image/png','image/webp'].includes(file.type))return NextResponse.json({error:'Chọn ảnh JPG, PNG hoặc WebP dưới 8 MB.'},{status:400});const bytes=Buffer.from(await file.arrayBuffer());const optimized=await sharp(bytes,{limitInputPixels:24000000}).rotate().resize({width:1600,height:1600,fit:'inside',withoutEnlargement:true}).webp({quality:84}).toBuffer();const name=`${randomUUID()}.webp`;if(localMode()){const dir=path.join(process.cwd(),'.local','uploads');await mkdir(dir,{recursive:true});await writeFile(path.join(dir,name),optimized);return NextResponse.json({url:`/media/${name}`});}const c=await db();const {error}=await c.storage.from('urban-caps').upload(name,optimized,{contentType:'image/webp',upsert:false});if(error)throw new Error('storage');return NextResponse.json({url:c.storage.from('urban-caps').getPublicUrl(name).data.publicUrl});}catch(e){const forbidden=e instanceof Error&&e.message==='Bạn không có quyền quản trị.';return NextResponse.json({error:forbidden?'Bạn không có quyền tải ảnh.':'Không thể xử lý ảnh. Kiểm tra tệp và thử lại.'},{status:forbidden?403:400});}}
