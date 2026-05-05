FROM aflplusplus/aflplusplus:latest

WORKDIR /fuzzer

RUN apt-get update && apt-get install -y wget unzip build-essential

RUN wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.2.0%2Bcpu.zip \
    && unzip libtorch-cxx11-abi-shared-with-deps-2.2.0+cpu.zip \
    && rm libtorch-cxx11-abi-shared-with-deps-2.2.0+cpu.zip

COPY harness.cpp .

COPY seeds/ ./in/

RUN afl-clang-fast++ -fsanitize=address -O2 \
  -I./libtorch/include \
  -I./libtorch/include/torch/csrc/api/include \
  -L./libtorch/lib \
  -Wl,-rpath,./libtorch/lib \
  -ltorch -ltorch_cpu -lc10 \
  harness.cpp -o harness

RUN mkdir out
CMD ["afl-fuzz", "-i", "in/", "-o", "out/", "-m", "none", "--", "./harness"]
