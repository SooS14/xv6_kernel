
_zombie:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <main>:
#include "stat.h"
#include "user.h"

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
  12:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  15:	e8 d7 02 00 00       	call   2f1 <fork>
  1a:	85 c0                	test   %eax,%eax
  1c:	7e 0d                	jle    2b <main+0x2b>
    sleep(5);  // Let child exit before parent.
  1e:	83 ec 0c             	sub    $0xc,%esp
  21:	6a 05                	push   $0x5
  23:	e8 61 03 00 00       	call   389 <sleep>
  28:	83 c4 10             	add    $0x10,%esp
  exit();
  2b:	e8 c9 02 00 00       	call   2f9 <exit>

00000030 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	57                   	push   %edi
  34:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  38:	8b 55 10             	mov    0x10(%ebp),%edx
  3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  3e:	89 cb                	mov    %ecx,%ebx
  40:	89 df                	mov    %ebx,%edi
  42:	89 d1                	mov    %edx,%ecx
  44:	fc                   	cld    
  45:	f3 aa                	rep stos %al,%es:(%edi)
  47:	89 ca                	mov    %ecx,%edx
  49:	89 fb                	mov    %edi,%ebx
  4b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  51:	90                   	nop
  52:	5b                   	pop    %ebx
  53:	5f                   	pop    %edi
  54:	5d                   	pop    %ebp
  55:	c3                   	ret    

00000056 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  56:	f3 0f 1e fb          	endbr32 
  5a:	55                   	push   %ebp
  5b:	89 e5                	mov    %esp,%ebp
  5d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  66:	90                   	nop
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	8d 42 01             	lea    0x1(%edx),%eax
  6d:	89 45 0c             	mov    %eax,0xc(%ebp)
  70:	8b 45 08             	mov    0x8(%ebp),%eax
  73:	8d 48 01             	lea    0x1(%eax),%ecx
  76:	89 4d 08             	mov    %ecx,0x8(%ebp)
  79:	0f b6 12             	movzbl (%edx),%edx
  7c:	88 10                	mov    %dl,(%eax)
  7e:	0f b6 00             	movzbl (%eax),%eax
  81:	84 c0                	test   %al,%al
  83:	75 e2                	jne    67 <strcpy+0x11>
    ;
  return os;
  85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  88:	c9                   	leave  
  89:	c3                   	ret    

0000008a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8a:	f3 0f 1e fb          	endbr32 
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  91:	eb 08                	jmp    9b <strcmp+0x11>
    p++, q++;
  93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	84 c0                	test   %al,%al
  a3:	74 10                	je     b5 <strcmp+0x2b>
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 10             	movzbl (%eax),%edx
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	0f b6 00             	movzbl (%eax),%eax
  b1:	38 c2                	cmp    %al,%dl
  b3:	74 de                	je     93 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	0f b6 00             	movzbl (%eax),%eax
  bb:	0f b6 d0             	movzbl %al,%edx
  be:	8b 45 0c             	mov    0xc(%ebp),%eax
  c1:	0f b6 00             	movzbl (%eax),%eax
  c4:	0f b6 c0             	movzbl %al,%eax
  c7:	29 c2                	sub    %eax,%edx
  c9:	89 d0                	mov    %edx,%eax
}
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    

000000cd <strlen>:

uint
strlen(const char *s)
{
  cd:	f3 0f 1e fb          	endbr32 
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  de:	eb 04                	jmp    e4 <strlen+0x17>
  e0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	01 d0                	add    %edx,%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	84 c0                	test   %al,%al
  f1:	75 ed                	jne    e0 <strlen+0x13>
    ;
  return n;
  f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f6:	c9                   	leave  
  f7:	c3                   	ret    

000000f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f8:	f3 0f 1e fb          	endbr32 
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  ff:	8b 45 10             	mov    0x10(%ebp),%eax
 102:	50                   	push   %eax
 103:	ff 75 0c             	pushl  0xc(%ebp)
 106:	ff 75 08             	pushl  0x8(%ebp)
 109:	e8 22 ff ff ff       	call   30 <stosb>
 10e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 111:	8b 45 08             	mov    0x8(%ebp),%eax
}
 114:	c9                   	leave  
 115:	c3                   	ret    

00000116 <strchr>:

