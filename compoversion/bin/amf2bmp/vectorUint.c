
#include <stdio.h>
#include "vectorUint.h"

int isVectorUint(FILE *fp) {
	unsigned int c = fgetc(fp);
	return c == 0x0e;
}

void getLength(int *len, FILE *fp) {
	unsigned int c;
	unsigned int tmp;
	
	tmp = 0;
	while (1) {
		c = fgetc(fp);
		tmp <<= 7;
		tmp |= c & 0x7f;
		// break when lowest (?) bit is 0
		if (!(c & 0x80))
			break;
	}
	tmp >>= 1;
	
	*len = tmp;
}

void readPixels(char *buf, int *len, int num, FILE *fp) {
	if (num*4 > *len)
		num = *len/4;
	fread(buf, num*4, 1, fp);
}
