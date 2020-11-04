
_grep:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
   a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  11:	e9 ae 00 00 00       	jmp    c4 <grep+0xc4>
    m += n;
  16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  19:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1f:	05 a0 0e 00 00       	add    $0xea0,%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  27:	c7 45 f0 a0 0e 00 00 	movl   $0xea0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2e:	eb 44                	jmp    74 <grep+0x74>
      *q = 0;
  30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  33:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  36:	83 ec 08             	sub    $0x8,%esp
  39:	ff 75 f0             	pushl  -0x10(%ebp)
  3c:	ff 75 08             	pushl  0x8(%ebp)
  3f:	e8 97 01 00 00       	call   1db <match>
  44:	83 c4 10             	add    $0x10,%esp
  47:	85 c0                	test   %eax,%eax
  49:	74 20                	je     6b <grep+0x6b>
        *q = '\n';
  4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4e:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  54:	83 c0 01             	add    $0x1,%eax
  57:	2b 45 f0             	sub    -0x10(%ebp),%eax
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	50                   	push   %eax
  5e:	ff 75 f0             	pushl  -0x10(%ebp)
  61:	6a 01                	push   $0x1
  63:	e8 c4 05 00 00       	call   62c <write>
  68:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6e:	83 c0 01             	add    $0x1,%eax
  71:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  74:	83 ec 08             	sub    $0x8,%esp
  77:	6a 0a                	push   $0xa
  79:	ff 75 f0             	pushl  -0x10(%ebp)
  7c:	e8 a8 03 00 00       	call   429 <strchr>
  81:	83 c4 10             	add    $0x10,%esp
  84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8b:	75 a3                	jne    30 <grep+0x30>
    }
    if(p == buf)
  8d:	81 7d f0 a0 0e 00 00 	cmpl   $0xea0,-0x10(%ebp)
  94:	75 07                	jne    9d <grep+0x9d>
      m = 0;
  96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a1:	7e 21                	jle    c4 <grep+0xc4>
      m -= p - buf;
  a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a6:	2d a0 0e 00 00       	sub    $0xea0,%eax
  ab:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  ae:	83 ec 04             	sub    $0x4,%esp
  b1:	ff 75 f4             	pushl  -0xc(%ebp)
  b4:	ff 75 f0             	pushl  -0x10(%ebp)
  b7:	68 a0 0e 00 00       	push   $0xea0
  bc:	e8 02 05 00 00       	call   5c3 <memmove>
  c1:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c7:	ba ff 03 00 00       	mov    $0x3ff,%edx
  cc:	29 c2                	sub    %eax,%edx
  ce:	89 d0                	mov    %edx,%eax
  d0:	89 c2                	mov    %eax,%edx
  d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d5:	05 a0 0e 00 00       	add    $0xea0,%eax
  da:	83 ec 04             	sub    $0x4,%esp
  dd:	52                   	push   %edx
  de:	50                   	push   %eax
  df:	ff 75 0c             	pushl  0xc(%ebp)
  e2:	e8 3d 05 00 00       	call   624 <read>
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f1:	0f 8f 1f ff ff ff    	jg     16 <grep+0x16>
    }
  }
}
  f7:	90                   	nop
  f8:	90                   	nop
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <main>:

int
main(int argc, char *argv[])
{
  fb:	f3 0f 1e fb          	endbr32 
  ff:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 103:	83 e4 f0             	and    $0xfffffff0,%esp
 106:	ff 71 fc             	pushl  -0x4(%ecx)
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	53                   	push   %ebx
 10d:	51                   	push   %ecx
 10e:	83 ec 10             	sub    $0x10,%esp
 111:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
 113:	83 3b 01             	cmpl   $0x1,(%ebx)
 116:	7f 17                	jg     12f <main+0x34>
    printf(2, "usage: grep pattern [file ...]\n");
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	68 58 0b 00 00       	push   $0xb58
 120:	6a 02                	push   $0x2
 122:	e8 69 06 00 00       	call   790 <printf>
 127:	83 c4 10             	add    $0x10,%esp
    exit();
 12a:	e8 dd 04 00 00       	call   60c <exit>
  }
  pattern = argv[1];
 12f:	8b 43 04             	mov    0x4(%ebx),%eax
 132:	8b 40 04             	mov    0x4(%eax),%eax
 135:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
 138:	83 3b 02             	cmpl   $0x2,(%ebx)
 13b:	7f 15                	jg     152 <main+0x57>
    grep(pattern, 0);
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	6a 00                	push   $0x0
 142:	ff 75 f0             	pushl  -0x10(%ebp)
 145:	e8 b6 fe ff ff       	call   0 <grep>
 14a:	83 c4 10             	add    $0x10,%esp
    exit();
 14d:	e8 ba 04 00 00       	call   60c <exit>
  }

  for(i = 2; i < argc; i++){
 152:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 159:	eb 74                	jmp    1cf <main+0xd4>
    if((fd = open(argv[i], 0)) < 0){
 15b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 165:	8b 43 04             	mov    0x4(%ebx),%eax
 168:	01 d0                	add    %edx,%eax
 16a:	8b 00                	mov    (%eax),%eax
 16c:	83 ec 08             	sub    $0x8,%esp
 16f:	6a 00                	push   $0x0
 171:	50                   	push   %eax
 172:	e8 d5 04 00 00       	call   64c <open>
 177:	83 c4 10             	add    $0x10,%esp
 17a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 181:	79 29                	jns    1ac <main+0xb1>
      printf(1, "grep: cannot open %s\n", argv[i]);
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18d:	8b 43 04             	mov    0x4(%ebx),%eax
 190:	01 d0                	add    %edx,%eax
 192:	8b 00                	mov    (%eax),%eax
 194:	83 ec 04             	sub    $0x4,%esp
 197:	50                   	push   %eax
 198:	68 78 0b 00 00       	push   $0xb78
 19d:	6a 01                	push   $0x1
 19f:	e8 ec 05 00 00       	call   790 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
      exit();
 1a7:	e8 60 04 00 00       	call   60c <exit>
    }
    grep(pattern, fd);
 1ac:	83 ec 08             	sub    $0x8,%esp
 1af:	ff 75 ec             	pushl  -0x14(%ebp)
 1b2:	ff 75 f0             	pushl  -0x10(%ebp)
 1b5:	e8 46 fe ff ff       	call   0 <grep>
 1ba:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bd:	83 ec 0c             	sub    $0xc,%esp
 1c0:	ff 75 ec             	pushl  -0x14(%ebp)
 1c3:	e8 6c 04 00 00       	call   634 <close>
 1c8:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d2:	3b 03                	cmp    (%ebx),%eax
 1d4:	7c 85                	jl     15b <main+0x60>
  }
  exit();
 1d6:	e8 31 04 00 00       	call   60c <exit>

