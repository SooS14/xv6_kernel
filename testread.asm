
_testread:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <hex2off>:
#include "fcntl.h"
#include "user.h"

uint
hex2off(char *h)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
  uint off;

  off=0;
   a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(;*h != '\0'; h++)
  11:	e9 9a 00 00 00       	jmp    b0 <hex2off+0xb0>
  {
    int d;

    if (*h >= '0' && *h <= '9')
  16:	8b 45 08             	mov    0x8(%ebp),%eax
  19:	0f b6 00             	movzbl (%eax),%eax
  1c:	3c 2f                	cmp    $0x2f,%al
  1e:	7e 1b                	jle    3b <hex2off+0x3b>
  20:	8b 45 08             	mov    0x8(%ebp),%eax
  23:	0f b6 00             	movzbl (%eax),%eax
  26:	3c 39                	cmp    $0x39,%al
  28:	7f 11                	jg     3b <hex2off+0x3b>
      d = *h - '0';
  2a:	8b 45 08             	mov    0x8(%ebp),%eax
  2d:	0f b6 00             	movzbl (%eax),%eax
  30:	0f be c0             	movsbl %al,%eax
  33:	83 e8 30             	sub    $0x30,%eax
  36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  39:	eb 61                	jmp    9c <hex2off+0x9c>
    else if (*h >= 'a' && *h <= 'f')
  3b:	8b 45 08             	mov    0x8(%ebp),%eax
  3e:	0f b6 00             	movzbl (%eax),%eax
  41:	3c 60                	cmp    $0x60,%al
  43:	7e 1b                	jle    60 <hex2off+0x60>
  45:	8b 45 08             	mov    0x8(%ebp),%eax
  48:	0f b6 00             	movzbl (%eax),%eax
  4b:	3c 66                	cmp    $0x66,%al
  4d:	7f 11                	jg     60 <hex2off+0x60>
      d = *h - 'a' + 10;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	0f b6 00             	movzbl (%eax),%eax
  55:	0f be c0             	movsbl %al,%eax
  58:	83 e8 57             	sub    $0x57,%eax
  5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  5e:	eb 3c                	jmp    9c <hex2off+0x9c>
    else if (*h >= 'A' && *h <= 'F')
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	0f b6 00             	movzbl (%eax),%eax
  66:	3c 40                	cmp    $0x40,%al
  68:	7e 1b                	jle    85 <hex2off+0x85>
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	0f b6 00             	movzbl (%eax),%eax
  70:	3c 46                	cmp    $0x46,%al
  72:	7f 11                	jg     85 <hex2off+0x85>
      d = *h - 'A' + 10;
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	0f b6 00             	movzbl (%eax),%eax
  7a:	0f be c0             	movsbl %al,%eax
  7d:	83 e8 37             	sub    $0x37,%eax
  80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  83:	eb 17                	jmp    9c <hex2off+0x9c>
    else
    {
      printf(2, "illegal hex digit\n") ;
  85:	83 ec 08             	sub    $0x8,%esp
  88:	68 df 0a 00 00       	push   $0xadf
  8d:	6a 02                	push   $0x2
  8f:	e8 84 06 00 00       	call   718 <printf>
  94:	83 c4 10             	add    $0x10,%esp
      exit () ;
  97:	e8 f8 04 00 00       	call   594 <exit>
    }
    off = (off << 4) + d;
  9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9f:	c1 e0 04             	shl    $0x4,%eax
  a2:	89 c2                	mov    %eax,%edx
  a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a7:	01 d0                	add    %edx,%eax
  a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;*h != '\0'; h++)
  ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	84 c0                	test   %al,%al
  b8:	0f 85 58 ff ff ff    	jne    16 <hex2off+0x16>
  }
  return off;
  be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  c1:	c9                   	leave  
  c2:	c3                   	ret    

000000c3 <main>:

