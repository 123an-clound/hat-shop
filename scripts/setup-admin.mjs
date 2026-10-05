import fs from 'node:fs';
import { randomBytes,scryptSync } from 'node:crypto';
const email=process.env.ADMIN_EMAIL;
const password=process.env.ADMIN_PASSWORD;
if(!email||!password||password.length<6)throw new Error('Set ADMIN_EMAIL and ADMIN_PASSWORD (at least 6 characters) for this command.');
const file='.env.local';
const original=fs.existsSync(file)?fs.readFileSync(file,'utf8'):'';
const salt=randomBytes(16).toString('hex');
const hash=scryptSync(password,salt,64).toString('hex');
const lines=original.split(/\r?\n/).filter(l=>l&&!l.startsWith('LOCAL_ADMIN_EMAIL=')&&!l.startsWith('LOCAL_ADMIN_PASSWORD_HASH='));
lines.push(`LOCAL_ADMIN_EMAIL=${email.toLowerCase()}`,`LOCAL_ADMIN_PASSWORD_HASH=${salt}:${hash}`);
fs.writeFileSync(file,lines.join('\n')+'\n');
if(fs.existsSync('.local/shop.sqlite')){
 const {DatabaseSync}=await import('node:sqlite');
 const db=new DatabaseSync('.local/shop.sqlite');
 db.prepare("UPDATE users SET password_hash=? WHERE email=? AND role='admin'").run(`${salt}:${hash}`,email.toLowerCase());
 db.prepare("DELETE FROM sessions WHERE user_id IN(SELECT id FROM users WHERE email=? AND role='admin')").run(email.toLowerCase());
 db.close();
}
console.log('Admin password hash configured. Restart the app. No plaintext password was written.');
