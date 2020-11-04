
_stressfs:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  18:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1f:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  26:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 6a 09 00 00       	push   $0x96a
  34:	6a 01                	push   $0x1
  36:	e8 68 05 00 00       	call   5a3 <printf>
  3b:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3e:	83 ec 04             	sub    $0x4,%esp
  41:	68 00 02 00 00       	push   $0x200
  46:	6a 61                	push   $0x61
  48:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4e:	50                   	push   %eax
  4f:	e8 ca 01 00 00       	call   21e <memset>
  54:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5e:	eb 0d                	jmp    6d <main+0x6d>
    if(fork() > 0)
  60:	e8 b2 03 00 00       	call   417 <fork>
  65:	85 c0                	test   %eax,%eax
  67:	7f 0c                	jg     75 <main+0x75>
  for(i = 0; i < 4; i++)
  69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6d:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  71:	7e ed                	jle    60 <main+0x60>
  73:	eb 01                	jmp    76 <main+0x76>
      break;
  75:	90                   	nop

  printf(1, "write %d\n", i);
  76:	83 ec 04             	sub    $0x4,%esp
  79:	ff 75 f4             	pushl  -0xc(%ebp)
  7c:	68 7d 09 00 00       	push   $0x97d
  81:	6a 01                	push   $0x1
  83:	e8 1b 05 00 00       	call   5a3 <printf>
  88:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  8b:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8f:	89 c2                	mov    %eax,%edx
  91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  94:	01 d0                	add    %edx,%eax
  96:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	68 02 02 00 00       	push   $0x202
  a1:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a4:	50                   	push   %eax
  a5:	e8 b5 03 00 00       	call   45f <open>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b7:	eb 1e                	jmp    d7 <main+0xd7>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b9:	83 ec 04             	sub    $0x4,%esp
  bc:	68 00 02 00 00       	push   $0x200
  c1:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c7:	50                   	push   %eax
  c8:	ff 75 f0             	pushl  -0x10(%ebp)
  cb:	e8 6f 03 00 00       	call   43f <write>
  d0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 20; i++)
  d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  db:	7e dc                	jle    b9 <main+0xb9>
  close(fd);
  dd:	83 ec 0c             	sub    $0xc,%esp
  e0:	ff 75 f0             	pushl  -0x10(%ebp)
  e3:	e8 5f 03 00 00       	call   447 <close>
  e8:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	68 87 09 00 00       	push   $0x987
  f3:	6a 01                	push   $0x1
  f5:	e8 a9 04 00 00       	call   5a3 <printf>
  fa:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  fd:	83 ec 08             	sub    $0x8,%esp
 100:	6a 00                	push   $0x0
 102:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 105:	50                   	push   %eax
 106:	e8 54 03 00 00       	call   45f <open>
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 111:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 118:	eb 1e                	jmp    138 <main+0x138>
    read(fd, data, sizeof(data));
 11a:	83 ec 04             	sub    $0x4,%esp
 11d:	68 00 02 00 00       	push   $0x200
 122:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 128:	50                   	push   %eax
 129:	ff 75 f0             	pushl  -0x10(%ebp)
 12c:	e8 06 03 00 00       	call   437 <read>
 131:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 20; i++)
 134:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 138:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 13c:	7e dc                	jle    11a <main+0x11a>
  close(fd);
 13e:	83 ec 0c             	sub    $0xc,%esp
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 fe 02 00 00       	call   447 <close>
 149:	83 c4 10             	add    $0x10,%esp

  wait();
 14c:	e8 d6 02 00 00       	call   427 <wait>

  exit();
 151:	e8 c9 02 00 00       	call   41f <exit>

00000156 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 156:	55                   	push   %ebp
 157:	89 e5                	mov    %esp,%ebp
 159:	57                   	push   %edi
 15a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 15b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15e:	8b 55 10             	mov    0x10(%ebp),%edx
 161:	8b 45 0c             	mov    0xc(%ebp),%eax
 164:	89 cb                	mov    %ecx,%ebx
 166:	89 df                	mov    %ebx,%edi
 168:	89 d1                	mov    %edx,%ecx
 16a:	fc                   	cld    
 16b:	f3 aa                	rep stos %al,%es:(%edi)
 16d:	89 ca                	mov    %ecx,%edx
 16f:	89 fb                	mov    %edi,%ebx
 171:	89 5d 08             	mov    %ebx,0x8(%ebp)
 174:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 177:	90                   	nop
 178:	5b                   	pop    %ebx
 179:	5f                   	pop    %edi
 17a:	5d                   	pop    %ebp
 17b:	c3                   	ret    

