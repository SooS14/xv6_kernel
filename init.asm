
_init:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  15:	83 ec 08             	sub    $0x8,%esp
  18:	6a 02                	push   $0x2
  1a:	68 1c 09 00 00       	push   $0x91c
  1f:	e8 ea 03 00 00       	call   40e <open>
  24:	83 c4 10             	add    $0x10,%esp
  27:	85 c0                	test   %eax,%eax
  29:	79 26                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  2b:	83 ec 04             	sub    $0x4,%esp
  2e:	6a 01                	push   $0x1
  30:	6a 01                	push   $0x1
  32:	68 1c 09 00 00       	push   $0x91c
  37:	e8 da 03 00 00       	call   416 <mknod>
  3c:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	6a 02                	push   $0x2
  44:	68 1c 09 00 00       	push   $0x91c
  49:	e8 c0 03 00 00       	call   40e <open>
  4e:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	6a 00                	push   $0x0
  56:	e8 eb 03 00 00       	call   446 <dup>
  5b:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	6a 00                	push   $0x0
  63:	e8 de 03 00 00       	call   446 <dup>
  68:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  6b:	83 ec 08             	sub    $0x8,%esp
  6e:	68 24 09 00 00       	push   $0x924
  73:	6a 01                	push   $0x1
  75:	e8 d8 04 00 00       	call   552 <printf>
  7a:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  7d:	e8 44 03 00 00       	call   3c6 <fork>
  82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  89:	79 17                	jns    a2 <main+0xa2>
      printf(1, "init: fork failed\n");
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 37 09 00 00       	push   $0x937
  93:	6a 01                	push   $0x1
  95:	e8 b8 04 00 00       	call   552 <printf>
  9a:	83 c4 10             	add    $0x10,%esp
      exit();
  9d:	e8 2c 03 00 00       	call   3ce <exit>
    }
    if(pid == 0){
  a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a6:	75 3e                	jne    e6 <main+0xe6>
      exec("sh", argv);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	68 b4 0b 00 00       	push   $0xbb4
  b0:	68 19 09 00 00       	push   $0x919
  b5:	e8 4c 03 00 00       	call   406 <exec>
  ba:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 4a 09 00 00       	push   $0x94a
  c5:	6a 01                	push   $0x1
  c7:	e8 86 04 00 00       	call   552 <printf>
  cc:	83 c4 10             	add    $0x10,%esp
      exit();
  cf:	e8 fa 02 00 00       	call   3ce <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 60 09 00 00       	push   $0x960
  dc:	6a 01                	push   $0x1
  de:	e8 6f 04 00 00       	call   552 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  e6:	e8 eb 02 00 00       	call   3d6 <wait>
  eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f2:	0f 88 73 ff ff ff    	js     6b <main+0x6b>
  f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fe:	75 d4                	jne    d4 <main+0xd4>
    printf(1, "init: starting sh\n");
 100:	e9 66 ff ff ff       	jmp    6b <main+0x6b>

00000105 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	57                   	push   %edi
 109:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10d:	8b 55 10             	mov    0x10(%ebp),%edx
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	89 cb                	mov    %ecx,%ebx
 115:	89 df                	mov    %ebx,%edi
 117:	89 d1                	mov    %edx,%ecx
 119:	fc                   	cld    
 11a:	f3 aa                	rep stos %al,%es:(%edi)
 11c:	89 ca                	mov    %ecx,%edx
 11e:	89 fb                	mov    %edi,%ebx
 120:	89 5d 08             	mov    %ebx,0x8(%ebp)
 123:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 126:	90                   	nop
 127:	5b                   	pop    %ebx
 128:	5f                   	pop    %edi
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    

0000012b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 12b:	f3 0f 1e fb          	endbr32 
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13b:	90                   	nop
 13c:	8b 55 0c             	mov    0xc(%ebp),%edx
 13f:	8d 42 01             	lea    0x1(%edx),%eax
 142:	89 45 0c             	mov    %eax,0xc(%ebp)
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	8d 48 01             	lea    0x1(%eax),%ecx
 14b:	89 4d 08             	mov    %ecx,0x8(%ebp)
 14e:	0f b6 12             	movzbl (%edx),%edx
 151:	88 10                	mov    %dl,(%eax)
 153:	0f b6 00             	movzbl (%eax),%eax
 156:	84 c0                	test   %al,%al
 158:	75 e2                	jne    13c <strcpy+0x11>
    ;
  return os;
 15a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15f:	f3 0f 1e fb          	endbr32 
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 166:	eb 08                	jmp    170 <strcmp+0x11>
    p++, q++;
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	84 c0                	test   %al,%al
 178:	74 10                	je     18a <strcmp+0x2b>
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 10             	movzbl (%eax),%edx
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	38 c2                	cmp    %al,%dl
 188:	74 de                	je     168 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	0f b6 d0             	movzbl %al,%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	0f b6 c0             	movzbl %al,%eax
 19c:	29 c2                	sub    %eax,%edx
 19e:	89 d0                	mov    %edx,%eax
}
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    

