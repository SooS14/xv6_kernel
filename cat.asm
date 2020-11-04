
_cat:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   a:	eb 31                	jmp    3d <cat+0x3d>
    if (write(1, buf, n) != n) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	ff 75 f4             	pushl  -0xc(%ebp)
  12:	68 40 0c 00 00       	push   $0xc40
  17:	6a 01                	push   $0x1
  19:	e8 fe 03 00 00       	call   41c <write>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  24:	74 17                	je     3d <cat+0x3d>
      printf(1, "cat: write error\n");
  26:	83 ec 08             	sub    $0x8,%esp
  29:	68 47 09 00 00       	push   $0x947
  2e:	6a 01                	push   $0x1
  30:	e8 4b 05 00 00       	call   580 <printf>
  35:	83 c4 10             	add    $0x10,%esp
      exit();
  38:	e8 bf 03 00 00       	call   3fc <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  3d:	83 ec 04             	sub    $0x4,%esp
  40:	68 00 02 00 00       	push   $0x200
  45:	68 40 0c 00 00       	push   $0xc40
  4a:	ff 75 08             	pushl  0x8(%ebp)
  4d:	e8 c2 03 00 00       	call   414 <read>
  52:	83 c4 10             	add    $0x10,%esp
  55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  5c:	7f ae                	jg     c <cat+0xc>
    }
  }
  if(n < 0){
  5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  62:	79 17                	jns    7b <cat+0x7b>
    printf(1, "cat: read error\n");
  64:	83 ec 08             	sub    $0x8,%esp
  67:	68 59 09 00 00       	push   $0x959
  6c:	6a 01                	push   $0x1
  6e:	e8 0d 05 00 00       	call   580 <printf>
  73:	83 c4 10             	add    $0x10,%esp
    exit();
  76:	e8 81 03 00 00       	call   3fc <exit>
  }
}
  7b:	90                   	nop
  7c:	c9                   	leave  
  7d:	c3                   	ret    

0000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	f3 0f 1e fb          	endbr32 
  82:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  86:	83 e4 f0             	and    $0xfffffff0,%esp
  89:	ff 71 fc             	pushl  -0x4(%ecx)
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	53                   	push   %ebx
  90:	51                   	push   %ecx
  91:	83 ec 10             	sub    $0x10,%esp
  94:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  96:	83 3b 01             	cmpl   $0x1,(%ebx)
  99:	7f 12                	jg     ad <main+0x2f>
    cat(0);
  9b:	83 ec 0c             	sub    $0xc,%esp
  9e:	6a 00                	push   $0x0
  a0:	e8 5b ff ff ff       	call   0 <cat>
  a5:	83 c4 10             	add    $0x10,%esp
    exit();
  a8:	e8 4f 03 00 00       	call   3fc <exit>
  }

  for(i = 1; i < argc; i++){
  ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  b4:	eb 71                	jmp    127 <main+0xa9>
    if((fd = open(argv[i], 0)) < 0){
  b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c0:	8b 43 04             	mov    0x4(%ebx),%eax
  c3:	01 d0                	add    %edx,%eax
  c5:	8b 00                	mov    (%eax),%eax
  c7:	83 ec 08             	sub    $0x8,%esp
  ca:	6a 00                	push   $0x0
  cc:	50                   	push   %eax
  cd:	e8 6a 03 00 00       	call   43c <open>
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  dc:	79 29                	jns    107 <main+0x89>
      printf(1, "cat: cannot open %s\n", argv[i]);
  de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e8:	8b 43 04             	mov    0x4(%ebx),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	8b 00                	mov    (%eax),%eax
  ef:	83 ec 04             	sub    $0x4,%esp
  f2:	50                   	push   %eax
  f3:	68 6a 09 00 00       	push   $0x96a
  f8:	6a 01                	push   $0x1
  fa:	e8 81 04 00 00       	call   580 <printf>
  ff:	83 c4 10             	add    $0x10,%esp
      exit();
 102:	e8 f5 02 00 00       	call   3fc <exit>
    }
    cat(fd);
 107:	83 ec 0c             	sub    $0xc,%esp
 10a:	ff 75 f0             	pushl  -0x10(%ebp)
 10d:	e8 ee fe ff ff       	call   0 <cat>
 112:	83 c4 10             	add    $0x10,%esp
    close(fd);
 115:	83 ec 0c             	sub    $0xc,%esp
 118:	ff 75 f0             	pushl  -0x10(%ebp)
 11b:	e8 04 03 00 00       	call   424 <close>
 120:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 123:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 127:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12a:	3b 03                	cmp    (%ebx),%eax
 12c:	7c 88                	jl     b6 <main+0x38>
  }
  exit();
 12e:	e8 c9 02 00 00       	call   3fc <exit>