0000017c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 17c:	f3 0f 1e fb          	endbr32 
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 18c:	90                   	nop
 18d:	8b 55 0c             	mov    0xc(%ebp),%edx
 190:	8d 42 01             	lea    0x1(%edx),%eax
 193:	89 45 0c             	mov    %eax,0xc(%ebp)
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	8d 48 01             	lea    0x1(%eax),%ecx
 19c:	89 4d 08             	mov    %ecx,0x8(%ebp)
 19f:	0f b6 12             	movzbl (%edx),%edx
 1a2:	88 10                	mov    %dl,(%eax)
 1a4:	0f b6 00             	movzbl (%eax),%eax
 1a7:	84 c0                	test   %al,%al
 1a9:	75 e2                	jne    18d <strcpy+0x11>
    ;
  return os;
 1ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ae:	c9                   	leave  
 1af:	c3                   	ret    

000001b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b7:	eb 08                	jmp    1c1 <strcmp+0x11>
    p++, q++;
 1b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	84 c0                	test   %al,%al
 1c9:	74 10                	je     1db <strcmp+0x2b>
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	0f b6 10             	movzbl (%eax),%edx
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	0f b6 00             	movzbl (%eax),%eax
 1d7:	38 c2                	cmp    %al,%dl
 1d9:	74 de                	je     1b9 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 00             	movzbl (%eax),%eax
 1e1:	0f b6 d0             	movzbl %al,%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	0f b6 00             	movzbl (%eax),%eax
 1ea:	0f b6 c0             	movzbl %al,%eax
 1ed:	29 c2                	sub    %eax,%edx
 1ef:	89 d0                	mov    %edx,%eax
}
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    

000001f3 <strlen>:

uint
strlen(const char *s)
{
 1f3:	f3 0f 1e fb          	endbr32 
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 204:	eb 04                	jmp    20a <strlen+0x17>
 206:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 20a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	01 d0                	add    %edx,%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	84 c0                	test   %al,%al
 217:	75 ed                	jne    206 <strlen+0x13>
    ;
  return n;
 219:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <memset>:

void*
memset(void *dst, int c, uint n)
{
 21e:	f3 0f 1e fb          	endbr32 
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 225:	8b 45 10             	mov    0x10(%ebp),%eax
 228:	50                   	push   %eax
 229:	ff 75 0c             	pushl  0xc(%ebp)
 22c:	ff 75 08             	pushl  0x8(%ebp)
 22f:	e8 22 ff ff ff       	call   156 <stosb>
 234:	83 c4 0c             	add    $0xc,%esp
  return dst;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
}
 23a:	c9                   	leave  
 23b:	c3                   	ret    

0000023c <strchr>:

char*
strchr(const char *s, char c)
{
 23c:	f3 0f 1e fb          	endbr32 
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 04             	sub    $0x4,%esp
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 24c:	eb 14                	jmp    262 <strchr+0x26>
    if(*s == c)
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	0f b6 00             	movzbl (%eax),%eax
 254:	38 45 fc             	cmp    %al,-0x4(%ebp)
 257:	75 05                	jne    25e <strchr+0x22>
      return (char*)s;
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	eb 13                	jmp    271 <strchr+0x35>
  for(; *s; s++)
 25e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	84 c0                	test   %al,%al
 26a:	75 e2                	jne    24e <strchr+0x12>
  return 0;
 26c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <gets>:

char*
gets(char *buf, int max)
{
 273:	f3 0f 1e fb          	endbr32 
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 284:	eb 42                	jmp    2c8 <gets+0x55>
    cc = read(0, &c, 1);
 286:	83 ec 04             	sub    $0x4,%esp
 289:	6a 01                	push   $0x1
 28b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 28e:	50                   	push   %eax
 28f:	6a 00                	push   $0x0
 291:	e8 a1 01 00 00       	call   437 <read>
 296:	83 c4 10             	add    $0x10,%esp
 299:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 29c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2a0:	7e 33                	jle    2d5 <gets+0x62>
      break;
    buf[i++] = c;
 2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a5:	8d 50 01             	lea    0x1(%eax),%edx
 2a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2ab:	89 c2                	mov    %eax,%edx
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	01 c2                	add    %eax,%edx
 2b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2bc:	3c 0a                	cmp    $0xa,%al
 2be:	74 16                	je     2d6 <gets+0x63>
 2c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c4:	3c 0d                	cmp    $0xd,%al
 2c6:	74 0e                	je     2d6 <gets+0x63>
  for(i=0; i+1 < max; ){
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	83 c0 01             	add    $0x1,%eax
 2ce:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2d1:	7f b3                	jg     286 <gets+0x13>
 2d3:	eb 01                	jmp    2d6 <gets+0x63>
      break;
 2d5:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	01 d0                	add    %edx,%eax
 2de:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e6:	f3 0f 1e fb          	endbr32 
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	6a 00                	push   $0x0
 2f5:	ff 75 08             	pushl  0x8(%ebp)
 2f8:	e8 62 01 00 00       	call   45f <open>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 307:	79 07                	jns    310 <stat+0x2a>
    return -1;
 309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 30e:	eb 25                	jmp    335 <stat+0x4f>
  r = fstat(fd, st);
 310:	83 ec 08             	sub    $0x8,%esp
 313:	ff 75 0c             	pushl  0xc(%ebp)
 316:	ff 75 f4             	pushl  -0xc(%ebp)
 319:	e8 59 01 00 00       	call   477 <fstat>
 31e:	83 c4 10             	add    $0x10,%esp
 321:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 324:	83 ec 0c             	sub    $0xc,%esp
 327:	ff 75 f4             	pushl  -0xc(%ebp)
 32a:	e8 18 01 00 00       	call   447 <close>
 32f:	83 c4 10             	add    $0x10,%esp
  return r;
 332:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 335:	c9                   	leave  
 336:	c3                   	ret    

00000337 <atoi>:



int
atoi(const char *s)
{
 337:	f3 0f 1e fb          	endbr32 
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	0f b6 00             	movzbl (%eax),%eax
 34e:	3c 2d                	cmp    $0x2d,%al
 350:	75 6b                	jne    3bd <atoi+0x86>
  {
    s++;
 352:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 356:	eb 25                	jmp    37d <atoi+0x46>
        n = n*10 + *s++ - '0';
 358:	8b 55 fc             	mov    -0x4(%ebp),%edx
 35b:	89 d0                	mov    %edx,%eax
 35d:	c1 e0 02             	shl    $0x2,%eax
 360:	01 d0                	add    %edx,%eax
 362:	01 c0                	add    %eax,%eax
 364:	89 c1                	mov    %eax,%ecx
 366:	8b 45 08             	mov    0x8(%ebp),%eax
 369:	8d 50 01             	lea    0x1(%eax),%edx
 36c:	89 55 08             	mov    %edx,0x8(%ebp)
 36f:	0f b6 00             	movzbl (%eax),%eax
 372:	0f be c0             	movsbl %al,%eax
 375:	01 c8                	add    %ecx,%eax
 377:	83 e8 30             	sub    $0x30,%eax
 37a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	3c 2f                	cmp    $0x2f,%al
 385:	7e 0a                	jle    391 <atoi+0x5a>
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	0f b6 00             	movzbl (%eax),%eax
 38d:	3c 39                	cmp    $0x39,%al
 38f:	7e c7                	jle    358 <atoi+0x21>

    return -n;
 391:	8b 45 fc             	mov    -0x4(%ebp),%eax
 394:	f7 d8                	neg    %eax
 396:	eb 3c                	jmp    3d4 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 398:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39b:	89 d0                	mov    %edx,%eax
 39d:	c1 e0 02             	shl    $0x2,%eax
 3a0:	01 d0                	add    %edx,%eax
 3a2:	01 c0                	add    %eax,%eax
 3a4:	89 c1                	mov    %eax,%ecx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8d 50 01             	lea    0x1(%eax),%edx
 3ac:	89 55 08             	mov    %edx,0x8(%ebp)
 3af:	0f b6 00             	movzbl (%eax),%eax
 3b2:	0f be c0             	movsbl %al,%eax
 3b5:	01 c8                	add    %ecx,%eax
 3b7:	83 e8 30             	sub    $0x30,%eax
 3ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x9a>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c7                	jle    398 <atoi+0x61>

    return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d6:	f3 0f 1e fb          	endbr32 
 3da:	55                   	push   %ebp
 3db:	89 e5                	mov    %esp,%ebp
 3dd:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ec:	eb 17                	jmp    405 <memmove+0x2f>
    *dst++ = *src++;
 3ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f1:	8d 42 01             	lea    0x1(%edx),%eax
 3f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fa:	8d 48 01             	lea    0x1(%eax),%ecx
 3fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 400:	0f b6 12             	movzbl (%edx),%edx
 403:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 405:	8b 45 10             	mov    0x10(%ebp),%eax
 408:	8d 50 ff             	lea    -0x1(%eax),%edx
 40b:	89 55 10             	mov    %edx,0x10(%ebp)
 40e:	85 c0                	test   %eax,%eax
 410:	7f dc                	jg     3ee <memmove+0x18>
  return vdst;
 412:	8b 45 08             	mov    0x8(%ebp),%eax
}
 415:	c9                   	leave  
 416:	c3                   	ret    

00000417 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 417:	b8 01 00 00 00       	mov    $0x1,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <exit>:
SYSCALL(exit)
 41f:	b8 02 00 00 00       	mov    $0x2,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <wait>:
SYSCALL(wait)
 427:	b8 03 00 00 00       	mov    $0x3,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <pipe>:
SYSCALL(pipe)
 42f:	b8 04 00 00 00       	mov    $0x4,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <read>:
SYSCALL(read)
 437:	b8 05 00 00 00       	mov    $0x5,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <write>:
SYSCALL(write)
 43f:	b8 10 00 00 00       	mov    $0x10,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <close>:
SYSCALL(close)
 447:	b8 15 00 00 00       	mov    $0x15,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <kill>:
SYSCALL(kill)
 44f:	b8 06 00 00 00       	mov    $0x6,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <exec>:
SYSCALL(exec)
 457:	b8 07 00 00 00       	mov    $0x7,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <open>:
SYSCALL(open)
 45f:	b8 0f 00 00 00       	mov    $0xf,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <mknod>:
SYSCALL(mknod)
 467:	b8 11 00 00 00       	mov    $0x11,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <unlink>:
SYSCALL(unlink)
 46f:	b8 12 00 00 00       	mov    $0x12,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <fstat>:
SYSCALL(fstat)
 477:	b8 08 00 00 00       	mov    $0x8,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <link>:
SYSCALL(link)
 47f:	b8 13 00 00 00       	mov    $0x13,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <mkdir>:
SYSCALL(mkdir)
 487:	b8 14 00 00 00       	mov    $0x14,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <chdir>:
SYSCALL(chdir)
 48f:	b8 09 00 00 00       	mov    $0x9,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <dup>:
SYSCALL(dup)
 497:	b8 0a 00 00 00       	mov    $0xa,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <getpid>:
SYSCALL(getpid)
 49f:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <sbrk>:
SYSCALL(sbrk)
 4a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <sleep>:
SYSCALL(sleep)
 4af:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <uptime>:
SYSCALL(uptime)
 4b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <lseek>:
SYSCALL(lseek)
 4bf:	b8 16 00 00 00       	mov    $0x16,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c7:	f3 0f 1e fb          	endbr32 
 4cb:	55                   	push   %ebp
 4cc:	89 e5                	mov    %esp,%ebp
 4ce:	83 ec 18             	sub    $0x18,%esp
 4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d7:	83 ec 04             	sub    $0x4,%esp
 4da:	6a 01                	push   $0x1
 4dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4df:	50                   	push   %eax
 4e0:	ff 75 08             	pushl  0x8(%ebp)
 4e3:	e8 57 ff ff ff       	call   43f <write>
 4e8:	83 c4 10             	add    $0x10,%esp
}
 4eb:	90                   	nop
 4ec:	c9                   	leave  
 4ed:	c3                   	ret    

000004ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ee:	f3 0f 1e fb          	endbr32 
 4f2:	55                   	push   %ebp
 4f3:	89 e5                	mov    %esp,%ebp
 4f5:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 503:	74 17                	je     51c <printint+0x2e>
 505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 509:	79 11                	jns    51c <printint+0x2e>
    neg = 1;
 50b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	f7 d8                	neg    %eax
 517:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51a:	eb 06                	jmp    522 <printint+0x34>
  } else {
    x = xx;
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 522:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 529:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52f:	ba 00 00 00 00       	mov    $0x0,%edx
 534:	f7 f1                	div    %ecx
 536:	89 d1                	mov    %edx,%ecx
 538:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53b:	8d 50 01             	lea    0x1(%eax),%edx
 53e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 541:	0f b6 91 d8 0b 00 00 	movzbl 0xbd8(%ecx),%edx
 548:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 54c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 54f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 552:	ba 00 00 00 00       	mov    $0x0,%edx
 557:	f7 f1                	div    %ecx
 559:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 560:	75 c7                	jne    529 <printint+0x3b>
  if(neg)
 562:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 566:	74 2d                	je     595 <printint+0xa7>
    buf[i++] = '-';
 568:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56b:	8d 50 01             	lea    0x1(%eax),%edx
 56e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 571:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 576:	eb 1d                	jmp    595 <printint+0xa7>
    putc(fd, buf[i]);
 578:	8d 55 dc             	lea    -0x24(%ebp),%edx
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	01 d0                	add    %edx,%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	0f be c0             	movsbl %al,%eax
 586:	83 ec 08             	sub    $0x8,%esp
 589:	50                   	push   %eax
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 35 ff ff ff       	call   4c7 <putc>
 592:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 595:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59d:	79 d9                	jns    578 <printint+0x8a>
}
 59f:	90                   	nop
 5a0:	90                   	nop
 5a1:	c9                   	leave  
 5a2:	c3                   	ret    

000005a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5a3:	f3 0f 1e fb          	endbr32 
 5a7:	55                   	push   %ebp
 5a8:	89 e5                	mov    %esp,%ebp
 5aa:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b4:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b7:	83 c0 04             	add    $0x4,%eax
 5ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c4:	e9 59 01 00 00       	jmp    722 <printf+0x17f>
    c = fmt[i] & 0xff;
 5c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cf:	01 d0                	add    %edx,%eax
 5d1:	0f b6 00             	movzbl (%eax),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	25 ff 00 00 00       	and    $0xff,%eax
 5dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e3:	75 2c                	jne    611 <printf+0x6e>
      if(c == '%'){
 5e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e9:	75 0c                	jne    5f7 <printf+0x54>
        state = '%';
 5eb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f2:	e9 27 01 00 00       	jmp    71e <printf+0x17b>
      } else {
        putc(fd, c);
 5f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fa:	0f be c0             	movsbl %al,%eax
 5fd:	83 ec 08             	sub    $0x8,%esp
 600:	50                   	push   %eax
 601:	ff 75 08             	pushl  0x8(%ebp)
 604:	e8 be fe ff ff       	call   4c7 <putc>
 609:	83 c4 10             	add    $0x10,%esp
 60c:	e9 0d 01 00 00       	jmp    71e <printf+0x17b>
      }
    } else if(state == '%'){
 611:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 615:	0f 85 03 01 00 00    	jne    71e <printf+0x17b>
      if(c == 'd'){
 61b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61f:	75 1e                	jne    63f <printf+0x9c>
        printint(fd, *ap, 10, 1);
 621:	8b 45 e8             	mov    -0x18(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	6a 01                	push   $0x1
 628:	6a 0a                	push   $0xa
 62a:	50                   	push   %eax
 62b:	ff 75 08             	pushl  0x8(%ebp)
 62e:	e8 bb fe ff ff       	call   4ee <printint>
 633:	83 c4 10             	add    $0x10,%esp
        ap++;
 636:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63a:	e9 d8 00 00 00       	jmp    717 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 63f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 643:	74 06                	je     64b <printf+0xa8>
 645:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 649:	75 1e                	jne    669 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	6a 00                	push   $0x0
 652:	6a 10                	push   $0x10
 654:	50                   	push   %eax
 655:	ff 75 08             	pushl  0x8(%ebp)
 658:	e8 91 fe ff ff       	call   4ee <printint>
 65d:	83 c4 10             	add    $0x10,%esp
        ap++;
 660:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 664:	e9 ae 00 00 00       	jmp    717 <printf+0x174>
      } else if(c == 's'){
 669:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 66d:	75 43                	jne    6b2 <printf+0x10f>
        s = (char*)*ap;
 66f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 677:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 67b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67f:	75 25                	jne    6a6 <printf+0x103>
          s = "(null)";
 681:	c7 45 f4 8d 09 00 00 	movl   $0x98d,-0xc(%ebp)
        while(*s != 0){
 688:	eb 1c                	jmp    6a6 <printf+0x103>
          putc(fd, *s);
 68a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68d:	0f b6 00             	movzbl (%eax),%eax
 690:	0f be c0             	movsbl %al,%eax
 693:	83 ec 08             	sub    $0x8,%esp
 696:	50                   	push   %eax
 697:	ff 75 08             	pushl  0x8(%ebp)
 69a:	e8 28 fe ff ff       	call   4c7 <putc>
 69f:	83 c4 10             	add    $0x10,%esp
          s++;
 6a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a9:	0f b6 00             	movzbl (%eax),%eax
 6ac:	84 c0                	test   %al,%al
 6ae:	75 da                	jne    68a <printf+0xe7>
 6b0:	eb 65                	jmp    717 <printf+0x174>
        }
      } else if(c == 'c'){
 6b2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b6:	75 1d                	jne    6d5 <printf+0x132>
        putc(fd, *ap);
 6b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	83 ec 08             	sub    $0x8,%esp
 6c3:	50                   	push   %eax
 6c4:	ff 75 08             	pushl  0x8(%ebp)
 6c7:	e8 fb fd ff ff       	call   4c7 <putc>
 6cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d3:	eb 42                	jmp    717 <printf+0x174>
      } else if(c == '%'){
 6d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d9:	75 17                	jne    6f2 <printf+0x14f>
        putc(fd, c);
 6db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6de:	0f be c0             	movsbl %al,%eax
 6e1:	83 ec 08             	sub    $0x8,%esp
 6e4:	50                   	push   %eax
 6e5:	ff 75 08             	pushl  0x8(%ebp)
 6e8:	e8 da fd ff ff       	call   4c7 <putc>
 6ed:	83 c4 10             	add    $0x10,%esp
 6f0:	eb 25                	jmp    717 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f2:	83 ec 08             	sub    $0x8,%esp
 6f5:	6a 25                	push   $0x25
 6f7:	ff 75 08             	pushl  0x8(%ebp)
 6fa:	e8 c8 fd ff ff       	call   4c7 <putc>
 6ff:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 705:	0f be c0             	movsbl %al,%eax
 708:	83 ec 08             	sub    $0x8,%esp
 70b:	50                   	push   %eax
 70c:	ff 75 08             	pushl  0x8(%ebp)
 70f:	e8 b3 fd ff ff       	call   4c7 <putc>
 714:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 717:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 71e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 722:	8b 55 0c             	mov    0xc(%ebp),%edx
 725:	8b 45 f0             	mov    -0x10(%ebp),%eax
 728:	01 d0                	add    %edx,%eax
 72a:	0f b6 00             	movzbl (%eax),%eax
 72d:	84 c0                	test   %al,%al
 72f:	0f 85 94 fe ff ff    	jne    5c9 <printf+0x26>
    }
  }
}
 735:	90                   	nop
 736:	90                   	nop
 737:	c9                   	leave  
 738:	c3                   	ret    

00000739 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 739:	f3 0f 1e fb          	endbr32 
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	83 e8 08             	sub    $0x8,%eax
 749:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74c:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 751:	89 45 fc             	mov    %eax,-0x4(%ebp)
 754:	eb 24                	jmp    77a <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 75e:	72 12                	jb     772 <free+0x39>
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 766:	77 24                	ja     78c <free+0x53>
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 770:	72 1a                	jb     78c <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	89 45 fc             	mov    %eax,-0x4(%ebp)
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 780:	76 d4                	jbe    756 <free+0x1d>
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 78a:	73 ca                	jae    756 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	01 c2                	add    %eax,%edx
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	39 c2                	cmp    %eax,%edx
 7a5:	75 24                	jne    7cb <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 50 04             	mov    0x4(%eax),%edx
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	01 c2                	add    %eax,%edx
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	8b 10                	mov    (%eax),%edx
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	89 10                	mov    %edx,(%eax)
 7c9:	eb 0a                	jmp    7d5 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 10                	mov    (%eax),%edx
 7d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	01 d0                	add    %edx,%eax
 7e7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7ea:	75 20                	jne    80c <free+0xd3>
    p->s.size += bp->s.size;
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 50 04             	mov    0x4(%eax),%edx
 7f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	01 c2                	add    %eax,%edx
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	8b 10                	mov    (%eax),%edx
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	89 10                	mov    %edx,(%eax)
 80a:	eb 08                	jmp    814 <free+0xdb>
  } else
    p->s.ptr = bp;
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 812:	89 10                	mov    %edx,(%eax)
  freep = p;
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	a3 f4 0b 00 00       	mov    %eax,0xbf4
}
 81c:	90                   	nop
 81d:	c9                   	leave  
 81e:	c3                   	ret    

