
_ln:     format de fichier elf32-i386


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
  13:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  15:	83 3b 03             	cmpl   $0x3,(%ebx)
  18:	74 17                	je     31 <main+0x31>
    printf(2, "Usage: ln old new\n");
  1a:	83 ec 08             	sub    $0x8,%esp
  1d:	68 8c 08 00 00       	push   $0x88c
  22:	6a 02                	push   $0x2
  24:	e8 9c 04 00 00       	call   4c5 <printf>
  29:	83 c4 10             	add    $0x10,%esp
    exit();
  2c:	e8 10 03 00 00       	call   341 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  31:	8b 43 04             	mov    0x4(%ebx),%eax
  34:	83 c0 08             	add    $0x8,%eax
  37:	8b 10                	mov    (%eax),%edx
  39:	8b 43 04             	mov    0x4(%ebx),%eax
  3c:	83 c0 04             	add    $0x4,%eax
  3f:	8b 00                	mov    (%eax),%eax
  41:	83 ec 08             	sub    $0x8,%esp
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	e8 56 03 00 00       	call   3a1 <link>
  4b:	83 c4 10             	add    $0x10,%esp
  4e:	85 c0                	test   %eax,%eax
  50:	79 21                	jns    73 <main+0x73>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  52:	8b 43 04             	mov    0x4(%ebx),%eax
  55:	83 c0 08             	add    $0x8,%eax
  58:	8b 10                	mov    (%eax),%edx
  5a:	8b 43 04             	mov    0x4(%ebx),%eax
  5d:	83 c0 04             	add    $0x4,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	52                   	push   %edx
  63:	50                   	push   %eax
  64:	68 9f 08 00 00       	push   $0x89f
  69:	6a 02                	push   $0x2
  6b:	e8 55 04 00 00       	call   4c5 <printf>
  70:	83 c4 10             	add    $0x10,%esp
  exit();
  73:	e8 c9 02 00 00       	call   341 <exit>

00000078 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	57                   	push   %edi
  7c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80:	8b 55 10             	mov    0x10(%ebp),%edx
  83:	8b 45 0c             	mov    0xc(%ebp),%eax
  86:	89 cb                	mov    %ecx,%ebx
  88:	89 df                	mov    %ebx,%edi
  8a:	89 d1                	mov    %edx,%ecx
  8c:	fc                   	cld    
  8d:	f3 aa                	rep stos %al,%es:(%edi)
  8f:	89 ca                	mov    %ecx,%edx
  91:	89 fb                	mov    %edi,%ebx
  93:	89 5d 08             	mov    %ebx,0x8(%ebp)
  96:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  99:	90                   	nop
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  9e:	f3 0f 1e fb          	endbr32 
  a2:	55                   	push   %ebp
  a3:	89 e5                	mov    %esp,%ebp
  a5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ae:	90                   	nop
  af:	8b 55 0c             	mov    0xc(%ebp),%edx
  b2:	8d 42 01             	lea    0x1(%edx),%eax
  b5:	89 45 0c             	mov    %eax,0xc(%ebp)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	8d 48 01             	lea    0x1(%eax),%ecx
  be:	89 4d 08             	mov    %ecx,0x8(%ebp)
  c1:	0f b6 12             	movzbl (%edx),%edx
  c4:	88 10                	mov    %dl,(%eax)
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	84 c0                	test   %al,%al
  cb:	75 e2                	jne    af <strcpy+0x11>
    ;
  return os;
  cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d0:	c9                   	leave  
  d1:	c3                   	ret    

000000d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d2:	f3 0f 1e fb          	endbr32 
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d9:	eb 08                	jmp    e3 <strcmp+0x11>
    p++, q++;
  db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  df:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	84 c0                	test   %al,%al
  eb:	74 10                	je     fd <strcmp+0x2b>
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	0f b6 10             	movzbl (%eax),%edx
  f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	38 c2                	cmp    %al,%dl
  fb:	74 de                	je     db <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 00             	movzbl (%eax),%eax
 103:	0f b6 d0             	movzbl %al,%edx
 106:	8b 45 0c             	mov    0xc(%ebp),%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	0f b6 c0             	movzbl %al,%eax
 10f:	29 c2                	sub    %eax,%edx
 111:	89 d0                	mov    %edx,%eax
}
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    

