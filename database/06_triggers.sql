-- Trigger: tu dong lam mot so viec khi du lieu thay doi

-- 1) Khi co nguoi dang ky (them vao auth.users) -> tu tao ho so trong profiles
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'full_name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 2) Khi co danh gia moi / sua / xoa -> tinh lai diem sao trung binh cua san pham
create or replace function public.update_product_rating()
returns trigger
language plpgsql
as $$
declare
  pid uuid := coalesce(new.product_id, old.product_id);
begin
  update public.products p
  set rating_avg = coalesce((select avg(rating) from public.product_reviews where product_id = pid), 0),
      rating_count = (select count(*) from public.product_reviews where product_id = pid)
  where p.id = pid;
  return null;
end;
$$;

drop trigger if exists on_review_changed on public.product_reviews;
create trigger on_review_changed
  after insert or update or delete on public.product_reviews
  for each row execute function public.update_product_rating();
