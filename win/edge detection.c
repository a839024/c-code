#include <stdio.h>
#include <stdlib.h>
int main(){
    FILE *inptr,*outptr;
    int i,j,k,m;
    unsigned char gray[512][512];
    int Gx,Gy;
    inptr=fopen("gray.raw","rb");
    outptr=fopen("test.raw","wb");
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
                    gray[i][j]=fgetc(inptr);
        }    
    }
    for(i=0;i<512;i=i+3){
        for(j=0;j<512;j=j+3){
            printf("%d %d\n",i,j);            
            Gx=gray[i][j+2]-gray[i][j]+gray[i+1][j+2]*2-gray[i+1][j]*2+gray[i+2][j+2]-gray[i+2][j];
            Gy=gray[i][j]-gray[i+2][j]+gray[i][j+1]*2-gray[i+2][j+1]*2+gray[i][j+2]-gray[i+2][j+2];
            if(Gx<0) Gx=-Gx;
            if(Gy<0) Gy=-Gy;
            if(Gx>=27||Gy>=27){
                for(k=0;k<3;k++){
                    for(m=0;m<3;m++){
                        if(j==510&&m==2) continue; 
                        if(i==510&&k==2) continue;
                        gray[i+k][j+m]=0;
                    }
                }
            }
            else{
                for(k=0;k<3;k++){
                    for(m=0;m<3;m++){
                        if(j==510&&m==2) continue;
                        if(i==510&&k==2) continue;
                        gray[i+k][j+m]=255;
                    }
                }
            }
        }
    }
    fwrite(gray,sizeof(unsigned char),512*512,outptr);
    fclose(inptr);
    fclose(outptr);
    system("PAUSE");
    return 0;
    
}
