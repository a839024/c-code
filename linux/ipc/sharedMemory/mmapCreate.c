#include <sys/mman.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>

typedef struct{
    char name[4];
    int age;
}people;

main(int argc, char** argv)
{
    int fd,i;
    people *p_map;
    char temp;

    fd = open(argv[1], O_CREAT | O_RDWR | O_TRUNC, 0777);
    //lseek(fd, sizeof(people)*5-1, SEEK_SET);
    //write(fd, "", 1);

    ftruncate(fd, sizeof(people)*5);

    p_map = (people*) mmap(NULL, sizeof(people)*10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    close(fd);
    temp = 'a';
    for(i=0; i<10; i++)
    {
        temp += 1;
        memcpy((*(p_map + i)).name, &temp, sizeof(temp));
        (*(p_map + i)).age = 20 + i;
    }


    printf("initialize over \n");
    sleep(10);
    munmap(p_map, sizeof(people)*10);
    printf("umap ok \n");
}
