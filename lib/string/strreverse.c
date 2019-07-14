#include<string.h>

void strreverse(const char* input, char* output) {
    size_t inputLength = strlen(input);
    for (unsigned int i = 0; i < inputLength; ++i) {
        output[i] = input[inputLength - 1 - i];
    }
}