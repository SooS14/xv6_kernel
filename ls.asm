
_ls:     format de fichier elf32-i386


Déassemblage de la section .text :

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   b:	83 ec 0c             	sub    $0xc,%esp
   e:	ff 75 08             	pushl  0x8(%ebp)
  11:	e8 d5 03 00 00       	call   3eb <strlen>
  16:	83 c4 10             	add    $0x10,%esp
  19:	8b 55 08             	mov    0x8(%ebp),%edx
  1c:	01 d0                	add    %edx,%eax
  1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  21:	eb 04                	jmp    27 <fmtname+0x27>
  23:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  2d:	72 0a                	jb     39 <fmtname+0x39>
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	0f b6 00             	movzbl (%eax),%eax
  35:	3c 2f                	cmp    $0x2f,%al
  37:	75 ea                	jne    23 <fmtname+0x23>
    ;
  p++;
  39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	ff 75 f4             	pushl  -0xc(%ebp)
  43:	e8 a3 03 00 00       	call   3eb <strlen>
  48:	83 c4 10             	add    $0x10,%esp
  4b:	83 f8 0d             	cmp    $0xd,%eax
  4e:	76 05                	jbe    55 <fmtname+0x55>
    return p;
  50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  53:	eb 60                	jmp    b5 <fmtname+0xb5>
  memmove(buf, p, strlen(p));
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	ff 75 f4             	pushl  -0xc(%ebp)
  5b:	e8 8b 03 00 00       	call   3eb <strlen>
  60:	83 c4 10             	add    $0x10,%esp
  63:	83 ec 04             	sub    $0x4,%esp
  66:	50                   	push   %eax
  67:	ff 75 f4             	pushl  -0xc(%ebp)
  6a:	68 64 0e 00 00       	push   $0xe64
  6f:	e8 5a 05 00 00       	call   5ce <memmove>
  74:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	ff 75 f4             	pushl  -0xc(%ebp)
  7d:	e8 69 03 00 00       	call   3eb <strlen>
  82:	83 c4 10             	add    $0x10,%esp
  85:	ba 0e 00 00 00       	mov    $0xe,%edx
  8a:	89 d3                	mov    %edx,%ebx
  8c:	29 c3                	sub    %eax,%ebx
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	ff 75 f4             	pushl  -0xc(%ebp)
  94:	e8 52 03 00 00       	call   3eb <strlen>
  99:	83 c4 10             	add    $0x10,%esp
  9c:	05 64 0e 00 00       	add    $0xe64,%eax
  a1:	83 ec 04             	sub    $0x4,%esp
  a4:	53                   	push   %ebx
  a5:	6a 20                	push   $0x20
  a7:	50                   	push   %eax
  a8:	e8 69 03 00 00       	call   416 <memset>
  ad:	83 c4 10             	add    $0x10,%esp
  return buf;
  b0:	b8 64 0e 00 00       	mov    $0xe64,%eax
}
  b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b8:	c9                   	leave  
  b9:	c3                   	ret    

000000ba <ls>:

