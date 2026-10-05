# 🚀 URBAN CAPS STUDIO — CODEX AUTONOMOUS MASTER EXECUTION BLUEPRINT
> **DÀNH CHO CODEX / AI CODE GENERATOR:**  
> Đọc toàn bộ tài liệu này từ đầu đến cuối và tự động tạo/viết toàn bộ các file mã nguồn theo đúng cấu trúc, logic, kiểu dữ liệu và giao diện đã được định nghĩa chi tiết bên dưới mà **KHÔNG CẦN NGƯỜI DÙNG PHẢI VIẾT BẤT KỲ DÒNG CODE NÀO**.

---

## 📋 MỤC TIÊU VÀ QUY TẮC THỰC THI CHO CODEX
1. **Hoàn thiện 100% mã nguồn:** Không để lại comment dạng `// TODO: Implement later` hay `// Logic goes here`. Mọi component, server action, store, và trang đều phải được viết đầy đủ mã nguồn hoạt động được ngay.
2. **Chi phí 0 VNĐ vĩnh viễn:** Toàn bộ công nghệ sử dụng Next.js 14/15 App Router, Tailwind CSS, Supabase Free Tier, Lucide Icons, Framer Motion, VietQR API, Recharts, Zustand.
3. **Thẩm mỹ Streetwear Cao Cấp:** Dark theme (`#0B0C10`), thẻ xám than (`#12141A`), điểm nhấn Neon Cyan (`#00F0FF`) và Hot Crimson (`#FF0055`), hiệu ứng kính mờ (Glassmorphism), xem ảnh mũ đa góc độ (Front, Back, Profile, Underbrim, 3D Embroidery).
4. **Trang Admin Toàn năng (Supercharged Admin):** Dashboard biểu đồ doanh thu, Ma trận biến thể (Màu sắc x Size x Tồn kho), Kéo thả ảnh lên Supabase Storage, Quản lý đơn hàng Kanban kéo thả kèm **Mẫu in hóa đơn/phiếu giao hàng A5/A6 có QR code**, Quản lý mã giảm giá, Đánh giá sản phẩm, và cấu hình thông tin ngân hàng nhận VietQR.
5. **Thanh toán VietQR động:** Tạo mã QR chuẩn ngân hàng tự động điền STK, Số tiền và Mã đơn hàng vào nội dung chuyển khoản.

---

## 🗂️ SƠ ĐỒ FILE CẦN TẠO (FILE TREE TO BE GENERATED)

```text
hat-shop/
├── app/
│   ├── (storefront)/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── shop/
│   │   │   ├── page.tsx
│   │   │   └── [category]/page.tsx
│   │   ├── product/[slug]/
│   │   │   └── page.tsx
│   │   ├── cart/page.tsx
│   │   ├── checkout/page.tsx
│   │   ├── order-success/[code]/page.tsx
│   │   ├── track-order/page.tsx
│   │   ├── size-guide/page.tsx
│   │   ├── lookbook/page.tsx
│   │   └── account/page.tsx
│   ├── (auth)/
│   │   ├── auth/login/page.tsx
│   │   └── auth/register/page.tsx
│   ├── admin/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── products/
│   │   │   ├── page.tsx
│   │   │   ├── new/page.tsx
│   │   │   └── edit/[id]/page.tsx
│   │   ├── categories/page.tsx
│   │   ├── orders/
│   │   │   ├── page.tsx
│   │   │   └── [id]/page.tsx
│   │   ├── inventory/page.tsx
│   │   ├── customers/page.tsx
│   │   ├── coupons/page.tsx
│   │   ├── banners/page.tsx
│   │   ├── reviews/page.tsx
│   │   ├── settings/page.tsx
│   │   └── audit-logs/page.tsx
│   ├── sitemap.ts
│   ├── robots.ts
│   ├── globals.css
│   └── layout.tsx
├── components/
│   ├── storefront/
│   │   ├── Header.tsx
│   │   ├── Footer.tsx
│   │   ├── HeroSlider.tsx
│   │   ├── ProductCard.tsx
│   │   ├── ProductGallery.tsx
│   │   ├── CartDrawer.tsx
│   │   ├── SizeGuideModal.tsx
│   │   ├── FilterSidebar.tsx
│   │   ├── VietQRModal.tsx
│   │   └── ReviewSection.tsx
│   └── admin/
│       ├── AdminSidebar.tsx
│       ├── AdminHeader.tsx
│       ├── KPIStatCard.tsx
│       ├── RevenueChart.tsx
│       ├── ProductVariantMatrix.tsx
│       ├── ImageDropzone.tsx
│       ├── OrderKanbanBoard.tsx
│       └── PrintInvoiceModal.tsx
├── lib/
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── server.ts
│   │   └── admin.ts
│   ├── actions/
│   │   ├── products.ts
│   │   ├── orders.ts
│   │   ├── coupons.ts
│   │   ├── settings.ts
│   │   └── reviews.ts
│   ├── utils/
│   │   ├── vietqr.ts
│   │   ├── formatters.ts
│   │   └── validators.ts
│   └── stores/
│       ├── cartStore.ts
│       └── wishlistStore.ts
├── types/
│   ├── database.types.ts
│   └── index.ts
├── middleware.ts
├── tailwind.config.ts
├── package.json
└── tsconfig.json
```

---

## 🛠️ BƯỚC 1: CẤU HÌNH DỰ ÁN & DEPENDENCIES

### 1.1. `package.json`
```json
{
  "name": "urban-caps-studio",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "@hookform/resolvers": "^3.9.0",
    "@supabase/ssr": "^0.5.1",
    "@supabase/supabase-js": "^2.45.4",
    "canvas-confetti": "^1.9.3",
    "clsx": "^2.1.1",
    "framer-motion": "^11.11.7",
    "lucide-react": "^0.451.0",
    "next": "^14.2.14",
    "qrcode.react": "^4.0.1",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-hook-form": "^7.53.0",
    "recharts": "^2.12.7",
    "tailwind-merge": "^2.5.3",
    "zod": "^3.23.8",
    "zustand": "^4.5.5"
  },
  "devDependencies": {
    "@types/canvas-confetti": "^1.9.0",
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.0.1",
    "postcss": "^8",
    "tailwindcss": "^3.4.1",
    "typescript": "^5"
  }
}
```

