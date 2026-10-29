# Backend Menly

Node.js + Express + TypeScript, kien truc MVVM.

## Cach chay
1. `npm install`
2. Tao file `.env` tu `.env.example` va dien thong tin Supabase.
3. `npm run dev` roi mo http://localhost:5000/api/v1/health

## Cau truc
- `src/config/` — ket noi Supabase, doc bien moi truong.
- `src/models/` — truy cap du lieu (doc/ghi Supabase).
- `src/viewmodels/` — xu ly nghiep vu.
- `src/views/routes/` — nhan request HTTP, tra ket qua.
- `src/views/app.ts` — gan tat ca route.
- `src/middlewares/` — xac thuc, bat loi.

Cac route hien tra ve 501 (chua cai dat) — moi nguoi vao dien noi dung theo phan cong.
