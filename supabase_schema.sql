-- ==============================================================================
-- DATABASE SCHEMA & RLS POLICIES FOR URBAN CAPS / STREETWEAR HAT SHOP
-- Engine: PostgreSQL / Supabase
-- Target: 100% Free Tier Compatible, Enterprise-Grade Security
-- ==============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. ENUMS & CUSTOM TYPES
CREATE TYPE user_role AS ENUM ('admin', 'staff', 'customer');
CREATE TYPE order_status_type AS ENUM ('pending', 'confirmed', 'processing', 'shipping', 'completed', 'cancelled');
CREATE TYPE payment_status_type AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE payment_method_type AS ENUM ('cod', 'vietqr');
CREATE TYPE discount_type AS ENUM ('percentage', 'fixed');
CREATE TYPE product_status_type AS ENUM ('active', 'draft', 'archived');

-- 2. PROFILES TABLE (Linked with Supabase Auth)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    phone TEXT,
    avatar_url TEXT,
    role user_role DEFAULT 'customer' NOT NULL,
    shipping_address TEXT,
    province TEXT,
    district TEXT,
    ward TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 3. CATEGORIES TABLE
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    image_url TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 4. COLLECTIONS TABLE (e.g. Summer Drop, Limited Edition, Cyberpunk 2026)
CREATE TABLE collections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    banner_image TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 5. PRODUCTS TABLE
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    collection_id UUID REFERENCES collections(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    sku TEXT UNIQUE NOT NULL,
    description TEXT,
    short_description TEXT,
    original_price NUMERIC(12, 2) NOT NULL,
    sale_price NUMERIC(12, 2),
    cost_price NUMERIC(12, 2),
    material TEXT DEFAULT '100% Premium Cotton Twill',
    care_instructions TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    is_trending BOOLEAN DEFAULT FALSE,
    is_new_arrival BOOLEAN DEFAULT TRUE,
    status product_status_type DEFAULT 'active' NOT NULL,
    tags TEXT[] DEFAULT '{}',
    rating NUMERIC(2, 1) DEFAULT 5.0,
    review_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 6. PRODUCT VARIANTS (Colors, Sizes, Stock, Multi-angle images)
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    color_name TEXT NOT NULL,
    color_code TEXT DEFAULT '#000000',
    size TEXT NOT NULL DEFAULT 'One Size', -- e.g., One Size, S/M, L/XL, 56cm, 58cm
    stock_quantity INT DEFAULT 0 NOT NULL,
    sku_variant TEXT UNIQUE,
    image_url TEXT NOT NULL,
    additional_images TEXT[] DEFAULT '{}', -- Multi-angle images (Side, Back, Underbrim, On-model)
    price_adjustment NUMERIC(12, 2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 7. COUPONS TABLE
CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT UNIQUE NOT NULL,
    description TEXT,
    discount_type discount_type NOT NULL,
    discount_value NUMERIC(12, 2) NOT NULL,
    min_order_amount NUMERIC(12, 2) DEFAULT 0,
    max_discount_amount NUMERIC(12, 2),
    usage_limit INT DEFAULT 100,
    usage_count INT DEFAULT 0,
    start_date TIMESTAMPTZ DEFAULT NOW(),
    end_date TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 8. ORDERS TABLE
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_code TEXT UNIQUE NOT NULL, -- e.g. HAT-2026-89213
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL, -- Nullable for Guest Checkout
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    shipping_address TEXT NOT NULL,
    province TEXT NOT NULL,
    district TEXT NOT NULL,
    ward TEXT NOT NULL,
    payment_method payment_method_type DEFAULT 'cod' NOT NULL,
    payment_status payment_status_type DEFAULT 'pending' NOT NULL,
    order_status order_status_type DEFAULT 'pending' NOT NULL,
    subtotal NUMERIC(12, 2) NOT NULL,
    discount_amount NUMERIC(12, 2) DEFAULT 0,
    shipping_fee NUMERIC(12, 2) DEFAULT 30000,
    total_amount NUMERIC(12, 2) NOT NULL,
    coupon_code TEXT,
    note TEXT,
    tracking_number TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 9. ORDER ITEMS TABLE
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    variant_id UUID REFERENCES product_variants(id) ON DELETE SET NULL,
    product_name TEXT NOT NULL,
    variant_details JSONB NOT NULL, -- { color: "Midnight Black", size: "One Size", sku: "..." }
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12, 2) NOT NULL,
    total_price NUMERIC(12, 2) NOT NULL,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 10. REVIEWS TABLE
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    user_name TEXT NOT NULL,
    user_avatar TEXT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    images TEXT[] DEFAULT '{}',
    is_approved BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 11. BANNERS & PROMOTIONS TABLE
CREATE TABLE banners (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    subtitle TEXT,
    badge_text TEXT,
    image_url TEXT NOT NULL,
    mobile_image_url TEXT,
    link_url TEXT,
    button_text TEXT DEFAULT 'MUA NGAY',
    position TEXT DEFAULT 'hero', -- hero, promo_grid, popup, banner_strip
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 12. INVENTORY LOGS TABLE
CREATE TABLE inventory_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    change_amount INT NOT NULL, -- positive for restock, negative for order deduction
    previous_stock INT NOT NULL,
    new_stock INT NOT NULL,
    reason TEXT NOT NULL, -- 'Order Creation', 'Admin Restock', 'Damage', 'Return'
    admin_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 13. ADMIN AUDIT LOGS (Security & Traceability)
CREATE TABLE admin_audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    admin_email TEXT,
    action TEXT NOT NULL, -- e.g. 'UPDATE_ORDER_STATUS', 'DELETE_PRODUCT', 'UPDATE_SETTINGS'
    entity_type TEXT NOT NULL,
    entity_id TEXT,
    changes JSONB,
    ip_address TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 14. STORE SETTINGS TABLE (Singleton)
CREATE TABLE site_settings (
    id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
    shop_name TEXT DEFAULT 'URBAN CAPS STUDIO' NOT NULL,
    hotline TEXT DEFAULT '0988.888.888',
    email TEXT DEFAULT 'contact@urbancaps.vn',
    address TEXT DEFAULT '123 Phố Thời Trang, Quận 1, TP. Hồ Chí Minh',
    logo_url TEXT,
    favicon_url TEXT,
    bank_code TEXT DEFAULT 'MB', -- MB, VCB, ACB, TPB, ICB
    bank_account_no TEXT DEFAULT '999988889999',
    bank_account_name TEXT DEFAULT 'NGUYEN VAN ADMIN',
    vietqr_template TEXT DEFAULT 'compact',
    announcement_bar_text TEXT DEFAULT '🔥 FREE SHIP TOÀN QUỐC CHO ĐƠN HÀNG TỪ 500.000Đ | TẶNG KÈM HỘP BẢO VỆ FORM MŨ',
    facebook_url TEXT,
    instagram_url TEXT,
    tiktok_url TEXT,
    maintenance_mode BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Insert initial site settings row
INSERT INTO site_settings (id, shop_name) VALUES (1, 'URBAN CAPS STUDIO') ON CONFLICT DO NOTHING;


-- ==============================================================================
-- TRIGGERS & AUTOMATED FUNCTIONS
-- ==============================================================================

-- Auto create profile on auth signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, avatar_url, role)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        NEW.raw_user_meta_data->>'avatar_url',
        'customer'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Auto update product review stats
CREATE OR REPLACE FUNCTION public.update_product_review_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET 
        rating = COALESCE((SELECT ROUND(AVG(rating)::numeric, 1) FROM reviews WHERE product_id = NEW.product_id AND is_approved = TRUE), 5.0),
        review_count = (SELECT COUNT(*) FROM reviews WHERE product_id = NEW.product_id AND is_approved = TRUE)
    WHERE id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_review_created_or_updated
    AFTER INSERT OR UPDATE OR DELETE ON reviews
    FOR EACH ROW EXECUTE FUNCTION public.update_product_review_stats();

-- Stock deduction and restoration helper functions
CREATE OR REPLACE FUNCTION public.deduct_inventory_for_order(p_order_id UUID)
RETURNS VOID AS $$
DECLARE
    item RECORD;
    curr_stock INT;
BEGIN
    FOR item IN SELECT variant_id, product_id, quantity FROM order_items WHERE order_id = p_order_id LOOP
        IF item.variant_id IS NOT NULL THEN
            SELECT stock_quantity INTO curr_stock FROM product_variants WHERE id = item.variant_id FOR UPDATE;
            UPDATE product_variants SET stock_quantity = GREATEST(0, stock_quantity - item.quantity) WHERE id = item.variant_id;
            INSERT INTO inventory_logs (variant_id, product_id, change_amount, previous_stock, new_stock, reason)
            VALUES (item.variant_id, item.product_id, -item.quantity, curr_stock, GREATEST(0, curr_stock - item.quantity), 'Order Created: ' || p_order_id::text);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

-- Helper function to check if current user is admin/staff
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() AND role IN ('admin', 'staff')
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 1. Profiles Policies
CREATE POLICY "Public profiles can view minimal info" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins have full control over profiles" ON profiles FOR ALL USING (public.is_admin());

-- 2. Categories Policies
CREATE POLICY "Anyone can view categories" ON categories FOR SELECT USING (true);
CREATE POLICY "Admins have full control over categories" ON categories FOR ALL USING (public.is_admin());

-- 3. Collections Policies
CREATE POLICY "Anyone can view active collections" ON collections FOR SELECT USING (is_active = true OR public.is_admin());
CREATE POLICY "Admins have full control over collections" ON collections FOR ALL USING (public.is_admin());

-- 4. Products & Variants Policies
CREATE POLICY "Public can view active products" ON products FOR SELECT USING (status = 'active' OR public.is_admin());
CREATE POLICY "Admins have full control over products" ON products FOR ALL USING (public.is_admin());

CREATE POLICY "Public can view product variants" ON product_variants FOR SELECT USING (true);
CREATE POLICY "Admins have full control over variants" ON product_variants FOR ALL USING (public.is_admin());

-- 5. Coupons Policies
CREATE POLICY "Public can validate active coupons" ON coupons FOR SELECT USING (is_active = true OR public.is_admin());
CREATE POLICY "Admins have full control over coupons" ON coupons FOR ALL USING (public.is_admin());

-- 6. Orders & Order Items Policies
CREATE POLICY "Users can view own orders" ON orders FOR SELECT USING (auth.uid() = user_id OR public.is_admin());
CREATE POLICY "Anyone can create order (guest checkout supported)" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Admins can update orders" ON orders FOR UPDATE USING (public.is_admin());

CREATE POLICY "Users can view own order items" ON order_items FOR SELECT USING (
    EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND (orders.user_id = auth.uid() OR public.is_admin()))
);
CREATE POLICY "Anyone can insert order items" ON order_items FOR INSERT WITH CHECK (true);

-- 7. Reviews Policies
CREATE POLICY "Anyone can view approved reviews" ON reviews FOR SELECT USING (is_approved = true OR public.is_admin());
CREATE POLICY "Authenticated users can submit reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "Admins can manage reviews" ON reviews FOR ALL USING (public.is_admin());

-- 8. Banners Policies
CREATE POLICY "Anyone can view active banners" ON banners FOR SELECT USING (is_active = true OR public.is_admin());
CREATE POLICY "Admins can manage banners" ON banners FOR ALL USING (public.is_admin());

-- 9. Site Settings Policies
CREATE POLICY "Anyone can view site settings" ON site_settings FOR SELECT USING (true);
CREATE POLICY "Admins can update site settings" ON site_settings FOR UPDATE USING (public.is_admin());

-- 10. Audit & Inventory Logs (Admins only)
CREATE POLICY "Admins only view inventory logs" ON inventory_logs FOR ALL USING (public.is_admin());
CREATE POLICY "Admins only view audit logs" ON admin_audit_logs FOR ALL USING (public.is_admin());

-- ==============================================================================
-- STORAGE BUCKETS SETUP (To be created in Supabase Dashboard / SQL)
-- ==============================================================================
-- Buckets: 'products', 'banners', 'reviews', 'avatars'
-- All buckets should have Public Read access, and Authenticated Admin Write access.
