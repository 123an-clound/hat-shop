import { notFound } from 'next/navigation';
import { randomUUID } from 'node:crypto';
import { adminUser,list,get } from '@/lib/repository';
import Products from '@/components/admin/Products';
import ProductEditor from '@/components/admin/ProductEditor';
import { OrderList,OrderEditor } from '@/components/admin/Orders';
import { Resources,SettingsEditor,ReviewsAdmin,Customers,AuditLogs } from '@/components/admin/Resources';
import type { Product,Category,Order,Coupon,Banner,Settings,Review,AuditLog } from '@/types';
export default async function AdminPage({params}:{params:Promise<{section:string[]}>}){await adminUser();const {section}=await params;const [name,action,id]=section;
 if(name==='products'&&(action==='new'||action==='edit')){const categories=await list<Category>('categories');let product:Product|null;if(action==='edit'){if(!id)notFound();product=await get<Product>('products',id);if(!product)notFound();}else{const id=randomUUID();product={id,name:'',slug:'',sku:'',category_id:categories[0]?.id??'',description:'',short_description:'',original_price:300000,sale_price:null,material:'100% Cotton Twill',care_instructions:'Giặt nhẹ bằng tay, phơi trong bóng râm.',is_featured:false,is_new_arrival:true,is_trending:false,status:'draft',tags:[],created_at:new Date().toISOString(),variants:[{id:randomUUID(),product_id:id,color_name:'Đen',color_code:'#222222',size:'One Size',stock_quantity:0,image_url:'',additional_images:[],price_adjustment:0,sku_variant:'BLACK-OS'}]};}return <ProductEditor product={product} categories={categories}/>;}
 if((name==='products'||name==='inventory')&&!action)return <Products products={await list<Product>('products')} categories={await list<Category>('categories')} inventory={name==='inventory'}/>;
 if(name==='orders'){if(action){const order=await get<Order>('orders',action);if(!order)notFound();return <OrderEditor order={order} settings={(await list<Settings>('settings'))[0]}/>;}return <OrderList orders={(await list<Order>('orders')).sort((a,b)=>b.created_at.localeCompare(a.created_at))}/>;}
 if(name==='categories'&&!action)return <Resources entity="categories" records={await list<Category>('categories')}/>;
 if(name==='coupons'&&!action)return <Resources entity="coupons" records={await list<Coupon>('coupons')}/>;
 if(name==='banners'&&!action)return <Resources entity="banners" records={await list<Banner>('banners')}/>;
 if(name==='settings'&&!action)return <SettingsEditor settings={(await list<Settings>('settings'))[0]}/>;
 if(name==='reviews'&&!action)return <ReviewsAdmin reviews={await list<Review>('reviews')} products={await list<Product>('products')}/>;
 if(name==='customers'&&!action)return <Customers orders={await list<Order>('orders')}/>;
 if(name==='audit-logs'&&!action)return <AuditLogs logs={(await list<AuditLog>('audit_logs')).sort((a,b)=>b.created_at.localeCompare(a.created_at)).slice(0,200)}/>;
 notFound();}
