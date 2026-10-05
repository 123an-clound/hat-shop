-- Run only against an isolated database after database/urban_caps.sql.
-- All fixtures are rolled back. Storage itself needs a real Supabase preview test.
begin;
insert into auth.users(id,email) values
 ('90000000-0000-4000-8000-000000000001','sql-admin@example.test'),
 ('90000000-0000-4000-8000-000000000002','sql-customer@example.test');
insert into uc_admins values('90000000-0000-4000-8000-000000000001');
insert into uc_settings(id,shop_name,email) values(1,'SQL test','sql@example.test');
insert into uc_products(id,name,slug,sku,original_price,sale_price,status)
 values('91000000-0000-4000-8000-000000000001','Test cap','sql-test-cap','SQL-001',350000,290000,'active');
insert into uc_variants(id,product_id,color_name,color_code,size,stock_quantity,image_url,sku_variant)
 values('92000000-0000-4000-8000-000000000001','91000000-0000-4000-8000-000000000001','White','#ffffff','OS',20,'/images/cap-black.webp','SQL-001-OS');
insert into uc_coupons(code,discount_type,discount_value,usage_limit,min_order_amount)
 values('SQL10','percentage',10,1,500000);
set local role anon;
do $$ declare payload jsonb; result jsonb; again jsonb; begin
 payload:='{"requestId":"93000000-0000-4000-8000-000000000001","customer_name":"SQL Customer","customer_email":"sql-customer@example.test","customer_phone":"0901234567","shipping_address":"123 Test Street","province":"Test Province","ward":"Test Ward","payment_method":"cod","coupon_code":"SQL10","total_amount":1,"items":[{"variantId":"92000000-0000-4000-8000-000000000001","quantity":1},{"variantId":"92000000-0000-4000-8000-000000000001","quantity":1}]}';
 result:=public.uc_create_order(payload,repeat('a',64));
 assert (result->'order'->>'subtotal')::bigint=580000,'Authoritative price';
 assert (result->'order'->>'total_amount')::bigint=522000,'Coupon and free shipping';
 assert jsonb_array_length(result->'order'->'items')=1,'Duplicate aggregation';
 again:=public.uc_create_order(payload,repeat('b',64));
 assert again=result,'Idempotent checkout';
 assert public.uc_lookup_order(result->'order'->>'order_code','0900000000') is null,'Phone privacy';
 assert public.uc_order_with_token(result->'order'->>'order_code',repeat('b',64)) is null,'Token privacy';
 assert public.uc_order_with_token(result->'order'->>'order_code',repeat('a',64)) is not null,'Valid token';
 begin
   perform * from public.uc_orders;
   raise exception 'Anonymous order access was allowed';
 exception when insufficient_privilege then null; end;
 begin
   perform public.uc_create_order(jsonb_set(jsonb_set(payload-'coupon_code','{requestId}','"93000000-0000-4000-8000-000000000002"'),'{items}','[{"variantId":"92000000-0000-4000-8000-000000000001","quantity":99}]'),repeat('c',64));
   raise exception 'Overselling was allowed';
 exception when raise_exception then
   if sqlerrm<>'Insufficient stock' then raise; end if;
 end;
end $$;
reset role;
select set_config('request.jwt.claim.sub','90000000-0000-4000-8000-000000000002',true);
set local role authenticated;
do $$ declare affected integer; begin
 assert not public.uc_is_admin(),'Customer is not admin';
 assert (select count(*) from public.uc_orders)=0,'Other customer order privacy';
 update public.uc_products set name='Unauthorized';
 get diagnostics affected=row_count;
 assert affected=0,'Customer cannot edit products';
 begin
   insert into public.uc_admins values('90000000-0000-4000-8000-000000000002');
   raise exception 'Self promotion was allowed';
 exception when insufficient_privilege then null; end;
 begin
   perform public.uc_update_order('{}');
   raise exception 'Unauthorized order update was allowed';
 exception when raise_exception then
   if sqlerrm<>'Forbidden' then raise; end if;
 end;
end $$;
reset role;
select set_config('request.jwt.claim.sub','90000000-0000-4000-8000-000000000001',true);
set local role authenticated;
do $$ declare payload jsonb; target uuid; begin
 assert public.uc_is_admin(),'Admin recognition';
 select to_jsonb(p)||jsonb_build_object('variants',(select jsonb_agg(to_jsonb(v)) from public.uc_variants v where v.product_id=p.id)) into payload from public.uc_products p where p.sku='SQL-001';
 perform public.uc_save_product(jsonb_set(payload,'{name}','"Verified cap"'));
 assert (select name from public.uc_products where sku='SQL-001')='Verified cap','Atomic product save';
 assert (select stock_quantity from public.uc_variants where sku_variant='SQL-001-OS')=18,'Inventory deducted once';
 assert (select usage_count from public.uc_coupons where code='SQL10')=1,'Coupon consumed once';
 select id into target from public.uc_orders where customer_email='sql-customer@example.test';
 perform public.uc_update_order(jsonb_build_object('id',target,'status','cancelled','payment','pending'));
 perform public.uc_update_order(jsonb_build_object('id',target,'status','cancelled','payment','pending'));
 assert (select stock_quantity from public.uc_variants where sku_variant='SQL-001-OS')=20,'Cancellation restocks exactly once';
end $$;
reset role;
rollback;
select 'PASS: checkout, privacy, RLS, role escalation, product save, stock and cancellation' as result;
