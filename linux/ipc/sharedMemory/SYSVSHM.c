#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>

int main(void)
{
    int shmid;
    pid_t pid;
    int *shm;
    struct shmid_ds ds;

    shmid = shmget(IPC_PRIVATE, 100 * sizeof(int), IPC_CREAT | 0600);
    if(shmid < 0)
    {
        perror("shmget error");
        exit(-1);
    }

    shm = shmat(shmid, NULL, 0);
    if((int)shm == -1)
    {
        perror("shmat error");
        exit(-1);
    }

    shmctl(shmid, IPC_STAT, &ds);
    printf("the shared memory is only attached to the parent, so counter=%d\n\n", (int)ds.shm_nattch);

    pid = fork();

    if(pid == 0)
    {
        sleep(10);
        shmdt(shm);
        exit(-1);
    }
    else
    {
        shmctl(shmid, IPC_STAT, &ds);
        printf("the shared memory is attached to both the parent and child, so counter=%d\n", (int)ds.shm_nattch);
        printf("Notice that we didn't explicitly attach the shared memory to the child, but the counter is still %d\n", (int)ds.shm_nattch);

        wait(NULL);

        shmdt(shm);
        shmctl(shmid, IPC_RMID, NULL);
    }

    return 0;
}
