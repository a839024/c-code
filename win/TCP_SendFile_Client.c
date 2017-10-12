#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
int main(void)
{
	struct sockaddr_in server;
	int sock,readSize;
	char buf[256],temp[256],filename[256];
	FILE *input,*output;
	pid_t pid;
	int flag=0;
	bzero(&server,sizeof(server));
	server.sin_family=PF_INET;
	server.sin_addr.s_addr=inet_addr("127.0.0.1");
	server.sin_port=htons(6789);	
	sock=socket(PF_INET,SOCK_STREAM,0);
	connect(sock,(struct sockaddr *)&server,sizeof(server));
	//readSize=read(sock,temp,sizeof(temp));
	//write(sock,buf,sizeof(buf));
	printf("Please enter the filename: ");
	scanf("%s",filename);
	input=fopen(filename,"rb");
	if(!input)
	{
		printf("File is not exist!!\n");
	}
	else
	{
		printf("File found!!\n");
		write(sock,filename,sizeof(filename));
		while(1)
		{
			bzero(temp,sizeof(temp));
			if(fscanf(input,"%s\n",temp)==EOF)break;
			printf("%s",temp);
			readSize=write(sock,temp,sizeof(temp));
			printf("%dbytes was been sent!!\n",readSize);
		}
		
	}
	//re~
	output=fopen("test2","wb");
	readSize=read(sock,filename,sizeof(filename));
	printf("FILENAME:%s",filename);
	while(1)
	{
		bzero(buf,sizeof(buf));
		readSize=read(sock,buf,sizeof(buf));
		if(readSize==0)break;
		fprintf(output,"%s\n",buf);
		break;
	}
	fclose(output);
	printf("\nReceive finish!!\n");



	//close(sock);
}
