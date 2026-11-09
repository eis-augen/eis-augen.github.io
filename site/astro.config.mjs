import { defineConfig } from 'astro/config';

// Si publicas como hashlaay.github.io usa base: '/'
// Si publicas como usuario.github.io/repo-name cambia base al nombre del repo
export default defineConfig({
  site: 'https://eis-augen.github.io',
  base: '/',
});
