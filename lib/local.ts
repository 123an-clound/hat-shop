import 'server-only';
import { DatabaseSync } from 'node:sqlite';
import { mkdirSync } from 'node:fs';
import path from 'node:path';
import { randomUUID, randomBytes, scryptSync, timingSafeEqual, createHash } from 'node:crypto';
import { cookies } from 'next/headers';
import * as seed from './seed';
export const localMode=()=>!process.env.NEXT_PUBLIC_SUPABASE_URL;
type LocalUser={id:string;email:string;name:string;password_hash:string;role:'admin'|'customer';created_at:string};
let database:DatabaseSync|undefined;
export function localDb(){
 if(process.env.VERCEL)throw new Error('Cần kết nối Supabase trước khi triển khai lên Vercel.');
 if(database)return database;
 mkdirSync(path.join(process.cwd(),'.local'),{recursive:true});
 database=new DatabaseSync(path.join(process.cwd(),'.local','shop.sqlite'));
 database.exec('PRAGMA journal_mode = WAL; PRAGMA busy_timeout = 5000; CREATE TABLE IF NOT EXISTS records (entity TEXT NOT NULL,id TEXT NOT NULL,data TEXT NOT NULL,PRIMARY KEY(entity,id)); CREATE TABLE IF NOT EXISTS users (id TEXT PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,password_hash TEXT NOT NULL,role TEXT NOT NULL,created_at TEXT NOT NULL); CREATE TABLE IF NOT EXISTS sessions (token TEXT PRIMARY KEY,user_id TEXT NOT NULL,expires INTEGER NOT NULL); CREATE TABLE IF NOT EXISTS rate_limits (key TEXT PRIMARY KEY,count INTEGER NOT NULL,expires INTEGER NOT NULL);');
 const seeded=database.prepare("SELECT id FROM records WHERE entity='meta' AND id='seeded'").get();
 if(!seeded){database.exec('BEGIN IMMEDIATE');try{const stmt=database.prepare('INSERT INTO records(entity,id,data) VALUES(?,?,?)');for(const [entity,rows] of Object.entries({products:seed.products,categories:seed.categories,banners:seed.banners,settings:[seed.settings]}))for(const row of rows)stmt.run(entity,String(row.id),JSON.stringify(row));stmt.run('meta','seeded','{}');database.exec('COMMIT');}catch(e){database.exec('ROLLBACK');throw e;}}
 if(process.env.LOCAL_ADMIN_PASSWORD_HASH&&process.env.LOCAL_ADMIN_EMAIL){database.prepare('INSERT OR IGNORE INTO users(id,email,name,password_hash,role,created_at) VALUES(?,?,?,?,?,?)').run(randomUUID(),process.env.LOCAL_ADMIN_EMAIL.toLowerCase(),'Quản trị viên',process.env.LOCAL_ADMIN_PASSWORD_HASH,'admin',new Date().toISOString());}
 return database;
}
export function localList<T>(entity:string):T[]{return (localDb().prepare('SELECT data FROM records WHERE entity=? ORDER BY rowid DESC').all(entity) as {data:string}[]).map(r=>JSON.parse(r.data) as T);}
export function localGet<T>(entity:string,id:string):T|null{const row=localDb().prepare('SELECT data FROM records WHERE entity=? AND id=?').get(entity,id) as {data:string}|undefined;return row?JSON.parse(row.data) as T:null;}
export function localSave<T extends {id:string|number}>(entity:string,row:T){localDb().prepare('INSERT INTO records(entity,id,data) VALUES(?,?,?) ON CONFLICT(entity,id) DO UPDATE SET data=excluded.data').run(entity,String(row.id),JSON.stringify(row));}
export function localDelete(entity:string,id:string){localDb().prepare('DELETE FROM records WHERE entity=? AND id=?').run(entity,id);}
export function transaction<T>(fn:()=>T):T{const d=localDb();d.exec('BEGIN IMMEDIATE');try{const result=fn();d.exec('COMMIT');return result;}catch(e){d.exec('ROLLBACK');throw e;}}
export function passwordHash(password:string){const salt=randomBytes(16).toString('hex');return `${salt}:${scryptSync(password,salt,64).toString('hex')}`;}
export function verifyPassword(password:string,hash:string){const [salt,hex]=hash.split(':');if(!salt||!hex)return false;const actual=scryptSync(password,salt,64);const expected=Buffer.from(hex,'hex');return actual.length===expected.length&&timingSafeEqual(actual,expected);}
export async function localUser(){const token=(await cookies()).get('uc_session')?.value;if(!token)return null;return localDb().prepare('SELECT u.id,u.email,u.name,u.role,u.created_at FROM sessions s JOIN users u ON u.id=s.user_id WHERE s.token=? AND s.expires>?').get(createHash('sha256').update(token).digest('hex'),Date.now()) as Omit<LocalUser,'password_hash'>|undefined??null;}
export async function localLogin(email:string,password:string){const user=localDb().prepare('SELECT * FROM users WHERE email=?').get(email.toLowerCase()) as LocalUser|undefined;const fallback=process.env.LOCAL_ADMIN_PASSWORD_HASH??passwordHash('invalid-placeholder');if(!verifyPassword(password,user?.password_hash??fallback)||!user)throw new Error('Email hoặc mật khẩu không đúng.');const token=randomBytes(32).toString('hex');localDb().prepare('DELETE FROM sessions WHERE expires<?').run(Date.now());localDb().prepare('INSERT INTO sessions VALUES(?,?,?)').run(createHash('sha256').update(token).digest('hex'),user.id,Date.now()+8*60*60*1000);(await cookies()).set('uc_session',token,{httpOnly:true,sameSite:'lax',secure:process.env.NODE_ENV==='production',path:'/',maxAge:8*60*60});return user;}
export async function localLogout(){const jar=await cookies();const token=jar.get('uc_session')?.value;if(token)localDb().prepare('DELETE FROM sessions WHERE token=?').run(createHash('sha256').update(token).digest('hex'));jar.delete('uc_session');}
export function localRegister(email:string,password:string,name:string){try{localDb().prepare('INSERT INTO users VALUES(?,?,?,?,?,?)').run(randomUUID(),email.toLowerCase(),name,passwordHash(password),'customer',new Date().toISOString());}catch{throw new Error('Không thể tạo tài khoản với email này.');}}
export function localRateLimit(key:string,max=10,windowMs=60000){const d=localDb();d.prepare('DELETE FROM rate_limits WHERE expires<?').run(Date.now());const row=d.prepare('INSERT INTO rate_limits VALUES(?,1,?) ON CONFLICT(key) DO UPDATE SET count=count+1 RETURNING count').get(key,Date.now()+windowMs) as {count:number};if(row.count>max)throw new Error('Bạn thao tác quá nhanh. Vui lòng thử lại sau ít phút.');}
