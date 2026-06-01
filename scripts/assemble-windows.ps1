Write-Host "Preparing Electron Package"

New-Item -ItemType Directory -Force `
  self-flow-ui/action-service

New-Item -ItemType Directory -Force `
  self-flow-ui/computer-use-service

New-Item -ItemType Directory -Force `
  self-flow-ui/scheduler-service

New-Item -ItemType Directory -Force `
  self-flow-ui/process

Write-Host "Copying Action Service"

Copy-Item `
  self-flow-rust-action-service/target/release/*.exe `
  self-flow-ui/action-service/

Write-Host "Copying Computer Use Service"

Copy-Item `
  self-flow-rust-computer-use/target/release/*.exe `
  self-flow-ui/computer-use-service/

Write-Host "Copying Scheduler Service"

Copy-Item `
  self-flow-scheduler-service/target/release/*.exe `
  self-flow-ui/scheduler-service/

Write-Host "Generating runtime.json"

@'
[
  {
    "service_name":"action-service",
    "host":"127.0.0.1",
    "port":7001
  },
  {
    "service_name":"computer-use",
    "host":"127.0.0.1",
    "port":7002
  },
  {
    "service_name":"scheduler-service",
    "host":"127.0.0.1",
    "port":7003
  }
]
'@ | Out-File `
self-flow-ui/process/runtime.json `
-Encoding utf8

############################################################
# DEBUG
############################################################

Write-Host ""
Write-Host "===== VERIFYING COPIED FILES ====="

Get-ChildItem self-flow-ui/action-service -Recurse

Get-ChildItem self-flow-ui/computer-use-service -Recurse

Get-ChildItem self-flow-ui/scheduler-service -Recurse

Get-ChildItem self-flow-ui/process -Recurse

############################################################
# BUILD
############################################################

Write-Host "Building Electron"

Push-Location self-flow-ui

npm run build

# Generate unpacked app first
npx electron-builder --win dir --x64 --publish never

############################################################
# DEBUG PACKAGING
############################################################

Write-Host ""
Write-Host "===== WIN UNPACKED CONTENT ====="

Get-ChildItem `
  release/win-unpacked/resources `
  -Recurse `
  -ErrorAction SilentlyContinue

Pop-Location