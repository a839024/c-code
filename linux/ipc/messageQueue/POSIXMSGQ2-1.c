#include <stdio.h>
#include <mqueue.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

#define MAXSIZE 10
#define BUFFER  8192

struct MsgType{
    int len;
    char buf[MAXSIZE];
    char x;
    short y;
};

int main()
{
    mqd_t msgq_id;
    struct MsgType msg;

    unsigned int sender = 1;
    struct mq_attr msgq_attr;

    unsigned int recv_size = BUFFER;
    const char *file = "/posix";

    msgq_id = mq_open(file, O_RDWR);
    if(msgq_id == (mqd_t)-1)
    {
        perror("mq_open");
        exit(1);
    }

    if(mq_getattr(msgq_id, &msgq_attr) == -1)
    {
        perror("mq_getattr");
        exit(1);
    }

    printf("Queue \"%s\":\n\t- stores at most %ld messages\n\t- \
            large at most %ld bytes each\n\t- currently holds %ld messages\n",
            file, msgq_attr.mq_maxmsg, msgq_attr.mq_msgsize, msgq_attr.mq_curmsgs);

    if(recv_size < msgq_attr.mq_msgsize)
        recv_size = msgq_attr.mq_msgsize;

    int i = 0;
    while(i < 10) {
        msg.len = -1;
        memset(msg.buf, 0, MAXSIZE);
        msg.x = ' ';
        msg.y = -1;

        if (mq_receive(msgq_id, (char*)&msg, recv_size, &sender) == -1)
        {
            perror("mq_receive");
            exit(1);
        }

        printf("msg.len = %d, msg.buf = %s, msg.x = %c, msg.y = %d\n", msg.len, msg.buf, msg.x, msg.y);

        i++;
        sleep(1);
    }

    if(mq_close(msgq_id) == -1)
    {
        perror("mq_close");
        exit(1);
    }

    return 0;
}
