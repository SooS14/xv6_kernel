
_kill:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	83 ec 10             	sub    $0x10,%esp
  16:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  18:	83 3b 01             	cmpl   $0x1,(%ebx)
  1b:	7f 17                	jg     34 <main+0x34>
    printf(2, "usage: kill pid...\n");
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	68 8a 08 00 00       	push   $0x88a
  25:	6a 02                	push   $0x2
  27:	e8 97 04 00 00       	call   4c3 <printf>
  2c:	83 c4 10             	add    $0x10,%esp
    exit();
  2f:	e8 0b 03 00 00       	call   33f <exit>
  }
  for(i=1; i<argc; i++)
  34:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  3b:	eb 2d                	jmp    6a <main+0x6a>
    kill(atoi(argv[i]));
  3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	01 d0                	add    %edx,%eax
  4c:	8b 00                	mov    (%eax),%eax
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	50                   	push   %eax
  52:	e8 00 02 00 00       	call   257 <atoi>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	50                   	push   %eax
  5e:	e8 0c 03 00 00       	call   36f <kill>
  63:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6d:	3b 03                	cmp    (%ebx),%eax
  6f:	7c cc                	jl     3d <main+0x3d>
  exit();
  71:	e8 c9 02 00 00       	call   33f <exit>

00000076 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	57                   	push   %edi
  7a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7e:	8b 55 10             	mov    0x10(%ebp),%edx
  81:	8b 45 0c             	mov    0xc(%ebp),%eax
  84:	89 cb                	mov    %ecx,%ebx
  86:	89 df                	mov    %ebx,%edi
  88:	89 d1                	mov    %edx,%ecx
  8a:	fc                   	cld    
  8b:	f3 aa                	rep stos %al,%es:(%edi)
  8d:	89 ca                	mov    %ecx,%edx
  8f:	89 fb                	mov    %edi,%ebx
  91:	89 5d 08             	mov    %ebx,0x8(%ebp)
  94:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  97:	90                   	nop
  98:	5b                   	pop    %ebx
  99:	5f                   	pop    %edi
  9a:	5d                   	pop    %ebp
  9b:	c3                   	ret    

0000009c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  9c:	f3 0f 1e fb          	endbr32 
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ac:	90                   	nop
  ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  b0:	8d 42 01             	lea    0x1(%edx),%eax
  b3:	89 45 0c             	mov    %eax,0xc(%ebp)
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	8d 48 01             	lea    0x1(%eax),%ecx
  bc:	89 4d 08             	mov    %ecx,0x8(%ebp)
  bf:	0f b6 12             	movzbl (%edx),%edx
  c2:	88 10                	mov    %dl,(%eax)
  c4:	0f b6 00             	movzbl (%eax),%eax
  c7:	84 c0                	test   %al,%al
  c9:	75 e2                	jne    ad <strcpy+0x11>
    ;
  return os;
  cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ce:	c9                   	leave  
  cf:	c3                   	ret    

000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	f3 0f 1e fb          	endbr32 
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d7:	eb 08                	jmp    e1 <strcmp+0x11>
    p++, q++;
  d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	84 c0                	test   %al,%al
  e9:	74 10                	je     fb <strcmp+0x2b>
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	38 c2                	cmp    %al,%dl
  f9:	74 de                	je     d9 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	0f b6 d0             	movzbl %al,%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 c0             	movzbl %al,%eax
 10d:	29 c2                	sub    %eax,%edx
 10f:	89 d0                	mov    %edx,%eax
}
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    

00000113 <strlen>:

