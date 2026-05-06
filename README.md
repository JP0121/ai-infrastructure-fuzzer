# ai-infrastructure-fuzzer
A containerized, high-performance AFL++ fuzzing pipeline for discovering zero-day memory corruption in PyTorch and AI infrastructure. Built by Lapis Forge.

# Lapis Forge: AI Infrastructure Fuzzer 🎯

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![C++](https://img.shields.io/badge/c++-%2300599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![Security](https://img.shields.io/badge/Security-Vulnerability_Research-red?style=for-the-badge)

An automated, highly scalable containerized fuzzing pipeline designed to stress-test the C++ backends of machine learning frameworks. Built by **Lapis Forge** to proactively discover memory corruption vulnerabilities (OOB reads, Buffer Overflows) in AI infrastructure.

Currently targeting **PyTorch (`libtorch`)** mathematical engines via AFL++ and AddressSanitizer (ASan).

## 🏗️ Architecture & DevOps Highlights

Fuzzing low-level C++ binaries inside isolated containers presents unique infrastructure challenges. This repository demonstrates several advanced DevOps and systems engineering patterns:

* **Kernel-Level Memory Monitoring:** Bypasses Docker's restrictive default `seccomp` profiles and strategically applies `SYS_PTRACE` capabilities. This allows AFL++ to monitor segmentation faults and memory violations without resorting to fully `--privileged` (and insecure) containers.
* **Persistent-Mode Harnessing:** Utilizes a custom C++ harness linking directly against `libtorch` using `__AFL_LOOP`, achieving execution speeds of 500+ mutations per second.
* **Volume-Mapped Crash Retention:** Decouples state from the container. All discovered crashes are instantly routed to the host machine, ensuring zero data loss if a fuzzing node goes down.
* **Scalable Node Deployment:** Designed to be deployed seamlessly across VPS instances for massive parallel fuzzing campaigns.

## 📁 Repository Structure

```text
ai-infrastructure-fuzzer/
├── Dockerfile          # Multi-stage AFL++ deployment environment
├── harness.cpp         # Target-specific C++ fuzzing harness (Testing torch::bmm)
├── seeds/              # Initial valid mathematical seed files
│   └── seed_bmm.bin    
├── .gitignore          # Prevents tracking of heavy binaries/crash dumps
├── run-node.sh         # Automated host configuration and container launch script
└── README.md
```
## 🚀 Quick Start / Deployment
1. Clone the Repository. First, bring the code down to the machine. Open a terminal and run:
   ```bash
   git clone https://github.com/JP0121/ai-infrastructure-fuzzer.git
   cd ai-infrastructure-fuzzer
   ```
2. Build the Docker Image
   ```bash
   docker build -t pytorch-fuzzer .
   ```
3. Configure the Host Kernel. Because the Docker container shares the host's underlying Linux kernel, the host must be told to allow programs to dump core memory when they crash. If this is skipped, AFL++ will refuse to start.
   ```bash
   sudo bash -c 'echo core > /proc/sys/kernel/core_pattern'
   ```
4. Launch the Fuzzing Node. Run the deployment script to automatically configure the host kernel and deploy the container safely:
   ```bash
   chmod +x run-node.sh
   ./run-node.sh
   ```
5. Monitor the Campaign. Check the AFL++ dashboard and execution metrics directly from the running container:
   ```bash
   Linux: docker exec -it fuzzer-node-1 afl-whatsup /fuzzer/out
   Windows/WSL: docker exec -it fuzzer-node-1 afl-whatsup //fuzzer/out
   ```
   📃Any discovered memory faults will be automatically extracted and saved locally on the host in the ./crashes directory.📃
      ```bash
      ls -la ./crashes/default/crashes/
      ```
## ⚠️ Disclaimer
This infrastructure is designed strictly for authorized security research, vulnerability discovery, and defensive engineering. All discovered vulnerabilities are subject to responsible disclosure practices.

