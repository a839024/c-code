#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <pthread.h>
void *connection_handler(void *);
int main(void)
{
	mkdir("receive",0777);
	struct sockaddr_in server,client;
	int sock,csock,readSize,addressSize,c;
	char buf[256],temp;
	
	pthread_t sniffer_thread;
	bzero(&server,sizeof(server));
	server.sin_family=PF_INET;
	server.sin_addr.s_addr=inet_addr("127.0.0.1");
	server.sin_port=htons(6789);
	sock=socket(PF_INET,SOCK_STREAM,0);
	if(bind(sock,(struct sockaddr *)&server,sizeof(server))<0)return 0;
	listen(sock,5);
	addressSize=sizeof(client);
	while(csock=accept(sock,(struct sockaddr *)&server,(socklen_t*)&addressSize))
	{			//new link		
		if(pthread_create(&sniffer_thread,0,connection_handler,(void *)&csock)<0)	return 1;
		pthread_detach(sniffer_thread);
		if(csock<0) return 1;
	}
	return 0;
}
void *connection_handler(void *sock)
{
	int csock = *(int *)sock;
	int readSize;
	char buf[256],temp,filename[256],temp2[256];
	int i;
	char copy[6]="-copy";
	FILE *output,*input;
	//readSize=read(csock,buf,sizeof(buf));
	//write(csock,buf,sizeof(buf));

	strcpy(filename,"./receive/");
	readSize=read(csock,buf,sizeof(buf));
	strcat(filename,buf);
	strcat(filename,copy);
	output=fopen(filename,"wb");
	while(1)
	{
		bzero(buf,sizeof(buf));
		readSize=read(csock,buf,sizeof(buf));
		if(readSize==0)break;
		fprintf(output,"%s\n",buf);
		break;
	}
	fclose(output);
	printf("Receive finish!!\n");
	
	input=fopen(filename,"rb");
	if(!input)
	{
		printf("File is not exist!!\n");
	}
	else
	{
		printf("File found!!\n");
		write(csock,filename,sizeof(filename));
		while(1)
		{
			bzero(temp2,sizeof(temp2));
			if(fscanf(input,"%s\n",temp2)==EOF)break;
			printf("%s",temp2);
			readSize=write(csock,temp2,sizeof(temp2));
			printf("%dbytes was been sent!!\n",readSize);
		}
		
	}
	pthread_exit(0);
}