uint
strlen(const char *s)
{
 113:	f3 0f 1e fb          	endbr32 
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 124:	eb 04                	jmp    12a <strlen+0x17>
 126:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	01 d0                	add    %edx,%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	84 c0                	test   %al,%al
 137:	75 ed                	jne    126 <strlen+0x13>
    ;
  return n;
 139:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	f3 0f 1e fb          	endbr32 
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 145:	8b 45 10             	mov    0x10(%ebp),%eax
 148:	50                   	push   %eax
 149:	ff 75 0c             	pushl  0xc(%ebp)
 14c:	ff 75 08             	pushl  0x8(%ebp)
 14f:	e8 22 ff ff ff       	call   76 <stosb>
 154:	83 c4 0c             	add    $0xc,%esp
  return dst;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15a:	c9                   	leave  
 15b:	c3                   	ret    

0000015c <strchr>:

char*
strchr(const char *s, char c)
{
 15c:	f3 0f 1e fb          	endbr32 
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 04             	sub    $0x4,%esp
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16c:	eb 14                	jmp    182 <strchr+0x26>
    if(*s == c)
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	38 45 fc             	cmp    %al,-0x4(%ebp)
 177:	75 05                	jne    17e <strchr+0x22>
      return (char*)s;
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	eb 13                	jmp    191 <strchr+0x35>
  for(; *s; s++)
 17e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	75 e2                	jne    16e <strchr+0x12>
  return 0;
 18c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 191:	c9                   	leave  
 192:	c3                   	ret    

00000193 <gets>:

char*
gets(char *buf, int max)
{
 193:	f3 0f 1e fb          	endbr32 
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a4:	eb 42                	jmp    1e8 <gets+0x55>
    cc = read(0, &c, 1);
 1a6:	83 ec 04             	sub    $0x4,%esp
 1a9:	6a 01                	push   $0x1
 1ab:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ae:	50                   	push   %eax
 1af:	6a 00                	push   $0x0
 1b1:	e8 a1 01 00 00       	call   357 <read>
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c0:	7e 33                	jle    1f5 <gets+0x62>
      break;
    buf[i++] = c;
 1c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c5:	8d 50 01             	lea    0x1(%eax),%edx
 1c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cb:	89 c2                	mov    %eax,%edx
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	01 c2                	add    %eax,%edx
 1d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 16                	je     1f6 <gets+0x63>
 1e0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e4:	3c 0d                	cmp    $0xd,%al
 1e6:	74 0e                	je     1f6 <gets+0x63>
  for(i=0; i+1 < max; ){
 1e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1eb:	83 c0 01             	add    $0x1,%eax
 1ee:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f1:	7f b3                	jg     1a6 <gets+0x13>
 1f3:	eb 01                	jmp    1f6 <gets+0x63>
      break;
 1f5:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(const char *n, struct stat *st)
{
 206:	f3 0f 1e fb          	endbr32 
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	6a 00                	push   $0x0
 215:	ff 75 08             	pushl  0x8(%ebp)
 218:	e8 62 01 00 00       	call   37f <open>
 21d:	83 c4 10             	add    $0x10,%esp
 220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 227:	79 07                	jns    230 <stat+0x2a>
    return -1;
 229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22e:	eb 25                	jmp    255 <stat+0x4f>
  r = fstat(fd, st);
 230:	83 ec 08             	sub    $0x8,%esp
 233:	ff 75 0c             	pushl  0xc(%ebp)
 236:	ff 75 f4             	pushl  -0xc(%ebp)
 239:	e8 59 01 00 00       	call   397 <fstat>
 23e:	83 c4 10             	add    $0x10,%esp
 241:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 244:	83 ec 0c             	sub    $0xc,%esp
 247:	ff 75 f4             	pushl  -0xc(%ebp)
 24a:	e8 18 01 00 00       	call   367 <close>
 24f:	83 c4 10             	add    $0x10,%esp
  return r;
 252:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <atoi>:



int
atoi(const char *s)
{
 257:	f3 0f 1e fb          	endbr32 
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 261:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 2d                	cmp    $0x2d,%al
 270:	75 6b                	jne    2dd <atoi+0x86>
  {
    s++;
 272:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 276:	eb 25                	jmp    29d <atoi+0x46>
        n = n*10 + *s++ - '0';
 278:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27b:	89 d0                	mov    %edx,%eax
 27d:	c1 e0 02             	shl    $0x2,%eax
 280:	01 d0                	add    %edx,%eax
 282:	01 c0                	add    %eax,%eax
 284:	89 c1                	mov    %eax,%ecx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 08             	mov    %edx,0x8(%ebp)
 28f:	0f b6 00             	movzbl (%eax),%eax
 292:	0f be c0             	movsbl %al,%eax
 295:	01 c8                	add    %ecx,%eax
 297:	83 e8 30             	sub    $0x30,%eax
 29a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	3c 2f                	cmp    $0x2f,%al
 2a5:	7e 0a                	jle    2b1 <atoi+0x5a>
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 39                	cmp    $0x39,%al
 2af:	7e c7                	jle    278 <atoi+0x21>

    return -n;
 2b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b4:	f7 d8                	neg    %eax
 2b6:	eb 3c                	jmp    2f4 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 2b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2bb:	89 d0                	mov    %edx,%eax
 2bd:	c1 e0 02             	shl    $0x2,%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	01 c0                	add    %eax,%eax
 2c4:	89 c1                	mov    %eax,%ecx
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	8d 50 01             	lea    0x1(%eax),%edx
 2cc:	89 55 08             	mov    %edx,0x8(%ebp)
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	0f be c0             	movsbl %al,%eax
 2d5:	01 c8                	add    %ecx,%eax
 2d7:	83 e8 30             	sub    $0x30,%eax
 2da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	0f b6 00             	movzbl (%eax),%eax
 2e3:	3c 2f                	cmp    $0x2f,%al
 2e5:	7e 0a                	jle    2f1 <atoi+0x9a>
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	3c 39                	cmp    $0x39,%al
 2ef:	7e c7                	jle    2b8 <atoi+0x61>

    return n;
 2f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f6:	f3 0f 1e fb          	endbr32 
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 306:	8b 45 0c             	mov    0xc(%ebp),%eax
 309:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 30c:	eb 17                	jmp    325 <memmove+0x2f>
    *dst++ = *src++;
 30e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 311:	8d 42 01             	lea    0x1(%edx),%eax
 314:	89 45 f8             	mov    %eax,-0x8(%ebp)
 317:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31a:	8d 48 01             	lea    0x1(%eax),%ecx
 31d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 320:	0f b6 12             	movzbl (%edx),%edx
 323:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 325:	8b 45 10             	mov    0x10(%ebp),%eax
 328:	8d 50 ff             	lea    -0x1(%eax),%edx
 32b:	89 55 10             	mov    %edx,0x10(%ebp)
 32e:	85 c0                	test   %eax,%eax
 330:	7f dc                	jg     30e <memmove+0x18>
  return vdst;
 332:	8b 45 08             	mov    0x8(%ebp),%eax
}
 335:	c9                   	leave  
 336:	c3                   	ret    

00000337 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 337:	b8 01 00 00 00       	mov    $0x1,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <exit>:
SYSCALL(exit)
 33f:	b8 02 00 00 00       	mov    $0x2,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <wait>:
SYSCALL(wait)
 347:	b8 03 00 00 00       	mov    $0x3,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <pipe>:
SYSCALL(pipe)
 34f:	b8 04 00 00 00       	mov    $0x4,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <read>:
SYSCALL(read)
 357:	b8 05 00 00 00       	mov    $0x5,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <write>:
SYSCALL(write)
 35f:	b8 10 00 00 00       	mov    $0x10,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <close>:
SYSCALL(close)
 367:	b8 15 00 00 00       	mov    $0x15,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <kill>:
SYSCALL(kill)
 36f:	b8 06 00 00 00       	mov    $0x6,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <exec>:
SYSCALL(exec)
 377:	b8 07 00 00 00       	mov    $0x7,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <open>:
SYSCALL(open)
 37f:	b8 0f 00 00 00       	mov    $0xf,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <mknod>:
SYSCALL(mknod)
 387:	b8 11 00 00 00       	mov    $0x11,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <unlink>:
SYSCALL(unlink)
 38f:	b8 12 00 00 00       	mov    $0x12,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <fstat>:
SYSCALL(fstat)
 397:	b8 08 00 00 00       	mov    $0x8,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <link>:
SYSCALL(link)
 39f:	b8 13 00 00 00       	mov    $0x13,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <mkdir>:
SYSCALL(mkdir)
 3a7:	b8 14 00 00 00       	mov    $0x14,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <chdir>:
SYSCALL(chdir)
 3af:	b8 09 00 00 00       	mov    $0x9,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <dup>:
SYSCALL(dup)
 3b7:	b8 0a 00 00 00       	mov    $0xa,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <getpid>:
SYSCALL(getpid)
 3bf:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <sbrk>:
SYSCALL(sbrk)
 3c7:	b8 0c 00 00 00       	mov    $0xc,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <sleep>:
SYSCALL(sleep)
 3cf:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <uptime>:
SYSCALL(uptime)
 3d7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <lseek>:
SYSCALL(lseek)
 3df:	b8 16 00 00 00       	mov    $0x16,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e7:	f3 0f 1e fb          	endbr32 
 3eb:	55                   	push   %ebp
 3ec:	89 e5                	mov    %esp,%ebp
 3ee:	83 ec 18             	sub    $0x18,%esp
 3f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f7:	83 ec 04             	sub    $0x4,%esp
 3fa:	6a 01                	push   $0x1
 3fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ff:	50                   	push   %eax
 400:	ff 75 08             	pushl  0x8(%ebp)
 403:	e8 57 ff ff ff       	call   35f <write>
 408:	83 c4 10             	add    $0x10,%esp
}
 40b:	90                   	nop
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40e:	f3 0f 1e fb          	endbr32 
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 418:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 41f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 423:	74 17                	je     43c <printint+0x2e>
 425:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 429:	79 11                	jns    43c <printint+0x2e>
    neg = 1;
 42b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	f7 d8                	neg    %eax
 437:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43a:	eb 06                	jmp    442 <printint+0x34>
  } else {
    x = xx;
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 442:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 449:	8b 4d 10             	mov    0x10(%ebp),%ecx
 44c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44f:	ba 00 00 00 00       	mov    $0x0,%edx
 454:	f7 f1                	div    %ecx
 456:	89 d1                	mov    %edx,%ecx
 458:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45b:	8d 50 01             	lea    0x1(%eax),%edx
 45e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 461:	0f b6 91 f0 0a 00 00 	movzbl 0xaf0(%ecx),%edx
 468:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 46c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 472:	ba 00 00 00 00       	mov    $0x0,%edx
 477:	f7 f1                	div    %ecx
 479:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 480:	75 c7                	jne    449 <printint+0x3b>
  if(neg)
 482:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 486:	74 2d                	je     4b5 <printint+0xa7>
    buf[i++] = '-';
 488:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48b:	8d 50 01             	lea    0x1(%eax),%edx
 48e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 491:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 496:	eb 1d                	jmp    4b5 <printint+0xa7>
    putc(fd, buf[i]);
 498:	8d 55 dc             	lea    -0x24(%ebp),%edx
 49b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49e:	01 d0                	add    %edx,%eax
 4a0:	0f b6 00             	movzbl (%eax),%eax
 4a3:	0f be c0             	movsbl %al,%eax
 4a6:	83 ec 08             	sub    $0x8,%esp
 4a9:	50                   	push   %eax
 4aa:	ff 75 08             	pushl  0x8(%ebp)
 4ad:	e8 35 ff ff ff       	call   3e7 <putc>
 4b2:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4b5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bd:	79 d9                	jns    498 <printint+0x8a>
}
 4bf:	90                   	nop
 4c0:	90                   	nop
 4c1:	c9                   	leave  
 4c2:	c3                   	ret    

000004c3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c3:	f3 0f 1e fb          	endbr32 
 4c7:	55                   	push   %ebp
 4c8:	89 e5                	mov    %esp,%ebp
 4ca:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d7:	83 c0 04             	add    $0x4,%eax
 4da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e4:	e9 59 01 00 00       	jmp    642 <printf+0x17f>
    c = fmt[i] & 0xff;
 4e9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ef:	01 d0                	add    %edx,%eax
 4f1:	0f b6 00             	movzbl (%eax),%eax
 4f4:	0f be c0             	movsbl %al,%eax
 4f7:	25 ff 00 00 00       	and    $0xff,%eax
 4fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 503:	75 2c                	jne    531 <printf+0x6e>
      if(c == '%'){
 505:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 509:	75 0c                	jne    517 <printf+0x54>
        state = '%';
 50b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 512:	e9 27 01 00 00       	jmp    63e <printf+0x17b>
      } else {
        putc(fd, c);
 517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51a:	0f be c0             	movsbl %al,%eax
 51d:	83 ec 08             	sub    $0x8,%esp
 520:	50                   	push   %eax
 521:	ff 75 08             	pushl  0x8(%ebp)
 524:	e8 be fe ff ff       	call   3e7 <putc>
 529:	83 c4 10             	add    $0x10,%esp
 52c:	e9 0d 01 00 00       	jmp    63e <printf+0x17b>
      }
    } else if(state == '%'){
 531:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 535:	0f 85 03 01 00 00    	jne    63e <printf+0x17b>
      if(c == 'd'){
 53b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 53f:	75 1e                	jne    55f <printf+0x9c>
        printint(fd, *ap, 10, 1);
 541:	8b 45 e8             	mov    -0x18(%ebp),%eax
 544:	8b 00                	mov    (%eax),%eax
 546:	6a 01                	push   $0x1
 548:	6a 0a                	push   $0xa
 54a:	50                   	push   %eax
 54b:	ff 75 08             	pushl  0x8(%ebp)
 54e:	e8 bb fe ff ff       	call   40e <printint>
 553:	83 c4 10             	add    $0x10,%esp
        ap++;
 556:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55a:	e9 d8 00 00 00       	jmp    637 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 55f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 563:	74 06                	je     56b <printf+0xa8>
 565:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 569:	75 1e                	jne    589 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 56b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56e:	8b 00                	mov    (%eax),%eax
 570:	6a 00                	push   $0x0
 572:	6a 10                	push   $0x10
 574:	50                   	push   %eax
 575:	ff 75 08             	pushl  0x8(%ebp)
 578:	e8 91 fe ff ff       	call   40e <printint>
 57d:	83 c4 10             	add    $0x10,%esp
        ap++;
 580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 584:	e9 ae 00 00 00       	jmp    637 <printf+0x174>
      } else if(c == 's'){
 589:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58d:	75 43                	jne    5d2 <printf+0x10f>
        s = (char*)*ap;
 58f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 592:	8b 00                	mov    (%eax),%eax
 594:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 597:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59f:	75 25                	jne    5c6 <printf+0x103>
          s = "(null)";
 5a1:	c7 45 f4 9e 08 00 00 	movl   $0x89e,-0xc(%ebp)
        while(*s != 0){
 5a8:	eb 1c                	jmp    5c6 <printf+0x103>
          putc(fd, *s);
 5aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	83 ec 08             	sub    $0x8,%esp
 5b6:	50                   	push   %eax
 5b7:	ff 75 08             	pushl  0x8(%ebp)
 5ba:	e8 28 fe ff ff       	call   3e7 <putc>
 5bf:	83 c4 10             	add    $0x10,%esp
          s++;
 5c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c9:	0f b6 00             	movzbl (%eax),%eax
 5cc:	84 c0                	test   %al,%al
 5ce:	75 da                	jne    5aa <printf+0xe7>
 5d0:	eb 65                	jmp    637 <printf+0x174>
        }
      } else if(c == 'c'){
 5d2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d6:	75 1d                	jne    5f5 <printf+0x132>
        putc(fd, *ap);
 5d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5db:	8b 00                	mov    (%eax),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	83 ec 08             	sub    $0x8,%esp
 5e3:	50                   	push   %eax
 5e4:	ff 75 08             	pushl  0x8(%ebp)
 5e7:	e8 fb fd ff ff       	call   3e7 <putc>
 5ec:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f3:	eb 42                	jmp    637 <printf+0x174>
      } else if(c == '%'){
 5f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f9:	75 17                	jne    612 <printf+0x14f>
        putc(fd, c);
 5fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	83 ec 08             	sub    $0x8,%esp
 604:	50                   	push   %eax
 605:	ff 75 08             	pushl  0x8(%ebp)
 608:	e8 da fd ff ff       	call   3e7 <putc>
 60d:	83 c4 10             	add    $0x10,%esp
 610:	eb 25                	jmp    637 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 612:	83 ec 08             	sub    $0x8,%esp
 615:	6a 25                	push   $0x25
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 c8 fd ff ff       	call   3e7 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 625:	0f be c0             	movsbl %al,%eax
 628:	83 ec 08             	sub    $0x8,%esp
 62b:	50                   	push   %eax
 62c:	ff 75 08             	pushl  0x8(%ebp)
 62f:	e8 b3 fd ff ff       	call   3e7 <putc>
 634:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 637:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 63e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 642:	8b 55 0c             	mov    0xc(%ebp),%edx
 645:	8b 45 f0             	mov    -0x10(%ebp),%eax
 648:	01 d0                	add    %edx,%eax
 64a:	0f b6 00             	movzbl (%eax),%eax
 64d:	84 c0                	test   %al,%al
 64f:	0f 85 94 fe ff ff    	jne    4e9 <printf+0x26>
    }
  }
}
 655:	90                   	nop
 656:	90                   	nop
 657:	c9                   	leave  
 658:	c3                   	ret    

00000659 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 659:	f3 0f 1e fb          	endbr32 
 65d:	55                   	push   %ebp
 65e:	89 e5                	mov    %esp,%ebp
 660:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	83 e8 08             	sub    $0x8,%eax
 669:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 671:	89 45 fc             	mov    %eax,-0x4(%ebp)
 674:	eb 24                	jmp    69a <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 67e:	72 12                	jb     692 <free+0x39>
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 686:	77 24                	ja     6ac <free+0x53>
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 690:	72 1a                	jb     6ac <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a0:	76 d4                	jbe    676 <free+0x1d>
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6aa:	73 ca                	jae    676 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	01 c2                	add    %eax,%edx
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	39 c2                	cmp    %eax,%edx
 6c5:	75 24                	jne    6eb <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 50 04             	mov    0x4(%eax),%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	89 10                	mov    %edx,(%eax)
 6e9:	eb 0a                	jmp    6f5 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 10                	mov    (%eax),%edx
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 40 04             	mov    0x4(%eax),%eax
 6fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	01 d0                	add    %edx,%eax
 707:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 70a:	75 20                	jne    72c <free+0xd3>
    p->s.size += bp->s.size;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 50 04             	mov    0x4(%eax),%edx
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	01 c2                	add    %eax,%edx
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	8b 10                	mov    (%eax),%edx
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	89 10                	mov    %edx,(%eax)
 72a:	eb 08                	jmp    734 <free+0xdb>
  } else
    p->s.ptr = bp;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 732:	89 10                	mov    %edx,(%eax)
  freep = p;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	a3 0c 0b 00 00       	mov    %eax,0xb0c
}
 73c:	90                   	nop
 73d:	c9                   	leave  
 73e:	c3                   	ret    

