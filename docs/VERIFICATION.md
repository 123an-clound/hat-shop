# Kiểm tra bàn giao — 05/10/2026

## Phạm vi đã dựng

Website Urban Caps Studio theo blueprint: cửa hàng tiếng Việt, danh mục/tìm kiếm/lọc, chi tiết và biến thể sản phẩm, yêu thích, giỏ hàng lưu trên trình duyệt, checkout COD/VietQR, mã giảm giá, tra cứu đơn, đăng ký/đăng nhập, lịch sử đơn và đánh giá sau mua. Admin có dashboard, sản phẩm/ảnh/tồn kho, đơn hàng dạng bảng/Kanban, in A5/A6, danh mục, banner, mã giảm giá, duyệt đánh giá, khách hàng theo đơn, cài đặt và nhật ký.

Chế độ hiện tại dùng SQLite trên máy. Đã tạo tài khoản admin theo thông tin người dùng cung cấp; chỉ lưu mật khẩu băm. Có adapter Supabase, script seed và SQL riêng, chưa áp dụng lên cloud.

## Kết quả kiểm tra

| Gate | Kết quả và phạm vi |
|---|---|
| Build / type / lint | `npm run build`, `npm run typecheck`, `npm run lint` thành công. Build còn cảnh báo không cài plugin ESLint riêng của Next; đã dùng ESLint TypeScript và React Hooks. |
| Unit | 10/10: giá phía server, tồn kho, số lượng trùng, coupon, phí giao hàng, VietQR, URL ảnh, chống chèn script qua JSON-LD. |
| Browser | 3/3 luồng cửa hàng/mobile, checkout/tra cứu và admin. Kiểm tra tải ảnh trả URL mới, lưu sản phẩm hiển thị lại ở cửa hàng, in phiếu, hủy đơn, đăng xuất và chặn truy cập admin. |
| SEO smoke | 1/1 bài bổ sung trên 7 trang public: HTTP 200, một H1, description/canonical trong head, Product JSON-LD hợp lệ về JSON, robots/sitemap trả 200. |
| Accessibility | axe không phát hiện vi phạm WCAG 2 A/AA và 2.1 AA ở trang chủ desktop/mobile, dashboard. Lighthouse accessibility 100. Có focus, nhãn biểu mẫu, dialog native, menu mobile và reduced motion. Chưa kiểm toàn bộ luồng bằng screen reader. |
| Security | `npm audit --omit=dev`: 0 lỗ hổng được báo. Kiểm tra admin/upload từ người chưa đăng nhập, định giá server, phiên HttpOnly, băm mật khẩu, rate limit, kiểm tra file qua Sharp. Chưa phải pentest độc lập. |
| Database | SQL đã thực thi trên PostgreSQL 17 Supabase image trong container riêng. Các assertion về checkout/idempotency, giá/coupon, chống bán quá tồn, quyền đọc đơn, chống tự nâng quyền admin, RPC lưu sản phẩm, hủy đơn hoàn tồn đúng một lần đều qua. Fixture rollback; container thử đã xóa. Storage tables dùng stub, chưa kiểm Supabase Storage/Auth qua dịch vụ cloud. |
| Performance | Lighthouse mobile production local: performance **95**, accessibility **100**, best practices **100**. FCP **0,9 giây**, LCP **2,9 giây**, TBT **20 ms**, CLS **0**. LCP còn cao hơn mục tiêu 2,5 giây: chưa coi gate Core Web Vitals production là đạt. Không có dữ liệu INP thực địa. |
| Design / motion | Đã xem giao diện desktop và 375 px, kiểm không tràn ngang. Motion nhẹ bằng CSS, tôn trọng reduced motion. Không dùng 3D nên không áp dụng gate GPU/WebGL. |
| SEO indexability | Điểm Lighthouse SEO **69** do chủ động `noindex` trên bản thử chưa có domain. Metadata đã qua smoke test. Chưa kiểm preview Vercel vì chưa deploy. |

Báo cáo máy: `lighthouse-mobile.json`. Không dùng số đo localhost để khẳng định tốc độ trên hosting thật.

## Điều chỉnh từ kiểm tra

- Giữ lại dữ liệu biểu mẫu tra cứu/đăng nhập/đánh giá khi gửi lỗi.
- Sửa bước nhập giá khiến trình duyệt chặn lưu sản phẩm.
- Sửa kiểm tra origin khi tải ảnh trên server local.
- Sửa tên biến SQL trùng alias trong RPC lưu sản phẩm.
- Ưu tiên tải ảnh hero, xuất metadata trong head, sửa nhãn truy cập của logo.
- Đơn do E2E tạo đã được dọn và tồn kho đã hoàn; tên sản phẩm thử đã được khôi phục.

## Giả định và giới hạn

1. Dùng thương hiệu Urban Caps Studio và nội dung/chính sách mẫu của kế hoạch. Giá, màu, tồn kho và ảnh hiện chỉ để xem thử; thay bằng dữ liệu thật trước khi bán.
2. Chưa xác định dự án Supabase nên không sửa các dự án cloud hiện có. Dữ liệu local không tự chuyển lên cloud. Chế độ local cần ổ đĩa bền vững và không chạy trực tiếp trên Vercel.
3. Chưa có ngân hàng thật nên checkout chỉ bật COD; VietQR bật sau khi điền đủ cài đặt. Chuyển khoản được admin xác nhận thủ công.
4. Chưa deploy; chưa nối hãng vận chuyển, webhook ngân hàng, email xác nhận đơn, analytics hay tên miền. Không có đánh giá hoặc doanh thu giả.
5. Cần kiểm lại Supabase Auth/Storage/RLS qua dịch vụ thật, SEO trên preview và hiệu năng hosting trước phát hành. Repository cloud hiện lấy tối đa 1.000 bản ghi mỗi danh sách; cần phân trang khi dữ liệu tăng.
6. File `supabase_schema.sql` gốc có vấn đề phân quyền/giá đơn; giữ nguyên để bảo toàn tài liệu, không áp dụng. Dùng `database/urban_caps.sql` thay thế sau khi chọn dự án.

Hướng dẫn thao tác trong `README.md`; nguồn và giới hạn ảnh trong `IMAGE-SOURCES.md`.
