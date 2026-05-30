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
  action-service/target/release/*.exe `
  self-flow-ui/action-service/

Write-Host "Copying Computer Use Service"

Copy-Item `
  computer-use-service/target/release/*.exe `
  self-flow-ui/computer-use-service/

Write-Host "Copying Scheduler Service"

Copy-Item `
  scheduler-service/target/release/*.exe `
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

Write-Host "Building Electron"

Push-Location self-flow-ui

npm run electron:pack:win

Pop-Location