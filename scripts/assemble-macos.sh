#!/bin/bash

set -e

echo "Preparing Electron Package"

mkdir -p self-flow-ui/action-service
mkdir -p self-flow-ui/computer-use-service
mkdir -p self-flow-ui/scheduler-service
mkdir -p self-flow-ui/process

echo "Checking Rust release folder sizes"

du -sh self-flow-rust-action-service/target/release/* || true
du -sh self-flow-rust-computer-use/target/release/* || true
du -sh self-flow-scheduler-service/target/release/* || true

echo "Copying Action Service"

install -m 755 \
  self-flow-rust-action-service/target/release/action-service \
  self-flow-ui/action-service/

echo "Copying Computer Use Service"

install -m 755 \
  self-flow-rust-computer-use/target/release/computer-use \
  self-flow-ui/computer-use-service/

echo "Copying Scheduler Service"

install -m 755 \
  self-flow-scheduler-service/target/release/scheduler-service \
  self-flow-ui/scheduler-service/

echo "Generating runtime.json"

cat > self-flow-ui/process/runtime.json <<EOF
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
EOF

echo "Building Electron"

cd self-flow-ui

npm run electron:pack:mac