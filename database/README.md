# Cơ sở dữ liệu Menly

Chạy lần lượt trên Supabase (SQL Editor) theo đúng thứ tự:

1. `01_types.sql` — tạo kiểu dữ liệu (enum) và tiện ích.
2. `02_tables.sql` — tạo toàn bộ 26 bảng.
3. `03_functions.sql` — tạo khung các hàm nghiệp vụ (viết nội dung sau).
4. `04_seed.sql` — nhập dữ liệu mẫu để chạy thử.

Lưu ý: tài khoản người dùng (admin/nhân viên/khách) được tạo qua Supabase Auth,
không ghi sẵn mật khẩu trong file SQL.