char*
strchr(const char *s, char c)
{
 116:	f3 0f 1e fb          	endbr32 
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 04             	sub    $0x4,%esp
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 126:	eb 14                	jmp    13c <strchr+0x26>
    if(*s == c)
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 131:	75 05                	jne    138 <strchr+0x22>
      return (char*)s;
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	eb 13                	jmp    14b <strchr+0x35>
  for(; *s; s++)
 138:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 e2                	jne    128 <strchr+0x12>
  return 0;
 146:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14b:	c9                   	leave  
 14c:	c3                   	ret    

0000014d <gets>:

char*
gets(char *buf, int max)
{
 14d:	f3 0f 1e fb          	endbr32 
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 157:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15e:	eb 42                	jmp    1a2 <gets+0x55>
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	8d 45 ef             	lea    -0x11(%ebp),%eax
 168:	50                   	push   %eax
 169:	6a 00                	push   $0x0
 16b:	e8 a1 01 00 00       	call   311 <read>
 170:	83 c4 10             	add    $0x10,%esp
 173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 176:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 17a:	7e 33                	jle    1af <gets+0x62>
      break;
    buf[i++] = c;
 17c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17f:	8d 50 01             	lea    0x1(%eax),%edx
 182:	89 55 f4             	mov    %edx,-0xc(%ebp)
 185:	89 c2                	mov    %eax,%edx
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	01 c2                	add    %eax,%edx
 18c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 190:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 192:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 196:	3c 0a                	cmp    $0xa,%al
 198:	74 16                	je     1b0 <gets+0x63>
 19a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19e:	3c 0d                	cmp    $0xd,%al
 1a0:	74 0e                	je     1b0 <gets+0x63>
  for(i=0; i+1 < max; ){
 1a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a5:	83 c0 01             	add    $0x1,%eax
 1a8:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1ab:	7f b3                	jg     160 <gets+0x13>
 1ad:	eb 01                	jmp    1b0 <gets+0x63>
      break;
 1af:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 d0                	add    %edx,%eax
 1b8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1be:	c9                   	leave  
 1bf:	c3                   	ret    

000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	6a 00                	push   $0x0
 1cf:	ff 75 08             	pushl  0x8(%ebp)
 1d2:	e8 62 01 00 00       	call   339 <open>
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1e1:	79 07                	jns    1ea <stat+0x2a>
    return -1;
 1e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e8:	eb 25                	jmp    20f <stat+0x4f>
  r = fstat(fd, st);
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	ff 75 0c             	pushl  0xc(%ebp)
 1f0:	ff 75 f4             	pushl  -0xc(%ebp)
 1f3:	e8 59 01 00 00       	call   351 <fstat>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1fe:	83 ec 0c             	sub    $0xc,%esp
 201:	ff 75 f4             	pushl  -0xc(%ebp)
 204:	e8 18 01 00 00       	call   321 <close>
 209:	83 c4 10             	add    $0x10,%esp
  return r;
 20c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <atoi>:



int
atoi(const char *s)
{
 211:	f3 0f 1e fb          	endbr32 
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	0f b6 00             	movzbl (%eax),%eax
 228:	3c 2d                	cmp    $0x2d,%al
 22a:	75 6b                	jne    297 <atoi+0x86>
  {
    s++;
 22c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 230:	eb 25                	jmp    257 <atoi+0x46>
        n = n*10 + *s++ - '0';
 232:	8b 55 fc             	mov    -0x4(%ebp),%edx
 235:	89 d0                	mov    %edx,%eax
 237:	c1 e0 02             	shl    $0x2,%eax
 23a:	01 d0                	add    %edx,%eax
 23c:	01 c0                	add    %eax,%eax
 23e:	89 c1                	mov    %eax,%ecx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	8d 50 01             	lea    0x1(%eax),%edx
 246:	89 55 08             	mov    %edx,0x8(%ebp)
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	0f be c0             	movsbl %al,%eax
 24f:	01 c8                	add    %ecx,%eax
 251:	83 e8 30             	sub    $0x30,%eax
 254:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	3c 2f                	cmp    $0x2f,%al
 25f:	7e 0a                	jle    26b <atoi+0x5a>
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	3c 39                	cmp    $0x39,%al
 269:	7e c7                	jle    232 <atoi+0x21>

    return -n;
 26b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26e:	f7 d8                	neg    %eax
 270:	eb 3c                	jmp    2ae <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 272:	8b 55 fc             	mov    -0x4(%ebp),%edx
 275:	89 d0                	mov    %edx,%eax
 277:	c1 e0 02             	shl    $0x2,%eax
 27a:	01 d0                	add    %edx,%eax
 27c:	01 c0                	add    %eax,%eax
 27e:	89 c1                	mov    %eax,%ecx
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	8d 50 01             	lea    0x1(%eax),%edx
 286:	89 55 08             	mov    %edx,0x8(%ebp)
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	0f be c0             	movsbl %al,%eax
 28f:	01 c8                	add    %ecx,%eax
 291:	83 e8 30             	sub    $0x30,%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	3c 2f                	cmp    $0x2f,%al
 29f:	7e 0a                	jle    2ab <atoi+0x9a>
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3c 39                	cmp    $0x39,%al
 2a9:	7e c7                	jle    272 <atoi+0x61>

    return n;
 2ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 2ae:	c9                   	leave  
 2af:	c3                   	ret    

000002b0 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b0:	f3 0f 1e fb          	endbr32 
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c6:	eb 17                	jmp    2df <memmove+0x2f>
    *dst++ = *src++;
 2c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2cb:	8d 42 01             	lea    0x1(%edx),%eax
 2ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d4:	8d 48 01             	lea    0x1(%eax),%ecx
 2d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2da:	0f b6 12             	movzbl (%edx),%edx
 2dd:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2df:	8b 45 10             	mov    0x10(%ebp),%eax
 2e2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e5:	89 55 10             	mov    %edx,0x10(%ebp)
 2e8:	85 c0                	test   %eax,%eax
 2ea:	7f dc                	jg     2c8 <memmove+0x18>
  return vdst;
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f1:	b8 01 00 00 00       	mov    $0x1,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <exit>:
SYSCALL(exit)
 2f9:	b8 02 00 00 00       	mov    $0x2,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <wait>:
SYSCALL(wait)
 301:	b8 03 00 00 00       	mov    $0x3,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <pipe>:
SYSCALL(pipe)
 309:	b8 04 00 00 00       	mov    $0x4,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <read>:
SYSCALL(read)
 311:	b8 05 00 00 00       	mov    $0x5,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <write>:
SYSCALL(write)
 319:	b8 10 00 00 00       	mov    $0x10,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <close>:
SYSCALL(close)
 321:	b8 15 00 00 00       	mov    $0x15,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <kill>:
SYSCALL(kill)
 329:	b8 06 00 00 00       	mov    $0x6,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <exec>:
SYSCALL(exec)
 331:	b8 07 00 00 00       	mov    $0x7,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <open>:
SYSCALL(open)
 339:	b8 0f 00 00 00       	mov    $0xf,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <mknod>:
SYSCALL(mknod)
 341:	b8 11 00 00 00       	mov    $0x11,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <unlink>:
SYSCALL(unlink)
 349:	b8 12 00 00 00       	mov    $0x12,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <fstat>:
SYSCALL(fstat)
 351:	b8 08 00 00 00       	mov    $0x8,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <link>:
SYSCALL(link)
 359:	b8 13 00 00 00       	mov    $0x13,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <mkdir>:
SYSCALL(mkdir)
 361:	b8 14 00 00 00       	mov    $0x14,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <chdir>:
SYSCALL(chdir)
 369:	b8 09 00 00 00       	mov    $0x9,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <dup>:
SYSCALL(dup)
 371:	b8 0a 00 00 00       	mov    $0xa,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <getpid>:
SYSCALL(getpid)
 379:	b8 0b 00 00 00       	mov    $0xb,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sbrk>:
SYSCALL(sbrk)
 381:	b8 0c 00 00 00       	mov    $0xc,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sleep>:
SYSCALL(sleep)
 389:	b8 0d 00 00 00       	mov    $0xd,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <uptime>:
SYSCALL(uptime)
 391:	b8 0e 00 00 00       	mov    $0xe,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <lseek>:
SYSCALL(lseek)
 399:	b8 16 00 00 00       	mov    $0x16,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a1:	f3 0f 1e fb          	endbr32 
 3a5:	55                   	push   %ebp
 3a6:	89 e5                	mov    %esp,%ebp
 3a8:	83 ec 18             	sub    $0x18,%esp
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b1:	83 ec 04             	sub    $0x4,%esp
 3b4:	6a 01                	push   $0x1
 3b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b9:	50                   	push   %eax
 3ba:	ff 75 08             	pushl  0x8(%ebp)
 3bd:	e8 57 ff ff ff       	call   319 <write>
 3c2:	83 c4 10             	add    $0x10,%esp
}
 3c5:	90                   	nop
 3c6:	c9                   	leave  
 3c7:	c3                   	ret    

000003c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c8:	f3 0f 1e fb          	endbr32 
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3dd:	74 17                	je     3f6 <printint+0x2e>
 3df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e3:	79 11                	jns    3f6 <printint+0x2e>
    neg = 1;
 3e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	f7 d8                	neg    %eax
 3f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f4:	eb 06                	jmp    3fc <printint+0x34>
  } else {
    x = xx;
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 403:	8b 4d 10             	mov    0x10(%ebp),%ecx
 406:	8b 45 ec             	mov    -0x14(%ebp),%eax
 409:	ba 00 00 00 00       	mov    $0x0,%edx
 40e:	f7 f1                	div    %ecx
 410:	89 d1                	mov    %edx,%ecx
 412:	8b 45 f4             	mov    -0xc(%ebp),%eax
 415:	8d 50 01             	lea    0x1(%eax),%edx
 418:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41b:	0f b6 91 90 0a 00 00 	movzbl 0xa90(%ecx),%edx
 422:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 426:	8b 4d 10             	mov    0x10(%ebp),%ecx
 429:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42c:	ba 00 00 00 00       	mov    $0x0,%edx
 431:	f7 f1                	div    %ecx
 433:	89 45 ec             	mov    %eax,-0x14(%ebp)
 436:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43a:	75 c7                	jne    403 <printint+0x3b>
  if(neg)
 43c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 440:	74 2d                	je     46f <printint+0xa7>
    buf[i++] = '-';
 442:	8b 45 f4             	mov    -0xc(%ebp),%eax
 445:	8d 50 01             	lea    0x1(%eax),%edx
 448:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 450:	eb 1d                	jmp    46f <printint+0xa7>
    putc(fd, buf[i]);
 452:	8d 55 dc             	lea    -0x24(%ebp),%edx
 455:	8b 45 f4             	mov    -0xc(%ebp),%eax
 458:	01 d0                	add    %edx,%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	0f be c0             	movsbl %al,%eax
 460:	83 ec 08             	sub    $0x8,%esp
 463:	50                   	push   %eax
 464:	ff 75 08             	pushl  0x8(%ebp)
 467:	e8 35 ff ff ff       	call   3a1 <putc>
 46c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 46f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 477:	79 d9                	jns    452 <printint+0x8a>
}
 479:	90                   	nop
 47a:	90                   	nop
 47b:	c9                   	leave  
 47c:	c3                   	ret    

0000047d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 47d:	f3 0f 1e fb          	endbr32 
 481:	55                   	push   %ebp
 482:	89 e5                	mov    %esp,%ebp
 484:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 487:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48e:	8d 45 0c             	lea    0xc(%ebp),%eax
 491:	83 c0 04             	add    $0x4,%eax
 494:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49e:	e9 59 01 00 00       	jmp    5fc <printf+0x17f>
    c = fmt[i] & 0xff;
 4a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a9:	01 d0                	add    %edx,%eax
 4ab:	0f b6 00             	movzbl (%eax),%eax
 4ae:	0f be c0             	movsbl %al,%eax
 4b1:	25 ff 00 00 00       	and    $0xff,%eax
 4b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bd:	75 2c                	jne    4eb <printf+0x6e>
      if(c == '%'){
 4bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c3:	75 0c                	jne    4d1 <printf+0x54>
        state = '%';
 4c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4cc:	e9 27 01 00 00       	jmp    5f8 <printf+0x17b>
      } else {
        putc(fd, c);
 4d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 be fe ff ff       	call   3a1 <putc>
 4e3:	83 c4 10             	add    $0x10,%esp
 4e6:	e9 0d 01 00 00       	jmp    5f8 <printf+0x17b>
      }
    } else if(state == '%'){
 4eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ef:	0f 85 03 01 00 00    	jne    5f8 <printf+0x17b>
      if(c == 'd'){
 4f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f9:	75 1e                	jne    519 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	6a 01                	push   $0x1
 502:	6a 0a                	push   $0xa
 504:	50                   	push   %eax
 505:	ff 75 08             	pushl  0x8(%ebp)
 508:	e8 bb fe ff ff       	call   3c8 <printint>
 50d:	83 c4 10             	add    $0x10,%esp
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 d8 00 00 00       	jmp    5f1 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 519:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51d:	74 06                	je     525 <printf+0xa8>
 51f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 523:	75 1e                	jne    543 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 525:	8b 45 e8             	mov    -0x18(%ebp),%eax
 528:	8b 00                	mov    (%eax),%eax
 52a:	6a 00                	push   $0x0
 52c:	6a 10                	push   $0x10
 52e:	50                   	push   %eax
 52f:	ff 75 08             	pushl  0x8(%ebp)
 532:	e8 91 fe ff ff       	call   3c8 <printint>
 537:	83 c4 10             	add    $0x10,%esp
        ap++;
 53a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53e:	e9 ae 00 00 00       	jmp    5f1 <printf+0x174>
      } else if(c == 's'){
 543:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 547:	75 43                	jne    58c <printf+0x10f>
        s = (char*)*ap;
 549:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54c:	8b 00                	mov    (%eax),%eax
 54e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 551:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 559:	75 25                	jne    580 <printf+0x103>
          s = "(null)";
 55b:	c7 45 f4 44 08 00 00 	movl   $0x844,-0xc(%ebp)
        while(*s != 0){
 562:	eb 1c                	jmp    580 <printf+0x103>
          putc(fd, *s);
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	0f b6 00             	movzbl (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 28 fe ff ff       	call   3a1 <putc>
 579:	83 c4 10             	add    $0x10,%esp
          s++;
 57c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	84 c0                	test   %al,%al
 588:	75 da                	jne    564 <printf+0xe7>
 58a:	eb 65                	jmp    5f1 <printf+0x174>
        }
      } else if(c == 'c'){
 58c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 590:	75 1d                	jne    5af <printf+0x132>
        putc(fd, *ap);
 592:	8b 45 e8             	mov    -0x18(%ebp),%eax
 595:	8b 00                	mov    (%eax),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	83 ec 08             	sub    $0x8,%esp
 59d:	50                   	push   %eax
 59e:	ff 75 08             	pushl  0x8(%ebp)
 5a1:	e8 fb fd ff ff       	call   3a1 <putc>
 5a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	eb 42                	jmp    5f1 <printf+0x174>
      } else if(c == '%'){
 5af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b3:	75 17                	jne    5cc <printf+0x14f>
        putc(fd, c);
 5b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 da fd ff ff       	call   3a1 <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
 5ca:	eb 25                	jmp    5f1 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	6a 25                	push   $0x25
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 c8 fd ff ff       	call   3a1 <putc>
 5d9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 b3 fd ff ff       	call   3a1 <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 602:	01 d0                	add    %edx,%eax
 604:	0f b6 00             	movzbl (%eax),%eax
 607:	84 c0                	test   %al,%al
 609:	0f 85 94 fe ff ff    	jne    4a3 <printf+0x26>
    }
  }
}
 60f:	90                   	nop
 610:	90                   	nop
 611:	c9                   	leave  
 612:	c3                   	ret    

00000613 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 613:	f3 0f 1e fb          	endbr32 
 617:	55                   	push   %ebp
 618:	89 e5                	mov    %esp,%ebp
 61a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	83 e8 08             	sub    $0x8,%eax
 623:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 626:	a1 ac 0a 00 00       	mov    0xaac,%eax
 62b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62e:	eb 24                	jmp    654 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 638:	72 12                	jb     64c <free+0x39>
 63a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 640:	77 24                	ja     666 <free+0x53>
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 64a:	72 1a                	jb     666 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65a:	76 d4                	jbe    630 <free+0x1d>
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 664:	73 ca                	jae    630 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	8b 40 04             	mov    0x4(%eax),%eax
 66c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	01 c2                	add    %eax,%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	39 c2                	cmp    %eax,%edx
 67f:	75 24                	jne    6a5 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	8b 50 04             	mov    0x4(%eax),%edx
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	8b 40 04             	mov    0x4(%eax),%eax
 68f:	01 c2                	add    %eax,%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	8b 10                	mov    (%eax),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	89 10                	mov    %edx,(%eax)
 6a3:	eb 0a                	jmp    6af <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	01 d0                	add    %edx,%eax
 6c1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c4:	75 20                	jne    6e6 <free+0xd3>
    p->s.size += bp->s.size;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 50 04             	mov    0x4(%eax),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	01 c2                	add    %eax,%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	8b 10                	mov    (%eax),%edx
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	89 10                	mov    %edx,(%eax)
 6e4:	eb 08                	jmp    6ee <free+0xdb>
  } else
    p->s.ptr = bp;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ec:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	a3 ac 0a 00 00       	mov    %eax,0xaac
}
 6f6:	90                   	nop
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <morecore>:

