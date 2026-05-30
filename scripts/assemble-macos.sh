#!/bin/bash

set -e

echo "Preparing Electron Package"

mkdir -p self-flow-ui/action-service
mkdir -p self-flow-ui/computer-use-service
mkdir -p self-flow-ui/scheduler-service
mkdir -p self-flow-ui/process

echo "Copying Action Service"

cp action-service/target/release/* \
   self-flow-ui/action-service/

echo "Copying Computer Use Service"

cp computer-use-service/target/release/* \
   self-flow-ui/computer-use-service/

echo "Copying Scheduler Service"

cp scheduler-service/target/release/* \
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