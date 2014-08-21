#ifndef _VECTOR_UINT_H
#define _VECTOR_UINT_H

int isVectorUint(FILE *fp);
void getLength(int *len, FILE *fp);
void readPixels(char *buf, int *len, int num, FILE *fp);

#endif