static Header*
morecore(uint nu)
{
 6f9:	f3 0f 1e fb          	endbr32 
 6fd:	55                   	push   %ebp
 6fe:	89 e5                	mov    %esp,%ebp
 700:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 703:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70a:	77 07                	ja     713 <morecore+0x1a>
    nu = 4096;
 70c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 713:	8b 45 08             	mov    0x8(%ebp),%eax
 716:	c1 e0 03             	shl    $0x3,%eax
 719:	83 ec 0c             	sub    $0xc,%esp
 71c:	50                   	push   %eax
 71d:	e8 5f fc ff ff       	call   381 <sbrk>
 722:	83 c4 10             	add    $0x10,%esp
 725:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 728:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72c:	75 07                	jne    735 <morecore+0x3c>
    return 0;
 72e:	b8 00 00 00 00       	mov    $0x0,%eax
 733:	eb 26                	jmp    75b <morecore+0x62>
  hp = (Header*)p;
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	8b 55 08             	mov    0x8(%ebp),%edx
 741:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 744:	8b 45 f0             	mov    -0x10(%ebp),%eax
 747:	83 c0 08             	add    $0x8,%eax
 74a:	83 ec 0c             	sub    $0xc,%esp
 74d:	50                   	push   %eax
 74e:	e8 c0 fe ff ff       	call   613 <free>
 753:	83 c4 10             	add    $0x10,%esp
  return freep;
 756:	a1 ac 0a 00 00       	mov    0xaac,%eax
}
 75b:	c9                   	leave  
 75c:	c3                   	ret    