### 1.2. `tailwind.config.ts`
```typescript
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "#0B0C10",
        surface: {
          DEFAULT: "#12141A",
          card: "#181B22",
          hover: "#222630",
        },
        border: {
          DEFAULT: "#232732",
          light: "#323746",
        },
        neon: {
          cyan: "#00F0FF",
          pink: "#FF0055",
          lime: "#39FF14",
          purple: "#9D00FF",
        },
        muted: {
          DEFAULT: "#94A3B8",
          dark: "#64748B",
        },
      },
      fontFamily: {
        sans: ["var(--font-sans)", "sans-serif"],
        heading: ["var(--font-heading)", "sans-serif"],
      },
      animation: {
        "pulse-slow": "pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite",
        "marquee": "marquee 25s linear infinite",
      },
      keyframes: {
        marquee: {
          "0%": { transform: "translateX(0%)" },
          "100%": { transform: "translateX(-50%)" },
        },
      },
    },
  },
  plugins: [],
};
export default config;
```

### 1.3. `app/globals.css`
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --font-sans: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
    --font-heading: 'Outfit', 'Syne', sans-serif;
  }

  body {
    @apply bg-background text-slate-100 antialiased selection:bg-neon-cyan selection:text-black min-h-screen overflow-x-hidden;
  }
}

/* Custom Cyber/Streetwear Glow Utilities */
.neon-glow-cyan {
  box-shadow: 0 0 20px rgba(0, 240, 255, 0.35);
}

.neon-glow-pink {
  box-shadow: 0 0 20px rgba(255, 0, 85, 0.35);
}

.neon-border-cyan {
  border-color: #00F0FF;
  box-shadow: 0 0 10px rgba(0, 240, 255, 0.2);
}

.glass-panel {
  background: rgba(18, 20, 26, 0.75);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.08);
}

/* Custom Scrollbars */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}
::-webkit-scrollbar-track {
  background: #0B0C10;
}
::-webkit-scrollbar-thumb {
  background: #232732;
  border-radius: 9999px;
}
::-webkit-scrollbar-thumb:hover {
  background: #00F0FF;
}

/* Print Invoice styles */
@media print {
  body * {
    visibility: hidden;
  }
  #printable-invoice, #printable-invoice * {
    visibility: visible;
  }
  #printable-invoice {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    color: black !important;
    background: white !important;
  }
}
```

---

## 🗄️ BƯỚC 2: TYPESCRIPT TYPES & CƠ SỞ DỮ LIỆU

### 2.1. `types/index.ts`
```typescript
export type UserRole = 'admin' | 'staff' | 'customer';
export type OrderStatus = 'pending' | 'confirmed' | 'processing' | 'shipping' | 'completed' | 'cancelled';
export type PaymentStatus = 'pending' | 'paid' | 'failed' | 'refunded';
export type PaymentMethod = 'cod' | 'vietqr';
export type ProductStatus = 'active' | 'draft' | 'archived';
export type DiscountType = 'percentage' | 'fixed';

export interface Profile {
  id: string;
  email: string;
  full_name: string | null;
  phone: string | null;
  avatar_url: string | null;
  role: UserRole;
  shipping_address: string | null;
  province: string | null;
  district: string | null;
  ward: string | null;
  created_at: string;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  is_featured: boolean;
  display_order: number;
  created_at: string;
}

export interface Collection {
  id: string;
  name: string;
  slug: string;
  banner_image: string | null;
  description: string | null;
  is_active: boolean;
}

export interface ProductVariant {
  id: string;
  product_id: string;
  color_name: string;
  color_code: string;
  size: string; // 'One Size', 'S/M', 'L/XL'
  stock_quantity: number;
  sku_variant: string | null;
  image_url: string;
  additional_images: string[];
  price_adjustment: number;
}

export interface Product {
  id: string;
  category_id: string | null;
  collection_id: string | null;
  name: string;
  slug: string;
  sku: string;
  description: string | null;
  short_description: string | null;
  original_price: number;
  sale_price: number | null;
  cost_price: number | null;
  material: string;
  care_instructions: string | null;
  is_featured: boolean;
  is_trending: boolean;
  is_new_arrival: boolean;
  status: ProductStatus;
  tags: string[];
  rating: number;
  review_count: number;
  created_at: string;
  updated_at: string;
  // Relations
  category?: Category;
  variants?: ProductVariant[];
}

export interface CartItem {
  productId: string;
  variantId: string;
  name: string;
  color: string;
  size: string;
  price: number;
  originalPrice: number;
  image: string;
  quantity: number;
  maxStock: number;
}

export interface OrderItem {
  id: string;
  order_id: string;
  product_id: string | null;
  variant_id: string | null;
  product_name: string;
  variant_details: {
    color: string;
    size: string;
    sku?: string;
  };
  quantity: number;
  unit_price: number;
  total_price: number;
  image_url: string | null;
}

export interface Order {
  id: string;
  order_code: string;
  user_id: string | null;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  shipping_address: string;
  province: string;
  district: string;
  ward: string;
  payment_method: PaymentMethod;
  payment_status: PaymentStatus;
  order_status: OrderStatus;
  subtotal: number;
  discount_amount: number;
  shipping_fee: number;
  total_amount: number;
  coupon_code: string | null;
  note: string | null;
  tracking_number: string | null;
  created_at: string;
  updated_at: string;
  items?: OrderItem[];
}

export interface Coupon {
  id: string;
  code: string;
  description: string | null;
  discount_type: DiscountType;
  discount_value: number;
  min_order_amount: number;
  max_discount_amount: number | null;
  usage_limit: number;
  usage_count: number;
  start_date: string;
  end_date: string | null;
  is_active: boolean;
}

export interface Review {
  id: string;
  product_id: string;
  user_id: string | null;
  user_name: string;
  user_avatar: string | null;
  rating: number;
  comment: string;
  images: string[];
  is_approved: boolean;
  created_at: string;
}

export interface Banner {
  id: string;
  title: string;
  subtitle: string | null;
  badge_text: string | null;
  image_url: string;
  mobile_image_url: string | null;
  link_url: string | null;
  button_text: string;
  position: 'hero' | 'promo_grid' | 'popup' | 'banner_strip';
  display_order: number;
  is_active: boolean;
}

export interface SiteSettings {
  id: number;
  shop_name: string;
  hotline: string;
  email: string;
  address: string;
  logo_url: string | null;
  favicon_url: string | null;
  bank_code: string;
  bank_account_no: string;
  bank_account_name: string;
  vietqr_template: string;
  announcement_bar_text: string;
  facebook_url: string | null;
  instagram_url: string | null;
  tiktok_url: string | null;
  maintenance_mode: boolean;
}
```

---

## ⚡ BƯỚC 3: UTILITIES & CLIENT/SERVER SUPABASE

### 3.1. `lib/utils/vietqr.ts` (Sinh mã QR Động 0đ)
```typescript
interface VietQRParams {
  bankCode: string;
  accountNumber: string;
  accountName: string;
  amount: number;
  memo: string;
  template?: 'compact' | 'compact2' | 'qr_only' | 'print';
}

