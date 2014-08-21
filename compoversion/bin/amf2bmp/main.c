#include <stdio.h>
#include <string.h>

#include "vectorUint.h"
#include "bitmap.h"

int main(int argc, char *argv[]) {
	FILE *fp = NULL;
	FILE *bmp = NULL;
	char *label = NULL;
	unsigned int len;
	unsigned int fixed;
	unsigned int pos;
	
	if (argc < 3) {
		printf("Expected input file (arg 1) and output file (arg 2)\n");
		return 1;
	}
	
	fp = fopen(argv[1], "rb");
	if (!fp)
		goto fail;
	
	pos = strlen(argv[2]);
	label = (char*)malloc(pos+5);
	memset(label, 0x0, pos+5);
	strcat(label, argv[2]);
	label[pos+0] = '.';
	label[pos+1] = 'b';
	label[pos+2] = 'm';
	label[pos+3] = 'p';
	pos -= 4;
	label[pos+0] = '-';
	label[pos+1] = '0';
	label[pos+2] = '0';
	label[pos+3] = '0';
	while (1) {
		if (isVectorUint(fp)) {
			getLength(&len, fp);
			fixed = fgetc(fp);
		}
		if (feof(fp))
			break;
		
		if (label[pos+3] < '9')
			label[pos+3]++;
		else {
			label[pos+3] = '0';
			if (label[pos+2] < '9')
				label[pos+2]++;
			else {
				label[pos+2] = '0';
				if (label[pos+1] < '9')
					label[pos+1]++;
			}
		}
		
		bmp = fopen(label, "wb");
		if (!bmp)
			goto fail;
		
		writeHeader(bmp, 320, 240);
		writeDib(bmp, 320, 240);
		fillBMP(bmp, 320, 240);
		
		int y = 0;
		while (y < 240){
			char buffer[1280];
			readPixels(buffer, &len, 320, fp);
			writeLine(bmp, 320, 240, y, buffer);
			y++;
		}
		fclose(bmp);
		bmp = NULL;
		if (feof(fp))
			break;
	}
	
fail:
	if (fp)
		fclose(fp);
	if (bmp)
		fclose(bmp);
	
	system("PAUSE");
	return 0;
}

void writeLine(FILE *fp, unsigned int width, unsigned int height, int y, char *buffer) {
	int x = 0;
	while (x < 320) {
		char *s = buffer + x*4;
		char *d = buffer + x*3;
		d[0] = s[3];
		d[1] = s[2];
		d[2] = s[1];
		x++;
	}
	fseek(fp, 54+(height-1-y)*width*3, SEEK_SET);
	fwrite(buffer, width*3, 1, fp);
}
