#include <stdio.h>
#include <stdlib.h>

int main(void){
    char key[100];
    char letter[27]={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
    char text[100];
    int P[50]={-1};
    int i,j,count=0,count2=0,x=0;
    FILE *inptr,*outptr;
    inptr=fopen("test.txt","r");
    outptr=fopen("result.txt","w");
    printf("Enter KEY:");
    scanf("%s",key);
    for(i=0;i<100;i++){
        if(key[i]-97==-97) break;
        count++;
    }
    i=0;
    while(fscanf(inptr,"%c",&text[i])!=EOF){
        for(j=0;j<26;j++){
            if(text[i]==letter[j]){
                P[i]=j;       
            }
        }
        i++;
        count2++;
    }
    for(i=0;i<count2/count+1;i++){    
        for(j=0;j<count;j++){
            if(i*count+j==count2) break;
            P[x]=P[x]+(int)key[j]-97;
            P[x]=P[x]%26;
            printf("%d ",P[x]);
            x++;
        }
    }
    for(i=0;i<x;i++)
        fprintf(outptr,"%c",letter[P[i]]);
    fclose(inptr);
    fclose(outptr);
    system("PAUSE");
    return 0;
}
