# Urban Caps Studio

## Phạm vi
Triển khai blueprint bằng Next.js 15 App Router, TypeScript, Tailwind, Supabase. Cửa hàng tiếng Việt, danh mục, tìm kiếm/lọc, chi tiết sản phẩm và biến thể, yêu thích, giỏ hàng, COD/VietQR, tra cứu đơn, tài khoản. Admin quản lý sản phẩm và ảnh, danh mục, tồn kho, đơn hàng, khách hàng, mã giảm giá, banner, đánh giá, thiết lập và nhật ký.

## Thiết kế
Dark streetwear: background #0B0C10, surface #12141A, cyan #00F0FF, crimson #FF0055. Outfit + Plus Jakarta Sans. Typography lớn, khoảng trắng có chủ đích, hình sản phẩm thật. Motion dùng CSS cho hover/entry, tôn trọng reduced-motion; không dùng 3D vì chưa có model sản phẩm.

## Bảo mật và dữ liệu
Không lưu mật khẩu trong source/client. Supabase Auth cho đăng nhập; kiểm tra quyền trên server mỗi mutation. Tính giá từ database, giao dịch nguyên tử khi đặt đơn và trừ kho, idempotency để tránh đơn trùng. Không seed ngân hàng giả. Chỉ cho VietQR khi admin cấu hình ngân hàng. Dữ liệu ảnh mẫu có thể sửa tại admin.

## Điều kiện bên ngoài
Cần chọn dự án Supabase trước khi ghi dữ liệu. Chưa có tên miền production và thông tin ngân hàng thật. Không thể cam kết dịch vụ bên thứ ba miễn phí vĩnh viễn.