00000115 <strlen>:

uint
strlen(const char *s)
{
 115:	f3 0f 1e fb          	endbr32 
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 126:	eb 04                	jmp    12c <strlen+0x17>
 128:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	01 d0                	add    %edx,%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	84 c0                	test   %al,%al
 139:	75 ed                	jne    128 <strlen+0x13>
    ;
  return n;
 13b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	f3 0f 1e fb          	endbr32 
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 147:	8b 45 10             	mov    0x10(%ebp),%eax
 14a:	50                   	push   %eax
 14b:	ff 75 0c             	pushl  0xc(%ebp)
 14e:	ff 75 08             	pushl  0x8(%ebp)
 151:	e8 22 ff ff ff       	call   78 <stosb>
 156:	83 c4 0c             	add    $0xc,%esp
  return dst;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	f3 0f 1e fb          	endbr32 
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	83 ec 04             	sub    $0x4,%esp
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16e:	eb 14                	jmp    184 <strchr+0x26>
    if(*s == c)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	38 45 fc             	cmp    %al,-0x4(%ebp)
 179:	75 05                	jne    180 <strchr+0x22>
      return (char*)s;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	eb 13                	jmp    193 <strchr+0x35>
  for(; *s; s++)
 180:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	84 c0                	test   %al,%al
 18c:	75 e2                	jne    170 <strchr+0x12>
  return 0;
 18e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <gets>:

char*
gets(char *buf, int max)
{
 195:	f3 0f 1e fb          	endbr32 
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x55>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 a1 01 00 00       	call   359 <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x62>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x63>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x63>
  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f3:	7f b3                	jg     1a8 <gets+0x13>
 1f5:	eb 01                	jmp    1f8 <gets+0x63>
      break;
 1f7:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(const char *n, struct stat *st)
{
 208:	f3 0f 1e fb          	endbr32 
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	6a 00                	push   $0x0
 217:	ff 75 08             	pushl  0x8(%ebp)
 21a:	e8 62 01 00 00       	call   381 <open>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 229:	79 07                	jns    232 <stat+0x2a>
    return -1;
 22b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 230:	eb 25                	jmp    257 <stat+0x4f>
  r = fstat(fd, st);
 232:	83 ec 08             	sub    $0x8,%esp
 235:	ff 75 0c             	pushl  0xc(%ebp)
 238:	ff 75 f4             	pushl  -0xc(%ebp)
 23b:	e8 59 01 00 00       	call   399 <fstat>
 240:	83 c4 10             	add    $0x10,%esp
 243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	ff 75 f4             	pushl  -0xc(%ebp)
 24c:	e8 18 01 00 00       	call   369 <close>
 251:	83 c4 10             	add    $0x10,%esp
  return r;
 254:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <atoi>:



int
atoi(const char *s)
{
 259:	f3 0f 1e fb          	endbr32 
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	3c 2d                	cmp    $0x2d,%al
 272:	75 6b                	jne    2df <atoi+0x86>
  {
    s++;
 274:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 278:	eb 25                	jmp    29f <atoi+0x46>
        n = n*10 + *s++ - '0';
 27a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27d:	89 d0                	mov    %edx,%eax
 27f:	c1 e0 02             	shl    $0x2,%eax
 282:	01 d0                	add    %edx,%eax
 284:	01 c0                	add    %eax,%eax
 286:	89 c1                	mov    %eax,%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8d 50 01             	lea    0x1(%eax),%edx
 28e:	89 55 08             	mov    %edx,0x8(%ebp)
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	0f be c0             	movsbl %al,%eax
 297:	01 c8                	add    %ecx,%eax
 299:	83 e8 30             	sub    $0x30,%eax
 29c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3c 2f                	cmp    $0x2f,%al
 2a7:	7e 0a                	jle    2b3 <atoi+0x5a>
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3c 39                	cmp    $0x39,%al
 2b1:	7e c7                	jle    27a <atoi+0x21>

    return -n;
 2b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b6:	f7 d8                	neg    %eax
 2b8:	eb 3c                	jmp    2f6 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 2ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2bd:	89 d0                	mov    %edx,%eax
 2bf:	c1 e0 02             	shl    $0x2,%eax
 2c2:	01 d0                	add    %edx,%eax
 2c4:	01 c0                	add    %eax,%eax
 2c6:	89 c1                	mov    %eax,%ecx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	8d 50 01             	lea    0x1(%eax),%edx
 2ce:	89 55 08             	mov    %edx,0x8(%ebp)
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	0f be c0             	movsbl %al,%eax
 2d7:	01 c8                	add    %ecx,%eax
 2d9:	83 e8 30             	sub    $0x30,%eax
 2dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	3c 2f                	cmp    $0x2f,%al
 2e7:	7e 0a                	jle    2f3 <atoi+0x9a>
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	3c 39                	cmp    $0x39,%al
 2f1:	7e c7                	jle    2ba <atoi+0x61>

    return n;
 2f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f8:	f3 0f 1e fb          	endbr32 
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 308:	8b 45 0c             	mov    0xc(%ebp),%eax
 30b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 30e:	eb 17                	jmp    327 <memmove+0x2f>
    *dst++ = *src++;
 310:	8b 55 f8             	mov    -0x8(%ebp),%edx
 313:	8d 42 01             	lea    0x1(%edx),%eax
 316:	89 45 f8             	mov    %eax,-0x8(%ebp)
 319:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31c:	8d 48 01             	lea    0x1(%eax),%ecx
 31f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 322:	0f b6 12             	movzbl (%edx),%edx
 325:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 327:	8b 45 10             	mov    0x10(%ebp),%eax
 32a:	8d 50 ff             	lea    -0x1(%eax),%edx
 32d:	89 55 10             	mov    %edx,0x10(%ebp)
 330:	85 c0                	test   %eax,%eax
 332:	7f dc                	jg     310 <memmove+0x18>
  return vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
}
 337:	c9                   	leave  
 338:	c3                   	ret    

00000339 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 339:	b8 01 00 00 00       	mov    $0x1,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <exit>:
SYSCALL(exit)
 341:	b8 02 00 00 00       	mov    $0x2,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <wait>:
SYSCALL(wait)
 349:	b8 03 00 00 00       	mov    $0x3,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <pipe>:
SYSCALL(pipe)
 351:	b8 04 00 00 00       	mov    $0x4,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <read>:
SYSCALL(read)
 359:	b8 05 00 00 00       	mov    $0x5,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <write>:
SYSCALL(write)
 361:	b8 10 00 00 00       	mov    $0x10,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <close>:
SYSCALL(close)
 369:	b8 15 00 00 00       	mov    $0x15,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <kill>:
SYSCALL(kill)
 371:	b8 06 00 00 00       	mov    $0x6,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <exec>:
SYSCALL(exec)
 379:	b8 07 00 00 00       	mov    $0x7,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <open>:
SYSCALL(open)
 381:	b8 0f 00 00 00       	mov    $0xf,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <mknod>:
SYSCALL(mknod)
 389:	b8 11 00 00 00       	mov    $0x11,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <unlink>:
SYSCALL(unlink)
 391:	b8 12 00 00 00       	mov    $0x12,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <fstat>:
SYSCALL(fstat)
 399:	b8 08 00 00 00       	mov    $0x8,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <link>:
SYSCALL(link)
 3a1:	b8 13 00 00 00       	mov    $0x13,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <mkdir>:
SYSCALL(mkdir)
 3a9:	b8 14 00 00 00       	mov    $0x14,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <chdir>:
SYSCALL(chdir)
 3b1:	b8 09 00 00 00       	mov    $0x9,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <dup>:
SYSCALL(dup)
 3b9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <getpid>:
SYSCALL(getpid)
 3c1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <sbrk>:
SYSCALL(sbrk)
 3c9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <sleep>:
SYSCALL(sleep)
 3d1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <uptime>:
SYSCALL(uptime)
 3d9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <lseek>:
SYSCALL(lseek)
 3e1:	b8 16 00 00 00       	mov    $0x16,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e9:	f3 0f 1e fb          	endbr32 
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 18             	sub    $0x18,%esp
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f9:	83 ec 04             	sub    $0x4,%esp
 3fc:	6a 01                	push   $0x1
 3fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
 401:	50                   	push   %eax
 402:	ff 75 08             	pushl  0x8(%ebp)
 405:	e8 57 ff ff ff       	call   361 <write>
 40a:	83 c4 10             	add    $0x10,%esp
}
 40d:	90                   	nop
 40e:	c9                   	leave  
 40f:	c3                   	ret    

00000410 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 41a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 421:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 425:	74 17                	je     43e <printint+0x2e>
 427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 42b:	79 11                	jns    43e <printint+0x2e>
    neg = 1;
 42d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 434:	8b 45 0c             	mov    0xc(%ebp),%eax
 437:	f7 d8                	neg    %eax
 439:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43c:	eb 06                	jmp    444 <printint+0x34>
  } else {
    x = xx;
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 444:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 44b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 44e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f1                	div    %ecx
 458:	89 d1                	mov    %edx,%ecx
 45a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45d:	8d 50 01             	lea    0x1(%eax),%edx
 460:	89 55 f4             	mov    %edx,-0xc(%ebp)
 463:	0f b6 91 04 0b 00 00 	movzbl 0xb04(%ecx),%edx
 46a:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 46e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 471:	8b 45 ec             	mov    -0x14(%ebp),%eax
 474:	ba 00 00 00 00       	mov    $0x0,%edx
 479:	f7 f1                	div    %ecx
 47b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 482:	75 c7                	jne    44b <printint+0x3b>
  if(neg)
 484:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 488:	74 2d                	je     4b7 <printint+0xa7>
    buf[i++] = '-';
 48a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48d:	8d 50 01             	lea    0x1(%eax),%edx
 490:	89 55 f4             	mov    %edx,-0xc(%ebp)
 493:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 498:	eb 1d                	jmp    4b7 <printint+0xa7>
    putc(fd, buf[i]);
 49a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 49d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a0:	01 d0                	add    %edx,%eax
 4a2:	0f b6 00             	movzbl (%eax),%eax
 4a5:	0f be c0             	movsbl %al,%eax
 4a8:	83 ec 08             	sub    $0x8,%esp
 4ab:	50                   	push   %eax
 4ac:	ff 75 08             	pushl  0x8(%ebp)
 4af:	e8 35 ff ff ff       	call   3e9 <putc>
 4b4:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bf:	79 d9                	jns    49a <printint+0x8a>
}
 4c1:	90                   	nop
 4c2:	90                   	nop
 4c3:	c9                   	leave  
 4c4:	c3                   	ret    

000004c5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c5:	f3 0f 1e fb          	endbr32 
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d6:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d9:	83 c0 04             	add    $0x4,%eax
 4dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e6:	e9 59 01 00 00       	jmp    644 <printf+0x17f>
    c = fmt[i] & 0xff;
 4eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f1:	01 d0                	add    %edx,%eax
 4f3:	0f b6 00             	movzbl (%eax),%eax
 4f6:	0f be c0             	movsbl %al,%eax
 4f9:	25 ff 00 00 00       	and    $0xff,%eax
 4fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 505:	75 2c                	jne    533 <printf+0x6e>
      if(c == '%'){
 507:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 50b:	75 0c                	jne    519 <printf+0x54>
        state = '%';
 50d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 514:	e9 27 01 00 00       	jmp    640 <printf+0x17b>
      } else {
        putc(fd, c);
 519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51c:	0f be c0             	movsbl %al,%eax
 51f:	83 ec 08             	sub    $0x8,%esp
 522:	50                   	push   %eax
 523:	ff 75 08             	pushl  0x8(%ebp)
 526:	e8 be fe ff ff       	call   3e9 <putc>
 52b:	83 c4 10             	add    $0x10,%esp
 52e:	e9 0d 01 00 00       	jmp    640 <printf+0x17b>
      }
    } else if(state == '%'){
 533:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 537:	0f 85 03 01 00 00    	jne    640 <printf+0x17b>
      if(c == 'd'){
 53d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 541:	75 1e                	jne    561 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 543:	8b 45 e8             	mov    -0x18(%ebp),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	6a 01                	push   $0x1
 54a:	6a 0a                	push   $0xa
 54c:	50                   	push   %eax
 54d:	ff 75 08             	pushl  0x8(%ebp)
 550:	e8 bb fe ff ff       	call   410 <printint>
 555:	83 c4 10             	add    $0x10,%esp
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55c:	e9 d8 00 00 00       	jmp    639 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 561:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 565:	74 06                	je     56d <printf+0xa8>
 567:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56b:	75 1e                	jne    58b <printf+0xc6>
        printint(fd, *ap, 16, 0);
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	6a 00                	push   $0x0
 574:	6a 10                	push   $0x10
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 91 fe ff ff       	call   410 <printint>
 57f:	83 c4 10             	add    $0x10,%esp
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 586:	e9 ae 00 00 00       	jmp    639 <printf+0x174>
      } else if(c == 's'){
 58b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58f:	75 43                	jne    5d4 <printf+0x10f>
        s = (char*)*ap;
 591:	8b 45 e8             	mov    -0x18(%ebp),%eax
 594:	8b 00                	mov    (%eax),%eax
 596:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 599:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a1:	75 25                	jne    5c8 <printf+0x103>
          s = "(null)";
 5a3:	c7 45 f4 b3 08 00 00 	movl   $0x8b3,-0xc(%ebp)
        while(*s != 0){
 5aa:	eb 1c                	jmp    5c8 <printf+0x103>
          putc(fd, *s);
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	0f b6 00             	movzbl (%eax),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 28 fe ff ff       	call   3e9 <putc>
 5c1:	83 c4 10             	add    $0x10,%esp
          s++;
 5c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	84 c0                	test   %al,%al
 5d0:	75 da                	jne    5ac <printf+0xe7>
 5d2:	eb 65                	jmp    639 <printf+0x174>
        }
      } else if(c == 'c'){
 5d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d8:	75 1d                	jne    5f7 <printf+0x132>
        putc(fd, *ap);
 5da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 fb fd ff ff       	call   3e9 <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f5:	eb 42                	jmp    639 <printf+0x174>
      } else if(c == '%'){
 5f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fb:	75 17                	jne    614 <printf+0x14f>
        putc(fd, c);
 5fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	83 ec 08             	sub    $0x8,%esp
 606:	50                   	push   %eax
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 da fd ff ff       	call   3e9 <putc>
 60f:	83 c4 10             	add    $0x10,%esp
 612:	eb 25                	jmp    639 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 614:	83 ec 08             	sub    $0x8,%esp
 617:	6a 25                	push   $0x25
 619:	ff 75 08             	pushl  0x8(%ebp)
 61c:	e8 c8 fd ff ff       	call   3e9 <putc>
 621:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 627:	0f be c0             	movsbl %al,%eax
 62a:	83 ec 08             	sub    $0x8,%esp
 62d:	50                   	push   %eax
 62e:	ff 75 08             	pushl  0x8(%ebp)
 631:	e8 b3 fd ff ff       	call   3e9 <putc>
 636:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 639:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 640:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 644:	8b 55 0c             	mov    0xc(%ebp),%edx
 647:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64a:	01 d0                	add    %edx,%eax
 64c:	0f b6 00             	movzbl (%eax),%eax
 64f:	84 c0                	test   %al,%al
 651:	0f 85 94 fe ff ff    	jne    4eb <printf+0x26>
    }
  }
}
 657:	90                   	nop
 658:	90                   	nop
 659:	c9                   	leave  
 65a:	c3                   	ret    