000001a2 <strlen>:

uint
strlen(const char *s)
{
 1a2:	f3 0f 1e fb          	endbr32 
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b3:	eb 04                	jmp    1b9 <strlen+0x17>
 1b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	01 d0                	add    %edx,%eax
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	84 c0                	test   %al,%al
 1c6:	75 ed                	jne    1b5 <strlen+0x13>
    ;
  return n;
 1c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cd:	f3 0f 1e fb          	endbr32 
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1d4:	8b 45 10             	mov    0x10(%ebp),%eax
 1d7:	50                   	push   %eax
 1d8:	ff 75 0c             	pushl  0xc(%ebp)
 1db:	ff 75 08             	pushl  0x8(%ebp)
 1de:	e8 22 ff ff ff       	call   105 <stosb>
 1e3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <strchr>:

char*
strchr(const char *s, char c)
{
 1eb:	f3 0f 1e fb          	endbr32 
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 04             	sub    $0x4,%esp
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fb:	eb 14                	jmp    211 <strchr+0x26>
    if(*s == c)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	38 45 fc             	cmp    %al,-0x4(%ebp)
 206:	75 05                	jne    20d <strchr+0x22>
      return (char*)s;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	eb 13                	jmp    220 <strchr+0x35>
  for(; *s; s++)
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 e2                	jne    1fd <strchr+0x12>
  return 0;
 21b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	f3 0f 1e fb          	endbr32 
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 233:	eb 42                	jmp    277 <gets+0x55>
    cc = read(0, &c, 1);
 235:	83 ec 04             	sub    $0x4,%esp
 238:	6a 01                	push   $0x1
 23a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23d:	50                   	push   %eax
 23e:	6a 00                	push   $0x0
 240:	e8 a1 01 00 00       	call   3e6 <read>
 245:	83 c4 10             	add    $0x10,%esp
 248:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24f:	7e 33                	jle    284 <gets+0x62>
      break;
    buf[i++] = c;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	8d 50 01             	lea    0x1(%eax),%edx
 257:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	01 c2                	add    %eax,%edx
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	3c 0a                	cmp    $0xa,%al
 26d:	74 16                	je     285 <gets+0x63>
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	3c 0d                	cmp    $0xd,%al
 275:	74 0e                	je     285 <gets+0x63>
  for(i=0; i+1 < max; ){
 277:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27a:	83 c0 01             	add    $0x1,%eax
 27d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 280:	7f b3                	jg     235 <gets+0x13>
 282:	eb 01                	jmp    285 <gets+0x63>
      break;
 284:	90                   	nop
      break;
  }
  buf[i] = '\0';
 285:	8b 55 f4             	mov    -0xc(%ebp),%edx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <stat>:

int
stat(const char *n, struct stat *st)
{
 295:	f3 0f 1e fb          	endbr32 
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	6a 00                	push   $0x0
 2a4:	ff 75 08             	pushl  0x8(%ebp)
 2a7:	e8 62 01 00 00       	call   40e <open>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b6:	79 07                	jns    2bf <stat+0x2a>
    return -1;
 2b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bd:	eb 25                	jmp    2e4 <stat+0x4f>
  r = fstat(fd, st);
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	ff 75 0c             	pushl  0xc(%ebp)
 2c5:	ff 75 f4             	pushl  -0xc(%ebp)
 2c8:	e8 59 01 00 00       	call   426 <fstat>
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d3:	83 ec 0c             	sub    $0xc,%esp
 2d6:	ff 75 f4             	pushl  -0xc(%ebp)
 2d9:	e8 18 01 00 00       	call   3f6 <close>
 2de:	83 c4 10             	add    $0x10,%esp
  return r;
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:



int
atoi(const char *s)
{
 2e6:	f3 0f 1e fb          	endbr32 
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	3c 2d                	cmp    $0x2d,%al
 2ff:	75 6b                	jne    36c <atoi+0x86>
  {
    s++;
 301:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 305:	eb 25                	jmp    32c <atoi+0x46>
        n = n*10 + *s++ - '0';
 307:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30a:	89 d0                	mov    %edx,%eax
 30c:	c1 e0 02             	shl    $0x2,%eax
 30f:	01 d0                	add    %edx,%eax
 311:	01 c0                	add    %eax,%eax
 313:	89 c1                	mov    %eax,%ecx
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 08             	mov    %edx,0x8(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	01 c8                	add    %ecx,%eax
 326:	83 e8 30             	sub    $0x30,%eax
 329:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	3c 2f                	cmp    $0x2f,%al
 334:	7e 0a                	jle    340 <atoi+0x5a>
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	3c 39                	cmp    $0x39,%al
 33e:	7e c7                	jle    307 <atoi+0x21>

    return -n;
 340:	8b 45 fc             	mov    -0x4(%ebp),%eax
 343:	f7 d8                	neg    %eax
 345:	eb 3c                	jmp    383 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 347:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34a:	89 d0                	mov    %edx,%eax
 34c:	c1 e0 02             	shl    $0x2,%eax
 34f:	01 d0                	add    %edx,%eax
 351:	01 c0                	add    %eax,%eax
 353:	89 c1                	mov    %eax,%ecx
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	8d 50 01             	lea    0x1(%eax),%edx
 35b:	89 55 08             	mov    %edx,0x8(%ebp)
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	0f be c0             	movsbl %al,%eax
 364:	01 c8                	add    %ecx,%eax
 366:	83 e8 30             	sub    $0x30,%eax
 369:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	0f b6 00             	movzbl (%eax),%eax
 372:	3c 2f                	cmp    $0x2f,%al
 374:	7e 0a                	jle    380 <atoi+0x9a>
 376:	8b 45 08             	mov    0x8(%ebp),%eax
 379:	0f b6 00             	movzbl (%eax),%eax
 37c:	3c 39                	cmp    $0x39,%al
 37e:	7e c7                	jle    347 <atoi+0x61>

    return n;
 380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 383:	c9                   	leave  
 384:	c3                   	ret    

00000385 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 385:	f3 0f 1e fb          	endbr32 
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 39b:	eb 17                	jmp    3b4 <memmove+0x2f>
    *dst++ = *src++;
 39d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a0:	8d 42 01             	lea    0x1(%edx),%eax
 3a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a9:	8d 48 01             	lea    0x1(%eax),%ecx
 3ac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3af:	0f b6 12             	movzbl (%edx),%edx
 3b2:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3b4:	8b 45 10             	mov    0x10(%ebp),%eax
 3b7:	8d 50 ff             	lea    -0x1(%eax),%edx
 3ba:	89 55 10             	mov    %edx,0x10(%ebp)
 3bd:	85 c0                	test   %eax,%eax
 3bf:	7f dc                	jg     39d <memmove+0x18>
  return vdst;
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c6:	b8 01 00 00 00       	mov    $0x1,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <exit>:
SYSCALL(exit)
 3ce:	b8 02 00 00 00       	mov    $0x2,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <wait>:
SYSCALL(wait)
 3d6:	b8 03 00 00 00       	mov    $0x3,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <pipe>:
SYSCALL(pipe)
 3de:	b8 04 00 00 00       	mov    $0x4,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <read>:
SYSCALL(read)
 3e6:	b8 05 00 00 00       	mov    $0x5,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <write>:
SYSCALL(write)
 3ee:	b8 10 00 00 00       	mov    $0x10,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <close>:
SYSCALL(close)
 3f6:	b8 15 00 00 00       	mov    $0x15,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <kill>:
SYSCALL(kill)
 3fe:	b8 06 00 00 00       	mov    $0x6,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <exec>:
SYSCALL(exec)
 406:	b8 07 00 00 00       	mov    $0x7,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <open>:
SYSCALL(open)
 40e:	b8 0f 00 00 00       	mov    $0xf,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <mknod>:
SYSCALL(mknod)
 416:	b8 11 00 00 00       	mov    $0x11,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <unlink>:
SYSCALL(unlink)
 41e:	b8 12 00 00 00       	mov    $0x12,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <fstat>:
SYSCALL(fstat)
 426:	b8 08 00 00 00       	mov    $0x8,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <link>:
SYSCALL(link)
 42e:	b8 13 00 00 00       	mov    $0x13,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <mkdir>:
SYSCALL(mkdir)
 436:	b8 14 00 00 00       	mov    $0x14,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <chdir>:
SYSCALL(chdir)
 43e:	b8 09 00 00 00       	mov    $0x9,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <dup>:
SYSCALL(dup)
 446:	b8 0a 00 00 00       	mov    $0xa,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <getpid>:
SYSCALL(getpid)
 44e:	b8 0b 00 00 00       	mov    $0xb,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <sbrk>:
SYSCALL(sbrk)
 456:	b8 0c 00 00 00       	mov    $0xc,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <sleep>:
SYSCALL(sleep)
 45e:	b8 0d 00 00 00       	mov    $0xd,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <uptime>:
SYSCALL(uptime)
 466:	b8 0e 00 00 00       	mov    $0xe,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <lseek>:
SYSCALL(lseek)
 46e:	b8 16 00 00 00       	mov    $0x16,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 476:	f3 0f 1e fb          	endbr32 
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	83 ec 18             	sub    $0x18,%esp
 480:	8b 45 0c             	mov    0xc(%ebp),%eax
 483:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 486:	83 ec 04             	sub    $0x4,%esp
 489:	6a 01                	push   $0x1
 48b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 48e:	50                   	push   %eax
 48f:	ff 75 08             	pushl  0x8(%ebp)
 492:	e8 57 ff ff ff       	call   3ee <write>
 497:	83 c4 10             	add    $0x10,%esp
}
 49a:	90                   	nop
 49b:	c9                   	leave  
 49c:	c3                   	ret    

0000049d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49d:	f3 0f 1e fb          	endbr32 
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ae:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b2:	74 17                	je     4cb <printint+0x2e>
 4b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b8:	79 11                	jns    4cb <printint+0x2e>
    neg = 1;
 4ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c4:	f7 d8                	neg    %eax
 4c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c9:	eb 06                	jmp    4d1 <printint+0x34>
  } else {
    x = xx;
 4cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4de:	ba 00 00 00 00       	mov    $0x0,%edx
 4e3:	f7 f1                	div    %ecx
 4e5:	89 d1                	mov    %edx,%ecx
 4e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ea:	8d 50 01             	lea    0x1(%eax),%edx
 4ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f0:	0f b6 91 bc 0b 00 00 	movzbl 0xbbc(%ecx),%edx
 4f7:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 501:	ba 00 00 00 00       	mov    $0x0,%edx
 506:	f7 f1                	div    %ecx
 508:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50f:	75 c7                	jne    4d8 <printint+0x3b>
  if(neg)
 511:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 515:	74 2d                	je     544 <printint+0xa7>
    buf[i++] = '-';
 517:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51a:	8d 50 01             	lea    0x1(%eax),%edx
 51d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 520:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 525:	eb 1d                	jmp    544 <printint+0xa7>
    putc(fd, buf[i]);
 527:	8d 55 dc             	lea    -0x24(%ebp),%edx
 52a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52d:	01 d0                	add    %edx,%eax
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	83 ec 08             	sub    $0x8,%esp
 538:	50                   	push   %eax
 539:	ff 75 08             	pushl  0x8(%ebp)
 53c:	e8 35 ff ff ff       	call   476 <putc>
 541:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 544:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54c:	79 d9                	jns    527 <printint+0x8a>
}
 54e:	90                   	nop
 54f:	90                   	nop
 550:	c9                   	leave  
 551:	c3                   	ret    

00000552 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 552:	f3 0f 1e fb          	endbr32 
 556:	55                   	push   %ebp
 557:	89 e5                	mov    %esp,%ebp
 559:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 55c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 563:	8d 45 0c             	lea    0xc(%ebp),%eax
 566:	83 c0 04             	add    $0x4,%eax
 569:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 56c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 573:	e9 59 01 00 00       	jmp    6d1 <printf+0x17f>
    c = fmt[i] & 0xff;
 578:	8b 55 0c             	mov    0xc(%ebp),%edx
 57b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57e:	01 d0                	add    %edx,%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	25 ff 00 00 00       	and    $0xff,%eax
 58b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 592:	75 2c                	jne    5c0 <printf+0x6e>
      if(c == '%'){
 594:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 598:	75 0c                	jne    5a6 <printf+0x54>
        state = '%';
 59a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a1:	e9 27 01 00 00       	jmp    6cd <printf+0x17b>
      } else {
        putc(fd, c);
 5a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	83 ec 08             	sub    $0x8,%esp
 5af:	50                   	push   %eax
 5b0:	ff 75 08             	pushl  0x8(%ebp)
 5b3:	e8 be fe ff ff       	call   476 <putc>
 5b8:	83 c4 10             	add    $0x10,%esp
 5bb:	e9 0d 01 00 00       	jmp    6cd <printf+0x17b>
      }
    } else if(state == '%'){
 5c0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c4:	0f 85 03 01 00 00    	jne    6cd <printf+0x17b>
      if(c == 'd'){
 5ca:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ce:	75 1e                	jne    5ee <printf+0x9c>
        printint(fd, *ap, 10, 1);
 5d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d3:	8b 00                	mov    (%eax),%eax
 5d5:	6a 01                	push   $0x1
 5d7:	6a 0a                	push   $0xa
 5d9:	50                   	push   %eax
 5da:	ff 75 08             	pushl  0x8(%ebp)
 5dd:	e8 bb fe ff ff       	call   49d <printint>
 5e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e9:	e9 d8 00 00 00       	jmp    6c6 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 5ee:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5f2:	74 06                	je     5fa <printf+0xa8>
 5f4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f8:	75 1e                	jne    618 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 5fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fd:	8b 00                	mov    (%eax),%eax
 5ff:	6a 00                	push   $0x0
 601:	6a 10                	push   $0x10
 603:	50                   	push   %eax
 604:	ff 75 08             	pushl  0x8(%ebp)
 607:	e8 91 fe ff ff       	call   49d <printint>
 60c:	83 c4 10             	add    $0x10,%esp
        ap++;
 60f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 613:	e9 ae 00 00 00       	jmp    6c6 <printf+0x174>
      } else if(c == 's'){
 618:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 61c:	75 43                	jne    661 <printf+0x10f>
        s = (char*)*ap;
 61e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 626:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 62a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62e:	75 25                	jne    655 <printf+0x103>
          s = "(null)";
 630:	c7 45 f4 69 09 00 00 	movl   $0x969,-0xc(%ebp)
        while(*s != 0){
 637:	eb 1c                	jmp    655 <printf+0x103>
          putc(fd, *s);
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	0f b6 00             	movzbl (%eax),%eax
 63f:	0f be c0             	movsbl %al,%eax
 642:	83 ec 08             	sub    $0x8,%esp
 645:	50                   	push   %eax
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 28 fe ff ff       	call   476 <putc>
 64e:	83 c4 10             	add    $0x10,%esp
          s++;
 651:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 655:	8b 45 f4             	mov    -0xc(%ebp),%eax
 658:	0f b6 00             	movzbl (%eax),%eax
 65b:	84 c0                	test   %al,%al
 65d:	75 da                	jne    639 <printf+0xe7>
 65f:	eb 65                	jmp    6c6 <printf+0x174>
        }
      } else if(c == 'c'){
 661:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 665:	75 1d                	jne    684 <printf+0x132>
        putc(fd, *ap);
 667:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	83 ec 08             	sub    $0x8,%esp
 672:	50                   	push   %eax
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 fb fd ff ff       	call   476 <putc>
 67b:	83 c4 10             	add    $0x10,%esp
        ap++;
 67e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 682:	eb 42                	jmp    6c6 <printf+0x174>
      } else if(c == '%'){
 684:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 688:	75 17                	jne    6a1 <printf+0x14f>
        putc(fd, c);
 68a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68d:	0f be c0             	movsbl %al,%eax
 690:	83 ec 08             	sub    $0x8,%esp
 693:	50                   	push   %eax
 694:	ff 75 08             	pushl  0x8(%ebp)
 697:	e8 da fd ff ff       	call   476 <putc>
 69c:	83 c4 10             	add    $0x10,%esp
 69f:	eb 25                	jmp    6c6 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a1:	83 ec 08             	sub    $0x8,%esp
 6a4:	6a 25                	push   $0x25
 6a6:	ff 75 08             	pushl  0x8(%ebp)
 6a9:	e8 c8 fd ff ff       	call   476 <putc>
 6ae:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b4:	0f be c0             	movsbl %al,%eax
 6b7:	83 ec 08             	sub    $0x8,%esp
 6ba:	50                   	push   %eax
 6bb:	ff 75 08             	pushl  0x8(%ebp)
 6be:	e8 b3 fd ff ff       	call   476 <putc>
 6c3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6cd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d7:	01 d0                	add    %edx,%eax
 6d9:	0f b6 00             	movzbl (%eax),%eax
 6dc:	84 c0                	test   %al,%al
 6de:	0f 85 94 fe ff ff    	jne    578 <printf+0x26>
    }
  }
}
 6e4:	90                   	nop
 6e5:	90                   	nop
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    

000006e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e8:	f3 0f 1e fb          	endbr32 
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f2:	8b 45 08             	mov    0x8(%ebp),%eax
 6f5:	83 e8 08             	sub    $0x8,%eax
 6f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fb:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 700:	89 45 fc             	mov    %eax,-0x4(%ebp)
 703:	eb 24                	jmp    729 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 70d:	72 12                	jb     721 <free+0x39>
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 715:	77 24                	ja     73b <free+0x53>
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 00                	mov    (%eax),%eax
 71c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 71f:	72 1a                	jb     73b <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	89 45 fc             	mov    %eax,-0x4(%ebp)
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72f:	76 d4                	jbe    705 <free+0x1d>
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 739:	73 ca                	jae    705 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	8b 40 04             	mov    0x4(%eax),%eax
 741:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 748:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74b:	01 c2                	add    %eax,%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	39 c2                	cmp    %eax,%edx
 754:	75 24                	jne    77a <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	8b 50 04             	mov    0x4(%eax),%edx
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	8b 40 04             	mov    0x4(%eax),%eax
 764:	01 c2                	add    %eax,%edx
 766:	8b 45 f8             	mov    -0x8(%ebp),%eax
 769:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76f:	8b 00                	mov    (%eax),%eax
 771:	8b 10                	mov    (%eax),%edx
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	89 10                	mov    %edx,(%eax)
 778:	eb 0a                	jmp    784 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 10                	mov    (%eax),%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	01 d0                	add    %edx,%eax
 796:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 799:	75 20                	jne    7bb <free+0xd3>
    p->s.size += bp->s.size;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 50 04             	mov    0x4(%eax),%edx
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	01 c2                	add    %eax,%edx
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b2:	8b 10                	mov    (%eax),%edx
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	89 10                	mov    %edx,(%eax)
 7b9:	eb 08                	jmp    7c3 <free+0xdb>
  } else
    p->s.ptr = bp;
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	a3 d8 0b 00 00       	mov    %eax,0xbd8
}
 7cb:	90                   	nop
 7cc:	c9                   	leave  
 7cd:	c3                   	ret    

