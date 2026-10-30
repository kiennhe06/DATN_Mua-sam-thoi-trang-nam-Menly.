-- Index giup truy van nhanh hon (loc, tim kiem, lay theo khoa ngoai)

-- San pham: loc theo danh muc / cua hang, tim kiem theo ten
create index if not exists idx_products_category on public.products (category_id);
create index if not exists idx_products_shop on public.products (shop_id);
create index if not exists idx_products_search on public.products using gin (search_text gin_trgm_ops);

-- Bien the & anh san pham
create index if not exists idx_variants_product on public.product_variants (product_id);
create index if not exists idx_images_product on public.product_images (product_id);

-- Don hang: lay don cua 1 nguoi, tra cuu theo ma
create index if not exists idx_orders_user on public.orders (user_id);
create index if not exists idx_orders_code on public.orders (code);
create index if not exists idx_order_items_order on public.order_items (order_id);

-- Gio hang & yeu thich
create index if not exists idx_cart_user on public.cart_items (user_id);
create index if not exists idx_wishlists_user on public.wishlists (user_id);

-- Danh gia & thong bao
create index if not exists idx_reviews_product on public.product_reviews (product_id);
create index if not exists idx_notifications_user on public.notifications (user_id);
