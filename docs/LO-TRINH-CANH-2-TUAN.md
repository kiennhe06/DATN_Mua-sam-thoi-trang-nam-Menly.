# Lộ trình công việc của Cảnh trong 2 tuần

Phạm vi: phần quản trị gồm sản phẩm, đơn hàng, kho, mã giảm giá, người dùng, đánh giá, dashboard, thông báo, duyệt trả hàng và báo cáo/demo.

## Ngày 1 — Khảo sát repository mới (hoàn thành)

- Xác nhận mã nguồn làm việc là repository có URL `DATN_Mua-sam-thoi-trang-nam-Menly..git`, nhánh `main` tại commit `82e0d6c`.
- Đọc cấu trúc backend Express/TypeScript, admin Next.js và schema Supabase để xác định các điểm cần triển khai.
- Chạy build ban đầu: `backend` (`npm run build`) và `admin` (`npm run build`) đều thành công.
- Ghi nhận hiện trạng: trang sản phẩm admin còn TODO; các API quản trị trả `501`; middleware xác thực/phân quyền chưa triển khai.
- Không chuyển nguyên commit từ repository cũ vì hai repository có lịch sử và mã nguồn khác nhau.

## Ngày 2 — Nền tảng quản lý sản phẩm (hoàn thành)

- Hoàn thiện đăng nhập Supabase bằng `SUPABASE_ANON_KEY`; chỉ tài khoản có hồ sơ vai trò admin, đang hoạt động và không bị khóa mới đăng nhập được.
- Xác thực Bearer token và kiểm tra vai trò admin tại các API quản trị.
- Thêm validation và API để lọc, xem, thêm, sửa, duyệt và ngừng kinh doanh sản phẩm; thao tác ngừng kinh doanh là cập nhật trạng thái, không xóa dữ liệu đơn hàng.
- Hoàn thiện form đăng nhập và trang admin quản lý sản phẩm, gồm lọc danh mục/trạng thái và thông báo lỗi API.
- Bổ sung 4 kiểm tra cho dữ liệu hợp lệ, giá/slug sai, cập nhật rỗng và bộ lọc trạng thái.
- Xác nhận `backend`: `npm test`, `npm run build`; `admin`: `npm run build` đều thành công.
- Quản lý biến thể size/màu/SKU/tồn kho vẫn nằm ở ngày 3, chưa đưa vào biểu mẫu sản phẩm cơ bản.

## Ngày 3 — Hoàn thiện sản phẩm và biến thể

- Bổ sung quản lý ảnh, size, màu sắc, SKU và tồn kho theo biến thể.
- Bổ sung tìm kiếm, lọc danh mục/trạng thái và phân trang cho danh sách sản phẩm.
- Kiểm tra ràng buộc dữ liệu với schema hiện có và xử lý trường hợp SKU/slug trùng.

## Ngày 4 — Quản lý đơn hàng

- Xây dựng danh sách đơn hàng, tìm kiếm và xem chi tiết.
- Thêm cập nhật trạng thái theo luồng hợp lệ, lưu ý lịch sử và trạng thái thanh toán.
- Kiểm tra các trường hợp đơn đã hủy, đã giao hoặc không thể chuyển trạng thái.

## Ngày 5 — Quản lý kho

- Hiển thị tồn kho theo biến thể và lịch sử biến động.
- Thêm điều chỉnh nhập/xuất kho có lý do, xác thực số lượng và ghi nhận người thao tác.
- Kiểm tra không cho tồn kho xuống dưới 0.

## Ngày 6 — Người dùng và phân quyền

- Xây dựng danh sách người dùng, tìm kiếm và xem hồ sơ.
- Thêm khóa/mở khóa tài khoản và giới hạn thao tác theo vai trò.
- Kiểm tra các trường hợp không cho người dùng tự khóa tài khoản quản trị cuối cùng.

## Ngày 7 — Mã giảm giá

- Xây dựng CRUD mã giảm giá và các điều kiện áp dụng.
- Kiểm tra thời hạn, giá trị giảm, đơn tối thiểu và giới hạn lượt sử dụng.

## Ngày 8 — Đánh giá sản phẩm

- Hiển thị danh sách đánh giá, lọc theo sản phẩm/trạng thái.
- Thêm phản hồi và xử lý nội dung vi phạm theo quyền quản trị.

## Ngày 9 — Trả hàng và hoàn tiền

- Hiển thị yêu cầu trả hàng cùng lý do, ảnh và thông tin đơn.
- Thêm duyệt/từ chối có ghi chú, kiểm tra trạng thái đơn và quy trình hoàn tiền.

## Ngày 10 — Banner

- Xây dựng quản lý banner: thêm, sửa, bật/tắt và sắp xếp.
- Kiểm tra URL ảnh và khoảng thời gian hiển thị.

## Ngày 11 — Thông báo

- Xây dựng gửi thông báo tới nhóm người dùng phù hợp.
- Hiển thị kết quả gửi và lỗi, tránh báo thành công khi thao tác thất bại.

## Ngày 12 — Dashboard

- Tổng hợp doanh thu, đơn hàng, sản phẩm và người dùng từ dữ liệu thực.
- Hiển thị bộ lọc thời gian và trạng thái dữ liệu rỗng/lỗi.

## Ngày 13 — Rà soát và kiểm thử

- Chạy build, lint và các kiểm tra hiện có; bổ sung kiểm tra cho phần đã làm.
- Rà soát phân quyền, validation, lỗi API và các luồng dữ liệu liên quan.
- Sửa các lỗi phát hiện được, không đưa cấu hình bí mật vào Git.

## Ngày 14 — Chuẩn bị báo cáo/demo

- Chạy lại các luồng quản trị đã hoàn thành và ghi nhận phần còn phụ thuộc cấu hình Supabase.
- Cập nhật hướng dẫn chạy, tổng hợp ảnh/chức năng demo và nội dung báo cáo.
- Chia commit theo từng phần chức năng đã triển khai; không tạo commit rỗng hoặc chỉ để tăng số lượng.

## Ghi chú triển khai

- Làm trực tiếp trên repository mới và nhánh `feature/canh` ở remote; không push nhầm sang repository cũ.
- Commit tách theo thay đổi thực tế, tiêu đề tiếng Việt dễ hiểu; chỉ commit các tệp thuộc phạm vi công việc.
- Các tính năng cần Supabase phải được kiểm tra với cấu hình môi trường hợp lệ; không lưu `.env` hoặc khóa truy cập trong repository.
