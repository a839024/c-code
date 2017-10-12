#include <stdio.h>
#include <mqueue.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

#define MAXSIZE 10

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

    unsigned int prio = 1;

    struct mq_attr msgq_attr;
    const char *file = "/posix";

    msgq_id = mq_open(file, O_RDWR | O_CREAT, S_IRWXU | S_IRWXG, NULL);
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

    if(mq_setattr(msgq_id, &msgq_attr, NULL) == -1)
    {
        perror("mq_setattr");
        exit(1);
    }

    int i = 0;
    while(i < 10)
    {
        msg.len = i;
        memset(msg.buf, 0, MAXSIZE);
        sprintf(msg.buf, "0x%x", i);
        msg.x = (char)(i + 'a');
        msg.y = (short)(i + 100);

        printf("msg.len = %d, msg.buf = %s, msg.x = %c, msg.y = %d\n", msg.len, msg.buf, msg.x, msg.y);

        if(mq_send(msgq_id, (char*)&msg, sizeof(struct MsgType), prio) == -1)
        {
            perror("mq_send");
            exit(1);
        }

        i++;
        sleep(1);
    }

    sleep(30);

    if(mq_close(msgq_id) == -1)
    {
        perror("mq_close");
        exit(1);
    }

    if(mq_unlink(file) == -1)
    {
        perror("mq_unlink");
        exit(1);
    }

    return 0;
}
