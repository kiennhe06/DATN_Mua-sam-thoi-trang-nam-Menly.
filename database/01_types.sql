-- Kiểu dữ liệu dùng chung (enum) và tiện ích mở rộng
create extension if not exists pg_trgm;

do $$ begin
  create type order_status as enum
    ('pending_payment','paid','processing','shipping','delivered','completed','cancelled','expired');
exception when duplicate_object then null; end $$;

do $$ begin
  create type payment_status as enum ('pending','paid','failed','refunded','cancelled');
exception when duplicate_object then null; end $$;

do $$ begin
  create type inventory_movement_reason as enum ('order','cancel','restock','adjust','return');
exception when duplicate_object then null; end $$;