int
main(int argc, char *argv[])
{
  c3:	f3 0f 1e fb          	endbr32 
  c7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  cb:	83 e4 f0             	and    $0xfffffff0,%esp
  ce:	ff 71 fc             	pushl  -0x4(%ecx)
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	53                   	push   %ebx
  d5:	51                   	push   %ecx
  d6:	83 c4 80             	add    $0xffffff80,%esp
  d9:	89 cb                	mov    %ecx,%ebx
  uint off;
  int n;
  int i, nr, fd;
  uchar buf [100];

  if(argc != 4){
  db:	83 3b 04             	cmpl   $0x4,(%ebx)
  de:	74 17                	je     f7 <main+0x34>
    printf(2, "Usage: testread dev off n\n");
  e0:	83 ec 08             	sub    $0x8,%esp
  e3:	68 f2 0a 00 00       	push   $0xaf2
  e8:	6a 02                	push   $0x2
  ea:	e8 29 06 00 00       	call   718 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    exit();
  f2:	e8 9d 04 00 00       	call   594 <exit>
  }

  off = hex2off (argv [2]);
  f7:	8b 43 04             	mov    0x4(%ebx),%eax
  fa:	83 c0 08             	add    $0x8,%eax
  fd:	8b 00                	mov    (%eax),%eax
  ff:	83 ec 0c             	sub    $0xc,%esp
 102:	50                   	push   %eax
 103:	e8 f8 fe ff ff       	call   0 <hex2off>
 108:	83 c4 10             	add    $0x10,%esp
 10b:	89 45 ec             	mov    %eax,-0x14(%ebp)

  n = atoi (argv [3]);
 10e:	8b 43 04             	mov    0x4(%ebx),%eax
 111:	83 c0 0c             	add    $0xc,%eax
 114:	8b 00                	mov    (%eax),%eax
 116:	83 ec 0c             	sub    $0xc,%esp
 119:	50                   	push   %eax
 11a:	e8 8d 03 00 00       	call   4ac <atoi>
 11f:	83 c4 10             	add    $0x10,%esp
 122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (n < 0) n = 0;
 125:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 129:	79 07                	jns    132 <main+0x6f>
 12b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (n > sizeof buf) n = sizeof buf;
 132:	8b 45 f4             	mov    -0xc(%ebp),%eax
 135:	83 f8 64             	cmp    $0x64,%eax
 138:	76 07                	jbe    141 <main+0x7e>
 13a:	c7 45 f4 64 00 00 00 	movl   $0x64,-0xc(%ebp)

  printf(1, "off=%x, n=%d\n", off, n);
 141:	ff 75 f4             	pushl  -0xc(%ebp)
 144:	ff 75 ec             	pushl  -0x14(%ebp)
 147:	68 0d 0b 00 00       	push   $0xb0d
 14c:	6a 01                	push   $0x1
 14e:	e8 c5 05 00 00       	call   718 <printf>
 153:	83 c4 10             	add    $0x10,%esp

  if ((fd = open (argv[1], O_RDONLY)) == -1) {
 156:	8b 43 04             	mov    0x4(%ebx),%eax
 159:	83 c0 04             	add    $0x4,%eax
 15c:	8b 00                	mov    (%eax),%eax
 15e:	83 ec 08             	sub    $0x8,%esp
 161:	6a 00                	push   $0x0
 163:	50                   	push   %eax
 164:	e8 6b 04 00 00       	call   5d4 <open>
 169:	83 c4 10             	add    $0x10,%esp
 16c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 16f:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
 173:	75 20                	jne    195 <main+0xd2>
    printf(2, "cannot open %d\n", argv[1]);
 175:	8b 43 04             	mov    0x4(%ebx),%eax
 178:	83 c0 04             	add    $0x4,%eax
 17b:	8b 00                	mov    (%eax),%eax
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	50                   	push   %eax
 181:	68 1b 0b 00 00       	push   $0xb1b
 186:	6a 02                	push   $0x2
 188:	e8 8b 05 00 00       	call   718 <printf>
 18d:	83 c4 10             	add    $0x10,%esp
    exit();
 190:	e8 ff 03 00 00       	call   594 <exit>
  }
  if (lseek(fd, off, SEEK_SET) == -1) {
 195:	8b 45 ec             	mov    -0x14(%ebp),%eax
 198:	83 ec 04             	sub    $0x4,%esp
 19b:	6a 00                	push   $0x0
 19d:	50                   	push   %eax
 19e:	ff 75 e8             	pushl  -0x18(%ebp)
 1a1:	e8 8e 04 00 00       	call   634 <lseek>
 1a6:	83 c4 10             	add    $0x10,%esp
 1a9:	83 f8 ff             	cmp    $0xffffffff,%eax
 1ac:	75 1a                	jne    1c8 <main+0x105>
    printf(2, "cannot lseek to %d\n", off);
 1ae:	83 ec 04             	sub    $0x4,%esp
 1b1:	ff 75 ec             	pushl  -0x14(%ebp)
 1b4:	68 2b 0b 00 00       	push   $0xb2b
 1b9:	6a 02                	push   $0x2
 1bb:	e8 58 05 00 00       	call   718 <printf>
 1c0:	83 c4 10             	add    $0x10,%esp
    exit();
 1c3:	e8 cc 03 00 00       	call   594 <exit>
  }
  nr = read(fd, buf, n);
 1c8:	83 ec 04             	sub    $0x4,%esp
 1cb:	ff 75 f4             	pushl  -0xc(%ebp)
 1ce:	8d 45 80             	lea    -0x80(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 e8             	pushl  -0x18(%ebp)
 1d5:	e8 d2 03 00 00       	call   5ac <read>
 1da:	83 c4 10             	add    $0x10,%esp
 1dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  printf (1, "read %d bytes\n", nr) ;
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	ff 75 e4             	pushl  -0x1c(%ebp)
 1e6:	68 3f 0b 00 00       	push   $0xb3f
 1eb:	6a 01                	push   $0x1
 1ed:	e8 26 05 00 00       	call   718 <printf>
 1f2:	83 c4 10             	add    $0x10,%esp
  if (nr == -1) {
 1f5:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
 1f9:	75 1a                	jne    215 <main+0x152>
    printf(2, "cannot read %d bytes", n);
 1fb:	83 ec 04             	sub    $0x4,%esp
 1fe:	ff 75 f4             	pushl  -0xc(%ebp)
 201:	68 4e 0b 00 00       	push   $0xb4e
 206:	6a 02                	push   $0x2
 208:	e8 0b 05 00 00       	call   718 <printf>
 20d:	83 c4 10             	add    $0x10,%esp
    exit();
 210:	e8 7f 03 00 00       	call   594 <exit>
  }
  if (close(fd) == -1) {
 215:	83 ec 0c             	sub    $0xc,%esp
 218:	ff 75 e8             	pushl  -0x18(%ebp)
 21b:	e8 9c 03 00 00       	call   5bc <close>
 220:	83 c4 10             	add    $0x10,%esp
 223:	83 f8 ff             	cmp    $0xffffffff,%eax
 226:	75 20                	jne    248 <main+0x185>
    printf(2, "cannot close %s\n", argv[1]);
 228:	8b 43 04             	mov    0x4(%ebx),%eax
 22b:	83 c0 04             	add    $0x4,%eax
 22e:	8b 00                	mov    (%eax),%eax
 230:	83 ec 04             	sub    $0x4,%esp
 233:	50                   	push   %eax
 234:	68 63 0b 00 00       	push   $0xb63
 239:	6a 02                	push   $0x2
 23b:	e8 d8 04 00 00       	call   718 <printf>
 240:	83 c4 10             	add    $0x10,%esp
    exit();
 243:	e8 4c 03 00 00       	call   594 <exit>
  }

  for (i = 0 ; i < nr ; i++)
 248:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 24f:	eb 5b                	jmp    2ac <main+0x1e9>
  {
    if (i > 0 && i % 16 == 0)
 251:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 255:	7e 1c                	jle    273 <main+0x1b0>
 257:	8b 45 f0             	mov    -0x10(%ebp),%eax
 25a:	83 e0 0f             	and    $0xf,%eax
 25d:	85 c0                	test   %eax,%eax
 25f:	75 12                	jne    273 <main+0x1b0>
	printf (1, "\n") ;
 261:	83 ec 08             	sub    $0x8,%esp
 264:	68 74 0b 00 00       	push   $0xb74
 269:	6a 01                	push   $0x1
 26b:	e8 a8 04 00 00       	call   718 <printf>
 270:	83 c4 10             	add    $0x10,%esp
    printf (1, " %x%x", buf[i] >> 4, buf[i] & 0xf) ;
 273:	8d 55 80             	lea    -0x80(%ebp),%edx
 276:	8b 45 f0             	mov    -0x10(%ebp),%eax
 279:	01 d0                	add    %edx,%eax
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	0f b6 c0             	movzbl %al,%eax
 281:	83 e0 0f             	and    $0xf,%eax
 284:	89 c2                	mov    %eax,%edx
 286:	8d 4d 80             	lea    -0x80(%ebp),%ecx
 289:	8b 45 f0             	mov    -0x10(%ebp),%eax
 28c:	01 c8                	add    %ecx,%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	c0 e8 04             	shr    $0x4,%al
 294:	0f b6 c0             	movzbl %al,%eax
 297:	52                   	push   %edx
 298:	50                   	push   %eax
 299:	68 76 0b 00 00       	push   $0xb76
 29e:	6a 01                	push   $0x1
 2a0:	e8 73 04 00 00       	call   718 <printf>
 2a5:	83 c4 10             	add    $0x10,%esp
  for (i = 0 ; i < nr ; i++)
 2a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 2ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2af:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 2b2:	7c 9d                	jl     251 <main+0x18e>
  }
  printf (1,"\n") ;
 2b4:	83 ec 08             	sub    $0x8,%esp
 2b7:	68 74 0b 00 00       	push   $0xb74
 2bc:	6a 01                	push   $0x1
 2be:	e8 55 04 00 00       	call   718 <printf>
 2c3:	83 c4 10             	add    $0x10,%esp

  exit();
 2c6:	e8 c9 02 00 00       	call   594 <exit>

000002cb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	57                   	push   %edi
 2cf:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2d3:	8b 55 10             	mov    0x10(%ebp),%edx
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	89 cb                	mov    %ecx,%ebx
 2db:	89 df                	mov    %ebx,%edi
 2dd:	89 d1                	mov    %edx,%ecx
 2df:	fc                   	cld    
 2e0:	f3 aa                	rep stos %al,%es:(%edi)
 2e2:	89 ca                	mov    %ecx,%edx
 2e4:	89 fb                	mov    %edi,%ebx
 2e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2e9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2ec:	90                   	nop
 2ed:	5b                   	pop    %ebx
 2ee:	5f                   	pop    %edi
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    

000002f1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f1:	f3 0f 1e fb          	endbr32 
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 301:	90                   	nop
 302:	8b 55 0c             	mov    0xc(%ebp),%edx
 305:	8d 42 01             	lea    0x1(%edx),%eax
 308:	89 45 0c             	mov    %eax,0xc(%ebp)
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	8d 48 01             	lea    0x1(%eax),%ecx
 311:	89 4d 08             	mov    %ecx,0x8(%ebp)
 314:	0f b6 12             	movzbl (%edx),%edx
 317:	88 10                	mov    %dl,(%eax)
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	84 c0                	test   %al,%al
 31e:	75 e2                	jne    302 <strcpy+0x11>
    ;
  return os;
 320:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 325:	f3 0f 1e fb          	endbr32 
 329:	55                   	push   %ebp
 32a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 32c:	eb 08                	jmp    336 <strcmp+0x11>
    p++, q++;
 32e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 332:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	84 c0                	test   %al,%al
 33e:	74 10                	je     350 <strcmp+0x2b>
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	0f b6 10             	movzbl (%eax),%edx
 346:	8b 45 0c             	mov    0xc(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	38 c2                	cmp    %al,%dl
 34e:	74 de                	je     32e <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	0f b6 d0             	movzbl %al,%edx
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	0f b6 c0             	movzbl %al,%eax
 362:	29 c2                	sub    %eax,%edx
 364:	89 d0                	mov    %edx,%eax
}
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    

00000368 <strlen>:

uint
strlen(const char *s)
{
 368:	f3 0f 1e fb          	endbr32 
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 372:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 379:	eb 04                	jmp    37f <strlen+0x17>
 37b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 37f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	01 d0                	add    %edx,%eax
 387:	0f b6 00             	movzbl (%eax),%eax
 38a:	84 c0                	test   %al,%al
 38c:	75 ed                	jne    37b <strlen+0x13>
    ;
  return n;
 38e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 391:	c9                   	leave  
 392:	c3                   	ret    

00000393 <memset>:

void*
memset(void *dst, int c, uint n)
{
 393:	f3 0f 1e fb          	endbr32 
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 39a:	8b 45 10             	mov    0x10(%ebp),%eax
 39d:	50                   	push   %eax
 39e:	ff 75 0c             	pushl  0xc(%ebp)
 3a1:	ff 75 08             	pushl  0x8(%ebp)
 3a4:	e8 22 ff ff ff       	call   2cb <stosb>
 3a9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3af:	c9                   	leave  
 3b0:	c3                   	ret    

000003b1 <strchr>:

char*
strchr(const char *s, char c)
{
 3b1:	f3 0f 1e fb          	endbr32 
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 04             	sub    $0x4,%esp
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3c1:	eb 14                	jmp    3d7 <strchr+0x26>
    if(*s == c)
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 3cc:	75 05                	jne    3d3 <strchr+0x22>
      return (char*)s;
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	eb 13                	jmp    3e6 <strchr+0x35>
  for(; *s; s++)
 3d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	84 c0                	test   %al,%al
 3df:	75 e2                	jne    3c3 <strchr+0x12>
  return 0;
 3e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    

000003e8 <gets>:

char*
gets(char *buf, int max)
{
 3e8:	f3 0f 1e fb          	endbr32 
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3f9:	eb 42                	jmp    43d <gets+0x55>
    cc = read(0, &c, 1);
 3fb:	83 ec 04             	sub    $0x4,%esp
 3fe:	6a 01                	push   $0x1
 400:	8d 45 ef             	lea    -0x11(%ebp),%eax
 403:	50                   	push   %eax
 404:	6a 00                	push   $0x0
 406:	e8 a1 01 00 00       	call   5ac <read>
 40b:	83 c4 10             	add    $0x10,%esp
 40e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 411:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 415:	7e 33                	jle    44a <gets+0x62>
      break;
    buf[i++] = c;
 417:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41a:	8d 50 01             	lea    0x1(%eax),%edx
 41d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 420:	89 c2                	mov    %eax,%edx
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	01 c2                	add    %eax,%edx
 427:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 42b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 42d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 431:	3c 0a                	cmp    $0xa,%al
 433:	74 16                	je     44b <gets+0x63>
 435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 439:	3c 0d                	cmp    $0xd,%al
 43b:	74 0e                	je     44b <gets+0x63>
  for(i=0; i+1 < max; ){
 43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 440:	83 c0 01             	add    $0x1,%eax
 443:	39 45 0c             	cmp    %eax,0xc(%ebp)
 446:	7f b3                	jg     3fb <gets+0x13>
 448:	eb 01                	jmp    44b <gets+0x63>
      break;
 44a:	90                   	nop
      break;
  }
  buf[i] = '\0';
 44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 456:	8b 45 08             	mov    0x8(%ebp),%eax
}
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <stat>:

int
stat(const char *n, struct stat *st)
{
 45b:	f3 0f 1e fb          	endbr32 
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 465:	83 ec 08             	sub    $0x8,%esp
 468:	6a 00                	push   $0x0
 46a:	ff 75 08             	pushl  0x8(%ebp)
 46d:	e8 62 01 00 00       	call   5d4 <open>
 472:	83 c4 10             	add    $0x10,%esp
 475:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47c:	79 07                	jns    485 <stat+0x2a>
    return -1;
 47e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 483:	eb 25                	jmp    4aa <stat+0x4f>
  r = fstat(fd, st);
 485:	83 ec 08             	sub    $0x8,%esp
 488:	ff 75 0c             	pushl  0xc(%ebp)
 48b:	ff 75 f4             	pushl  -0xc(%ebp)
 48e:	e8 59 01 00 00       	call   5ec <fstat>
 493:	83 c4 10             	add    $0x10,%esp
 496:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 499:	83 ec 0c             	sub    $0xc,%esp
 49c:	ff 75 f4             	pushl  -0xc(%ebp)
 49f:	e8 18 01 00 00       	call   5bc <close>
 4a4:	83 c4 10             	add    $0x10,%esp
  return r;
 4a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4aa:	c9                   	leave  
 4ab:	c3                   	ret    

000004ac <atoi>:



int
atoi(const char *s)
{
 4ac:	f3 0f 1e fb          	endbr32 
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	0f b6 00             	movzbl (%eax),%eax
 4c3:	3c 2d                	cmp    $0x2d,%al
 4c5:	75 6b                	jne    532 <atoi+0x86>
  {
    s++;
 4c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 4cb:	eb 25                	jmp    4f2 <atoi+0x46>
        n = n*10 + *s++ - '0';
 4cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d0:	89 d0                	mov    %edx,%eax
 4d2:	c1 e0 02             	shl    $0x2,%eax
 4d5:	01 d0                	add    %edx,%eax
 4d7:	01 c0                	add    %eax,%eax
 4d9:	89 c1                	mov    %eax,%ecx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	8d 50 01             	lea    0x1(%eax),%edx
 4e1:	89 55 08             	mov    %edx,0x8(%ebp)
 4e4:	0f b6 00             	movzbl (%eax),%eax
 4e7:	0f be c0             	movsbl %al,%eax
 4ea:	01 c8                	add    %ecx,%eax
 4ec:	83 e8 30             	sub    $0x30,%eax
 4ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	0f b6 00             	movzbl (%eax),%eax
 4f8:	3c 2f                	cmp    $0x2f,%al
 4fa:	7e 0a                	jle    506 <atoi+0x5a>
 4fc:	8b 45 08             	mov    0x8(%ebp),%eax
 4ff:	0f b6 00             	movzbl (%eax),%eax
 502:	3c 39                	cmp    $0x39,%al
 504:	7e c7                	jle    4cd <atoi+0x21>

    return -n;
 506:	8b 45 fc             	mov    -0x4(%ebp),%eax
 509:	f7 d8                	neg    %eax
 50b:	eb 3c                	jmp    549 <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 50d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 510:	89 d0                	mov    %edx,%eax
 512:	c1 e0 02             	shl    $0x2,%eax
 515:	01 d0                	add    %edx,%eax
 517:	01 c0                	add    %eax,%eax
 519:	89 c1                	mov    %eax,%ecx
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	8d 50 01             	lea    0x1(%eax),%edx
 521:	89 55 08             	mov    %edx,0x8(%ebp)
 524:	0f b6 00             	movzbl (%eax),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	01 c8                	add    %ecx,%eax
 52c:	83 e8 30             	sub    $0x30,%eax
 52f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	3c 2f                	cmp    $0x2f,%al
 53a:	7e 0a                	jle    546 <atoi+0x9a>
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	0f b6 00             	movzbl (%eax),%eax
 542:	3c 39                	cmp    $0x39,%al
 544:	7e c7                	jle    50d <atoi+0x61>

    return n;
 546:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 549:	c9                   	leave  
 54a:	c3                   	ret    

0000054b <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 54b:	f3 0f 1e fb          	endbr32 
 54f:	55                   	push   %ebp
 550:	89 e5                	mov    %esp,%ebp
 552:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 55b:	8b 45 0c             	mov    0xc(%ebp),%eax
 55e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 561:	eb 17                	jmp    57a <memmove+0x2f>
    *dst++ = *src++;
 563:	8b 55 f8             	mov    -0x8(%ebp),%edx
 566:	8d 42 01             	lea    0x1(%edx),%eax
 569:	89 45 f8             	mov    %eax,-0x8(%ebp)
 56c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56f:	8d 48 01             	lea    0x1(%eax),%ecx
 572:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 575:	0f b6 12             	movzbl (%edx),%edx
 578:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 57a:	8b 45 10             	mov    0x10(%ebp),%eax
 57d:	8d 50 ff             	lea    -0x1(%eax),%edx
 580:	89 55 10             	mov    %edx,0x10(%ebp)
 583:	85 c0                	test   %eax,%eax
 585:	7f dc                	jg     563 <memmove+0x18>
  return vdst;
 587:	8b 45 08             	mov    0x8(%ebp),%eax
}
 58a:	c9                   	leave  
 58b:	c3                   	ret    

0000058c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 58c:	b8 01 00 00 00       	mov    $0x1,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <exit>:
SYSCALL(exit)
 594:	b8 02 00 00 00       	mov    $0x2,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <wait>:
SYSCALL(wait)
 59c:	b8 03 00 00 00       	mov    $0x3,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <pipe>:
SYSCALL(pipe)
 5a4:	b8 04 00 00 00       	mov    $0x4,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <read>:
SYSCALL(read)
 5ac:	b8 05 00 00 00       	mov    $0x5,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <write>:
SYSCALL(write)
 5b4:	b8 10 00 00 00       	mov    $0x10,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <close>:
SYSCALL(close)
 5bc:	b8 15 00 00 00       	mov    $0x15,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <kill>:
SYSCALL(kill)
 5c4:	b8 06 00 00 00       	mov    $0x6,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <exec>:
SYSCALL(exec)
 5cc:	b8 07 00 00 00       	mov    $0x7,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <open>:
SYSCALL(open)
 5d4:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <mknod>:
SYSCALL(mknod)
 5dc:	b8 11 00 00 00       	mov    $0x11,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <unlink>:
SYSCALL(unlink)
 5e4:	b8 12 00 00 00       	mov    $0x12,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <fstat>:
SYSCALL(fstat)
 5ec:	b8 08 00 00 00       	mov    $0x8,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <link>:
SYSCALL(link)
 5f4:	b8 13 00 00 00       	mov    $0x13,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <mkdir>:
SYSCALL(mkdir)
 5fc:	b8 14 00 00 00       	mov    $0x14,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <chdir>:
SYSCALL(chdir)
 604:	b8 09 00 00 00       	mov    $0x9,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <dup>:
SYSCALL(dup)
 60c:	b8 0a 00 00 00       	mov    $0xa,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <getpid>:
SYSCALL(getpid)
 614:	b8 0b 00 00 00       	mov    $0xb,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <sbrk>:
SYSCALL(sbrk)
 61c:	b8 0c 00 00 00       	mov    $0xc,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <sleep>:
SYSCALL(sleep)
 624:	b8 0d 00 00 00       	mov    $0xd,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <uptime>:
SYSCALL(uptime)
 62c:	b8 0e 00 00 00       	mov    $0xe,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <lseek>:
SYSCALL(lseek)
 634:	b8 16 00 00 00       	mov    $0x16,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 63c:	f3 0f 1e fb          	endbr32 
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	83 ec 18             	sub    $0x18,%esp
 646:	8b 45 0c             	mov    0xc(%ebp),%eax
 649:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64c:	83 ec 04             	sub    $0x4,%esp
 64f:	6a 01                	push   $0x1
 651:	8d 45 f4             	lea    -0xc(%ebp),%eax
 654:	50                   	push   %eax
 655:	ff 75 08             	pushl  0x8(%ebp)
 658:	e8 57 ff ff ff       	call   5b4 <write>
 65d:	83 c4 10             	add    $0x10,%esp
}
 660:	90                   	nop
 661:	c9                   	leave  
 662:	c3                   	ret    

00000663 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 663:	f3 0f 1e fb          	endbr32 
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 66d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 674:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 678:	74 17                	je     691 <printint+0x2e>
 67a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 67e:	79 11                	jns    691 <printint+0x2e>
    neg = 1;
 680:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 687:	8b 45 0c             	mov    0xc(%ebp),%eax
 68a:	f7 d8                	neg    %eax
 68c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68f:	eb 06                	jmp    697 <printint+0x34>
  } else {
    x = xx;
 691:	8b 45 0c             	mov    0xc(%ebp),%eax
 694:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 69e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a4:	ba 00 00 00 00       	mov    $0x0,%edx
 6a9:	f7 f1                	div    %ecx
 6ab:	89 d1                	mov    %edx,%ecx
 6ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b0:	8d 50 01             	lea    0x1(%eax),%edx
 6b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6b6:	0f b6 91 ec 0d 00 00 	movzbl 0xdec(%ecx),%edx
 6bd:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c7:	ba 00 00 00 00       	mov    $0x0,%edx
 6cc:	f7 f1                	div    %ecx
 6ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d5:	75 c7                	jne    69e <printint+0x3b>
  if(neg)
 6d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6db:	74 2d                	je     70a <printint+0xa7>
    buf[i++] = '-';
 6dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e0:	8d 50 01             	lea    0x1(%eax),%edx
 6e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6eb:	eb 1d                	jmp    70a <printint+0xa7>
    putc(fd, buf[i]);
 6ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f3:	01 d0                	add    %edx,%eax
 6f5:	0f b6 00             	movzbl (%eax),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	83 ec 08             	sub    $0x8,%esp
 6fe:	50                   	push   %eax
 6ff:	ff 75 08             	pushl  0x8(%ebp)
 702:	e8 35 ff ff ff       	call   63c <putc>
 707:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 70a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 70e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 712:	79 d9                	jns    6ed <printint+0x8a>
}
 714:	90                   	nop
 715:	90                   	nop
 716:	c9                   	leave  
 717:	c3                   	ret    

00000718 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 718:	f3 0f 1e fb          	endbr32 
 71c:	55                   	push   %ebp
 71d:	89 e5                	mov    %esp,%ebp
 71f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 722:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 729:	8d 45 0c             	lea    0xc(%ebp),%eax
 72c:	83 c0 04             	add    $0x4,%eax
 72f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 732:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 739:	e9 59 01 00 00       	jmp    897 <printf+0x17f>
    c = fmt[i] & 0xff;
 73e:	8b 55 0c             	mov    0xc(%ebp),%edx
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	01 d0                	add    %edx,%eax
 746:	0f b6 00             	movzbl (%eax),%eax
 749:	0f be c0             	movsbl %al,%eax
 74c:	25 ff 00 00 00       	and    $0xff,%eax
 751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 754:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 758:	75 2c                	jne    786 <printf+0x6e>
      if(c == '%'){
 75a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75e:	75 0c                	jne    76c <printf+0x54>
        state = '%';
 760:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 767:	e9 27 01 00 00       	jmp    893 <printf+0x17b>
      } else {
        putc(fd, c);
 76c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76f:	0f be c0             	movsbl %al,%eax
 772:	83 ec 08             	sub    $0x8,%esp
 775:	50                   	push   %eax
 776:	ff 75 08             	pushl  0x8(%ebp)
 779:	e8 be fe ff ff       	call   63c <putc>
 77e:	83 c4 10             	add    $0x10,%esp
 781:	e9 0d 01 00 00       	jmp    893 <printf+0x17b>
      }
    } else if(state == '%'){
 786:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 78a:	0f 85 03 01 00 00    	jne    893 <printf+0x17b>
      if(c == 'd'){
 790:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 794:	75 1e                	jne    7b4 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 796:	8b 45 e8             	mov    -0x18(%ebp),%eax
 799:	8b 00                	mov    (%eax),%eax
 79b:	6a 01                	push   $0x1
 79d:	6a 0a                	push   $0xa
 79f:	50                   	push   %eax
 7a0:	ff 75 08             	pushl  0x8(%ebp)
 7a3:	e8 bb fe ff ff       	call   663 <printint>
 7a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 7ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7af:	e9 d8 00 00 00       	jmp    88c <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 7b4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b8:	74 06                	je     7c0 <printf+0xa8>
 7ba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7be:	75 1e                	jne    7de <printf+0xc6>
        printint(fd, *ap, 16, 0);
 7c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	6a 00                	push   $0x0
 7c7:	6a 10                	push   $0x10
 7c9:	50                   	push   %eax
 7ca:	ff 75 08             	pushl  0x8(%ebp)
 7cd:	e8 91 fe ff ff       	call   663 <printint>
 7d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d9:	e9 ae 00 00 00       	jmp    88c <printf+0x174>
      } else if(c == 's'){
 7de:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7e2:	75 43                	jne    827 <printf+0x10f>
        s = (char*)*ap;
 7e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f4:	75 25                	jne    81b <printf+0x103>
          s = "(null)";
 7f6:	c7 45 f4 7c 0b 00 00 	movl   $0xb7c,-0xc(%ebp)
        while(*s != 0){
 7fd:	eb 1c                	jmp    81b <printf+0x103>
          putc(fd, *s);
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	0f b6 00             	movzbl (%eax),%eax
 805:	0f be c0             	movsbl %al,%eax
 808:	83 ec 08             	sub    $0x8,%esp
 80b:	50                   	push   %eax
 80c:	ff 75 08             	pushl  0x8(%ebp)
 80f:	e8 28 fe ff ff       	call   63c <putc>
 814:	83 c4 10             	add    $0x10,%esp
          s++;
 817:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	0f b6 00             	movzbl (%eax),%eax
 821:	84 c0                	test   %al,%al
 823:	75 da                	jne    7ff <printf+0xe7>
 825:	eb 65                	jmp    88c <printf+0x174>
        }
      } else if(c == 'c'){
 827:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 82b:	75 1d                	jne    84a <printf+0x132>
        putc(fd, *ap);
 82d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	0f be c0             	movsbl %al,%eax
 835:	83 ec 08             	sub    $0x8,%esp
 838:	50                   	push   %eax
 839:	ff 75 08             	pushl  0x8(%ebp)
 83c:	e8 fb fd ff ff       	call   63c <putc>
 841:	83 c4 10             	add    $0x10,%esp
        ap++;
 844:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 848:	eb 42                	jmp    88c <printf+0x174>
      } else if(c == '%'){
 84a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 84e:	75 17                	jne    867 <printf+0x14f>
        putc(fd, c);
 850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 853:	0f be c0             	movsbl %al,%eax
 856:	83 ec 08             	sub    $0x8,%esp
 859:	50                   	push   %eax
 85a:	ff 75 08             	pushl  0x8(%ebp)
 85d:	e8 da fd ff ff       	call   63c <putc>
 862:	83 c4 10             	add    $0x10,%esp
 865:	eb 25                	jmp    88c <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 867:	83 ec 08             	sub    $0x8,%esp
 86a:	6a 25                	push   $0x25
 86c:	ff 75 08             	pushl  0x8(%ebp)
 86f:	e8 c8 fd ff ff       	call   63c <putc>
 874:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 87a:	0f be c0             	movsbl %al,%eax
 87d:	83 ec 08             	sub    $0x8,%esp
 880:	50                   	push   %eax
 881:	ff 75 08             	pushl  0x8(%ebp)
 884:	e8 b3 fd ff ff       	call   63c <putc>
 889:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 88c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 893:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 897:	8b 55 0c             	mov    0xc(%ebp),%edx
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	01 d0                	add    %edx,%eax
 89f:	0f b6 00             	movzbl (%eax),%eax
 8a2:	84 c0                	test   %al,%al
 8a4:	0f 85 94 fe ff ff    	jne    73e <printf+0x26>
    }
  }
}
 8aa:	90                   	nop
 8ab:	90                   	nop
 8ac:	c9                   	leave  
 8ad:	c3                   	ret    

000008ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ae:	f3 0f 1e fb          	endbr32 
 8b2:	55                   	push   %ebp
 8b3:	89 e5                	mov    %esp,%ebp
 8b5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b8:	8b 45 08             	mov    0x8(%ebp),%eax
 8bb:	83 e8 08             	sub    $0x8,%eax
 8be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	a1 08 0e 00 00       	mov    0xe08,%eax
 8c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c9:	eb 24                	jmp    8ef <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	8b 00                	mov    (%eax),%eax
 8d0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8d3:	72 12                	jb     8e7 <free+0x39>
 8d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8db:	77 24                	ja     901 <free+0x53>
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	8b 00                	mov    (%eax),%eax
 8e2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8e5:	72 1a                	jb     901 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ea:	8b 00                	mov    (%eax),%eax
 8ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f5:	76 d4                	jbe    8cb <free+0x1d>
 8f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fa:	8b 00                	mov    (%eax),%eax
 8fc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8ff:	73 ca                	jae    8cb <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 901:	8b 45 f8             	mov    -0x8(%ebp),%eax
 904:	8b 40 04             	mov    0x4(%eax),%eax
 907:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 90e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 911:	01 c2                	add    %eax,%edx
 913:	8b 45 fc             	mov    -0x4(%ebp),%eax
 916:	8b 00                	mov    (%eax),%eax
 918:	39 c2                	cmp    %eax,%edx
 91a:	75 24                	jne    940 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 91c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91f:	8b 50 04             	mov    0x4(%eax),%edx
 922:	8b 45 fc             	mov    -0x4(%ebp),%eax
 925:	8b 00                	mov    (%eax),%eax
 927:	8b 40 04             	mov    0x4(%eax),%eax
 92a:	01 c2                	add    %eax,%edx
 92c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	8b 00                	mov    (%eax),%eax
 937:	8b 10                	mov    (%eax),%edx
 939:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93c:	89 10                	mov    %edx,(%eax)
 93e:	eb 0a                	jmp    94a <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 10                	mov    (%eax),%edx
 945:	8b 45 f8             	mov    -0x8(%ebp),%eax
 948:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	8b 40 04             	mov    0x4(%eax),%eax
 950:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 957:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95a:	01 d0                	add    %edx,%eax
 95c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 95f:	75 20                	jne    981 <free+0xd3>
    p->s.size += bp->s.size;
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	8b 50 04             	mov    0x4(%eax),%edx
 967:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96a:	8b 40 04             	mov    0x4(%eax),%eax
 96d:	01 c2                	add    %eax,%edx
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 975:	8b 45 f8             	mov    -0x8(%ebp),%eax
 978:	8b 10                	mov    (%eax),%edx
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	89 10                	mov    %edx,(%eax)
 97f:	eb 08                	jmp    989 <free+0xdb>
  } else
    p->s.ptr = bp;
 981:	8b 45 fc             	mov    -0x4(%ebp),%eax
 984:	8b 55 f8             	mov    -0x8(%ebp),%edx
 987:	89 10                	mov    %edx,(%eax)
  freep = p;
 989:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98c:	a3 08 0e 00 00       	mov    %eax,0xe08
}
 991:	90                   	nop
 992:	c9                   	leave  
 993:	c3                   	ret    

00000994 <morecore>:

static Header*
morecore(uint nu)
{
 994:	f3 0f 1e fb          	endbr32 
 998:	55                   	push   %ebp
 999:	89 e5                	mov    %esp,%ebp
 99b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 99e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9a5:	77 07                	ja     9ae <morecore+0x1a>
    nu = 4096;
 9a7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9ae:	8b 45 08             	mov    0x8(%ebp),%eax
 9b1:	c1 e0 03             	shl    $0x3,%eax
 9b4:	83 ec 0c             	sub    $0xc,%esp
 9b7:	50                   	push   %eax
 9b8:	e8 5f fc ff ff       	call   61c <sbrk>
 9bd:	83 c4 10             	add    $0x10,%esp
 9c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9c3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9c7:	75 07                	jne    9d0 <morecore+0x3c>
    return 0;
 9c9:	b8 00 00 00 00       	mov    $0x0,%eax
 9ce:	eb 26                	jmp    9f6 <morecore+0x62>
  hp = (Header*)p;
 9d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d9:	8b 55 08             	mov    0x8(%ebp),%edx
 9dc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e2:	83 c0 08             	add    $0x8,%eax
 9e5:	83 ec 0c             	sub    $0xc,%esp
 9e8:	50                   	push   %eax
 9e9:	e8 c0 fe ff ff       	call   8ae <free>
 9ee:	83 c4 10             	add    $0x10,%esp
  return freep;
 9f1:	a1 08 0e 00 00       	mov    0xe08,%eax
}
 9f6:	c9                   	leave  
 9f7:	c3                   	ret    

000009f8 <malloc>:

void*
malloc(uint nbytes)
{
 9f8:	f3 0f 1e fb          	endbr32 
 9fc:	55                   	push   %ebp
 9fd:	89 e5                	mov    %esp,%ebp
 9ff:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a02:	8b 45 08             	mov    0x8(%ebp),%eax
 a05:	83 c0 07             	add    $0x7,%eax
 a08:	c1 e8 03             	shr    $0x3,%eax
 a0b:	83 c0 01             	add    $0x1,%eax
 a0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a11:	a1 08 0e 00 00       	mov    0xe08,%eax
 a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a1d:	75 23                	jne    a42 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 a1f:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
 a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a29:	a3 08 0e 00 00       	mov    %eax,0xe08
 a2e:	a1 08 0e 00 00       	mov    0xe08,%eax
 a33:	a3 00 0e 00 00       	mov    %eax,0xe00
    base.s.size = 0;
 a38:	c7 05 04 0e 00 00 00 	movl   $0x0,0xe04
 a3f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a45:	8b 00                	mov    (%eax),%eax
 a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 40 04             	mov    0x4(%eax),%eax
 a50:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a53:	77 4d                	ja     aa2 <malloc+0xaa>
      if(p->s.size == nunits)
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	8b 40 04             	mov    0x4(%eax),%eax
 a5b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a5e:	75 0c                	jne    a6c <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a63:	8b 10                	mov    (%eax),%edx
 a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a68:	89 10                	mov    %edx,(%eax)
 a6a:	eb 26                	jmp    a92 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6f:	8b 40 04             	mov    0x4(%eax),%eax
 a72:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a75:	89 c2                	mov    %eax,%edx
 a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a80:	8b 40 04             	mov    0x4(%eax),%eax
 a83:	c1 e0 03             	shl    $0x3,%eax
 a86:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a8f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a95:	a3 08 0e 00 00       	mov    %eax,0xe08
      return (void*)(p + 1);
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	83 c0 08             	add    $0x8,%eax
 aa0:	eb 3b                	jmp    add <malloc+0xe5>
    }
    if(p == freep)
 aa2:	a1 08 0e 00 00       	mov    0xe08,%eax
 aa7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aaa:	75 1e                	jne    aca <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 aac:	83 ec 0c             	sub    $0xc,%esp
 aaf:	ff 75 ec             	pushl  -0x14(%ebp)
 ab2:	e8 dd fe ff ff       	call   994 <morecore>
 ab7:	83 c4 10             	add    $0x10,%esp
 aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac1:	75 07                	jne    aca <malloc+0xd2>
        return 0;
 ac3:	b8 00 00 00 00       	mov    $0x0,%eax
 ac8:	eb 13                	jmp    add <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad3:	8b 00                	mov    (%eax),%eax
 ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ad8:	e9 6d ff ff ff       	jmp    a4a <malloc+0x52>
  }
}
 add:	c9                   	leave  
 ade:	c3                   	ret    
