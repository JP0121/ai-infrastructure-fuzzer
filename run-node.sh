#!/bin/bash
# Lapis Forge Fuzzing Node Deployment Script

echo "[*] Setting host kernel core pattern..."
sudo bash -c 'echo core > /proc/sys/kernel/core_pattern'

echo "[*] Launching AFL++ Docker Node..."
docker run -d \
  --name fuzzer-node-1 \
  --security-opt seccomp=unconfined \
  --cap-add=SYS_PTRACE \
  -v $(pwd)/crashes:/fuzzer/out \
  pytorch-fuzzer

echo "[+] Node deployed successfully. View dashboard with: docker exec -it fuzzer-node-1 afl-whatsup /fuzzer/out"