0000075d <malloc>:

void*
malloc(uint nbytes)
{
 75d:	f3 0f 1e fb          	endbr32 
 761:	55                   	push   %ebp
 762:	89 e5                	mov    %esp,%ebp
 764:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 767:	8b 45 08             	mov    0x8(%ebp),%eax
 76a:	83 c0 07             	add    $0x7,%eax
 76d:	c1 e8 03             	shr    $0x3,%eax
 770:	83 c0 01             	add    $0x1,%eax
 773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 776:	a1 ac 0a 00 00       	mov    0xaac,%eax
 77b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 782:	75 23                	jne    7a7 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 784:	c7 45 f0 a4 0a 00 00 	movl   $0xaa4,-0x10(%ebp)
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	a3 ac 0a 00 00       	mov    %eax,0xaac
 793:	a1 ac 0a 00 00       	mov    0xaac,%eax
 798:	a3 a4 0a 00 00       	mov    %eax,0xaa4
    base.s.size = 0;
 79d:	c7 05 a8 0a 00 00 00 	movl   $0x0,0xaa8
 7a4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7b8:	77 4d                	ja     807 <malloc+0xaa>
      if(p->s.size == nunits)
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7c3:	75 0c                	jne    7d1 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cd:	89 10                	mov    %edx,(%eax)
 7cf:	eb 26                	jmp    7f7 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7da:	89 c2                	mov    %eax,%edx
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 40 04             	mov    0x4(%eax),%eax
 7e8:	c1 e0 03             	shl    $0x3,%eax
 7eb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	a3 ac 0a 00 00       	mov    %eax,0xaac
      return (void*)(p + 1);
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	83 c0 08             	add    $0x8,%eax
 805:	eb 3b                	jmp    842 <malloc+0xe5>
    }
    if(p == freep)
 807:	a1 ac 0a 00 00       	mov    0xaac,%eax
 80c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80f:	75 1e                	jne    82f <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 811:	83 ec 0c             	sub    $0xc,%esp
 814:	ff 75 ec             	pushl  -0x14(%ebp)
 817:	e8 dd fe ff ff       	call   6f9 <morecore>
 81c:	83 c4 10             	add    $0x10,%esp
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 826:	75 07                	jne    82f <malloc+0xd2>
        return 0;
 828:	b8 00 00 00 00       	mov    $0x0,%eax
 82d:	eb 13                	jmp    842 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83d:	e9 6d ff ff ff       	jmp    7af <malloc+0x52>
  }
}
 842:	c9                   	leave  
 843:	c3                   	ret    
