
_mkdir:     format de fichier elf32-i386


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

  if(argc < 2){
  18:	83 3b 01             	cmpl   $0x1,(%ebx)
  1b:	7f 17                	jg     34 <main+0x34>
    printf(2, "Usage: mkdir files...\n");
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	68 a8 08 00 00       	push   $0x8a8
  25:	6a 02                	push   $0x2
  27:	e8 b5 04 00 00       	call   4e1 <printf>
  2c:	83 c4 10             	add    $0x10,%esp
    exit();
  2f:	e8 29 03 00 00       	call   35d <exit>
  }

  for(i = 1; i < argc; i++){
  34:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  3b:	eb 4b                	jmp    88 <main+0x88>
    if(mkdir(argv[i]) < 0){
  3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	01 d0                	add    %edx,%eax
  4c:	8b 00                	mov    (%eax),%eax
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	50                   	push   %eax
  52:	e8 6e 03 00 00       	call   3c5 <mkdir>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	79 26                	jns    84 <main+0x84>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  68:	8b 43 04             	mov    0x4(%ebx),%eax
  6b:	01 d0                	add    %edx,%eax
  6d:	8b 00                	mov    (%eax),%eax
  6f:	83 ec 04             	sub    $0x4,%esp
  72:	50                   	push   %eax
  73:	68 bf 08 00 00       	push   $0x8bf
  78:	6a 02                	push   $0x2
  7a:	e8 62 04 00 00       	call   4e1 <printf>
  7f:	83 c4 10             	add    $0x10,%esp
      break;
  82:	eb 0b                	jmp    8f <main+0x8f>
  for(i = 1; i < argc; i++){
  84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8b:	3b 03                	cmp    (%ebx),%eax
  8d:	7c ae                	jl     3d <main+0x3d>
    }
  }

  exit();
  8f:	e8 c9 02 00 00       	call   35d <exit>

00000094 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	57                   	push   %edi
  98:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 10             	mov    0x10(%ebp),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	89 cb                	mov    %ecx,%ebx
  a4:	89 df                	mov    %ebx,%edi
  a6:	89 d1                	mov    %edx,%ecx
  a8:	fc                   	cld    
  a9:	f3 aa                	rep stos %al,%es:(%edi)
  ab:	89 ca                	mov    %ecx,%edx
  ad:	89 fb                	mov    %edi,%ebx
  af:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b5:	90                   	nop
  b6:	5b                   	pop    %ebx
  b7:	5f                   	pop    %edi
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ca:	90                   	nop
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 42 01             	lea    0x1(%edx),%eax
  d1:	89 45 0c             	mov    %eax,0xc(%ebp)
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	8d 48 01             	lea    0x1(%eax),%ecx
  da:	89 4d 08             	mov    %ecx,0x8(%ebp)
  dd:	0f b6 12             	movzbl (%edx),%edx
  e0:	88 10                	mov    %dl,(%eax)
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	75 e2                	jne    cb <strcpy+0x11>
    ;
  return os;
  e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	f3 0f 1e fb          	endbr32 
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f5:	eb 08                	jmp    ff <strcmp+0x11>
    p++, q++;
  f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	84 c0                	test   %al,%al
 107:	74 10                	je     119 <strcmp+0x2b>
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 10             	movzbl (%eax),%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	38 c2                	cmp    %al,%dl
 117:	74 de                	je     f7 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	0f b6 d0             	movzbl %al,%edx
 122:	8b 45 0c             	mov    0xc(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	0f b6 c0             	movzbl %al,%eax
 12b:	29 c2                	sub    %eax,%edx
 12d:	89 d0                	mov    %edx,%eax
}
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strlen>:

uint
strlen(const char *s)
{
 131:	f3 0f 1e fb          	endbr32 
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 13b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 142:	eb 04                	jmp    148 <strlen+0x17>
 144:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 148:	8b 55 fc             	mov    -0x4(%ebp),%edx
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	01 d0                	add    %edx,%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	84 c0                	test   %al,%al
 155:	75 ed                	jne    144 <strlen+0x13>
    ;
  return n;
 157:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15a:	c9                   	leave  
 15b:	c3                   	ret    

0000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	f3 0f 1e fb          	endbr32 
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 163:	8b 45 10             	mov    0x10(%ebp),%eax
 166:	50                   	push   %eax
 167:	ff 75 0c             	pushl  0xc(%ebp)
 16a:	ff 75 08             	pushl  0x8(%ebp)
 16d:	e8 22 ff ff ff       	call   94 <stosb>
 172:	83 c4 0c             	add    $0xc,%esp
  return dst;
 175:	8b 45 08             	mov    0x8(%ebp),%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <strchr>:

char*
strchr(const char *s, char c)
{
 17a:	f3 0f 1e fb          	endbr32 
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 04             	sub    $0x4,%esp
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 18a:	eb 14                	jmp    1a0 <strchr+0x26>
    if(*s == c)
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	38 45 fc             	cmp    %al,-0x4(%ebp)
 195:	75 05                	jne    19c <strchr+0x22>
      return (char*)s;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	eb 13                	jmp    1af <strchr+0x35>
  for(; *s; s++)
 19c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	75 e2                	jne    18c <strchr+0x12>
  return 0;
 1aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1af:	c9                   	leave  
 1b0:	c3                   	ret    

000001b1 <gets>:

char*
gets(char *buf, int max)
{
 1b1:	f3 0f 1e fb          	endbr32 
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c2:	eb 42                	jmp    206 <gets+0x55>
    cc = read(0, &c, 1);
 1c4:	83 ec 04             	sub    $0x4,%esp
 1c7:	6a 01                	push   $0x1
 1c9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1cc:	50                   	push   %eax
 1cd:	6a 00                	push   $0x0
 1cf:	e8 a1 01 00 00       	call   375 <read>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1de:	7e 33                	jle    213 <gets+0x62>
      break;
    buf[i++] = c;
 1e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e3:	8d 50 01             	lea    0x1(%eax),%edx
 1e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e9:	89 c2                	mov    %eax,%edx
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	01 c2                	add    %eax,%edx
 1f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fa:	3c 0a                	cmp    $0xa,%al
 1fc:	74 16                	je     214 <gets+0x63>
 1fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 202:	3c 0d                	cmp    $0xd,%al
 204:	74 0e                	je     214 <gets+0x63>
  for(i=0; i+1 < max; ){
 206:	8b 45 f4             	mov    -0xc(%ebp),%eax
 209:	83 c0 01             	add    $0x1,%eax
 20c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 20f:	7f b3                	jg     1c4 <gets+0x13>
 211:	eb 01                	jmp    214 <gets+0x63>
      break;
 213:	90                   	nop
      break;
  }
  buf[i] = '\0';
 214:	8b 55 f4             	mov    -0xc(%ebp),%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	f3 0f 1e fb          	endbr32 
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	6a 00                	push   $0x0
 233:	ff 75 08             	pushl  0x8(%ebp)
 236:	e8 62 01 00 00       	call   39d <open>
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 245:	79 07                	jns    24e <stat+0x2a>
    return -1;
 247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24c:	eb 25                	jmp    273 <stat+0x4f>
  r = fstat(fd, st);
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	ff 75 0c             	pushl  0xc(%ebp)
 254:	ff 75 f4             	pushl  -0xc(%ebp)
 257:	e8 59 01 00 00       	call   3b5 <fstat>
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 262:	83 ec 0c             	sub    $0xc,%esp
 265:	ff 75 f4             	pushl  -0xc(%ebp)
 268:	e8 18 01 00 00       	call   385 <close>
 26d:	83 c4 10             	add    $0x10,%esp
  return r;
 270:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <atoi>:



int
atoi(const char *s)
{
 275:	f3 0f 1e fb          	endbr32 
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 27f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	3c 2d                	cmp    $0x2d,%al
 28e:	75 6b                	jne    2fb <atoi+0x86>
  {
    s++;
 290:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 294:	eb 25                	jmp    2bb <atoi+0x46>
        n = n*10 + *s++ - '0';
 296:	8b 55 fc             	mov    -0x4(%ebp),%edx
 299:	89 d0                	mov    %edx,%eax
 29b:	c1 e0 02             	shl    $0x2,%eax
 29e:	01 d0                	add    %edx,%eax
 2a0:	01 c0                	add    %eax,%eax
 2a2:	89 c1                	mov    %eax,%ecx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8d 50 01             	lea    0x1(%eax),%edx
 2aa:	89 55 08             	mov    %edx,0x8(%ebp)
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	0f be c0             	movsbl %al,%eax
 2b3:	01 c8                	add    %ecx,%eax
 2b5:	83 e8 30             	sub    $0x30,%eax
 2b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3c 2f                	cmp    $0x2f,%al
 2c3:	7e 0a                	jle    2cf <atoi+0x5a>
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	0f b6 00             	movzbl (%eax),%eax
 2cb:	3c 39                	cmp    $0x39,%al
 2cd:	7e c7                	jle    296 <atoi+0x21>

    return -n;
 2cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d2:	f7 d8                	neg    %eax
 2d4:	eb 3c                	jmp    312 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 2d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d9:	89 d0                	mov    %edx,%eax
 2db:	c1 e0 02             	shl    $0x2,%eax
 2de:	01 d0                	add    %edx,%eax
 2e0:	01 c0                	add    %eax,%eax
 2e2:	89 c1                	mov    %eax,%ecx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	8d 50 01             	lea    0x1(%eax),%edx
 2ea:	89 55 08             	mov    %edx,0x8(%ebp)
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	0f be c0             	movsbl %al,%eax
 2f3:	01 c8                	add    %ecx,%eax
 2f5:	83 e8 30             	sub    $0x30,%eax
 2f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	0f b6 00             	movzbl (%eax),%eax
 301:	3c 2f                	cmp    $0x2f,%al
 303:	7e 0a                	jle    30f <atoi+0x9a>
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	3c 39                	cmp    $0x39,%al
 30d:	7e c7                	jle    2d6 <atoi+0x61>

    return n;
 30f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 312:	c9                   	leave  
 313:	c3                   	ret    

00000314 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 314:	f3 0f 1e fb          	endbr32 
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 324:	8b 45 0c             	mov    0xc(%ebp),%eax
 327:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 32a:	eb 17                	jmp    343 <memmove+0x2f>
    *dst++ = *src++;
 32c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32f:	8d 42 01             	lea    0x1(%edx),%eax
 332:	89 45 f8             	mov    %eax,-0x8(%ebp)
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
 338:	8d 48 01             	lea    0x1(%eax),%ecx
 33b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 33e:	0f b6 12             	movzbl (%edx),%edx
 341:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 343:	8b 45 10             	mov    0x10(%ebp),%eax
 346:	8d 50 ff             	lea    -0x1(%eax),%edx
 349:	89 55 10             	mov    %edx,0x10(%ebp)
 34c:	85 c0                	test   %eax,%eax
 34e:	7f dc                	jg     32c <memmove+0x18>
  return vdst;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 355:	b8 01 00 00 00       	mov    $0x1,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <exit>:
SYSCALL(exit)
 35d:	b8 02 00 00 00       	mov    $0x2,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <wait>:
SYSCALL(wait)
 365:	b8 03 00 00 00       	mov    $0x3,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <pipe>:
SYSCALL(pipe)
 36d:	b8 04 00 00 00       	mov    $0x4,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <read>:
SYSCALL(read)
 375:	b8 05 00 00 00       	mov    $0x5,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <write>:
SYSCALL(write)
 37d:	b8 10 00 00 00       	mov    $0x10,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <close>:
SYSCALL(close)
 385:	b8 15 00 00 00       	mov    $0x15,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <kill>:
SYSCALL(kill)
 38d:	b8 06 00 00 00       	mov    $0x6,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <exec>:
SYSCALL(exec)
 395:	b8 07 00 00 00       	mov    $0x7,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <open>:
SYSCALL(open)
 39d:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <mknod>:
SYSCALL(mknod)
 3a5:	b8 11 00 00 00       	mov    $0x11,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <unlink>:
SYSCALL(unlink)
 3ad:	b8 12 00 00 00       	mov    $0x12,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <fstat>:
SYSCALL(fstat)
 3b5:	b8 08 00 00 00       	mov    $0x8,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <link>:
SYSCALL(link)
 3bd:	b8 13 00 00 00       	mov    $0x13,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <mkdir>:
SYSCALL(mkdir)
 3c5:	b8 14 00 00 00       	mov    $0x14,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <chdir>:
SYSCALL(chdir)
 3cd:	b8 09 00 00 00       	mov    $0x9,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <dup>:
SYSCALL(dup)
 3d5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <getpid>:
SYSCALL(getpid)
 3dd:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <sbrk>:
SYSCALL(sbrk)
 3e5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <sleep>:
SYSCALL(sleep)
 3ed:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <uptime>:
SYSCALL(uptime)
 3f5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <lseek>:
SYSCALL(lseek)
 3fd:	b8 16 00 00 00       	mov    $0x16,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 405:	f3 0f 1e fb          	endbr32 
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 18             	sub    $0x18,%esp
 40f:	8b 45 0c             	mov    0xc(%ebp),%eax
 412:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 415:	83 ec 04             	sub    $0x4,%esp
 418:	6a 01                	push   $0x1
 41a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41d:	50                   	push   %eax
 41e:	ff 75 08             	pushl  0x8(%ebp)
 421:	e8 57 ff ff ff       	call   37d <write>
 426:	83 c4 10             	add    $0x10,%esp
}
 429:	90                   	nop
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	f3 0f 1e fb          	endbr32 
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 441:	74 17                	je     45a <printint+0x2e>
 443:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 447:	79 11                	jns    45a <printint+0x2e>
    neg = 1;
 449:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 450:	8b 45 0c             	mov    0xc(%ebp),%eax
 453:	f7 d8                	neg    %eax
 455:	89 45 ec             	mov    %eax,-0x14(%ebp)
 458:	eb 06                	jmp    460 <printint+0x34>
  } else {
    x = xx;
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 467:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46d:	ba 00 00 00 00       	mov    $0x0,%edx
 472:	f7 f1                	div    %ecx
 474:	89 d1                	mov    %edx,%ecx
 476:	8b 45 f4             	mov    -0xc(%ebp),%eax
 479:	8d 50 01             	lea    0x1(%eax),%edx
 47c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47f:	0f b6 91 2c 0b 00 00 	movzbl 0xb2c(%ecx),%edx
 486:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 48a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 490:	ba 00 00 00 00       	mov    $0x0,%edx
 495:	f7 f1                	div    %ecx
 497:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49e:	75 c7                	jne    467 <printint+0x3b>
  if(neg)
 4a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a4:	74 2d                	je     4d3 <printint+0xa7>
    buf[i++] = '-';
 4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a9:	8d 50 01             	lea    0x1(%eax),%edx
 4ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4af:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b4:	eb 1d                	jmp    4d3 <printint+0xa7>
    putc(fd, buf[i]);
 4b6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	01 d0                	add    %edx,%eax
 4be:	0f b6 00             	movzbl (%eax),%eax
 4c1:	0f be c0             	movsbl %al,%eax
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	50                   	push   %eax
 4c8:	ff 75 08             	pushl  0x8(%ebp)
 4cb:	e8 35 ff ff ff       	call   405 <putc>
 4d0:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 d9                	jns    4b6 <printint+0x8a>
}
 4dd:	90                   	nop
 4de:	90                   	nop
 4df:	c9                   	leave  
 4e0:	c3                   	ret    

000004e1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4e1:	f3 0f 1e fb          	endbr32 
 4e5:	55                   	push   %ebp
 4e6:	89 e5                	mov    %esp,%ebp
 4e8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f5:	83 c0 04             	add    $0x4,%eax
 4f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 502:	e9 59 01 00 00       	jmp    660 <printf+0x17f>
    c = fmt[i] & 0xff;
 507:	8b 55 0c             	mov    0xc(%ebp),%edx
 50a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50d:	01 d0                	add    %edx,%eax
 50f:	0f b6 00             	movzbl (%eax),%eax
 512:	0f be c0             	movsbl %al,%eax
 515:	25 ff 00 00 00       	and    $0xff,%eax
 51a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 521:	75 2c                	jne    54f <printf+0x6e>
      if(c == '%'){
 523:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 527:	75 0c                	jne    535 <printf+0x54>
        state = '%';
 529:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 530:	e9 27 01 00 00       	jmp    65c <printf+0x17b>
      } else {
        putc(fd, c);
 535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	83 ec 08             	sub    $0x8,%esp
 53e:	50                   	push   %eax
 53f:	ff 75 08             	pushl  0x8(%ebp)
 542:	e8 be fe ff ff       	call   405 <putc>
 547:	83 c4 10             	add    $0x10,%esp
 54a:	e9 0d 01 00 00       	jmp    65c <printf+0x17b>
      }
    } else if(state == '%'){
 54f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 553:	0f 85 03 01 00 00    	jne    65c <printf+0x17b>
      if(c == 'd'){
 559:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55d:	75 1e                	jne    57d <printf+0x9c>
        printint(fd, *ap, 10, 1);
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	8b 00                	mov    (%eax),%eax
 564:	6a 01                	push   $0x1
 566:	6a 0a                	push   $0xa
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 bb fe ff ff       	call   42c <printint>
 571:	83 c4 10             	add    $0x10,%esp
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 578:	e9 d8 00 00 00       	jmp    655 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 57d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 581:	74 06                	je     589 <printf+0xa8>
 583:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 587:	75 1e                	jne    5a7 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	8b 00                	mov    (%eax),%eax
 58e:	6a 00                	push   $0x0
 590:	6a 10                	push   $0x10
 592:	50                   	push   %eax
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 91 fe ff ff       	call   42c <printint>
 59b:	83 c4 10             	add    $0x10,%esp
        ap++;
 59e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a2:	e9 ae 00 00 00       	jmp    655 <printf+0x174>
      } else if(c == 's'){
 5a7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ab:	75 43                	jne    5f0 <printf+0x10f>
        s = (char*)*ap;
 5ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b0:	8b 00                	mov    (%eax),%eax
 5b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bd:	75 25                	jne    5e4 <printf+0x103>
          s = "(null)";
 5bf:	c7 45 f4 db 08 00 00 	movl   $0x8db,-0xc(%ebp)
        while(*s != 0){
 5c6:	eb 1c                	jmp    5e4 <printf+0x103>
          putc(fd, *s);
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	83 ec 08             	sub    $0x8,%esp
 5d4:	50                   	push   %eax
 5d5:	ff 75 08             	pushl  0x8(%ebp)
 5d8:	e8 28 fe ff ff       	call   405 <putc>
 5dd:	83 c4 10             	add    $0x10,%esp
          s++;
 5e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	84 c0                	test   %al,%al
 5ec:	75 da                	jne    5c8 <printf+0xe7>
 5ee:	eb 65                	jmp    655 <printf+0x174>
        }
      } else if(c == 'c'){
 5f0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f4:	75 1d                	jne    613 <printf+0x132>
        putc(fd, *ap);
 5f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	0f be c0             	movsbl %al,%eax
 5fe:	83 ec 08             	sub    $0x8,%esp
 601:	50                   	push   %eax
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	e8 fb fd ff ff       	call   405 <putc>
 60a:	83 c4 10             	add    $0x10,%esp
        ap++;
 60d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 611:	eb 42                	jmp    655 <printf+0x174>
      } else if(c == '%'){
 613:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 617:	75 17                	jne    630 <printf+0x14f>
        putc(fd, c);
 619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	50                   	push   %eax
 623:	ff 75 08             	pushl  0x8(%ebp)
 626:	e8 da fd ff ff       	call   405 <putc>
 62b:	83 c4 10             	add    $0x10,%esp
 62e:	eb 25                	jmp    655 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 630:	83 ec 08             	sub    $0x8,%esp
 633:	6a 25                	push   $0x25
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 c8 fd ff ff       	call   405 <putc>
 63d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 643:	0f be c0             	movsbl %al,%eax
 646:	83 ec 08             	sub    $0x8,%esp
 649:	50                   	push   %eax
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 b3 fd ff ff       	call   405 <putc>
 652:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 655:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 65c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 660:	8b 55 0c             	mov    0xc(%ebp),%edx
 663:	8b 45 f0             	mov    -0x10(%ebp),%eax
 666:	01 d0                	add    %edx,%eax
 668:	0f b6 00             	movzbl (%eax),%eax
 66b:	84 c0                	test   %al,%al
 66d:	0f 85 94 fe ff ff    	jne    507 <printf+0x26>
    }
  }
}
 673:	90                   	nop
 674:	90                   	nop
 675:	c9                   	leave  
 676:	c3                   	ret    

00000677 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 677:	f3 0f 1e fb          	endbr32 
 67b:	55                   	push   %ebp
 67c:	89 e5                	mov    %esp,%ebp
 67e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	83 e8 08             	sub    $0x8,%eax
 687:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	a1 48 0b 00 00       	mov    0xb48,%eax
 68f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 692:	eb 24                	jmp    6b8 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 69c:	72 12                	jb     6b0 <free+0x39>
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a4:	77 24                	ja     6ca <free+0x53>
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6ae:	72 1a                	jb     6ca <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6be:	76 d4                	jbe    694 <free+0x1d>
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c8:	73 ca                	jae    694 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	8b 40 04             	mov    0x4(%eax),%eax
 6d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	01 c2                	add    %eax,%edx
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	39 c2                	cmp    %eax,%edx
 6e3:	75 24                	jne    709 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	8b 50 04             	mov    0x4(%eax),%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 00                	mov    (%eax),%eax
 6f0:	8b 40 04             	mov    0x4(%eax),%eax
 6f3:	01 c2                	add    %eax,%edx
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	8b 10                	mov    (%eax),%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	89 10                	mov    %edx,(%eax)
 707:	eb 0a                	jmp    713 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 10                	mov    (%eax),%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 40 04             	mov    0x4(%eax),%eax
 719:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	01 d0                	add    %edx,%eax
 725:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 728:	75 20                	jne    74a <free+0xd3>
    p->s.size += bp->s.size;
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 50 04             	mov    0x4(%eax),%edx
 730:	8b 45 f8             	mov    -0x8(%ebp),%eax
 733:	8b 40 04             	mov    0x4(%eax),%eax
 736:	01 c2                	add    %eax,%edx
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
 748:	eb 08                	jmp    752 <free+0xdb>
  } else
    p->s.ptr = bp;
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 750:	89 10                	mov    %edx,(%eax)
  freep = p;
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	a3 48 0b 00 00       	mov    %eax,0xb48
}
 75a:	90                   	nop
 75b:	c9                   	leave  
 75c:	c3                   	ret    

