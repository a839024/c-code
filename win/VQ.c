#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main(){
    FILE *inptr,*outptr,*inptr2;
    int i,j,T=0,k,m,n=99999999,index,o;
    unsigned char codebook[256][16];
    unsigned char gray[512][512];
    inptr=fopen("codebook_256","r");
    for(i=0;i<256;i++){
        //printf("%d:",i);               
        for(j=0;j<16;j++){
            codebook[i][j] = fgetc(inptr);
            
            //printf("%d ",codebook[i][j]);
        }
        //printf("\n");
    }
    fclose(inptr);
    inptr2=fopen("lenna.raw","rb");
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
                    gray[i][j]=fgetc(inptr2);
        }    
    }
    for(i=0;i<512;i=i+4){
        for(j=0;j<512;j=j+4){ 
            for(k=0;k<256;k++){           
                for(o=0;o<4;o++){
                    for(m=0;m<4;m++){
                        T+=pow((gray[i+o][j+m]-codebook[k][m+o*4]),2);
                    }
                }
                if(T<n){
                    n=T;
                    index=k;
                    //system("PAUSE");
                }
                T=0;
            }
            //printf("%d ",index);
            //system("PAUSE");
            for(o=0;o<4;o++){
                for(m=0;m<4;m++){
                    gray[i+o][j+m]=codebook[index][m+o*4];
                    //printf("%d ",gray[i+o][j+m]);
                    //system("PAUSE");
                }
            }
           // printf("\n");
            n=99999999;
        }
    }
    outptr=fopen("test.raw","wb");
    fwrite(gray,sizeof(unsigned char),512*512,outptr);
    fclose(inptr);
    fclose(inptr2);
    fclose(outptr);
    system("PAUSE");
    return 0;
    
}
