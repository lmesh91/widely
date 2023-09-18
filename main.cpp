#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include <chrono>
#include <pari/pari.h>

long pow10arr[19];

void init() {
    for (int i = 0; i < 19; i++) {
        pow10arr[i] = pow(10, i);
    }
}
// Function to check if a number is prime
bool isPrime(long n) {
    /*if (n <= 1) return false;
    if (n <= 3) return true;

    if (n % 2 == 0 || n % 3 == 0) return false;

    for (long i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) return false;
    }

    return true;*/
    return uisprime(n) == 1;
}

int stringLen(long x) {
    int len = 0;
    while (x > 0) {
        x /= 10;
        len++;
    }
    return len;
}

long getDigit(long x, int d) {
    return (x / pow10arr[d]) % 10;
}

long getRightSide(long x, int d) {
    return x % pow10arr[d];
}

long getLeftSide(long x, int d) {
    return x / pow10arr[d] * pow10arr[d];
}


bool long_digitallyDelicate(long x) {
    // Get len of string
    int L = stringLen(x);
    for (int i = 0; i < L; i++) {
        for (int d = 0; d < 10; d++) {
            long diff = d - getDigit(x, i);
            if (diff != 0) {
                long num = getLeftSide(x, i) + diff * pow10arr[i] + getRightSide(x, i);
                if (isPrime(num)) {
                    return false;
                }
            }
        }
    }
    return true;
}

bool long_digitallyUnstable(long x) {
    // Get len of string
    int L = stringLen(x);
    for (int i = 0; i <= L; i++) {
        for (long d = 0; d < 10; d++) {
            if (d != 0 || i != L) {
                long num = getLeftSide(x, i) * 10L + d * pow10arr[i] + getRightSide(x, i);
                if (isPrime(num)) {
                    return false;
                }
            }
        }
    }
    return true;
}
int main() {
    init();
    pari_init(400000000, 2); // Initialize PARI with enough stack space
    
    auto startTime = std::chrono::high_resolution_clock::now();

    long i = 2147483659;
    bool foundNum = false;
    while (!foundNum) {
        if (uisprime(i) == 1) {
            if (long_digitallyUnstable(i)) {
                std::cout << i << std::endl;
                if (long_digitallyDelicate(i)) {
                    std::cout << "^ This number is WDI" << std::endl;
                    foundNum = true;
                }
            }
        }
        i++;
    }
    
    auto stopTime = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stopTime - startTime);
    std::cout << "Execution finished in " << duration.count() << "ms" << std::endl;
}