0000075d <morecore>:

static Header*
morecore(uint nu)
{
 75d:	f3 0f 1e fb          	endbr32 
 761:	55                   	push   %ebp
 762:	89 e5                	mov    %esp,%ebp
 764:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 767:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 76e:	77 07                	ja     777 <morecore+0x1a>
    nu = 4096;
 770:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	c1 e0 03             	shl    $0x3,%eax
 77d:	83 ec 0c             	sub    $0xc,%esp
 780:	50                   	push   %eax
 781:	e8 5f fc ff ff       	call   3e5 <sbrk>
 786:	83 c4 10             	add    $0x10,%esp
 789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 790:	75 07                	jne    799 <morecore+0x3c>
    return 0;
 792:	b8 00 00 00 00       	mov    $0x0,%eax
 797:	eb 26                	jmp    7bf <morecore+0x62>
  hp = (Header*)p;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	8b 55 08             	mov    0x8(%ebp),%edx
 7a5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ab:	83 c0 08             	add    $0x8,%eax
 7ae:	83 ec 0c             	sub    $0xc,%esp
 7b1:	50                   	push   %eax
 7b2:	e8 c0 fe ff ff       	call   677 <free>
 7b7:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ba:	a1 48 0b 00 00       	mov    0xb48,%eax
}
 7bf:	c9                   	leave  
 7c0:	c3                   	ret    

