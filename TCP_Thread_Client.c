#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
int main(void){
	struct sockaddr_in server;
	int sock,readSize;
	char buf[256],temp[256];
	pid_t pid;
	int flag=0;

	bzero(&server,sizeof(server));
	server.sin_family=PF_INET;
	server.sin_addr.s_addr=inet_addr("127.0.0.1");
	server.sin_port=htons(6789);
	sock=socket(PF_INET,SOCK_STREAM,0);
	connect(sock,(struct sockaddr *)&server,sizeof(server));
	
	//scanf("%27[^\n]%*c",buf);	
	write(sock,buf,sizeof(buf));
	while(1){				//listen
		
		readSize=read(sock,temp,sizeof(temp));
		temp[readSize]=0;
		printf("read message:%s\n",temp);
		
   		pid = fork();
		if (pid == -1) {
     	 		perror("fork failed");
			exit(EXIT_FAILURE);
  	 	}
		else if (pid == 0) {
			readSize=read(sock,temp,sizeof(temp));
			temp[readSize]=0;
			printf("read message:%s\n",temp);
			if(flag!=0)  break;
			if(readSize==0)break;
		}
		else{
			if(scanf("%27[^\n]%*c",buf) !=EOF && strcmp(buf,"quit")!=0){
				write(sock,buf,sizeof(buf));
			}else {
				flag=1;
				_exit(EXIT_SUCCESS);
				break;
			}
		}
	}
}
