#include <stdio.h>
#include <stdlib.h>
int main(){
    FILE *inptr,*outptr;
    unsigned char picture[512][512][3];
    unsigned char test[512][512];
    int i,j,k;
    inptr=fopen("512Lenna.raw","rb");
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            for(k=0;k<3;k++){
                if(k==0)
                    picture[i][j][k] =0.299*fgetc(inptr);
                else if(k==1)
                    picture[i][j][k] =0.587*fgetc(inptr);
                else if(k==2)
                    picture[i][j][k] =0.114*fgetc(inptr);
            }
        }    
    }
    test[i][j]=0;
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            for(k=0;k<3;k++){
                test[i][j]=test[i][j]+picture[i][j][k];
            }
        }    
    }
    outptr=fopen("test.raw","wb");
    fwrite(test,sizeof(unsigned char),512*512,outptr);
    fclose(inptr);
    fclose(outptr);
    return 0;
}
