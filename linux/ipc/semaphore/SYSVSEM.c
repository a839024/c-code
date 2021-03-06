#include <stdio.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>

void die(char *msg)
{
    perror(msg);
    exit(1);
}

int main()
{
    int i,j;
    int pid;
    int semid; /* semid of semaphore set */
    key_t key ; /* key to pass to semget() */
    int semflg = IPC_CREAT | 0666; /* semflg to pass to semget() */
    int nsems = 1; /* nsems to pass to semget() */
    int nsops; /* number of operations to do */
    struct sembuf *sops = (struct sembuf *) malloc(2*sizeof(struct sembuf));
    /* ptr to operations to perform */

    /* generate key */
    if ((key = ftok(".", 'Q')) == -1)
         die("ftok");

    /* set up semaphore */

    printf("\nsemget: Setting up semaphore: semget(%#lx, %\
        %#o)\n",key, nsems, semflg);
    if ((semid = semget(key, nsems, semflg)) == -1)
        die("semget: semget failed");


    if ((pid = fork()) < 0)
        die("fork");

    if (pid == 0)
    {
        /* child */
        i = 0;

        while (i< 3)/* allow for 3 semaphore sets */
        {
            nsops = 2;
            /* wait for semaphore to reach zero */
            sops[0].sem_num = 0; /* We only use one track */
            sops[0].sem_op = 0; /* wait for semaphore flag to become zero */
            sops[0].sem_flg = SEM_UNDO; /* take off semaphore asynchronous*/

            sops[1].sem_num = 0;
            sops[1].sem_op = 1; /* increment semaphore -- take control of track */
            sops[1].sem_flg = SEM_UNDO | IPC_NOWAIT; /* take off semaphore */

            /* Recap the call to be made. */
            printf("\nsemop:ChildCalling semop(%d, &sops, %d) with:", semid, nsops);

            /* Make the semop() call and report the results. */
            if ((j = semop(semid, sops, nsops)) == -1)
                perror("semop: semop failed");
            else
            {
                printf("\n\nChild Process Taking Control of Track: %d/3 times\n", i+1);
                sleep(5); /* DO Nothing for 5 seconds */

                nsops = 1;

                /* wait for semaphore to reach zero */
                sops[0].sem_num = 0;
                sops[0].sem_op = -1; /* Give UP COntrol of track */
                sops[0].sem_flg = SEM_UNDO | IPC_NOWAIT; /* take off semaphore, asynchronous*/

                if ((j = semop(semid, sops, nsops)) == -1)
                    perror("semop: semop failed");
                else
                     printf("Child Process Giving up Control of Track: %d/3 times\n", i+1);
                sleep(5); /* halt process to allow parent to catch semaphore change first */
            }
            ++i;
        }

    }
    else /* parent */
    {
        i = 0;
        while (i< 3) /* allow for 3 semaphore sets */
        {
            nsops = 2;

            /* wait for semaphore to reach zero */
            sops[0].sem_num = 0;
            sops[0].sem_op = 0; /* wait for semaphore flag to become zero */
            sops[0].sem_flg = SEM_UNDO; /* take off semaphore asynchronous*/

            sops[1].sem_num = 0;
            sops[1].sem_op = 1; /* increment semaphore -- take control of track */
            sops[1].sem_flg = SEM_UNDO | IPC_NOWAIT; /* take off semaphore */

            /* Recap the call to be made. */
             printf("\nsemop:Parent Calling semop(%d, &sops, %d) with:", semid, nsops);

    /* Make the semop() call and report the results. */
             if ((j = semop(semid, sops, nsops)) == -1)
             {
                 perror("semop: semop failed");
             }
             else
             {
                 printf("Parent Process Taking Control of Track: %d/3 times\n", i+1);
                 sleep(5); /* Sleep for 5 seconds */
                 nsops = 1;

                 /* wait for semaphore to reach zero */
                 sops[0].sem_num = 0;
                 sops[0].sem_op = -1; /* Give UP Control of track */
                 sops[0].sem_flg = SEM_UNDO | IPC_NOWAIT; /* take off semaphore, asynchronous*/

                 if ((j = semop(semid, sops, nsops)) == -1)
                 {
                     perror("semop: semop failed");
                 }
                 else
                     printf("Parent Process Giving up Control of Track: %d/3 times\n", i+1);
                 sleep(5); /* halt process to allow child to catch semaphore change first */
             }
             ++i;
        }
    }
}
