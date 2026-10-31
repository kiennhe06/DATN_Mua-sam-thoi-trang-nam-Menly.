import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { createServer } from 'node:net';
import { after, before, test } from 'node:test';
import { fileURLToPath } from 'node:url';

const nextCli = fileURLToPath(new URL('../node_modules/next/dist/bin/next', import.meta.url));
let serverProcess;
let baseUrl;
let processOutput = '';

function rememberOutput(chunk) {
  processOutput = (processOutput + chunk.toString()).slice(-8000);
}

async function findAvailablePort() {
  const server = createServer();
  await new Promise((resolve, reject) => {
    server.once('error', reject);
    server.listen(0, '127.0.0.1', resolve);
  });
  const address = server.address();
  if (!address || typeof address === 'string') {
    await new Promise((resolve) => server.close(resolve));
    throw new Error('Không lấy được cổng chạy thử admin');
  }
  await new Promise((resolve, reject) => {
    server.close((error) => error ? reject(error) : resolve());
  });
  return address.port;
}

before(async () => {
  const port = await findAvailablePort();
  baseUrl = `http://127.0.0.1:${port}`;
  serverProcess = spawn(
    process.execPath,
    [nextCli, 'start', '--hostname', '127.0.0.1', '--port', String(port)],
    {
      cwd: fileURLToPath(new URL('..', import.meta.url)),
      env: { ...process.env, NEXT_TELEMETRY_DISABLED: '1' },
      stdio: ['ignore', 'pipe', 'pipe'],
    },
  );
  serverProcess.stdout.on('data', rememberOutput);
  serverProcess.stderr.on('data', rememberOutput);

  let lastError;
  for (let attempt = 0; attempt < 40; attempt += 1) {
    if (serverProcess.exitCode !== null) {
      throw new Error(`Máy chủ admin dừng ngoài dự kiến.\n${processOutput}`);
    }

    try {
      const response = await fetch(`${baseUrl}/login`, { signal: AbortSignal.timeout(1000) });
      if (response.ok) return;
      lastError = new Error(`Trang đăng nhập trả về mã ${response.status}`);
    } catch (error) {
      lastError = error;
    }
    await new Promise((resolve) => setTimeout(resolve, 250));
  }

  throw new Error(`Không khởi động được máy chủ admin.\n${processOutput}`, { cause: lastError });
});

after(async () => {
  if (!serverProcess || serverProcess.exitCode !== null) return;
  const closed = new Promise((resolve) => serverProcess.once('close', resolve));
  serverProcess.kill();
  await closed;
});

test('trang đăng nhập quản trị hiển thị thành công', async () => {
  const response = await fetch(`${baseUrl}/login`);
  assert.equal(response.status, 200);
  assert.match(await response.text(), /Đăng nhập quản trị/);
});

test('trang quản lý sản phẩm hiển thị thành công', async () => {
  const response = await fetch(`${baseUrl}/products`);
  assert.equal(response.status, 200);
  assert.match(await response.text(), /Quản lý sản phẩm/);
});
