#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * The result is broken pipe
 * Because both of the read-ends have been closed
 * If write before closing the read ends
 * The program will work success
 */

main(){
    int pipe_fd[2];
    pid_t pid;
    char r_buf[4];
    char* w_buf;
    int writenum;
    int cmd;

    memset(r_buf, 0, sizeof(r_buf));
    if(pipe(pipe_fd) < 0){
        printf("pipe create error");
        return -1;
    }
    pid=fork();
    if(pid == 0){
        close(pipe_fd[0]);
        close(pipe_fd[1]);
        sleep(10);
        exit(0);
    }else if(pid > 0){
        sleep(1);
//        close(pipe_fd[0]);
        w_buf = "111";
        if((writenum=write(pipe_fd[1], w_buf, 4)) == -1)
            printf("write to pipe error\n");
        else
            printf("the bytes write to pipe is %d\n", writenum);
        close(pipe_fd[1]);
//        close(pipe_fd[0]);
    }else{
        printf("process fork error");
    }
}
