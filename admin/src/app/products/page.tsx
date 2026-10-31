'use client';

import { FormEvent, useCallback, useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { ApiError, apiFetch } from '@/lib/api';

type Category = { id: string; name: string };
type Product = {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  thumbnail_url: string | null;
  approval_status: 'pending' | 'approved' | 'rejected';
  is_active: boolean;
};
type ProductForm = {
  categoryId: string;
  name: string;
  slug: string;
  description: string;
  price: string;
  thumbnailUrl: string;
};
type DataResponse<T> = { data: T };

const emptyForm: ProductForm = {
  categoryId: '',
  name: '',
  slug: '',
  description: '',
  price: '',
  thumbnailUrl: '',
};

const fieldStyle = { display: 'block', width: '100%', padding: 8, marginTop: 4 };
const buttonStyle = { padding: '8px 12px', cursor: 'pointer' };

export default function ProductsPage() {
  const router = useRouter();
  const [categories, setCategories] = useState<Category[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [form, setForm] = useState<ProductForm>(emptyForm);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [searchText, setSearchText] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [activeFilter, setActiveFilter] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);

  const handleRequestError = useCallback((requestError: unknown) => {
    if (requestError instanceof ApiError && requestError.status === 401) {
      window.sessionStorage.removeItem('menly_admin_token');
      router.replace('/login');
      return;
    }
    setError(requestError instanceof Error ? requestError.message : 'Không thể tải dữ liệu');
  }, [router]);

  const loadProducts = useCallback(async () => {
    const params = new URLSearchParams();
    if (search.trim()) params.set('search', search.trim());
    if (categoryFilter) params.set('categoryId', categoryFilter);
    if (statusFilter) params.set('approvalStatus', statusFilter);
    if (activeFilter) params.set('isActive', activeFilter);

    const queryString = params.toString();
    const query = queryString ? `?${queryString}` : '';
    const response = await apiFetch<DataResponse<Product[]>>(`/admin/products${query}`);
    setProducts(response.data);
  }, [activeFilter, categoryFilter, search, statusFilter]);

  useEffect(() => {
    if (!window.sessionStorage.getItem('menly_admin_token')) {
      router.replace('/login');
      return;
    }

    apiFetch<DataResponse<Category[]>>('/categories')
      .then((response) => setCategories(response.data))
      .catch(handleRequestError);
  }, [handleRequestError, router]);

  useEffect(() => {
    if (!window.sessionStorage.getItem('menly_admin_token')) return;
    setIsLoading(true);
    setError('');
    void loadProducts()
      .catch(handleRequestError)
      .finally(() => setIsLoading(false));
  }, [handleRequestError, loadProducts]);

  function resetForm() {
    setForm(emptyForm);
    setEditingId(null);
  }

  function startEditing(product: Product) {
    setEditingId(product.id);
    setForm({
      categoryId: product.category_id,
      name: product.name,
      slug: product.slug,
      description: product.description ?? '',
      price: String(product.price),
      thumbnailUrl: product.thumbnail_url ?? '',
    });
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError('');
    setIsSaving(true);

    const payload = {
      categoryId: form.categoryId,
      name: form.name.trim(),
      slug: form.slug.trim(),
      description: form.description.trim(),
      price: Number(form.price),
      thumbnailUrl: form.thumbnailUrl.trim(),
    };

    try {
      if (editingId) {
        await apiFetch(`/admin/products/${editingId}`, {
          method: 'PUT',
          body: JSON.stringify(payload),
        });
      } else {
        await apiFetch('/admin/products', {
          method: 'POST',
          body: JSON.stringify(payload),
        });
      }
      resetForm();
      await loadProducts();
    } catch (requestError) {
      handleRequestError(requestError);
    } finally {
      setIsSaving(false);
    }
  }

  async function approveProduct(id: string) {
    setError('');
    try {
      await apiFetch(`/admin/products/${id}/approve`, { method: 'PATCH' });
      await loadProducts();
    } catch (requestError) {
      handleRequestError(requestError);
    }
  }

  async function deactivateProduct(product: Product) {
    if (!window.confirm(`Ngừng kinh doanh sản phẩm "${product.name}"?`)) return;
    setError('');
    try {
      await apiFetch(`/admin/products/${product.id}`, { method: 'DELETE' });
      await loadProducts();
    } catch (requestError) {
      handleRequestError(requestError);
    }
  }

  function logout() {
    window.sessionStorage.removeItem('menly_admin_token');
    router.replace('/login');
  }

  return (
    <main style={{ maxWidth: 1200, margin: '32px auto', padding: 24 }}>
      <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <h1>Quản lý sản phẩm</h1>
          <p>Thêm, cập nhật, duyệt và ngừng kinh doanh sản phẩm.</p>
        </div>
        <button type="button" onClick={logout} style={buttonStyle}>Đăng xuất</button>
      </header>

      {error && <p role="alert" style={{ color: '#b42318' }}>{error}</p>}

      <section style={{ margin: '24px 0', padding: 16, border: '1px solid #ddd', borderRadius: 8 }}>
        <h2>{editingId ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm'}</h2>
        <form onSubmit={handleSubmit} style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: 12 }}>
          <label>
            Danh mục
            <select
              required
              value={form.categoryId}
              onChange={(event) => setForm({ ...form, categoryId: event.target.value })}
              style={fieldStyle}
            >
              <option value="">Chọn danh mục</option>
              {categories.map((category) => (
                <option key={category.id} value={category.id}>{category.name}</option>
              ))}
            </select>
          </label>
          <label>
            Tên sản phẩm
            <input required maxLength={200} value={form.name} onChange={(event) => setForm({ ...form, name: event.target.value })} style={fieldStyle} />
          </label>
          <label>
            Slug
            <input required maxLength={220} pattern="[a-z0-9]+(?:-[a-z0-9]+)*" value={form.slug} onChange={(event) => setForm({ ...form, slug: event.target.value })} style={fieldStyle} />
          </label>
          <label>
            Giá (VNĐ)
            <input required type="number" min={0} step={1} value={form.price} onChange={(event) => setForm({ ...form, price: event.target.value })} style={fieldStyle} />
          </label>
          <label>
            Ảnh đại diện (URL)
            <input type="url" value={form.thumbnailUrl} onChange={(event) => setForm({ ...form, thumbnailUrl: event.target.value })} style={fieldStyle} />
          </label>
          <label style={{ gridColumn: '1 / -1' }}>
            Mô tả
            <textarea maxLength={5000} rows={3} value={form.description} onChange={(event) => setForm({ ...form, description: event.target.value })} style={fieldStyle} />
          </label>
          <div style={{ display: 'flex', gap: 8, alignItems: 'end' }}>
            <button type="submit" disabled={isSaving} style={buttonStyle}>
              {isSaving ? 'Đang lưu...' : editingId ? 'Lưu thay đổi' : 'Thêm sản phẩm'}
            </button>
            {editingId && <button type="button" onClick={resetForm} style={buttonStyle}>Hủy sửa</button>}
          </div>
        </form>
      </section>

      <section>
        <h2>Danh sách sản phẩm</h2>
        <form
          onSubmit={(event) => {
            event.preventDefault();
            setSearch(searchText);
          }}
          style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 16 }}
        >
          <input aria-label="Tìm sản phẩm" placeholder="Tìm theo tên" value={searchText} onChange={(event) => setSearchText(event.target.value)} />
          <select aria-label="Lọc danh mục" value={categoryFilter} onChange={(event) => setCategoryFilter(event.target.value)}>
            <option value="">Tất cả danh mục</option>
            {categories.map((category) => <option key={category.id} value={category.id}>{category.name}</option>)}
          </select>
          <select aria-label="Lọc duyệt" value={statusFilter} onChange={(event) => setStatusFilter(event.target.value)}>
            <option value="">Tất cả trạng thái duyệt</option>
            <option value="pending">Chờ duyệt</option>
            <option value="approved">Đã duyệt</option>
            <option value="rejected">Từ chối</option>
          </select>
          <select aria-label="Lọc kinh doanh" value={activeFilter} onChange={(event) => setActiveFilter(event.target.value)}>
            <option value="">Tất cả trạng thái kinh doanh</option>
            <option value="true">Đang kinh doanh</option>
            <option value="false">Đã ngừng</option>
          </select>
          <button type="submit" style={buttonStyle}>Lọc</button>
        </form>

        {isLoading ? <p>Đang tải sản phẩm...</p> : products.length === 0 ? <p>Chưa có sản phẩm phù hợp.</p> : (
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr>
                  {['Tên sản phẩm', 'Danh mục', 'Giá', 'Duyệt', 'Kinh doanh', 'Thao tác'].map((heading) => (
                    <th key={heading} style={{ textAlign: 'left', padding: 10, borderBottom: '1px solid #ccc' }}>{heading}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {products.map((product) => (
                  <tr key={product.id}>
                    <td style={{ padding: 10, borderBottom: '1px solid #eee' }}>{product.name}</td>
                    <td style={{ padding: 10, borderBottom: '1px solid #eee' }}>
                      {categories.find((category) => category.id === product.category_id)?.name ?? 'Không rõ'}
                    </td>
                    <td style={{ padding: 10, borderBottom: '1px solid #eee' }}>{product.price.toLocaleString('vi-VN')} ₫</td>
                    <td style={{ padding: 10, borderBottom: '1px solid #eee' }}>{product.approval_status}</td>
                    <td style={{ padding: 10, borderBottom: '1px solid #eee' }}>{product.is_active ? 'Đang bán' : 'Đã ngừng'}</td>
                    <td style={{ padding: 10, borderBottom: '1px solid #eee', whiteSpace: 'nowrap' }}>
                      <button type="button" onClick={() => startEditing(product)} style={buttonStyle}>Sửa</button>{' '}
                      {product.approval_status !== 'approved' && (
                        <button type="button" onClick={() => void approveProduct(product.id)} style={buttonStyle}>Duyệt</button>
                      )}{' '}
                      {product.is_active && (
                        <button type="button" onClick={() => void deactivateProduct(product)} style={buttonStyle}>Ngừng bán</button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </main>
  );
}
