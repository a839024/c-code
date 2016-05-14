#include <stdio.h>
#include <stdlib.h>
int main(){
    FILE *outptr,*inptr,*inptr2;
    int i,j,n,m,raw,column,key,t;
    unsigned char lenna[512][512];
    unsigned char panda[32][32];
    int random[32][32];
    unsigned char mark[512][512];
    printf("Enter KEY:");
    scanf(" %d",&key);
    srand(key);
    inptr=fopen("lenna512.raw","rb");
    for(i=0;i<512;i++){
    	for(j=0;j<512;j++){
    		lenna[i][j] = fgetc(inptr);
    	}
    }
    inptr2=fopen("panda32.raw","rb");
    for(i=0;i<32;i++){
    	for(j=0;j<32;j++){
    		panda[i][j] = fgetc(inptr2);
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
            printf("%d \n",random[i][j]);
    		raw=random[i][j]/512;
    		column=random[i][j]%512;
    		t=lenna[raw][column]/2/2;
    		//printf("%d",random[i][j]);
    		//system("PAUSE");
    		if(panda[i][j]==255){
    			if(t%2==1){
					lenna[raw][column]-=4;
				}
			}
			else if(panda[i][j]==0){
				if(t%2==0){
					lenna[raw][column]+=4;
				}
    		}
    	}
    }
	//output watermark
	outptr=fopen("test.raw","wb");
    fwrite(lenna,sizeof(unsigned char),512*512,outptr);
    fclose(inptr);
    fclose(inptr2);
    fclose(outptr);
    system("PAUSE");
    return 0;
    
} 