000007c1 <malloc>:

void*
malloc(uint nbytes)
{
 7c1:	f3 0f 1e fb          	endbr32 
 7c5:	55                   	push   %ebp
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7cb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ce:	83 c0 07             	add    $0x7,%eax
 7d1:	c1 e8 03             	shr    $0x3,%eax
 7d4:	83 c0 01             	add    $0x1,%eax
 7d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7da:	a1 48 0b 00 00       	mov    0xb48,%eax
 7df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e6:	75 23                	jne    80b <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7e8:	c7 45 f0 40 0b 00 00 	movl   $0xb40,-0x10(%ebp)
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	a3 48 0b 00 00       	mov    %eax,0xb48
 7f7:	a1 48 0b 00 00       	mov    0xb48,%eax
 7fc:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 801:	c7 05 44 0b 00 00 00 	movl   $0x0,0xb44
 808:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 81c:	77 4d                	ja     86b <malloc+0xaa>
      if(p->s.size == nunits)
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 827:	75 0c                	jne    835 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 10                	mov    (%eax),%edx
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 831:	89 10                	mov    %edx,(%eax)
 833:	eb 26                	jmp    85b <malloc+0x9a>
      else {
        p->s.size -= nunits;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 40 04             	mov    0x4(%eax),%eax
 83b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83e:	89 c2                	mov    %eax,%edx
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	c1 e0 03             	shl    $0x3,%eax
 84f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 55 ec             	mov    -0x14(%ebp),%edx
 858:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	a3 48 0b 00 00       	mov    %eax,0xb48
      return (void*)(p + 1);
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	83 c0 08             	add    $0x8,%eax
 869:	eb 3b                	jmp    8a6 <malloc+0xe5>
    }
    if(p == freep)
 86b:	a1 48 0b 00 00       	mov    0xb48,%eax
 870:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 873:	75 1e                	jne    893 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 875:	83 ec 0c             	sub    $0xc,%esp
 878:	ff 75 ec             	pushl  -0x14(%ebp)
 87b:	e8 dd fe ff ff       	call   75d <morecore>
 880:	83 c4 10             	add    $0x10,%esp
 883:	89 45 f4             	mov    %eax,-0xc(%ebp)
 886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88a:	75 07                	jne    893 <malloc+0xd2>
        return 0;
 88c:	b8 00 00 00 00       	mov    $0x0,%eax
 891:	eb 13                	jmp    8a6 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 45 f0             	mov    %eax,-0x10(%ebp)
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 00                	mov    (%eax),%eax
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a1:	e9 6d ff ff ff       	jmp    813 <malloc+0x52>
  }
}
 8a6:	c9                   	leave  
 8a7:	c3                   	ret    