0000073f <morecore>:

static Header*
morecore(uint nu)
{
 73f:	f3 0f 1e fb          	endbr32 
 743:	55                   	push   %ebp
 744:	89 e5                	mov    %esp,%ebp
 746:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 749:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 750:	77 07                	ja     759 <morecore+0x1a>
    nu = 4096;
 752:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 759:	8b 45 08             	mov    0x8(%ebp),%eax
 75c:	c1 e0 03             	shl    $0x3,%eax
 75f:	83 ec 0c             	sub    $0xc,%esp
 762:	50                   	push   %eax
 763:	e8 5f fc ff ff       	call   3c7 <sbrk>
 768:	83 c4 10             	add    $0x10,%esp
 76b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 772:	75 07                	jne    77b <morecore+0x3c>
    return 0;
 774:	b8 00 00 00 00       	mov    $0x0,%eax
 779:	eb 26                	jmp    7a1 <morecore+0x62>
  hp = (Header*)p;
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	8b 55 08             	mov    0x8(%ebp),%edx
 787:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	83 c0 08             	add    $0x8,%eax
 790:	83 ec 0c             	sub    $0xc,%esp
 793:	50                   	push   %eax
 794:	e8 c0 fe ff ff       	call   659 <free>
 799:	83 c4 10             	add    $0x10,%esp
  return freep;
 79c:	a1 0c 0b 00 00       	mov    0xb0c,%eax
}
 7a1:	c9                   	leave  
 7a2:	c3                   	ret    

