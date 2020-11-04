
_testlseek:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <min>:
#define SIZE 1024



int min(int a, int b)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
	if (a < b)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	3b 45 0c             	cmp    0xc(%ebp),%eax
   d:	7d 05                	jge    14 <min+0x14>
	{
		return a;
   f:	8b 45 08             	mov    0x8(%ebp),%eax
  12:	eb 03                	jmp    17 <min+0x17>
	}
	else
	{
		return b;
  14:	8b 45 0c             	mov    0xc(%ebp),%eax
	}
}
  17:	5d                   	pop    %ebp
  18:	c3                   	ret    

00000019 <main>:



int main(int argc, char *argv[])
{
  19:	f3 0f 1e fb          	endbr32 
  1d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  21:	83 e4 f0             	and    $0xfffffff0,%esp
  24:	ff 71 fc             	pushl  -0x4(%ecx)
  27:	55                   	push   %ebp
  28:	89 e5                	mov    %esp,%ebp
  2a:	53                   	push   %ebx
  2b:	51                   	push   %ecx
  2c:	81 ec 20 04 00 00    	sub    $0x420,%esp
  32:	89 cb                	mov    %ecx,%ebx
	int offset;
	int n;
	char buf[SIZE+1];


	if (argc <= 3)
  34:	83 3b 03             	cmpl   $0x3,(%ebx)
  37:	7f 17                	jg     50 <main+0x37>
	{
		printf(1, "testlseek: arg error, give : file, count, offset\n");
  39:	83 ec 08             	sub    $0x8,%esp
  3c:	68 f8 09 00 00       	push   $0x9f8
  41:	6a 01                	push   $0x1
  43:	e8 e8 05 00 00       	call   630 <printf>
  48:	83 c4 10             	add    $0x10,%esp
		exit();
  4b:	e8 5c 04 00 00       	call   4ac <exit>
	}


	if ((fd = open(argv[1], O_RDONLY)) == -1)
  50:	8b 43 04             	mov    0x4(%ebx),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	6a 00                	push   $0x0
  5d:	50                   	push   %eax
  5e:	e8 89 04 00 00       	call   4ec <open>
  63:	83 c4 10             	add    $0x10,%esp
  66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  69:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  6d:	75 17                	jne    86 <main+0x6d>
	{
		printf(1, "testlseek : open error\n");
  6f:	83 ec 08             	sub    $0x8,%esp
  72:	68 2a 0a 00 00       	push   $0xa2a
  77:	6a 01                	push   $0x1
  79:	e8 b2 05 00 00       	call   630 <printf>
  7e:	83 c4 10             	add    $0x10,%esp
		exit();
  81:	e8 26 04 00 00       	call   4ac <exit>
	}
	
	

	count = atoi(argv[2]);
  86:	8b 43 04             	mov    0x4(%ebx),%eax
  89:	83 c0 08             	add    $0x8,%eax
  8c:	8b 00                	mov    (%eax),%eax
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	50                   	push   %eax
  92:	e8 2d 03 00 00       	call   3c4 <atoi>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	offset = atoi(argv[3]);
  9d:	8b 43 04             	mov    0x4(%ebx),%eax
  a0:	83 c0 0c             	add    $0xc,%eax
  a3:	8b 00                	mov    (%eax),%eax
  a5:	83 ec 0c             	sub    $0xc,%esp
  a8:	50                   	push   %eax
  a9:	e8 16 03 00 00       	call   3c4 <atoi>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 ec             	mov    %eax,-0x14(%ebp)


	if (offset < 0)
  b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  b8:	79 16                	jns    d0 <main+0xb7>
	{
		lseek(fd, -offset, SEEK_END);
  ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  bd:	f7 d8                	neg    %eax
  bf:	83 ec 04             	sub    $0x4,%esp
  c2:	6a 02                	push   $0x2
  c4:	50                   	push   %eax
  c5:	ff 75 f0             	pushl  -0x10(%ebp)
  c8:	e8 7f 04 00 00       	call   54c <lseek>
  cd:	83 c4 10             	add    $0x10,%esp
		//jnsp si cela est correcte mais, on positionne l'offset du fichier à size - offset
	}
	
	if (offset > 0)
  d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  d4:	7e 13                	jle    e9 <main+0xd0>
	{
		lseek(fd, offset, SEEK_SET);
  d6:	83 ec 04             	sub    $0x4,%esp
  d9:	6a 00                	push   $0x0
  db:	ff 75 ec             	pushl  -0x14(%ebp)
  de:	ff 75 f0             	pushl  -0x10(%ebp)
  e1:	e8 66 04 00 00       	call   54c <lseek>
  e6:	83 c4 10             	add    $0x10,%esp
	}

	

	if (count < SIZE)
  e9:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  f0:	0f 8f b8 00 00 00    	jg     1ae <main+0x195>
	{
		if ((n = read(fd, &buf, count)) == -1)
  f6:	83 ec 04             	sub    $0x4,%esp
  f9:	ff 75 f4             	pushl  -0xc(%ebp)
  fc:	8d 85 e7 fb ff ff    	lea    -0x419(%ebp),%eax
 102:	50                   	push   %eax
 103:	ff 75 f0             	pushl  -0x10(%ebp)
 106:	e8 b9 03 00 00       	call   4c4 <read>
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 111:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
 115:	75 17                	jne    12e <main+0x115>
		{
			printf(1, "read err\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 42 0a 00 00       	push   $0xa42
 11f:	6a 01                	push   $0x1
 121:	e8 0a 05 00 00       	call   630 <printf>
 126:	83 c4 10             	add    $0x10,%esp
			exit();
 129:	e8 7e 03 00 00       	call   4ac <exit>
		}

		write(1, &buf, n);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	ff 75 e8             	pushl  -0x18(%ebp)
 134:	8d 85 e7 fb ff ff    	lea    -0x419(%ebp),%eax
 13a:	50                   	push   %eax
 13b:	6a 01                	push   $0x1
 13d:	e8 8a 03 00 00       	call   4cc <write>
 142:	83 c4 10             	add    $0x10,%esp
 145:	eb 6d                	jmp    1b4 <main+0x19b>
	}
	else
	{
		while (count > 0)
		{
			if ((n = read(fd, &buf, min(SIZE, count))) == -1)
 147:	83 ec 08             	sub    $0x8,%esp
 14a:	ff 75 f4             	pushl  -0xc(%ebp)
 14d:	68 00 04 00 00       	push   $0x400
 152:	e8 a9 fe ff ff       	call   0 <min>
 157:	83 c4 10             	add    $0x10,%esp
 15a:	83 ec 04             	sub    $0x4,%esp
 15d:	50                   	push   %eax
 15e:	8d 85 e7 fb ff ff    	lea    -0x419(%ebp),%eax
 164:	50                   	push   %eax
 165:	ff 75 f0             	pushl  -0x10(%ebp)
 168:	e8 57 03 00 00       	call   4c4 <read>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	89 45 e8             	mov    %eax,-0x18(%ebp)
 173:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
 177:	75 17                	jne    190 <main+0x177>
			{
				printf(1, "read err\n");
 179:	83 ec 08             	sub    $0x8,%esp
 17c:	68 42 0a 00 00       	push   $0xa42
 181:	6a 01                	push   $0x1
 183:	e8 a8 04 00 00       	call   630 <printf>
 188:	83 c4 10             	add    $0x10,%esp
				exit();
 18b:	e8 1c 03 00 00       	call   4ac <exit>
			}

			write(1, &buf, n);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	ff 75 e8             	pushl  -0x18(%ebp)
 196:	8d 85 e7 fb ff ff    	lea    -0x419(%ebp),%eax
 19c:	50                   	push   %eax
 19d:	6a 01                	push   $0x1
 19f:	e8 28 03 00 00       	call   4cc <write>
 1a4:	83 c4 10             	add    $0x10,%esp
			
			count -= SIZE;
 1a7:	81 6d f4 00 04 00 00 	subl   $0x400,-0xc(%ebp)
		while (count > 0)
 1ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b2:	7f 93                	jg     147 <main+0x12e>
		
	}
		

	
	if (close(fd) == -1)
 1b4:	83 ec 0c             	sub    $0xc,%esp
 1b7:	ff 75 f0             	pushl  -0x10(%ebp)
 1ba:	e8 15 03 00 00       	call   4d4 <close>
 1bf:	83 c4 10             	add    $0x10,%esp
 1c2:	83 f8 ff             	cmp    $0xffffffff,%eax
 1c5:	75 17                	jne    1de <main+0x1c5>
	{
		printf(1, "testlseek: close error\n");
 1c7:	83 ec 08             	sub    $0x8,%esp
 1ca:	68 4c 0a 00 00       	push   $0xa4c
 1cf:	6a 01                	push   $0x1
 1d1:	e8 5a 04 00 00       	call   630 <printf>
 1d6:	83 c4 10             	add    $0x10,%esp
		exit();
 1d9:	e8 ce 02 00 00       	call   4ac <exit>
	}

	exit();
 1de:	e8 c9 02 00 00       	call   4ac <exit>

000001e3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	57                   	push   %edi
 1e7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1eb:	8b 55 10             	mov    0x10(%ebp),%edx
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	89 cb                	mov    %ecx,%ebx
 1f3:	89 df                	mov    %ebx,%edi
 1f5:	89 d1                	mov    %edx,%ecx
 1f7:	fc                   	cld    
 1f8:	f3 aa                	rep stos %al,%es:(%edi)
 1fa:	89 ca                	mov    %ecx,%edx
 1fc:	89 fb                	mov    %edi,%ebx
 1fe:	89 5d 08             	mov    %ebx,0x8(%ebp)
 201:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 204:	90                   	nop
 205:	5b                   	pop    %ebx
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    

00000209 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 209:	f3 0f 1e fb          	endbr32 
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 219:	90                   	nop
 21a:	8b 55 0c             	mov    0xc(%ebp),%edx
 21d:	8d 42 01             	lea    0x1(%edx),%eax
 220:	89 45 0c             	mov    %eax,0xc(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8d 48 01             	lea    0x1(%eax),%ecx
 229:	89 4d 08             	mov    %ecx,0x8(%ebp)
 22c:	0f b6 12             	movzbl (%edx),%edx
 22f:	88 10                	mov    %dl,(%eax)
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	84 c0                	test   %al,%al
 236:	75 e2                	jne    21a <strcpy+0x11>
    ;
  return os;
 238:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23d:	f3 0f 1e fb          	endbr32 
 241:	55                   	push   %ebp
 242:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 244:	eb 08                	jmp    24e <strcmp+0x11>
    p++, q++;
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	0f b6 00             	movzbl (%eax),%eax
 254:	84 c0                	test   %al,%al
 256:	74 10                	je     268 <strcmp+0x2b>
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	0f b6 10             	movzbl (%eax),%edx
 25e:	8b 45 0c             	mov    0xc(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	38 c2                	cmp    %al,%dl
 266:	74 de                	je     246 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	0f b6 d0             	movzbl %al,%edx
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	0f b6 c0             	movzbl %al,%eax
 27a:	29 c2                	sub    %eax,%edx
 27c:	89 d0                	mov    %edx,%eax
}
 27e:	5d                   	pop    %ebp
 27f:	c3                   	ret    

00000280 <strlen>:

uint
strlen(const char *s)
{
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 28a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 291:	eb 04                	jmp    297 <strlen+0x17>
 293:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 297:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	01 d0                	add    %edx,%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	84 c0                	test   %al,%al
 2a4:	75 ed                	jne    293 <strlen+0x13>
    ;
  return n;
 2a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ab:	f3 0f 1e fb          	endbr32 
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2b2:	8b 45 10             	mov    0x10(%ebp),%eax
 2b5:	50                   	push   %eax
 2b6:	ff 75 0c             	pushl  0xc(%ebp)
 2b9:	ff 75 08             	pushl  0x8(%ebp)
 2bc:	e8 22 ff ff ff       	call   1e3 <stosb>
 2c1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <strchr>:

char*
strchr(const char *s, char c)
{
 2c9:	f3 0f 1e fb          	endbr32 
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	83 ec 04             	sub    $0x4,%esp
 2d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d9:	eb 14                	jmp    2ef <strchr+0x26>
    if(*s == c)
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2e4:	75 05                	jne    2eb <strchr+0x22>
      return (char*)s;
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	eb 13                	jmp    2fe <strchr+0x35>
  for(; *s; s++)
 2eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	0f b6 00             	movzbl (%eax),%eax
 2f5:	84 c0                	test   %al,%al
 2f7:	75 e2                	jne    2db <strchr+0x12>
  return 0;
 2f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2fe:	c9                   	leave  
 2ff:	c3                   	ret    

00000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 311:	eb 42                	jmp    355 <gets+0x55>
    cc = read(0, &c, 1);
 313:	83 ec 04             	sub    $0x4,%esp
 316:	6a 01                	push   $0x1
 318:	8d 45 ef             	lea    -0x11(%ebp),%eax
 31b:	50                   	push   %eax
 31c:	6a 00                	push   $0x0
 31e:	e8 a1 01 00 00       	call   4c4 <read>
 323:	83 c4 10             	add    $0x10,%esp
 326:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 329:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 32d:	7e 33                	jle    362 <gets+0x62>
      break;
    buf[i++] = c;
 32f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 332:	8d 50 01             	lea    0x1(%eax),%edx
 335:	89 55 f4             	mov    %edx,-0xc(%ebp)
 338:	89 c2                	mov    %eax,%edx
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	01 c2                	add    %eax,%edx
 33f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 343:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 345:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 349:	3c 0a                	cmp    $0xa,%al
 34b:	74 16                	je     363 <gets+0x63>
 34d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 351:	3c 0d                	cmp    $0xd,%al
 353:	74 0e                	je     363 <gets+0x63>
  for(i=0; i+1 < max; ){
 355:	8b 45 f4             	mov    -0xc(%ebp),%eax
 358:	83 c0 01             	add    $0x1,%eax
 35b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 35e:	7f b3                	jg     313 <gets+0x13>
 360:	eb 01                	jmp    363 <gets+0x63>
      break;
 362:	90                   	nop
      break;
  }
  buf[i] = '\0';
 363:	8b 55 f4             	mov    -0xc(%ebp),%edx
 366:	8b 45 08             	mov    0x8(%ebp),%eax
 369:	01 d0                	add    %edx,%eax
 36b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 36e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 371:	c9                   	leave  
 372:	c3                   	ret    

00000373 <stat>:

int
stat(const char *n, struct stat *st)
{
 373:	f3 0f 1e fb          	endbr32 
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37d:	83 ec 08             	sub    $0x8,%esp
 380:	6a 00                	push   $0x0
 382:	ff 75 08             	pushl  0x8(%ebp)
 385:	e8 62 01 00 00       	call   4ec <open>
 38a:	83 c4 10             	add    $0x10,%esp
 38d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 394:	79 07                	jns    39d <stat+0x2a>
    return -1;
 396:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 39b:	eb 25                	jmp    3c2 <stat+0x4f>
  r = fstat(fd, st);
 39d:	83 ec 08             	sub    $0x8,%esp
 3a0:	ff 75 0c             	pushl  0xc(%ebp)
 3a3:	ff 75 f4             	pushl  -0xc(%ebp)
 3a6:	e8 59 01 00 00       	call   504 <fstat>
 3ab:	83 c4 10             	add    $0x10,%esp
 3ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3b1:	83 ec 0c             	sub    $0xc,%esp
 3b4:	ff 75 f4             	pushl  -0xc(%ebp)
 3b7:	e8 18 01 00 00       	call   4d4 <close>
 3bc:	83 c4 10             	add    $0x10,%esp
  return r;
 3bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3c2:	c9                   	leave  
 3c3:	c3                   	ret    

000003c4 <atoi>:



int
atoi(const char *s)
{
 3c4:	f3 0f 1e fb          	endbr32 
 3c8:	55                   	push   %ebp
 3c9:	89 e5                	mov    %esp,%ebp
 3cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	0f b6 00             	movzbl (%eax),%eax
 3db:	3c 2d                	cmp    $0x2d,%al
 3dd:	75 6b                	jne    44a <atoi+0x86>
  {
    s++;
 3df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 3e3:	eb 25                	jmp    40a <atoi+0x46>
        n = n*10 + *s++ - '0';
 3e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e8:	89 d0                	mov    %edx,%eax
 3ea:	c1 e0 02             	shl    $0x2,%eax
 3ed:	01 d0                	add    %edx,%eax
 3ef:	01 c0                	add    %eax,%eax
 3f1:	89 c1                	mov    %eax,%ecx
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	8d 50 01             	lea    0x1(%eax),%edx
 3f9:	89 55 08             	mov    %edx,0x8(%ebp)
 3fc:	0f b6 00             	movzbl (%eax),%eax
 3ff:	0f be c0             	movsbl %al,%eax
 402:	01 c8                	add    %ecx,%eax
 404:	83 e8 30             	sub    $0x30,%eax
 407:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	0f b6 00             	movzbl (%eax),%eax
 410:	3c 2f                	cmp    $0x2f,%al
 412:	7e 0a                	jle    41e <atoi+0x5a>
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	0f b6 00             	movzbl (%eax),%eax
 41a:	3c 39                	cmp    $0x39,%al
 41c:	7e c7                	jle    3e5 <atoi+0x21>

    return -n;
 41e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 421:	f7 d8                	neg    %eax
 423:	eb 3c                	jmp    461 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 425:	8b 55 fc             	mov    -0x4(%ebp),%edx
 428:	89 d0                	mov    %edx,%eax
 42a:	c1 e0 02             	shl    $0x2,%eax
 42d:	01 d0                	add    %edx,%eax
 42f:	01 c0                	add    %eax,%eax
 431:	89 c1                	mov    %eax,%ecx
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	8d 50 01             	lea    0x1(%eax),%edx
 439:	89 55 08             	mov    %edx,0x8(%ebp)
 43c:	0f b6 00             	movzbl (%eax),%eax
 43f:	0f be c0             	movsbl %al,%eax
 442:	01 c8                	add    %ecx,%eax
 444:	83 e8 30             	sub    $0x30,%eax
 447:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	0f b6 00             	movzbl (%eax),%eax
 450:	3c 2f                	cmp    $0x2f,%al
 452:	7e 0a                	jle    45e <atoi+0x9a>
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	0f b6 00             	movzbl (%eax),%eax
 45a:	3c 39                	cmp    $0x39,%al
 45c:	7e c7                	jle    425 <atoi+0x61>

    return n;
 45e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 461:	c9                   	leave  
 462:	c3                   	ret    

00000463 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 463:	f3 0f 1e fb          	endbr32 
 467:	55                   	push   %ebp
 468:	89 e5                	mov    %esp,%ebp
 46a:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 473:	8b 45 0c             	mov    0xc(%ebp),%eax
 476:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 479:	eb 17                	jmp    492 <memmove+0x2f>
    *dst++ = *src++;
 47b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 47e:	8d 42 01             	lea    0x1(%edx),%eax
 481:	89 45 f8             	mov    %eax,-0x8(%ebp)
 484:	8b 45 fc             	mov    -0x4(%ebp),%eax
 487:	8d 48 01             	lea    0x1(%eax),%ecx
 48a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 48d:	0f b6 12             	movzbl (%edx),%edx
 490:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 492:	8b 45 10             	mov    0x10(%ebp),%eax
 495:	8d 50 ff             	lea    -0x1(%eax),%edx
 498:	89 55 10             	mov    %edx,0x10(%ebp)
 49b:	85 c0                	test   %eax,%eax
 49d:	7f dc                	jg     47b <memmove+0x18>
  return vdst;
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4a4:	b8 01 00 00 00       	mov    $0x1,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <exit>:
SYSCALL(exit)
 4ac:	b8 02 00 00 00       	mov    $0x2,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <wait>:
SYSCALL(wait)
 4b4:	b8 03 00 00 00       	mov    $0x3,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <pipe>:
SYSCALL(pipe)
 4bc:	b8 04 00 00 00       	mov    $0x4,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <read>:
SYSCALL(read)
 4c4:	b8 05 00 00 00       	mov    $0x5,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <write>:
SYSCALL(write)
 4cc:	b8 10 00 00 00       	mov    $0x10,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <close>:
SYSCALL(close)
 4d4:	b8 15 00 00 00       	mov    $0x15,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <kill>:
SYSCALL(kill)
 4dc:	b8 06 00 00 00       	mov    $0x6,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <exec>:
SYSCALL(exec)
 4e4:	b8 07 00 00 00       	mov    $0x7,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <open>:
SYSCALL(open)
 4ec:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <mknod>:
SYSCALL(mknod)
 4f4:	b8 11 00 00 00       	mov    $0x11,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <unlink>:
SYSCALL(unlink)
 4fc:	b8 12 00 00 00       	mov    $0x12,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <fstat>:
SYSCALL(fstat)
 504:	b8 08 00 00 00       	mov    $0x8,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <link>:
SYSCALL(link)
 50c:	b8 13 00 00 00       	mov    $0x13,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <mkdir>:
SYSCALL(mkdir)
 514:	b8 14 00 00 00       	mov    $0x14,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <chdir>:
SYSCALL(chdir)
 51c:	b8 09 00 00 00       	mov    $0x9,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <dup>:
SYSCALL(dup)
 524:	b8 0a 00 00 00       	mov    $0xa,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <getpid>:
SYSCALL(getpid)
 52c:	b8 0b 00 00 00       	mov    $0xb,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <sbrk>:
SYSCALL(sbrk)
 534:	b8 0c 00 00 00       	mov    $0xc,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <sleep>:
SYSCALL(sleep)
 53c:	b8 0d 00 00 00       	mov    $0xd,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <uptime>:
SYSCALL(uptime)
 544:	b8 0e 00 00 00       	mov    $0xe,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <lseek>:
SYSCALL(lseek)
 54c:	b8 16 00 00 00       	mov    $0x16,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 554:	f3 0f 1e fb          	endbr32 
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	83 ec 18             	sub    $0x18,%esp
 55e:	8b 45 0c             	mov    0xc(%ebp),%eax
 561:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 564:	83 ec 04             	sub    $0x4,%esp
 567:	6a 01                	push   $0x1
 569:	8d 45 f4             	lea    -0xc(%ebp),%eax
 56c:	50                   	push   %eax
 56d:	ff 75 08             	pushl  0x8(%ebp)
 570:	e8 57 ff ff ff       	call   4cc <write>
 575:	83 c4 10             	add    $0x10,%esp
}
 578:	90                   	nop
 579:	c9                   	leave  
 57a:	c3                   	ret    

0000057b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57b:	f3 0f 1e fb          	endbr32 
 57f:	55                   	push   %ebp
 580:	89 e5                	mov    %esp,%ebp
 582:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 58c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 590:	74 17                	je     5a9 <printint+0x2e>
 592:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 596:	79 11                	jns    5a9 <printint+0x2e>
    neg = 1;
 598:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 59f:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a2:	f7 d8                	neg    %eax
 5a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a7:	eb 06                	jmp    5af <printint+0x34>
  } else {
    x = xx;
 5a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bc:	ba 00 00 00 00       	mov    $0x0,%edx
 5c1:	f7 f1                	div    %ecx
 5c3:	89 d1                	mov    %edx,%ecx
 5c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c8:	8d 50 01             	lea    0x1(%eax),%edx
 5cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ce:	0f b6 91 d4 0c 00 00 	movzbl 0xcd4(%ecx),%edx
 5d5:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5df:	ba 00 00 00 00       	mov    $0x0,%edx
 5e4:	f7 f1                	div    %ecx
 5e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ed:	75 c7                	jne    5b6 <printint+0x3b>
  if(neg)
 5ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f3:	74 2d                	je     622 <printint+0xa7>
    buf[i++] = '-';
 5f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f8:	8d 50 01             	lea    0x1(%eax),%edx
 5fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5fe:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 603:	eb 1d                	jmp    622 <printint+0xa7>
    putc(fd, buf[i]);
 605:	8d 55 dc             	lea    -0x24(%ebp),%edx
 608:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60b:	01 d0                	add    %edx,%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 35 ff ff ff       	call   554 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 622:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62a:	79 d9                	jns    605 <printint+0x8a>
}
 62c:	90                   	nop
 62d:	90                   	nop
 62e:	c9                   	leave  
 62f:	c3                   	ret    

00000630 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 630:	f3 0f 1e fb          	endbr32 
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 63a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 641:	8d 45 0c             	lea    0xc(%ebp),%eax
 644:	83 c0 04             	add    $0x4,%eax
 647:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 64a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 651:	e9 59 01 00 00       	jmp    7af <printf+0x17f>
    c = fmt[i] & 0xff;
 656:	8b 55 0c             	mov    0xc(%ebp),%edx
 659:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65c:	01 d0                	add    %edx,%eax
 65e:	0f b6 00             	movzbl (%eax),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	25 ff 00 00 00       	and    $0xff,%eax
 669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 66c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 670:	75 2c                	jne    69e <printf+0x6e>
      if(c == '%'){
 672:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 676:	75 0c                	jne    684 <printf+0x54>
        state = '%';
 678:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 67f:	e9 27 01 00 00       	jmp    7ab <printf+0x17b>
      } else {
        putc(fd, c);
 684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 687:	0f be c0             	movsbl %al,%eax
 68a:	83 ec 08             	sub    $0x8,%esp
 68d:	50                   	push   %eax
 68e:	ff 75 08             	pushl  0x8(%ebp)
 691:	e8 be fe ff ff       	call   554 <putc>
 696:	83 c4 10             	add    $0x10,%esp
 699:	e9 0d 01 00 00       	jmp    7ab <printf+0x17b>
      }
    } else if(state == '%'){
 69e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6a2:	0f 85 03 01 00 00    	jne    7ab <printf+0x17b>
      if(c == 'd'){
 6a8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6ac:	75 1e                	jne    6cc <printf+0x9c>
        printint(fd, *ap, 10, 1);
 6ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	6a 01                	push   $0x1
 6b5:	6a 0a                	push   $0xa
 6b7:	50                   	push   %eax
 6b8:	ff 75 08             	pushl  0x8(%ebp)
 6bb:	e8 bb fe ff ff       	call   57b <printint>
 6c0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c7:	e9 d8 00 00 00       	jmp    7a4 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 6cc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6d0:	74 06                	je     6d8 <printf+0xa8>
 6d2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6d6:	75 1e                	jne    6f6 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 6d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	6a 00                	push   $0x0
 6df:	6a 10                	push   $0x10
 6e1:	50                   	push   %eax
 6e2:	ff 75 08             	pushl  0x8(%ebp)
 6e5:	e8 91 fe ff ff       	call   57b <printint>
 6ea:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f1:	e9 ae 00 00 00       	jmp    7a4 <printf+0x174>
      } else if(c == 's'){
 6f6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6fa:	75 43                	jne    73f <printf+0x10f>
        s = (char*)*ap;
 6fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 704:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 70c:	75 25                	jne    733 <printf+0x103>
          s = "(null)";
 70e:	c7 45 f4 64 0a 00 00 	movl   $0xa64,-0xc(%ebp)
        while(*s != 0){
 715:	eb 1c                	jmp    733 <printf+0x103>
          putc(fd, *s);
 717:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71a:	0f b6 00             	movzbl (%eax),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	83 ec 08             	sub    $0x8,%esp
 723:	50                   	push   %eax
 724:	ff 75 08             	pushl  0x8(%ebp)
 727:	e8 28 fe ff ff       	call   554 <putc>
 72c:	83 c4 10             	add    $0x10,%esp
          s++;
 72f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	0f b6 00             	movzbl (%eax),%eax
 739:	84 c0                	test   %al,%al
 73b:	75 da                	jne    717 <printf+0xe7>
 73d:	eb 65                	jmp    7a4 <printf+0x174>
        }
      } else if(c == 'c'){
 73f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 743:	75 1d                	jne    762 <printf+0x132>
        putc(fd, *ap);
 745:	8b 45 e8             	mov    -0x18(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	0f be c0             	movsbl %al,%eax
 74d:	83 ec 08             	sub    $0x8,%esp
 750:	50                   	push   %eax
 751:	ff 75 08             	pushl  0x8(%ebp)
 754:	e8 fb fd ff ff       	call   554 <putc>
 759:	83 c4 10             	add    $0x10,%esp
        ap++;
 75c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 760:	eb 42                	jmp    7a4 <printf+0x174>
      } else if(c == '%'){
 762:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 766:	75 17                	jne    77f <printf+0x14f>
        putc(fd, c);
 768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76b:	0f be c0             	movsbl %al,%eax
 76e:	83 ec 08             	sub    $0x8,%esp
 771:	50                   	push   %eax
 772:	ff 75 08             	pushl  0x8(%ebp)
 775:	e8 da fd ff ff       	call   554 <putc>
 77a:	83 c4 10             	add    $0x10,%esp
 77d:	eb 25                	jmp    7a4 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 77f:	83 ec 08             	sub    $0x8,%esp
 782:	6a 25                	push   $0x25
 784:	ff 75 08             	pushl  0x8(%ebp)
 787:	e8 c8 fd ff ff       	call   554 <putc>
 78c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 78f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 792:	0f be c0             	movsbl %al,%eax
 795:	83 ec 08             	sub    $0x8,%esp
 798:	50                   	push   %eax
 799:	ff 75 08             	pushl  0x8(%ebp)
 79c:	e8 b3 fd ff ff       	call   554 <putc>
 7a1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7af:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b5:	01 d0                	add    %edx,%eax
 7b7:	0f b6 00             	movzbl (%eax),%eax
 7ba:	84 c0                	test   %al,%al
 7bc:	0f 85 94 fe ff ff    	jne    656 <printf+0x26>
    }
  }
}
 7c2:	90                   	nop
 7c3:	90                   	nop
 7c4:	c9                   	leave  
 7c5:	c3                   	ret    

000007c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c6:	f3 0f 1e fb          	endbr32 
 7ca:	55                   	push   %ebp
 7cb:	89 e5                	mov    %esp,%ebp
 7cd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d0:	8b 45 08             	mov    0x8(%ebp),%eax
 7d3:	83 e8 08             	sub    $0x8,%eax
 7d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d9:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 7de:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e1:	eb 24                	jmp    807 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7eb:	72 12                	jb     7ff <free+0x39>
 7ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f3:	77 24                	ja     819 <free+0x53>
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7fd:	72 1a                	jb     819 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 fc             	mov    %eax,-0x4(%ebp)
 807:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80d:	76 d4                	jbe    7e3 <free+0x1d>
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 817:	73 ca                	jae    7e3 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	8b 40 04             	mov    0x4(%eax),%eax
 81f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	01 c2                	add    %eax,%edx
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	39 c2                	cmp    %eax,%edx
 832:	75 24                	jne    858 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	8b 50 04             	mov    0x4(%eax),%edx
 83a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83d:	8b 00                	mov    (%eax),%eax
 83f:	8b 40 04             	mov    0x4(%eax),%eax
 842:	01 c2                	add    %eax,%edx
 844:	8b 45 f8             	mov    -0x8(%ebp),%eax
 847:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	8b 00                	mov    (%eax),%eax
 84f:	8b 10                	mov    (%eax),%edx
 851:	8b 45 f8             	mov    -0x8(%ebp),%eax
 854:	89 10                	mov    %edx,(%eax)
 856:	eb 0a                	jmp    862 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	8b 10                	mov    (%eax),%edx
 85d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 860:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	8b 40 04             	mov    0x4(%eax),%eax
 868:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	01 d0                	add    %edx,%eax
 874:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 877:	75 20                	jne    899 <free+0xd3>
    p->s.size += bp->s.size;
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	8b 50 04             	mov    0x4(%eax),%edx
 87f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 882:	8b 40 04             	mov    0x4(%eax),%eax
 885:	01 c2                	add    %eax,%edx
 887:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 88d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 890:	8b 10                	mov    (%eax),%edx
 892:	8b 45 fc             	mov    -0x4(%ebp),%eax
 895:	89 10                	mov    %edx,(%eax)
 897:	eb 08                	jmp    8a1 <free+0xdb>
  } else
    p->s.ptr = bp;
 899:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 89f:	89 10                	mov    %edx,(%eax)
  freep = p;
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	a3 f0 0c 00 00       	mov    %eax,0xcf0
}
 8a9:	90                   	nop
 8aa:	c9                   	leave  
 8ab:	c3                   	ret    

000008ac <morecore>:

static Header*
morecore(uint nu)
{
 8ac:	f3 0f 1e fb          	endbr32 
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8b6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8bd:	77 07                	ja     8c6 <morecore+0x1a>
    nu = 4096;
 8bf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8c6:	8b 45 08             	mov    0x8(%ebp),%eax
 8c9:	c1 e0 03             	shl    $0x3,%eax
 8cc:	83 ec 0c             	sub    $0xc,%esp
 8cf:	50                   	push   %eax
 8d0:	e8 5f fc ff ff       	call   534 <sbrk>
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8db:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8df:	75 07                	jne    8e8 <morecore+0x3c>
    return 0;
 8e1:	b8 00 00 00 00       	mov    $0x0,%eax
 8e6:	eb 26                	jmp    90e <morecore+0x62>
  hp = (Header*)p;
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f1:	8b 55 08             	mov    0x8(%ebp),%edx
 8f4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fa:	83 c0 08             	add    $0x8,%eax
 8fd:	83 ec 0c             	sub    $0xc,%esp
 900:	50                   	push   %eax
 901:	e8 c0 fe ff ff       	call   7c6 <free>
 906:	83 c4 10             	add    $0x10,%esp
  return freep;
 909:	a1 f0 0c 00 00       	mov    0xcf0,%eax
}
 90e:	c9                   	leave  
 90f:	c3                   	ret    

00000910 <malloc>:

void*
malloc(uint nbytes)
{
 910:	f3 0f 1e fb          	endbr32 
 914:	55                   	push   %ebp
 915:	89 e5                	mov    %esp,%ebp
 917:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91a:	8b 45 08             	mov    0x8(%ebp),%eax
 91d:	83 c0 07             	add    $0x7,%eax
 920:	c1 e8 03             	shr    $0x3,%eax
 923:	83 c0 01             	add    $0x1,%eax
 926:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 929:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 92e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 931:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 935:	75 23                	jne    95a <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 937:	c7 45 f0 e8 0c 00 00 	movl   $0xce8,-0x10(%ebp)
 93e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 941:	a3 f0 0c 00 00       	mov    %eax,0xcf0
 946:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 94b:	a3 e8 0c 00 00       	mov    %eax,0xce8
    base.s.size = 0;
 950:	c7 05 ec 0c 00 00 00 	movl   $0x0,0xcec
 957:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 96b:	77 4d                	ja     9ba <malloc+0xaa>
      if(p->s.size == nunits)
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8b 40 04             	mov    0x4(%eax),%eax
 973:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 976:	75 0c                	jne    984 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	8b 10                	mov    (%eax),%edx
 97d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 980:	89 10                	mov    %edx,(%eax)
 982:	eb 26                	jmp    9aa <malloc+0x9a>
      else {
        p->s.size -= nunits;
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 98d:	89 c2                	mov    %eax,%edx
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 995:	8b 45 f4             	mov    -0xc(%ebp),%eax
 998:	8b 40 04             	mov    0x4(%eax),%eax
 99b:	c1 e0 03             	shl    $0x3,%eax
 99e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9a7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ad:	a3 f0 0c 00 00       	mov    %eax,0xcf0
      return (void*)(p + 1);
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	83 c0 08             	add    $0x8,%eax
 9b8:	eb 3b                	jmp    9f5 <malloc+0xe5>
    }
    if(p == freep)
 9ba:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 9bf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9c2:	75 1e                	jne    9e2 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 9c4:	83 ec 0c             	sub    $0xc,%esp
 9c7:	ff 75 ec             	pushl  -0x14(%ebp)
 9ca:	e8 dd fe ff ff       	call   8ac <morecore>
 9cf:	83 c4 10             	add    $0x10,%esp
 9d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d9:	75 07                	jne    9e2 <malloc+0xd2>
        return 0;
 9db:	b8 00 00 00 00       	mov    $0x0,%eax
 9e0:	eb 13                	jmp    9f5 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	8b 00                	mov    (%eax),%eax
 9ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9f0:	e9 6d ff ff ff       	jmp    962 <malloc+0x52>
  }
}
 9f5:	c9                   	leave  
 9f6:	c3                   	ret    
