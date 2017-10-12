#include <sys/mman.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

typedef struct
{
    char name[4];
    int age;
} people;

main(int argc, char** argv)
{
    int i, fd;
    people* p_map;
    char temp = 'a';
    fd = shm_open(argv[1], O_CREAT | O_RDWR, 00777);
    if(-1 == fd)
    {
        printf("open file error = %s\n", strerror(errno));
        return -1;
    }

    ftruncate(fd, sizeof(people)*5);
    p_map = (people*)mmap(NULL, sizeof(people)*10, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

    if(MAP_FAILED == p_map)
    {
        printf("mmap file error = %s\n", strerror(errno));
        return -1;
    }

    close(fd);
    for(i = 0; i < 10; i++)
    {
        memcpy( (*(p_map+i)).name, &temp, sizeof(temp));
//        (*(p_map+i)).name[1] = 0;
        (*(p_map+i)).age = 20 + i;
        temp += 1;
    }
    printf("initialize over\n");

    sleep(10);
    //close(fd);
    munmap(p_map, sizeof(people)*10);
    printf("unmap ok");
    return 0;
}
