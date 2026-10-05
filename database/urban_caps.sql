-- Urban Caps schema. Apply to the selected Supabase project only.
-- uc_ prefixes isolate this application from existing project tables.
begin;
create table if not exists public.uc_admins(user_id uuid primary key references auth.users(id) on delete cascade);
create or replace function public.uc_is_admin() returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.uc_admins where user_id=(select auth.uid()));
$$;
revoke all on function public.uc_is_admin() from public;
grant execute on function public.uc_is_admin() to anon,authenticated;
create table if not exists public.uc_categories(
 id uuid primary key default gen_random_uuid(),name text not null,slug text not null unique check(slug ~ '^[a-z0-9-]+$'),
 description text not null default '',image_url text not null,display_order integer not null default 0
);
create table if not exists public.uc_products(
 id uuid primary key default gen_random_uuid(),name text not null check(length(name) between 2 and 160),
 slug text not null unique check(slug ~ '^[a-z0-9-]+$'),sku text not null unique,
 category_id uuid references public.uc_categories(id) on delete restrict,
 description text not null default '',short_description text not null default '',
 original_price bigint not null check(original_price>0),sale_price bigint check(sale_price>=0 and sale_price<=original_price),
 material text not null default '',care_instructions text not null default '',
 is_featured boolean not null default false,is_new_arrival boolean not null default true,is_trending boolean not null default false,
 status text not null default 'draft' check(status in('active','draft','archived')),tags text[] not null default '{}',
 created_at timestamptz not null default now()
);
create table if not exists public.uc_variants(
 id uuid primary key default gen_random_uuid(),product_id uuid not null references public.uc_products(id) on delete cascade,
 color_name text not null,color_code text not null check(color_code ~ '^#[0-9a-fA-F]{6}$'),size text not null,
 stock_quantity integer not null check(stock_quantity between 0 and 100000),
 image_url text not null,additional_images text[] not null default '{}',
 price_adjustment bigint not null default 0 check(price_adjustment>=0),sku_variant text not null,
 unique(product_id,color_name,size)
);
create index if not exists uc_variants_product_idx on public.uc_variants(product_id);
create index if not exists uc_products_category_idx on public.uc_products(category_id);
create table if not exists public.uc_settings(
 id integer primary key check(id=1),shop_name text not null,hotline text not null default '',email text not null,
 address text not null default '',bank_code text not null default '',bank_account_no text not null default '',
 bank_account_name text not null default '',announcement_bar_text text not null default '',
 instagram_url text not null default '',facebook_url text not null default '',
 shipping_fee bigint not null default 30000 check(shipping_fee>=0),
 free_shipping_threshold bigint not null default 500000 check(free_shipping_threshold>=0)
);
create table if not exists public.uc_banners(
 id uuid primary key default gen_random_uuid(),title text not null,subtitle text not null default '',badge_text text not null default '',
 image_url text not null,link_url text not null default '/shop' check(link_url ~ '^/[^/]'),button_text text not null,
 is_active boolean not null default true,display_order integer not null default 0
);
create table if not exists public.uc_coupons(
 id uuid primary key default gen_random_uuid(),code text not null unique,
 discount_type text not null check(discount_type in('percentage','fixed')),discount_value bigint not null check(discount_value>0),
 min_order_amount bigint not null default 0 check(min_order_amount>=0),max_discount_amount bigint check(max_discount_amount>=0),
 usage_limit integer not null check(usage_limit>0),usage_count integer not null default 0 check(usage_count>=0),
 start_date timestamptz not null default now(),end_date timestamptz,is_active boolean not null default true,
 check(discount_type!='percentage' or discount_value<=100),check(end_date is null or end_date>start_date)
);
create table if not exists public.uc_orders(
 id uuid primary key default gen_random_uuid(),order_code text not null unique,user_id uuid references auth.users(id) on delete set null,
 customer_name text not null,customer_email text not null,customer_phone text not null,shipping_address text not null,
 province text not null,ward text not null,note text not null default '',payment_method text not null check(payment_method in('cod','vietqr')),
 payment_status text not null default 'pending' check(payment_status in('pending','paid','refunded')),
 order_status text not null default 'pending' check(order_status in('pending','confirmed','processing','shipping','completed','cancelled')),
 subtotal bigint not null check(subtotal>=0),discount_amount bigint not null default 0 check(discount_amount>=0),
 shipping_fee bigint not null check(shipping_fee>=0),total_amount bigint not null check(total_amount>=0),
 coupon_code text,tracking_number text not null default '',created_at timestamptz not null default now(),
 items jsonb not null check(jsonb_typeof(items)='array'),
 check(total_amount=subtotal-discount_amount+shipping_fee)
);
create index if not exists uc_orders_user_idx on public.uc_orders(user_id);
create index if not exists uc_orders_created_idx on public.uc_orders(created_at desc);
create table if not exists public.uc_reviews(
 id uuid primary key default gen_random_uuid(),product_id uuid not null references public.uc_products(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,user_name text not null,
 rating integer not null check(rating between 1 and 5),comment text not null check(length(comment) between 10 and 2000),
 is_approved boolean not null default false,created_at timestamptz not null default now(),unique(user_id,product_id)
);
create index if not exists uc_reviews_product_idx on public.uc_reviews(product_id);
create table if not exists public.uc_audit_logs(
 id uuid primary key default gen_random_uuid(),actor_id uuid not null references auth.users(id),action text not null,
 entity text not null,created_at timestamptz not null default now()
);
create index if not exists uc_audit_actor_idx on public.uc_audit_logs(actor_id);
create table if not exists public.uc_order_access(
 request_id uuid primary key,order_id uuid not null references public.uc_orders(id),token text not null check(length(token)=64),
 created_at timestamptz not null default now()
);
create index if not exists uc_order_access_order_idx on public.uc_order_access(order_id);
create table if not exists public.uc_limits(key text primary key,count integer not null,expires timestamptz not null);
-- RLS enabled on every exposed table; only specific permissions granted below.
do $$ declare t text; begin foreach t in array array['admins','categories','products','variants','settings','banners','coupons','orders','reviews','audit_logs','order_access','limits'] loop
 execute format('alter table public.uc_%I enable row level security',t);
 execute format('revoke all on public.uc_%I from anon, authenticated',t);
end loop; end $$;
grant select on public.uc_admins to authenticated;
create policy uc_admin_self on public.uc_admins for select to authenticated using(user_id=(select auth.uid()));
grant select on public.uc_categories,public.uc_products,public.uc_variants,public.uc_settings,public.uc_banners,public.uc_coupons,public.uc_reviews to anon,authenticated;
create policy uc_category_read on public.uc_categories for select using(true);
create policy uc_product_read on public.uc_products for select using(status='active' or public.uc_is_admin());
create policy uc_variant_read on public.uc_variants for select using(exists(select 1 from public.uc_products p where p.id=product_id and (p.status='active' or public.uc_is_admin())));
create policy uc_settings_read on public.uc_settings for select using(true);
create policy uc_banner_read on public.uc_banners for select using(is_active or public.uc_is_admin());
create policy uc_coupon_read on public.uc_coupons for select using(is_active or public.uc_is_admin());
create policy uc_review_read on public.uc_reviews for select using(is_approved or user_id=(select auth.uid()) or public.uc_is_admin());
grant select on public.uc_orders,public.uc_audit_logs to authenticated;
create policy uc_orders_read on public.uc_orders for select to authenticated using(user_id=(select auth.uid()) or public.uc_is_admin());
create policy uc_audit_read on public.uc_audit_logs for select to authenticated using(public.uc_is_admin());
do $$ declare t text; begin foreach t in array array['categories','products','variants','settings','banners','coupons','reviews'] loop
 execute format('grant insert, update, delete on public.uc_%I to authenticated',t);
 execute format('create policy uc_admin_write on public.uc_%I for all to authenticated using(public.uc_is_admin()) with check(public.uc_is_admin())',t);
end loop; end $$;
grant insert on public.uc_audit_logs,public.uc_reviews to authenticated;
create policy uc_audit_insert on public.uc_audit_logs for insert to authenticated with check(public.uc_is_admin() and actor_id=(select auth.uid()));
create policy uc_review_submit on public.uc_reviews for insert to authenticated with check(
 user_id=(select auth.uid()) and not is_approved and exists(
 select 1 from public.uc_orders o where o.user_id=(select auth.uid()) and o.order_status='completed'
 and exists(select 1 from jsonb_array_elements(o.items) i where (i->>'product_id')::uuid=product_id)
 ));
-- Atomic rate limiter. Checkout and lookup use fixed limits internally as well.
create or replace function public.uc_rate_limit(p_key text,p_limit integer,p_window integer) returns void
language plpgsql security definer set search_path='' as $$
declare hits integer; begin
 if length(p_key)>200 or p_limit not between 1 and 100 or p_window not between 1 and 86400 then raise exception 'Invalid rate limit'; end if;
 insert into public.uc_limits as l(key,count,expires) values(p_key,1,now()+make_interval(secs=>p_window))
 on conflict(key) do update set count=case when l.expires<now() then 1 else l.count+1 end,
 expires=case when l.expires<now() then now()+make_interval(secs=>p_window) else l.expires end returning count into hits;
 if hits>p_limit then raise exception 'Rate limit exceeded'; end if;
end $$;
revoke all on function public.uc_rate_limit(text,integer,integer) from public;
grant execute on function public.uc_rate_limit(text,integer,integer) to anon,authenticated;
create or replace function public.uc_save_product(payload jsonb) returns void
language plpgsql security invoker set search_path='' as $$
declare p public.uc_products; v public.uc_variants; r jsonb; begin
 if not public.uc_is_admin() then raise exception 'Forbidden'; end if;
 p:=jsonb_populate_record(null::public.uc_products,payload-'variants');
 if jsonb_array_length(payload->'variants') not between 1 and 50 then raise exception 'Invalid variants'; end if;
 if exists(select 1 from jsonb_array_elements(payload->'variants') x where (x->>'product_id')::uuid<>p.id) then raise exception 'Invalid product'; end if;
 insert into public.uc_products values(p.*) on conflict(id) do update set
 name=excluded.name,slug=excluded.slug,sku=excluded.sku,category_id=excluded.category_id,description=excluded.description,
 short_description=excluded.short_description,original_price=excluded.original_price,sale_price=excluded.sale_price,
 material=excluded.material,care_instructions=excluded.care_instructions,is_featured=excluded.is_featured,
 is_new_arrival=excluded.is_new_arrival,is_trending=excluded.is_trending,status=excluded.status,tags=excluded.tags;
 if exists(select 1 from public.uc_variants existing_variant cross join public.uc_orders o cross join lateral jsonb_array_elements(o.items) i
 where existing_variant.product_id=p.id and o.order_status not in('completed','cancelled') and i->>'variant_id'=existing_variant.id::text
 and not exists(select 1 from jsonb_array_elements(payload->'variants') n where n->>'id'=existing_variant.id::text)) then raise exception 'Variant has open orders'; end if;
 delete from public.uc_variants where product_id=p.id and id not in(select (x->>'id')::uuid from jsonb_array_elements(payload->'variants') x);
 for r in select * from jsonb_array_elements(payload->'variants') loop
 v:=jsonb_populate_record(null::public.uc_variants,r);
 if exists(select 1 from public.uc_variants old where old.id=v.id and old.product_id<>p.id) then raise exception 'Invalid variant owner'; end if;
 insert into public.uc_variants values(v.*) on conflict(id) do update set color_name=excluded.color_name,color_code=excluded.color_code,
 size=excluded.size,stock_quantity=excluded.stock_quantity,image_url=excluded.image_url,additional_images=excluded.additional_images,
 price_adjustment=excluded.price_adjustment,sku_variant=excluded.sku_variant;
 end loop;
end $$;
revoke all on function public.uc_save_product(jsonb) from public;
grant execute on function public.uc_save_product(jsonb) to authenticated;
-- A single transaction validates prices, aggregates duplicate variants, locks stock
-- and coupon rows, then creates an order. Clients cannot supply totals or statuses.
create or replace function public.uc_create_order(payload jsonb,access_token text) returns jsonb
language plpgsql security definer set search_path='' as $$
declare s public.uc_settings; c public.uc_coupons; p public.uc_products; v public.uc_variants; o public.uc_orders;
 r record; prior public.uc_order_access; lines jsonb:='[]'; subtotal bigint:=0; discount bigint:=0; shipping bigint; amount bigint;
 req uuid:=(payload->>'requestId')::uuid; begin
 if length(access_token)<>64 or access_token !~ '^[a-f0-9]+$' then raise exception 'Invalid token'; end if;
 perform pg_advisory_xact_lock(hashtextextended(req::text,0));
 select * into prior from public.uc_order_access where request_id=req;
 if found then select * into o from public.uc_orders where id=prior.order_id; return jsonb_build_object('order',to_jsonb(o),'token',prior.token); end if;
 if length(payload->>'customer_name') not between 2 and 100 or
 coalesce(payload->>'customer_email','') !~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$' or
 length(payload->>'customer_email')>254 or coalesce(payload->>'customer_phone','') !~ '^(0|\+84)[0-9]{9,10}$' or
 length(payload->>'shipping_address') not between 8 and 400 or length(payload->>'province') not between 2 and 100 or
 length(payload->>'ward') not between 2 and 100 or length(coalesce(payload->>'note',''))>1000 or
 coalesce(payload->>'payment_method','') not in('cod','vietqr') then raise exception 'Invalid customer'; end if;
 if jsonb_typeof(payload->'items')<>'array' or jsonb_array_length(payload->'items') not between 1 and 50 then raise exception 'Invalid items'; end if;
 perform public.uc_rate_limit('order:'||lower(payload->>'customer_email'),8,600);
 select * into strict s from public.uc_settings where id=1;
 if payload->>'payment_method'='vietqr' and (s.bank_code='' or s.bank_account_no='' or s.bank_account_name='') then raise exception 'Bank not configured'; end if;
 for r in select (i->>'variantId')::uuid as id,sum((i->>'quantity')::numeric) as quantity
 from jsonb_array_elements(payload->'items') i group by 1 order by 1 loop
 if r.quantity not between 1 and 99 or r.quantity<>trunc(r.quantity) then raise exception 'Invalid quantity'; end if;
 if exists(select 1 from jsonb_array_elements(payload->'items') i where (i->>'quantity')::numeric<=0 or (i->>'quantity')::numeric<>trunc((i->>'quantity')::numeric)) then raise exception 'Invalid quantity'; end if;
 select * into strict v from public.uc_variants where id=r.id for update;
 select * into strict p from public.uc_products where id=v.product_id;
 if p.status<>'active' or v.stock_quantity<r.quantity then raise exception 'Insufficient stock'; end if;
 amount:=coalesce(p.sale_price,p.original_price)+v.price_adjustment; subtotal:=subtotal+amount*r.quantity;
 lines:=lines||jsonb_build_array(jsonb_build_object('variant_id',v.id,'product_id',p.id,'product_name',p.name,
 'color',v.color_name,'size',v.size,'quantity',r.quantity,'unit_price',amount,'image_url',v.image_url));
 update public.uc_variants set stock_quantity=stock_quantity-r.quantity where id=v.id;
 end loop;
 if coalesce(payload->>'coupon_code','')<>'' then
 select * into strict c from public.uc_coupons where code=upper(payload->>'coupon_code') for update;
 if not c.is_active or c.usage_count>=c.usage_limit or c.start_date>now() or c.end_date<now() or subtotal<c.min_order_amount then raise exception 'Invalid coupon'; end if;
 discount:=case when c.discount_type='percentage' then round(subtotal*c.discount_value/100.0) else c.discount_value end;
 discount:=least(subtotal,discount,coalesce(c.max_discount_amount,discount));
 update public.uc_coupons set usage_count=usage_count+1 where id=c.id;
 end if;
 shipping:=case when subtotal>=s.free_shipping_threshold then 0 else s.shipping_fee end;
 insert into public.uc_orders(order_code,user_id,customer_name,customer_email,customer_phone,shipping_address,province,ward,note,
 payment_method,subtotal,discount_amount,shipping_fee,total_amount,coupon_code,items)
 values('UC'||upper(replace(gen_random_uuid()::text,'-','')),auth.uid(),payload->>'customer_name',payload->>'customer_email',
 payload->>'customer_phone',payload->>'shipping_address',payload->>'province',payload->>'ward',coalesce(payload->>'note',''),
 payload->>'payment_method',subtotal,discount,shipping,subtotal-discount+shipping,c.code,lines) returning * into o;
 insert into public.uc_order_access(request_id,order_id,token) values(req,o.id,access_token);
 return jsonb_build_object('order',to_jsonb(o),'token',access_token);
end $$;
revoke all on function public.uc_create_order(jsonb,text) from public;
grant execute on function public.uc_create_order(jsonb,text) to anon,authenticated;
create or replace function public.uc_lookup_order(p_code text,p_phone text) returns jsonb
language plpgsql security definer set search_path='' as $$
declare o public.uc_orders; begin
 perform public.uc_rate_limit('lookup:'||left(p_code,40),8,60);
 select * into o from public.uc_orders where order_code=p_code and customer_phone=p_phone;
 if not found then return null; end if;return to_jsonb(o);
end $$;
create or replace function public.uc_order_with_token(p_code text,p_token text) returns jsonb
language sql security definer set search_path='' as $$
 select to_jsonb(o) from public.uc_orders o join public.uc_order_access a on a.order_id=o.id
 where o.order_code=p_code and a.token=p_token and a.created_at>now()-interval '7 days';
$$;
revoke all on function public.uc_lookup_order(text,text),public.uc_order_with_token(text,text) from public;
grant execute on function public.uc_lookup_order(text,text),public.uc_order_with_token(text,text) to anon,authenticated;
create or replace function public.uc_update_order(payload jsonb) returns void
language plpgsql security definer set search_path='' as $$
declare o public.uc_orders; target text:=payload->>'status'; paid text:=payload->>'payment'; i jsonb; allowed text[]; begin
 if not public.uc_is_admin() then raise exception 'Forbidden'; end if;
 select * into strict o from public.uc_orders where id=(payload->>'id')::uuid for update;
 allowed:=case o.order_status when 'pending' then array['confirmed','cancelled'] when 'confirmed' then array['processing','cancelled']
 when 'processing' then array['shipping','cancelled'] when 'shipping' then array['completed'] else '{}'::text[] end;
 if target<>o.order_status and not target=any(allowed) then raise exception 'Invalid transition'; end if;
 if paid='refunded' and o.payment_status='pending' then raise exception 'Unpaid order'; end if;
 if paid='pending' and o.payment_status='paid' then raise exception 'Already paid'; end if;
 if target='completed' and paid<>'paid' then raise exception 'Payment required'; end if;
 if target='cancelled' and o.order_status<>'cancelled' then
 for i in select * from jsonb_array_elements(o.items) order by value->>'variant_id' loop
 update public.uc_variants set stock_quantity=stock_quantity+(i->>'quantity')::integer where id=(i->>'variant_id')::uuid;
 end loop;end if;
 update public.uc_orders set order_status=target,payment_status=paid,tracking_number=left(coalesce(payload->>'tracking',''),100) where id=o.id;
end $$;
revoke all on function public.uc_update_order(jsonb) from public;
grant execute on function public.uc_update_order(jsonb) to authenticated;
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('urban-caps','urban-caps',true,8388608,array['image/webp']) on conflict(id) do nothing;
create policy uc_storage_read on storage.objects for select using(bucket_id='urban-caps');
create policy uc_storage_insert on storage.objects for insert to authenticated with check(bucket_id='urban-caps' and public.uc_is_admin());
create policy uc_storage_update on storage.objects for update to authenticated using(bucket_id='urban-caps' and public.uc_is_admin()) with check(bucket_id='urban-caps' and public.uc_is_admin());
create policy uc_storage_delete on storage.objects for delete to authenticated using(bucket_id='urban-caps' and public.uc_is_admin());
commit;
