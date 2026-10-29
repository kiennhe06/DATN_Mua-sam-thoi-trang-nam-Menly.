// Ham goi API chung toi backend.
const API_URL = process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:5000';

export async function apiFetch(path: string, options?: RequestInit) {
  // TODO: them Authorization header (token admin)
  const res = await fetch(`${API_URL}/api/v1${path}`, options);
  if (!res.ok) throw new Error('Yeu cau that bai');
  return res.json();
}