void
ls(char *path)
{
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	57                   	push   %edi
  c2:	56                   	push   %esi
  c3:	53                   	push   %ebx
  c4:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  ca:	83 ec 08             	sub    $0x8,%esp
  cd:	6a 00                	push   $0x0
  cf:	ff 75 08             	pushl  0x8(%ebp)
  d2:	e8 80 05 00 00       	call   657 <open>
  d7:	83 c4 10             	add    $0x10,%esp
  da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  e1:	79 1a                	jns    fd <ls+0x43>
    printf(2, "ls: cannot open %s\n", path);
  e3:	83 ec 04             	sub    $0x4,%esp
  e6:	ff 75 08             	pushl  0x8(%ebp)
  e9:	68 62 0b 00 00       	push   $0xb62
  ee:	6a 02                	push   $0x2
  f0:	e8 a6 06 00 00       	call   79b <printf>
  f5:	83 c4 10             	add    $0x10,%esp
    return;
  f8:	e9 e1 01 00 00       	jmp    2de <ls+0x224>
  }

  if(fstat(fd, &st) < 0){
  fd:	83 ec 08             	sub    $0x8,%esp
 100:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 106:	50                   	push   %eax
 107:	ff 75 e4             	pushl  -0x1c(%ebp)
 10a:	e8 60 05 00 00       	call   66f <fstat>
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	79 28                	jns    13e <ls+0x84>
    printf(2, "ls: cannot stat %s\n", path);
 116:	83 ec 04             	sub    $0x4,%esp
 119:	ff 75 08             	pushl  0x8(%ebp)
 11c:	68 76 0b 00 00       	push   $0xb76
 121:	6a 02                	push   $0x2
 123:	e8 73 06 00 00       	call   79b <printf>
 128:	83 c4 10             	add    $0x10,%esp
    close(fd);
 12b:	83 ec 0c             	sub    $0xc,%esp
 12e:	ff 75 e4             	pushl  -0x1c(%ebp)
 131:	e8 09 05 00 00       	call   63f <close>
 136:	83 c4 10             	add    $0x10,%esp
    return;
 139:	e9 a0 01 00 00       	jmp    2de <ls+0x224>
  }

  switch(st.type){
 13e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 145:	98                   	cwtl   
 146:	83 f8 01             	cmp    $0x1,%eax
 149:	74 48                	je     193 <ls+0xd9>
 14b:	83 f8 02             	cmp    $0x2,%eax
 14e:	0f 85 7c 01 00 00    	jne    2d0 <ls+0x216>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 154:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 15a:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 160:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 167:	0f bf d8             	movswl %ax,%ebx
 16a:	83 ec 0c             	sub    $0xc,%esp
 16d:	ff 75 08             	pushl  0x8(%ebp)
 170:	e8 8b fe ff ff       	call   0 <fmtname>
 175:	83 c4 10             	add    $0x10,%esp
 178:	83 ec 08             	sub    $0x8,%esp
 17b:	57                   	push   %edi
 17c:	56                   	push   %esi
 17d:	53                   	push   %ebx
 17e:	50                   	push   %eax
 17f:	68 8a 0b 00 00       	push   $0xb8a
 184:	6a 01                	push   $0x1
 186:	e8 10 06 00 00       	call   79b <printf>
 18b:	83 c4 20             	add    $0x20,%esp
    break;
 18e:	e9 3d 01 00 00       	jmp    2d0 <ls+0x216>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 193:	83 ec 0c             	sub    $0xc,%esp
 196:	ff 75 08             	pushl  0x8(%ebp)
 199:	e8 4d 02 00 00       	call   3eb <strlen>
 19e:	83 c4 10             	add    $0x10,%esp
 1a1:	83 c0 10             	add    $0x10,%eax
 1a4:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a9:	76 17                	jbe    1c2 <ls+0x108>
      printf(1, "ls: path too long\n");
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	68 97 0b 00 00       	push   $0xb97
 1b3:	6a 01                	push   $0x1
 1b5:	e8 e1 05 00 00       	call   79b <printf>
 1ba:	83 c4 10             	add    $0x10,%esp
      break;
 1bd:	e9 0e 01 00 00       	jmp    2d0 <ls+0x216>
    }
    strcpy(buf, path);
 1c2:	83 ec 08             	sub    $0x8,%esp
 1c5:	ff 75 08             	pushl  0x8(%ebp)
 1c8:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1ce:	50                   	push   %eax
 1cf:	e8 a0 01 00 00       	call   374 <strcpy>
 1d4:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d7:	83 ec 0c             	sub    $0xc,%esp
 1da:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e0:	50                   	push   %eax
 1e1:	e8 05 02 00 00       	call   3eb <strlen>
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1ef:	01 d0                	add    %edx,%eax
 1f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f7:	8d 50 01             	lea    0x1(%eax),%edx
 1fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1fd:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	e9 aa 00 00 00       	jmp    2af <ls+0x1f5>
      if(de.inum == 0)
 205:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 20c:	66 85 c0             	test   %ax,%ax
 20f:	75 05                	jne    216 <ls+0x15c>
        continue;
 211:	e9 99 00 00 00       	jmp    2af <ls+0x1f5>
      memmove(p, de.name, DIRSIZ);
 216:	83 ec 04             	sub    $0x4,%esp
 219:	6a 0e                	push   $0xe
 21b:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 221:	83 c0 02             	add    $0x2,%eax
 224:	50                   	push   %eax
 225:	ff 75 e0             	pushl  -0x20(%ebp)
 228:	e8 a1 03 00 00       	call   5ce <memmove>
 22d:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 230:	8b 45 e0             	mov    -0x20(%ebp),%eax
 233:	83 c0 0e             	add    $0xe,%eax
 236:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 242:	50                   	push   %eax
 243:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 249:	50                   	push   %eax
 24a:	e8 8f 02 00 00       	call   4de <stat>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	85 c0                	test   %eax,%eax
 254:	79 1b                	jns    271 <ls+0x1b7>
        printf(1, "ls: cannot stat %s\n", buf);
 256:	83 ec 04             	sub    $0x4,%esp
 259:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25f:	50                   	push   %eax
 260:	68 76 0b 00 00       	push   $0xb76
 265:	6a 01                	push   $0x1
 267:	e8 2f 05 00 00       	call   79b <printf>
 26c:	83 c4 10             	add    $0x10,%esp
        continue;
 26f:	eb 3e                	jmp    2af <ls+0x1f5>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 271:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 277:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 27d:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 284:	0f bf d8             	movswl %ax,%ebx
 287:	83 ec 0c             	sub    $0xc,%esp
 28a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 290:	50                   	push   %eax
 291:	e8 6a fd ff ff       	call   0 <fmtname>
 296:	83 c4 10             	add    $0x10,%esp
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	57                   	push   %edi
 29d:	56                   	push   %esi
 29e:	53                   	push   %ebx
 29f:	50                   	push   %eax
 2a0:	68 8a 0b 00 00       	push   $0xb8a
 2a5:	6a 01                	push   $0x1
 2a7:	e8 ef 04 00 00       	call   79b <printf>
 2ac:	83 c4 20             	add    $0x20,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2af:	83 ec 04             	sub    $0x4,%esp
 2b2:	6a 10                	push   $0x10
 2b4:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2ba:	50                   	push   %eax
 2bb:	ff 75 e4             	pushl  -0x1c(%ebp)
 2be:	e8 6c 03 00 00       	call   62f <read>
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	83 f8 10             	cmp    $0x10,%eax
 2c9:	0f 84 36 ff ff ff    	je     205 <ls+0x14b>
    }
    break;
 2cf:	90                   	nop
  }
  close(fd);
 2d0:	83 ec 0c             	sub    $0xc,%esp
 2d3:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d6:	e8 64 03 00 00       	call   63f <close>
 2db:	83 c4 10             	add    $0x10,%esp
}
 2de:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e1:	5b                   	pop    %ebx
 2e2:	5e                   	pop    %esi
 2e3:	5f                   	pop    %edi
 2e4:	5d                   	pop    %ebp
 2e5:	c3                   	ret    

000002e6 <main>:

