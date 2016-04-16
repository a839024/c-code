#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main(){
    FILE *outptr1,*outptr2,*outptr3,*outptr4,*outptr5,*outptr6,*outptr7,*outptr8,*inptr;
    int i,j;
    unsigned char gray[512][512];
    unsigned char gray1[512][512];
    inptr=fopen("lenna.raw","rb");
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
                    gray[i][j]=fgetc(inptr);
        }    
    }
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            if(gray[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr1=fopen("1bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr1);
    fclose(outptr1);
    //一 
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            gray1[i][j]=gray[i][j]/2;
            if(gray1[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr2=fopen("2bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr2);
    fclose(outptr2);
    //二 
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            gray1[i][j]=gray[i][j]/2/2;
            if(gray1[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr3=fopen("3bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr3);
    fclose(outptr3);
    //三 
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            gray1[i][j]=gray[i][j]/2/2/2;
            if(gray1[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr4=fopen("4bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr4);
    fclose(outptr4);
    //四 
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            gray1[i][j]=gray[i][j]/2/2/2/2;
            if(gray1[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr5=fopen("5bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr5);
    fclose(outptr5);
    //五 
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            gray1[i][j]=gray[i][j]/2/2/2/2/2;
            if(gray1[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr6=fopen("6bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr6);
    fclose(outptr6);
    //六 
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            gray1[i][j]=gray[i][j]/2/2/2/2/2/2;
            if(gray1[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr7=fopen("7bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr7);
    fclose(outptr7);
    //七 
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            gray1[i][j]=gray[i][j]/2/2/2/2/2/2/2;
            if(gray1[i][j]%2==0)
                gray1[i][j]=0;
            else
                gray1[i][j]=255;
        }
    }
    outptr8=fopen("8bit.raw","wb");
    fwrite(gray1,sizeof(unsigned char),512*512,outptr8);
    fclose(outptr8);
    //八 
    fclose(inptr);
    system("PAUSE");
    return 0;
    
} 
