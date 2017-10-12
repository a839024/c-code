#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main(){
    FILE *outptr,*inptr;
    int i,j,m,n,raw,column,key,t;
    unsigned char test[512][512];
    int random[32][32];
    unsigned char mark[32][32];
    inptr=fopen("test.raw","rb");
    printf("Enter KEY:");
    scanf(" %d",&key);
    srand(key);
    for(i=0;i<512;i++){
        for(j=0;j<512;j++){
            test[i][j]=fgetc(inptr);
        }
    }
    for(i=0;i<32;i++){
        for(j=0;j<32;j++){
            random[i][j]=rand()%(512*512);
    		for(m=0;m<=i;m++){
                for(n=0;n<32;n++){
                    if(m==i&&n==j) break;
                    if(random[m][n]==random[i][j]){
                        random[i][j]=rand()%(512*512);
                        m=0;
                        n=-1;
                    }
                        
                }
            }
            raw=random[i][j]/512;
            column=random[i][j]%512;
            t=test[raw][column]/2/2;
            if(t%2==0){
                mark[i][j]=255;
            }
            else if(t%2==1){
                mark[i][j]=0;
            }
        }
    }
    outptr=fopen("watermark.raw","wb");
    fwrite(mark,sizeof(unsigned char),32*32,outptr);
    fclose(inptr);
    fclose(outptr);
    system("PAUSE");
    return 0;
    
} 