000007ce <morecore>:

static Header*
morecore(uint nu)
{
 7ce:	f3 0f 1e fb          	endbr32 
 7d2:	55                   	push   %ebp
 7d3:	89 e5                	mov    %esp,%ebp
 7d5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7df:	77 07                	ja     7e8 <morecore+0x1a>
    nu = 4096;
 7e1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e8:	8b 45 08             	mov    0x8(%ebp),%eax
 7eb:	c1 e0 03             	shl    $0x3,%eax
 7ee:	83 ec 0c             	sub    $0xc,%esp
 7f1:	50                   	push   %eax
 7f2:	e8 5f fc ff ff       	call   456 <sbrk>
 7f7:	83 c4 10             	add    $0x10,%esp
 7fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7fd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 801:	75 07                	jne    80a <morecore+0x3c>
    return 0;
 803:	b8 00 00 00 00       	mov    $0x0,%eax
 808:	eb 26                	jmp    830 <morecore+0x62>
  hp = (Header*)p;
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	8b 55 08             	mov    0x8(%ebp),%edx
 816:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	83 c0 08             	add    $0x8,%eax
 81f:	83 ec 0c             	sub    $0xc,%esp
 822:	50                   	push   %eax
 823:	e8 c0 fe ff ff       	call   6e8 <free>
 828:	83 c4 10             	add    $0x10,%esp
  return freep;
 82b:	a1 d8 0b 00 00       	mov    0xbd8,%eax
}
 830:	c9                   	leave  
 831:	c3                   	ret    

