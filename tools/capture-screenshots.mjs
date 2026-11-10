import { chromium } from 'playwright';
import { mkdir } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const outDir = path.join(root, '..', 'site', 'public', 'images', 'projects');
await mkdir(outDir, { recursive: true });

const shots = [
  { url: 'https://meinekleine.world/', file: 'meine-kleine-welt.png', wait: 2500 },
  { url: 'http://127.0.0.1:3456/', file: 'valknut.png', wait: 1500 },
  { url: 'https://89-126-249-15.sslip.io/login', file: 'siss-fleet.png', wait: 3000 },
  { url: 'http://127.0.0.1:3457/#contenido', file: 'zona7radio.png', wait: 2000 },
  { url: 'http://127.0.0.1:3458/', file: 'data-center.png', wait: 1500 },
  {
    url: 'file:///' + path.join(root, '..', 'showcases', 'latina-live', '.external', 'latina-website', 'index.html').replace(/\\/g, '/'),
    file: 'latina-live.png',
    wait: 1500,
  },
  { url: 'http://127.0.0.1:3777/', file: 'qyron-werke.png', wait: 3500 },
  {
    url: 'file:///' + path.join(root, 'dns-onboarding-mock.html').replace(/\\/g, '/'),
    file: 'dns-privado.png',
    wait: 500,
  },
];

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });

for (const shot of shots) {
  try {
    await page.goto(shot.url, { waitUntil: 'networkidle', timeout: 60000 });
    await page.waitForTimeout(shot.wait);
    await page.screenshot({ path: path.join(outDir, shot.file), fullPage: false });
    console.log('ok', shot.file);
  } catch (err) {
    console.error('fail', shot.file, err.message);
  }
}

await browser.close();
