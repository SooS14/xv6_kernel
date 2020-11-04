
_mknod:     format de fichier elf32-i386


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
  int maj, min;

  if(argc != 4){
  18:	83 3b 04             	cmpl   $0x4,(%ebx)
  1b:	74 17                	je     34 <main+0x34>
    printf(2, "Usage: mknod path major minor\n");
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	68 bc 08 00 00       	push   $0x8bc
  25:	6a 02                	push   $0x2
  27:	e8 c9 04 00 00       	call   4f5 <printf>
  2c:	83 c4 10             	add    $0x10,%esp
    exit();
  2f:	e8 3d 03 00 00       	call   371 <exit>
  }

  maj = atoi (argv [2]);
  34:	8b 43 04             	mov    0x4(%ebx),%eax
  37:	83 c0 08             	add    $0x8,%eax
  3a:	8b 00                	mov    (%eax),%eax
  3c:	83 ec 0c             	sub    $0xc,%esp
  3f:	50                   	push   %eax
  40:	e8 44 02 00 00       	call   289 <atoi>
  45:	83 c4 10             	add    $0x10,%esp
  48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  min = atoi (argv [3]);
  4b:	8b 43 04             	mov    0x4(%ebx),%eax
  4e:	83 c0 0c             	add    $0xc,%eax
  51:	8b 00                	mov    (%eax),%eax
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	50                   	push   %eax
  57:	e8 2d 02 00 00       	call   289 <atoi>
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (mknod (argv[1], maj, min) < 0){
  62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  65:	0f bf c8             	movswl %ax,%ecx
  68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6b:	0f bf d0             	movswl %ax,%edx
  6e:	8b 43 04             	mov    0x4(%ebx),%eax
  71:	83 c0 04             	add    $0x4,%eax
  74:	8b 00                	mov    (%eax),%eax
  76:	83 ec 04             	sub    $0x4,%esp
  79:	51                   	push   %ecx
  7a:	52                   	push   %edx
  7b:	50                   	push   %eax
  7c:	e8 38 03 00 00       	call   3b9 <mknod>
  81:	83 c4 10             	add    $0x10,%esp
  84:	85 c0                	test   %eax,%eax
  86:	79 1b                	jns    a3 <main+0xa3>
    printf(2, "mkdir: %s failed to create\n", argv[1]);
  88:	8b 43 04             	mov    0x4(%ebx),%eax
  8b:	83 c0 04             	add    $0x4,%eax
  8e:	8b 00                	mov    (%eax),%eax
  90:	83 ec 04             	sub    $0x4,%esp
  93:	50                   	push   %eax
  94:	68 db 08 00 00       	push   $0x8db
  99:	6a 02                	push   $0x2
  9b:	e8 55 04 00 00       	call   4f5 <printf>
  a0:	83 c4 10             	add    $0x10,%esp
  }

  exit();
  a3:	e8 c9 02 00 00       	call   371 <exit>

000000a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b0:	8b 55 10             	mov    0x10(%ebp),%edx
  b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  b6:	89 cb                	mov    %ecx,%ebx
  b8:	89 df                	mov    %ebx,%edi
  ba:	89 d1                	mov    %edx,%ecx
  bc:	fc                   	cld    
  bd:	f3 aa                	rep stos %al,%es:(%edi)
  bf:	89 ca                	mov    %ecx,%edx
  c1:	89 fb                	mov    %edi,%ebx
  c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c9:	90                   	nop
  ca:	5b                   	pop    %ebx
  cb:	5f                   	pop    %edi
  cc:	5d                   	pop    %ebp
  cd:	c3                   	ret    