0000065b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65b:	f3 0f 1e fb          	endbr32 
 65f:	55                   	push   %ebp
 660:	89 e5                	mov    %esp,%ebp
 662:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	83 e8 08             	sub    $0x8,%eax
 66b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	a1 20 0b 00 00       	mov    0xb20,%eax
 673:	89 45 fc             	mov    %eax,-0x4(%ebp)
 676:	eb 24                	jmp    69c <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 680:	72 12                	jb     694 <free+0x39>
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 688:	77 24                	ja     6ae <free+0x53>
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 692:	72 1a                	jb     6ae <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a2:	76 d4                	jbe    678 <free+0x1d>
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6ac:	73 ca                	jae    678 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	8b 40 04             	mov    0x4(%eax),%eax
 6b4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	01 c2                	add    %eax,%edx
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	39 c2                	cmp    %eax,%edx
 6c7:	75 24                	jne    6ed <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	8b 50 04             	mov    0x4(%eax),%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	01 c2                	add    %eax,%edx
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	8b 10                	mov    (%eax),%edx
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	89 10                	mov    %edx,(%eax)
 6eb:	eb 0a                	jmp    6f7 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 10                	mov    (%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	01 d0                	add    %edx,%eax
 709:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 70c:	75 20                	jne    72e <free+0xd3>
    p->s.size += bp->s.size;
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 50 04             	mov    0x4(%eax),%edx
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	8b 40 04             	mov    0x4(%eax),%eax
 71a:	01 c2                	add    %eax,%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	8b 10                	mov    (%eax),%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	89 10                	mov    %edx,(%eax)
 72c:	eb 08                	jmp    736 <free+0xdb>
  } else
    p->s.ptr = bp;
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 55 f8             	mov    -0x8(%ebp),%edx
 734:	89 10                	mov    %edx,(%eax)
  freep = p;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 73e:	90                   	nop
 73f:	c9                   	leave  
 740:	c3                   	ret    