00000133 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 133:	55                   	push   %ebp
 134:	89 e5                	mov    %esp,%ebp
 136:	57                   	push   %edi
 137:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 138:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13b:	8b 55 10             	mov    0x10(%ebp),%edx
 13e:	8b 45 0c             	mov    0xc(%ebp),%eax
 141:	89 cb                	mov    %ecx,%ebx
 143:	89 df                	mov    %ebx,%edi
 145:	89 d1                	mov    %edx,%ecx
 147:	fc                   	cld    
 148:	f3 aa                	rep stos %al,%es:(%edi)
 14a:	89 ca                	mov    %ecx,%edx
 14c:	89 fb                	mov    %edi,%ebx
 14e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 151:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 154:	90                   	nop
 155:	5b                   	pop    %ebx
 156:	5f                   	pop    %edi
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    

00000159 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 159:	f3 0f 1e fb          	endbr32 
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 169:	90                   	nop
 16a:	8b 55 0c             	mov    0xc(%ebp),%edx
 16d:	8d 42 01             	lea    0x1(%edx),%eax
 170:	89 45 0c             	mov    %eax,0xc(%ebp)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	8d 48 01             	lea    0x1(%eax),%ecx
 179:	89 4d 08             	mov    %ecx,0x8(%ebp)
 17c:	0f b6 12             	movzbl (%edx),%edx
 17f:	88 10                	mov    %dl,(%eax)
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	84 c0                	test   %al,%al
 186:	75 e2                	jne    16a <strcpy+0x11>
    ;
  return os;
 188:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18b:	c9                   	leave  
 18c:	c3                   	ret    

0000018d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18d:	f3 0f 1e fb          	endbr32 
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 194:	eb 08                	jmp    19e <strcmp+0x11>
    p++, q++;
 196:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 10                	je     1b8 <strcmp+0x2b>
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 10             	movzbl (%eax),%edx
 1ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	38 c2                	cmp    %al,%dl
 1b6:	74 de                	je     196 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	0f b6 d0             	movzbl %al,%edx
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	0f b6 c0             	movzbl %al,%eax
 1ca:	29 c2                	sub    %eax,%edx
 1cc:	89 d0                	mov    %edx,%eax
}
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <strlen>:

uint
strlen(const char *s)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e1:	eb 04                	jmp    1e7 <strlen+0x17>
 1e3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	0f b6 00             	movzbl (%eax),%eax
 1f2:	84 c0                	test   %al,%al
 1f4:	75 ed                	jne    1e3 <strlen+0x13>
    ;
  return n;
 1f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fb:	f3 0f 1e fb          	endbr32 
 1ff:	55                   	push   %ebp
 200:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 202:	8b 45 10             	mov    0x10(%ebp),%eax
 205:	50                   	push   %eax
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 08             	pushl  0x8(%ebp)
 20c:	e8 22 ff ff ff       	call   133 <stosb>
 211:	83 c4 0c             	add    $0xc,%esp
  return dst;
 214:	8b 45 08             	mov    0x8(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <strchr>:

char*
strchr(const char *s, char c)
{
 219:	f3 0f 1e fb          	endbr32 
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	83 ec 04             	sub    $0x4,%esp
 223:	8b 45 0c             	mov    0xc(%ebp),%eax
 226:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 229:	eb 14                	jmp    23f <strchr+0x26>
    if(*s == c)
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	38 45 fc             	cmp    %al,-0x4(%ebp)
 234:	75 05                	jne    23b <strchr+0x22>
      return (char*)s;
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	eb 13                	jmp    24e <strchr+0x35>
  for(; *s; s++)
 23b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	75 e2                	jne    22b <strchr+0x12>
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 261:	eb 42                	jmp    2a5 <gets+0x55>
    cc = read(0, &c, 1);
 263:	83 ec 04             	sub    $0x4,%esp
 266:	6a 01                	push   $0x1
 268:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26b:	50                   	push   %eax
 26c:	6a 00                	push   $0x0
 26e:	e8 a1 01 00 00       	call   414 <read>
 273:	83 c4 10             	add    $0x10,%esp
 276:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27d:	7e 33                	jle    2b2 <gets+0x62>
      break;
    buf[i++] = c;
 27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 f4             	mov    %edx,-0xc(%ebp)
 288:	89 c2                	mov    %eax,%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 c2                	add    %eax,%edx
 28f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 293:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 299:	3c 0a                	cmp    $0xa,%al
 29b:	74 16                	je     2b3 <gets+0x63>
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	3c 0d                	cmp    $0xd,%al
 2a3:	74 0e                	je     2b3 <gets+0x63>
  for(i=0; i+1 < max; ){
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2ae:	7f b3                	jg     263 <gets+0x13>
 2b0:	eb 01                	jmp    2b3 <gets+0x63>
      break;
 2b2:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	01 d0                	add    %edx,%eax
 2bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c3:	f3 0f 1e fb          	endbr32 
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2cd:	83 ec 08             	sub    $0x8,%esp
 2d0:	6a 00                	push   $0x0
 2d2:	ff 75 08             	pushl  0x8(%ebp)
 2d5:	e8 62 01 00 00       	call   43c <open>
 2da:	83 c4 10             	add    $0x10,%esp
 2dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e4:	79 07                	jns    2ed <stat+0x2a>
    return -1;
 2e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2eb:	eb 25                	jmp    312 <stat+0x4f>
  r = fstat(fd, st);
 2ed:	83 ec 08             	sub    $0x8,%esp
 2f0:	ff 75 0c             	pushl  0xc(%ebp)
 2f3:	ff 75 f4             	pushl  -0xc(%ebp)
 2f6:	e8 59 01 00 00       	call   454 <fstat>
 2fb:	83 c4 10             	add    $0x10,%esp
 2fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 301:	83 ec 0c             	sub    $0xc,%esp
 304:	ff 75 f4             	pushl  -0xc(%ebp)
 307:	e8 18 01 00 00       	call   424 <close>
 30c:	83 c4 10             	add    $0x10,%esp
  return r;
 30f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 312:	c9                   	leave  
 313:	c3                   	ret    

00000314 <atoi>:



int
atoi(const char *s)
{
 314:	f3 0f 1e fb          	endbr32 
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	0f b6 00             	movzbl (%eax),%eax
 32b:	3c 2d                	cmp    $0x2d,%al
 32d:	75 6b                	jne    39a <atoi+0x86>
  {
    s++;
 32f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 333:	eb 25                	jmp    35a <atoi+0x46>
        n = n*10 + *s++ - '0';
 335:	8b 55 fc             	mov    -0x4(%ebp),%edx
 338:	89 d0                	mov    %edx,%eax
 33a:	c1 e0 02             	shl    $0x2,%eax
 33d:	01 d0                	add    %edx,%eax
 33f:	01 c0                	add    %eax,%eax
 341:	89 c1                	mov    %eax,%ecx
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	8d 50 01             	lea    0x1(%eax),%edx
 349:	89 55 08             	mov    %edx,0x8(%ebp)
 34c:	0f b6 00             	movzbl (%eax),%eax
 34f:	0f be c0             	movsbl %al,%eax
 352:	01 c8                	add    %ecx,%eax
 354:	83 e8 30             	sub    $0x30,%eax
 357:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	0f b6 00             	movzbl (%eax),%eax
 360:	3c 2f                	cmp    $0x2f,%al
 362:	7e 0a                	jle    36e <atoi+0x5a>
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	0f b6 00             	movzbl (%eax),%eax
 36a:	3c 39                	cmp    $0x39,%al
 36c:	7e c7                	jle    335 <atoi+0x21>

    return -n;
 36e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 371:	f7 d8                	neg    %eax
 373:	eb 3c                	jmp    3b1 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 375:	8b 55 fc             	mov    -0x4(%ebp),%edx
 378:	89 d0                	mov    %edx,%eax
 37a:	c1 e0 02             	shl    $0x2,%eax
 37d:	01 d0                	add    %edx,%eax
 37f:	01 c0                	add    %eax,%eax
 381:	89 c1                	mov    %eax,%ecx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 08             	mov    %edx,0x8(%ebp)
 38c:	0f b6 00             	movzbl (%eax),%eax
 38f:	0f be c0             	movsbl %al,%eax
 392:	01 c8                	add    %ecx,%eax
 394:	83 e8 30             	sub    $0x30,%eax
 397:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	0f b6 00             	movzbl (%eax),%eax
 3a0:	3c 2f                	cmp    $0x2f,%al
 3a2:	7e 0a                	jle    3ae <atoi+0x9a>
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	0f b6 00             	movzbl (%eax),%eax
 3aa:	3c 39                	cmp    $0x39,%al
 3ac:	7e c7                	jle    375 <atoi+0x61>

    return n;
 3ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b3:	f3 0f 1e fb          	endbr32 
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c9:	eb 17                	jmp    3e2 <memmove+0x2f>
    *dst++ = *src++;
 3cb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ce:	8d 42 01             	lea    0x1(%edx),%eax
 3d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d7:	8d 48 01             	lea    0x1(%eax),%ecx
 3da:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3dd:	0f b6 12             	movzbl (%edx),%edx
 3e0:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3e2:	8b 45 10             	mov    0x10(%ebp),%eax
 3e5:	8d 50 ff             	lea    -0x1(%eax),%edx
 3e8:	89 55 10             	mov    %edx,0x10(%ebp)
 3eb:	85 c0                	test   %eax,%eax
 3ed:	7f dc                	jg     3cb <memmove+0x18>
  return vdst;
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f2:	c9                   	leave  
 3f3:	c3                   	ret    

000003f4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f4:	b8 01 00 00 00       	mov    $0x1,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <exit>:
SYSCALL(exit)
 3fc:	b8 02 00 00 00       	mov    $0x2,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <wait>:
SYSCALL(wait)
 404:	b8 03 00 00 00       	mov    $0x3,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <pipe>:
SYSCALL(pipe)
 40c:	b8 04 00 00 00       	mov    $0x4,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <read>:
SYSCALL(read)
 414:	b8 05 00 00 00       	mov    $0x5,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <write>:
SYSCALL(write)
 41c:	b8 10 00 00 00       	mov    $0x10,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <close>:
SYSCALL(close)
 424:	b8 15 00 00 00       	mov    $0x15,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <kill>:
SYSCALL(kill)
 42c:	b8 06 00 00 00       	mov    $0x6,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <exec>:
SYSCALL(exec)
 434:	b8 07 00 00 00       	mov    $0x7,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <open>:
SYSCALL(open)
 43c:	b8 0f 00 00 00       	mov    $0xf,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <mknod>:
SYSCALL(mknod)
 444:	b8 11 00 00 00       	mov    $0x11,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <unlink>:
SYSCALL(unlink)
 44c:	b8 12 00 00 00       	mov    $0x12,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <fstat>:
SYSCALL(fstat)
 454:	b8 08 00 00 00       	mov    $0x8,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <link>:
SYSCALL(link)
 45c:	b8 13 00 00 00       	mov    $0x13,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mkdir>:
SYSCALL(mkdir)
 464:	b8 14 00 00 00       	mov    $0x14,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <chdir>:
SYSCALL(chdir)
 46c:	b8 09 00 00 00       	mov    $0x9,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <dup>:
SYSCALL(dup)
 474:	b8 0a 00 00 00       	mov    $0xa,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <getpid>:
SYSCALL(getpid)
 47c:	b8 0b 00 00 00       	mov    $0xb,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <sbrk>:
SYSCALL(sbrk)
 484:	b8 0c 00 00 00       	mov    $0xc,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <sleep>:
SYSCALL(sleep)
 48c:	b8 0d 00 00 00       	mov    $0xd,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <uptime>:
SYSCALL(uptime)
 494:	b8 0e 00 00 00       	mov    $0xe,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <lseek>:
SYSCALL(lseek)
 49c:	b8 16 00 00 00       	mov    $0x16,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a4:	f3 0f 1e fb          	endbr32 
 4a8:	55                   	push   %ebp
 4a9:	89 e5                	mov    %esp,%ebp
 4ab:	83 ec 18             	sub    $0x18,%esp
 4ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b4:	83 ec 04             	sub    $0x4,%esp
 4b7:	6a 01                	push   $0x1
 4b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4bc:	50                   	push   %eax
 4bd:	ff 75 08             	pushl  0x8(%ebp)
 4c0:	e8 57 ff ff ff       	call   41c <write>
 4c5:	83 c4 10             	add    $0x10,%esp
}
 4c8:	90                   	nop
 4c9:	c9                   	leave  
 4ca:	c3                   	ret    

000004cb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cb:	f3 0f 1e fb          	endbr32 
 4cf:	55                   	push   %ebp
 4d0:	89 e5                	mov    %esp,%ebp
 4d2:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e0:	74 17                	je     4f9 <printint+0x2e>
 4e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e6:	79 11                	jns    4f9 <printint+0x2e>
    neg = 1;
 4e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f2:	f7 d8                	neg    %eax
 4f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f7:	eb 06                	jmp    4ff <printint+0x34>
  } else {
    x = xx;
 4f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 506:	8b 4d 10             	mov    0x10(%ebp),%ecx
 509:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50c:	ba 00 00 00 00       	mov    $0x0,%edx
 511:	f7 f1                	div    %ecx
 513:	89 d1                	mov    %edx,%ecx
 515:	8b 45 f4             	mov    -0xc(%ebp),%eax
 518:	8d 50 01             	lea    0x1(%eax),%edx
 51b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51e:	0f b6 91 f0 0b 00 00 	movzbl 0xbf0(%ecx),%edx
 525:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 529:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52f:	ba 00 00 00 00       	mov    $0x0,%edx
 534:	f7 f1                	div    %ecx
 536:	89 45 ec             	mov    %eax,-0x14(%ebp)
 539:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53d:	75 c7                	jne    506 <printint+0x3b>
  if(neg)
 53f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 543:	74 2d                	je     572 <printint+0xa7>
    buf[i++] = '-';
 545:	8b 45 f4             	mov    -0xc(%ebp),%eax
 548:	8d 50 01             	lea    0x1(%eax),%edx
 54b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 553:	eb 1d                	jmp    572 <printint+0xa7>
    putc(fd, buf[i]);
 555:	8d 55 dc             	lea    -0x24(%ebp),%edx
 558:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55b:	01 d0                	add    %edx,%eax
 55d:	0f b6 00             	movzbl (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	83 ec 08             	sub    $0x8,%esp
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 35 ff ff ff       	call   4a4 <putc>
 56f:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 572:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57a:	79 d9                	jns    555 <printint+0x8a>
}
 57c:	90                   	nop
 57d:	90                   	nop
 57e:	c9                   	leave  
 57f:	c3                   	ret    

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 580:	f3 0f 1e fb          	endbr32 
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 58a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 591:	8d 45 0c             	lea    0xc(%ebp),%eax
 594:	83 c0 04             	add    $0x4,%eax
 597:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 59a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a1:	e9 59 01 00 00       	jmp    6ff <printf+0x17f>
    c = fmt[i] & 0xff;
 5a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ac:	01 d0                	add    %edx,%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	25 ff 00 00 00       	and    $0xff,%eax
 5b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c0:	75 2c                	jne    5ee <printf+0x6e>
      if(c == '%'){
 5c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c6:	75 0c                	jne    5d4 <printf+0x54>
        state = '%';
 5c8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cf:	e9 27 01 00 00       	jmp    6fb <printf+0x17b>
      } else {
        putc(fd, c);
 5d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d7:	0f be c0             	movsbl %al,%eax
 5da:	83 ec 08             	sub    $0x8,%esp
 5dd:	50                   	push   %eax
 5de:	ff 75 08             	pushl  0x8(%ebp)
 5e1:	e8 be fe ff ff       	call   4a4 <putc>
 5e6:	83 c4 10             	add    $0x10,%esp
 5e9:	e9 0d 01 00 00       	jmp    6fb <printf+0x17b>
      }
    } else if(state == '%'){
 5ee:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f2:	0f 85 03 01 00 00    	jne    6fb <printf+0x17b>
      if(c == 'd'){
 5f8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5fc:	75 1e                	jne    61c <printf+0x9c>
        printint(fd, *ap, 10, 1);
 5fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	6a 01                	push   $0x1
 605:	6a 0a                	push   $0xa
 607:	50                   	push   %eax
 608:	ff 75 08             	pushl  0x8(%ebp)
 60b:	e8 bb fe ff ff       	call   4cb <printint>
 610:	83 c4 10             	add    $0x10,%esp
        ap++;
 613:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 617:	e9 d8 00 00 00       	jmp    6f4 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 61c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 620:	74 06                	je     628 <printf+0xa8>
 622:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 626:	75 1e                	jne    646 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 628:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	6a 00                	push   $0x0
 62f:	6a 10                	push   $0x10
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	e8 91 fe ff ff       	call   4cb <printint>
 63a:	83 c4 10             	add    $0x10,%esp
        ap++;
 63d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 641:	e9 ae 00 00 00       	jmp    6f4 <printf+0x174>
      } else if(c == 's'){
 646:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 64a:	75 43                	jne    68f <printf+0x10f>
        s = (char*)*ap;
 64c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 654:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65c:	75 25                	jne    683 <printf+0x103>
          s = "(null)";
 65e:	c7 45 f4 7f 09 00 00 	movl   $0x97f,-0xc(%ebp)
        while(*s != 0){
 665:	eb 1c                	jmp    683 <printf+0x103>
          putc(fd, *s);
 667:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66a:	0f b6 00             	movzbl (%eax),%eax
 66d:	0f be c0             	movsbl %al,%eax
 670:	83 ec 08             	sub    $0x8,%esp
 673:	50                   	push   %eax
 674:	ff 75 08             	pushl  0x8(%ebp)
 677:	e8 28 fe ff ff       	call   4a4 <putc>
 67c:	83 c4 10             	add    $0x10,%esp
          s++;
 67f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 683:	8b 45 f4             	mov    -0xc(%ebp),%eax
 686:	0f b6 00             	movzbl (%eax),%eax
 689:	84 c0                	test   %al,%al
 68b:	75 da                	jne    667 <printf+0xe7>
 68d:	eb 65                	jmp    6f4 <printf+0x174>
        }
      } else if(c == 'c'){
 68f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 693:	75 1d                	jne    6b2 <printf+0x132>
        putc(fd, *ap);
 695:	8b 45 e8             	mov    -0x18(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	0f be c0             	movsbl %al,%eax
 69d:	83 ec 08             	sub    $0x8,%esp
 6a0:	50                   	push   %eax
 6a1:	ff 75 08             	pushl  0x8(%ebp)
 6a4:	e8 fb fd ff ff       	call   4a4 <putc>
 6a9:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b0:	eb 42                	jmp    6f4 <printf+0x174>
      } else if(c == '%'){
 6b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b6:	75 17                	jne    6cf <printf+0x14f>
        putc(fd, c);
 6b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	83 ec 08             	sub    $0x8,%esp
 6c1:	50                   	push   %eax
 6c2:	ff 75 08             	pushl  0x8(%ebp)
 6c5:	e8 da fd ff ff       	call   4a4 <putc>
 6ca:	83 c4 10             	add    $0x10,%esp
 6cd:	eb 25                	jmp    6f4 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cf:	83 ec 08             	sub    $0x8,%esp
 6d2:	6a 25                	push   $0x25
 6d4:	ff 75 08             	pushl  0x8(%ebp)
 6d7:	e8 c8 fd ff ff       	call   4a4 <putc>
 6dc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e2:	0f be c0             	movsbl %al,%eax
 6e5:	83 ec 08             	sub    $0x8,%esp
 6e8:	50                   	push   %eax
 6e9:	ff 75 08             	pushl  0x8(%ebp)
 6ec:	e8 b3 fd ff ff       	call   4a4 <putc>
 6f1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6fb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 702:	8b 45 f0             	mov    -0x10(%ebp),%eax
 705:	01 d0                	add    %edx,%eax
 707:	0f b6 00             	movzbl (%eax),%eax
 70a:	84 c0                	test   %al,%al
 70c:	0f 85 94 fe ff ff    	jne    5a6 <printf+0x26>
    }
  }
}
 712:	90                   	nop
 713:	90                   	nop
 714:	c9                   	leave  
 715:	c3                   	ret    

00000716 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 716:	f3 0f 1e fb          	endbr32 
 71a:	55                   	push   %ebp
 71b:	89 e5                	mov    %esp,%ebp
 71d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 720:	8b 45 08             	mov    0x8(%ebp),%eax
 723:	83 e8 08             	sub    $0x8,%eax
 726:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 729:	a1 28 0c 00 00       	mov    0xc28,%eax
 72e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 731:	eb 24                	jmp    757 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 73b:	72 12                	jb     74f <free+0x39>
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 743:	77 24                	ja     769 <free+0x53>
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 74d:	72 1a                	jb     769 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	89 45 fc             	mov    %eax,-0x4(%ebp)
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75d:	76 d4                	jbe    733 <free+0x1d>
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 767:	73 ca                	jae    733 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	01 c2                	add    %eax,%edx
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	39 c2                	cmp    %eax,%edx
 782:	75 24                	jne    7a8 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 784:	8b 45 f8             	mov    -0x8(%ebp),%eax
 787:	8b 50 04             	mov    0x4(%eax),%edx
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	01 c2                	add    %eax,%edx
 794:	8b 45 f8             	mov    -0x8(%ebp),%eax
 797:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 00                	mov    (%eax),%eax
 79f:	8b 10                	mov    (%eax),%edx
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	89 10                	mov    %edx,(%eax)
 7a6:	eb 0a                	jmp    7b2 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 10                	mov    (%eax),%edx
 7ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	01 d0                	add    %edx,%eax
 7c4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7c7:	75 20                	jne    7e9 <free+0xd3>
    p->s.size += bp->s.size;
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 50 04             	mov    0x4(%eax),%edx
 7cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	01 c2                	add    %eax,%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e0:	8b 10                	mov    (%eax),%edx
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	89 10                	mov    %edx,(%eax)
 7e7:	eb 08                	jmp    7f1 <free+0xdb>
  } else
    p->s.ptr = bp;
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 7f9:	90                   	nop
 7fa:	c9                   	leave  
 7fb:	c3                   	ret    

000007fc <morecore>:

static Header*
morecore(uint nu)
{
 7fc:	f3 0f 1e fb          	endbr32 
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 806:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 80d:	77 07                	ja     816 <morecore+0x1a>
    nu = 4096;
 80f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 816:	8b 45 08             	mov    0x8(%ebp),%eax
 819:	c1 e0 03             	shl    $0x3,%eax
 81c:	83 ec 0c             	sub    $0xc,%esp
 81f:	50                   	push   %eax
 820:	e8 5f fc ff ff       	call   484 <sbrk>
 825:	83 c4 10             	add    $0x10,%esp
 828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 82b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 82f:	75 07                	jne    838 <morecore+0x3c>
    return 0;
 831:	b8 00 00 00 00       	mov    $0x0,%eax
 836:	eb 26                	jmp    85e <morecore+0x62>
  hp = (Header*)p;
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	8b 55 08             	mov    0x8(%ebp),%edx
 844:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 847:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84a:	83 c0 08             	add    $0x8,%eax
 84d:	83 ec 0c             	sub    $0xc,%esp
 850:	50                   	push   %eax
 851:	e8 c0 fe ff ff       	call   716 <free>
 856:	83 c4 10             	add    $0x10,%esp
  return freep;
 859:	a1 28 0c 00 00       	mov    0xc28,%eax
}
 85e:	c9                   	leave  
 85f:	c3                   	ret    

00000860 <malloc>:

void*
malloc(uint nbytes)
{
 860:	f3 0f 1e fb          	endbr32 
 864:	55                   	push   %ebp
 865:	89 e5                	mov    %esp,%ebp
 867:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86a:	8b 45 08             	mov    0x8(%ebp),%eax
 86d:	83 c0 07             	add    $0x7,%eax
 870:	c1 e8 03             	shr    $0x3,%eax
 873:	83 c0 01             	add    $0x1,%eax
 876:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 879:	a1 28 0c 00 00       	mov    0xc28,%eax
 87e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 881:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 885:	75 23                	jne    8aa <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 887:	c7 45 f0 20 0c 00 00 	movl   $0xc20,-0x10(%ebp)
 88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 891:	a3 28 0c 00 00       	mov    %eax,0xc28
 896:	a1 28 0c 00 00       	mov    0xc28,%eax
 89b:	a3 20 0c 00 00       	mov    %eax,0xc20
    base.s.size = 0;
 8a0:	c7 05 24 0c 00 00 00 	movl   $0x0,0xc24
 8a7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ad:	8b 00                	mov    (%eax),%eax
 8af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	8b 40 04             	mov    0x4(%eax),%eax
 8b8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8bb:	77 4d                	ja     90a <malloc+0xaa>
      if(p->s.size == nunits)
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	8b 40 04             	mov    0x4(%eax),%eax
 8c3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8c6:	75 0c                	jne    8d4 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 10                	mov    (%eax),%edx
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	89 10                	mov    %edx,(%eax)
 8d2:	eb 26                	jmp    8fa <malloc+0x9a>
      else {
        p->s.size -= nunits;
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8dd:	89 c2                	mov    %eax,%edx
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e8:	8b 40 04             	mov    0x4(%eax),%eax
 8eb:	c1 e0 03             	shl    $0x3,%eax
 8ee:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fd:	a3 28 0c 00 00       	mov    %eax,0xc28
      return (void*)(p + 1);
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	83 c0 08             	add    $0x8,%eax
 908:	eb 3b                	jmp    945 <malloc+0xe5>
    }
    if(p == freep)
 90a:	a1 28 0c 00 00       	mov    0xc28,%eax
 90f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 912:	75 1e                	jne    932 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 914:	83 ec 0c             	sub    $0xc,%esp
 917:	ff 75 ec             	pushl  -0x14(%ebp)
 91a:	e8 dd fe ff ff       	call   7fc <morecore>
 91f:	83 c4 10             	add    $0x10,%esp
 922:	89 45 f4             	mov    %eax,-0xc(%ebp)
 925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 929:	75 07                	jne    932 <malloc+0xd2>
        return 0;
 92b:	b8 00 00 00 00       	mov    $0x0,%eax
 930:	eb 13                	jmp    945 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	89 45 f0             	mov    %eax,-0x10(%ebp)
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 940:	e9 6d ff ff ff       	jmp    8b2 <malloc+0x52>
  }
}
 945:	c9                   	leave  
 946:	c3                   	ret    
