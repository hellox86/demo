#include <math.h>
#include <stdio.h>
#include <string.h>
// learn from here https://github.com/tarantino07/cube.c
#include <unistd.h>

float A, B, C;

float cubeWidth = 20;
int width = 100, height = 44;
float zBuffer[100 * 44]; 

// Грубо говоря храню здесь отдаленность каждой точки от камеры

char buffer[100 * 44];
int backgroundASCIICode = ' ';
int distanceFromCam = 200; // always in z axis
float horizontalOffset;

float K1 = 40;

float x, y, z;
float ooz; // мера близости точки от камеры, чем ближе точка, тем больше ooz
int xp, yp;
int idx;

float calculateX(float i, float j, float k) {
  return j * sinf(A) * sinf(B) * cosf(C) - k * cosf(A) * sinf(B) * cosf(C) +
         j * cosf(A) * sinf(C) + k * sinf(A) * sinf(C) + i * cosf(B) * cosf(C);
}

float calculateY(float i, float j, float k) {
  return j * cosf(A) * cosf(C) + k * sinf(A) * cosf(C) -
         j * sinf(A) * sinf(B) * sinf(C) + k * cosf(A) * sinf(B) * sinf(C) -
         i * cosf(B) * sinf(C);
}

float calculateZ(float i, float j, float k) {
  return k * cosf(A) * cosf(B) - j * sinf(A) * cosf(B) + i * sinf(B);
}

void calculateForSurface(float cubeX, float cubeY, float cubeZ, int ch) {
  x = calculateX(cubeX, cubeY, cubeZ);
  y = calculateY(cubeX, cubeY, cubeZ);
  z = calculateZ(cubeX, cubeY, cubeZ) + distanceFromCam;

  ooz = 1 / z;
  // представляю 3D точки в 2D
  xp = (int)(width / 2 + horizontalOffset + K1 * ooz * x * 2);
  yp = (int)(height / 2 + K1 * ooz * y); 

  idx = xp + yp * width;
  
  if (idx >=0 && idx < width*height) {
  if (ooz > zBuffer[idx]) { // если новая точки ближе к камере
      zBuffer[idx] = ooz;
      buffer[idx] = ch;
  }
}
}

int main() {
  printf("\x1b[2J"); // clear screen
  while (1) {
    memset(buffer, backgroundASCIICode, width * height);
    memset(zBuffer, 0, width * height * 4); // 4 - float type size

    for (float cubeX = -cubeWidth; cubeX < cubeWidth; cubeX += 0.15) {
      for (float cubeY = -cubeWidth; cubeY < cubeWidth; cubeY += 0.15)
    {
      // по граням куба
        calculateForSurface(cubeX, cubeY, -cubeWidth, '@');
        calculateForSurface(cubeWidth, cubeY, cubeX, '$');
        calculateForSurface(-cubeWidth, cubeY, -cubeX, '~');
        calculateForSurface(-cubeX, cubeY, cubeWidth, '#');
        calculateForSurface(cubeX, -cubeWidth, -cubeY, ';');
        calculateForSurface(cubeX, cubeWidth, cubeY, '+');
      }
    }
    printf("\x1b[H"); // cursor to (1, 1)
    for (int k = 0; k < width * height; k++) {
      putchar(k % width ? buffer[k] : '\n');
    }

    A += 0.05;
    B += 0.05;
    C += 0.01;
    usleep(16000); // micros sleep
  }
  return 0;
}