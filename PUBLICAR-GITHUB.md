# Publicar el portafolio de Hashlaay Alderweireld

## Opción A — Sitio personal (recomendada para ofertas laborales)

Repositorio: **`hashlaay.github.io`** (nombre exacto en GitHub).

1. Instala [GitHub CLI](https://cli.github.com/) y ejecuta `gh auth login`.
2. En GitHub crea un repo público llamado **`hashlaay.github.io`** (si tu usuario es otro, ajusta el nombre).
3. Sube este proyecto:

```powershell
cd C:\Users\alder\Desktop\portafolio-profesional
git remote add origin https://github.com/TU_USUARIO/TU_USUARIO.github.io.git
git push -u origin main
```

4. En el repo: **Settings → Pages → Source: GitHub Actions**.
5. El workflow `.github/workflows/pages.yml` publicará el sitio.
6. URL pública: **https://hashlaay.github.io** (o la de tu usuario).

Antes de subir, edita `site/src/data/profile.json` si tu usuario de GitHub no es `hashlaay`.

## Opción B — Repo con nombre distinto

Si el repo se llama `portafolio-profesional`, cambia en `site/astro.config.mjs`:

```js
site: 'https://hashlaay.github.io',
base: '/portafolio-profesional',
```

Vuelve a hacer `npm run build` en `site/`.

## Regenerar copias de código (sin tocar el Escritorio)

```powershell
.\tools\sanitize-copy.ps1
```

Incluye **meine_kleine_world** en `showcases/meine-kleine-world`.

## Qué pones en la CV

> Portafolio: https://hashlaay.github.io  
> Repositorio con muestras de código: enlace al mismo repo (carpeta `showcases/`).
