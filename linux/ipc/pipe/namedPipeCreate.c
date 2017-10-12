#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

#define FIFO_NAME ("/tmp/fifo.1")
#define FILE_MODE (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)

int main()
{
    int writefd;
    char status[] = "success";
    size_t n = 0;
    printf("before mkfifo\n");
    if(mkfifo(FIFO_NAME, FILE_MODE) < 0)
    {
        if(EEXIST == errno)
        {
            printf("FIFO: %s already exist, cannot be created.\n", FIFO_NAME);
        }
        else
        {
            perror("create FIFO failed");
            exit(1);
        }
    }

    printf("before open\n");
    writefd = open(FIFO_NAME, O_WRONLY, 0);
    printf("after open\n");
    if( writefd == -1)
    {
        perror("open FIFO failed");
        unlink(FIFO_NAME);
        exit(1);
    }

    n = write(writefd, status, strlen(status));
    if(n != strlen(status))
    {
        perror("write FIFO failed");
        unlink(FIFO_NAME);
        exit(1);
    }

    if(close(writefd) == -1)
    {
        perror("close FIFO failed");
        unlink(FIFO_NAME);
        exit(1);
    }
    return 0;
}
