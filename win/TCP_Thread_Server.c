#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <pthread.h>
void *connection_handler(void *);
int a[100]={0};
int working=1;
char allert[]="server is full";
int main(void){
	struct sockaddr_in server,client;
	int sock,csock,readSize,addressSize,c;
	char buf[256],temp[256];
	pthread_t sniffer_thread;

	bzero(&server,sizeof(server));
	server.sin_family=PF_INET;
	server.sin_addr.s_addr=inet_addr("127.0.0.1");
	server.sin_port=htons(6789);
	sock=socket(PF_INET,SOCK_STREAM,0);
	bind(sock,(struct sockaddr *)&server,sizeof(server)); 

	listen(sock,5);
	
	addressSize=sizeof(client);
	
	while(csock=accept(sock,(struct sockaddr *)&server,(socklen_t*)&addressSize)){			//new link	
		if(csock>=6){
			printf("server full\n");
			send(csock,allert,sizeof(allert),0);
			pthread_exit(0);
		}	
		working++;
		printf("online:%d\n",working-1);
		if(pthread_create(&sniffer_thread,0,connection_handler,(void *)&csock)<0){
			return 1; 
		}
		pthread_detach(sniffer_thread);

		if(csock<0) return 1;
	}
	return 0;
}
void *connection_handler(void *sock){
	char *buffer;
	int csock = *(int *)sock;
	int readSize;
	long addr = 0;
	char buf[256],temp[256];
	int number;
	int i;

	number = working;				//the online id
	
	while(readSize=read(csock,buf,sizeof(buf))){
		a[number]=csock;
		
		buf[readSize]=0;
		printf("read message:%s\n",buf);
		
		if(strcmp(buf,"quit")==0){
			working--;
			
			for(i=number;i<100;i++){
				a[i]=a[i+1];
				a[99]=0;
			}
			
			break;
		}
		for(i=1;i<100;i++){
			if(a[i]!=0)
			write(a[i],buf,sizeof(buf));
		}
	}
	if(readSize == 0){
		puts("Client disconnected");
		fflush(stdout);
		working--;
		a[number]=0;
		for(i=number;i<100;i++){
			a[i]=a[i+1];
			a[99]=0;
		}
		
	}
	pthread_exit(0);
}