000000ce <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  ce:	f3 0f 1e fb          	endbr32 
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  d5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  de:	90                   	nop
  df:	8b 55 0c             	mov    0xc(%ebp),%edx
  e2:	8d 42 01             	lea    0x1(%edx),%eax
  e5:	89 45 0c             	mov    %eax,0xc(%ebp)
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	8d 48 01             	lea    0x1(%eax),%ecx
  ee:	89 4d 08             	mov    %ecx,0x8(%ebp)
  f1:	0f b6 12             	movzbl (%edx),%edx
  f4:	88 10                	mov    %dl,(%eax)
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	75 e2                	jne    df <strcpy+0x11>
    ;
  return os;
  fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 102:	f3 0f 1e fb          	endbr32 
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 109:	eb 08                	jmp    113 <strcmp+0x11>
    p++, q++;
 10b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	74 10                	je     12d <strcmp+0x2b>
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	0f b6 10             	movzbl (%eax),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	38 c2                	cmp    %al,%dl
 12b:	74 de                	je     10b <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	0f b6 00             	movzbl (%eax),%eax
 133:	0f b6 d0             	movzbl %al,%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	0f b6 00             	movzbl (%eax),%eax
 13c:	0f b6 c0             	movzbl %al,%eax
 13f:	29 c2                	sub    %eax,%edx
 141:	89 d0                	mov    %edx,%eax
}
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    

00000145 <strlen>:

uint
strlen(const char *s)
{
 145:	f3 0f 1e fb          	endbr32 
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 14f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 156:	eb 04                	jmp    15c <strlen+0x17>
 158:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 15c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	01 d0                	add    %edx,%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	84 c0                	test   %al,%al
 169:	75 ed                	jne    158 <strlen+0x13>
    ;
  return n;
 16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 177:	8b 45 10             	mov    0x10(%ebp),%eax
 17a:	50                   	push   %eax
 17b:	ff 75 0c             	pushl  0xc(%ebp)
 17e:	ff 75 08             	pushl  0x8(%ebp)
 181:	e8 22 ff ff ff       	call   a8 <stosb>
 186:	83 c4 0c             	add    $0xc,%esp
  return dst;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <strchr>:

char*
strchr(const char *s, char c)
{
 18e:	f3 0f 1e fb          	endbr32 
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	83 ec 04             	sub    $0x4,%esp
 198:	8b 45 0c             	mov    0xc(%ebp),%eax
 19b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 19e:	eb 14                	jmp    1b4 <strchr+0x26>
    if(*s == c)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1a9:	75 05                	jne    1b0 <strchr+0x22>
      return (char*)s;
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	eb 13                	jmp    1c3 <strchr+0x35>
  for(; *s; s++)
 1b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	84 c0                	test   %al,%al
 1bc:	75 e2                	jne    1a0 <strchr+0x12>
  return 0;
 1be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c3:	c9                   	leave  
 1c4:	c3                   	ret    

000001c5 <gets>:

char*
gets(char *buf, int max)
{
 1c5:	f3 0f 1e fb          	endbr32 
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d6:	eb 42                	jmp    21a <gets+0x55>
    cc = read(0, &c, 1);
 1d8:	83 ec 04             	sub    $0x4,%esp
 1db:	6a 01                	push   $0x1
 1dd:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e0:	50                   	push   %eax
 1e1:	6a 00                	push   $0x0
 1e3:	e8 a1 01 00 00       	call   389 <read>
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f2:	7e 33                	jle    227 <gets+0x62>
      break;
    buf[i++] = c;
 1f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f7:	8d 50 01             	lea    0x1(%eax),%edx
 1fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1fd:	89 c2                	mov    %eax,%edx
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	01 c2                	add    %eax,%edx
 204:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 208:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 20a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20e:	3c 0a                	cmp    $0xa,%al
 210:	74 16                	je     228 <gets+0x63>
 212:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 216:	3c 0d                	cmp    $0xd,%al
 218:	74 0e                	je     228 <gets+0x63>
  for(i=0; i+1 < max; ){
 21a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21d:	83 c0 01             	add    $0x1,%eax
 220:	39 45 0c             	cmp    %eax,0xc(%ebp)
 223:	7f b3                	jg     1d8 <gets+0x13>
 225:	eb 01                	jmp    228 <gets+0x63>
      break;
 227:	90                   	nop
      break;
  }
  buf[i] = '\0';
 228:	8b 55 f4             	mov    -0xc(%ebp),%edx
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	01 d0                	add    %edx,%eax
 230:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	f3 0f 1e fb          	endbr32 
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 242:	83 ec 08             	sub    $0x8,%esp
 245:	6a 00                	push   $0x0
 247:	ff 75 08             	pushl  0x8(%ebp)
 24a:	e8 62 01 00 00       	call   3b1 <open>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 259:	79 07                	jns    262 <stat+0x2a>
    return -1;
 25b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 260:	eb 25                	jmp    287 <stat+0x4f>
  r = fstat(fd, st);
 262:	83 ec 08             	sub    $0x8,%esp
 265:	ff 75 0c             	pushl  0xc(%ebp)
 268:	ff 75 f4             	pushl  -0xc(%ebp)
 26b:	e8 59 01 00 00       	call   3c9 <fstat>
 270:	83 c4 10             	add    $0x10,%esp
 273:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 276:	83 ec 0c             	sub    $0xc,%esp
 279:	ff 75 f4             	pushl  -0xc(%ebp)
 27c:	e8 18 01 00 00       	call   399 <close>
 281:	83 c4 10             	add    $0x10,%esp
  return r;
 284:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <atoi>:



int
atoi(const char *s)
{
 289:	f3 0f 1e fb          	endbr32 
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp
 290:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	0f b6 00             	movzbl (%eax),%eax
 2a0:	3c 2d                	cmp    $0x2d,%al
 2a2:	75 6b                	jne    30f <atoi+0x86>
  {
    s++;
 2a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 2a8:	eb 25                	jmp    2cf <atoi+0x46>
        n = n*10 + *s++ - '0';
 2aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ad:	89 d0                	mov    %edx,%eax
 2af:	c1 e0 02             	shl    $0x2,%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	01 c0                	add    %eax,%eax
 2b6:	89 c1                	mov    %eax,%ecx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8d 50 01             	lea    0x1(%eax),%edx
 2be:	89 55 08             	mov    %edx,0x8(%ebp)
 2c1:	0f b6 00             	movzbl (%eax),%eax
 2c4:	0f be c0             	movsbl %al,%eax
 2c7:	01 c8                	add    %ecx,%eax
 2c9:	83 e8 30             	sub    $0x30,%eax
 2cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	3c 2f                	cmp    $0x2f,%al
 2d7:	7e 0a                	jle    2e3 <atoi+0x5a>
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 39                	cmp    $0x39,%al
 2e1:	7e c7                	jle    2aa <atoi+0x21>

    return -n;
 2e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e6:	f7 d8                	neg    %eax
 2e8:	eb 3c                	jmp    326 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 2ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ed:	89 d0                	mov    %edx,%eax
 2ef:	c1 e0 02             	shl    $0x2,%eax
 2f2:	01 d0                	add    %edx,%eax
 2f4:	01 c0                	add    %eax,%eax
 2f6:	89 c1                	mov    %eax,%ecx
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	8d 50 01             	lea    0x1(%eax),%edx
 2fe:	89 55 08             	mov    %edx,0x8(%ebp)
 301:	0f b6 00             	movzbl (%eax),%eax
 304:	0f be c0             	movsbl %al,%eax
 307:	01 c8                	add    %ecx,%eax
 309:	83 e8 30             	sub    $0x30,%eax
 30c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 00             	movzbl (%eax),%eax
 315:	3c 2f                	cmp    $0x2f,%al
 317:	7e 0a                	jle    323 <atoi+0x9a>
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 39                	cmp    $0x39,%al
 321:	7e c7                	jle    2ea <atoi+0x61>

    return n;
 323:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 326:	c9                   	leave  
 327:	c3                   	ret    

00000328 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 328:	f3 0f 1e fb          	endbr32 
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 338:	8b 45 0c             	mov    0xc(%ebp),%eax
 33b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 33e:	eb 17                	jmp    357 <memmove+0x2f>
    *dst++ = *src++;
 340:	8b 55 f8             	mov    -0x8(%ebp),%edx
 343:	8d 42 01             	lea    0x1(%edx),%eax
 346:	89 45 f8             	mov    %eax,-0x8(%ebp)
 349:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34c:	8d 48 01             	lea    0x1(%eax),%ecx
 34f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 352:	0f b6 12             	movzbl (%edx),%edx
 355:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 357:	8b 45 10             	mov    0x10(%ebp),%eax
 35a:	8d 50 ff             	lea    -0x1(%eax),%edx
 35d:	89 55 10             	mov    %edx,0x10(%ebp)
 360:	85 c0                	test   %eax,%eax
 362:	7f dc                	jg     340 <memmove+0x18>
  return vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 369:	b8 01 00 00 00       	mov    $0x1,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <exit>:
SYSCALL(exit)
 371:	b8 02 00 00 00       	mov    $0x2,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <wait>:
SYSCALL(wait)
 379:	b8 03 00 00 00       	mov    $0x3,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <pipe>:
SYSCALL(pipe)
 381:	b8 04 00 00 00       	mov    $0x4,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <read>:
SYSCALL(read)
 389:	b8 05 00 00 00       	mov    $0x5,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <write>:
SYSCALL(write)
 391:	b8 10 00 00 00       	mov    $0x10,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <close>:
SYSCALL(close)
 399:	b8 15 00 00 00       	mov    $0x15,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <kill>:
SYSCALL(kill)
 3a1:	b8 06 00 00 00       	mov    $0x6,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <exec>:
SYSCALL(exec)
 3a9:	b8 07 00 00 00       	mov    $0x7,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <open>:
SYSCALL(open)
 3b1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <mknod>:
SYSCALL(mknod)
 3b9:	b8 11 00 00 00       	mov    $0x11,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <unlink>:
SYSCALL(unlink)
 3c1:	b8 12 00 00 00       	mov    $0x12,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <fstat>:
SYSCALL(fstat)
 3c9:	b8 08 00 00 00       	mov    $0x8,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <link>:
SYSCALL(link)
 3d1:	b8 13 00 00 00       	mov    $0x13,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <mkdir>:
SYSCALL(mkdir)
 3d9:	b8 14 00 00 00       	mov    $0x14,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <chdir>:
SYSCALL(chdir)
 3e1:	b8 09 00 00 00       	mov    $0x9,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <dup>:
SYSCALL(dup)
 3e9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <getpid>:
SYSCALL(getpid)
 3f1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <sbrk>:
SYSCALL(sbrk)
 3f9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <sleep>:
SYSCALL(sleep)
 401:	b8 0d 00 00 00       	mov    $0xd,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <uptime>:
SYSCALL(uptime)
 409:	b8 0e 00 00 00       	mov    $0xe,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <lseek>:
SYSCALL(lseek)
 411:	b8 16 00 00 00       	mov    $0x16,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 419:	f3 0f 1e fb          	endbr32 
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	83 ec 18             	sub    $0x18,%esp
 423:	8b 45 0c             	mov    0xc(%ebp),%eax
 426:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 429:	83 ec 04             	sub    $0x4,%esp
 42c:	6a 01                	push   $0x1
 42e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 431:	50                   	push   %eax
 432:	ff 75 08             	pushl  0x8(%ebp)
 435:	e8 57 ff ff ff       	call   391 <write>
 43a:	83 c4 10             	add    $0x10,%esp
}
 43d:	90                   	nop
 43e:	c9                   	leave  
 43f:	c3                   	ret    

00000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	f3 0f 1e fb          	endbr32 
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 451:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 455:	74 17                	je     46e <printint+0x2e>
 457:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45b:	79 11                	jns    46e <printint+0x2e>
    neg = 1;
 45d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 464:	8b 45 0c             	mov    0xc(%ebp),%eax
 467:	f7 d8                	neg    %eax
 469:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46c:	eb 06                	jmp    474 <printint+0x34>
  } else {
    x = xx;
 46e:	8b 45 0c             	mov    0xc(%ebp),%eax
 471:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 47e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 481:	ba 00 00 00 00       	mov    $0x0,%edx
 486:	f7 f1                	div    %ecx
 488:	89 d1                	mov    %edx,%ecx
 48a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48d:	8d 50 01             	lea    0x1(%eax),%edx
 490:	89 55 f4             	mov    %edx,-0xc(%ebp)
 493:	0f b6 91 48 0b 00 00 	movzbl 0xb48(%ecx),%edx
 49a:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 49e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a4:	ba 00 00 00 00       	mov    $0x0,%edx
 4a9:	f7 f1                	div    %ecx
 4ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b2:	75 c7                	jne    47b <printint+0x3b>
  if(neg)
 4b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b8:	74 2d                	je     4e7 <printint+0xa7>
    buf[i++] = '-';
 4ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bd:	8d 50 01             	lea    0x1(%eax),%edx
 4c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c8:	eb 1d                	jmp    4e7 <printint+0xa7>
    putc(fd, buf[i]);
 4ca:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d0:	01 d0                	add    %edx,%eax
 4d2:	0f b6 00             	movzbl (%eax),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	83 ec 08             	sub    $0x8,%esp
 4db:	50                   	push   %eax
 4dc:	ff 75 08             	pushl  0x8(%ebp)
 4df:	e8 35 ff ff ff       	call   419 <putc>
 4e4:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4e7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ef:	79 d9                	jns    4ca <printint+0x8a>
}
 4f1:	90                   	nop
 4f2:	90                   	nop
 4f3:	c9                   	leave  
 4f4:	c3                   	ret    

000004f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4f5:	f3 0f 1e fb          	endbr32 
 4f9:	55                   	push   %ebp
 4fa:	89 e5                	mov    %esp,%ebp
 4fc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 506:	8d 45 0c             	lea    0xc(%ebp),%eax
 509:	83 c0 04             	add    $0x4,%eax
 50c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 516:	e9 59 01 00 00       	jmp    674 <printf+0x17f>
    c = fmt[i] & 0xff;
 51b:	8b 55 0c             	mov    0xc(%ebp),%edx
 51e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 521:	01 d0                	add    %edx,%eax
 523:	0f b6 00             	movzbl (%eax),%eax
 526:	0f be c0             	movsbl %al,%eax
 529:	25 ff 00 00 00       	and    $0xff,%eax
 52e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 531:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 535:	75 2c                	jne    563 <printf+0x6e>
      if(c == '%'){
 537:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53b:	75 0c                	jne    549 <printf+0x54>
        state = '%';
 53d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 544:	e9 27 01 00 00       	jmp    670 <printf+0x17b>
      } else {
        putc(fd, c);
 549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	83 ec 08             	sub    $0x8,%esp
 552:	50                   	push   %eax
 553:	ff 75 08             	pushl  0x8(%ebp)
 556:	e8 be fe ff ff       	call   419 <putc>
 55b:	83 c4 10             	add    $0x10,%esp
 55e:	e9 0d 01 00 00       	jmp    670 <printf+0x17b>
      }
    } else if(state == '%'){
 563:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 567:	0f 85 03 01 00 00    	jne    670 <printf+0x17b>
      if(c == 'd'){
 56d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 571:	75 1e                	jne    591 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 573:	8b 45 e8             	mov    -0x18(%ebp),%eax
 576:	8b 00                	mov    (%eax),%eax
 578:	6a 01                	push   $0x1
 57a:	6a 0a                	push   $0xa
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 bb fe ff ff       	call   440 <printint>
 585:	83 c4 10             	add    $0x10,%esp
        ap++;
 588:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58c:	e9 d8 00 00 00       	jmp    669 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 591:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 595:	74 06                	je     59d <printf+0xa8>
 597:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 59b:	75 1e                	jne    5bb <printf+0xc6>
        printint(fd, *ap, 16, 0);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	6a 00                	push   $0x0
 5a4:	6a 10                	push   $0x10
 5a6:	50                   	push   %eax
 5a7:	ff 75 08             	pushl  0x8(%ebp)
 5aa:	e8 91 fe ff ff       	call   440 <printint>
 5af:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b6:	e9 ae 00 00 00       	jmp    669 <printf+0x174>
      } else if(c == 's'){
 5bb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5bf:	75 43                	jne    604 <printf+0x10f>
        s = (char*)*ap;
 5c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c4:	8b 00                	mov    (%eax),%eax
 5c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d1:	75 25                	jne    5f8 <printf+0x103>
          s = "(null)";
 5d3:	c7 45 f4 f7 08 00 00 	movl   $0x8f7,-0xc(%ebp)
        while(*s != 0){
 5da:	eb 1c                	jmp    5f8 <printf+0x103>
          putc(fd, *s);
 5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5df:	0f b6 00             	movzbl (%eax),%eax
 5e2:	0f be c0             	movsbl %al,%eax
 5e5:	83 ec 08             	sub    $0x8,%esp
 5e8:	50                   	push   %eax
 5e9:	ff 75 08             	pushl  0x8(%ebp)
 5ec:	e8 28 fe ff ff       	call   419 <putc>
 5f1:	83 c4 10             	add    $0x10,%esp
          s++;
 5f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fb:	0f b6 00             	movzbl (%eax),%eax
 5fe:	84 c0                	test   %al,%al
 600:	75 da                	jne    5dc <printf+0xe7>
 602:	eb 65                	jmp    669 <printf+0x174>
        }
      } else if(c == 'c'){
 604:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 608:	75 1d                	jne    627 <printf+0x132>
        putc(fd, *ap);
 60a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	0f be c0             	movsbl %al,%eax
 612:	83 ec 08             	sub    $0x8,%esp
 615:	50                   	push   %eax
 616:	ff 75 08             	pushl  0x8(%ebp)
 619:	e8 fb fd ff ff       	call   419 <putc>
 61e:	83 c4 10             	add    $0x10,%esp
        ap++;
 621:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 625:	eb 42                	jmp    669 <printf+0x174>
      } else if(c == '%'){
 627:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62b:	75 17                	jne    644 <printf+0x14f>
        putc(fd, c);
 62d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 630:	0f be c0             	movsbl %al,%eax
 633:	83 ec 08             	sub    $0x8,%esp
 636:	50                   	push   %eax
 637:	ff 75 08             	pushl  0x8(%ebp)
 63a:	e8 da fd ff ff       	call   419 <putc>
 63f:	83 c4 10             	add    $0x10,%esp
 642:	eb 25                	jmp    669 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 644:	83 ec 08             	sub    $0x8,%esp
 647:	6a 25                	push   $0x25
 649:	ff 75 08             	pushl  0x8(%ebp)
 64c:	e8 c8 fd ff ff       	call   419 <putc>
 651:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 657:	0f be c0             	movsbl %al,%eax
 65a:	83 ec 08             	sub    $0x8,%esp
 65d:	50                   	push   %eax
 65e:	ff 75 08             	pushl  0x8(%ebp)
 661:	e8 b3 fd ff ff       	call   419 <putc>
 666:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 669:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 670:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 674:	8b 55 0c             	mov    0xc(%ebp),%edx
 677:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67a:	01 d0                	add    %edx,%eax
 67c:	0f b6 00             	movzbl (%eax),%eax
 67f:	84 c0                	test   %al,%al
 681:	0f 85 94 fe ff ff    	jne    51b <printf+0x26>
    }
  }
}
 687:	90                   	nop
 688:	90                   	nop
 689:	c9                   	leave  
 68a:	c3                   	ret    

0000068b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68b:	f3 0f 1e fb          	endbr32 
 68f:	55                   	push   %ebp
 690:	89 e5                	mov    %esp,%ebp
 692:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	83 e8 08             	sub    $0x8,%eax
 69b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69e:	a1 64 0b 00 00       	mov    0xb64,%eax
 6a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a6:	eb 24                	jmp    6cc <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6b0:	72 12                	jb     6c4 <free+0x39>
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b8:	77 24                	ja     6de <free+0x53>
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c2:	72 1a                	jb     6de <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d2:	76 d4                	jbe    6a8 <free+0x1d>
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6dc:	73 ca                	jae    6a8 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	8b 40 04             	mov    0x4(%eax),%eax
 6e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	01 c2                	add    %eax,%edx
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	39 c2                	cmp    %eax,%edx
 6f7:	75 24                	jne    71d <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	8b 50 04             	mov    0x4(%eax),%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	8b 40 04             	mov    0x4(%eax),%eax
 707:	01 c2                	add    %eax,%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	8b 10                	mov    (%eax),%edx
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	89 10                	mov    %edx,(%eax)
 71b:	eb 0a                	jmp    727 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 10                	mov    (%eax),%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 40 04             	mov    0x4(%eax),%eax
 72d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	01 d0                	add    %edx,%eax
 739:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 73c:	75 20                	jne    75e <free+0xd3>
    p->s.size += bp->s.size;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 50 04             	mov    0x4(%eax),%edx
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	01 c2                	add    %eax,%edx
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
 75c:	eb 08                	jmp    766 <free+0xdb>
  } else
    p->s.ptr = bp;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 55 f8             	mov    -0x8(%ebp),%edx
 764:	89 10                	mov    %edx,(%eax)
  freep = p;
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	a3 64 0b 00 00       	mov    %eax,0xb64
}
 76e:	90                   	nop
 76f:	c9                   	leave  
 770:	c3                   	ret    

