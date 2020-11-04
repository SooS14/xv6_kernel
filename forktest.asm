
_forktest:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 08             	sub    $0x8,%esp
  write(fd, s, strlen(s));
   a:	83 ec 0c             	sub    $0xc,%esp
   d:	ff 75 0c             	pushl  0xc(%ebp)
  10:	e8 9c 01 00 00       	call   1b1 <strlen>
  15:	83 c4 10             	add    $0x10,%esp
  18:	83 ec 04             	sub    $0x4,%esp
  1b:	50                   	push   %eax
  1c:	ff 75 0c             	pushl  0xc(%ebp)
  1f:	ff 75 08             	pushl  0x8(%ebp)
  22:	e8 d6 03 00 00       	call   3fd <write>
  27:	83 c4 10             	add    $0x10,%esp
}
  2a:	90                   	nop
  2b:	c9                   	leave  
  2c:	c3                   	ret    

0000002d <forktest>:

void
forktest(void)
{
  2d:	f3 0f 1e fb          	endbr32 
  31:	55                   	push   %ebp
  32:	89 e5                	mov    %esp,%ebp
  34:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	68 88 04 00 00       	push   $0x488
  3f:	6a 01                	push   $0x1
  41:	e8 ba ff ff ff       	call   0 <printf>
  46:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  50:	eb 1d                	jmp    6f <forktest+0x42>
    pid = fork();
  52:	e8 7e 03 00 00       	call   3d5 <fork>
  57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5e:	78 1a                	js     7a <forktest+0x4d>
      break;
    if(pid == 0)
  60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  64:	75 05                	jne    6b <forktest+0x3e>
      exit();
  66:	e8 72 03 00 00       	call   3dd <exit>
  for(n=0; n<N; n++){
  6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  76:	7e da                	jle    52 <forktest+0x25>
  78:	eb 01                	jmp    7b <forktest+0x4e>
      break;
  7a:	90                   	nop
  }

  if(n == N){
  7b:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  82:	75 40                	jne    c4 <forktest+0x97>
    printf(1, "fork claimed to work N times!\n", N);
  84:	83 ec 04             	sub    $0x4,%esp
  87:	68 e8 03 00 00       	push   $0x3e8
  8c:	68 94 04 00 00       	push   $0x494
  91:	6a 01                	push   $0x1
  93:	e8 68 ff ff ff       	call   0 <printf>
  98:	83 c4 10             	add    $0x10,%esp
    exit();
  9b:	e8 3d 03 00 00       	call   3dd <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
  a0:	e8 40 03 00 00       	call   3e5 <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	79 17                	jns    c0 <forktest+0x93>
      printf(1, "wait stopped early\n");
  a9:	83 ec 08             	sub    $0x8,%esp
  ac:	68 b3 04 00 00       	push   $0x4b3
  b1:	6a 01                	push   $0x1
  b3:	e8 48 ff ff ff       	call   0 <printf>
  b8:	83 c4 10             	add    $0x10,%esp
      exit();
  bb:	e8 1d 03 00 00       	call   3dd <exit>
  for(; n > 0; n--){
  c0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  c8:	7f d6                	jg     a0 <forktest+0x73>
    }
  }

  if(wait() != -1){
  ca:	e8 16 03 00 00       	call   3e5 <wait>
  cf:	83 f8 ff             	cmp    $0xffffffff,%eax
  d2:	74 17                	je     eb <forktest+0xbe>
    printf(1, "wait got too many\n");
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	68 c7 04 00 00       	push   $0x4c7
  dc:	6a 01                	push   $0x1
  de:	e8 1d ff ff ff       	call   0 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
    exit();
  e6:	e8 f2 02 00 00       	call   3dd <exit>
  }

  printf(1, "fork test OK\n");
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	68 da 04 00 00       	push   $0x4da
  f3:	6a 01                	push   $0x1
  f5:	e8 06 ff ff ff       	call   0 <printf>
  fa:	83 c4 10             	add    $0x10,%esp
}
  fd:	90                   	nop
  fe:	c9                   	leave  
  ff:	c3                   	ret    

00000100 <main>:

int
main(void)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 10a:	e8 1e ff ff ff       	call   2d <forktest>
  exit();
 10f:	e8 c9 02 00 00       	call   3dd <exit>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	90                   	nop
 136:	5b                   	pop    %ebx
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 13a:	f3 0f 1e fb          	endbr32 
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14a:	90                   	nop
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 42 01             	lea    0x1(%edx),%eax
 151:	89 45 0c             	mov    %eax,0xc(%ebp)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8d 48 01             	lea    0x1(%eax),%ecx
 15a:	89 4d 08             	mov    %ecx,0x8(%ebp)
 15d:	0f b6 12             	movzbl (%edx),%edx
 160:	88 10                	mov    %dl,(%eax)
 162:	0f b6 00             	movzbl (%eax),%eax
 165:	84 c0                	test   %al,%al
 167:	75 e2                	jne    14b <strcpy+0x11>
    ;
  return os;
 169:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16e:	f3 0f 1e fb          	endbr32 
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 175:	eb 08                	jmp    17f <strcmp+0x11>
    p++, q++;
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	74 10                	je     199 <strcmp+0x2b>
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	38 c2                	cmp    %al,%dl
 197:	74 de                	je     177 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 d0             	movzbl %al,%edx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	0f b6 c0             	movzbl %al,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(const char *s)
{
 1b1:	f3 0f 1e fb          	endbr32 
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c2:	eb 04                	jmp    1c8 <strlen+0x17>
 1c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	01 d0                	add    %edx,%eax
 1d0:	0f b6 00             	movzbl (%eax),%eax
 1d3:	84 c0                	test   %al,%al
 1d5:	75 ed                	jne    1c4 <strlen+0x13>
    ;
  return n;
 1d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1dc:	f3 0f 1e fb          	endbr32 
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e3:	8b 45 10             	mov    0x10(%ebp),%eax
 1e6:	50                   	push   %eax
 1e7:	ff 75 0c             	pushl  0xc(%ebp)
 1ea:	ff 75 08             	pushl  0x8(%ebp)
 1ed:	e8 22 ff ff ff       	call   114 <stosb>
 1f2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <strchr>:

char*
strchr(const char *s, char c)
{
 1fa:	f3 0f 1e fb          	endbr32 
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 04             	sub    $0x4,%esp
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20a:	eb 14                	jmp    220 <strchr+0x26>
    if(*s == c)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	0f b6 00             	movzbl (%eax),%eax
 212:	38 45 fc             	cmp    %al,-0x4(%ebp)
 215:	75 05                	jne    21c <strchr+0x22>
      return (char*)s;
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	eb 13                	jmp    22f <strchr+0x35>
  for(; *s; s++)
 21c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	75 e2                	jne    20c <strchr+0x12>
  return 0;
 22a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22f:	c9                   	leave  
 230:	c3                   	ret    

00000231 <gets>:

char*
gets(char *buf, int max)
{
 231:	f3 0f 1e fb          	endbr32 
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 242:	eb 42                	jmp    286 <gets+0x55>
    cc = read(0, &c, 1);
 244:	83 ec 04             	sub    $0x4,%esp
 247:	6a 01                	push   $0x1
 249:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24c:	50                   	push   %eax
 24d:	6a 00                	push   $0x0
 24f:	e8 a1 01 00 00       	call   3f5 <read>
 254:	83 c4 10             	add    $0x10,%esp
 257:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25e:	7e 33                	jle    293 <gets+0x62>
      break;
    buf[i++] = c;
 260:	8b 45 f4             	mov    -0xc(%ebp),%eax
 263:	8d 50 01             	lea    0x1(%eax),%edx
 266:	89 55 f4             	mov    %edx,-0xc(%ebp)
 269:	89 c2                	mov    %eax,%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	01 c2                	add    %eax,%edx
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 276:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27a:	3c 0a                	cmp    $0xa,%al
 27c:	74 16                	je     294 <gets+0x63>
 27e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 282:	3c 0d                	cmp    $0xd,%al
 284:	74 0e                	je     294 <gets+0x63>
  for(i=0; i+1 < max; ){
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 28f:	7f b3                	jg     244 <gets+0x13>
 291:	eb 01                	jmp    294 <gets+0x63>
      break;
 293:	90                   	nop
      break;
  }
  buf[i] = '\0';
 294:	8b 55 f4             	mov    -0xc(%ebp),%edx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	01 d0                	add    %edx,%eax
 29c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a4:	f3 0f 1e fb          	endbr32 
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	83 ec 08             	sub    $0x8,%esp
 2b1:	6a 00                	push   $0x0
 2b3:	ff 75 08             	pushl  0x8(%ebp)
 2b6:	e8 62 01 00 00       	call   41d <open>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c5:	79 07                	jns    2ce <stat+0x2a>
    return -1;
 2c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cc:	eb 25                	jmp    2f3 <stat+0x4f>
  r = fstat(fd, st);
 2ce:	83 ec 08             	sub    $0x8,%esp
 2d1:	ff 75 0c             	pushl  0xc(%ebp)
 2d4:	ff 75 f4             	pushl  -0xc(%ebp)
 2d7:	e8 59 01 00 00       	call   435 <fstat>
 2dc:	83 c4 10             	add    $0x10,%esp
 2df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e2:	83 ec 0c             	sub    $0xc,%esp
 2e5:	ff 75 f4             	pushl  -0xc(%ebp)
 2e8:	e8 18 01 00 00       	call   405 <close>
 2ed:	83 c4 10             	add    $0x10,%esp
  return r;
 2f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <atoi>:



int
atoi(const char *s)
{
 2f5:	f3 0f 1e fb          	endbr32 
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	3c 2d                	cmp    $0x2d,%al
 30e:	75 6b                	jne    37b <atoi+0x86>
  {
    s++;
 310:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 314:	eb 25                	jmp    33b <atoi+0x46>
        n = n*10 + *s++ - '0';
 316:	8b 55 fc             	mov    -0x4(%ebp),%edx
 319:	89 d0                	mov    %edx,%eax
 31b:	c1 e0 02             	shl    $0x2,%eax
 31e:	01 d0                	add    %edx,%eax
 320:	01 c0                	add    %eax,%eax
 322:	89 c1                	mov    %eax,%ecx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8d 50 01             	lea    0x1(%eax),%edx
 32a:	89 55 08             	mov    %edx,0x8(%ebp)
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	0f be c0             	movsbl %al,%eax
 333:	01 c8                	add    %ecx,%eax
 335:	83 e8 30             	sub    $0x30,%eax
 338:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	0f b6 00             	movzbl (%eax),%eax
 341:	3c 2f                	cmp    $0x2f,%al
 343:	7e 0a                	jle    34f <atoi+0x5a>
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	3c 39                	cmp    $0x39,%al
 34d:	7e c7                	jle    316 <atoi+0x21>

    return -n;
 34f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 352:	f7 d8                	neg    %eax
 354:	eb 3c                	jmp    392 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 356:	8b 55 fc             	mov    -0x4(%ebp),%edx
 359:	89 d0                	mov    %edx,%eax
 35b:	c1 e0 02             	shl    $0x2,%eax
 35e:	01 d0                	add    %edx,%eax
 360:	01 c0                	add    %eax,%eax
 362:	89 c1                	mov    %eax,%ecx
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	8d 50 01             	lea    0x1(%eax),%edx
 36a:	89 55 08             	mov    %edx,0x8(%ebp)
 36d:	0f b6 00             	movzbl (%eax),%eax
 370:	0f be c0             	movsbl %al,%eax
 373:	01 c8                	add    %ecx,%eax
 375:	83 e8 30             	sub    $0x30,%eax
 378:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	3c 2f                	cmp    $0x2f,%al
 383:	7e 0a                	jle    38f <atoi+0x9a>
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	3c 39                	cmp    $0x39,%al
 38d:	7e c7                	jle    356 <atoi+0x61>

    return n;
 38f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 392:	c9                   	leave  
 393:	c3                   	ret    

00000394 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 394:	f3 0f 1e fb          	endbr32 
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3aa:	eb 17                	jmp    3c3 <memmove+0x2f>
    *dst++ = *src++;
 3ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3af:	8d 42 01             	lea    0x1(%edx),%eax
 3b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b8:	8d 48 01             	lea    0x1(%eax),%ecx
 3bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3be:	0f b6 12             	movzbl (%edx),%edx
 3c1:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3c3:	8b 45 10             	mov    0x10(%ebp),%eax
 3c6:	8d 50 ff             	lea    -0x1(%eax),%edx
 3c9:	89 55 10             	mov    %edx,0x10(%ebp)
 3cc:	85 c0                	test   %eax,%eax
 3ce:	7f dc                	jg     3ac <memmove+0x18>
  return vdst;
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3d3:	c9                   	leave  
 3d4:	c3                   	ret    

000003d5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d5:	b8 01 00 00 00       	mov    $0x1,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <exit>:
SYSCALL(exit)
 3dd:	b8 02 00 00 00       	mov    $0x2,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <wait>:
SYSCALL(wait)
 3e5:	b8 03 00 00 00       	mov    $0x3,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <pipe>:
SYSCALL(pipe)
 3ed:	b8 04 00 00 00       	mov    $0x4,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <read>:
SYSCALL(read)
 3f5:	b8 05 00 00 00       	mov    $0x5,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <write>:
SYSCALL(write)
 3fd:	b8 10 00 00 00       	mov    $0x10,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <close>:
SYSCALL(close)
 405:	b8 15 00 00 00       	mov    $0x15,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <kill>:
SYSCALL(kill)
 40d:	b8 06 00 00 00       	mov    $0x6,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <exec>:
SYSCALL(exec)
 415:	b8 07 00 00 00       	mov    $0x7,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <open>:
SYSCALL(open)
 41d:	b8 0f 00 00 00       	mov    $0xf,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <mknod>:
SYSCALL(mknod)
 425:	b8 11 00 00 00       	mov    $0x11,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <unlink>:
SYSCALL(unlink)
 42d:	b8 12 00 00 00       	mov    $0x12,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <fstat>:
SYSCALL(fstat)
 435:	b8 08 00 00 00       	mov    $0x8,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <link>:
SYSCALL(link)
 43d:	b8 13 00 00 00       	mov    $0x13,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <mkdir>:
SYSCALL(mkdir)
 445:	b8 14 00 00 00       	mov    $0x14,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <chdir>:
SYSCALL(chdir)
 44d:	b8 09 00 00 00       	mov    $0x9,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <dup>:
SYSCALL(dup)
 455:	b8 0a 00 00 00       	mov    $0xa,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <getpid>:
SYSCALL(getpid)
 45d:	b8 0b 00 00 00       	mov    $0xb,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <sbrk>:
SYSCALL(sbrk)
 465:	b8 0c 00 00 00       	mov    $0xc,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <sleep>:
SYSCALL(sleep)
 46d:	b8 0d 00 00 00       	mov    $0xd,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <uptime>:
SYSCALL(uptime)
 475:	b8 0e 00 00 00       	mov    $0xe,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <lseek>:
SYSCALL(lseek)
 47d:	b8 16 00 00 00       	mov    $0x16,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    