000001db <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1db:	f3 0f 1e fb          	endbr32 
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3c 5e                	cmp    $0x5e,%al
 1ed:	75 17                	jne    206 <match+0x2b>
    return matchhere(re+1, text);
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	83 c0 01             	add    $0x1,%eax
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	ff 75 0c             	pushl  0xc(%ebp)
 1fb:	50                   	push   %eax
 1fc:	e8 38 00 00 00       	call   239 <matchhere>
 201:	83 c4 10             	add    $0x10,%esp
 204:	eb 31                	jmp    237 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 206:	83 ec 08             	sub    $0x8,%esp
 209:	ff 75 0c             	pushl  0xc(%ebp)
 20c:	ff 75 08             	pushl  0x8(%ebp)
 20f:	e8 25 00 00 00       	call   239 <matchhere>
 214:	83 c4 10             	add    $0x10,%esp
 217:	85 c0                	test   %eax,%eax
 219:	74 07                	je     222 <match+0x47>
      return 1;
 21b:	b8 01 00 00 00       	mov    $0x1,%eax
 220:	eb 15                	jmp    237 <match+0x5c>
  }while(*text++ != '\0');
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	8d 50 01             	lea    0x1(%eax),%edx
 228:	89 55 0c             	mov    %edx,0xc(%ebp)
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	84 c0                	test   %al,%al
 230:	75 d4                	jne    206 <match+0x2b>
  return 0;
 232:	b8 00 00 00 00       	mov    $0x0,%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 239:	f3 0f 1e fb          	endbr32 
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	84 c0                	test   %al,%al
 24b:	75 0a                	jne    257 <matchhere+0x1e>
    return 1;
 24d:	b8 01 00 00 00       	mov    $0x1,%eax
 252:	e9 99 00 00 00       	jmp    2f0 <matchhere+0xb7>
  if(re[1] == '*')
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	83 c0 01             	add    $0x1,%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	3c 2a                	cmp    $0x2a,%al
 262:	75 21                	jne    285 <matchhere+0x4c>
    return matchstar(re[0], re+2, text);
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8d 50 02             	lea    0x2(%eax),%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	0f be c0             	movsbl %al,%eax
 273:	83 ec 04             	sub    $0x4,%esp
 276:	ff 75 0c             	pushl  0xc(%ebp)
 279:	52                   	push   %edx
 27a:	50                   	push   %eax
 27b:	e8 72 00 00 00       	call   2f2 <matchstar>
 280:	83 c4 10             	add    $0x10,%esp
 283:	eb 6b                	jmp    2f0 <matchhere+0xb7>
  if(re[0] == '$' && re[1] == '\0')
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	3c 24                	cmp    $0x24,%al
 28d:	75 1d                	jne    2ac <matchhere+0x73>
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	83 c0 01             	add    $0x1,%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	84 c0                	test   %al,%al
 29a:	75 10                	jne    2ac <matchhere+0x73>
    return *text == '\0';
 29c:	8b 45 0c             	mov    0xc(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	84 c0                	test   %al,%al
 2a4:	0f 94 c0             	sete   %al
 2a7:	0f b6 c0             	movzbl %al,%eax
 2aa:	eb 44                	jmp    2f0 <matchhere+0xb7>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	84 c0                	test   %al,%al
 2b4:	74 35                	je     2eb <matchhere+0xb2>
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	3c 2e                	cmp    $0x2e,%al
 2be:	74 10                	je     2d0 <matchhere+0x97>
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	0f b6 10             	movzbl (%eax),%edx
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	38 c2                	cmp    %al,%dl
 2ce:	75 1b                	jne    2eb <matchhere+0xb2>
    return matchhere(re+1, text+1);
 2d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d3:	8d 50 01             	lea    0x1(%eax),%edx
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	83 c0 01             	add    $0x1,%eax
 2dc:	83 ec 08             	sub    $0x8,%esp
 2df:	52                   	push   %edx
 2e0:	50                   	push   %eax
 2e1:	e8 53 ff ff ff       	call   239 <matchhere>
 2e6:	83 c4 10             	add    $0x10,%esp
 2e9:	eb 05                	jmp    2f0 <matchhere+0xb7>
  return 0;
 2eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2f2:	f3 0f 1e fb          	endbr32 
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2fc:	83 ec 08             	sub    $0x8,%esp
 2ff:	ff 75 10             	pushl  0x10(%ebp)
 302:	ff 75 0c             	pushl  0xc(%ebp)
 305:	e8 2f ff ff ff       	call   239 <matchhere>
 30a:	83 c4 10             	add    $0x10,%esp
 30d:	85 c0                	test   %eax,%eax
 30f:	74 07                	je     318 <matchstar+0x26>
      return 1;
 311:	b8 01 00 00 00       	mov    $0x1,%eax
 316:	eb 29                	jmp    341 <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	0f b6 00             	movzbl (%eax),%eax
 31e:	84 c0                	test   %al,%al
 320:	74 1a                	je     33c <matchstar+0x4a>
 322:	8b 45 10             	mov    0x10(%ebp),%eax
 325:	8d 50 01             	lea    0x1(%eax),%edx
 328:	89 55 10             	mov    %edx,0x10(%ebp)
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	0f be c0             	movsbl %al,%eax
 331:	39 45 08             	cmp    %eax,0x8(%ebp)
 334:	74 c6                	je     2fc <matchstar+0xa>
 336:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 33a:	74 c0                	je     2fc <matchstar+0xa>
  return 0;
 33c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	57                   	push   %edi
 347:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 348:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34b:	8b 55 10             	mov    0x10(%ebp),%edx
 34e:	8b 45 0c             	mov    0xc(%ebp),%eax
 351:	89 cb                	mov    %ecx,%ebx
 353:	89 df                	mov    %ebx,%edi
 355:	89 d1                	mov    %edx,%ecx
 357:	fc                   	cld    
 358:	f3 aa                	rep stos %al,%es:(%edi)
 35a:	89 ca                	mov    %ecx,%edx
 35c:	89 fb                	mov    %edi,%ebx
 35e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 361:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 364:	90                   	nop
 365:	5b                   	pop    %ebx
 366:	5f                   	pop    %edi
 367:	5d                   	pop    %ebp
 368:	c3                   	ret    

00000369 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 369:	f3 0f 1e fb          	endbr32 
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 379:	90                   	nop
 37a:	8b 55 0c             	mov    0xc(%ebp),%edx
 37d:	8d 42 01             	lea    0x1(%edx),%eax
 380:	89 45 0c             	mov    %eax,0xc(%ebp)
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8d 48 01             	lea    0x1(%eax),%ecx
 389:	89 4d 08             	mov    %ecx,0x8(%ebp)
 38c:	0f b6 12             	movzbl (%edx),%edx
 38f:	88 10                	mov    %dl,(%eax)
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	75 e2                	jne    37a <strcpy+0x11>
    ;
  return os;
 398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39b:	c9                   	leave  
 39c:	c3                   	ret    

0000039d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39d:	f3 0f 1e fb          	endbr32 
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3a4:	eb 08                	jmp    3ae <strcmp+0x11>
    p++, q++;
 3a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
 3b1:	0f b6 00             	movzbl (%eax),%eax
 3b4:	84 c0                	test   %al,%al
 3b6:	74 10                	je     3c8 <strcmp+0x2b>
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	0f b6 10             	movzbl (%eax),%edx
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	0f b6 00             	movzbl (%eax),%eax
 3c4:	38 c2                	cmp    %al,%dl
 3c6:	74 de                	je     3a6 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	0f b6 d0             	movzbl %al,%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	0f b6 c0             	movzbl %al,%eax
 3da:	29 c2                	sub    %eax,%edx
 3dc:	89 d0                	mov    %edx,%eax
}
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    

