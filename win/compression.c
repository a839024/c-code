#include<stdio.h>
#include<stdlib.h>
int main(){
    FILE *input, *output;
    input=fopen("test.txt","r");
    output=fopen("result.txt","w");
	char str[100],tmp[10];
    int i,j,r,n,state,temp=1;  
    i=0;
    while(fscanf(input,"%c",&str[i])!=EOF){ //AABCDDDEFG
        if(i==0){
        	i++;
        	continue;
        }
        else if(i==1){
        	if(str[0]==str[1]){
        		state=1;
        		temp++;
        		i++;
        		continue;
        	}
        	if(str[0]!=str[1]){
        		state=0;
        		temp++;
        		i++;
        		continue;
        	}
        }
        else{
        	if(str[i]!=str[i-1]&&state==1){    
        		fprintf(output,"r%d%c",temp,str[0]);
        		printf("r%d%c",temp,str[0]);
        		str[0]=str[i];
        		state=0;
        		temp=1;
        	}
        	else if(str[i]==str[i-1]&&state!=1){
        		fprintf(output,"n%d",temp-1);
        		printf("n%d",temp-1);
        		for(i=0;i<temp-1;i++){
        			fprintf(output,"%c",str[i]);
        			printf("%c",str[i]);
        		}
        		str[0]=str[i];
        		str[1]=str[i];
        		i=2;
        		state=1;
        		temp=2;
        		continue;
        	}
        	else if(str[i]==str[i-1]&&state==1){
        		temp++;
        		i++;
        		continue;
        	}
        	else if(str[i]!=str[i-1]&&state!=1){
        		temp++;
        		i++;
        		continue;
        	}
        }
        
        
        
        
		i=1;
        
    }   
	if(state==0){
		fprintf(output,"n%d",temp);
		printf("n%d",temp);
		for(i=0;i<temp;i++){
        			fprintf(output,"%c",str[i]);
        			printf("%c",str[i]);
        		}
	}
	else{
		fprintf(output,"r%d%c",temp,str[0]);
        		printf("r%d%c",temp,str[0]);
	}
	fclose(input);
    fclose(output);
    
    return 0;
}
