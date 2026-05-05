#include <torch/torch.h>
#include <iostream>
#include <vector>

__AFL_FUZZ_INIT();

int main() {
#ifdef __AFL_HAVE_MANUAL_CONTROL
    __AFL_INIT();
#endif

    unsigned char *buf = __AFL_FUZZ_TESTCASE_BUF;
    
    while (__AFL_LOOP(10000)) {
        int len = __AFL_FUZZ_TESTCASE_LEN;
        if (len < 4) continue;

        try {
            int64_t b = buf[0];
            int64_t n = buf[1];
            int64_t m = buf[2];
            int64_t p = buf[3];
          
            torch::Tensor t1 = torch::randn({b, n, m}, torch::kFloat32);
            torch::Tensor t2 = torch::randn({b, m, p}, torch::kFloat32);
            torch::Tensor result = torch::bmm(t1, t2);

            result.sum().item<float>();

        } catch (const c10::Error& e) {
            continue;
        } catch (...) {
            continue;
        }
    }
    return 0;
}
