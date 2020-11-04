
_wc:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  1d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  24:	eb 69                	jmp    8f <wc+0x8f>
    for(i=0; i<n; i++){
  26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  2d:	eb 58                	jmp    87 <wc+0x87>
      c++;
  2f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	05 c0 0c 00 00       	add    $0xcc0,%eax
  3b:	0f b6 00             	movzbl (%eax),%eax
  3e:	3c 0a                	cmp    $0xa,%al
  40:	75 04                	jne    46 <wc+0x46>
        l++;
  42:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	05 c0 0c 00 00       	add    $0xcc0,%eax
  4e:	0f b6 00             	movzbl (%eax),%eax
  51:	0f be c0             	movsbl %al,%eax
  54:	83 ec 08             	sub    $0x8,%esp
  57:	50                   	push   %eax
  58:	68 d9 09 00 00       	push   $0x9d9
  5d:	e8 49 02 00 00       	call   2ab <strchr>
  62:	83 c4 10             	add    $0x10,%esp
  65:	85 c0                	test   %eax,%eax
  67:	74 09                	je     72 <wc+0x72>
        inword = 0;
  69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  70:	eb 11                	jmp    83 <wc+0x83>
      else if(!inword){
  72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  76:	75 0b                	jne    83 <wc+0x83>
        w++;
  78:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  7c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8d:	7c a0                	jl     2f <wc+0x2f>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8f:	83 ec 04             	sub    $0x4,%esp
  92:	68 00 02 00 00       	push   $0x200
  97:	68 c0 0c 00 00       	push   $0xcc0
  9c:	ff 75 08             	pushl  0x8(%ebp)
  9f:	e8 02 04 00 00       	call   4a6 <read>
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ae:	0f 8f 72 ff ff ff    	jg     26 <wc+0x26>
      }
    }
  }
  if(n < 0){
  b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b8:	79 17                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	68 df 09 00 00       	push   $0x9df
  c2:	6a 01                	push   $0x1
  c4:	e8 49 05 00 00       	call   612 <printf>
  c9:	83 c4 10             	add    $0x10,%esp
    exit();
  cc:	e8 bd 03 00 00       	call   48e <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	83 ec 08             	sub    $0x8,%esp
  d4:	ff 75 0c             	pushl  0xc(%ebp)
  d7:	ff 75 e8             	pushl  -0x18(%ebp)
  da:	ff 75 ec             	pushl  -0x14(%ebp)
  dd:	ff 75 f0             	pushl  -0x10(%ebp)
  e0:	68 ef 09 00 00       	push   $0x9ef
  e5:	6a 01                	push   $0x1
  e7:	e8 26 05 00 00       	call   612 <printf>
  ec:	83 c4 20             	add    $0x20,%esp
}
  ef:	90                   	nop
  f0:	c9                   	leave  
  f1:	c3                   	ret    

000000f2 <main>:

int
main(int argc, char *argv[])
{
  f2:	f3 0f 1e fb          	endbr32 
  f6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  fa:	83 e4 f0             	and    $0xfffffff0,%esp
  fd:	ff 71 fc             	pushl  -0x4(%ecx)
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	51                   	push   %ecx
 105:	83 ec 10             	sub    $0x10,%esp
 108:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 10a:	83 3b 01             	cmpl   $0x1,(%ebx)
 10d:	7f 17                	jg     126 <main+0x34>
    wc(0, "");
 10f:	83 ec 08             	sub    $0x8,%esp
 112:	68 fc 09 00 00       	push   $0x9fc
 117:	6a 00                	push   $0x0
 119:	e8 e2 fe ff ff       	call   0 <wc>
 11e:	83 c4 10             	add    $0x10,%esp
    exit();
 121:	e8 68 03 00 00       	call   48e <exit>
  }

  for(i = 1; i < argc; i++){
 126:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 12d:	e9 83 00 00 00       	jmp    1b5 <main+0xc3>
    if((fd = open(argv[i], 0)) < 0){
 132:	8b 45 f4             	mov    -0xc(%ebp),%eax
 135:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 13c:	8b 43 04             	mov    0x4(%ebx),%eax
 13f:	01 d0                	add    %edx,%eax
 141:	8b 00                	mov    (%eax),%eax
 143:	83 ec 08             	sub    $0x8,%esp
 146:	6a 00                	push   $0x0
 148:	50                   	push   %eax
 149:	e8 80 03 00 00       	call   4ce <open>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	89 45 f0             	mov    %eax,-0x10(%ebp)
 154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 158:	79 29                	jns    183 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	50                   	push   %eax
 16f:	68 fd 09 00 00       	push   $0x9fd
 174:	6a 01                	push   $0x1
 176:	e8 97 04 00 00       	call   612 <printf>
 17b:	83 c4 10             	add    $0x10,%esp
      exit();
 17e:	e8 0b 03 00 00       	call   48e <exit>
    }
    wc(fd, argv[i]);
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18d:	8b 43 04             	mov    0x4(%ebx),%eax
 190:	01 d0                	add    %edx,%eax
 192:	8b 00                	mov    (%eax),%eax
 194:	83 ec 08             	sub    $0x8,%esp
 197:	50                   	push   %eax
 198:	ff 75 f0             	pushl  -0x10(%ebp)
 19b:	e8 60 fe ff ff       	call   0 <wc>
 1a0:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1a3:	83 ec 0c             	sub    $0xc,%esp
 1a6:	ff 75 f0             	pushl  -0x10(%ebp)
 1a9:	e8 08 03 00 00       	call   4b6 <close>
 1ae:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 1b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b8:	3b 03                	cmp    (%ebx),%eax
 1ba:	0f 8c 72 ff ff ff    	jl     132 <main+0x40>
  }
  exit();
 1c0:	e8 c9 02 00 00       	call   48e <exit>

000001c5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
 1c8:	57                   	push   %edi
 1c9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cd:	8b 55 10             	mov    0x10(%ebp),%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	89 cb                	mov    %ecx,%ebx
 1d5:	89 df                	mov    %ebx,%edi
 1d7:	89 d1                	mov    %edx,%ecx
 1d9:	fc                   	cld    
 1da:	f3 aa                	rep stos %al,%es:(%edi)
 1dc:	89 ca                	mov    %ecx,%edx
 1de:	89 fb                	mov    %edi,%ebx
 1e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e6:	90                   	nop
 1e7:	5b                   	pop    %ebx
 1e8:	5f                   	pop    %edi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    

000001eb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1eb:	f3 0f 1e fb          	endbr32 
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1fb:	90                   	nop
 1fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ff:	8d 42 01             	lea    0x1(%edx),%eax
 202:	89 45 0c             	mov    %eax,0xc(%ebp)
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 48 01             	lea    0x1(%eax),%ecx
 20b:	89 4d 08             	mov    %ecx,0x8(%ebp)
 20e:	0f b6 12             	movzbl (%edx),%edx
 211:	88 10                	mov    %dl,(%eax)
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	84 c0                	test   %al,%al
 218:	75 e2                	jne    1fc <strcpy+0x11>
    ;
  return os;
 21a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21d:	c9                   	leave  
 21e:	c3                   	ret    

0000021f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21f:	f3 0f 1e fb          	endbr32 
 223:	55                   	push   %ebp
 224:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 226:	eb 08                	jmp    230 <strcmp+0x11>
    p++, q++;
 228:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	84 c0                	test   %al,%al
 238:	74 10                	je     24a <strcmp+0x2b>
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 10             	movzbl (%eax),%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	38 c2                	cmp    %al,%dl
 248:	74 de                	je     228 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	0f b6 d0             	movzbl %al,%edx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	0f b6 c0             	movzbl %al,%eax
 25c:	29 c2                	sub    %eax,%edx
 25e:	89 d0                	mov    %edx,%eax
}
 260:	5d                   	pop    %ebp
 261:	c3                   	ret    

00000262 <strlen>:

uint
strlen(const char *s)
{
 262:	f3 0f 1e fb          	endbr32 
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 26c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 273:	eb 04                	jmp    279 <strlen+0x17>
 275:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 279:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	01 d0                	add    %edx,%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	84 c0                	test   %al,%al
 286:	75 ed                	jne    275 <strlen+0x13>
    ;
  return n;
 288:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <memset>:

void*
memset(void *dst, int c, uint n)
{
 28d:	f3 0f 1e fb          	endbr32 
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	50                   	push   %eax
 298:	ff 75 0c             	pushl  0xc(%ebp)
 29b:	ff 75 08             	pushl  0x8(%ebp)
 29e:	e8 22 ff ff ff       	call   1c5 <stosb>
 2a3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <strchr>:

char*
strchr(const char *s, char c)
{
 2ab:	f3 0f 1e fb          	endbr32 
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 04             	sub    $0x4,%esp
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2bb:	eb 14                	jmp    2d1 <strchr+0x26>
    if(*s == c)
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2c6:	75 05                	jne    2cd <strchr+0x22>
      return (char*)s;
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	eb 13                	jmp    2e0 <strchr+0x35>
  for(; *s; s++)
 2cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	84 c0                	test   %al,%al
 2d9:	75 e2                	jne    2bd <strchr+0x12>
  return 0;
 2db:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <gets>:

char*
gets(char *buf, int max)
{
 2e2:	f3 0f 1e fb          	endbr32 
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f3:	eb 42                	jmp    337 <gets+0x55>
    cc = read(0, &c, 1);
 2f5:	83 ec 04             	sub    $0x4,%esp
 2f8:	6a 01                	push   $0x1
 2fa:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2fd:	50                   	push   %eax
 2fe:	6a 00                	push   $0x0
 300:	e8 a1 01 00 00       	call   4a6 <read>
 305:	83 c4 10             	add    $0x10,%esp
 308:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 30b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30f:	7e 33                	jle    344 <gets+0x62>
      break;
    buf[i++] = c;
 311:	8b 45 f4             	mov    -0xc(%ebp),%eax
 314:	8d 50 01             	lea    0x1(%eax),%edx
 317:	89 55 f4             	mov    %edx,-0xc(%ebp)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	01 c2                	add    %eax,%edx
 321:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 325:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 327:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32b:	3c 0a                	cmp    $0xa,%al
 32d:	74 16                	je     345 <gets+0x63>
 32f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 333:	3c 0d                	cmp    $0xd,%al
 335:	74 0e                	je     345 <gets+0x63>
  for(i=0; i+1 < max; ){
 337:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33a:	83 c0 01             	add    $0x1,%eax
 33d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 340:	7f b3                	jg     2f5 <gets+0x13>
 342:	eb 01                	jmp    345 <gets+0x63>
      break;
 344:	90                   	nop
      break;
  }
  buf[i] = '\0';
 345:	8b 55 f4             	mov    -0xc(%ebp),%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	01 d0                	add    %edx,%eax
 34d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stat>:

int
stat(const char *n, struct stat *st)
{
 355:	f3 0f 1e fb          	endbr32 
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35f:	83 ec 08             	sub    $0x8,%esp
 362:	6a 00                	push   $0x0
 364:	ff 75 08             	pushl  0x8(%ebp)
 367:	e8 62 01 00 00       	call   4ce <open>
 36c:	83 c4 10             	add    $0x10,%esp
 36f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 376:	79 07                	jns    37f <stat+0x2a>
    return -1;
 378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 37d:	eb 25                	jmp    3a4 <stat+0x4f>
  r = fstat(fd, st);
 37f:	83 ec 08             	sub    $0x8,%esp
 382:	ff 75 0c             	pushl  0xc(%ebp)
 385:	ff 75 f4             	pushl  -0xc(%ebp)
 388:	e8 59 01 00 00       	call   4e6 <fstat>
 38d:	83 c4 10             	add    $0x10,%esp
 390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 393:	83 ec 0c             	sub    $0xc,%esp
 396:	ff 75 f4             	pushl  -0xc(%ebp)
 399:	e8 18 01 00 00       	call   4b6 <close>
 39e:	83 c4 10             	add    $0x10,%esp
  return r;
 3a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <atoi>:



int
atoi(const char *s)
{
 3a6:	f3 0f 1e fb          	endbr32 
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	3c 2d                	cmp    $0x2d,%al
 3bf:	75 6b                	jne    42c <atoi+0x86>
  {
    s++;
 3c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 3c5:	eb 25                	jmp    3ec <atoi+0x46>
        n = n*10 + *s++ - '0';
 3c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ca:	89 d0                	mov    %edx,%eax
 3cc:	c1 e0 02             	shl    $0x2,%eax
 3cf:	01 d0                	add    %edx,%eax
 3d1:	01 c0                	add    %eax,%eax
 3d3:	89 c1                	mov    %eax,%ecx
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	8d 50 01             	lea    0x1(%eax),%edx
 3db:	89 55 08             	mov    %edx,0x8(%ebp)
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	0f be c0             	movsbl %al,%eax
 3e4:	01 c8                	add    %ecx,%eax
 3e6:	83 e8 30             	sub    $0x30,%eax
 3e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	3c 2f                	cmp    $0x2f,%al
 3f4:	7e 0a                	jle    400 <atoi+0x5a>
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	0f b6 00             	movzbl (%eax),%eax
 3fc:	3c 39                	cmp    $0x39,%al
 3fe:	7e c7                	jle    3c7 <atoi+0x21>

    return -n;
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
 403:	f7 d8                	neg    %eax
 405:	eb 3c                	jmp    443 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 407:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40a:	89 d0                	mov    %edx,%eax
 40c:	c1 e0 02             	shl    $0x2,%eax
 40f:	01 d0                	add    %edx,%eax
 411:	01 c0                	add    %eax,%eax
 413:	89 c1                	mov    %eax,%ecx
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	8d 50 01             	lea    0x1(%eax),%edx
 41b:	89 55 08             	mov    %edx,0x8(%ebp)
 41e:	0f b6 00             	movzbl (%eax),%eax
 421:	0f be c0             	movsbl %al,%eax
 424:	01 c8                	add    %ecx,%eax
 426:	83 e8 30             	sub    $0x30,%eax
 429:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
 42f:	0f b6 00             	movzbl (%eax),%eax
 432:	3c 2f                	cmp    $0x2f,%al
 434:	7e 0a                	jle    440 <atoi+0x9a>
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	3c 39                	cmp    $0x39,%al
 43e:	7e c7                	jle    407 <atoi+0x61>

    return n;
 440:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 445:	f3 0f 1e fb          	endbr32 
 449:	55                   	push   %ebp
 44a:	89 e5                	mov    %esp,%ebp
 44c:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 45b:	eb 17                	jmp    474 <memmove+0x2f>
    *dst++ = *src++;
 45d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 460:	8d 42 01             	lea    0x1(%edx),%eax
 463:	89 45 f8             	mov    %eax,-0x8(%ebp)
 466:	8b 45 fc             	mov    -0x4(%ebp),%eax
 469:	8d 48 01             	lea    0x1(%eax),%ecx
 46c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 46f:	0f b6 12             	movzbl (%edx),%edx
 472:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 474:	8b 45 10             	mov    0x10(%ebp),%eax
 477:	8d 50 ff             	lea    -0x1(%eax),%edx
 47a:	89 55 10             	mov    %edx,0x10(%ebp)
 47d:	85 c0                	test   %eax,%eax
 47f:	7f dc                	jg     45d <memmove+0x18>
  return vdst;
 481:	8b 45 08             	mov    0x8(%ebp),%eax
}
 484:	c9                   	leave  
 485:	c3                   	ret    

00000486 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 486:	b8 01 00 00 00       	mov    $0x1,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <exit>:
SYSCALL(exit)
 48e:	b8 02 00 00 00       	mov    $0x2,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <wait>:
SYSCALL(wait)
 496:	b8 03 00 00 00       	mov    $0x3,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <pipe>:
SYSCALL(pipe)
 49e:	b8 04 00 00 00       	mov    $0x4,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <read>:
SYSCALL(read)
 4a6:	b8 05 00 00 00       	mov    $0x5,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <write>:
SYSCALL(write)
 4ae:	b8 10 00 00 00       	mov    $0x10,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <close>:
SYSCALL(close)
 4b6:	b8 15 00 00 00       	mov    $0x15,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <kill>:
SYSCALL(kill)
 4be:	b8 06 00 00 00       	mov    $0x6,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <exec>:
SYSCALL(exec)
 4c6:	b8 07 00 00 00       	mov    $0x7,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <open>:
SYSCALL(open)
 4ce:	b8 0f 00 00 00       	mov    $0xf,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <mknod>:
SYSCALL(mknod)
 4d6:	b8 11 00 00 00       	mov    $0x11,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <unlink>:
SYSCALL(unlink)
 4de:	b8 12 00 00 00       	mov    $0x12,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <fstat>:
SYSCALL(fstat)
 4e6:	b8 08 00 00 00       	mov    $0x8,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <link>:
SYSCALL(link)
 4ee:	b8 13 00 00 00       	mov    $0x13,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <mkdir>:
SYSCALL(mkdir)
 4f6:	b8 14 00 00 00       	mov    $0x14,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <chdir>:
SYSCALL(chdir)
 4fe:	b8 09 00 00 00       	mov    $0x9,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <dup>:
SYSCALL(dup)
 506:	b8 0a 00 00 00       	mov    $0xa,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <getpid>:
SYSCALL(getpid)
 50e:	b8 0b 00 00 00       	mov    $0xb,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <sbrk>:
SYSCALL(sbrk)
 516:	b8 0c 00 00 00       	mov    $0xc,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <sleep>:
SYSCALL(sleep)
 51e:	b8 0d 00 00 00       	mov    $0xd,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <uptime>:
SYSCALL(uptime)
 526:	b8 0e 00 00 00       	mov    $0xe,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <lseek>:
SYSCALL(lseek)
 52e:	b8 16 00 00 00       	mov    $0x16,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 536:	f3 0f 1e fb          	endbr32 
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
 53d:	83 ec 18             	sub    $0x18,%esp
 540:	8b 45 0c             	mov    0xc(%ebp),%eax
 543:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 546:	83 ec 04             	sub    $0x4,%esp
 549:	6a 01                	push   $0x1
 54b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54e:	50                   	push   %eax
 54f:	ff 75 08             	pushl  0x8(%ebp)
 552:	e8 57 ff ff ff       	call   4ae <write>
 557:	83 c4 10             	add    $0x10,%esp
}
 55a:	90                   	nop
 55b:	c9                   	leave  
 55c:	c3                   	ret    

0000055d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55d:	f3 0f 1e fb          	endbr32 
 561:	55                   	push   %ebp
 562:	89 e5                	mov    %esp,%ebp
 564:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 567:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 56e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 572:	74 17                	je     58b <printint+0x2e>
 574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 578:	79 11                	jns    58b <printint+0x2e>
    neg = 1;
 57a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 581:	8b 45 0c             	mov    0xc(%ebp),%eax
 584:	f7 d8                	neg    %eax
 586:	89 45 ec             	mov    %eax,-0x14(%ebp)
 589:	eb 06                	jmp    591 <printint+0x34>
  } else {
    x = xx;
 58b:	8b 45 0c             	mov    0xc(%ebp),%eax
 58e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 598:	8b 4d 10             	mov    0x10(%ebp),%ecx
 59b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59e:	ba 00 00 00 00       	mov    $0x0,%edx
 5a3:	f7 f1                	div    %ecx
 5a5:	89 d1                	mov    %edx,%ecx
 5a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5aa:	8d 50 01             	lea    0x1(%eax),%edx
 5ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b0:	0f b6 91 80 0c 00 00 	movzbl 0xc80(%ecx),%edx
 5b7:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 5bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c1:	ba 00 00 00 00       	mov    $0x0,%edx
 5c6:	f7 f1                	div    %ecx
 5c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5cf:	75 c7                	jne    598 <printint+0x3b>
  if(neg)
 5d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d5:	74 2d                	je     604 <printint+0xa7>
    buf[i++] = '-';
 5d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5da:	8d 50 01             	lea    0x1(%eax),%edx
 5dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5e0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5e5:	eb 1d                	jmp    604 <printint+0xa7>
    putc(fd, buf[i]);
 5e7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ed:	01 d0                	add    %edx,%eax
 5ef:	0f b6 00             	movzbl (%eax),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	83 ec 08             	sub    $0x8,%esp
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	pushl  0x8(%ebp)
 5fc:	e8 35 ff ff ff       	call   536 <putc>
 601:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 604:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60c:	79 d9                	jns    5e7 <printint+0x8a>
}
 60e:	90                   	nop
 60f:	90                   	nop
 610:	c9                   	leave  
 611:	c3                   	ret    

00000612 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 612:	f3 0f 1e fb          	endbr32 
 616:	55                   	push   %ebp
 617:	89 e5                	mov    %esp,%ebp
 619:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 61c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 623:	8d 45 0c             	lea    0xc(%ebp),%eax
 626:	83 c0 04             	add    $0x4,%eax
 629:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 62c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 633:	e9 59 01 00 00       	jmp    791 <printf+0x17f>
    c = fmt[i] & 0xff;
 638:	8b 55 0c             	mov    0xc(%ebp),%edx
 63b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63e:	01 d0                	add    %edx,%eax
 640:	0f b6 00             	movzbl (%eax),%eax
 643:	0f be c0             	movsbl %al,%eax
 646:	25 ff 00 00 00       	and    $0xff,%eax
 64b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 64e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 652:	75 2c                	jne    680 <printf+0x6e>
      if(c == '%'){
 654:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 658:	75 0c                	jne    666 <printf+0x54>
        state = '%';
 65a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 661:	e9 27 01 00 00       	jmp    78d <printf+0x17b>
      } else {
        putc(fd, c);
 666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	50                   	push   %eax
 670:	ff 75 08             	pushl  0x8(%ebp)
 673:	e8 be fe ff ff       	call   536 <putc>
 678:	83 c4 10             	add    $0x10,%esp
 67b:	e9 0d 01 00 00       	jmp    78d <printf+0x17b>
      }
    } else if(state == '%'){
 680:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 684:	0f 85 03 01 00 00    	jne    78d <printf+0x17b>
      if(c == 'd'){
 68a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 68e:	75 1e                	jne    6ae <printf+0x9c>
        printint(fd, *ap, 10, 1);
 690:	8b 45 e8             	mov    -0x18(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	6a 01                	push   $0x1
 697:	6a 0a                	push   $0xa
 699:	50                   	push   %eax
 69a:	ff 75 08             	pushl  0x8(%ebp)
 69d:	e8 bb fe ff ff       	call   55d <printint>
 6a2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a9:	e9 d8 00 00 00       	jmp    786 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 6ae:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b2:	74 06                	je     6ba <printf+0xa8>
 6b4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b8:	75 1e                	jne    6d8 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 6ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	6a 00                	push   $0x0
 6c1:	6a 10                	push   $0x10
 6c3:	50                   	push   %eax
 6c4:	ff 75 08             	pushl  0x8(%ebp)
 6c7:	e8 91 fe ff ff       	call   55d <printint>
 6cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 6cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d3:	e9 ae 00 00 00       	jmp    786 <printf+0x174>
      } else if(c == 's'){
 6d8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6dc:	75 43                	jne    721 <printf+0x10f>
        s = (char*)*ap;
 6de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e1:	8b 00                	mov    (%eax),%eax
 6e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ee:	75 25                	jne    715 <printf+0x103>
          s = "(null)";
 6f0:	c7 45 f4 11 0a 00 00 	movl   $0xa11,-0xc(%ebp)
        while(*s != 0){
 6f7:	eb 1c                	jmp    715 <printf+0x103>
          putc(fd, *s);
 6f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fc:	0f b6 00             	movzbl (%eax),%eax
 6ff:	0f be c0             	movsbl %al,%eax
 702:	83 ec 08             	sub    $0x8,%esp
 705:	50                   	push   %eax
 706:	ff 75 08             	pushl  0x8(%ebp)
 709:	e8 28 fe ff ff       	call   536 <putc>
 70e:	83 c4 10             	add    $0x10,%esp
          s++;
 711:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 718:	0f b6 00             	movzbl (%eax),%eax
 71b:	84 c0                	test   %al,%al
 71d:	75 da                	jne    6f9 <printf+0xe7>
 71f:	eb 65                	jmp    786 <printf+0x174>
        }
      } else if(c == 'c'){
 721:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 725:	75 1d                	jne    744 <printf+0x132>
        putc(fd, *ap);
 727:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	0f be c0             	movsbl %al,%eax
 72f:	83 ec 08             	sub    $0x8,%esp
 732:	50                   	push   %eax
 733:	ff 75 08             	pushl  0x8(%ebp)
 736:	e8 fb fd ff ff       	call   536 <putc>
 73b:	83 c4 10             	add    $0x10,%esp
        ap++;
 73e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 742:	eb 42                	jmp    786 <printf+0x174>
      } else if(c == '%'){
 744:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 748:	75 17                	jne    761 <printf+0x14f>
        putc(fd, c);
 74a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74d:	0f be c0             	movsbl %al,%eax
 750:	83 ec 08             	sub    $0x8,%esp
 753:	50                   	push   %eax
 754:	ff 75 08             	pushl  0x8(%ebp)
 757:	e8 da fd ff ff       	call   536 <putc>
 75c:	83 c4 10             	add    $0x10,%esp
 75f:	eb 25                	jmp    786 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 761:	83 ec 08             	sub    $0x8,%esp
 764:	6a 25                	push   $0x25
 766:	ff 75 08             	pushl  0x8(%ebp)
 769:	e8 c8 fd ff ff       	call   536 <putc>
 76e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 774:	0f be c0             	movsbl %al,%eax
 777:	83 ec 08             	sub    $0x8,%esp
 77a:	50                   	push   %eax
 77b:	ff 75 08             	pushl  0x8(%ebp)
 77e:	e8 b3 fd ff ff       	call   536 <putc>
 783:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 786:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 78d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 791:	8b 55 0c             	mov    0xc(%ebp),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	01 d0                	add    %edx,%eax
 799:	0f b6 00             	movzbl (%eax),%eax
 79c:	84 c0                	test   %al,%al
 79e:	0f 85 94 fe ff ff    	jne    638 <printf+0x26>
    }
  }
}
 7a4:	90                   	nop
 7a5:	90                   	nop
 7a6:	c9                   	leave  
 7a7:	c3                   	ret    

000007a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a8:	f3 0f 1e fb          	endbr32 
 7ac:	55                   	push   %ebp
 7ad:	89 e5                	mov    %esp,%ebp
 7af:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b2:	8b 45 08             	mov    0x8(%ebp),%eax
 7b5:	83 e8 08             	sub    $0x8,%eax
 7b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bb:	a1 a8 0c 00 00       	mov    0xca8,%eax
 7c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c3:	eb 24                	jmp    7e9 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	8b 00                	mov    (%eax),%eax
 7ca:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 7cd:	72 12                	jb     7e1 <free+0x39>
 7cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d5:	77 24                	ja     7fb <free+0x53>
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	8b 00                	mov    (%eax),%eax
 7dc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7df:	72 1a                	jb     7fb <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ef:	76 d4                	jbe    7c5 <free+0x1d>
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7f9:	73 ca                	jae    7c5 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 808:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80b:	01 c2                	add    %eax,%edx
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	39 c2                	cmp    %eax,%edx
 814:	75 24                	jne    83a <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	8b 50 04             	mov    0x4(%eax),%edx
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	01 c2                	add    %eax,%edx
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82f:	8b 00                	mov    (%eax),%eax
 831:	8b 10                	mov    (%eax),%edx
 833:	8b 45 f8             	mov    -0x8(%ebp),%eax
 836:	89 10                	mov    %edx,(%eax)
 838:	eb 0a                	jmp    844 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 83a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83d:	8b 10                	mov    (%eax),%edx
 83f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 842:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 851:	8b 45 fc             	mov    -0x4(%ebp),%eax
 854:	01 d0                	add    %edx,%eax
 856:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 859:	75 20                	jne    87b <free+0xd3>
    p->s.size += bp->s.size;
 85b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85e:	8b 50 04             	mov    0x4(%eax),%edx
 861:	8b 45 f8             	mov    -0x8(%ebp),%eax
 864:	8b 40 04             	mov    0x4(%eax),%eax
 867:	01 c2                	add    %eax,%edx
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 86f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 872:	8b 10                	mov    (%eax),%edx
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	89 10                	mov    %edx,(%eax)
 879:	eb 08                	jmp    883 <free+0xdb>
  } else
    p->s.ptr = bp;
 87b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 881:	89 10                	mov    %edx,(%eax)
  freep = p;
 883:	8b 45 fc             	mov    -0x4(%ebp),%eax
 886:	a3 a8 0c 00 00       	mov    %eax,0xca8
}
 88b:	90                   	nop
 88c:	c9                   	leave  
 88d:	c3                   	ret    

0000088e <morecore>:

static Header*
morecore(uint nu)
{
 88e:	f3 0f 1e fb          	endbr32 
 892:	55                   	push   %ebp
 893:	89 e5                	mov    %esp,%ebp
 895:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 898:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 89f:	77 07                	ja     8a8 <morecore+0x1a>
    nu = 4096;
 8a1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a8:	8b 45 08             	mov    0x8(%ebp),%eax
 8ab:	c1 e0 03             	shl    $0x3,%eax
 8ae:	83 ec 0c             	sub    $0xc,%esp
 8b1:	50                   	push   %eax
 8b2:	e8 5f fc ff ff       	call   516 <sbrk>
 8b7:	83 c4 10             	add    $0x10,%esp
 8ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8bd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c1:	75 07                	jne    8ca <morecore+0x3c>
    return 0;
 8c3:	b8 00 00 00 00       	mov    $0x0,%eax
 8c8:	eb 26                	jmp    8f0 <morecore+0x62>
  hp = (Header*)p;
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d3:	8b 55 08             	mov    0x8(%ebp),%edx
 8d6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dc:	83 c0 08             	add    $0x8,%eax
 8df:	83 ec 0c             	sub    $0xc,%esp
 8e2:	50                   	push   %eax
 8e3:	e8 c0 fe ff ff       	call   7a8 <free>
 8e8:	83 c4 10             	add    $0x10,%esp
  return freep;
 8eb:	a1 a8 0c 00 00       	mov    0xca8,%eax
}
 8f0:	c9                   	leave  
 8f1:	c3                   	ret    

000008f2 <malloc>:

void*
malloc(uint nbytes)
{
 8f2:	f3 0f 1e fb          	endbr32 
 8f6:	55                   	push   %ebp
 8f7:	89 e5                	mov    %esp,%ebp
 8f9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fc:	8b 45 08             	mov    0x8(%ebp),%eax
 8ff:	83 c0 07             	add    $0x7,%eax
 902:	c1 e8 03             	shr    $0x3,%eax
 905:	83 c0 01             	add    $0x1,%eax
 908:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 90b:	a1 a8 0c 00 00       	mov    0xca8,%eax
 910:	89 45 f0             	mov    %eax,-0x10(%ebp)
 913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 917:	75 23                	jne    93c <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 919:	c7 45 f0 a0 0c 00 00 	movl   $0xca0,-0x10(%ebp)
 920:	8b 45 f0             	mov    -0x10(%ebp),%eax
 923:	a3 a8 0c 00 00       	mov    %eax,0xca8
 928:	a1 a8 0c 00 00       	mov    0xca8,%eax
 92d:	a3 a0 0c 00 00       	mov    %eax,0xca0
    base.s.size = 0;
 932:	c7 05 a4 0c 00 00 00 	movl   $0x0,0xca4
 939:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93f:	8b 00                	mov    (%eax),%eax
 941:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 944:	8b 45 f4             	mov    -0xc(%ebp),%eax
 947:	8b 40 04             	mov    0x4(%eax),%eax
 94a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 94d:	77 4d                	ja     99c <malloc+0xaa>
      if(p->s.size == nunits)
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	8b 40 04             	mov    0x4(%eax),%eax
 955:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 958:	75 0c                	jne    966 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	8b 10                	mov    (%eax),%edx
 95f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 962:	89 10                	mov    %edx,(%eax)
 964:	eb 26                	jmp    98c <malloc+0x9a>
      else {
        p->s.size -= nunits;
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	8b 40 04             	mov    0x4(%eax),%eax
 96c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 96f:	89 c2                	mov    %eax,%edx
 971:	8b 45 f4             	mov    -0xc(%ebp),%eax
 974:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97a:	8b 40 04             	mov    0x4(%eax),%eax
 97d:	c1 e0 03             	shl    $0x3,%eax
 980:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	8b 55 ec             	mov    -0x14(%ebp),%edx
 989:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 98c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98f:	a3 a8 0c 00 00       	mov    %eax,0xca8
      return (void*)(p + 1);
 994:	8b 45 f4             	mov    -0xc(%ebp),%eax
 997:	83 c0 08             	add    $0x8,%eax
 99a:	eb 3b                	jmp    9d7 <malloc+0xe5>
    }
    if(p == freep)
 99c:	a1 a8 0c 00 00       	mov    0xca8,%eax
 9a1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9a4:	75 1e                	jne    9c4 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 9a6:	83 ec 0c             	sub    $0xc,%esp
 9a9:	ff 75 ec             	pushl  -0x14(%ebp)
 9ac:	e8 dd fe ff ff       	call   88e <morecore>
 9b1:	83 c4 10             	add    $0x10,%esp
 9b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9bb:	75 07                	jne    9c4 <malloc+0xd2>
        return 0;
 9bd:	b8 00 00 00 00       	mov    $0x0,%eax
 9c2:	eb 13                	jmp    9d7 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cd:	8b 00                	mov    (%eax),%eax
 9cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d2:	e9 6d ff ff ff       	jmp    944 <malloc+0x52>
  }
}
 9d7:	c9                   	leave  
 9d8:	c3                   	ret    
