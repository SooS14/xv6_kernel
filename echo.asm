
_echo:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  for(i = 1; i < argc; i++)
  18:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1f:	eb 3c                	jmp    5d <main+0x5d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  24:	83 c0 01             	add    $0x1,%eax
  27:	39 03                	cmp    %eax,(%ebx)
  29:	7e 07                	jle    32 <main+0x32>
  2b:	b9 7d 08 00 00       	mov    $0x87d,%ecx
  30:	eb 05                	jmp    37 <main+0x37>
  32:	b9 7f 08 00 00       	mov    $0x87f,%ecx
  37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  41:	8b 43 04             	mov    0x4(%ebx),%eax
  44:	01 d0                	add    %edx,%eax
  46:	8b 00                	mov    (%eax),%eax
  48:	51                   	push   %ecx
  49:	50                   	push   %eax
  4a:	68 81 08 00 00       	push   $0x881
  4f:	6a 01                	push   $0x1
  51:	e8 60 04 00 00       	call   4b6 <printf>
  56:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  60:	3b 03                	cmp    (%ebx),%eax
  62:	7c bd                	jl     21 <main+0x21>
  exit();
  64:	e8 c9 02 00 00       	call   332 <exit>

00000069 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  69:	55                   	push   %ebp
  6a:	89 e5                	mov    %esp,%ebp
  6c:	57                   	push   %edi
  6d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  71:	8b 55 10             	mov    0x10(%ebp),%edx
  74:	8b 45 0c             	mov    0xc(%ebp),%eax
  77:	89 cb                	mov    %ecx,%ebx
  79:	89 df                	mov    %ebx,%edi
  7b:	89 d1                	mov    %edx,%ecx
  7d:	fc                   	cld    
  7e:	f3 aa                	rep stos %al,%es:(%edi)
  80:	89 ca                	mov    %ecx,%edx
  82:	89 fb                	mov    %edi,%ebx
  84:	89 5d 08             	mov    %ebx,0x8(%ebp)
  87:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8a:	90                   	nop
  8b:	5b                   	pop    %ebx
  8c:	5f                   	pop    %edi
  8d:	5d                   	pop    %ebp
  8e:	c3                   	ret    

0000008f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  8f:	f3 0f 1e fb          	endbr32 
  93:	55                   	push   %ebp
  94:	89 e5                	mov    %esp,%ebp
  96:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9f:	90                   	nop
  a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  a3:	8d 42 01             	lea    0x1(%edx),%eax
  a6:	89 45 0c             	mov    %eax,0xc(%ebp)
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	8d 48 01             	lea    0x1(%eax),%ecx
  af:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b2:	0f b6 12             	movzbl (%edx),%edx
  b5:	88 10                	mov    %dl,(%eax)
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	84 c0                	test   %al,%al
  bc:	75 e2                	jne    a0 <strcpy+0x11>
    ;
  return os;
  be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c1:	c9                   	leave  
  c2:	c3                   	ret    

000000c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c3:	f3 0f 1e fb          	endbr32 
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ca:	eb 08                	jmp    d4 <strcmp+0x11>
    p++, q++;
  cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 00             	movzbl (%eax),%eax
  da:	84 c0                	test   %al,%al
  dc:	74 10                	je     ee <strcmp+0x2b>
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	0f b6 10             	movzbl (%eax),%edx
  e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	38 c2                	cmp    %al,%dl
  ec:	74 de                	je     cc <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	0f b6 d0             	movzbl %al,%edx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	0f b6 00             	movzbl (%eax),%eax
  fd:	0f b6 c0             	movzbl %al,%eax
 100:	29 c2                	sub    %eax,%edx
 102:	89 d0                	mov    %edx,%eax
}
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <strlen>:

uint
strlen(const char *s)
{
 106:	f3 0f 1e fb          	endbr32 
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 117:	eb 04                	jmp    11d <strlen+0x17>
 119:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	01 d0                	add    %edx,%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	84 c0                	test   %al,%al
 12a:	75 ed                	jne    119 <strlen+0x13>
    ;
  return n;
 12c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <memset>:

void*
memset(void *dst, int c, uint n)
{
 131:	f3 0f 1e fb          	endbr32 
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 138:	8b 45 10             	mov    0x10(%ebp),%eax
 13b:	50                   	push   %eax
 13c:	ff 75 0c             	pushl  0xc(%ebp)
 13f:	ff 75 08             	pushl  0x8(%ebp)
 142:	e8 22 ff ff ff       	call   69 <stosb>
 147:	83 c4 0c             	add    $0xc,%esp
  return dst;
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <strchr>:

char*
strchr(const char *s, char c)
{
 14f:	f3 0f 1e fb          	endbr32 
 153:	55                   	push   %ebp
 154:	89 e5                	mov    %esp,%ebp
 156:	83 ec 04             	sub    $0x4,%esp
 159:	8b 45 0c             	mov    0xc(%ebp),%eax
 15c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15f:	eb 14                	jmp    175 <strchr+0x26>
    if(*s == c)
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	38 45 fc             	cmp    %al,-0x4(%ebp)
 16a:	75 05                	jne    171 <strchr+0x22>
      return (char*)s;
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	eb 13                	jmp    184 <strchr+0x35>
  for(; *s; s++)
 171:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	0f b6 00             	movzbl (%eax),%eax
 17b:	84 c0                	test   %al,%al
 17d:	75 e2                	jne    161 <strchr+0x12>
  return 0;
 17f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 184:	c9                   	leave  
 185:	c3                   	ret    

00000186 <gets>:

char*
gets(char *buf, int max)
{
 186:	f3 0f 1e fb          	endbr32 
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 197:	eb 42                	jmp    1db <gets+0x55>
    cc = read(0, &c, 1);
 199:	83 ec 04             	sub    $0x4,%esp
 19c:	6a 01                	push   $0x1
 19e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a1:	50                   	push   %eax
 1a2:	6a 00                	push   $0x0
 1a4:	e8 a1 01 00 00       	call   34a <read>
 1a9:	83 c4 10             	add    $0x10,%esp
 1ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b3:	7e 33                	jle    1e8 <gets+0x62>
      break;
    buf[i++] = c;
 1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b8:	8d 50 01             	lea    0x1(%eax),%edx
 1bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1be:	89 c2                	mov    %eax,%edx
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	01 c2                	add    %eax,%edx
 1c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cf:	3c 0a                	cmp    $0xa,%al
 1d1:	74 16                	je     1e9 <gets+0x63>
 1d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d7:	3c 0d                	cmp    $0xd,%al
 1d9:	74 0e                	je     1e9 <gets+0x63>
  for(i=0; i+1 < max; ){
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	83 c0 01             	add    $0x1,%eax
 1e1:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1e4:	7f b3                	jg     199 <gets+0x13>
 1e6:	eb 01                	jmp    1e9 <gets+0x63>
      break;
 1e8:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	01 d0                	add    %edx,%eax
 1f1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f9:	f3 0f 1e fb          	endbr32 
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	6a 00                	push   $0x0
 208:	ff 75 08             	pushl  0x8(%ebp)
 20b:	e8 62 01 00 00       	call   372 <open>
 210:	83 c4 10             	add    $0x10,%esp
 213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21a:	79 07                	jns    223 <stat+0x2a>
    return -1;
 21c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 221:	eb 25                	jmp    248 <stat+0x4f>
  r = fstat(fd, st);
 223:	83 ec 08             	sub    $0x8,%esp
 226:	ff 75 0c             	pushl  0xc(%ebp)
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 59 01 00 00       	call   38a <fstat>
 231:	83 c4 10             	add    $0x10,%esp
 234:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 237:	83 ec 0c             	sub    $0xc,%esp
 23a:	ff 75 f4             	pushl  -0xc(%ebp)
 23d:	e8 18 01 00 00       	call   35a <close>
 242:	83 c4 10             	add    $0x10,%esp
  return r;
 245:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 248:	c9                   	leave  
 249:	c3                   	ret    

0000024a <atoi>:



int
atoi(const char *s)
{
 24a:	f3 0f 1e fb          	endbr32 
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	3c 2d                	cmp    $0x2d,%al
 263:	75 6b                	jne    2d0 <atoi+0x86>
  {
    s++;
 265:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 269:	eb 25                	jmp    290 <atoi+0x46>
        n = n*10 + *s++ - '0';
 26b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26e:	89 d0                	mov    %edx,%eax
 270:	c1 e0 02             	shl    $0x2,%eax
 273:	01 d0                	add    %edx,%eax
 275:	01 c0                	add    %eax,%eax
 277:	89 c1                	mov    %eax,%ecx
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	8d 50 01             	lea    0x1(%eax),%edx
 27f:	89 55 08             	mov    %edx,0x8(%ebp)
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	0f be c0             	movsbl %al,%eax
 288:	01 c8                	add    %ecx,%eax
 28a:	83 e8 30             	sub    $0x30,%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	3c 2f                	cmp    $0x2f,%al
 298:	7e 0a                	jle    2a4 <atoi+0x5a>
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	0f b6 00             	movzbl (%eax),%eax
 2a0:	3c 39                	cmp    $0x39,%al
 2a2:	7e c7                	jle    26b <atoi+0x21>

    return -n;
 2a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a7:	f7 d8                	neg    %eax
 2a9:	eb 3c                	jmp    2e7 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 2ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ae:	89 d0                	mov    %edx,%eax
 2b0:	c1 e0 02             	shl    $0x2,%eax
 2b3:	01 d0                	add    %edx,%eax
 2b5:	01 c0                	add    %eax,%eax
 2b7:	89 c1                	mov    %eax,%ecx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	8d 50 01             	lea    0x1(%eax),%edx
 2bf:	89 55 08             	mov    %edx,0x8(%ebp)
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	0f be c0             	movsbl %al,%eax
 2c8:	01 c8                	add    %ecx,%eax
 2ca:	83 e8 30             	sub    $0x30,%eax
 2cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 00             	movzbl (%eax),%eax
 2d6:	3c 2f                	cmp    $0x2f,%al
 2d8:	7e 0a                	jle    2e4 <atoi+0x9a>
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	0f b6 00             	movzbl (%eax),%eax
 2e0:	3c 39                	cmp    $0x39,%al
 2e2:	7e c7                	jle    2ab <atoi+0x61>

    return n;
 2e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e9:	f3 0f 1e fb          	endbr32 
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ff:	eb 17                	jmp    318 <memmove+0x2f>
    *dst++ = *src++;
 301:	8b 55 f8             	mov    -0x8(%ebp),%edx
 304:	8d 42 01             	lea    0x1(%edx),%eax
 307:	89 45 f8             	mov    %eax,-0x8(%ebp)
 30a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 30d:	8d 48 01             	lea    0x1(%eax),%ecx
 310:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 313:	0f b6 12             	movzbl (%edx),%edx
 316:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	8d 50 ff             	lea    -0x1(%eax),%edx
 31e:	89 55 10             	mov    %edx,0x10(%ebp)
 321:	85 c0                	test   %eax,%eax
 323:	7f dc                	jg     301 <memmove+0x18>
  return vdst;
 325:	8b 45 08             	mov    0x8(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32a:	b8 01 00 00 00       	mov    $0x1,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <exit>:
SYSCALL(exit)
 332:	b8 02 00 00 00       	mov    $0x2,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <wait>:
SYSCALL(wait)
 33a:	b8 03 00 00 00       	mov    $0x3,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <pipe>:
SYSCALL(pipe)
 342:	b8 04 00 00 00       	mov    $0x4,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <read>:
SYSCALL(read)
 34a:	b8 05 00 00 00       	mov    $0x5,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <write>:
SYSCALL(write)
 352:	b8 10 00 00 00       	mov    $0x10,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <close>:
SYSCALL(close)
 35a:	b8 15 00 00 00       	mov    $0x15,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <kill>:
SYSCALL(kill)
 362:	b8 06 00 00 00       	mov    $0x6,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <exec>:
SYSCALL(exec)
 36a:	b8 07 00 00 00       	mov    $0x7,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <open>:
SYSCALL(open)
 372:	b8 0f 00 00 00       	mov    $0xf,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mknod>:
SYSCALL(mknod)
 37a:	b8 11 00 00 00       	mov    $0x11,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <unlink>:
SYSCALL(unlink)
 382:	b8 12 00 00 00       	mov    $0x12,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <fstat>:
SYSCALL(fstat)
 38a:	b8 08 00 00 00       	mov    $0x8,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <link>:
SYSCALL(link)
 392:	b8 13 00 00 00       	mov    $0x13,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mkdir>:
SYSCALL(mkdir)
 39a:	b8 14 00 00 00       	mov    $0x14,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <chdir>:
SYSCALL(chdir)
 3a2:	b8 09 00 00 00       	mov    $0x9,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <dup>:
SYSCALL(dup)
 3aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <getpid>:
SYSCALL(getpid)
 3b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <sbrk>:
SYSCALL(sbrk)
 3ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <sleep>:
SYSCALL(sleep)
 3c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <uptime>:
SYSCALL(uptime)
 3ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <lseek>:
SYSCALL(lseek)
 3d2:	b8 16 00 00 00       	mov    $0x16,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3da:	f3 0f 1e fb          	endbr32 
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	83 ec 18             	sub    $0x18,%esp
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ea:	83 ec 04             	sub    $0x4,%esp
 3ed:	6a 01                	push   $0x1
 3ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f2:	50                   	push   %eax
 3f3:	ff 75 08             	pushl  0x8(%ebp)
 3f6:	e8 57 ff ff ff       	call   352 <write>
 3fb:	83 c4 10             	add    $0x10,%esp
}
 3fe:	90                   	nop
 3ff:	c9                   	leave  
 400:	c3                   	ret    

00000401 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 401:	f3 0f 1e fb          	endbr32 
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 412:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 416:	74 17                	je     42f <printint+0x2e>
 418:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 41c:	79 11                	jns    42f <printint+0x2e>
    neg = 1;
 41e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 425:	8b 45 0c             	mov    0xc(%ebp),%eax
 428:	f7 d8                	neg    %eax
 42a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42d:	eb 06                	jmp    435 <printint+0x34>
  } else {
    x = xx;
 42f:	8b 45 0c             	mov    0xc(%ebp),%eax
 432:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 435:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 43c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 442:	ba 00 00 00 00       	mov    $0x0,%edx
 447:	f7 f1                	div    %ecx
 449:	89 d1                	mov    %edx,%ecx
 44b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44e:	8d 50 01             	lea    0x1(%eax),%edx
 451:	89 55 f4             	mov    %edx,-0xc(%ebp)
 454:	0f b6 91 d8 0a 00 00 	movzbl 0xad8(%ecx),%edx
 45b:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 45f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 462:	8b 45 ec             	mov    -0x14(%ebp),%eax
 465:	ba 00 00 00 00       	mov    $0x0,%edx
 46a:	f7 f1                	div    %ecx
 46c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 473:	75 c7                	jne    43c <printint+0x3b>
  if(neg)
 475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 479:	74 2d                	je     4a8 <printint+0xa7>
    buf[i++] = '-';
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	8d 50 01             	lea    0x1(%eax),%edx
 481:	89 55 f4             	mov    %edx,-0xc(%ebp)
 484:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 489:	eb 1d                	jmp    4a8 <printint+0xa7>
    putc(fd, buf[i]);
 48b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 48e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 491:	01 d0                	add    %edx,%eax
 493:	0f b6 00             	movzbl (%eax),%eax
 496:	0f be c0             	movsbl %al,%eax
 499:	83 ec 08             	sub    $0x8,%esp
 49c:	50                   	push   %eax
 49d:	ff 75 08             	pushl  0x8(%ebp)
 4a0:	e8 35 ff ff ff       	call   3da <putc>
 4a5:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4a8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b0:	79 d9                	jns    48b <printint+0x8a>
}
 4b2:	90                   	nop
 4b3:	90                   	nop
 4b4:	c9                   	leave  
 4b5:	c3                   	ret    

000004b6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4b6:	f3 0f 1e fb          	endbr32 
 4ba:	55                   	push   %ebp
 4bb:	89 e5                	mov    %esp,%ebp
 4bd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c7:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ca:	83 c0 04             	add    $0x4,%eax
 4cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d7:	e9 59 01 00 00       	jmp    635 <printf+0x17f>
    c = fmt[i] & 0xff;
 4dc:	8b 55 0c             	mov    0xc(%ebp),%edx
 4df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e2:	01 d0                	add    %edx,%eax
 4e4:	0f b6 00             	movzbl (%eax),%eax
 4e7:	0f be c0             	movsbl %al,%eax
 4ea:	25 ff 00 00 00       	and    $0xff,%eax
 4ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f6:	75 2c                	jne    524 <printf+0x6e>
      if(c == '%'){
 4f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fc:	75 0c                	jne    50a <printf+0x54>
        state = '%';
 4fe:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 505:	e9 27 01 00 00       	jmp    631 <printf+0x17b>
      } else {
        putc(fd, c);
 50a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50d:	0f be c0             	movsbl %al,%eax
 510:	83 ec 08             	sub    $0x8,%esp
 513:	50                   	push   %eax
 514:	ff 75 08             	pushl  0x8(%ebp)
 517:	e8 be fe ff ff       	call   3da <putc>
 51c:	83 c4 10             	add    $0x10,%esp
 51f:	e9 0d 01 00 00       	jmp    631 <printf+0x17b>
      }
    } else if(state == '%'){
 524:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 528:	0f 85 03 01 00 00    	jne    631 <printf+0x17b>
      if(c == 'd'){
 52e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 532:	75 1e                	jne    552 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 534:	8b 45 e8             	mov    -0x18(%ebp),%eax
 537:	8b 00                	mov    (%eax),%eax
 539:	6a 01                	push   $0x1
 53b:	6a 0a                	push   $0xa
 53d:	50                   	push   %eax
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 bb fe ff ff       	call   401 <printint>
 546:	83 c4 10             	add    $0x10,%esp
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54d:	e9 d8 00 00 00       	jmp    62a <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 552:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 556:	74 06                	je     55e <printf+0xa8>
 558:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55c:	75 1e                	jne    57c <printf+0xc6>
        printint(fd, *ap, 16, 0);
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	8b 00                	mov    (%eax),%eax
 563:	6a 00                	push   $0x0
 565:	6a 10                	push   $0x10
 567:	50                   	push   %eax
 568:	ff 75 08             	pushl  0x8(%ebp)
 56b:	e8 91 fe ff ff       	call   401 <printint>
 570:	83 c4 10             	add    $0x10,%esp
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 577:	e9 ae 00 00 00       	jmp    62a <printf+0x174>
      } else if(c == 's'){
 57c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 580:	75 43                	jne    5c5 <printf+0x10f>
        s = (char*)*ap;
 582:	8b 45 e8             	mov    -0x18(%ebp),%eax
 585:	8b 00                	mov    (%eax),%eax
 587:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 58e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 592:	75 25                	jne    5b9 <printf+0x103>
          s = "(null)";
 594:	c7 45 f4 86 08 00 00 	movl   $0x886,-0xc(%ebp)
        while(*s != 0){
 59b:	eb 1c                	jmp    5b9 <printf+0x103>
          putc(fd, *s);
 59d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a0:	0f b6 00             	movzbl (%eax),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 28 fe ff ff       	call   3da <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
          s++;
 5b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bc:	0f b6 00             	movzbl (%eax),%eax
 5bf:	84 c0                	test   %al,%al
 5c1:	75 da                	jne    59d <printf+0xe7>
 5c3:	eb 65                	jmp    62a <printf+0x174>
        }
      } else if(c == 'c'){
 5c5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c9:	75 1d                	jne    5e8 <printf+0x132>
        putc(fd, *ap);
 5cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	83 ec 08             	sub    $0x8,%esp
 5d6:	50                   	push   %eax
 5d7:	ff 75 08             	pushl  0x8(%ebp)
 5da:	e8 fb fd ff ff       	call   3da <putc>
 5df:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e6:	eb 42                	jmp    62a <printf+0x174>
      } else if(c == '%'){
 5e8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ec:	75 17                	jne    605 <printf+0x14f>
        putc(fd, c);
 5ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f1:	0f be c0             	movsbl %al,%eax
 5f4:	83 ec 08             	sub    $0x8,%esp
 5f7:	50                   	push   %eax
 5f8:	ff 75 08             	pushl  0x8(%ebp)
 5fb:	e8 da fd ff ff       	call   3da <putc>
 600:	83 c4 10             	add    $0x10,%esp
 603:	eb 25                	jmp    62a <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 605:	83 ec 08             	sub    $0x8,%esp
 608:	6a 25                	push   $0x25
 60a:	ff 75 08             	pushl  0x8(%ebp)
 60d:	e8 c8 fd ff ff       	call   3da <putc>
 612:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	83 ec 08             	sub    $0x8,%esp
 61e:	50                   	push   %eax
 61f:	ff 75 08             	pushl  0x8(%ebp)
 622:	e8 b3 fd ff ff       	call   3da <putc>
 627:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 62a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 631:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 635:	8b 55 0c             	mov    0xc(%ebp),%edx
 638:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63b:	01 d0                	add    %edx,%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	84 c0                	test   %al,%al
 642:	0f 85 94 fe ff ff    	jne    4dc <printf+0x26>
    }
  }
}
 648:	90                   	nop
 649:	90                   	nop
 64a:	c9                   	leave  
 64b:	c3                   	ret    

0000064c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64c:	f3 0f 1e fb          	endbr32 
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	83 e8 08             	sub    $0x8,%eax
 65c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65f:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 664:	89 45 fc             	mov    %eax,-0x4(%ebp)
 667:	eb 24                	jmp    68d <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 671:	72 12                	jb     685 <free+0x39>
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 679:	77 24                	ja     69f <free+0x53>
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 683:	72 1a                	jb     69f <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 693:	76 d4                	jbe    669 <free+0x1d>
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69d:	73 ca                	jae    669 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 40 04             	mov    0x4(%eax),%eax
 6a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	01 c2                	add    %eax,%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	39 c2                	cmp    %eax,%edx
 6b8:	75 24                	jne    6de <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	8b 50 04             	mov    0x4(%eax),%edx
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	8b 40 04             	mov    0x4(%eax),%eax
 6c8:	01 c2                	add    %eax,%edx
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	8b 10                	mov    (%eax),%edx
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	89 10                	mov    %edx,(%eax)
 6dc:	eb 0a                	jmp    6e8 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 10                	mov    (%eax),%edx
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 40 04             	mov    0x4(%eax),%eax
 6ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	01 d0                	add    %edx,%eax
 6fa:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6fd:	75 20                	jne    71f <free+0xd3>
    p->s.size += bp->s.size;
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 50 04             	mov    0x4(%eax),%edx
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	8b 40 04             	mov    0x4(%eax),%eax
 70b:	01 c2                	add    %eax,%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	8b 10                	mov    (%eax),%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	89 10                	mov    %edx,(%eax)
 71d:	eb 08                	jmp    727 <free+0xdb>
  } else
    p->s.ptr = bp;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 55 f8             	mov    -0x8(%ebp),%edx
 725:	89 10                	mov    %edx,(%eax)
  freep = p;
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	a3 f4 0a 00 00       	mov    %eax,0xaf4
}
 72f:	90                   	nop
 730:	c9                   	leave  
 731:	c3                   	ret    

00000732 <morecore>:

static Header*
morecore(uint nu)
{
 732:	f3 0f 1e fb          	endbr32 
 736:	55                   	push   %ebp
 737:	89 e5                	mov    %esp,%ebp
 739:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 73c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 743:	77 07                	ja     74c <morecore+0x1a>
    nu = 4096;
 745:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	c1 e0 03             	shl    $0x3,%eax
 752:	83 ec 0c             	sub    $0xc,%esp
 755:	50                   	push   %eax
 756:	e8 5f fc ff ff       	call   3ba <sbrk>
 75b:	83 c4 10             	add    $0x10,%esp
 75e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 761:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 765:	75 07                	jne    76e <morecore+0x3c>
    return 0;
 767:	b8 00 00 00 00       	mov    $0x0,%eax
 76c:	eb 26                	jmp    794 <morecore+0x62>
  hp = (Header*)p;
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 774:	8b 45 f0             	mov    -0x10(%ebp),%eax
 777:	8b 55 08             	mov    0x8(%ebp),%edx
 77a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	83 c0 08             	add    $0x8,%eax
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	50                   	push   %eax
 787:	e8 c0 fe ff ff       	call   64c <free>
 78c:	83 c4 10             	add    $0x10,%esp
  return freep;
 78f:	a1 f4 0a 00 00       	mov    0xaf4,%eax
}
 794:	c9                   	leave  
 795:	c3                   	ret    

00000796 <malloc>:

void*
malloc(uint nbytes)
{
 796:	f3 0f 1e fb          	endbr32 
 79a:	55                   	push   %ebp
 79b:	89 e5                	mov    %esp,%ebp
 79d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
 7a3:	83 c0 07             	add    $0x7,%eax
 7a6:	c1 e8 03             	shr    $0x3,%eax
 7a9:	83 c0 01             	add    $0x1,%eax
 7ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7af:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 7b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bb:	75 23                	jne    7e0 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7bd:	c7 45 f0 ec 0a 00 00 	movl   $0xaec,-0x10(%ebp)
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	a3 f4 0a 00 00       	mov    %eax,0xaf4
 7cc:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 7d1:	a3 ec 0a 00 00       	mov    %eax,0xaec
    base.s.size = 0;
 7d6:	c7 05 f0 0a 00 00 00 	movl   $0x0,0xaf0
 7dd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f1:	77 4d                	ja     840 <malloc+0xaa>
      if(p->s.size == nunits)
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7fc:	75 0c                	jne    80a <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 10                	mov    (%eax),%edx
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	89 10                	mov    %edx,(%eax)
 808:	eb 26                	jmp    830 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	2b 45 ec             	sub    -0x14(%ebp),%eax
 813:	89 c2                	mov    %eax,%edx
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 40 04             	mov    0x4(%eax),%eax
 821:	c1 e0 03             	shl    $0x3,%eax
 824:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 830:	8b 45 f0             	mov    -0x10(%ebp),%eax
 833:	a3 f4 0a 00 00       	mov    %eax,0xaf4
      return (void*)(p + 1);
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	83 c0 08             	add    $0x8,%eax
 83e:	eb 3b                	jmp    87b <malloc+0xe5>
    }
    if(p == freep)
 840:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 845:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 848:	75 1e                	jne    868 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 84a:	83 ec 0c             	sub    $0xc,%esp
 84d:	ff 75 ec             	pushl  -0x14(%ebp)
 850:	e8 dd fe ff ff       	call   732 <morecore>
 855:	83 c4 10             	add    $0x10,%esp
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85f:	75 07                	jne    868 <malloc+0xd2>
        return 0;
 861:	b8 00 00 00 00       	mov    $0x0,%eax
 866:	eb 13                	jmp    87b <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 876:	e9 6d ff ff ff       	jmp    7e8 <malloc+0x52>
  }
}
 87b:	c9                   	leave  
 87c:	c3                   	ret    