00000832 <malloc>:

void*
malloc(uint nbytes)
{
 832:	f3 0f 1e fb          	endbr32 
 836:	55                   	push   %ebp
 837:	89 e5                	mov    %esp,%ebp
 839:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83c:	8b 45 08             	mov    0x8(%ebp),%eax
 83f:	83 c0 07             	add    $0x7,%eax
 842:	c1 e8 03             	shr    $0x3,%eax
 845:	83 c0 01             	add    $0x1,%eax
 848:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 84b:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 850:	89 45 f0             	mov    %eax,-0x10(%ebp)
 853:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 857:	75 23                	jne    87c <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 859:	c7 45 f0 d0 0b 00 00 	movl   $0xbd0,-0x10(%ebp)
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	a3 d8 0b 00 00       	mov    %eax,0xbd8
 868:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 86d:	a3 d0 0b 00 00       	mov    %eax,0xbd0
    base.s.size = 0;
 872:	c7 05 d4 0b 00 00 00 	movl   $0x0,0xbd4
 879:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	8b 40 04             	mov    0x4(%eax),%eax
 88a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 88d:	77 4d                	ja     8dc <malloc+0xaa>
      if(p->s.size == nunits)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 898:	75 0c                	jne    8a6 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 10                	mov    (%eax),%edx
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	89 10                	mov    %edx,(%eax)
 8a4:	eb 26                	jmp    8cc <malloc+0x9a>
      else {
        p->s.size -= nunits;
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8b 40 04             	mov    0x4(%eax),%eax
 8ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8af:	89 c2                	mov    %eax,%edx
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	c1 e0 03             	shl    $0x3,%eax
 8c0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cf:	a3 d8 0b 00 00       	mov    %eax,0xbd8
      return (void*)(p + 1);
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	83 c0 08             	add    $0x8,%eax
 8da:	eb 3b                	jmp    917 <malloc+0xe5>
    }
    if(p == freep)
 8dc:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 8e1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e4:	75 1e                	jne    904 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 8e6:	83 ec 0c             	sub    $0xc,%esp
 8e9:	ff 75 ec             	pushl  -0x14(%ebp)
 8ec:	e8 dd fe ff ff       	call   7ce <morecore>
 8f1:	83 c4 10             	add    $0x10,%esp
 8f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8fb:	75 07                	jne    904 <malloc+0xd2>
        return 0;
 8fd:	b8 00 00 00 00       	mov    $0x0,%eax
 902:	eb 13                	jmp    917 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 912:	e9 6d ff ff ff       	jmp    884 <malloc+0x52>
  }
}
 917:	c9                   	leave  
 918:	c3                   	ret    
