#include <stdint.h>
#include <stdio.h>

extern int64_t root(int64_t);

int main(void) {
  printf("%lld\n", (long long) root(6));
  return 0;
}
