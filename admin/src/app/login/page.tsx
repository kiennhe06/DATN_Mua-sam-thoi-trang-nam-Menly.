'use client';

import { FormEvent, useState } from 'react';
import { useRouter } from 'next/navigation';
import { apiFetch } from '@/lib/api';

type LoginResponse = {
  data: {
    accessToken: string;
    expiresAt: number | null;
    user: { id: string; email: string | null; fullName: string | null; role: string };
  };
};

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);

    try {
      const response = await apiFetch<LoginResponse>('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email, password }),
      });
      window.sessionStorage.setItem('menly_admin_token', response.data.accessToken);
      router.replace('/products');
    } catch (submitError) {
      setError(submitError instanceof Error ? submitError.message : 'Đăng nhập thất bại');
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main style={{ maxWidth: 420, margin: '64px auto', padding: 24 }}>
      <h1>Đăng nhập quản trị</h1>
      <p>Đăng nhập bằng tài khoản có quyền quản trị hệ thống.</p>
      <form onSubmit={handleSubmit} style={{ display: 'grid', gap: 16 }}>
        <label>
          Email
          <input
            type="email"
            autoComplete="username"
            required
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            style={{ display: 'block', width: '100%', padding: 10, marginTop: 6 }}
          />
        </label>
        <label>
          Mật khẩu
          <input
            type="password"
            autoComplete="current-password"
            required
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            style={{ display: 'block', width: '100%', padding: 10, marginTop: 6 }}
          />
        </label>
        {error && <p role="alert" style={{ color: '#b42318', margin: 0 }}>{error}</p>}
        <button type="submit" disabled={isSubmitting} style={{ padding: 12 }}>
          {isSubmitting ? 'Đang đăng nhập...' : 'Đăng nhập'}
        </button>
      </form>
    </main>
  );
}
