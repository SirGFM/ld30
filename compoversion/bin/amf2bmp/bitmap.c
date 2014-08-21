#include <stdio.h>
#include <string.h>

#include "bitmap.h"

void writeHeader(FILE *fp, unsigned int width, unsigned int height) {
	unsigned char header[14];
	unsigned int size;
	unsigned int padding;
	
	padding = (width * 3) % 4;
	if (padding)
		padding = 4 - padding;
	
	size = (width*3 + padding)*height + 54;
	
	memset(header, 0x0, 14);
	header[0] = 'B';
	header[1] = 'M';
	header[2] = ((unsigned char*)(&size))[0];
	header[3] = ((unsigned char*)(&size))[1];
	header[4] = ((unsigned char*)(&size))[2];
	header[5] = ((unsigned char*)(&size))[3];
	header[10] = 54;
	
	fwrite(header, 14, 1, fp);
}

void writeDib(FILE *fp, unsigned int width, unsigned int height) {
	unsigned char dib[40];
	unsigned int size;
	unsigned int padding;
	
	padding = (width * 3) % 4;
	if (padding)
		padding = 4 - padding;
	
	size = (width*3 + padding)*height + 54;
	
	memset(dib, 0x0, 40);
	// Header size
	dib[0] = 40;
	// Width
	dib[4] = ((unsigned char*)(&width))[0];
	dib[5] = ((unsigned char*)(&width))[1];
	dib[6] = ((unsigned char*)(&width))[2];
	dib[7] = ((unsigned char*)(&width))[3];
	// Height
	dib[8] = ((unsigned char*)(&height))[0];
	dib[9] = ((unsigned char*)(&height))[1];
	dib[10] = ((unsigned char*)(&height))[2];
	dib[11] = ((unsigned char*)(&height))[3];
	// Planes
	dib[12] = 1;
	// BBP
	dib[14] = 24;
	// Size in bytes
	dib[20] = ((unsigned char*)(&size))[0];
	dib[21] = ((unsigned char*)(&size))[1];
	dib[22] = ((unsigned char*)(&size))[2];
	dib[23] = ((unsigned char*)(&size))[3];
	// DPI (horizontal)
	dib[24] = 0x13;
	dib[25] = 0x0b;
	// DPI (vertical)
	dib[26] = 0x13;
	dib[27] = 0x0b;
	
	fwrite(dib, 40, 1, fp);
}

void fillBMP(FILE *fp, unsigned int width, unsigned int height) {
	unsigned char line[960];
	
	memset(line, 0x0, 960);
	
	int y = 0;
	while (y < 240) {
		fwrite(line, 960, 1, fp);
		y++;
	}
}
