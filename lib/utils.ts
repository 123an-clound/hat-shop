import type { Coupon } from '@/types';
export const money = (amount: number) => new Intl.NumberFormat('vi-VN', { style:'currency',currency:'VND',maximumFractionDigits:0 }).format(amount);
export const date = (value:string) => new Date(value).toLocaleDateString('vi-VN');
export const statusNames = { pending:'Chờ xác nhận',confirmed:'Đã xác nhận',processing:'Đang chuẩn bị',shipping:'Đang giao',completed:'Hoàn thành',cancelled:'Đã hủy' };
export function couponDiscount(c:Coupon,subtotal:number,now = new Date()):number {
 if(!c.is_active || c.usage_count>=c.usage_limit || subtotal<c.min_order_amount || new Date(c.start_date)>now || (c.end_date && new Date(c.end_date)<now)) throw new Error('Mã giảm giá hết hạn hoặc chưa đủ điều kiện.');
 const amount = c.discount_type==='percentage'?Math.round(subtotal*c.discount_value/100):c.discount_value;
 return Math.max(0,Math.min(subtotal,amount,c.max_discount_amount??Infinity));
}
export function vietQR(bank:string,account:string,name:string,amount:number,code:string) {
 if(!/^[a-zA-Z0-9]{2,20}$/.test(bank)||!/^\d{6,30}$/.test(account)||!name.trim())return null;
 return `https://img.vietqr.io/image/${bank}-${account}-compact2.png?${new URLSearchParams({amount:String(Math.round(amount)),addInfo:code.replace(/[^a-zA-Z0-9]/g,''),accountName:name.toUpperCase()})}`;
}
export function safeImage(url:string) { return /^\/(?:images|media)\/[a-zA-Z0-9._-]+$/.test(url) || /^https:\/\//.test(url); }
export function serializeJsonLd(data:unknown){return JSON.stringify(data).replace(/</g,'\\u003c');}
