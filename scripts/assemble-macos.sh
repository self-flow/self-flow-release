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

echo "Listing Rust binaries"

ls -lh self-flow-rust-action-service/target/release
ls -lh self-flow-rust-computer-use/target/release
ls -lh self-flow-scheduler-service/target/release

echo "Copying Action Service"

install -m 755 \
  self-flow-rust-action-service/target/release/self-flow-rust-action-service \
  self-flow-ui/action-service/

echo "Copying Computer Use Service"

install -m 755 \
  self-flow-rust-computer-use/target/release/computer-use \
  self-flow-ui/computer-use-service/

echo "Copying Scheduler Service"

install -m 755 \
  self-flow-scheduler-service/target/release/self-flow-rust-scheduler-service \
  self-flow-ui/scheduler-service/

echo "Generating runtime.json"

cat > self-flow-ui/process/runtime.json <<EOF
[
  {
    "service_name": "ui",
    "host": "0.0.0.0",
    "port": 60052,
    "userid": "8CLnvCayNPgFambAIsMbplkr7QJ2"
  },
  {
    "service_name": "action-service",
    "host": "127.0.0.1",
    "port": 60195,
    "userid": null
  },
  {
    "service_name": "computer-use",
    "host": "127.0.0.1",
    "port": 60197,
    "userid": null
  },
  {
    "service_name": "scheduler-service",
    "host": "127.0.0.1",
    "port": 60204,
    "userid": null
  }
]
EOF

echo "Building Electron"

cd self-flow-ui

npm run electron:pack:mac