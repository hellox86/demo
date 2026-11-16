#include <stdio.h>
#include <math.h>
#include <float.h>

#define TAB 256

float sintab[TAB];

void sintable() {
  for (size_t i = 0; i < TAB; i++) {
    sintab[i] = sinf((2.0f * M_PI * i) / TAB);
  }
}


int main() {
  sintable();
  for (size_t i = 0; i < TAB; i++) {
    float e = sintab[i];
    int el = e * (1 << 16);
    printf("%d, ", el);
    if (i != 0 && i % 64 == 0) printf("\n");
  }
  printf("\n%d", (int)M_PI * (1 << 16));
  
  return 0;
}
