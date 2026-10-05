import type { CheckoutInput } from './validators';
import type { Coupon, OrderItem, Product, Settings } from '@/types';
import { couponDiscount } from './utils';
export function priceOrder(payload:CheckoutInput,products:Product[],settings:Settings,coupons:Coupon[]) {
 const quantities=new Map<string,number>();for(const item of payload.items)quantities.set(item.variantId,(quantities.get(item.variantId)??0)+item.quantity);
 const items:OrderItem[]=[];
 for(const [id,quantity] of quantities){const p=products.find(p=>p.status==='active'&&p.variants.some(v=>v.id===id));const v=p?.variants.find(v=>v.id===id);if(!p||!v)throw new Error('Một sản phẩm không còn được bán. Hãy cập nhật giỏ hàng.');if(quantity>99||quantity>v.stock_quantity)throw new Error(`${p.name} chỉ còn ${v.stock_quantity} sản phẩm.`);items.push({variant_id:id,product_id:p.id,product_name:p.name,color:v.color_name,size:v.size,quantity,unit_price:(p.sale_price??p.original_price)+v.price_adjustment,image_url:v.image_url});}
 const subtotal=items.reduce((sum,i)=>sum+i.unit_price*i.quantity,0);const coupon=payload.coupon_code?coupons.find(c=>c.code.toUpperCase()===payload.coupon_code.toUpperCase()):undefined;
 if(payload.coupon_code&&!coupon)throw new Error('Mã giảm giá không tồn tại.');const discount_amount=coupon?couponDiscount(coupon,subtotal):0;const shipping_fee=subtotal>=settings.free_shipping_threshold?0:settings.shipping_fee;
 if(payload.payment_method==='vietqr'&&(!settings.bank_code||!settings.bank_account_no||!settings.bank_account_name))throw new Error('Chuyển khoản chưa được bật. Vui lòng chọn COD.');
 return {items,subtotal,discount_amount,shipping_fee,total_amount:subtotal-discount_amount+shipping_fee,coupon};
}