000003e0 <strlen>:

uint
strlen(const char *s)
{
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f1:	eb 04                	jmp    3f7 <strlen+0x17>
 3f3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	01 d0                	add    %edx,%eax
 3ff:	0f b6 00             	movzbl (%eax),%eax
 402:	84 c0                	test   %al,%al
 404:	75 ed                	jne    3f3 <strlen+0x13>
    ;
  return n;
 406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 409:	c9                   	leave  
 40a:	c3                   	ret    

0000040b <memset>:

void*
memset(void *dst, int c, uint n)
{
 40b:	f3 0f 1e fb          	endbr32 
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 412:	8b 45 10             	mov    0x10(%ebp),%eax
 415:	50                   	push   %eax
 416:	ff 75 0c             	pushl  0xc(%ebp)
 419:	ff 75 08             	pushl  0x8(%ebp)
 41c:	e8 22 ff ff ff       	call   343 <stosb>
 421:	83 c4 0c             	add    $0xc,%esp
  return dst;
 424:	8b 45 08             	mov    0x8(%ebp),%eax
}
 427:	c9                   	leave  
 428:	c3                   	ret    

00000429 <strchr>:

char*
strchr(const char *s, char c)
{
 429:	f3 0f 1e fb          	endbr32 
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp
 430:	83 ec 04             	sub    $0x4,%esp
 433:	8b 45 0c             	mov    0xc(%ebp),%eax
 436:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 439:	eb 14                	jmp    44f <strchr+0x26>
    if(*s == c)
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	0f b6 00             	movzbl (%eax),%eax
 441:	38 45 fc             	cmp    %al,-0x4(%ebp)
 444:	75 05                	jne    44b <strchr+0x22>
      return (char*)s;
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	eb 13                	jmp    45e <strchr+0x35>
  for(; *s; s++)
 44b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	84 c0                	test   %al,%al
 457:	75 e2                	jne    43b <strchr+0x12>
  return 0;
 459:	b8 00 00 00 00       	mov    $0x0,%eax
}
 45e:	c9                   	leave  
 45f:	c3                   	ret    

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	f3 0f 1e fb          	endbr32 
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 471:	eb 42                	jmp    4b5 <gets+0x55>
    cc = read(0, &c, 1);
 473:	83 ec 04             	sub    $0x4,%esp
 476:	6a 01                	push   $0x1
 478:	8d 45 ef             	lea    -0x11(%ebp),%eax
 47b:	50                   	push   %eax
 47c:	6a 00                	push   $0x0
 47e:	e8 a1 01 00 00       	call   624 <read>
 483:	83 c4 10             	add    $0x10,%esp
 486:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48d:	7e 33                	jle    4c2 <gets+0x62>
      break;
    buf[i++] = c;
 48f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 492:	8d 50 01             	lea    0x1(%eax),%edx
 495:	89 55 f4             	mov    %edx,-0xc(%ebp)
 498:	89 c2                	mov    %eax,%edx
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	01 c2                	add    %eax,%edx
 49f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a9:	3c 0a                	cmp    $0xa,%al
 4ab:	74 16                	je     4c3 <gets+0x63>
 4ad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b1:	3c 0d                	cmp    $0xd,%al
 4b3:	74 0e                	je     4c3 <gets+0x63>
  for(i=0; i+1 < max; ){
 4b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b8:	83 c0 01             	add    $0x1,%eax
 4bb:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4be:	7f b3                	jg     473 <gets+0x13>
 4c0:	eb 01                	jmp    4c3 <gets+0x63>
      break;
 4c2:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	01 d0                	add    %edx,%eax
 4cb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d1:	c9                   	leave  
 4d2:	c3                   	ret    

000004d3 <stat>:

int
stat(const char *n, struct stat *st)
{
 4d3:	f3 0f 1e fb          	endbr32 
 4d7:	55                   	push   %ebp
 4d8:	89 e5                	mov    %esp,%ebp
 4da:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4dd:	83 ec 08             	sub    $0x8,%esp
 4e0:	6a 00                	push   $0x0
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 62 01 00 00       	call   64c <open>
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f4:	79 07                	jns    4fd <stat+0x2a>
    return -1;
 4f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4fb:	eb 25                	jmp    522 <stat+0x4f>
  r = fstat(fd, st);
 4fd:	83 ec 08             	sub    $0x8,%esp
 500:	ff 75 0c             	pushl  0xc(%ebp)
 503:	ff 75 f4             	pushl  -0xc(%ebp)
 506:	e8 59 01 00 00       	call   664 <fstat>
 50b:	83 c4 10             	add    $0x10,%esp
 50e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 511:	83 ec 0c             	sub    $0xc,%esp
 514:	ff 75 f4             	pushl  -0xc(%ebp)
 517:	e8 18 01 00 00       	call   634 <close>
 51c:	83 c4 10             	add    $0x10,%esp
  return r;
 51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 522:	c9                   	leave  
 523:	c3                   	ret    

00000524 <atoi>:



int
atoi(const char *s)
{
 524:	f3 0f 1e fb          	endbr32 
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 52e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	0f b6 00             	movzbl (%eax),%eax
 53b:	3c 2d                	cmp    $0x2d,%al
 53d:	75 6b                	jne    5aa <atoi+0x86>
  {
    s++;
 53f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 543:	eb 25                	jmp    56a <atoi+0x46>
        n = n*10 + *s++ - '0';
 545:	8b 55 fc             	mov    -0x4(%ebp),%edx
 548:	89 d0                	mov    %edx,%eax
 54a:	c1 e0 02             	shl    $0x2,%eax
 54d:	01 d0                	add    %edx,%eax
 54f:	01 c0                	add    %eax,%eax
 551:	89 c1                	mov    %eax,%ecx
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	8d 50 01             	lea    0x1(%eax),%edx
 559:	89 55 08             	mov    %edx,0x8(%ebp)
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	0f be c0             	movsbl %al,%eax
 562:	01 c8                	add    %ecx,%eax
 564:	83 e8 30             	sub    $0x30,%eax
 567:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	0f b6 00             	movzbl (%eax),%eax
 570:	3c 2f                	cmp    $0x2f,%al
 572:	7e 0a                	jle    57e <atoi+0x5a>
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	0f b6 00             	movzbl (%eax),%eax
 57a:	3c 39                	cmp    $0x39,%al
 57c:	7e c7                	jle    545 <atoi+0x21>

    return -n;
 57e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 581:	f7 d8                	neg    %eax
 583:	eb 3c                	jmp    5c1 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 585:	8b 55 fc             	mov    -0x4(%ebp),%edx
 588:	89 d0                	mov    %edx,%eax
 58a:	c1 e0 02             	shl    $0x2,%eax
 58d:	01 d0                	add    %edx,%eax
 58f:	01 c0                	add    %eax,%eax
 591:	89 c1                	mov    %eax,%ecx
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	8d 50 01             	lea    0x1(%eax),%edx
 599:	89 55 08             	mov    %edx,0x8(%ebp)
 59c:	0f b6 00             	movzbl (%eax),%eax
 59f:	0f be c0             	movsbl %al,%eax
 5a2:	01 c8                	add    %ecx,%eax
 5a4:	83 e8 30             	sub    $0x30,%eax
 5a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	3c 2f                	cmp    $0x2f,%al
 5b2:	7e 0a                	jle    5be <atoi+0x9a>
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	0f b6 00             	movzbl (%eax),%eax
 5ba:	3c 39                	cmp    $0x39,%al
 5bc:	7e c7                	jle    585 <atoi+0x61>

    return n;
 5be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 5c1:	c9                   	leave  
 5c2:	c3                   	ret    

000005c3 <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 5c3:	f3 0f 1e fb          	endbr32 
 5c7:	55                   	push   %ebp
 5c8:	89 e5                	mov    %esp,%ebp
 5ca:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5d9:	eb 17                	jmp    5f2 <memmove+0x2f>
    *dst++ = *src++;
 5db:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5de:	8d 42 01             	lea    0x1(%edx),%eax
 5e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
 5e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e7:	8d 48 01             	lea    0x1(%eax),%ecx
 5ea:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 5ed:	0f b6 12             	movzbl (%edx),%edx
 5f0:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 5f2:	8b 45 10             	mov    0x10(%ebp),%eax
 5f5:	8d 50 ff             	lea    -0x1(%eax),%edx
 5f8:	89 55 10             	mov    %edx,0x10(%ebp)
 5fb:	85 c0                	test   %eax,%eax
 5fd:	7f dc                	jg     5db <memmove+0x18>
  return vdst;
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 602:	c9                   	leave  
 603:	c3                   	ret    

00000604 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 604:	b8 01 00 00 00       	mov    $0x1,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <exit>:
SYSCALL(exit)
 60c:	b8 02 00 00 00       	mov    $0x2,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <wait>:
SYSCALL(wait)
 614:	b8 03 00 00 00       	mov    $0x3,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <pipe>:
SYSCALL(pipe)
 61c:	b8 04 00 00 00       	mov    $0x4,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <read>:
SYSCALL(read)
 624:	b8 05 00 00 00       	mov    $0x5,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <write>:
SYSCALL(write)
 62c:	b8 10 00 00 00       	mov    $0x10,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <close>:
SYSCALL(close)
 634:	b8 15 00 00 00       	mov    $0x15,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <kill>:
SYSCALL(kill)
 63c:	b8 06 00 00 00       	mov    $0x6,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <exec>:
SYSCALL(exec)
 644:	b8 07 00 00 00       	mov    $0x7,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <open>:
SYSCALL(open)
 64c:	b8 0f 00 00 00       	mov    $0xf,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <mknod>:
SYSCALL(mknod)
 654:	b8 11 00 00 00       	mov    $0x11,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <unlink>:
SYSCALL(unlink)
 65c:	b8 12 00 00 00       	mov    $0x12,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <fstat>:
SYSCALL(fstat)
 664:	b8 08 00 00 00       	mov    $0x8,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <link>:
SYSCALL(link)
 66c:	b8 13 00 00 00       	mov    $0x13,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <mkdir>:
SYSCALL(mkdir)
 674:	b8 14 00 00 00       	mov    $0x14,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <chdir>:
SYSCALL(chdir)
 67c:	b8 09 00 00 00       	mov    $0x9,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <dup>:
SYSCALL(dup)
 684:	b8 0a 00 00 00       	mov    $0xa,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <getpid>:
SYSCALL(getpid)
 68c:	b8 0b 00 00 00       	mov    $0xb,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <sbrk>:
SYSCALL(sbrk)
 694:	b8 0c 00 00 00       	mov    $0xc,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <sleep>:
SYSCALL(sleep)
 69c:	b8 0d 00 00 00       	mov    $0xd,%eax
 6a1:	cd 40                	int    $0x40
 6a3:	c3                   	ret    

000006a4 <uptime>:
SYSCALL(uptime)
 6a4:	b8 0e 00 00 00       	mov    $0xe,%eax
 6a9:	cd 40                	int    $0x40
 6ab:	c3                   	ret    

000006ac <lseek>:
SYSCALL(lseek)
 6ac:	b8 16 00 00 00       	mov    $0x16,%eax
 6b1:	cd 40                	int    $0x40
 6b3:	c3                   	ret    

000006b4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b4:	f3 0f 1e fb          	endbr32 
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 18             	sub    $0x18,%esp
 6be:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6c4:	83 ec 04             	sub    $0x4,%esp
 6c7:	6a 01                	push   $0x1
 6c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6cc:	50                   	push   %eax
 6cd:	ff 75 08             	pushl  0x8(%ebp)
 6d0:	e8 57 ff ff ff       	call   62c <write>
 6d5:	83 c4 10             	add    $0x10,%esp
}
 6d8:	90                   	nop
 6d9:	c9                   	leave  
 6da:	c3                   	ret    

000006db <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6db:	f3 0f 1e fb          	endbr32 
 6df:	55                   	push   %ebp
 6e0:	89 e5                	mov    %esp,%ebp
 6e2:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6ec:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6f0:	74 17                	je     709 <printint+0x2e>
 6f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6f6:	79 11                	jns    709 <printint+0x2e>
    neg = 1;
 6f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 702:	f7 d8                	neg    %eax
 704:	89 45 ec             	mov    %eax,-0x14(%ebp)
 707:	eb 06                	jmp    70f <printint+0x34>
  } else {
    x = xx;
 709:	8b 45 0c             	mov    0xc(%ebp),%eax
 70c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 70f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 716:	8b 4d 10             	mov    0x10(%ebp),%ecx
 719:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71c:	ba 00 00 00 00       	mov    $0x0,%edx
 721:	f7 f1                	div    %ecx
 723:	89 d1                	mov    %edx,%ecx
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	8d 50 01             	lea    0x1(%eax),%edx
 72b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 72e:	0f b6 91 60 0e 00 00 	movzbl 0xe60(%ecx),%edx
 735:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 739:	8b 4d 10             	mov    0x10(%ebp),%ecx
 73c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73f:	ba 00 00 00 00       	mov    $0x0,%edx
 744:	f7 f1                	div    %ecx
 746:	89 45 ec             	mov    %eax,-0x14(%ebp)
 749:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 74d:	75 c7                	jne    716 <printint+0x3b>
  if(neg)
 74f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 753:	74 2d                	je     782 <printint+0xa7>
    buf[i++] = '-';
 755:	8b 45 f4             	mov    -0xc(%ebp),%eax
 758:	8d 50 01             	lea    0x1(%eax),%edx
 75b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 763:	eb 1d                	jmp    782 <printint+0xa7>
    putc(fd, buf[i]);
 765:	8d 55 dc             	lea    -0x24(%ebp),%edx
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	01 d0                	add    %edx,%eax
 76d:	0f b6 00             	movzbl (%eax),%eax
 770:	0f be c0             	movsbl %al,%eax
 773:	83 ec 08             	sub    $0x8,%esp
 776:	50                   	push   %eax
 777:	ff 75 08             	pushl  0x8(%ebp)
 77a:	e8 35 ff ff ff       	call   6b4 <putc>
 77f:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 782:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 78a:	79 d9                	jns    765 <printint+0x8a>
}
 78c:	90                   	nop
 78d:	90                   	nop
 78e:	c9                   	leave  
 78f:	c3                   	ret    

00000790 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 790:	f3 0f 1e fb          	endbr32 
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 79a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7a1:	8d 45 0c             	lea    0xc(%ebp),%eax
 7a4:	83 c0 04             	add    $0x4,%eax
 7a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7b1:	e9 59 01 00 00       	jmp    90f <printf+0x17f>
    c = fmt[i] & 0xff;
 7b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bc:	01 d0                	add    %edx,%eax
 7be:	0f b6 00             	movzbl (%eax),%eax
 7c1:	0f be c0             	movsbl %al,%eax
 7c4:	25 ff 00 00 00       	and    $0xff,%eax
 7c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7d0:	75 2c                	jne    7fe <printf+0x6e>
      if(c == '%'){
 7d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d6:	75 0c                	jne    7e4 <printf+0x54>
        state = '%';
 7d8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7df:	e9 27 01 00 00       	jmp    90b <printf+0x17b>
      } else {
        putc(fd, c);
 7e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e7:	0f be c0             	movsbl %al,%eax
 7ea:	83 ec 08             	sub    $0x8,%esp
 7ed:	50                   	push   %eax
 7ee:	ff 75 08             	pushl  0x8(%ebp)
 7f1:	e8 be fe ff ff       	call   6b4 <putc>
 7f6:	83 c4 10             	add    $0x10,%esp
 7f9:	e9 0d 01 00 00       	jmp    90b <printf+0x17b>
      }
    } else if(state == '%'){
 7fe:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 802:	0f 85 03 01 00 00    	jne    90b <printf+0x17b>
      if(c == 'd'){
 808:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 80c:	75 1e                	jne    82c <printf+0x9c>
        printint(fd, *ap, 10, 1);
 80e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	6a 01                	push   $0x1
 815:	6a 0a                	push   $0xa
 817:	50                   	push   %eax
 818:	ff 75 08             	pushl  0x8(%ebp)
 81b:	e8 bb fe ff ff       	call   6db <printint>
 820:	83 c4 10             	add    $0x10,%esp
        ap++;
 823:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 827:	e9 d8 00 00 00       	jmp    904 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 82c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 830:	74 06                	je     838 <printf+0xa8>
 832:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 836:	75 1e                	jne    856 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 838:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	6a 00                	push   $0x0
 83f:	6a 10                	push   $0x10
 841:	50                   	push   %eax
 842:	ff 75 08             	pushl  0x8(%ebp)
 845:	e8 91 fe ff ff       	call   6db <printint>
 84a:	83 c4 10             	add    $0x10,%esp
        ap++;
 84d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 851:	e9 ae 00 00 00       	jmp    904 <printf+0x174>
      } else if(c == 's'){
 856:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 85a:	75 43                	jne    89f <printf+0x10f>
        s = (char*)*ap;
 85c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 85f:	8b 00                	mov    (%eax),%eax
 861:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 864:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86c:	75 25                	jne    893 <printf+0x103>
          s = "(null)";
 86e:	c7 45 f4 8e 0b 00 00 	movl   $0xb8e,-0xc(%ebp)
        while(*s != 0){
 875:	eb 1c                	jmp    893 <printf+0x103>
          putc(fd, *s);
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	0f b6 00             	movzbl (%eax),%eax
 87d:	0f be c0             	movsbl %al,%eax
 880:	83 ec 08             	sub    $0x8,%esp
 883:	50                   	push   %eax
 884:	ff 75 08             	pushl  0x8(%ebp)
 887:	e8 28 fe ff ff       	call   6b4 <putc>
 88c:	83 c4 10             	add    $0x10,%esp
          s++;
 88f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	0f b6 00             	movzbl (%eax),%eax
 899:	84 c0                	test   %al,%al
 89b:	75 da                	jne    877 <printf+0xe7>
 89d:	eb 65                	jmp    904 <printf+0x174>
        }
      } else if(c == 'c'){
 89f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8a3:	75 1d                	jne    8c2 <printf+0x132>
        putc(fd, *ap);
 8a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a8:	8b 00                	mov    (%eax),%eax
 8aa:	0f be c0             	movsbl %al,%eax
 8ad:	83 ec 08             	sub    $0x8,%esp
 8b0:	50                   	push   %eax
 8b1:	ff 75 08             	pushl  0x8(%ebp)
 8b4:	e8 fb fd ff ff       	call   6b4 <putc>
 8b9:	83 c4 10             	add    $0x10,%esp
        ap++;
 8bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c0:	eb 42                	jmp    904 <printf+0x174>
      } else if(c == '%'){
 8c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8c6:	75 17                	jne    8df <printf+0x14f>
        putc(fd, c);
 8c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8cb:	0f be c0             	movsbl %al,%eax
 8ce:	83 ec 08             	sub    $0x8,%esp
 8d1:	50                   	push   %eax
 8d2:	ff 75 08             	pushl  0x8(%ebp)
 8d5:	e8 da fd ff ff       	call   6b4 <putc>
 8da:	83 c4 10             	add    $0x10,%esp
 8dd:	eb 25                	jmp    904 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8df:	83 ec 08             	sub    $0x8,%esp
 8e2:	6a 25                	push   $0x25
 8e4:	ff 75 08             	pushl  0x8(%ebp)
 8e7:	e8 c8 fd ff ff       	call   6b4 <putc>
 8ec:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f2:	0f be c0             	movsbl %al,%eax
 8f5:	83 ec 08             	sub    $0x8,%esp
 8f8:	50                   	push   %eax
 8f9:	ff 75 08             	pushl  0x8(%ebp)
 8fc:	e8 b3 fd ff ff       	call   6b4 <putc>
 901:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 904:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 90b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 90f:	8b 55 0c             	mov    0xc(%ebp),%edx
 912:	8b 45 f0             	mov    -0x10(%ebp),%eax
 915:	01 d0                	add    %edx,%eax
 917:	0f b6 00             	movzbl (%eax),%eax
 91a:	84 c0                	test   %al,%al
 91c:	0f 85 94 fe ff ff    	jne    7b6 <printf+0x26>
    }
  }
}
 922:	90                   	nop
 923:	90                   	nop
 924:	c9                   	leave  
 925:	c3                   	ret    

00000926 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 926:	f3 0f 1e fb          	endbr32 
 92a:	55                   	push   %ebp
 92b:	89 e5                	mov    %esp,%ebp
 92d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 930:	8b 45 08             	mov    0x8(%ebp),%eax
 933:	83 e8 08             	sub    $0x8,%eax
 936:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 939:	a1 88 0e 00 00       	mov    0xe88,%eax
 93e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 941:	eb 24                	jmp    967 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	8b 00                	mov    (%eax),%eax
 948:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 94b:	72 12                	jb     95f <free+0x39>
 94d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 950:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 953:	77 24                	ja     979 <free+0x53>
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	8b 00                	mov    (%eax),%eax
 95a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 95d:	72 1a                	jb     979 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 00                	mov    (%eax),%eax
 964:	89 45 fc             	mov    %eax,-0x4(%ebp)
 967:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 96d:	76 d4                	jbe    943 <free+0x1d>
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	8b 00                	mov    (%eax),%eax
 974:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 977:	73 ca                	jae    943 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 979:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97c:	8b 40 04             	mov    0x4(%eax),%eax
 97f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 986:	8b 45 f8             	mov    -0x8(%ebp),%eax
 989:	01 c2                	add    %eax,%edx
 98b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98e:	8b 00                	mov    (%eax),%eax
 990:	39 c2                	cmp    %eax,%edx
 992:	75 24                	jne    9b8 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 994:	8b 45 f8             	mov    -0x8(%ebp),%eax
 997:	8b 50 04             	mov    0x4(%eax),%edx
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	8b 00                	mov    (%eax),%eax
 99f:	8b 40 04             	mov    0x4(%eax),%eax
 9a2:	01 c2                	add    %eax,%edx
 9a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ad:	8b 00                	mov    (%eax),%eax
 9af:	8b 10                	mov    (%eax),%edx
 9b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b4:	89 10                	mov    %edx,(%eax)
 9b6:	eb 0a                	jmp    9c2 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bb:	8b 10                	mov    (%eax),%edx
 9bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	8b 40 04             	mov    0x4(%eax),%eax
 9c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d2:	01 d0                	add    %edx,%eax
 9d4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 9d7:	75 20                	jne    9f9 <free+0xd3>
    p->s.size += bp->s.size;
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	8b 50 04             	mov    0x4(%eax),%edx
 9df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e2:	8b 40 04             	mov    0x4(%eax),%eax
 9e5:	01 c2                	add    %eax,%edx
 9e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ea:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f0:	8b 10                	mov    (%eax),%edx
 9f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f5:	89 10                	mov    %edx,(%eax)
 9f7:	eb 08                	jmp    a01 <free+0xdb>
  } else
    p->s.ptr = bp;
 9f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9ff:	89 10                	mov    %edx,(%eax)
  freep = p;
 a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a04:	a3 88 0e 00 00       	mov    %eax,0xe88
}
 a09:	90                   	nop
 a0a:	c9                   	leave  
 a0b:	c3                   	ret    

