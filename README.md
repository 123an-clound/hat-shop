# Urban Caps Studio

Website bán mũ theo `HAT_SHOP_MASTER_BLUEPRINT.md`: Next.js 15, React, TypeScript, Tailwind CSS, Zustand, Recharts. Giao diện tiếng Việt, responsive.

## Chạy trên máy

Yêu cầu Node.js 24 trở lên (chế độ local dùng SQLite tích hợp).

```powershell
npm install
npm run dev
```

- Cửa hàng: http://127.0.0.1:3000
- Đăng nhập: http://127.0.0.1:3000/auth/login
- Quản trị: http://127.0.0.1:3000/admin

Tài khoản admin đã được cấu hình trong `.env.local` trên máy hiện tại theo thông tin bạn cung cấp. Mật khẩu được băm scrypt, không có trong source hay mã gửi ra trình duyệt. Phiên đăng nhập dùng cookie HttpOnly, hết hạn sau 8 giờ.

Dữ liệu lưu tại `.local/shop.sqlite`, ảnh tải lên tại `.local/uploads`. Sao lưu cả thư mục `.local` và `.env.local`; không đưa chúng lên Git. Đây là chế độ cho một máy/một server có ổ đĩa bền vững, không dùng trực tiếp trên Vercel.

## Quản trị

1. **Sản phẩm**: thêm/sửa tên, mô tả, giá, danh mục, trạng thái, màu/size/tồn kho. Tải JPG/PNG/WebP hoặc dán URL HTTPS. Ảnh tải lên được chuyển WebP và giới hạn 1600 px.
2. **Đơn hàng**: dạng bảng hoặc Kanban. Xác nhận → chuẩn bị → đang giao → hoàn thành; chỉ hoàn thành sau khi đánh dấu đã thanh toán. Hủy trước khi giao sẽ hoàn tồn kho đúng một lần.
3. **In phiếu**: mở đơn → In phiếu → chọn A5/A6. QR chứa mã đơn; với VietQR, QR chuyển khoản chứa số tiền và nội dung.
4. **Cài đặt**: nhập thông tin liên hệ, phí giao hàng và tài khoản ngân hàng thật. Khi chưa có ngân hàng, checkout chỉ cho COD.
5. **Danh mục, banner, mã giảm giá, đánh giá, khách hàng, nhật ký**: quản lý từ thanh bên.

Mẫu sản phẩm và giá là dữ liệu minh họa. Nguồn ảnh trong `docs/IMAGE-SOURCES.md`. Không có đánh giá/doanh thu giả.

## Supabase

Chưa ghi dữ liệu lên dự án Supabase nào vì chưa xác định dự án đích.

1. Chọn đúng dự án rồi chạy **`database/urban_caps.sql`** một lần trong SQL Editor. Schema dùng prefix `uc_` để tránh trùng bảng dự án khác. Không chạy file `supabase_schema.sql` gốc: bản gốc cho phép cập nhật role trong profile và tạo đơn không kiểm soát giá.
2. Điền `NEXT_PUBLIC_SUPABASE_URL` và `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` vào `.env.local`.
3. Thiết lập tạm `SUPABASE_SERVICE_ROLE_KEY`, `ADMIN_EMAIL`, `ADMIN_PASSWORD` trong shell rồi chạy `npm run seed:supabase`. Script không ghi đè dữ liệu mẫu đã tồn tại, không đổi mật khẩu hoặc nâng quyền người dùng đã tồn tại. Nếu email đã có sẵn, cần xác minh tài khoản đó trước khi cấp quyền.
4. Cấu hình URL xác nhận email cho Supabase Auth theo domain sẽ dùng. Khởi động lại ứng dụng.

Khóa service-role chỉ dùng trong script khởi tạo, không cần cho runtime và không được đặt tên với tiền tố `NEXT_PUBLIC_`. Script seed đọc biến môi trường shell, gồm cả `NEXT_PUBLIC_SUPABASE_URL`; không tự nạp `.env.local`. Dữ liệu local không tự chuyển lên Supabase. SQL đã qua kiểm tra giao dịch và RLS trên PostgreSQL cô lập; tích hợp Auth/Storage/cloud cần kiểm lại trên dự án đã chọn trước khi triển khai.

## Kiểm tra

```powershell
npm run typecheck
npm run lint
npm test
npm run build
npm start
# Trong terminal khác:
$env:TEST_ADMIN_PASSWORD = '<mat-khau-admin>'
npm run test:e2e
```

Các bài test E2E tạo đơn có tên `E2E Khách thử`, thử chỉnh sửa rồi hoàn lại tên/ảnh sản phẩm; đơn thử được hủy trong bài kiểm tra admin.

Kết quả chi tiết và giới hạn kiểm tra: [docs/VERIFICATION.md](docs/VERIFICATION.md).

## Trước khi phát hành

- Kết nối Supabase, kiểm tra RPC/RLS và tạo admin cloud.
- Thay ảnh mẫu, kiểm tra giá/tồn kho, thông tin liên hệ và chính sách bán hàng.
- Nhập tài khoản ngân hàng thật nếu dùng VietQR. Hệ thống không tự xác minh chuyển khoản; quản trị viên xác nhận khi nhận tiền.
- Đặt `NEXT_PUBLIC_SITE_URL` bằng domain HTTPS thật. Khi chưa đặt, robots chủ động chặn index bản thử.
- Chạy kiểm tra SEO kỹ thuật/trang trên preview Vercel và đo hiệu năng trên môi trường triển khai.
- Đánh giá, ảnh đội ngũ, địa chỉ cửa hàng và analytics cần dữ liệu thật; hiện không giả lập các nội dung này.

Không thể cam kết free tier bên thứ ba miễn phí vĩnh viễn. Hiện chưa deploy, chưa tích hợp đơn vị vận chuyển, webhook ngân hàng hoặc gửi email xác nhận đơn.
