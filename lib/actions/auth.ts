'use server';
import { z } from 'zod';
import { redirect } from 'next/navigation';
import { revalidatePath } from 'next/cache';
import { loginSchema } from '@/lib/validators';
import { db } from '@/lib/supabase/server';
import { localMode,localLogin,localLogout,localRegister } from '@/lib/local';
import { currentUser } from '@/lib/repository';
import { throttle } from '@/lib/security';
export async function login(input:unknown){try{const data=loginSchema.parse(input);await throttle('login',8,15*60000,data.email.toLowerCase());if(localMode()){await localLogin(data.email,data.password);}else{const c=await db();const {error}=await c.auth.signInWithPassword(data);if(error)throw new Error('Email hoặc mật khẩu không đúng.');}const user=await currentUser();revalidatePath('/','layout');return {success:true,url:user?.role==='admin'?'/admin':'/account',message:''};}catch(e){return {success:false,url:'',message:e instanceof z.ZodError?'Vui lòng nhập email và mật khẩu hợp lệ.':e instanceof Error?e.message:'Không thể đăng nhập.'};}}
export async function register(input:unknown){try{const data=loginSchema.extend({name:z.string().trim().min(2).max(100),password:z.string().min(8).max(128)}).parse(input);await throttle('register',4,60*60000);if(localMode()){localRegister(data.email,data.password,data.name);await localLogin(data.email,data.password);return {success:true,message:'Tạo tài khoản thành công.',url:'/account'};}const c=await db();const {data:result,error}=await c.auth.signUp({email:data.email,password:data.password,options:{data:{full_name:data.name}}});if(error)throw new Error('Không tạo được tài khoản. Kiểm tra email hoặc thử lại.');return {success:true,message:result.session?'Tạo tài khoản thành công.':'Kiểm tra hộp thư để xác nhận email trước khi đăng nhập.',url:result.session?'/account':''};}catch(e){return {success:false,message:e instanceof z.ZodError?'Tên cần ít nhất 2 ký tự, mật khẩu ít nhất 8 ký tự và email hợp lệ.':e instanceof Error?e.message:'Không tạo được tài khoản.',url:''};}}
export async function logout(){if(localMode())await localLogout();else {const c=await db();await c.auth.signOut();}revalidatePath('/','layout');redirect('/auth/login');}
