#include <unistd.h>
#include <stdio.h>

main()
{
	pid_t pid_test;
	pid_test = fork();

	if(pid_test < 0)
		printf("error in fork");
	else if (pid_test == 0)
	{
		printf("i am child process, ID is %d\n", getpid());
		printf("i am child's parent process, ID is %d\n", getppid());
	}
	else
	{
		printf("i am parent's parent process, ID is %d\n", getppid());
		printf("i am parent process, ID is %d\n", getpid());
		printf("parent process will return child process id, pID is %d\n", pid_test);
	}
}