00000741 <morecore>:

static Header*
morecore(uint nu)
{
 741:	f3 0f 1e fb          	endbr32 
 745:	55                   	push   %ebp
 746:	89 e5                	mov    %esp,%ebp
 748:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 752:	77 07                	ja     75b <morecore+0x1a>
    nu = 4096;
 754:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	c1 e0 03             	shl    $0x3,%eax
 761:	83 ec 0c             	sub    $0xc,%esp
 764:	50                   	push   %eax
 765:	e8 5f fc ff ff       	call   3c9 <sbrk>
 76a:	83 c4 10             	add    $0x10,%esp
 76d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 770:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 774:	75 07                	jne    77d <morecore+0x3c>
    return 0;
 776:	b8 00 00 00 00       	mov    $0x0,%eax
 77b:	eb 26                	jmp    7a3 <morecore+0x62>
  hp = (Header*)p;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	8b 55 08             	mov    0x8(%ebp),%edx
 789:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	83 c0 08             	add    $0x8,%eax
 792:	83 ec 0c             	sub    $0xc,%esp
 795:	50                   	push   %eax
 796:	e8 c0 fe ff ff       	call   65b <free>
 79b:	83 c4 10             	add    $0x10,%esp
  return freep;
 79e:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <malloc>:

void*
malloc(uint nbytes)
{
 7a5:	f3 0f 1e fb          	endbr32 
 7a9:	55                   	push   %ebp
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	83 c0 07             	add    $0x7,%eax
 7b5:	c1 e8 03             	shr    $0x3,%eax
 7b8:	83 c0 01             	add    $0x1,%eax
 7bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7be:	a1 20 0b 00 00       	mov    0xb20,%eax
 7c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ca:	75 23                	jne    7ef <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7cc:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	a3 20 0b 00 00       	mov    %eax,0xb20
 7db:	a1 20 0b 00 00       	mov    0xb20,%eax
 7e0:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 7e5:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 7ec:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 800:	77 4d                	ja     84f <malloc+0xaa>
      if(p->s.size == nunits)
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 40 04             	mov    0x4(%eax),%eax
 808:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 80b:	75 0c                	jne    819 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 10                	mov    (%eax),%edx
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	89 10                	mov    %edx,(%eax)
 817:	eb 26                	jmp    83f <malloc+0x9a>
      else {
        p->s.size -= nunits;
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	8b 40 04             	mov    0x4(%eax),%eax
 81f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 822:	89 c2                	mov    %eax,%edx
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 40 04             	mov    0x4(%eax),%eax
 830:	c1 e0 03             	shl    $0x3,%eax
 833:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	83 c0 08             	add    $0x8,%eax
 84d:	eb 3b                	jmp    88a <malloc+0xe5>
    }
    if(p == freep)
 84f:	a1 20 0b 00 00       	mov    0xb20,%eax
 854:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 857:	75 1e                	jne    877 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 859:	83 ec 0c             	sub    $0xc,%esp
 85c:	ff 75 ec             	pushl  -0x14(%ebp)
 85f:	e8 dd fe ff ff       	call   741 <morecore>
 864:	83 c4 10             	add    $0x10,%esp
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86e:	75 07                	jne    877 <malloc+0xd2>
        return 0;
 870:	b8 00 00 00 00       	mov    $0x0,%eax
 875:	eb 13                	jmp    88a <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 885:	e9 6d ff ff ff       	jmp    7f7 <malloc+0x52>
  }
}
 88a:	c9                   	leave  
 88b:	c3                   	ret    
