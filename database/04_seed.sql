-- Dữ liệu mẫu để chạy thử (có thể chạy lại nhiều lần)

insert into public.categories (name, slug, sort_order) values
  ('Ao so mi','ao-so-mi',1),
  ('Ao thun','ao-thun',2),
  ('Quan jeans','quan-jeans',3),
  ('Quan tay','quan-tay',4),
  ('Ao khoac','ao-khoac',5)
on conflict (slug) do nothing;

-- Vai san pham mau (gan vao danh muc theo slug)
insert into public.products (category_id, name, slug, description, price, is_active)
select c.id, p.name, p.slug, p.descr, p.price, true
from (values
  ('Ao so mi trang basic','ao-so-mi-trang-basic','Ao so mi nam mau trang', 299000, 'ao-so-mi'),
  ('Ao thun co tron','ao-thun-co-tron','Ao thun nam co tron', 159000, 'ao-thun'),
  ('Quan jeans slimfit','quan-jeans-slimfit','Quan jeans nam om', 459000, 'quan-jeans'),
  ('Quan tay cong so','quan-tay-cong-so','Quan tay nam', 389000, 'quan-tay'),
  ('Ao khoac bomber','ao-khoac-bomber','Ao khoac nam', 599000, 'ao-khoac')
) as p(name, slug, descr, price, cat_slug)
join public.categories c on c.slug = p.cat_slug
on conflict (slug) do nothing;

-- Bien the mau cho moi san pham (size M, L mau Den)
insert into public.product_variants (product_id, size, color, sku, stock)
select pr.id, v.size, v.color, pr.slug || '-' || v.size || '-' || v.color, 50
from public.products pr
cross join (values ('M','Den'), ('L','Den')) as v(size, color)
on conflict (sku) do nothing;

-- Ghi chu: tai khoan admin/nhan vien/khach tao qua Supabase Auth (khong hardcode o day).
