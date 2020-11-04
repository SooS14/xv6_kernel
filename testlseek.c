#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define SIZE 1024



int min(int a, int b)
{
	if (a < b)
	{
		return a;
	}
	else
	{
		return b;
	}
}



int main(int argc, char *argv[])
{

	int fd;
	int count;
	int offset;
	int n;
	char buf[SIZE+1];


	if (argc <= 3)
	{
		printf(1, "testlseek: arg error, give : file, count, offset\n");
		exit();
	}


	if ((fd = open(argv[1], O_RDONLY)) == -1)
	{
		printf(1, "testlseek : open error\n");
		exit();
	}
	
	

	count = atoi(argv[2]);
	offset = atoi(argv[3]);


	if (offset < 0)
	{
		lseek(fd, -offset, SEEK_END);
		//jnsp si cela est correcte mais, on positionne l'offset du fichier à size - offset
	}
	
	if (offset > 0)
	{
		lseek(fd, offset, SEEK_SET);
	}

	

	if (count < SIZE)
	{
		if ((n = read(fd, &buf, count)) == -1)
		{
			printf(1, "read err\n");
			exit();
		}

		write(1, &buf, n);
		
	}
	else
	{
		while (count > 0)
		{
			if ((n = read(fd, &buf, min(SIZE, count))) == -1)
			{
				printf(1, "read err\n");
				exit();
			}

			write(1, &buf, n);
			
			count -= SIZE;
		}
		
	}
		

	
	if (close(fd) == -1)
	{
		printf(1, "testlseek: close error\n");
		exit();
	}

	exit();
}