00000a0c <morecore>:

static Header*
morecore(uint nu)
{
 a0c:	f3 0f 1e fb          	endbr32 
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a16:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a1d:	77 07                	ja     a26 <morecore+0x1a>
    nu = 4096;
 a1f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a26:	8b 45 08             	mov    0x8(%ebp),%eax
 a29:	c1 e0 03             	shl    $0x3,%eax
 a2c:	83 ec 0c             	sub    $0xc,%esp
 a2f:	50                   	push   %eax
 a30:	e8 5f fc ff ff       	call   694 <sbrk>
 a35:	83 c4 10             	add    $0x10,%esp
 a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a3b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a3f:	75 07                	jne    a48 <morecore+0x3c>
    return 0;
 a41:	b8 00 00 00 00       	mov    $0x0,%eax
 a46:	eb 26                	jmp    a6e <morecore+0x62>
  hp = (Header*)p;
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a51:	8b 55 08             	mov    0x8(%ebp),%edx
 a54:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5a:	83 c0 08             	add    $0x8,%eax
 a5d:	83 ec 0c             	sub    $0xc,%esp
 a60:	50                   	push   %eax
 a61:	e8 c0 fe ff ff       	call   926 <free>
 a66:	83 c4 10             	add    $0x10,%esp
  return freep;
 a69:	a1 88 0e 00 00       	mov    0xe88,%eax
}
 a6e:	c9                   	leave  
 a6f:	c3                   	ret    