000007a3 <malloc>:

void*
malloc(uint nbytes)
{
 7a3:	f3 0f 1e fb          	endbr32 
 7a7:	55                   	push   %ebp
 7a8:	89 e5                	mov    %esp,%ebp
 7aa:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ad:	8b 45 08             	mov    0x8(%ebp),%eax
 7b0:	83 c0 07             	add    $0x7,%eax
 7b3:	c1 e8 03             	shr    $0x3,%eax
 7b6:	83 c0 01             	add    $0x1,%eax
 7b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bc:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 7c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c8:	75 23                	jne    7ed <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7ca:	c7 45 f0 04 0b 00 00 	movl   $0xb04,-0x10(%ebp)
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	a3 0c 0b 00 00       	mov    %eax,0xb0c
 7d9:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 7de:	a3 04 0b 00 00       	mov    %eax,0xb04
    base.s.size = 0;
 7e3:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 7ea:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7fe:	77 4d                	ja     84d <malloc+0xaa>
      if(p->s.size == nunits)
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 809:	75 0c                	jne    817 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 10                	mov    (%eax),%edx
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	89 10                	mov    %edx,(%eax)
 815:	eb 26                	jmp    83d <malloc+0x9a>
      else {
        p->s.size -= nunits;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 820:	89 c2                	mov    %eax,%edx
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	c1 e0 03             	shl    $0x3,%eax
 831:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 840:	a3 0c 0b 00 00       	mov    %eax,0xb0c
      return (void*)(p + 1);
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	83 c0 08             	add    $0x8,%eax
 84b:	eb 3b                	jmp    888 <malloc+0xe5>
    }
    if(p == freep)
 84d:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 852:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 855:	75 1e                	jne    875 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 857:	83 ec 0c             	sub    $0xc,%esp
 85a:	ff 75 ec             	pushl  -0x14(%ebp)
 85d:	e8 dd fe ff ff       	call   73f <morecore>
 862:	83 c4 10             	add    $0x10,%esp
 865:	89 45 f4             	mov    %eax,-0xc(%ebp)
 868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86c:	75 07                	jne    875 <malloc+0xd2>
        return 0;
 86e:	b8 00 00 00 00       	mov    $0x0,%eax
 873:	eb 13                	jmp    888 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 00                	mov    (%eax),%eax
 880:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 883:	e9 6d ff ff ff       	jmp    7f5 <malloc+0x52>
  }
}
 888:	c9                   	leave  
 889:	c3                   	ret    