int
main(int argc, char *argv[])
{
 2e6:	f3 0f 1e fb          	endbr32 
 2ea:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2ee:	83 e4 f0             	and    $0xfffffff0,%esp
 2f1:	ff 71 fc             	pushl  -0x4(%ecx)
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	51                   	push   %ecx
 2f9:	83 ec 10             	sub    $0x10,%esp
 2fc:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2fe:	83 3b 01             	cmpl   $0x1,(%ebx)
 301:	7f 15                	jg     318 <main+0x32>
    ls(".");
 303:	83 ec 0c             	sub    $0xc,%esp
 306:	68 aa 0b 00 00       	push   $0xbaa
 30b:	e8 aa fd ff ff       	call   ba <ls>
 310:	83 c4 10             	add    $0x10,%esp
    exit();
 313:	e8 ff 02 00 00       	call   617 <exit>
  }
  for(i=1; i<argc; i++)
 318:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 31f:	eb 21                	jmp    342 <main+0x5c>
    ls(argv[i]);
 321:	8b 45 f4             	mov    -0xc(%ebp),%eax
 324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 32b:	8b 43 04             	mov    0x4(%ebx),%eax
 32e:	01 d0                	add    %edx,%eax
 330:	8b 00                	mov    (%eax),%eax
 332:	83 ec 0c             	sub    $0xc,%esp
 335:	50                   	push   %eax
 336:	e8 7f fd ff ff       	call   ba <ls>
 33b:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
 33e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 342:	8b 45 f4             	mov    -0xc(%ebp),%eax
 345:	3b 03                	cmp    (%ebx),%eax
 347:	7c d8                	jl     321 <main+0x3b>
  exit();
 349:	e8 c9 02 00 00       	call   617 <exit>

0000034e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	57                   	push   %edi
 352:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 353:	8b 4d 08             	mov    0x8(%ebp),%ecx
 356:	8b 55 10             	mov    0x10(%ebp),%edx
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	89 cb                	mov    %ecx,%ebx
 35e:	89 df                	mov    %ebx,%edi
 360:	89 d1                	mov    %edx,%ecx
 362:	fc                   	cld    
 363:	f3 aa                	rep stos %al,%es:(%edi)
 365:	89 ca                	mov    %ecx,%edx
 367:	89 fb                	mov    %edi,%ebx
 369:	89 5d 08             	mov    %ebx,0x8(%ebp)
 36c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 36f:	90                   	nop
 370:	5b                   	pop    %ebx
 371:	5f                   	pop    %edi
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    

00000374 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 374:	f3 0f 1e fb          	endbr32 
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 384:	90                   	nop
 385:	8b 55 0c             	mov    0xc(%ebp),%edx
 388:	8d 42 01             	lea    0x1(%edx),%eax
 38b:	89 45 0c             	mov    %eax,0xc(%ebp)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	8d 48 01             	lea    0x1(%eax),%ecx
 394:	89 4d 08             	mov    %ecx,0x8(%ebp)
 397:	0f b6 12             	movzbl (%edx),%edx
 39a:	88 10                	mov    %dl,(%eax)
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	75 e2                	jne    385 <strcpy+0x11>
    ;
  return os;
 3a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a8:	f3 0f 1e fb          	endbr32 
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3af:	eb 08                	jmp    3b9 <strcmp+0x11>
    p++, q++;
 3b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	74 10                	je     3d3 <strcmp+0x2b>
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 10             	movzbl (%eax),%edx
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	38 c2                	cmp    %al,%dl
 3d1:	74 de                	je     3b1 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	0f b6 d0             	movzbl %al,%edx
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	0f b6 c0             	movzbl %al,%eax
 3e5:	29 c2                	sub    %eax,%edx
 3e7:	89 d0                	mov    %edx,%eax
}
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret    

000003eb <strlen>:

uint
strlen(const char *s)
{
 3eb:	f3 0f 1e fb          	endbr32 
 3ef:	55                   	push   %ebp
 3f0:	89 e5                	mov    %esp,%ebp
 3f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3fc:	eb 04                	jmp    402 <strlen+0x17>
 3fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 402:	8b 55 fc             	mov    -0x4(%ebp),%edx
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	01 d0                	add    %edx,%eax
 40a:	0f b6 00             	movzbl (%eax),%eax
 40d:	84 c0                	test   %al,%al
 40f:	75 ed                	jne    3fe <strlen+0x13>
    ;
  return n;
 411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <memset>:

void*
memset(void *dst, int c, uint n)
{
 416:	f3 0f 1e fb          	endbr32 
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 41d:	8b 45 10             	mov    0x10(%ebp),%eax
 420:	50                   	push   %eax
 421:	ff 75 0c             	pushl  0xc(%ebp)
 424:	ff 75 08             	pushl  0x8(%ebp)
 427:	e8 22 ff ff ff       	call   34e <stosb>
 42c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <strchr>:

char*
strchr(const char *s, char c)
{
 434:	f3 0f 1e fb          	endbr32 
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	83 ec 04             	sub    $0x4,%esp
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 444:	eb 14                	jmp    45a <strchr+0x26>
    if(*s == c)
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	0f b6 00             	movzbl (%eax),%eax
 44c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 44f:	75 05                	jne    456 <strchr+0x22>
      return (char*)s;
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	eb 13                	jmp    469 <strchr+0x35>
  for(; *s; s++)
 456:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	84 c0                	test   %al,%al
 462:	75 e2                	jne    446 <strchr+0x12>
  return 0;
 464:	b8 00 00 00 00       	mov    $0x0,%eax
}
 469:	c9                   	leave  
 46a:	c3                   	ret    

0000046b <gets>:

char*
gets(char *buf, int max)
{
 46b:	f3 0f 1e fb          	endbr32 
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 47c:	eb 42                	jmp    4c0 <gets+0x55>
    cc = read(0, &c, 1);
 47e:	83 ec 04             	sub    $0x4,%esp
 481:	6a 01                	push   $0x1
 483:	8d 45 ef             	lea    -0x11(%ebp),%eax
 486:	50                   	push   %eax
 487:	6a 00                	push   $0x0
 489:	e8 a1 01 00 00       	call   62f <read>
 48e:	83 c4 10             	add    $0x10,%esp
 491:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 498:	7e 33                	jle    4cd <gets+0x62>
      break;
    buf[i++] = c;
 49a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49d:	8d 50 01             	lea    0x1(%eax),%edx
 4a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a3:	89 c2                	mov    %eax,%edx
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	01 c2                	add    %eax,%edx
 4aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ae:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b4:	3c 0a                	cmp    $0xa,%al
 4b6:	74 16                	je     4ce <gets+0x63>
 4b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bc:	3c 0d                	cmp    $0xd,%al
 4be:	74 0e                	je     4ce <gets+0x63>
  for(i=0; i+1 < max; ){
 4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c3:	83 c0 01             	add    $0x1,%eax
 4c6:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4c9:	7f b3                	jg     47e <gets+0x13>
 4cb:	eb 01                	jmp    4ce <gets+0x63>
      break;
 4cd:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	01 d0                	add    %edx,%eax
 4d6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4dc:	c9                   	leave  
 4dd:	c3                   	ret    

000004de <stat>:

int
stat(const char *n, struct stat *st)
{
 4de:	f3 0f 1e fb          	endbr32 
 4e2:	55                   	push   %ebp
 4e3:	89 e5                	mov    %esp,%ebp
 4e5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e8:	83 ec 08             	sub    $0x8,%esp
 4eb:	6a 00                	push   $0x0
 4ed:	ff 75 08             	pushl  0x8(%ebp)
 4f0:	e8 62 01 00 00       	call   657 <open>
 4f5:	83 c4 10             	add    $0x10,%esp
 4f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ff:	79 07                	jns    508 <stat+0x2a>
    return -1;
 501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 506:	eb 25                	jmp    52d <stat+0x4f>
  r = fstat(fd, st);
 508:	83 ec 08             	sub    $0x8,%esp
 50b:	ff 75 0c             	pushl  0xc(%ebp)
 50e:	ff 75 f4             	pushl  -0xc(%ebp)
 511:	e8 59 01 00 00       	call   66f <fstat>
 516:	83 c4 10             	add    $0x10,%esp
 519:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 51c:	83 ec 0c             	sub    $0xc,%esp
 51f:	ff 75 f4             	pushl  -0xc(%ebp)
 522:	e8 18 01 00 00       	call   63f <close>
 527:	83 c4 10             	add    $0x10,%esp
  return r;
 52a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 52d:	c9                   	leave  
 52e:	c3                   	ret    

0000052f <atoi>:



int
atoi(const char *s)
{
 52f:	f3 0f 1e fb          	endbr32 
 533:	55                   	push   %ebp
 534:	89 e5                	mov    %esp,%ebp
 536:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 539:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if (*s == '-')
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	0f b6 00             	movzbl (%eax),%eax
 546:	3c 2d                	cmp    $0x2d,%al
 548:	75 6b                	jne    5b5 <atoi+0x86>
  {
    s++;
 54a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while('0' <= *s && *s <= '9')
 54e:	eb 25                	jmp    575 <atoi+0x46>
        n = n*10 + *s++ - '0';
 550:	8b 55 fc             	mov    -0x4(%ebp),%edx
 553:	89 d0                	mov    %edx,%eax
 555:	c1 e0 02             	shl    $0x2,%eax
 558:	01 d0                	add    %edx,%eax
 55a:	01 c0                	add    %eax,%eax
 55c:	89 c1                	mov    %eax,%ecx
 55e:	8b 45 08             	mov    0x8(%ebp),%eax
 561:	8d 50 01             	lea    0x1(%eax),%edx
 564:	89 55 08             	mov    %edx,0x8(%ebp)
 567:	0f b6 00             	movzbl (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	01 c8                	add    %ecx,%eax
 56f:	83 e8 30             	sub    $0x30,%eax
 572:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	0f b6 00             	movzbl (%eax),%eax
 57b:	3c 2f                	cmp    $0x2f,%al
 57d:	7e 0a                	jle    589 <atoi+0x5a>
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	0f b6 00             	movzbl (%eax),%eax
 585:	3c 39                	cmp    $0x39,%al
 587:	7e c7                	jle    550 <atoi+0x21>

    return -n;
 589:	8b 45 fc             	mov    -0x4(%ebp),%eax
 58c:	f7 d8                	neg    %eax
 58e:	eb 3c                	jmp    5cc <atoi+0x9d>
  }
  else
  {
    while('0' <= *s && *s <= '9')
        n = n*10 + *s++ - '0';
 590:	8b 55 fc             	mov    -0x4(%ebp),%edx
 593:	89 d0                	mov    %edx,%eax
 595:	c1 e0 02             	shl    $0x2,%eax
 598:	01 d0                	add    %edx,%eax
 59a:	01 c0                	add    %eax,%eax
 59c:	89 c1                	mov    %eax,%ecx
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	8d 50 01             	lea    0x1(%eax),%edx
 5a4:	89 55 08             	mov    %edx,0x8(%ebp)
 5a7:	0f b6 00             	movzbl (%eax),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	01 c8                	add    %ecx,%eax
 5af:	83 e8 30             	sub    $0x30,%eax
 5b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while('0' <= *s && *s <= '9')
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	0f b6 00             	movzbl (%eax),%eax
 5bb:	3c 2f                	cmp    $0x2f,%al
 5bd:	7e 0a                	jle    5c9 <atoi+0x9a>
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	0f b6 00             	movzbl (%eax),%eax
 5c5:	3c 39                	cmp    $0x39,%al
 5c7:	7e c7                	jle    590 <atoi+0x61>

    return n;
 5c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
  
}
 5cc:	c9                   	leave  
 5cd:	c3                   	ret    

000005ce <memmove>:



void*
memmove(void *vdst, const void *vsrc, int n)
{
 5ce:	f3 0f 1e fb          	endbr32 
 5d2:	55                   	push   %ebp
 5d3:	89 e5                	mov    %esp,%ebp
 5d5:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5de:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5e4:	eb 17                	jmp    5fd <memmove+0x2f>
    *dst++ = *src++;
 5e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5e9:	8d 42 01             	lea    0x1(%edx),%eax
 5ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
 5ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f2:	8d 48 01             	lea    0x1(%eax),%ecx
 5f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 5f8:	0f b6 12             	movzbl (%edx),%edx
 5fb:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 5fd:	8b 45 10             	mov    0x10(%ebp),%eax
 600:	8d 50 ff             	lea    -0x1(%eax),%edx
 603:	89 55 10             	mov    %edx,0x10(%ebp)
 606:	85 c0                	test   %eax,%eax
 608:	7f dc                	jg     5e6 <memmove+0x18>
  return vdst;
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 60d:	c9                   	leave  
 60e:	c3                   	ret    

0000060f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 60f:	b8 01 00 00 00       	mov    $0x1,%eax
 614:	cd 40                	int    $0x40
 616:	c3                   	ret    

00000617 <exit>:
SYSCALL(exit)
 617:	b8 02 00 00 00       	mov    $0x2,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <wait>:
SYSCALL(wait)
 61f:	b8 03 00 00 00       	mov    $0x3,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <pipe>:
SYSCALL(pipe)
 627:	b8 04 00 00 00       	mov    $0x4,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <read>:
SYSCALL(read)
 62f:	b8 05 00 00 00       	mov    $0x5,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <write>:
SYSCALL(write)
 637:	b8 10 00 00 00       	mov    $0x10,%eax
 63c:	cd 40                	int    $0x40
 63e:	c3                   	ret    

0000063f <close>:
SYSCALL(close)
 63f:	b8 15 00 00 00       	mov    $0x15,%eax
 644:	cd 40                	int    $0x40
 646:	c3                   	ret    

00000647 <kill>:
SYSCALL(kill)
 647:	b8 06 00 00 00       	mov    $0x6,%eax
 64c:	cd 40                	int    $0x40
 64e:	c3                   	ret    

0000064f <exec>:
SYSCALL(exec)
 64f:	b8 07 00 00 00       	mov    $0x7,%eax
 654:	cd 40                	int    $0x40
 656:	c3                   	ret    

00000657 <open>:
SYSCALL(open)
 657:	b8 0f 00 00 00       	mov    $0xf,%eax
 65c:	cd 40                	int    $0x40
 65e:	c3                   	ret    

0000065f <mknod>:
SYSCALL(mknod)
 65f:	b8 11 00 00 00       	mov    $0x11,%eax
 664:	cd 40                	int    $0x40
 666:	c3                   	ret    

00000667 <unlink>:
SYSCALL(unlink)
 667:	b8 12 00 00 00       	mov    $0x12,%eax
 66c:	cd 40                	int    $0x40
 66e:	c3                   	ret    

0000066f <fstat>:
SYSCALL(fstat)
 66f:	b8 08 00 00 00       	mov    $0x8,%eax
 674:	cd 40                	int    $0x40
 676:	c3                   	ret    

00000677 <link>:
SYSCALL(link)
 677:	b8 13 00 00 00       	mov    $0x13,%eax
 67c:	cd 40                	int    $0x40
 67e:	c3                   	ret    

0000067f <mkdir>:
SYSCALL(mkdir)
 67f:	b8 14 00 00 00       	mov    $0x14,%eax
 684:	cd 40                	int    $0x40
 686:	c3                   	ret    

00000687 <chdir>:
SYSCALL(chdir)
 687:	b8 09 00 00 00       	mov    $0x9,%eax
 68c:	cd 40                	int    $0x40
 68e:	c3                   	ret    

0000068f <dup>:
SYSCALL(dup)
 68f:	b8 0a 00 00 00       	mov    $0xa,%eax
 694:	cd 40                	int    $0x40
 696:	c3                   	ret    

00000697 <getpid>:
SYSCALL(getpid)
 697:	b8 0b 00 00 00       	mov    $0xb,%eax
 69c:	cd 40                	int    $0x40
 69e:	c3                   	ret    

0000069f <sbrk>:
SYSCALL(sbrk)
 69f:	b8 0c 00 00 00       	mov    $0xc,%eax
 6a4:	cd 40                	int    $0x40
 6a6:	c3                   	ret    

000006a7 <sleep>:
SYSCALL(sleep)
 6a7:	b8 0d 00 00 00       	mov    $0xd,%eax
 6ac:	cd 40                	int    $0x40
 6ae:	c3                   	ret    

000006af <uptime>:
SYSCALL(uptime)
 6af:	b8 0e 00 00 00       	mov    $0xe,%eax
 6b4:	cd 40                	int    $0x40
 6b6:	c3                   	ret    

000006b7 <lseek>:
SYSCALL(lseek)
 6b7:	b8 16 00 00 00       	mov    $0x16,%eax
 6bc:	cd 40                	int    $0x40
 6be:	c3                   	ret    

000006bf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6bf:	f3 0f 1e fb          	endbr32 
 6c3:	55                   	push   %ebp
 6c4:	89 e5                	mov    %esp,%ebp
 6c6:	83 ec 18             	sub    $0x18,%esp
 6c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6cc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6cf:	83 ec 04             	sub    $0x4,%esp
 6d2:	6a 01                	push   $0x1
 6d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 57 ff ff ff       	call   637 <write>
 6e0:	83 c4 10             	add    $0x10,%esp
}
 6e3:	90                   	nop
 6e4:	c9                   	leave  
 6e5:	c3                   	ret    

000006e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6e6:	f3 0f 1e fb          	endbr32 
 6ea:	55                   	push   %ebp
 6eb:	89 e5                	mov    %esp,%ebp
 6ed:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6f7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6fb:	74 17                	je     714 <printint+0x2e>
 6fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 701:	79 11                	jns    714 <printint+0x2e>
    neg = 1;
 703:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 70a:	8b 45 0c             	mov    0xc(%ebp),%eax
 70d:	f7 d8                	neg    %eax
 70f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 712:	eb 06                	jmp    71a <printint+0x34>
  } else {
    x = xx;
 714:	8b 45 0c             	mov    0xc(%ebp),%eax
 717:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 71a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 721:	8b 4d 10             	mov    0x10(%ebp),%ecx
 724:	8b 45 ec             	mov    -0x14(%ebp),%eax
 727:	ba 00 00 00 00       	mov    $0x0,%edx
 72c:	f7 f1                	div    %ecx
 72e:	89 d1                	mov    %edx,%ecx
 730:	8b 45 f4             	mov    -0xc(%ebp),%eax
 733:	8d 50 01             	lea    0x1(%eax),%edx
 736:	89 55 f4             	mov    %edx,-0xc(%ebp)
 739:	0f b6 91 50 0e 00 00 	movzbl 0xe50(%ecx),%edx
 740:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 744:	8b 4d 10             	mov    0x10(%ebp),%ecx
 747:	8b 45 ec             	mov    -0x14(%ebp),%eax
 74a:	ba 00 00 00 00       	mov    $0x0,%edx
 74f:	f7 f1                	div    %ecx
 751:	89 45 ec             	mov    %eax,-0x14(%ebp)
 754:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 758:	75 c7                	jne    721 <printint+0x3b>
  if(neg)
 75a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75e:	74 2d                	je     78d <printint+0xa7>
    buf[i++] = '-';
 760:	8b 45 f4             	mov    -0xc(%ebp),%eax
 763:	8d 50 01             	lea    0x1(%eax),%edx
 766:	89 55 f4             	mov    %edx,-0xc(%ebp)
 769:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 76e:	eb 1d                	jmp    78d <printint+0xa7>
    putc(fd, buf[i]);
 770:	8d 55 dc             	lea    -0x24(%ebp),%edx
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	01 d0                	add    %edx,%eax
 778:	0f b6 00             	movzbl (%eax),%eax
 77b:	0f be c0             	movsbl %al,%eax
 77e:	83 ec 08             	sub    $0x8,%esp
 781:	50                   	push   %eax
 782:	ff 75 08             	pushl  0x8(%ebp)
 785:	e8 35 ff ff ff       	call   6bf <putc>
 78a:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 78d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 795:	79 d9                	jns    770 <printint+0x8a>
}
 797:	90                   	nop
 798:	90                   	nop
 799:	c9                   	leave  
 79a:	c3                   	ret    

0000079b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 79b:	f3 0f 1e fb          	endbr32 
 79f:	55                   	push   %ebp
 7a0:	89 e5                	mov    %esp,%ebp
 7a2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7ac:	8d 45 0c             	lea    0xc(%ebp),%eax
 7af:	83 c0 04             	add    $0x4,%eax
 7b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7bc:	e9 59 01 00 00       	jmp    91a <printf+0x17f>
    c = fmt[i] & 0xff;
 7c1:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	01 d0                	add    %edx,%eax
 7c9:	0f b6 00             	movzbl (%eax),%eax
 7cc:	0f be c0             	movsbl %al,%eax
 7cf:	25 ff 00 00 00       	and    $0xff,%eax
 7d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7db:	75 2c                	jne    809 <printf+0x6e>
      if(c == '%'){
 7dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e1:	75 0c                	jne    7ef <printf+0x54>
        state = '%';
 7e3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7ea:	e9 27 01 00 00       	jmp    916 <printf+0x17b>
      } else {
        putc(fd, c);
 7ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f2:	0f be c0             	movsbl %al,%eax
 7f5:	83 ec 08             	sub    $0x8,%esp
 7f8:	50                   	push   %eax
 7f9:	ff 75 08             	pushl  0x8(%ebp)
 7fc:	e8 be fe ff ff       	call   6bf <putc>
 801:	83 c4 10             	add    $0x10,%esp
 804:	e9 0d 01 00 00       	jmp    916 <printf+0x17b>
      }
    } else if(state == '%'){
 809:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 80d:	0f 85 03 01 00 00    	jne    916 <printf+0x17b>
      if(c == 'd'){
 813:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 817:	75 1e                	jne    837 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 819:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	6a 01                	push   $0x1
 820:	6a 0a                	push   $0xa
 822:	50                   	push   %eax
 823:	ff 75 08             	pushl  0x8(%ebp)
 826:	e8 bb fe ff ff       	call   6e6 <printint>
 82b:	83 c4 10             	add    $0x10,%esp
        ap++;
 82e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 832:	e9 d8 00 00 00       	jmp    90f <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 837:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 83b:	74 06                	je     843 <printf+0xa8>
 83d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 841:	75 1e                	jne    861 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 843:	8b 45 e8             	mov    -0x18(%ebp),%eax
 846:	8b 00                	mov    (%eax),%eax
 848:	6a 00                	push   $0x0
 84a:	6a 10                	push   $0x10
 84c:	50                   	push   %eax
 84d:	ff 75 08             	pushl  0x8(%ebp)
 850:	e8 91 fe ff ff       	call   6e6 <printint>
 855:	83 c4 10             	add    $0x10,%esp
        ap++;
 858:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 85c:	e9 ae 00 00 00       	jmp    90f <printf+0x174>
      } else if(c == 's'){
 861:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 865:	75 43                	jne    8aa <printf+0x10f>
        s = (char*)*ap;
 867:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86a:	8b 00                	mov    (%eax),%eax
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 86f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 877:	75 25                	jne    89e <printf+0x103>
          s = "(null)";
 879:	c7 45 f4 ac 0b 00 00 	movl   $0xbac,-0xc(%ebp)
        while(*s != 0){
 880:	eb 1c                	jmp    89e <printf+0x103>
          putc(fd, *s);
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	0f b6 00             	movzbl (%eax),%eax
 888:	0f be c0             	movsbl %al,%eax
 88b:	83 ec 08             	sub    $0x8,%esp
 88e:	50                   	push   %eax
 88f:	ff 75 08             	pushl  0x8(%ebp)
 892:	e8 28 fe ff ff       	call   6bf <putc>
 897:	83 c4 10             	add    $0x10,%esp
          s++;
 89a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 89e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a1:	0f b6 00             	movzbl (%eax),%eax
 8a4:	84 c0                	test   %al,%al
 8a6:	75 da                	jne    882 <printf+0xe7>
 8a8:	eb 65                	jmp    90f <printf+0x174>
        }
      } else if(c == 'c'){
 8aa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8ae:	75 1d                	jne    8cd <printf+0x132>
        putc(fd, *ap);
 8b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	0f be c0             	movsbl %al,%eax
 8b8:	83 ec 08             	sub    $0x8,%esp
 8bb:	50                   	push   %eax
 8bc:	ff 75 08             	pushl  0x8(%ebp)
 8bf:	e8 fb fd ff ff       	call   6bf <putc>
 8c4:	83 c4 10             	add    $0x10,%esp
        ap++;
 8c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8cb:	eb 42                	jmp    90f <printf+0x174>
      } else if(c == '%'){
 8cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8d1:	75 17                	jne    8ea <printf+0x14f>
        putc(fd, c);
 8d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d6:	0f be c0             	movsbl %al,%eax
 8d9:	83 ec 08             	sub    $0x8,%esp
 8dc:	50                   	push   %eax
 8dd:	ff 75 08             	pushl  0x8(%ebp)
 8e0:	e8 da fd ff ff       	call   6bf <putc>
 8e5:	83 c4 10             	add    $0x10,%esp
 8e8:	eb 25                	jmp    90f <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ea:	83 ec 08             	sub    $0x8,%esp
 8ed:	6a 25                	push   $0x25
 8ef:	ff 75 08             	pushl  0x8(%ebp)
 8f2:	e8 c8 fd ff ff       	call   6bf <putc>
 8f7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8fd:	0f be c0             	movsbl %al,%eax
 900:	83 ec 08             	sub    $0x8,%esp
 903:	50                   	push   %eax
 904:	ff 75 08             	pushl  0x8(%ebp)
 907:	e8 b3 fd ff ff       	call   6bf <putc>
 90c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 90f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 916:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 91a:	8b 55 0c             	mov    0xc(%ebp),%edx
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	01 d0                	add    %edx,%eax
 922:	0f b6 00             	movzbl (%eax),%eax
 925:	84 c0                	test   %al,%al
 927:	0f 85 94 fe ff ff    	jne    7c1 <printf+0x26>
    }
  }
}
 92d:	90                   	nop
 92e:	90                   	nop
 92f:	c9                   	leave  
 930:	c3                   	ret    

00000931 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 931:	f3 0f 1e fb          	endbr32 
 935:	55                   	push   %ebp
 936:	89 e5                	mov    %esp,%ebp
 938:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93b:	8b 45 08             	mov    0x8(%ebp),%eax
 93e:	83 e8 08             	sub    $0x8,%eax
 941:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	a1 7c 0e 00 00       	mov    0xe7c,%eax
 949:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94c:	eb 24                	jmp    972 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	8b 00                	mov    (%eax),%eax
 953:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 956:	72 12                	jb     96a <free+0x39>
 958:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95e:	77 24                	ja     984 <free+0x53>
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	8b 00                	mov    (%eax),%eax
 965:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 968:	72 1a                	jb     984 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96d:	8b 00                	mov    (%eax),%eax
 96f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 972:	8b 45 f8             	mov    -0x8(%ebp),%eax
 975:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 978:	76 d4                	jbe    94e <free+0x1d>
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	8b 00                	mov    (%eax),%eax
 97f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 982:	73 ca                	jae    94e <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 984:	8b 45 f8             	mov    -0x8(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 991:	8b 45 f8             	mov    -0x8(%ebp),%eax
 994:	01 c2                	add    %eax,%edx
 996:	8b 45 fc             	mov    -0x4(%ebp),%eax
 999:	8b 00                	mov    (%eax),%eax
 99b:	39 c2                	cmp    %eax,%edx
 99d:	75 24                	jne    9c3 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 99f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a2:	8b 50 04             	mov    0x4(%eax),%edx
 9a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a8:	8b 00                	mov    (%eax),%eax
 9aa:	8b 40 04             	mov    0x4(%eax),%eax
 9ad:	01 c2                	add    %eax,%edx
 9af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	8b 00                	mov    (%eax),%eax
 9ba:	8b 10                	mov    (%eax),%edx
 9bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bf:	89 10                	mov    %edx,(%eax)
 9c1:	eb 0a                	jmp    9cd <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 9c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c6:	8b 10                	mov    (%eax),%edx
 9c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9cb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d0:	8b 40 04             	mov    0x4(%eax),%eax
 9d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dd:	01 d0                	add    %edx,%eax
 9df:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 9e2:	75 20                	jne    a04 <free+0xd3>
    p->s.size += bp->s.size;
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	8b 50 04             	mov    0x4(%eax),%edx
 9ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ed:	8b 40 04             	mov    0x4(%eax),%eax
 9f0:	01 c2                	add    %eax,%edx
 9f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fb:	8b 10                	mov    (%eax),%edx
 9fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a00:	89 10                	mov    %edx,(%eax)
 a02:	eb 08                	jmp    a0c <free+0xdb>
  } else
    p->s.ptr = bp;
 a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a07:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a0a:	89 10                	mov    %edx,(%eax)
  freep = p;
 a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0f:	a3 7c 0e 00 00       	mov    %eax,0xe7c
}
 a14:	90                   	nop
 a15:	c9                   	leave  
 a16:	c3                   	ret    

00000a17 <morecore>:

static Header*
morecore(uint nu)
{
 a17:	f3 0f 1e fb          	endbr32 
 a1b:	55                   	push   %ebp
 a1c:	89 e5                	mov    %esp,%ebp
 a1e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a21:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a28:	77 07                	ja     a31 <morecore+0x1a>
    nu = 4096;
 a2a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a31:	8b 45 08             	mov    0x8(%ebp),%eax
 a34:	c1 e0 03             	shl    $0x3,%eax
 a37:	83 ec 0c             	sub    $0xc,%esp
 a3a:	50                   	push   %eax
 a3b:	e8 5f fc ff ff       	call   69f <sbrk>
 a40:	83 c4 10             	add    $0x10,%esp
 a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a46:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a4a:	75 07                	jne    a53 <morecore+0x3c>
    return 0;
 a4c:	b8 00 00 00 00       	mov    $0x0,%eax
 a51:	eb 26                	jmp    a79 <morecore+0x62>
  hp = (Header*)p;
 a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5c:	8b 55 08             	mov    0x8(%ebp),%edx
 a5f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a65:	83 c0 08             	add    $0x8,%eax
 a68:	83 ec 0c             	sub    $0xc,%esp
 a6b:	50                   	push   %eax
 a6c:	e8 c0 fe ff ff       	call   931 <free>
 a71:	83 c4 10             	add    $0x10,%esp
  return freep;
 a74:	a1 7c 0e 00 00       	mov    0xe7c,%eax
}
 a79:	c9                   	leave  
 a7a:	c3                   	ret    

00000a7b <malloc>:

void*
malloc(uint nbytes)
{
 a7b:	f3 0f 1e fb          	endbr32 
 a7f:	55                   	push   %ebp
 a80:	89 e5                	mov    %esp,%ebp
 a82:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a85:	8b 45 08             	mov    0x8(%ebp),%eax
 a88:	83 c0 07             	add    $0x7,%eax
 a8b:	c1 e8 03             	shr    $0x3,%eax
 a8e:	83 c0 01             	add    $0x1,%eax
 a91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a94:	a1 7c 0e 00 00       	mov    0xe7c,%eax
 a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 aa0:	75 23                	jne    ac5 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 aa2:	c7 45 f0 74 0e 00 00 	movl   $0xe74,-0x10(%ebp)
 aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aac:	a3 7c 0e 00 00       	mov    %eax,0xe7c
 ab1:	a1 7c 0e 00 00       	mov    0xe7c,%eax
 ab6:	a3 74 0e 00 00       	mov    %eax,0xe74
    base.s.size = 0;
 abb:	c7 05 78 0e 00 00 00 	movl   $0x0,0xe78
 ac2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac8:	8b 00                	mov    (%eax),%eax
 aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad0:	8b 40 04             	mov    0x4(%eax),%eax
 ad3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ad6:	77 4d                	ja     b25 <malloc+0xaa>
      if(p->s.size == nunits)
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	8b 40 04             	mov    0x4(%eax),%eax
 ade:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ae1:	75 0c                	jne    aef <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	8b 10                	mov    (%eax),%edx
 ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aeb:	89 10                	mov    %edx,(%eax)
 aed:	eb 26                	jmp    b15 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af2:	8b 40 04             	mov    0x4(%eax),%eax
 af5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 af8:	89 c2                	mov    %eax,%edx
 afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b03:	8b 40 04             	mov    0x4(%eax),%eax
 b06:	c1 e0 03             	shl    $0x3,%eax
 b09:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b12:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b18:	a3 7c 0e 00 00       	mov    %eax,0xe7c
      return (void*)(p + 1);
 b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b20:	83 c0 08             	add    $0x8,%eax
 b23:	eb 3b                	jmp    b60 <malloc+0xe5>
    }
    if(p == freep)
 b25:	a1 7c 0e 00 00       	mov    0xe7c,%eax
 b2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b2d:	75 1e                	jne    b4d <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 b2f:	83 ec 0c             	sub    $0xc,%esp
 b32:	ff 75 ec             	pushl  -0x14(%ebp)
 b35:	e8 dd fe ff ff       	call   a17 <morecore>
 b3a:	83 c4 10             	add    $0x10,%esp
 b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b44:	75 07                	jne    b4d <malloc+0xd2>
        return 0;
 b46:	b8 00 00 00 00       	mov    $0x0,%eax
 b4b:	eb 13                	jmp    b60 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b56:	8b 00                	mov    (%eax),%eax
 b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b5b:	e9 6d ff ff ff       	jmp    acd <malloc+0x52>
  }
}
 b60:	c9                   	leave  
 b61:	c3                   	ret    
