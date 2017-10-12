#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#define FIFO_NAME ("/tmp/fifo.1")
#define MAXLINE (1024)

int main()
{
    int readfd;
    char status[MAXLINE];
    size_t n = 0;

    readfd = open(FIFO_NAME, O_RDONLY | O_NONBLOCK, 0);
    printf("%d\n", readfd);
    if(readfd == -1)
    {
        perror("open FIFO failed");
        unlink(FIFO_NAME);
        exit(1);
    }

    n = read(readfd, status, MAXLINE);
    if(n == -1)
    {
        perror("read FIFO failed");
        exit(1);
    }
    status[n] = 0;
    printf("PIPE CONTEN: %s\n", status);

    if(close(readfd) == -1)
    {
        perror("close FIFO failed");
        unlink(FIFO_NAME);
        exit(1);
    }

    sleep(10);
    unlink(FIFO_NAME);
    return 0;
}