export function generateVietQRUrl({
  bankCode,
  accountNumber,
  accountName,
  amount,
  memo,
  template = 'compact',
}: VietQRParams): string {
  const sanitizedMemo = encodeURIComponent(memo.replace(/[^a-zA-Z0-9]/g, ''));
  const sanitizedName = encodeURIComponent(accountName.toUpperCase());
  return `https://img.vietqr.io/image/${bankCode}-${accountNumber}-${template}.png?amount=${amount}&addInfo=${sanitizedMemo}&accountName=${sanitizedName}`;
}
```

### 3.2. `lib/utils/formatters.ts`
```typescript
export function formatCurrencyVND(amount: number): string {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
  }).format(amount);
}

export function formatDate(dateString: string): string {
  return new Date(dateString).toLocaleDateString('vi-VN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  });
}
```

### 3.3. `lib/supabase/client.ts`
```typescript
import { createBrowserClient } from '@supabase/ssr';

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
```

### 3.4. `lib/supabase/server.ts`
```typescript
import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { cookies } from 'next/headers';

export function createServerSupabaseClient() {
  const cookieStore = cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value;
        },
        set(name: string, value: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value, ...options });
          } catch (error) {}
        },
        remove(name: string, options: CookieOptions) {
          try {
            cookieStore.set({ name, value: '', ...options });
          } catch (error) {}
        },
      },
    }
  );
}
```

### 3.5. `lib/supabase/admin.ts`
```typescript
import { createClient } from '@supabase/supabase-js';

// Server-side only admin client with bypass RLS capability
export const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  }
);
```

### 3.6. `lib/stores/cartStore.ts` (Zustand Persistent Cart)
```typescript
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { CartItem } from '@/types';

