#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main(){
    FILE *inptr1,*inptr2;
    unsigned char lena[512][512];
    unsigned char test[512][512];
    int i,j;
    float MSE,PSNR;
    inptr1=fopen("test.raw","rb");
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            test[i][j] = fgetc(inptr1);
        }
    }
    fclose(inptr1);
    inptr2=fopen("lena.raw","rb");
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            lena[i][j] = fgetc(inptr2);
        }
    }
    fclose(inptr2);
    MSE = 0;
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
             MSE = MSE + (test[i][j] - lena[i][j])*(test[i][j] - lena[i][j]);     
        }
    }
    MSE = MSE/(512*512);
    printf("MSE=%f\n",MSE);
    PSNR=10*log10(pow(255,2)/MSE);
    printf("PSNR=%f",PSNR);
    system("PAUSE");
    return 0;
}