00000771 <morecore>:

static Header*
morecore(uint nu)
{
 771:	f3 0f 1e fb          	endbr32 
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 77b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 782:	77 07                	ja     78b <morecore+0x1a>
    nu = 4096;
 784:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 78b:	8b 45 08             	mov    0x8(%ebp),%eax
 78e:	c1 e0 03             	shl    $0x3,%eax
 791:	83 ec 0c             	sub    $0xc,%esp
 794:	50                   	push   %eax
 795:	e8 5f fc ff ff       	call   3f9 <sbrk>
 79a:	83 c4 10             	add    $0x10,%esp
 79d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a4:	75 07                	jne    7ad <morecore+0x3c>
    return 0;
 7a6:	b8 00 00 00 00       	mov    $0x0,%eax
 7ab:	eb 26                	jmp    7d3 <morecore+0x62>
  hp = (Header*)p;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b6:	8b 55 08             	mov    0x8(%ebp),%edx
 7b9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	83 c0 08             	add    $0x8,%eax
 7c2:	83 ec 0c             	sub    $0xc,%esp
 7c5:	50                   	push   %eax
 7c6:	e8 c0 fe ff ff       	call   68b <free>
 7cb:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ce:	a1 64 0b 00 00       	mov    0xb64,%eax
}
 7d3:	c9                   	leave  
 7d4:	c3                   	ret    

