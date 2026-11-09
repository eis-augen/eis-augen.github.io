# Ejecutar UNA vez despues de iniciar sesion en GitHub (gh auth login).
$gh = "C:\Program Files\GitHub CLI\gh.exe"
Set-Location "C:\Users\alder\Desktop\portafolio-profesional"

& $gh auth status
if ($LASTEXITCODE -ne 0) {
  Write-Host "Primero: $gh auth login -h github.com -p https -w"
  exit 1
}

$user = (& $gh api user --jq .login).Trim()
$repoPages = "$user.github.io"
Write-Host "Usuario GitHub: $user"
Write-Host "Creando/actualizando repo: $repoPages"

$remotes = git remote 2>$null
if ($remotes -match 'origin') {
  git push -u origin main
} else {
  & $gh repo create $repoPages --public --source=. --remote=origin --push
}

Write-Host "Listo. Activa Pages: repo en GitHub -> Settings -> Pages -> Source: GitHub Actions"
Write-Host "URL: https://$user.github.io"