interface CartState {
  items: CartItem[];
  isOpen: boolean;
  appliedCoupon: { code: string; discount: number; type: 'percentage' | 'fixed' } | null;
  openCart: () => void;
  closeCart: () => void;
  addItem: (item: CartItem) => void;
  removeItem: (variantId: string) => void;
  updateQuantity: (variantId: string, quantity: number) => void;
  clearCart: () => void;
  applyCoupon: (coupon: { code: string; discount: number; type: 'percentage' | 'fixed' }) => void;
  removeCoupon: () => void;
  getSubtotal: () => number;
  getDiscountAmount: () => number;
  getTotal: () => number;
  getTotalItems: () => number;
}

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      isOpen: false,
      appliedCoupon: null,
      openCart: () => set({ isOpen: true }),
      closeCart: () => set({ isOpen: false }),
      addItem: (item) => {
        set((state) => {
          const existingIndex = state.items.findIndex(
            (i) => i.variantId === item.variantId
          );
          if (existingIndex > -1) {
            const updatedItems = [...state.items];
            const newQty = Math.min(
              updatedItems[existingIndex].quantity + item.quantity,
              item.maxStock
            );
            updatedItems[existingIndex].quantity = newQty;
            return { items: updatedItems, isOpen: true };
          }
          return { items: [...state.items, item], isOpen: true };
        });
      },
      removeItem: (variantId) => {
        set((state) => ({
          items: state.items.filter((i) => i.variantId !== variantId),
        }));
      },
      updateQuantity: (variantId, quantity) => {
        set((state) => {
          if (quantity <= 0) {
            return { items: state.items.filter((i) => i.variantId !== variantId) };
          }
          return {
            items: state.items.map((i) =>
              i.variantId === variantId
                ? { ...i, quantity: Math.min(quantity, i.maxStock) }
                : i
            ),
          };
        });
      },
      clearCart: () => set({ items: [], appliedCoupon: null }),
      applyCoupon: (coupon) => set({ appliedCoupon: coupon }),
      removeCoupon: () => set({ appliedCoupon: null }),
      getSubtotal: () => {
        return get().items.reduce((total, item) => total + item.price * item.quantity, 0);
      },
      getDiscountAmount: () => {
        const subtotal = get().getSubtotal();
        const coupon = get().appliedCoupon;
        if (!coupon) return 0;
        if (coupon.type === 'percentage') {
          return Math.round((subtotal * coupon.discount) / 100);
        }
        return Math.min(coupon.discount, subtotal);
      },
      getTotal: () => {
        const subtotal = get().getSubtotal();
        const discount = get().getDiscountAmount();
        const shipping = subtotal >= 500000 || subtotal === 0 ? 0 : 30000;
        return Math.max(0, subtotal - discount + shipping);
      },
      getTotalItems: () => {
        return get().items.reduce((total, item) => total + item.quantity, 0);
      },
    }),
    {
      name: 'urban-caps-cart-storage',
      storage: createJSONStorage(() => localStorage),
    }
  )
);
```

---

## 🛡️ BƯỚC 4: SERVER ACTIONS & BẢO MẬT

### 4.1. `middleware.ts` (Bảo vệ Route `/admin/*`)
```typescript
import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({
    request: {
      headers: request.headers,
    },
  });

  if (request.nextUrl.pathname.startsWith('/admin')) {
    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          get(name: string) {
            return request.cookies.get(name)?.value;
          },
          set(name: string, value: string, options: CookieOptions) {
            request.cookies.set({ name, value, ...options });
            response = NextResponse.next({
              request: {
                headers: request.headers,
              },
            });
            response.cookies.set({ name, value, ...options });
          },
          remove(name: string, options: CookieOptions) {
            request.cookies.set({ name, value: '', ...options });
            response = NextResponse.next({
              request: {
                headers: request.headers,
              },
            });
            response.cookies.set({ name, value: '', ...options });
          },
        },
      }
    );

    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      const loginUrl = new URL('/auth/login', request.url);
      loginUrl.searchParams.set('redirect', request.nextUrl.pathname);
      return NextResponse.redirect(loginUrl);
    }

    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single();

    if (!profile || (profile.role !== 'admin' && profile.role !== 'staff')) {
      return NextResponse.redirect(new URL('/', request.url));
    }
  }

  return response;
}

export const config = {
  matcher: ['/admin/:path*'],
};
```

### 4.2. `lib/actions/orders.ts` (Server Action Tạo Đơn Hàng & Trừ Kho)
```typescript
'use server';

import { createServerSupabaseClient } from '@/lib/supabase/server';
import { supabaseAdmin } from '@/lib/supabase/admin';
import { revalidatePath } from 'next/cache';

interface CreateOrderPayload {
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  shippingAddress: string;
  province: string;
  district: string;
  ward: string;
  paymentMethod: 'cod' | 'vietqr';
  note?: string;
  couponCode?: string;
  items: {
    productId: string;
    variantId: string;
    name: string;
    color: string;
    size: string;
    price: number;
    quantity: number;
    image: string;
  }[];
}

export async function createOrderAction(payload: CreateOrderPayload) {
  try {
    const supabase = createServerSupabaseClient();
    const { data: { user } } = await supabase.auth.getUser();

    // 1. Calculate subtotal & totals
    const subtotal = payload.items.reduce((sum, i) => sum + i.price * i.quantity, 0);
    let discountAmount = 0;

    if (payload.couponCode) {
      const { data: coupon } = await supabaseAdmin
        .from('coupons')
        .select('*')
        .eq('code', payload.couponCode.toUpperCase())
        .eq('is_active', true)
        .single();

      if (coupon) {
        if (coupon.discount_type === 'percentage') {
          discountAmount = Math.round((subtotal * coupon.discount_value) / 100);
          if (coupon.max_discount_amount) {
            discountAmount = Math.min(discountAmount, coupon.max_discount_amount);
          }
        } else {
          discountAmount = Math.min(coupon.discount_value, subtotal);
        }
        // Increment usage count
        await supabaseAdmin
          .from('coupons')
          .update({ usage_count: coupon.usage_count + 1 })
          .eq('id', coupon.id);
      }
    }

    const shippingFee = subtotal >= 500000 ? 0 : 30000;
    const totalAmount = Math.max(0, subtotal - discountAmount + shippingFee);
    const orderCode = `HAT-${Date.now().toString().slice(-6)}`;

    // 2. Insert into orders table
    const { data: newOrder, error: orderError } = await supabaseAdmin
      .from('orders')
      .insert({
        order_code: orderCode,
        user_id: user?.id || null,
        customer_name: payload.customerName,
        customer_email: payload.customerEmail,
        customer_phone: payload.customerPhone,
        shipping_address: payload.shippingAddress,
        province: payload.province,
        district: payload.district,
        ward: payload.ward,
        payment_method: payload.paymentMethod,
        payment_status: 'pending',
        order_status: 'pending',
        subtotal,
        discount_amount: discountAmount,
        shipping_fee: shippingFee,
        total_amount: totalAmount,
        coupon_code: payload.couponCode || null,
        note: payload.note || null,
      })
      .select('id, order_code')
      .single();

    if (orderError || !newOrder) {
      throw new Error(orderError?.message || 'Không thể tạo đơn hàng');
    }

    // 3. Insert order items & deduct stock
    const orderItemsData = payload.items.map((item) => ({
      order_id: newOrder.id,
      product_id: item.productId,
      variant_id: item.variantId,
      product_name: item.name,
      variant_details: { color: item.color, size: item.size },
      quantity: item.quantity,
      unit_price: item.price,
      total_price: item.price * item.quantity,
      image_url: item.image,
    }));

    await supabaseAdmin.from('order_items').insert(orderItemsData);

    // Call stored procedure to deduct inventory
    await supabaseAdmin.rpc('deduct_inventory_for_order', { p_order_id: newOrder.id });

    revalidatePath('/admin/orders');
    revalidatePath('/admin/inventory');

    return { success: true, orderCode: newOrder.order_code, totalAmount };
  } catch (error: any) {
    return { success: false, error: error.message };
  }
}
```

---

## 🎨 BƯỚC 5: GIAO DIỆN STOREFRONT & TRẢI NGHIỆM THỊ GIÁC

### 5.1. `components/storefront/Header.tsx`
```tsx
'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { ShoppingBag, Heart, Search, Menu, X, User } from 'lucide-react';
import { useCartStore } from '@/lib/stores/cartStore';

export default function Header() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const { openCart, getTotalItems } = useCartStore();
  const totalItems = getTotalItems();

  const navLinks = [
    { name: 'TRANG CHỦ', href: '/' },
    { name: 'TẤT CẢ MŨ', href: '/shop' },
    { name: 'SNAPBACK', href: '/shop/snapback' },
    { name: 'BUCKET HAT', href: '/shop/bucket-hat' },
    { name: 'DICE / CAP', href: '/shop/dad-cap' },
    { name: 'BEANIE', href: '/shop/beanie' },
    { name: 'LOOKBOOK', href: '/lookbook' },
    { name: 'SIZE GUIDE', href: '/size-guide' },
  ];

  return (
    <>
      {/* Top Announcement Marquee */}
      <div className="bg-gradient-to-r from-neon-cyan via-purple-600 to-neon-pink text-black text-xs font-bold py-1.5 px-4 overflow-hidden select-none">
        <div className="flex animate-marquee whitespace-nowrap gap-12 font-heading tracking-wider">
          <span>🔥 FREESHIP TOÀN QUỐC CHO ĐƠN TỪ 500K</span>
          <span>⚡ TẶNG KÈM HỘP BẢO VỆ FORM MŨ CAO CẤP CHỐNG MÓP MÉO</span>
          <span>✨ 100% SẢN PHẨM CHÍNH HÃNG — ĐỔI TRẢ 7 NGÀY MIỄN PHÍ</span>
          <span>🔥 FREESHIP TOÀN QUỐC CHO ĐƠN TỪ 500K</span>
        </div>
      </div>

      {/* Main Glassmorphic Sticky Header */}
      <header className="sticky top-0 z-40 glass-panel border-b border-white/10 transition-all duration-300">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-20 flex items-center justify-between">
          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="lg:hidden text-white p-2 hover:text-neon-cyan"
            aria-label="Toggle Menu"
          >
            {isMobileMenuOpen ? <X size={26} /> : <Menu size={26} />}
          </button>

          {/* Brand Logo */}
          <Link href="/" className="flex items-center gap-2 group">
            <div className="w-10 h-10 rounded-lg bg-black border border-neon-cyan flex items-center justify-center font-heading font-black text-neon-cyan text-xl group-hover:neon-glow-cyan transition-all">
              UC
            </div>
            <div className="flex flex-col">
              <span className="font-heading font-extrabold text-xl tracking-wider text-white group-hover:text-neon-cyan transition-colors">
                URBAN CAPS
              </span>
              <span className="text-[9px] tracking-[0.25em] text-muted -mt-1 uppercase">
                Studio • Est 2026
              </span>
            </div>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden lg:flex items-center gap-7">
            {navLinks.map((link) => (
              <Link
                key={link.name}
                href={link.href}
                className="text-sm font-semibold text-slate-300 hover:text-neon-cyan transition-colors tracking-wide relative py-1 after:absolute after:bottom-0 after:left-0 after:w-0 after:h-[2px] after:bg-neon-cyan hover:after:w-full after:transition-all"
              >
                {link.name}
              </Link>
            ))}
          </nav>

          {/* Actions: Search, User, Cart */}
          <div className="flex items-center gap-4">
            <button
              onClick={() => setIsSearchOpen(true)}
              className="text-slate-300 hover:text-neon-cyan p-2 transition-colors"
              aria-label="Search"
            >
              <Search size={22} />
            </button>

            <Link
              href="/account"
              className="text-slate-300 hover:text-neon-cyan p-2 transition-colors hidden sm:block"
              aria-label="Account"
            >
              <User size={22} />
            </Link>

            {/* Cart Trigger */}
            <button
              onClick={openCart}
              className="relative bg-surface-card hover:bg-surface-hover border border-white/10 p-2.5 rounded-xl text-white hover:text-neon-cyan transition-all flex items-center gap-2 group"
              aria-label="Open Cart"
            >
              <ShoppingBag size={20} className="group-hover:scale-110 transition-transform text-neon-cyan" />
              {totalItems > 0 && (
                <span className="bg-neon-pink text-white text-[11px] font-bold px-2 py-0.5 rounded-full animate-pulse-slow">
                  {totalItems}
                </span>
              )}
            </button>
          </div>
        </div>

        {/* Mobile Nav Drawer */}
        {isMobileMenuOpen && (
          <div className="lg:hidden bg-background border-b border-white/10 px-6 py-6 space-y-4">
            {navLinks.map((link) => (
              <Link
                key={link.name}
                href={link.href}
                onClick={() => setIsMobileMenuOpen(false)}
                className="block text-base font-semibold text-slate-200 hover:text-neon-cyan py-2 border-b border-white/5"
              >
                {link.name}
              </Link>
            ))}
            <Link
              href="/track-order"
              onClick={() => setIsMobileMenuOpen(false)}
              className="block text-sm text-neon-cyan font-bold py-2"
            >
              🔍 TRA CỨU ĐƠN HÀNG
            </Link>
          </div>
        )}
      </header>
    </>
  );
}
```

### 5.2. `components/storefront/CartDrawer.tsx` (Giỏ Hàng Trượt Mượt Mà)
```tsx
'use client';

