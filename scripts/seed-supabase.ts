import { createClient } from '@supabase/supabase-js';
import { products,categories,banners,settings } from '../lib/seed';
const url=process.env.NEXT_PUBLIC_SUPABASE_URL;
const key=process.env.SUPABASE_SERVICE_ROLE_KEY;
const email=process.env.ADMIN_EMAIL;
const password=process.env.ADMIN_PASSWORD;
if(!url||!key||!email||!password)throw new Error('Set Supabase URL, service-role key, ADMIN_EMAIL and ADMIN_PASSWORD in the shell. Apply database/urban_caps.sql first.');
const client=createClient(url,key,{auth:{persistSession:false,autoRefreshToken:false}});
async function seed(){
 const results=await Promise.all([
  client.from('uc_categories').upsert(categories,{onConflict:'id',ignoreDuplicates:true}),
  client.from('uc_settings').upsert([settings],{onConflict:'id',ignoreDuplicates:true}),
  client.from('uc_banners').upsert(banners,{onConflict:'id',ignoreDuplicates:true}),
 ]);
 for(const result of results)if(result.error)throw result.error;
 const {error:productsError}=await client.from('uc_products').upsert(products.map(({variants:_variants,...p})=>p),{onConflict:'id',ignoreDuplicates:true});if(productsError)throw productsError;
 const {error:variantsError}=await client.from('uc_variants').upsert(products.flatMap(p=>p.variants),{onConflict:'id',ignoreDuplicates:true});if(variantsError)throw variantsError;
 const {data,error}=await client.auth.admin.createUser({email:email!,password:password!,email_confirm:true,user_metadata:{full_name:'Quản trị viên'}});
 if(error)throw new Error(`Không tạo được tài khoản admin: ${error.message}. Tài khoản có sẵn không bị đổi mật khẩu hoặc tự nâng quyền.`);
 const {error:roleError}=await client.from('uc_admins').insert({user_id:data.user.id});if(roleError)throw roleError;
 console.log('Seeded catalog and created the administrator. Existing catalog records were preserved.');
}
seed().catch(error=>{console.error(error.message);process.exitCode=1;});