0000081f <morecore>:

static Header*
morecore(uint nu)
{
 81f:	f3 0f 1e fb          	endbr32 
 823:	55                   	push   %ebp
 824:	89 e5                	mov    %esp,%ebp
 826:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 829:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 830:	77 07                	ja     839 <morecore+0x1a>
    nu = 4096;
 832:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 839:	8b 45 08             	mov    0x8(%ebp),%eax
 83c:	c1 e0 03             	shl    $0x3,%eax
 83f:	83 ec 0c             	sub    $0xc,%esp
 842:	50                   	push   %eax
 843:	e8 5f fc ff ff       	call   4a7 <sbrk>
 848:	83 c4 10             	add    $0x10,%esp
 84b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 84e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 852:	75 07                	jne    85b <morecore+0x3c>
    return 0;
 854:	b8 00 00 00 00       	mov    $0x0,%eax
 859:	eb 26                	jmp    881 <morecore+0x62>
  hp = (Header*)p;
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 861:	8b 45 f0             	mov    -0x10(%ebp),%eax
 864:	8b 55 08             	mov    0x8(%ebp),%edx
 867:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 86a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86d:	83 c0 08             	add    $0x8,%eax
 870:	83 ec 0c             	sub    $0xc,%esp
 873:	50                   	push   %eax
 874:	e8 c0 fe ff ff       	call   739 <free>
 879:	83 c4 10             	add    $0x10,%esp
  return freep;
 87c:	a1 f4 0b 00 00       	mov    0xbf4,%eax
}
 881:	c9                   	leave  
 882:	c3                   	ret    

