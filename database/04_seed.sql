-- Du lieu mau de chay thu (co the chay lai nhieu lan)

-- Danh muc
insert into public.categories (name, slug, sort_order) values
  ('Ao so mi','ao-so-mi',1),
  ('Ao thun','ao-thun',2),
  ('Quan jeans','quan-jeans',3),
  ('Quan tay','quan-tay',4),
  ('Ao khoac','ao-khoac',5)
on conflict (slug) do nothing;

-- San pham (2 mon moi danh muc) + anh dai dien
insert into public.products (category_id, name, slug, description, price, thumbnail_url, is_active)
select c.id, p.name, p.slug, p.descr, p.price,
       'https://picsum.photos/seed/' || p.slug || '/400/500', true
from (values
  ('Ao so mi trang basic','ao-so-mi-trang-basic','Ao so mi nam mau trang', 299000, 'ao-so-mi'),
  ('Ao so mi caro','ao-so-mi-caro','Ao so mi nam ho a tiet caro', 329000, 'ao-so-mi'),
  ('Ao thun co tron','ao-thun-co-tron','Ao thun nam co tron', 159000, 'ao-thun'),
  ('Ao polo','ao-polo','Ao polo nam', 229000, 'ao-thun'),
  ('Quan jeans slimfit','quan-jeans-slimfit','Quan jeans nam om', 459000, 'quan-jeans'),
  ('Quan jeans xanh nhat','quan-jeans-xanh-nhat','Quan jeans nam mau xanh nhat', 479000, 'quan-jeans'),
  ('Quan tay cong so','quan-tay-cong-so','Quan tay nam cong so', 389000, 'quan-tay'),
  ('Quan kaki','quan-kaki','Quan kaki nam', 349000, 'quan-tay'),
  ('Ao khoac bomber','ao-khoac-bomber','Ao khoac bomber nam', 599000, 'ao-khoac'),
  ('Ao khoac jean','ao-khoac-jean','Ao khoac jean nam', 549000, 'ao-khoac')
) as p(name, slug, descr, price, cat_slug)
join public.categories c on c.slug = p.cat_slug
on conflict (slug) do nothing;

-- Bien the (size M, L mau Den) cho moi san pham
insert into public.product_variants (product_id, size, color, sku, stock)
select pr.id, v.size, v.color, pr.slug || '-' || v.size || '-' || v.color, 50
from public.products pr
cross join (values ('M','Den'), ('L','Den')) as v(size, color)
on conflict (sku) do nothing;

-- Anh san pham
insert into public.product_images (product_id, url, sort_order)
select pr.id, 'https://picsum.photos/seed/' || pr.slug || '/600/800', 0
from public.products pr
where not exists (
  select 1 from public.product_images i where i.product_id = pr.id
);

-- Mot ma giam gia mau (giam 10%, toi da 50k, cho don tu 200k)
insert into public.vouchers (code, title, discount_type, discount_value, min_order_value, max_discount, usage_limit, end_date)
values ('WELCOME10','Giam 10% cho don dau tien','percentage',10,200000,50000,1000, now() + interval '90 days')
on conflict (code) do nothing;

-- Ghi chu: tai khoan admin/nhan vien/khach tao qua Supabase Auth (khong hardcode mat khau o day).
