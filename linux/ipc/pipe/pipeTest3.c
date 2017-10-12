#include <unistd.h>
#include <sys/types.h>
#include <error.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

main(){
    int pipe_fd[2];
    pid_t pid;
    char r_buf[4096];
    char w_buf[4096*2];
    int writenum;
    int rnum;

    memset(r_buf, 0, sizeof(r_buf));
    if(pipe(pipe_fd) < 0 ){
        printf("pipe create error\n");
        return -1;
    }

    if((pid=fork()) == 0){
        close(pipe_fd[1]);
        while(1){
            sleep(1);
            rnum = read(pipe_fd[0], r_buf, 1000);
            printf("child: readnum is %d\n", rnum);
        }
        close(pipe_fd[0]);
        exit(0);
    }else if(pid > 0){
        close(pipe_fd[0]);
        memset(r_buf, 0, sizeof(r_buf));
        if((writenum=write(pipe_fd[1], w_buf, 5000)) == -1)
            printf("write to pipe error\n");
        else
            printf("the byte write to pipe is %d\n", writenum);
        writenum = write(pipe_fd[1], w_buf, 5000);
        close(pipe_fd[1]);
    }
}