00000883 <malloc>:

void*
malloc(uint nbytes)
{
 883:	f3 0f 1e fb          	endbr32 
 887:	55                   	push   %ebp
 888:	89 e5                	mov    %esp,%ebp
 88a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	83 c0 07             	add    $0x7,%eax
 893:	c1 e8 03             	shr    $0x3,%eax
 896:	83 c0 01             	add    $0x1,%eax
 899:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 89c:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 8a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a8:	75 23                	jne    8cd <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 8aa:	c7 45 f0 ec 0b 00 00 	movl   $0xbec,-0x10(%ebp)
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 f4 0b 00 00       	mov    %eax,0xbf4
 8b9:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 8be:	a3 ec 0b 00 00       	mov    %eax,0xbec
    base.s.size = 0;
 8c3:	c7 05 f0 0b 00 00 00 	movl   $0x0,0xbf0
 8ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8de:	77 4d                	ja     92d <malloc+0xaa>
      if(p->s.size == nunits)
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8e9:	75 0c                	jne    8f7 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 10                	mov    (%eax),%edx
 8f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f3:	89 10                	mov    %edx,(%eax)
 8f5:	eb 26                	jmp    91d <malloc+0x9a>
      else {
        p->s.size -= nunits;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 900:	89 c2                	mov    %eax,%edx
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	c1 e0 03             	shl    $0x3,%eax
 911:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 55 ec             	mov    -0x14(%ebp),%edx
 91a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	a3 f4 0b 00 00       	mov    %eax,0xbf4
      return (void*)(p + 1);
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	83 c0 08             	add    $0x8,%eax
 92b:	eb 3b                	jmp    968 <malloc+0xe5>
    }
    if(p == freep)
 92d:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 935:	75 1e                	jne    955 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 937:	83 ec 0c             	sub    $0xc,%esp
 93a:	ff 75 ec             	pushl  -0x14(%ebp)
 93d:	e8 dd fe ff ff       	call   81f <morecore>
 942:	83 c4 10             	add    $0x10,%esp
 945:	89 45 f4             	mov    %eax,-0xc(%ebp)
 948:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94c:	75 07                	jne    955 <malloc+0xd2>
        return 0;
 94e:	b8 00 00 00 00       	mov    $0x0,%eax
 953:	eb 13                	jmp    968 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 963:	e9 6d ff ff ff       	jmp    8d5 <malloc+0x52>
  }
}
 968:	c9                   	leave  
 969:	c3                   	ret    
