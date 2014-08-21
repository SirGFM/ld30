#ifndef __BITMAP_H
#define __BITMAP_H

void writeHeader(FILE *fp, unsigned int width, unsigned int height);
void writeDib(FILE *fp, unsigned int width, unsigned int height);
void fillBMP(FILE *fp, unsigned int width, unsigned int height);
void writeLine(FILE *fp, unsigned int width, unsigned int height, int y, char *buffer);

#endif
