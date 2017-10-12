#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FIFO_SERVER "/tmp/fifoserver"

main(int argc, char** argv)
{
    int fd;
    char w_buf[4096*2];
    char status[] = "success";
    size_t n;
    int read_wnum;
    memset(w_buf, 0, sizeof(w_buf));

    if((mkfifo(FIFO_SERVER, O_CREAT|O_EXCL) < 0) && (errno!=EEXIST))
        printf("cannot create fifoserver");
    if(fd == -1)
        if(errno == ENXIO)
            printf("open error; no reading process\n");
    fd = open(FIFO_SERVER, O_WRONLY, 0);
    //fd=open(FIFO_SERVER, O_WRONLY, 0);
    read_wnum = write(fd, w_buf, 2048);
    //n = write(fd, status, strlen(status));

    if(read_wnum == -1)
    {
        if(errno == EAGAIN)
            printf("write to fifo error; try later\n");
    }
    else
        printf("real write num is %d\n", read_wnum);
    read_wnum = write(fd, w_buf, 5000);

    //read_wnum = write(fd, w_buf, 4096);
    if(read_wnum == -1)
        if(errno == EAGAIN)
            printf("try later\n");
}

