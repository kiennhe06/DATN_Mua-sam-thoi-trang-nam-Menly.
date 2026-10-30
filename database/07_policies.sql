-- Phan quyen truy cap (RLS): ai duoc xem/sua du lieu nao
-- Luu y: backend dung service_role nen bo qua RLS; cac quy tac nay bao ve khi truy cap truc tiep.

-- ===== Cac bang cong khai (ai cung xem duoc) =====
alter table public.categories enable row level security;
drop policy if exists p_categories_read on public.categories;
create policy p_categories_read on public.categories for select using (true);

alter table public.products enable row level security;
drop policy if exists p_products_read on public.products;
create policy p_products_read on public.products for select using (true);

alter table public.product_variants enable row level security;
drop policy if exists p_variants_read on public.product_variants;
create policy p_variants_read on public.product_variants for select using (true);

alter table public.product_images enable row level security;
drop policy if exists p_images_read on public.product_images;
create policy p_images_read on public.product_images for select using (true);

alter table public.banners enable row level security;
drop policy if exists p_banners_read on public.banners;
create policy p_banners_read on public.banners for select using (is_active = true);

-- Danh gia: ai cung doc; chi chu moi them/xoa cua minh
alter table public.product_reviews enable row level security;
drop policy if exists p_reviews_read on public.product_reviews;
create policy p_reviews_read on public.product_reviews for select using (true);
drop policy if exists p_reviews_insert on public.product_reviews;
create policy p_reviews_insert on public.product_reviews for insert with check (user_id = auth.uid());
drop policy if exists p_reviews_delete on public.product_reviews;
create policy p_reviews_delete on public.product_reviews for delete using (user_id = auth.uid() or public.is_admin());

-- ===== Ho so: chi chu (hoac admin) moi xem; chi chu moi sua =====
alter table public.profiles enable row level security;
drop policy if exists p_profiles_select on public.profiles;
create policy p_profiles_select on public.profiles for select using (id = auth.uid() or public.is_admin());
drop policy if exists p_profiles_update on public.profiles;
create policy p_profiles_update on public.profiles for update using (id = auth.uid());

-- ===== Du lieu rieng tung nguoi =====
alter table public.cart_items enable row level security;
drop policy if exists p_cart_all on public.cart_items;
create policy p_cart_all on public.cart_items for all using (user_id = auth.uid()) with check (user_id = auth.uid());

alter table public.wishlists enable row level security;
drop policy if exists p_wishlist_all on public.wishlists;
create policy p_wishlist_all on public.wishlists for all using (user_id = auth.uid()) with check (user_id = auth.uid());

alter table public.user_addresses enable row level security;
drop policy if exists p_address_all on public.user_addresses;
create policy p_address_all on public.user_addresses for all using (user_id = auth.uid()) with check (user_id = auth.uid());

alter table public.notifications enable row level security;
drop policy if exists p_notif_all on public.notifications;
create policy p_notif_all on public.notifications for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Don hang: chi chu (hoac admin) moi xem
alter table public.orders enable row level security;
drop policy if exists p_orders_select on public.orders;
create policy p_orders_select on public.orders for select using (user_id = auth.uid() or public.is_admin());

alter table public.order_items enable row level security;
drop policy if exists p_order_items_select on public.order_items;
create policy p_order_items_select on public.order_items for select using (
  exists (select 1 from public.orders o where o.id = order_id and (o.user_id = auth.uid() or public.is_admin()))
);
