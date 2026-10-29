-- Các hàm nghiệp vụ quan trọng (khung - viết nội dung sau)

-- Tạo đơn hàng nguyên tử: tạo đơn, tạo order_items, trừ kho trong 1 giao dịch.
-- TODO: viết nội dung thật (kiểm tra tồn kho, trừ kho, ghi inventory_movements).
create or replace function public.create_order()
returns void
language plpgsql
as $$
begin
  raise exception 'TODO: create_order chua duoc cai dat';
end;
$$;

-- Xác nhận thanh toán (gọi khi VNPay báo thành công).
-- TODO: cập nhật payments + orders.status.
create or replace function public.settle_payment()
returns void
language plpgsql
as $$
begin
  raise exception 'TODO: settle_payment chua duoc cai dat';
end;
$$;

-- Hủy các đơn chờ thanh toán quá hạn (chạy định kỳ).
-- TODO: cập nhật trạng thái expired + hoàn kho.
create or replace function public.expire_pending_orders()
returns void
language plpgsql
as $$
begin
  raise exception 'TODO: expire_pending_orders chua duoc cai dat';
end;
$$;
