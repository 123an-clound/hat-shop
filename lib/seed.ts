import type { Banner, Category, Product, Settings } from '@/types';
export const images = {
  black: '/images/cap-black.webp', beige: '/images/cap-beige.webp', bucket: '/images/bucket.webp', beanie: '/images/beanie.webp', hero: '/images/hero.webp', lookbook: '/images/lookbook.webp',
};
export const categories: Category[] = [
  { id: '10000000-0000-4000-8000-000000000001', name: 'Snapback', slug: 'snapback', description: 'Form cứng. Chất riêng.', image_url: images.black, display_order: 1 },
  { id: '10000000-0000-4000-8000-000000000002', name: 'Dad cap', slug: 'dad-cap', description: 'Đơn giản, không đơn điệu.', image_url: images.beige, display_order: 2 },
  { id: '10000000-0000-4000-8000-000000000003', name: 'Bucket hat', slug: 'bucket-hat', description: 'Sẵn sàng xuống phố.', image_url: images.bucket, display_order: 3 },
  { id: '10000000-0000-4000-8000-000000000004', name: 'Beanie', slug: 'beanie', description: 'Ấm áp theo cách của bạn.', image_url: images.beanie, display_order: 4 },
];
const definitions: [string,string,number,number | null,number,string,string][] = [
 ['Essential 6-Panel Cap','essential-6-panel-cap',350000,290000,1,images.black,'Trắng'],
 ['Washed Cotton Dad Cap','washed-cotton-dad-cap',320000,null,1,images.beige,'Xám than'],
 ['Urban Explorer Bucket','urban-explorer-bucket',390000,350000,2,images.bucket,'Olive'],
 ['Signature Snapback','signature-snapback',420000,null,0,images.black,'Trắng'],
 ['Daily Ribbed Beanie','daily-ribbed-beanie',260000,null,3,images.beanie,'Nâu / Hồng'],
 ['Weekend Club Cap','weekend-club-cap',350000,299000,1,images.beige,'Xám than'],
 ['Off Duty Snapback','off-duty-snapback',450000,null,0,images.black,'Trắng'],
 ['Trail Utility Bucket','trail-utility-bucket',380000,null,2,images.bucket,'Olive'],
];
export const products: Product[] = definitions.map((d,i) => {
 const id = `20000000-0000-4000-8000-${String(i+1).padStart(12,'0')}`;
 return { id, name:d[0],slug:d[1],sku:`UC-${String(i+1).padStart(3,'0')}`,category_id:categories[d[4]].id,original_price:d[2],sale_price:d[3],short_description:'Một chiếc mũ. Nhiều cách thể hiện.',description:`${d[0]} dành cho những ngày bạn muốn mặc thật thoải mái mà vẫn có điểm nhấn. Form dễ phối, đường may gọn và chất liệu ${d[4]===3?'len dệt mềm':'cotton twill'} phù hợp sử dụng hằng ngày. Ảnh đang dùng là ảnh minh họa; màu sắc và chi tiết sản phẩm sẽ được cửa hàng cập nhật.`,material:d[4]===3?'Len dệt acrylic':'100% Cotton Twill',care_instructions:'Giặt nhẹ bằng tay với nước lạnh. Không dùng chất tẩy. Phơi trong bóng râm và giữ nguyên form mũ.',is_featured:i<4,is_new_arrival:i<3,is_trending:i===3,status:'active',tags:['everyday','streetwear'],created_at:'2026-10-01T00:00:00Z',variants:[{id:`30000000-0000-4000-8000-${String(i+1).padStart(12,'0')}`,product_id:id,color_name:d[6],color_code:['#eeeeee','#515256','#747664','#eeeeee','#8d646c','#515256','#eeeeee','#727462'][i],size:'One Size',stock_quantity:20+i*3,image_url:d[5],additional_images:[],price_adjustment:0,sku_variant:`UC-${String(i+1).padStart(3,'0')}-OS`}] };
});
export const settings: Settings = { id:1,shop_name:'URBAN CAPS STUDIO',hotline:'',email:'phamtuanan3939@gmail.com',address:'',bank_code:'',bank_account_no:'',bank_account_name:'',announcement_bar_text:'FREESHIP TOÀN QUỐC CHO ĐƠN TỪ 500K',instagram_url:'',facebook_url:'',shipping_fee:30000,free_shipping_threshold:500000 };
export const banners: Banner[] = [{ id:'40000000-0000-4000-8000-000000000001',title:'YOUR HEAD.\nYOUR RULES.',subtitle:'Không cần nói nhiều. Một chiếc mũ đúng gu là đủ.\nKhám phá những thiết kế dành cho nhịp sống của bạn.',badge_text:'THE EVERYDAY COLLECTION / 2026',image_url:images.hero,link_url:'/shop',button_text:'KHÁM PHÁ BỘ SƯU TẬP',is_active:true,display_order:0 }];