000007d5 <malloc>:

void*
malloc(uint nbytes)
{
 7d5:	f3 0f 1e fb          	endbr32 
 7d9:	55                   	push   %ebp
 7da:	89 e5                	mov    %esp,%ebp
 7dc:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7df:	8b 45 08             	mov    0x8(%ebp),%eax
 7e2:	83 c0 07             	add    $0x7,%eax
 7e5:	c1 e8 03             	shr    $0x3,%eax
 7e8:	83 c0 01             	add    $0x1,%eax
 7eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ee:	a1 64 0b 00 00       	mov    0xb64,%eax
 7f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7fa:	75 23                	jne    81f <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7fc:	c7 45 f0 5c 0b 00 00 	movl   $0xb5c,-0x10(%ebp)
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	a3 64 0b 00 00       	mov    %eax,0xb64
 80b:	a1 64 0b 00 00       	mov    0xb64,%eax
 810:	a3 5c 0b 00 00       	mov    %eax,0xb5c
    base.s.size = 0;
 815:	c7 05 60 0b 00 00 00 	movl   $0x0,0xb60
 81c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 40 04             	mov    0x4(%eax),%eax
 82d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 830:	77 4d                	ja     87f <malloc+0xaa>
      if(p->s.size == nunits)
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 40 04             	mov    0x4(%eax),%eax
 838:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 83b:	75 0c                	jne    849 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	8b 10                	mov    (%eax),%edx
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	89 10                	mov    %edx,(%eax)
 847:	eb 26                	jmp    86f <malloc+0x9a>
      else {
        p->s.size -= nunits;
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 852:	89 c2                	mov    %eax,%edx
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	8b 40 04             	mov    0x4(%eax),%eax
 860:	c1 e0 03             	shl    $0x3,%eax
 863:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 86f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 872:	a3 64 0b 00 00       	mov    %eax,0xb64
      return (void*)(p + 1);
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	83 c0 08             	add    $0x8,%eax
 87d:	eb 3b                	jmp    8ba <malloc+0xe5>
    }
    if(p == freep)
 87f:	a1 64 0b 00 00       	mov    0xb64,%eax
 884:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 887:	75 1e                	jne    8a7 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 889:	83 ec 0c             	sub    $0xc,%esp
 88c:	ff 75 ec             	pushl  -0x14(%ebp)
 88f:	e8 dd fe ff ff       	call   771 <morecore>
 894:	83 c4 10             	add    $0x10,%esp
 897:	89 45 f4             	mov    %eax,-0xc(%ebp)
 89a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89e:	75 07                	jne    8a7 <malloc+0xd2>
        return 0;
 8a0:	b8 00 00 00 00       	mov    $0x0,%eax
 8a5:	eb 13                	jmp    8ba <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b5:	e9 6d ff ff ff       	jmp    827 <malloc+0x52>
  }
}
 8ba:	c9                   	leave  
 8bb:	c3                   	ret    