00000a70 <malloc>:

void*
malloc(uint nbytes)
{
 a70:	f3 0f 1e fb          	endbr32 
 a74:	55                   	push   %ebp
 a75:	89 e5                	mov    %esp,%ebp
 a77:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a7a:	8b 45 08             	mov    0x8(%ebp),%eax
 a7d:	83 c0 07             	add    $0x7,%eax
 a80:	c1 e8 03             	shr    $0x3,%eax
 a83:	83 c0 01             	add    $0x1,%eax
 a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a89:	a1 88 0e 00 00       	mov    0xe88,%eax
 a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a95:	75 23                	jne    aba <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 a97:	c7 45 f0 80 0e 00 00 	movl   $0xe80,-0x10(%ebp)
 a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa1:	a3 88 0e 00 00       	mov    %eax,0xe88
 aa6:	a1 88 0e 00 00       	mov    0xe88,%eax
 aab:	a3 80 0e 00 00       	mov    %eax,0xe80
    base.s.size = 0;
 ab0:	c7 05 84 0e 00 00 00 	movl   $0x0,0xe84
 ab7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abd:	8b 00                	mov    (%eax),%eax
 abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	8b 40 04             	mov    0x4(%eax),%eax
 ac8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 acb:	77 4d                	ja     b1a <malloc+0xaa>
      if(p->s.size == nunits)
 acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad0:	8b 40 04             	mov    0x4(%eax),%eax
 ad3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ad6:	75 0c                	jne    ae4 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	8b 10                	mov    (%eax),%edx
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	89 10                	mov    %edx,(%eax)
 ae2:	eb 26                	jmp    b0a <malloc+0x9a>
      else {
        p->s.size -= nunits;
 ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae7:	8b 40 04             	mov    0x4(%eax),%eax
 aea:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aed:	89 c2                	mov    %eax,%edx
 aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	8b 40 04             	mov    0x4(%eax),%eax
 afb:	c1 e0 03             	shl    $0x3,%eax
 afe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b07:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0d:	a3 88 0e 00 00       	mov    %eax,0xe88
      return (void*)(p + 1);
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	83 c0 08             	add    $0x8,%eax
 b18:	eb 3b                	jmp    b55 <malloc+0xe5>
    }
    if(p == freep)
 b1a:	a1 88 0e 00 00       	mov    0xe88,%eax
 b1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b22:	75 1e                	jne    b42 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 b24:	83 ec 0c             	sub    $0xc,%esp
 b27:	ff 75 ec             	pushl  -0x14(%ebp)
 b2a:	e8 dd fe ff ff       	call   a0c <morecore>
 b2f:	83 c4 10             	add    $0x10,%esp
 b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b39:	75 07                	jne    b42 <malloc+0xd2>
        return 0;
 b3b:	b8 00 00 00 00       	mov    $0x0,%eax
 b40:	eb 13                	jmp    b55 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4b:	8b 00                	mov    (%eax),%eax
 b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b50:	e9 6d ff ff ff       	jmp    ac2 <malloc+0x52>
  }
}
 b55:	c9                   	leave  
 b56:	c3                   	ret    