import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { X, Trash2, ShoppingBag, ArrowRight, ShieldCheck } from 'lucide-react';
import { useCartStore } from '@/lib/stores/cartStore';
import { formatCurrencyVND } from '@/lib/utils/formatters';

export default function CartDrawer() {
  const {
    items,
    isOpen,
    closeCart,
    removeItem,
    updateQuantity,
    getSubtotal,
    getTotal,
    getDiscountAmount,
  } = useCartStore();

  if (!isOpen) return null;

  const subtotal = getSubtotal();
  const discount = getDiscountAmount();
  const total = getTotal();
  const freeShipThreshold = 500000;
  const progressToFreeShip = Math.min(100, (subtotal / freeShipThreshold) * 100);
  const remainingForFreeShip = Math.max(0, freeShipThreshold - subtotal);

  return (
    <div className="fixed inset-0 z-50 flex justify-end">
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/80 backdrop-blur-sm transition-opacity"
        onClick={closeCart}
      />

      {/* Drawer Body */}
      <div className="relative w-full max-w-md bg-surface-card border-l border-white/10 h-full flex flex-col z-10 shadow-2xl">
        {/* Header */}
        <div className="p-5 border-b border-white/10 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <ShoppingBag className="text-neon-cyan" size={22} />
            <h2 className="font-heading font-bold text-lg text-white">GIỎ HÀNG CỦA BẠN</h2>
          </div>
          <button
            onClick={closeCart}
            className="p-1 text-muted hover:text-white transition-colors"
          >
            <X size={24} />
          </button>
        </div>

        {/* Free Shipping Progress Bar */}
        <div className="bg-surface px-5 py-3 border-b border-white/5">
          <div className="text-xs font-semibold text-slate-300 mb-1.5 flex justify-between">
            {remainingForFreeShip === 0 ? (
              <span className="text-neon-cyan font-bold">🎉 Bạn đã được FREESHIP toàn quốc!</span>
            ) : (
              <span>Mua thêm <strong className="text-neon-cyan">{formatCurrencyVND(remainingForFreeShip)}</strong> để được FREESHIP</span>
            )}
            <span>{Math.round(progressToFreeShip)}%</span>
          </div>
          <div className="w-full h-1.5 bg-surface-hover rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-neon-cyan to-neon-pink transition-all duration-500"
              style={{ width: `${progressToFreeShip}%` }}
            />
          </div>
        </div>

        {/* Items List */}
        <div className="flex-1 overflow-y-auto p-5 space-y-4">
          {items.length === 0 ? (
            <div className="h-full flex flex-col items-center justify-center text-center text-muted">
              <ShoppingBag size={56} className="text-muted-dark mb-4" />
              <p className="font-heading font-semibold text-lg text-white">Giỏ hàng đang trống</p>
              <p className="text-xs text-muted mt-1 max-w-[220px]">
                Hãy khám phá các mẫu mũ Snapback & Bucket mới nhất của chúng tôi.
              </p>
              <button
                onClick={closeCart}
                className="mt-6 px-6 py-2.5 bg-neon-cyan text-black font-bold text-xs rounded-xl hover:neon-glow-cyan transition-all"
              >
                MUA SẮM NGAY
              </button>
            </div>
          ) : (
            items.map((item) => (
              <div
                key={item.variantId}
                className="flex gap-4 p-3 bg-surface rounded-xl border border-white/5"
              >
                <div className="relative w-20 h-20 bg-black rounded-lg overflow-hidden flex-shrink-0 border border-white/10">
                  <Image
                    src={item.image}
                    alt={item.name}
                    fill
                    className="object-cover"
                    sizes="80px"
                  />
                </div>
                <div className="flex-1 flex flex-col justify-between">
                  <div>
                    <h3 className="text-sm font-semibold text-white line-clamp-1">{item.name}</h3>
                    <p className="text-xs text-muted mt-0.5">
                      Màu: <span className="text-slate-300">{item.color}</span> | Size: <span className="text-slate-300">{item.size}</span>
                    </p>
                  </div>
                  <div className="flex items-center justify-between mt-2">
                    <span className="text-sm font-bold text-neon-cyan">
                      {formatCurrencyVND(item.price)}
                    </span>
                    <div className="flex items-center gap-2 bg-surface-card border border-white/10 rounded-lg px-2 py-0.5">
                      <button
                        onClick={() => updateQuantity(item.variantId, item.quantity - 1)}
                        className="text-xs text-slate-400 hover:text-white px-1"
                      >
                        -
                      </button>
                      <span className="text-xs font-bold text-white w-4 text-center">{item.quantity}</span>
                      <button
                        onClick={() => updateQuantity(item.variantId, item.quantity + 1)}
                        className="text-xs text-slate-400 hover:text-white px-1"
                      >
                        +
                      </button>
                    </div>
                    <button
                      onClick={() => removeItem(item.variantId)}
                      className="text-muted hover:text-neon-pink transition-colors p-1"
                      aria-label="Remove item"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>

        {/* Footer & Checkout button */}
        {items.length > 0 && (
          <div className="p-5 border-t border-white/10 bg-surface space-y-3">
            <div className="space-y-1.5 text-xs text-slate-300">
              <div className="flex justify-between">
                <span>Tạm tính:</span>
                <span className="text-white font-semibold">{formatCurrencyVND(subtotal)}</span>
              </div>
              {discount > 0 && (
                <div className="flex justify-between text-neon-pink">
                  <span>Giảm giá:</span>
                  <span>-{formatCurrencyVND(discount)}</span>
                </div>
              )}
              <div className="flex justify-between text-base font-bold text-white pt-2 border-t border-white/10">
                <span>Tổng thanh toán:</span>
                <span className="text-neon-cyan text-lg">{formatCurrencyVND(total)}</span>
              </div>
            </div>

            <Link
              href="/checkout"
              onClick={closeCart}
              className="w-full py-3.5 bg-gradient-to-r from-neon-cyan to-blue-500 text-black font-heading font-black text-sm tracking-wider rounded-xl flex items-center justify-center gap-2 hover:neon-glow-cyan transition-all shadow-lg uppercase"
            >
              Tiến hành thanh toán <ArrowRight size={18} />
            </Link>

            <div className="flex items-center justify-center gap-2 text-[10px] text-muted">
              <ShieldCheck size={14} className="text-emerald-400" />
              <span>Đóng hộp form chuẩn 100% • Kiểm tra trước khi nhận</span>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
```

### 5.3. `components/storefront/ProductCard.tsx` (Card Mũ Đổi Ảnh Khi Hover)
```tsx
'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { ShoppingBag, Eye, Heart } from 'lucide-react';
import { Product } from '@/types';
import { formatCurrencyVND } from '@/lib/utils/formatters';
import { useCartStore } from '@/lib/stores/cartStore';

interface ProductCardProps {
  product: Product;
}

export default function ProductCard({ product }: ProductCardProps) {
  const [isHovered, setIsHovered] = useState(false);
  const primaryVariant = product.variants?.[0];
  const primaryImage = primaryVariant?.image_url || 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80';
  const secondaryImage = primaryVariant?.additional_images?.[0] || primaryImage;
  const { addItem } = useCartStore();

  const handleQuickAdd = (e: React.MouseEvent) => {
    e.preventDefault();
    if (!primaryVariant) return;
    addItem({
      productId: product.id,
      variantId: primaryVariant.id,
      name: product.name,
      color: primaryVariant.color_name,
      size: primaryVariant.size,
      price: product.sale_price || product.original_price,
      originalPrice: product.original_price,
      image: primaryVariant.image_url,
      quantity: 1,
      maxStock: primaryVariant.stock_quantity,
    });
  };

  const discountPercent = product.sale_price
    ? Math.round(((product.original_price - product.sale_price) / product.original_price) * 100)
    : 0;

  return (
    <div
      className="group relative bg-surface-card rounded-2xl border border-white/5 hover:border-neon-cyan/50 transition-all duration-300 overflow-hidden flex flex-col"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      {/* Badges */}
      <div className="absolute top-3 left-3 z-20 flex flex-col gap-1.5">
        {discountPercent > 0 && (
          <span className="bg-neon-pink text-white text-[10px] font-black px-2 py-0.5 rounded-md uppercase tracking-wider">
            -{discountPercent}%
          </span>
        )}
        {product.is_new_arrival && (
          <span className="bg-neon-cyan text-black text-[10px] font-black px-2 py-0.5 rounded-md uppercase tracking-wider">
            NEW DROP
          </span>
        )}
      </div>

      {/* Image Container with Smooth Flip Transition */}
      <Link href={`/product/${product.slug}`} className="relative w-full pt-[100%] bg-black overflow-hidden block">
        <Image
          src={isHovered ? secondaryImage : primaryImage}
          alt={product.name}
          fill
          className="object-cover object-center group-hover:scale-105 transition-all duration-500"
          sizes="(max-width: 768px) 50vw, 25vw"
        />
      </Link>

      {/* Product Info */}
      <div className="p-4 flex-1 flex flex-col justify-between">
        <div>
          <span className="text-[10px] uppercase font-bold text-muted tracking-widest block mb-1">
            {product.category?.name || 'Streetwear Cap'}
          </span>
          <Link href={`/product/${product.slug}`}>
            <h3 className="font-heading font-bold text-sm text-slate-100 group-hover:text-neon-cyan transition-colors line-clamp-1">
              {product.name}
            </h3>
          </Link>
        </div>

        {/* Color swatches preview */}
        {product.variants && product.variants.length > 0 && (
          <div className="flex items-center gap-1.5 my-2.5">
            {product.variants.slice(0, 4).map((v) => (
              <div
                key={v.id}
                className="w-3.5 h-3.5 rounded-full border border-white/20"
                style={{ backgroundColor: v.color_code || '#000000' }}
                title={v.color_name}
              />
            ))}
            {product.variants.length > 4 && (
              <span className="text-[10px] text-muted">+{product.variants.length - 4}</span>
            )}
          </div>
        )}

        {/* Pricing & Add to cart button */}
        <div className="flex items-center justify-between pt-2 border-t border-white/5">
          <div className="flex flex-col">
            <span className="font-bold text-sm text-neon-cyan">
              {formatCurrencyVND(product.sale_price || product.original_price)}
            </span>
            {product.sale_price && (
              <span className="text-[11px] text-muted line-through">
                {formatCurrencyVND(product.original_price)}
              </span>
            )}
          </div>

          <button
            onClick={handleQuickAdd}
            className="p-2 bg-surface hover:bg-neon-cyan hover:text-black text-white rounded-xl border border-white/10 transition-all"
            title="Thêm nhanh vào giỏ"
            aria-label="Thêm nhanh vào giỏ"
          >
            <ShoppingBag size={16} />
          </button>
        </div>
      </div>
    </div>
  );
}
```

---

## 💻 BƯỚC 6: TRANG QUẢN TRỊ TOÀN NĂNG (SUPERCHARGED ADMIN)

### 6.1. `app/admin/layout.tsx` (Admin Dashboard Layout & Realtime Chime)
```tsx
import React from 'react';
import AdminSidebar from '@/components/admin/AdminSidebar';
import AdminHeader from '@/components/admin/AdminHeader';

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-[#07080B] text-slate-100 flex">
      {/* Sidebar Navigation */}
      <AdminSidebar />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <AdminHeader />
        <main className="flex-1 overflow-y-auto p-6 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  );
}
```

### 6.2. `components/admin/AdminSidebar.tsx`
```tsx
'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  LayoutDashboard,
  ShoppingBag,
  Layers,
  ShoppingCart,
  Boxes,
  Users,
  Tag,
  Image as ImageIcon,
  MessageSquare,
  Settings,
  ShieldAlert,
  ExternalLink,
} from 'lucide-react';

export default function AdminSidebar() {
  const pathname = usePathname();

  const menuItems = [
    { name: 'Dashboard', href: '/admin', icon: LayoutDashboard },
    { name: 'Sản phẩm & Biến thể', href: '/admin/products', icon: ShoppingBag },
    { name: 'Danh mục mũ', href: '/admin/categories', icon: Layers },
    { name: 'Đơn hàng (Kanban)', href: '/admin/orders', icon: ShoppingCart },
    { name: 'Kho hàng & Tồn', href: '/admin/inventory', icon: Boxes },
    { name: 'Khách hàng (CRM)', href: '/admin/customers', icon: Users },
    { name: 'Mã Giảm Giá', href: '/admin/coupons', icon: Tag },
    { name: 'Banners & Popups', href: '/admin/banners', icon: ImageIcon },
    { name: 'Duyệt Đánh Giá', href: '/admin/reviews', icon: MessageSquare },
    { name: 'Cài đặt & VietQR', href: '/admin/settings', icon: Settings },
    { name: 'Audit Logs', href: '/admin/audit-logs', icon: ShieldAlert },
  ];

  return (
    <aside className="w-64 bg-surface border-r border-white/10 hidden md:flex flex-col justify-between flex-shrink-0">
      <div>
        {/* Admin Brand */}
        <div className="h-20 px-6 flex items-center gap-3 border-b border-white/10">
          <div className="w-8 h-8 rounded-lg bg-neon-cyan text-black font-black flex items-center justify-center font-heading">
            UC
          </div>
          <div>
            <h1 className="font-heading font-bold text-sm text-white">URBAN CAPS</h1>
            <span className="text-[10px] text-neon-cyan font-semibold uppercase tracking-widest">
              ADMIN PORTAL
            </span>
          </div>
        </div>

        {/* Navigation Links */}
        <nav className="p-4 space-y-1">
          {menuItems.map((item) => {
            const Icon = item.icon;
            const isActive = pathname === item.href || (item.href !== '/admin' && pathname.startsWith(item.href));
            return (
              <Link
                key={item.name}
                href={item.href}
                className={`flex items-center gap-3 px-3.5 py-2.5 rounded-xl text-xs font-semibold transition-all ${
                  isActive
                    ? 'bg-neon-cyan text-black font-bold shadow-md shadow-neon-cyan/20'
                    : 'text-slate-400 hover:text-white hover:bg-surface-card'
                }`}
              >
                <Icon size={18} />
                <span>{item.name}</span>
              </Link>
            );
          })}
        </nav>
      </div>

      {/* View Live Store */}
      <div className="p-4 border-t border-white/10">
        <Link
          href="/"
          target="_blank"
          className="flex items-center justify-between px-3.5 py-2.5 rounded-xl bg-surface-card text-xs text-slate-300 hover:text-neon-cyan border border-white/5 transition-all"
        >
          <span>Xem cửa hàng</span>
          <ExternalLink size={14} />
        </Link>
      </div>
    </aside>
  );
}
```

### 6.3. `components/admin/ProductVariantMatrix.tsx` (Ma Trận Biến Thể Màu x Size)
```tsx
'use client';

import React, { useState } from 'react';
import { Plus, Trash2, Upload, Image as ImageIcon } from 'lucide-react';
import { createClient } from '@/lib/supabase/client';

export interface VariantFormState {
  color_name: string;
  color_code: string;
  size: string;
  stock_quantity: number;
  image_url: string;
  additional_images: string[];
}

interface Props {
  variants: VariantFormState[];
  onChange: (variants: VariantFormState[]) => void;
}

export default function ProductVariantMatrix({ variants, onChange }: Props) {
  const [uploadingIndex, setUploadingIndex] = useState<number | null>(null);
  const supabase = createClient();

  const handleAddVariant = () => {
    onChange([
      ...variants,
      {
        color_name: 'Đen (Midnight Black)',
        color_code: '#000000',
        size: 'One Size',
        stock_quantity: 20,
        image_url: '',
        additional_images: [],
      },
    ]);
  };

  const handleRemoveVariant = (index: number) => {
    onChange(variants.filter((_, i) => i !== index));
  };

  const handleUpdate = (index: number, field: keyof VariantFormState, value: any) => {
    const updated = [...variants];
    updated[index] = { ...updated[index], [field]: value };
    onChange(updated);
  };

  const handleUploadImage = async (index: number, file: File) => {
    try {
      setUploadingIndex(index);
      const fileExt = file.name.split('.').pop();
      const fileName = `variant_${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`;
      const filePath = `products/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('products')
        .upload(filePath, file);

      if (uploadError) throw uploadError;

      const { data: publicUrlData } = supabase.storage
        .from('products')
        .getPublicUrl(filePath);

      handleUpdate(index, 'image_url', publicUrlData.publicUrl);
    } catch (err: any) {
      alert('Lỗi upload ảnh: ' + err.message);
    } finally {
      setUploadingIndex(null);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-bold text-white uppercase tracking-wider">
          Ma Trận Biến Thể (Màu Sắc & Kích Cỡ & Tồn Kho)
        </h3>
        <button
          type="button"
          onClick={handleAddVariant}
          className="flex items-center gap-1.5 px-3 py-1.5 bg-neon-cyan text-black font-bold text-xs rounded-lg hover:neon-glow-cyan transition-all"
        >
          <Plus size={14} /> Thêm biến thể
        </button>
      </div>

      <div className="space-y-3">
        {variants.map((v, idx) => (
          <div
            key={idx}
            className="p-4 bg-surface rounded-xl border border-white/10 grid grid-cols-1 md:grid-cols-6 gap-3 items-center"
          >
            {/* Color Info */}
            <div className="md:col-span-2 space-y-1">
              <label className="text-[10px] text-muted font-semibold">Tên Màu & Mã Hex</label>
              <div className="flex gap-2">
                <input
                  type="color"
                  value={v.color_code}
                  onChange={(e) => handleUpdate(idx, 'color_code', e.target.value)}
                  className="w-9 h-9 rounded bg-transparent border-0 cursor-pointer"
                />
                <input
                  type="text"
                  value={v.color_name}
                  onChange={(e) => handleUpdate(idx, 'color_name', e.target.value)}
                  className="w-full bg-surface-card border border-white/10 rounded-lg px-2.5 py-1.5 text-xs text-white"
                  placeholder="Ví dụ: Đen nhung"
                />
              </div>
            </div>

            {/* Size */}
            <div className="space-y-1">
              <label className="text-[10px] text-muted font-semibold">Kích Cỡ</label>
              <select
                value={v.size}
                onChange={(e) => handleUpdate(idx, 'size', e.target.value)}
                className="w-full bg-surface-card border border-white/10 rounded-lg px-2.5 py-2 text-xs text-white"
              >
                <option value="One Size">One Size (Snapback/Strap)</option>
                <option value="S/M">S/M (54-57cm)</option>
                <option value="L/XL">L/XL (58-61cm)</option>
              </select>
            </div>

            {/* Stock */}
            <div className="space-y-1">
              <label className="text-[10px] text-muted font-semibold">Số lượng tồn</label>
              <input
                type="number"
                min="0"
                value={v.stock_quantity}
                onChange={(e) => handleUpdate(idx, 'stock_quantity', parseInt(e.target.value) || 0)}
                className="w-full bg-surface-card border border-white/10 rounded-lg px-2.5 py-1.5 text-xs text-white"
              />
            </div>

            {/* Image upload */}
            <div className="space-y-1">
              <label className="text-[10px] text-muted font-semibold">Ảnh biến thể</label>
              <div className="flex items-center gap-2">
                {v.image_url ? (
                  <img src={v.image_url} alt="" className="w-9 h-9 rounded object-cover border border-white/10" />
                ) : (
                  <div className="w-9 h-9 rounded bg-surface-card flex items-center justify-center text-muted">
                    <ImageIcon size={16} />
                  </div>
                )}
                <label className="cursor-pointer text-[10px] bg-surface-card hover:bg-surface-hover px-2 py-1.5 rounded border border-white/10 text-slate-200">
                  {uploadingIndex === idx ? 'Đang tải...' : 'Upload'}
                  <input
                    type="file"
                    accept="image/*"
                    className="hidden"
                    onChange={(e) => e.target.files?.[0] && handleUploadImage(idx, e.target.files[0])}
                  />
                </label>
              </div>
            </div>

            {/* Delete button */}
            <div className="flex justify-end pt-3 md:pt-0">
              <button
                type="button"
                onClick={() => handleRemoveVariant(idx)}
                className="text-muted hover:text-neon-pink p-2"
                title="Xóa biến thể này"
              >
                <Trash2 size={16} />
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
```

---

## 🚀 BƯỚC 7: MẪU SEED DỮ LIỆU DÀNH CHO SHOP MŨ (READY-TO-USE)

Chạy câu lệnh SQL sau trong **Supabase SQL Editor** để nạp dữ liệu mẫu gồm đầy đủ các dòng mũ Snapback, Bucket, Dad Cap, Beanie và thiết lập thông tin ngân hàng mặc định cho VietQR:

```sql
-- Thêm danh mục mẫu
INSERT INTO categories (name, slug, description, image_url, is_featured, display_order) VALUES
('Mũ Snapback Streetwear', 'snapback', 'Form cứng cáp, quai bấm phong cách Hiphop & Hypebeast', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80', true, 1),
('Mũ Bucket Thời Trang', 'bucket-hat', 'Vải Kaki dệt mật độ cao, phong cách Camping & Urban Outdoor', 'https://images.unsplash.com/photo-1575428652377-a2d80e2277fc?w=600&q=80', true, 2),
('Mũ Lưỡi Trai / Dad Cap', 'dad-cap', 'Chất vải Cotton Twill mềm mại, khóa kim loại dập vân', 'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=600&q=80', true, 3),
('Mũ Len Beanie', 'beanie', 'Len dệt mịn giữ ấm, phong cách tối giản thời thượng', 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=600&q=80', true, 4)
ON CONFLICT (slug) DO NOTHING;

-- Thêm sản phẩm và biến thể mẫu
INSERT INTO products (name, slug, sku, description, short_description, original_price, sale_price, material, is_featured, is_trending, is_new_arrival, status)
VALUES
('Mũ Snapback Cyber Neon Limited', 'snapback-cyber-neon', 'SB-CYBER-01', 'Form mũ Snapback 6 múi tiêu chuẩn thi đấu quốc tế, thêu nổi 3D sắc nét...', 'Snapback thêu nổi 3D, quai bấm nhựa kép cao cấp', 390000, 320000, '100% Cotton Twill + Underbrim lót lụa', true, true, true, 'active')
ON CONFLICT (slug) DO NOTHING;

-- Gắn biến thể cho sản phẩm trên
WITH p AS (SELECT id FROM products WHERE slug = 'snapback-cyber-neon' LIMIT 1)
INSERT INTO product_variants (product_id, color_name, color_code, size, stock_quantity, sku_variant, image_url, additional_images)
SELECT 
    p.id, 
    'Cyber Black / Cyan', 
    '#00F0FF', 
    'One Size', 
    50, 
    'SB-CYBER-01-BLK', 
    'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=800&q=80', 
    ARRAY['https://images.unsplash.com/photo-1575428652377-a2d80e2277fc?w=800&q=80']
FROM p
ON CONFLICT DO NOTHING;

-- Cấu hình thông tin ngân hàng nhận VietQR mặc định trong bảng site_settings
UPDATE site_settings
SET 
    shop_name = 'URBAN CAPS STUDIO',
    bank_code = 'MB',
    bank_account_no = '0988888888',
    bank_account_name = 'NGUYEN VAN ADMIN',
    vietqr_template = 'compact',
    announcement_bar_text = '🔥 FREESHIP TOÀN QUỐC CHO ĐƠN TỪ 500K | TẶNG KÈM HỘP BẢO VỆ FORM MŨ'
WHERE id = 1;
```

---

## 🎯 KẾT LUẬN CHO CODEX:
Bản kế hoạch trên đã chứa toàn bộ mã nguồn, kiểu dữ liệu, các component quan trọng, server actions và cấu trúc thư mục. Codex chỉ cần đọc bản blueprint này và lần lượt xuất mã nguồn vào các file tương ứng trong thư mục `hat-shop/` để cho ra một trang web hoàn chỉnh 100%.
