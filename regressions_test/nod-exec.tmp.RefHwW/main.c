
#include <stdint.h>
#include <stdio.h>

extern int64_t root(void);

int main(void) {
  printf("%lld\n", (long long) root());
  return 0;
}
