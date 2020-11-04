
kernel:     format de fichier elf32-i386


Déassemblage de la section .text :

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 c6 10 80       	mov    $0x8010c630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 1a 3a 10 80       	mov    $0x80103a1a,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	f3 0f 1e fb          	endbr32 
80100038:	55                   	push   %ebp
80100039:	89 e5                	mov    %esp,%ebp
8010003b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003e:	83 ec 08             	sub    $0x8,%esp
80100041:	68 04 87 10 80       	push   $0x80108704
80100046:	68 40 c6 10 80       	push   $0x8010c640
8010004b:	e8 68 51 00 00       	call   801051b8 <initlock>
80100050:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100053:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
8010005a:	0d 11 80 
  bcache.head.next = &bcache.head;
8010005d:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
80100064:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100067:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
8010006e:	eb 47                	jmp    801000b7 <binit+0x83>
    b->next = bcache.head.next;
80100070:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
80100076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100079:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
8010007c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007f:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100089:	83 c0 0c             	add    $0xc,%eax
8010008c:	83 ec 08             	sub    $0x8,%esp
8010008f:	68 0b 87 10 80       	push   $0x8010870b
80100094:	50                   	push   %eax
80100095:	e8 8b 4f 00 00       	call   80105025 <initsleeplock>
8010009a:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
8010009d:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801000a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a5:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ab:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b0:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b7:	b8 3c 0d 11 80       	mov    $0x80110d3c,%eax
801000bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bf:	72 af                	jb     80100070 <binit+0x3c>
  }
}
801000c1:	90                   	nop
801000c2:	90                   	nop
801000c3:	c9                   	leave  
801000c4:	c3                   	ret    

801000c5 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c5:	f3 0f 1e fb          	endbr32 
801000c9:	55                   	push   %ebp
801000ca:	89 e5                	mov    %esp,%ebp
801000cc:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000cf:	83 ec 0c             	sub    $0xc,%esp
801000d2:	68 40 c6 10 80       	push   $0x8010c640
801000d7:	e8 02 51 00 00       	call   801051de <acquire>
801000dc:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000df:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801000e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000e7:	eb 58                	jmp    80100141 <bget+0x7c>
    if(b->dev == dev && b->blockno == blockno){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 40 04             	mov    0x4(%eax),%eax
801000ef:	39 45 08             	cmp    %eax,0x8(%ebp)
801000f2:	75 44                	jne    80100138 <bget+0x73>
801000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f7:	8b 40 08             	mov    0x8(%eax),%eax
801000fa:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000fd:	75 39                	jne    80100138 <bget+0x73>
      b->refcnt++;
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	8b 40 4c             	mov    0x4c(%eax),%eax
80100105:	8d 50 01             	lea    0x1(%eax),%edx
80100108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010b:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
8010010e:	83 ec 0c             	sub    $0xc,%esp
80100111:	68 40 c6 10 80       	push   $0x8010c640
80100116:	e8 35 51 00 00       	call   80105250 <release>
8010011b:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	83 c0 0c             	add    $0xc,%eax
80100124:	83 ec 0c             	sub    $0xc,%esp
80100127:	50                   	push   %eax
80100128:	e8 38 4f 00 00       	call   80105065 <acquiresleep>
8010012d:	83 c4 10             	add    $0x10,%esp
      return b;
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	e9 9d 00 00 00       	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013b:	8b 40 54             	mov    0x54(%eax),%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
80100148:	75 9f                	jne    801000e9 <bget+0x24>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010014a:	a1 8c 0d 11 80       	mov    0x80110d8c,%eax
8010014f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100152:	eb 6b                	jmp    801001bf <bget+0xfa>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100157:	8b 40 4c             	mov    0x4c(%eax),%eax
8010015a:	85 c0                	test   %eax,%eax
8010015c:	75 58                	jne    801001b6 <bget+0xf1>
8010015e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100161:	8b 00                	mov    (%eax),%eax
80100163:	83 e0 04             	and    $0x4,%eax
80100166:	85 c0                	test   %eax,%eax
80100168:	75 4c                	jne    801001b6 <bget+0xf1>
      b->dev = dev;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 08             	mov    0x8(%ebp),%edx
80100170:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	8b 55 0c             	mov    0xc(%ebp),%edx
80100179:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
80100185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100188:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
8010018f:	83 ec 0c             	sub    $0xc,%esp
80100192:	68 40 c6 10 80       	push   $0x8010c640
80100197:	e8 b4 50 00 00       	call   80105250 <release>
8010019c:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010019f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a2:	83 c0 0c             	add    $0xc,%eax
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	50                   	push   %eax
801001a9:	e8 b7 4e 00 00       	call   80105065 <acquiresleep>
801001ae:	83 c4 10             	add    $0x10,%esp
      return b;
801001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b4:	eb 1f                	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b9:	8b 40 50             	mov    0x50(%eax),%eax
801001bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001bf:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
801001c6:	75 8c                	jne    80100154 <bget+0x8f>
    }
  }
  panic("bget: no buffers");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 12 87 10 80       	push   $0x80108712
801001d0:	e8 fc 03 00 00       	call   801005d1 <panic>
}
801001d5:	c9                   	leave  
801001d6:	c3                   	ret    

801001d7 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001d7:	f3 0f 1e fb          	endbr32 
801001db:	55                   	push   %ebp
801001dc:	89 e5                	mov    %esp,%ebp
801001de:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001e1:	83 ec 08             	sub    $0x8,%esp
801001e4:	ff 75 0c             	pushl  0xc(%ebp)
801001e7:	ff 75 08             	pushl  0x8(%ebp)
801001ea:	e8 d6 fe ff ff       	call   801000c5 <bget>
801001ef:	83 c4 10             	add    $0x10,%esp
801001f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 02             	and    $0x2,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0e                	jne    8010020f <bread+0x38>
    iderw(b);
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	ff 75 f4             	pushl  -0xc(%ebp)
80100207:	e8 93 28 00 00       	call   80102a9f <iderw>
8010020c:	83 c4 10             	add    $0x10,%esp
  }
  return b;
8010020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100212:	c9                   	leave  
80100213:	c3                   	ret    

80100214 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100214:	f3 0f 1e fb          	endbr32 
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	83 c0 0c             	add    $0xc,%eax
80100224:	83 ec 0c             	sub    $0xc,%esp
80100227:	50                   	push   %eax
80100228:	e8 f2 4e 00 00       	call   8010511f <holdingsleep>
8010022d:	83 c4 10             	add    $0x10,%esp
80100230:	85 c0                	test   %eax,%eax
80100232:	75 0d                	jne    80100241 <bwrite+0x2d>
    panic("bwrite");
80100234:	83 ec 0c             	sub    $0xc,%esp
80100237:	68 23 87 10 80       	push   $0x80108723
8010023c:	e8 90 03 00 00       	call   801005d1 <panic>
  b->flags |= B_DIRTY;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 00                	mov    (%eax),%eax
80100246:	83 c8 04             	or     $0x4,%eax
80100249:	89 c2                	mov    %eax,%edx
8010024b:	8b 45 08             	mov    0x8(%ebp),%eax
8010024e:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100250:	83 ec 0c             	sub    $0xc,%esp
80100253:	ff 75 08             	pushl  0x8(%ebp)
80100256:	e8 44 28 00 00       	call   80102a9f <iderw>
8010025b:	83 c4 10             	add    $0x10,%esp
}
8010025e:	90                   	nop
8010025f:	c9                   	leave  
80100260:	c3                   	ret    

80100261 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100261:	f3 0f 1e fb          	endbr32 
80100265:	55                   	push   %ebp
80100266:	89 e5                	mov    %esp,%ebp
80100268:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	83 c0 0c             	add    $0xc,%eax
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	50                   	push   %eax
80100275:	e8 a5 4e 00 00       	call   8010511f <holdingsleep>
8010027a:	83 c4 10             	add    $0x10,%esp
8010027d:	85 c0                	test   %eax,%eax
8010027f:	75 0d                	jne    8010028e <brelse+0x2d>
    panic("brelse");
80100281:	83 ec 0c             	sub    $0xc,%esp
80100284:	68 2a 87 10 80       	push   $0x8010872a
80100289:	e8 43 03 00 00       	call   801005d1 <panic>

  releasesleep(&b->lock);
8010028e:	8b 45 08             	mov    0x8(%ebp),%eax
80100291:	83 c0 0c             	add    $0xc,%eax
80100294:	83 ec 0c             	sub    $0xc,%esp
80100297:	50                   	push   %eax
80100298:	e8 30 4e 00 00       	call   801050cd <releasesleep>
8010029d:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002a0:	83 ec 0c             	sub    $0xc,%esp
801002a3:	68 40 c6 10 80       	push   $0x8010c640
801002a8:	e8 31 4f 00 00       	call   801051de <acquire>
801002ad:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002b0:	8b 45 08             	mov    0x8(%ebp),%eax
801002b3:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b6:	8d 50 ff             	lea    -0x1(%eax),%edx
801002b9:	8b 45 08             	mov    0x8(%ebp),%eax
801002bc:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002bf:	8b 45 08             	mov    0x8(%ebp),%eax
801002c2:	8b 40 4c             	mov    0x4c(%eax),%eax
801002c5:	85 c0                	test   %eax,%eax
801002c7:	75 47                	jne    80100310 <brelse+0xaf>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002c9:	8b 45 08             	mov    0x8(%ebp),%eax
801002cc:	8b 40 54             	mov    0x54(%eax),%eax
801002cf:	8b 55 08             	mov    0x8(%ebp),%edx
801002d2:	8b 52 50             	mov    0x50(%edx),%edx
801002d5:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	8b 40 50             	mov    0x50(%eax),%eax
801002de:	8b 55 08             	mov    0x8(%ebp),%edx
801002e1:	8b 52 54             	mov    0x54(%edx),%edx
801002e4:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002e7:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
801002ed:	8b 45 08             	mov    0x8(%ebp),%eax
801002f0:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    bcache.head.next->prev = b;
801002fd:	a1 90 0d 11 80       	mov    0x80110d90,%eax
80100302:	8b 55 08             	mov    0x8(%ebp),%edx
80100305:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100308:	8b 45 08             	mov    0x8(%ebp),%eax
8010030b:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  }
  
  release(&bcache.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 40 c6 10 80       	push   $0x8010c640
80100318:	e8 33 4f 00 00       	call   80105250 <release>
8010031d:	83 c4 10             	add    $0x10,%esp
}
80100320:	90                   	nop
80100321:	c9                   	leave  
80100322:	c3                   	ret    

80100323 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80100323:	55                   	push   %ebp
80100324:	89 e5                	mov    %esp,%ebp
80100326:	83 ec 14             	sub    $0x14,%esp
80100329:	8b 45 08             	mov    0x8(%ebp),%eax
8010032c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100330:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100334:	89 c2                	mov    %eax,%edx
80100336:	ec                   	in     (%dx),%al
80100337:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010033a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010033e:	c9                   	leave  
8010033f:	c3                   	ret    

80100340 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80100340:	55                   	push   %ebp
80100341:	89 e5                	mov    %esp,%ebp
80100343:	83 ec 08             	sub    $0x8,%esp
80100346:	8b 45 08             	mov    0x8(%ebp),%eax
80100349:	8b 55 0c             	mov    0xc(%ebp),%edx
8010034c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100350:	89 d0                	mov    %edx,%eax
80100352:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100355:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100359:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010035d:	ee                   	out    %al,(%dx)
}
8010035e:	90                   	nop
8010035f:	c9                   	leave  
80100360:	c3                   	ret    

80100361 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100361:	55                   	push   %ebp
80100362:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100364:	fa                   	cli    
}
80100365:	90                   	nop
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    

80100368 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100368:	f3 0f 1e fb          	endbr32 
8010036c:	55                   	push   %ebp
8010036d:	89 e5                	mov    %esp,%ebp
8010036f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100372:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100376:	74 1c                	je     80100394 <printint+0x2c>
80100378:	8b 45 08             	mov    0x8(%ebp),%eax
8010037b:	c1 e8 1f             	shr    $0x1f,%eax
8010037e:	0f b6 c0             	movzbl %al,%eax
80100381:	89 45 10             	mov    %eax,0x10(%ebp)
80100384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100388:	74 0a                	je     80100394 <printint+0x2c>
    x = -xx;
8010038a:	8b 45 08             	mov    0x8(%ebp),%eax
8010038d:	f7 d8                	neg    %eax
8010038f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100392:	eb 06                	jmp    8010039a <printint+0x32>
  else
    x = xx;
80100394:	8b 45 08             	mov    0x8(%ebp),%eax
80100397:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010039a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
801003a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a7:	ba 00 00 00 00       	mov    $0x0,%edx
801003ac:	f7 f1                	div    %ecx
801003ae:	89 d1                	mov    %edx,%ecx
801003b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003b3:	8d 50 01             	lea    0x1(%eax),%edx
801003b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003b9:	0f b6 91 04 90 10 80 	movzbl -0x7fef6ffc(%ecx),%edx
801003c0:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003ca:	ba 00 00 00 00       	mov    $0x0,%edx
801003cf:	f7 f1                	div    %ecx
801003d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003d8:	75 c7                	jne    801003a1 <printint+0x39>

  if(sign)
801003da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003de:	74 2a                	je     8010040a <printint+0xa2>
    buf[i++] = '-';
801003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003e3:	8d 50 01             	lea    0x1(%eax),%edx
801003e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003e9:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ee:	eb 1a                	jmp    8010040a <printint+0xa2>
    consputc(buf[i]);
801003f0:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003f6:	01 d0                	add    %edx,%eax
801003f8:	0f b6 00             	movzbl (%eax),%eax
801003fb:	0f be c0             	movsbl %al,%eax
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	50                   	push   %eax
80100402:	e8 ff 03 00 00       	call   80100806 <consputc>
80100407:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
8010040a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010040e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100412:	79 dc                	jns    801003f0 <printint+0x88>
}
80100414:	90                   	nop
80100415:	90                   	nop
80100416:	c9                   	leave  
80100417:	c3                   	ret    

80100418 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100418:	f3 0f 1e fb          	endbr32 
8010041c:	55                   	push   %ebp
8010041d:	89 e5                	mov    %esp,%ebp
8010041f:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100422:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
80100427:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010042a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010042e:	74 10                	je     80100440 <cprintf+0x28>
    acquire(&cons.lock);
80100430:	83 ec 0c             	sub    $0xc,%esp
80100433:	68 a0 b5 10 80       	push   $0x8010b5a0
80100438:	e8 a1 4d 00 00       	call   801051de <acquire>
8010043d:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100440:	8b 45 08             	mov    0x8(%ebp),%eax
80100443:	85 c0                	test   %eax,%eax
80100445:	75 0d                	jne    80100454 <cprintf+0x3c>
    panic("null fmt");
80100447:	83 ec 0c             	sub    $0xc,%esp
8010044a:	68 31 87 10 80       	push   $0x80108731
8010044f:	e8 7d 01 00 00       	call   801005d1 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100454:	8d 45 0c             	lea    0xc(%ebp),%eax
80100457:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010045a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100461:	e9 2f 01 00 00       	jmp    80100595 <cprintf+0x17d>
    if(c != '%'){
80100466:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010046a:	74 13                	je     8010047f <cprintf+0x67>
      consputc(c);
8010046c:	83 ec 0c             	sub    $0xc,%esp
8010046f:	ff 75 e4             	pushl  -0x1c(%ebp)
80100472:	e8 8f 03 00 00       	call   80100806 <consputc>
80100477:	83 c4 10             	add    $0x10,%esp
      continue;
8010047a:	e9 12 01 00 00       	jmp    80100591 <cprintf+0x179>
    }
    c = fmt[++i] & 0xff;
8010047f:	8b 55 08             	mov    0x8(%ebp),%edx
80100482:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100489:	01 d0                	add    %edx,%eax
8010048b:	0f b6 00             	movzbl (%eax),%eax
8010048e:	0f be c0             	movsbl %al,%eax
80100491:	25 ff 00 00 00       	and    $0xff,%eax
80100496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100499:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010049d:	0f 84 14 01 00 00    	je     801005b7 <cprintf+0x19f>
      break;
    switch(c){
801004a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
801004a7:	74 5e                	je     80100507 <cprintf+0xef>
801004a9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
801004ad:	0f 8f c2 00 00 00    	jg     80100575 <cprintf+0x15d>
801004b3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
801004b7:	74 6b                	je     80100524 <cprintf+0x10c>
801004b9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
801004bd:	0f 8f b2 00 00 00    	jg     80100575 <cprintf+0x15d>
801004c3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004c7:	74 3e                	je     80100507 <cprintf+0xef>
801004c9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004cd:	0f 8f a2 00 00 00    	jg     80100575 <cprintf+0x15d>
801004d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004d7:	0f 84 89 00 00 00    	je     80100566 <cprintf+0x14e>
801004dd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004e1:	0f 85 8e 00 00 00    	jne    80100575 <cprintf+0x15d>
    case 'd':
      printint(*argp++, 10, 1);
801004e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ea:	8d 50 04             	lea    0x4(%eax),%edx
801004ed:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004f0:	8b 00                	mov    (%eax),%eax
801004f2:	83 ec 04             	sub    $0x4,%esp
801004f5:	6a 01                	push   $0x1
801004f7:	6a 0a                	push   $0xa
801004f9:	50                   	push   %eax
801004fa:	e8 69 fe ff ff       	call   80100368 <printint>
801004ff:	83 c4 10             	add    $0x10,%esp
      break;
80100502:	e9 8a 00 00 00       	jmp    80100591 <cprintf+0x179>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100507:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010050a:	8d 50 04             	lea    0x4(%eax),%edx
8010050d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100510:	8b 00                	mov    (%eax),%eax
80100512:	83 ec 04             	sub    $0x4,%esp
80100515:	6a 00                	push   $0x0
80100517:	6a 10                	push   $0x10
80100519:	50                   	push   %eax
8010051a:	e8 49 fe ff ff       	call   80100368 <printint>
8010051f:	83 c4 10             	add    $0x10,%esp
      break;
80100522:	eb 6d                	jmp    80100591 <cprintf+0x179>
    case 's':
      if((s = (char*)*argp++) == 0)
80100524:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100527:	8d 50 04             	lea    0x4(%eax),%edx
8010052a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010052d:	8b 00                	mov    (%eax),%eax
8010052f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100532:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100536:	75 22                	jne    8010055a <cprintf+0x142>
        s = "(null)";
80100538:	c7 45 ec 3a 87 10 80 	movl   $0x8010873a,-0x14(%ebp)
      for(; *s; s++)
8010053f:	eb 19                	jmp    8010055a <cprintf+0x142>
        consputc(*s);
80100541:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100544:	0f b6 00             	movzbl (%eax),%eax
80100547:	0f be c0             	movsbl %al,%eax
8010054a:	83 ec 0c             	sub    $0xc,%esp
8010054d:	50                   	push   %eax
8010054e:	e8 b3 02 00 00       	call   80100806 <consputc>
80100553:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100556:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010055a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010055d:	0f b6 00             	movzbl (%eax),%eax
80100560:	84 c0                	test   %al,%al
80100562:	75 dd                	jne    80100541 <cprintf+0x129>
      break;
80100564:	eb 2b                	jmp    80100591 <cprintf+0x179>
    case '%':
      consputc('%');
80100566:	83 ec 0c             	sub    $0xc,%esp
80100569:	6a 25                	push   $0x25
8010056b:	e8 96 02 00 00       	call   80100806 <consputc>
80100570:	83 c4 10             	add    $0x10,%esp
      break;
80100573:	eb 1c                	jmp    80100591 <cprintf+0x179>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100575:	83 ec 0c             	sub    $0xc,%esp
80100578:	6a 25                	push   $0x25
8010057a:	e8 87 02 00 00       	call   80100806 <consputc>
8010057f:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100582:	83 ec 0c             	sub    $0xc,%esp
80100585:	ff 75 e4             	pushl  -0x1c(%ebp)
80100588:	e8 79 02 00 00       	call   80100806 <consputc>
8010058d:	83 c4 10             	add    $0x10,%esp
      break;
80100590:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100591:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100595:	8b 55 08             	mov    0x8(%ebp),%edx
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	01 d0                	add    %edx,%eax
8010059d:	0f b6 00             	movzbl (%eax),%eax
801005a0:	0f be c0             	movsbl %al,%eax
801005a3:	25 ff 00 00 00       	and    $0xff,%eax
801005a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005af:	0f 85 b1 fe ff ff    	jne    80100466 <cprintf+0x4e>
801005b5:	eb 01                	jmp    801005b8 <cprintf+0x1a0>
      break;
801005b7:	90                   	nop
    }
  }

  if(locking)
801005b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005bc:	74 10                	je     801005ce <cprintf+0x1b6>
    release(&cons.lock);
801005be:	83 ec 0c             	sub    $0xc,%esp
801005c1:	68 a0 b5 10 80       	push   $0x8010b5a0
801005c6:	e8 85 4c 00 00       	call   80105250 <release>
801005cb:	83 c4 10             	add    $0x10,%esp
}
801005ce:	90                   	nop
801005cf:	c9                   	leave  
801005d0:	c3                   	ret    

801005d1 <panic>:

void
panic(char *s)
{
801005d1:	f3 0f 1e fb          	endbr32 
801005d5:	55                   	push   %ebp
801005d6:	89 e5                	mov    %esp,%ebp
801005d8:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005db:	e8 81 fd ff ff       	call   80100361 <cli>
  cons.locking = 0;
801005e0:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
801005e7:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005ea:	e8 7c 2b 00 00       	call   8010316b <lapicid>
801005ef:	83 ec 08             	sub    $0x8,%esp
801005f2:	50                   	push   %eax
801005f3:	68 41 87 10 80       	push   $0x80108741
801005f8:	e8 1b fe ff ff       	call   80100418 <cprintf>
801005fd:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100600:	8b 45 08             	mov    0x8(%ebp),%eax
80100603:	83 ec 0c             	sub    $0xc,%esp
80100606:	50                   	push   %eax
80100607:	e8 0c fe ff ff       	call   80100418 <cprintf>
8010060c:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010060f:	83 ec 0c             	sub    $0xc,%esp
80100612:	68 55 87 10 80       	push   $0x80108755
80100617:	e8 fc fd ff ff       	call   80100418 <cprintf>
8010061c:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
8010061f:	83 ec 08             	sub    $0x8,%esp
80100622:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100625:	50                   	push   %eax
80100626:	8d 45 08             	lea    0x8(%ebp),%eax
80100629:	50                   	push   %eax
8010062a:	e8 77 4c 00 00       	call   801052a6 <getcallerpcs>
8010062f:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100632:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100639:	eb 1c                	jmp    80100657 <panic+0x86>
    cprintf(" %p", pcs[i]);
8010063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010063e:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100642:	83 ec 08             	sub    $0x8,%esp
80100645:	50                   	push   %eax
80100646:	68 57 87 10 80       	push   $0x80108757
8010064b:	e8 c8 fd ff ff       	call   80100418 <cprintf>
80100650:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100653:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100657:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010065b:	7e de                	jle    8010063b <panic+0x6a>
  panicked = 1; // freeze other CPU
8010065d:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80100664:	00 00 00 
  for(;;)
80100667:	eb fe                	jmp    80100667 <panic+0x96>

80100669 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100669:	f3 0f 1e fb          	endbr32 
8010066d:	55                   	push   %ebp
8010066e:	89 e5                	mov    %esp,%ebp
80100670:	53                   	push   %ebx
80100671:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100674:	6a 0e                	push   $0xe
80100676:	68 d4 03 00 00       	push   $0x3d4
8010067b:	e8 c0 fc ff ff       	call   80100340 <outb>
80100680:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100683:	68 d5 03 00 00       	push   $0x3d5
80100688:	e8 96 fc ff ff       	call   80100323 <inb>
8010068d:	83 c4 04             	add    $0x4,%esp
80100690:	0f b6 c0             	movzbl %al,%eax
80100693:	c1 e0 08             	shl    $0x8,%eax
80100696:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100699:	6a 0f                	push   $0xf
8010069b:	68 d4 03 00 00       	push   $0x3d4
801006a0:	e8 9b fc ff ff       	call   80100340 <outb>
801006a5:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
801006a8:	68 d5 03 00 00       	push   $0x3d5
801006ad:	e8 71 fc ff ff       	call   80100323 <inb>
801006b2:	83 c4 04             	add    $0x4,%esp
801006b5:	0f b6 c0             	movzbl %al,%eax
801006b8:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
801006bb:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
801006bf:	75 30                	jne    801006f1 <cgaputc+0x88>
    pos += 80 - pos%80;
801006c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006c4:	ba 67 66 66 66       	mov    $0x66666667,%edx
801006c9:	89 c8                	mov    %ecx,%eax
801006cb:	f7 ea                	imul   %edx
801006cd:	c1 fa 05             	sar    $0x5,%edx
801006d0:	89 c8                	mov    %ecx,%eax
801006d2:	c1 f8 1f             	sar    $0x1f,%eax
801006d5:	29 c2                	sub    %eax,%edx
801006d7:	89 d0                	mov    %edx,%eax
801006d9:	c1 e0 02             	shl    $0x2,%eax
801006dc:	01 d0                	add    %edx,%eax
801006de:	c1 e0 04             	shl    $0x4,%eax
801006e1:	29 c1                	sub    %eax,%ecx
801006e3:	89 ca                	mov    %ecx,%edx
801006e5:	b8 50 00 00 00       	mov    $0x50,%eax
801006ea:	29 d0                	sub    %edx,%eax
801006ec:	01 45 f4             	add    %eax,-0xc(%ebp)
801006ef:	eb 38                	jmp    80100729 <cgaputc+0xc0>
  else if(c == BACKSPACE){
801006f1:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006f8:	75 0c                	jne    80100706 <cgaputc+0x9d>
    if(pos > 0) --pos;
801006fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006fe:	7e 29                	jle    80100729 <cgaputc+0xc0>
80100700:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100704:	eb 23                	jmp    80100729 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100706:	8b 45 08             	mov    0x8(%ebp),%eax
80100709:	0f b6 c0             	movzbl %al,%eax
8010070c:	80 cc 07             	or     $0x7,%ah
8010070f:	89 c3                	mov    %eax,%ebx
80100711:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010071a:	8d 50 01             	lea    0x1(%eax),%edx
8010071d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100720:	01 c0                	add    %eax,%eax
80100722:	01 c8                	add    %ecx,%eax
80100724:	89 da                	mov    %ebx,%edx
80100726:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
80100729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010072d:	78 09                	js     80100738 <cgaputc+0xcf>
8010072f:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100736:	7e 0d                	jle    80100745 <cgaputc+0xdc>
    panic("pos under/overflow");
80100738:	83 ec 0c             	sub    $0xc,%esp
8010073b:	68 5b 87 10 80       	push   $0x8010875b
80100740:	e8 8c fe ff ff       	call   801005d1 <panic>

  if((pos/80) >= 24){  // Scroll up.
80100745:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010074c:	7e 4c                	jle    8010079a <cgaputc+0x131>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010074e:	a1 00 90 10 80       	mov    0x80109000,%eax
80100753:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100759:	a1 00 90 10 80       	mov    0x80109000,%eax
8010075e:	83 ec 04             	sub    $0x4,%esp
80100761:	68 60 0e 00 00       	push   $0xe60
80100766:	52                   	push   %edx
80100767:	50                   	push   %eax
80100768:	e8 d7 4d 00 00       	call   80105544 <memmove>
8010076d:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100770:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100774:	b8 80 07 00 00       	mov    $0x780,%eax
80100779:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010077c:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010077f:	a1 00 90 10 80       	mov    0x80109000,%eax
80100784:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100787:	01 c9                	add    %ecx,%ecx
80100789:	01 c8                	add    %ecx,%eax
8010078b:	83 ec 04             	sub    $0x4,%esp
8010078e:	52                   	push   %edx
8010078f:	6a 00                	push   $0x0
80100791:	50                   	push   %eax
80100792:	e8 e6 4c 00 00       	call   8010547d <memset>
80100797:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
8010079a:	83 ec 08             	sub    $0x8,%esp
8010079d:	6a 0e                	push   $0xe
8010079f:	68 d4 03 00 00       	push   $0x3d4
801007a4:	e8 97 fb ff ff       	call   80100340 <outb>
801007a9:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
801007ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007af:	c1 f8 08             	sar    $0x8,%eax
801007b2:	0f b6 c0             	movzbl %al,%eax
801007b5:	83 ec 08             	sub    $0x8,%esp
801007b8:	50                   	push   %eax
801007b9:	68 d5 03 00 00       	push   $0x3d5
801007be:	e8 7d fb ff ff       	call   80100340 <outb>
801007c3:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007c6:	83 ec 08             	sub    $0x8,%esp
801007c9:	6a 0f                	push   $0xf
801007cb:	68 d4 03 00 00       	push   $0x3d4
801007d0:	e8 6b fb ff ff       	call   80100340 <outb>
801007d5:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007db:	0f b6 c0             	movzbl %al,%eax
801007de:	83 ec 08             	sub    $0x8,%esp
801007e1:	50                   	push   %eax
801007e2:	68 d5 03 00 00       	push   $0x3d5
801007e7:	e8 54 fb ff ff       	call   80100340 <outb>
801007ec:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007ef:	a1 00 90 10 80       	mov    0x80109000,%eax
801007f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007f7:	01 d2                	add    %edx,%edx
801007f9:	01 d0                	add    %edx,%eax
801007fb:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100800:	90                   	nop
80100801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100804:	c9                   	leave  
80100805:	c3                   	ret    

80100806 <consputc>:

void
consputc(int c)
{
80100806:	f3 0f 1e fb          	endbr32 
8010080a:	55                   	push   %ebp
8010080b:	89 e5                	mov    %esp,%ebp
8010080d:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100810:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80100815:	85 c0                	test   %eax,%eax
80100817:	74 07                	je     80100820 <consputc+0x1a>
    cli();
80100819:	e8 43 fb ff ff       	call   80100361 <cli>
    for(;;)
8010081e:	eb fe                	jmp    8010081e <consputc+0x18>
      ;
  }

  if(c == BACKSPACE){
80100820:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100827:	75 29                	jne    80100852 <consputc+0x4c>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	6a 08                	push   $0x8
8010082e:	e8 37 66 00 00       	call   80106e6a <uartputc>
80100833:	83 c4 10             	add    $0x10,%esp
80100836:	83 ec 0c             	sub    $0xc,%esp
80100839:	6a 20                	push   $0x20
8010083b:	e8 2a 66 00 00       	call   80106e6a <uartputc>
80100840:	83 c4 10             	add    $0x10,%esp
80100843:	83 ec 0c             	sub    $0xc,%esp
80100846:	6a 08                	push   $0x8
80100848:	e8 1d 66 00 00       	call   80106e6a <uartputc>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	eb 0e                	jmp    80100860 <consputc+0x5a>
  } else
    uartputc(c);
80100852:	83 ec 0c             	sub    $0xc,%esp
80100855:	ff 75 08             	pushl  0x8(%ebp)
80100858:	e8 0d 66 00 00       	call   80106e6a <uartputc>
8010085d:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	ff 75 08             	pushl  0x8(%ebp)
80100866:	e8 fe fd ff ff       	call   80100669 <cgaputc>
8010086b:	83 c4 10             	add    $0x10,%esp
}
8010086e:	90                   	nop
8010086f:	c9                   	leave  
80100870:	c3                   	ret    

80100871 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100871:	f3 0f 1e fb          	endbr32 
80100875:	55                   	push   %ebp
80100876:	89 e5                	mov    %esp,%ebp
80100878:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
8010087b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100882:	83 ec 0c             	sub    $0xc,%esp
80100885:	68 a0 b5 10 80       	push   $0x8010b5a0
8010088a:	e8 4f 49 00 00       	call   801051de <acquire>
8010088f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100892:	e9 52 01 00 00       	jmp    801009e9 <consoleintr+0x178>
    switch(c){
80100897:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
8010089b:	0f 84 81 00 00 00    	je     80100922 <consoleintr+0xb1>
801008a1:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801008a5:	0f 8f ac 00 00 00    	jg     80100957 <consoleintr+0xe6>
801008ab:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008af:	74 43                	je     801008f4 <consoleintr+0x83>
801008b1:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008b5:	0f 8f 9c 00 00 00    	jg     80100957 <consoleintr+0xe6>
801008bb:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
801008bf:	74 61                	je     80100922 <consoleintr+0xb1>
801008c1:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
801008c5:	0f 85 8c 00 00 00    	jne    80100957 <consoleintr+0xe6>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
801008cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
801008d2:	e9 12 01 00 00       	jmp    801009e9 <consoleintr+0x178>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d7:	a1 28 10 11 80       	mov    0x80111028,%eax
801008dc:	83 e8 01             	sub    $0x1,%eax
801008df:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
801008e4:	83 ec 0c             	sub    $0xc,%esp
801008e7:	68 00 01 00 00       	push   $0x100
801008ec:	e8 15 ff ff ff       	call   80100806 <consputc>
801008f1:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
801008f4:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801008fa:	a1 24 10 11 80       	mov    0x80111024,%eax
801008ff:	39 c2                	cmp    %eax,%edx
80100901:	0f 84 e2 00 00 00    	je     801009e9 <consoleintr+0x178>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100907:	a1 28 10 11 80       	mov    0x80111028,%eax
8010090c:	83 e8 01             	sub    $0x1,%eax
8010090f:	83 e0 7f             	and    $0x7f,%eax
80100912:	0f b6 80 a0 0f 11 80 	movzbl -0x7feef060(%eax),%eax
      while(input.e != input.w &&
80100919:	3c 0a                	cmp    $0xa,%al
8010091b:	75 ba                	jne    801008d7 <consoleintr+0x66>
      }
      break;
8010091d:	e9 c7 00 00 00       	jmp    801009e9 <consoleintr+0x178>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100922:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100928:	a1 24 10 11 80       	mov    0x80111024,%eax
8010092d:	39 c2                	cmp    %eax,%edx
8010092f:	0f 84 b4 00 00 00    	je     801009e9 <consoleintr+0x178>
        input.e--;
80100935:	a1 28 10 11 80       	mov    0x80111028,%eax
8010093a:	83 e8 01             	sub    $0x1,%eax
8010093d:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100942:	83 ec 0c             	sub    $0xc,%esp
80100945:	68 00 01 00 00       	push   $0x100
8010094a:	e8 b7 fe ff ff       	call   80100806 <consputc>
8010094f:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100952:	e9 92 00 00 00       	jmp    801009e9 <consoleintr+0x178>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100957:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010095b:	0f 84 87 00 00 00    	je     801009e8 <consoleintr+0x177>
80100961:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100967:	a1 20 10 11 80       	mov    0x80111020,%eax
8010096c:	29 c2                	sub    %eax,%edx
8010096e:	89 d0                	mov    %edx,%eax
80100970:	83 f8 7f             	cmp    $0x7f,%eax
80100973:	77 73                	ja     801009e8 <consoleintr+0x177>
        c = (c == '\r') ? '\n' : c;
80100975:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100979:	74 05                	je     80100980 <consoleintr+0x10f>
8010097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010097e:	eb 05                	jmp    80100985 <consoleintr+0x114>
80100980:	b8 0a 00 00 00       	mov    $0xa,%eax
80100985:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100988:	a1 28 10 11 80       	mov    0x80111028,%eax
8010098d:	8d 50 01             	lea    0x1(%eax),%edx
80100990:	89 15 28 10 11 80    	mov    %edx,0x80111028
80100996:	83 e0 7f             	and    $0x7f,%eax
80100999:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010099c:	88 90 a0 0f 11 80    	mov    %dl,-0x7feef060(%eax)
        consputc(c);
801009a2:	83 ec 0c             	sub    $0xc,%esp
801009a5:	ff 75 f0             	pushl  -0x10(%ebp)
801009a8:	e8 59 fe ff ff       	call   80100806 <consputc>
801009ad:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009b0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009b4:	74 18                	je     801009ce <consoleintr+0x15d>
801009b6:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009ba:	74 12                	je     801009ce <consoleintr+0x15d>
801009bc:	a1 28 10 11 80       	mov    0x80111028,%eax
801009c1:	8b 15 20 10 11 80    	mov    0x80111020,%edx
801009c7:	83 ea 80             	sub    $0xffffff80,%edx
801009ca:	39 d0                	cmp    %edx,%eax
801009cc:	75 1a                	jne    801009e8 <consoleintr+0x177>
          input.w = input.e;
801009ce:	a1 28 10 11 80       	mov    0x80111028,%eax
801009d3:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
801009d8:	83 ec 0c             	sub    $0xc,%esp
801009db:	68 20 10 11 80       	push   $0x80111020
801009e0:	e8 7f 44 00 00       	call   80104e64 <wakeup>
801009e5:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009e8:	90                   	nop
  while((c = getc()) >= 0){
801009e9:	8b 45 08             	mov    0x8(%ebp),%eax
801009ec:	ff d0                	call   *%eax
801009ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
801009f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009f5:	0f 89 9c fe ff ff    	jns    80100897 <consoleintr+0x26>
    }
  }
  release(&cons.lock);
801009fb:	83 ec 0c             	sub    $0xc,%esp
801009fe:	68 a0 b5 10 80       	push   $0x8010b5a0
80100a03:	e8 48 48 00 00       	call   80105250 <release>
80100a08:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a0f:	74 05                	je     80100a16 <consoleintr+0x1a5>
    procdump();  // now call procdump() wo. cons.lock held
80100a11:	e8 11 45 00 00       	call   80104f27 <procdump>
  }
}
80100a16:	90                   	nop
80100a17:	c9                   	leave  
80100a18:	c3                   	ret    

80100a19 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n, uint off)
{
80100a19:	f3 0f 1e fb          	endbr32 
80100a1d:	55                   	push   %ebp
80100a1e:	89 e5                	mov    %esp,%ebp
80100a20:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a23:	83 ec 0c             	sub    $0xc,%esp
80100a26:	ff 75 08             	pushl  0x8(%ebp)
80100a29:	e8 f7 11 00 00       	call   80101c25 <iunlock>
80100a2e:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a31:	8b 45 10             	mov    0x10(%ebp),%eax
80100a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a37:	83 ec 0c             	sub    $0xc,%esp
80100a3a:	68 a0 b5 10 80       	push   $0x8010b5a0
80100a3f:	e8 9a 47 00 00       	call   801051de <acquire>
80100a44:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a47:	e9 ab 00 00 00       	jmp    80100af7 <consoleread+0xde>
    while(input.r == input.w){
      if(myproc()->killed){
80100a4c:	e8 4b 3a 00 00       	call   8010449c <myproc>
80100a51:	8b 40 24             	mov    0x24(%eax),%eax
80100a54:	85 c0                	test   %eax,%eax
80100a56:	74 28                	je     80100a80 <consoleread+0x67>
        release(&cons.lock);
80100a58:	83 ec 0c             	sub    $0xc,%esp
80100a5b:	68 a0 b5 10 80       	push   $0x8010b5a0
80100a60:	e8 eb 47 00 00       	call   80105250 <release>
80100a65:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a68:	83 ec 0c             	sub    $0xc,%esp
80100a6b:	ff 75 08             	pushl  0x8(%ebp)
80100a6e:	e8 9b 10 00 00       	call   80101b0e <ilock>
80100a73:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a7b:	e9 ab 00 00 00       	jmp    80100b2b <consoleread+0x112>
      }
      sleep(&input.r, &cons.lock);
80100a80:	83 ec 08             	sub    $0x8,%esp
80100a83:	68 a0 b5 10 80       	push   $0x8010b5a0
80100a88:	68 20 10 11 80       	push   $0x80111020
80100a8d:	e8 e3 42 00 00       	call   80104d75 <sleep>
80100a92:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a95:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100a9b:	a1 24 10 11 80       	mov    0x80111024,%eax
80100aa0:	39 c2                	cmp    %eax,%edx
80100aa2:	74 a8                	je     80100a4c <consoleread+0x33>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100aa4:	a1 20 10 11 80       	mov    0x80111020,%eax
80100aa9:	8d 50 01             	lea    0x1(%eax),%edx
80100aac:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100ab2:	83 e0 7f             	and    $0x7f,%eax
80100ab5:	0f b6 80 a0 0f 11 80 	movzbl -0x7feef060(%eax),%eax
80100abc:	0f be c0             	movsbl %al,%eax
80100abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ac2:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ac6:	75 17                	jne    80100adf <consoleread+0xc6>
      if(n < target){
80100ac8:	8b 45 10             	mov    0x10(%ebp),%eax
80100acb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100ace:	76 2f                	jbe    80100aff <consoleread+0xe6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ad0:	a1 20 10 11 80       	mov    0x80111020,%eax
80100ad5:	83 e8 01             	sub    $0x1,%eax
80100ad8:	a3 20 10 11 80       	mov    %eax,0x80111020
      }
      break;
80100add:	eb 20                	jmp    80100aff <consoleread+0xe6>
    }
    *dst++ = c;
80100adf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ae2:	8d 50 01             	lea    0x1(%eax),%edx
80100ae5:	89 55 0c             	mov    %edx,0xc(%ebp)
80100ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100aeb:	88 10                	mov    %dl,(%eax)
    --n;
80100aed:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100af1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100af5:	74 0b                	je     80100b02 <consoleread+0xe9>
  while(n > 0){
80100af7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100afb:	7f 98                	jg     80100a95 <consoleread+0x7c>
80100afd:	eb 04                	jmp    80100b03 <consoleread+0xea>
      break;
80100aff:	90                   	nop
80100b00:	eb 01                	jmp    80100b03 <consoleread+0xea>
      break;
80100b02:	90                   	nop
  }
  release(&cons.lock);
80100b03:	83 ec 0c             	sub    $0xc,%esp
80100b06:	68 a0 b5 10 80       	push   $0x8010b5a0
80100b0b:	e8 40 47 00 00       	call   80105250 <release>
80100b10:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b13:	83 ec 0c             	sub    $0xc,%esp
80100b16:	ff 75 08             	pushl  0x8(%ebp)
80100b19:	e8 f0 0f 00 00       	call   80101b0e <ilock>
80100b1e:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b21:	8b 45 10             	mov    0x10(%ebp),%eax
80100b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b27:	29 c2                	sub    %eax,%edx
80100b29:	89 d0                	mov    %edx,%eax
}
80100b2b:	c9                   	leave  
80100b2c:	c3                   	ret    

80100b2d <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n, uint off)
{
80100b2d:	f3 0f 1e fb          	endbr32 
80100b31:	55                   	push   %ebp
80100b32:	89 e5                	mov    %esp,%ebp
80100b34:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	ff 75 08             	pushl  0x8(%ebp)
80100b3d:	e8 e3 10 00 00       	call   80101c25 <iunlock>
80100b42:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b45:	83 ec 0c             	sub    $0xc,%esp
80100b48:	68 a0 b5 10 80       	push   $0x8010b5a0
80100b4d:	e8 8c 46 00 00       	call   801051de <acquire>
80100b52:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b5c:	eb 21                	jmp    80100b7f <consolewrite+0x52>
    consputc(buf[i] & 0xff);
80100b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b61:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b64:	01 d0                	add    %edx,%eax
80100b66:	0f b6 00             	movzbl (%eax),%eax
80100b69:	0f be c0             	movsbl %al,%eax
80100b6c:	0f b6 c0             	movzbl %al,%eax
80100b6f:	83 ec 0c             	sub    $0xc,%esp
80100b72:	50                   	push   %eax
80100b73:	e8 8e fc ff ff       	call   80100806 <consputc>
80100b78:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b7b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b82:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b85:	7c d7                	jl     80100b5e <consolewrite+0x31>
  release(&cons.lock);
80100b87:	83 ec 0c             	sub    $0xc,%esp
80100b8a:	68 a0 b5 10 80       	push   $0x8010b5a0
80100b8f:	e8 bc 46 00 00       	call   80105250 <release>
80100b94:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b97:	83 ec 0c             	sub    $0xc,%esp
80100b9a:	ff 75 08             	pushl  0x8(%ebp)
80100b9d:	e8 6c 0f 00 00       	call   80101b0e <ilock>
80100ba2:	83 c4 10             	add    $0x10,%esp

  return n;
80100ba5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ba8:	c9                   	leave  
80100ba9:	c3                   	ret    

80100baa <consoleinit>:

void
consoleinit(void)
{
80100baa:	f3 0f 1e fb          	endbr32 
80100bae:	55                   	push   %ebp
80100baf:	89 e5                	mov    %esp,%ebp
80100bb1:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bb4:	83 ec 08             	sub    $0x8,%esp
80100bb7:	68 6e 87 10 80       	push   $0x8010876e
80100bbc:	68 a0 b5 10 80       	push   $0x8010b5a0
80100bc1:	e8 f2 45 00 00       	call   801051b8 <initlock>
80100bc6:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bc9:	c7 05 ec 19 11 80 2d 	movl   $0x80100b2d,0x801119ec
80100bd0:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bd3:	c7 05 e8 19 11 80 19 	movl   $0x80100a19,0x801119e8
80100bda:	0a 10 80 
  cons.locking = 1;
80100bdd:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100be4:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100be7:	83 ec 08             	sub    $0x8,%esp
80100bea:	6a 00                	push   $0x0
80100bec:	6a 01                	push   $0x1
80100bee:	e8 85 20 00 00       	call   80102c78 <ioapicenable>
80100bf3:	83 c4 10             	add    $0x10,%esp
}
80100bf6:	90                   	nop
80100bf7:	c9                   	leave  
80100bf8:	c3                   	ret    

80100bf9 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bf9:	f3 0f 1e fb          	endbr32 
80100bfd:	55                   	push   %ebp
80100bfe:	89 e5                	mov    %esp,%ebp
80100c00:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c06:	e8 91 38 00 00       	call   8010449c <myproc>
80100c0b:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100c0e:	e8 ca 2a 00 00       	call   801036dd <begin_op>

  if((ip = namei(path)) == 0){
80100c13:	83 ec 0c             	sub    $0xc,%esp
80100c16:	ff 75 08             	pushl  0x8(%ebp)
80100c19:	e8 5b 1a 00 00       	call   80102679 <namei>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c24:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c28:	75 1f                	jne    80100c49 <exec+0x50>
    end_op();
80100c2a:	e8 3e 2b 00 00       	call   8010376d <end_op>
    cprintf("exec: fail\n");
80100c2f:	83 ec 0c             	sub    $0xc,%esp
80100c32:	68 76 87 10 80       	push   $0x80108776
80100c37:	e8 dc f7 ff ff       	call   80100418 <cprintf>
80100c3c:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c44:	e9 f1 03 00 00       	jmp    8010103a <exec+0x441>
  }
  ilock(ip);
80100c49:	83 ec 0c             	sub    $0xc,%esp
80100c4c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c4f:	e8 ba 0e 00 00       	call   80101b0e <ilock>
80100c54:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c57:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c5e:	6a 34                	push   $0x34
80100c60:	6a 00                	push   $0x0
80100c62:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c68:	50                   	push   %eax
80100c69:	ff 75 d8             	pushl  -0x28(%ebp)
80100c6c:	e8 a5 13 00 00       	call   80102016 <readi>
80100c71:	83 c4 10             	add    $0x10,%esp
80100c74:	83 f8 34             	cmp    $0x34,%eax
80100c77:	0f 85 66 03 00 00    	jne    80100fe3 <exec+0x3ea>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c7d:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c83:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c88:	0f 85 58 03 00 00    	jne    80100fe6 <exec+0x3ed>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c8e:	e8 eb 71 00 00       	call   80107e7e <setupkvm>
80100c93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c96:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c9a:	0f 84 49 03 00 00    	je     80100fe9 <exec+0x3f0>
    goto bad;

  // Load program into memory.
  sz = 0;
80100ca0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ca7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100cae:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100cb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cb7:	e9 de 00 00 00       	jmp    80100d9a <exec+0x1a1>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cbf:	6a 20                	push   $0x20
80100cc1:	50                   	push   %eax
80100cc2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100cc8:	50                   	push   %eax
80100cc9:	ff 75 d8             	pushl  -0x28(%ebp)
80100ccc:	e8 45 13 00 00       	call   80102016 <readi>
80100cd1:	83 c4 10             	add    $0x10,%esp
80100cd4:	83 f8 20             	cmp    $0x20,%eax
80100cd7:	0f 85 0f 03 00 00    	jne    80100fec <exec+0x3f3>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cdd:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100ce3:	83 f8 01             	cmp    $0x1,%eax
80100ce6:	0f 85 a0 00 00 00    	jne    80100d8c <exec+0x193>
      continue;
    if(ph.memsz < ph.filesz)
80100cec:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cf2:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100cf8:	39 c2                	cmp    %eax,%edx
80100cfa:	0f 82 ef 02 00 00    	jb     80100fef <exec+0x3f6>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d00:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d06:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d0c:	01 c2                	add    %eax,%edx
80100d0e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d14:	39 c2                	cmp    %eax,%edx
80100d16:	0f 82 d6 02 00 00    	jb     80100ff2 <exec+0x3f9>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d1c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d22:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d28:	01 d0                	add    %edx,%eax
80100d2a:	83 ec 04             	sub    $0x4,%esp
80100d2d:	50                   	push   %eax
80100d2e:	ff 75 e0             	pushl  -0x20(%ebp)
80100d31:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d34:	e8 03 75 00 00       	call   8010823c <allocuvm>
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d43:	0f 84 ac 02 00 00    	je     80100ff5 <exec+0x3fc>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d49:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d4f:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d54:	85 c0                	test   %eax,%eax
80100d56:	0f 85 9c 02 00 00    	jne    80100ff8 <exec+0x3ff>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d5c:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d62:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d68:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d6e:	83 ec 0c             	sub    $0xc,%esp
80100d71:	52                   	push   %edx
80100d72:	50                   	push   %eax
80100d73:	ff 75 d8             	pushl  -0x28(%ebp)
80100d76:	51                   	push   %ecx
80100d77:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d7a:	e8 ec 73 00 00       	call   8010816b <loaduvm>
80100d7f:	83 c4 20             	add    $0x20,%esp
80100d82:	85 c0                	test   %eax,%eax
80100d84:	0f 88 71 02 00 00    	js     80100ffb <exec+0x402>
80100d8a:	eb 01                	jmp    80100d8d <exec+0x194>
      continue;
80100d8c:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d8d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d94:	83 c0 20             	add    $0x20,%eax
80100d97:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d9a:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100da1:	0f b7 c0             	movzwl %ax,%eax
80100da4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100da7:	0f 8c 0f ff ff ff    	jl     80100cbc <exec+0xc3>
      goto bad;
  }
  iunlockput(ip);
80100dad:	83 ec 0c             	sub    $0xc,%esp
80100db0:	ff 75 d8             	pushl  -0x28(%ebp)
80100db3:	e8 93 0f 00 00       	call   80101d4b <iunlockput>
80100db8:	83 c4 10             	add    $0x10,%esp
  end_op();
80100dbb:	e8 ad 29 00 00       	call   8010376d <end_op>
  ip = 0;
80100dc0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100dc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dca:	05 ff 0f 00 00       	add    $0xfff,%eax
80100dcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100dd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dda:	05 00 20 00 00       	add    $0x2000,%eax
80100ddf:	83 ec 04             	sub    $0x4,%esp
80100de2:	50                   	push   %eax
80100de3:	ff 75 e0             	pushl  -0x20(%ebp)
80100de6:	ff 75 d4             	pushl  -0x2c(%ebp)
80100de9:	e8 4e 74 00 00       	call   8010823c <allocuvm>
80100dee:	83 c4 10             	add    $0x10,%esp
80100df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100df4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100df8:	0f 84 00 02 00 00    	je     80100ffe <exec+0x405>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e01:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e06:	83 ec 08             	sub    $0x8,%esp
80100e09:	50                   	push   %eax
80100e0a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e0d:	e8 98 76 00 00       	call   801084aa <clearpteu>
80100e12:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e18:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e22:	e9 96 00 00 00       	jmp    80100ebd <exec+0x2c4>
    if(argc >= MAXARG)
80100e27:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e2b:	0f 87 d0 01 00 00    	ja     80101001 <exec+0x408>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e3e:	01 d0                	add    %edx,%eax
80100e40:	8b 00                	mov    (%eax),%eax
80100e42:	83 ec 0c             	sub    $0xc,%esp
80100e45:	50                   	push   %eax
80100e46:	e8 9b 48 00 00       	call   801056e6 <strlen>
80100e4b:	83 c4 10             	add    $0x10,%esp
80100e4e:	89 c2                	mov    %eax,%edx
80100e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e53:	29 d0                	sub    %edx,%eax
80100e55:	83 e8 01             	sub    $0x1,%eax
80100e58:	83 e0 fc             	and    $0xfffffffc,%eax
80100e5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e68:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e6b:	01 d0                	add    %edx,%eax
80100e6d:	8b 00                	mov    (%eax),%eax
80100e6f:	83 ec 0c             	sub    $0xc,%esp
80100e72:	50                   	push   %eax
80100e73:	e8 6e 48 00 00       	call   801056e6 <strlen>
80100e78:	83 c4 10             	add    $0x10,%esp
80100e7b:	83 c0 01             	add    $0x1,%eax
80100e7e:	89 c1                	mov    %eax,%ecx
80100e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e8d:	01 d0                	add    %edx,%eax
80100e8f:	8b 00                	mov    (%eax),%eax
80100e91:	51                   	push   %ecx
80100e92:	50                   	push   %eax
80100e93:	ff 75 dc             	pushl  -0x24(%ebp)
80100e96:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e99:	e8 c4 77 00 00       	call   80108662 <copyout>
80100e9e:	83 c4 10             	add    $0x10,%esp
80100ea1:	85 c0                	test   %eax,%eax
80100ea3:	0f 88 5b 01 00 00    	js     80101004 <exec+0x40b>
      goto bad;
    ustack[3+argc] = sp;
80100ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eac:	8d 50 03             	lea    0x3(%eax),%edx
80100eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100eb2:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100eb9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eca:	01 d0                	add    %edx,%eax
80100ecc:	8b 00                	mov    (%eax),%eax
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	0f 85 51 ff ff ff    	jne    80100e27 <exec+0x22e>
  }
  ustack[3+argc] = 0;
80100ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed9:	83 c0 03             	add    $0x3,%eax
80100edc:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100ee3:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ee7:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100eee:	ff ff ff 
  ustack[1] = argc;
80100ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ef4:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100efd:	83 c0 01             	add    $0x1,%eax
80100f00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f07:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f0a:	29 d0                	sub    %edx,%eax
80100f0c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100f12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f15:	83 c0 04             	add    $0x4,%eax
80100f18:	c1 e0 02             	shl    $0x2,%eax
80100f1b:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f21:	83 c0 04             	add    $0x4,%eax
80100f24:	c1 e0 02             	shl    $0x2,%eax
80100f27:	50                   	push   %eax
80100f28:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100f2e:	50                   	push   %eax
80100f2f:	ff 75 dc             	pushl  -0x24(%ebp)
80100f32:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f35:	e8 28 77 00 00       	call   80108662 <copyout>
80100f3a:	83 c4 10             	add    $0x10,%esp
80100f3d:	85 c0                	test   %eax,%eax
80100f3f:	0f 88 c2 00 00 00    	js     80101007 <exec+0x40e>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f45:	8b 45 08             	mov    0x8(%ebp),%eax
80100f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f51:	eb 17                	jmp    80100f6a <exec+0x371>
    if(*s == '/')
80100f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f56:	0f b6 00             	movzbl (%eax),%eax
80100f59:	3c 2f                	cmp    $0x2f,%al
80100f5b:	75 09                	jne    80100f66 <exec+0x36d>
      last = s+1;
80100f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f60:	83 c0 01             	add    $0x1,%eax
80100f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6d:	0f b6 00             	movzbl (%eax),%eax
80100f70:	84 c0                	test   %al,%al
80100f72:	75 df                	jne    80100f53 <exec+0x35a>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f74:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f77:	83 c0 6c             	add    $0x6c,%eax
80100f7a:	83 ec 04             	sub    $0x4,%esp
80100f7d:	6a 10                	push   $0x10
80100f7f:	ff 75 f0             	pushl  -0x10(%ebp)
80100f82:	50                   	push   %eax
80100f83:	e8 10 47 00 00       	call   80105698 <safestrcpy>
80100f88:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f8b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f8e:	8b 40 04             	mov    0x4(%eax),%eax
80100f91:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f94:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f9a:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fa0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100fa3:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fa5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fa8:	8b 40 18             	mov    0x18(%eax),%eax
80100fab:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100fb1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100fb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fb7:	8b 40 18             	mov    0x18(%eax),%eax
80100fba:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100fbd:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100fc0:	83 ec 0c             	sub    $0xc,%esp
80100fc3:	ff 75 d0             	pushl  -0x30(%ebp)
80100fc6:	e8 89 6f 00 00       	call   80107f54 <switchuvm>
80100fcb:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fce:	83 ec 0c             	sub    $0xc,%esp
80100fd1:	ff 75 cc             	pushl  -0x34(%ebp)
80100fd4:	e8 34 74 00 00       	call   8010840d <freevm>
80100fd9:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fdc:	b8 00 00 00 00       	mov    $0x0,%eax
80100fe1:	eb 57                	jmp    8010103a <exec+0x441>
    goto bad;
80100fe3:	90                   	nop
80100fe4:	eb 22                	jmp    80101008 <exec+0x40f>
    goto bad;
80100fe6:	90                   	nop
80100fe7:	eb 1f                	jmp    80101008 <exec+0x40f>
    goto bad;
80100fe9:	90                   	nop
80100fea:	eb 1c                	jmp    80101008 <exec+0x40f>
      goto bad;
80100fec:	90                   	nop
80100fed:	eb 19                	jmp    80101008 <exec+0x40f>
      goto bad;
80100fef:	90                   	nop
80100ff0:	eb 16                	jmp    80101008 <exec+0x40f>
      goto bad;
80100ff2:	90                   	nop
80100ff3:	eb 13                	jmp    80101008 <exec+0x40f>
      goto bad;
80100ff5:	90                   	nop
80100ff6:	eb 10                	jmp    80101008 <exec+0x40f>
      goto bad;
80100ff8:	90                   	nop
80100ff9:	eb 0d                	jmp    80101008 <exec+0x40f>
      goto bad;
80100ffb:	90                   	nop
80100ffc:	eb 0a                	jmp    80101008 <exec+0x40f>
    goto bad;
80100ffe:	90                   	nop
80100fff:	eb 07                	jmp    80101008 <exec+0x40f>
      goto bad;
80101001:	90                   	nop
80101002:	eb 04                	jmp    80101008 <exec+0x40f>
      goto bad;
80101004:	90                   	nop
80101005:	eb 01                	jmp    80101008 <exec+0x40f>
    goto bad;
80101007:	90                   	nop

 bad:
  if(pgdir)
80101008:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010100c:	74 0e                	je     8010101c <exec+0x423>
    freevm(pgdir);
8010100e:	83 ec 0c             	sub    $0xc,%esp
80101011:	ff 75 d4             	pushl  -0x2c(%ebp)
80101014:	e8 f4 73 00 00       	call   8010840d <freevm>
80101019:	83 c4 10             	add    $0x10,%esp
  if(ip){
8010101c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101020:	74 13                	je     80101035 <exec+0x43c>
    iunlockput(ip);
80101022:	83 ec 0c             	sub    $0xc,%esp
80101025:	ff 75 d8             	pushl  -0x28(%ebp)
80101028:	e8 1e 0d 00 00       	call   80101d4b <iunlockput>
8010102d:	83 c4 10             	add    $0x10,%esp
    end_op();
80101030:	e8 38 27 00 00       	call   8010376d <end_op>
  }
  return -1;
80101035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010103a:	c9                   	leave  
8010103b:	c3                   	ret    

8010103c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
8010103c:	f3 0f 1e fb          	endbr32 
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101046:	83 ec 08             	sub    $0x8,%esp
80101049:	68 82 87 10 80       	push   $0x80108782
8010104e:	68 40 10 11 80       	push   $0x80111040
80101053:	e8 60 41 00 00       	call   801051b8 <initlock>
80101058:	83 c4 10             	add    $0x10,%esp
}
8010105b:	90                   	nop
8010105c:	c9                   	leave  
8010105d:	c3                   	ret    

8010105e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010105e:	f3 0f 1e fb          	endbr32 
80101062:	55                   	push   %ebp
80101063:	89 e5                	mov    %esp,%ebp
80101065:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	68 40 10 11 80       	push   $0x80111040
80101070:	e8 69 41 00 00       	call   801051de <acquire>
80101075:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101078:	c7 45 f4 74 10 11 80 	movl   $0x80111074,-0xc(%ebp)
8010107f:	eb 2d                	jmp    801010ae <filealloc+0x50>
    if(f->ref == 0){
80101081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101084:	8b 40 04             	mov    0x4(%eax),%eax
80101087:	85 c0                	test   %eax,%eax
80101089:	75 1f                	jne    801010aa <filealloc+0x4c>
      f->ref = 1;
8010108b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010108e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101095:	83 ec 0c             	sub    $0xc,%esp
80101098:	68 40 10 11 80       	push   $0x80111040
8010109d:	e8 ae 41 00 00       	call   80105250 <release>
801010a2:	83 c4 10             	add    $0x10,%esp
      return f;
801010a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010a8:	eb 23                	jmp    801010cd <filealloc+0x6f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010aa:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
801010ae:	b8 d4 19 11 80       	mov    $0x801119d4,%eax
801010b3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801010b6:	72 c9                	jb     80101081 <filealloc+0x23>
    }
  }
  release(&ftable.lock);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	68 40 10 11 80       	push   $0x80111040
801010c0:	e8 8b 41 00 00       	call   80105250 <release>
801010c5:	83 c4 10             	add    $0x10,%esp
  return 0;
801010c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010cd:	c9                   	leave  
801010ce:	c3                   	ret    

801010cf <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010cf:	f3 0f 1e fb          	endbr32 
801010d3:	55                   	push   %ebp
801010d4:	89 e5                	mov    %esp,%ebp
801010d6:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010d9:	83 ec 0c             	sub    $0xc,%esp
801010dc:	68 40 10 11 80       	push   $0x80111040
801010e1:	e8 f8 40 00 00       	call   801051de <acquire>
801010e6:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010e9:	8b 45 08             	mov    0x8(%ebp),%eax
801010ec:	8b 40 04             	mov    0x4(%eax),%eax
801010ef:	85 c0                	test   %eax,%eax
801010f1:	7f 0d                	jg     80101100 <filedup+0x31>
    panic("filedup");
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	68 89 87 10 80       	push   $0x80108789
801010fb:	e8 d1 f4 ff ff       	call   801005d1 <panic>
  f->ref++;
80101100:	8b 45 08             	mov    0x8(%ebp),%eax
80101103:	8b 40 04             	mov    0x4(%eax),%eax
80101106:	8d 50 01             	lea    0x1(%eax),%edx
80101109:	8b 45 08             	mov    0x8(%ebp),%eax
8010110c:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 40 10 11 80       	push   $0x80111040
80101117:	e8 34 41 00 00       	call   80105250 <release>
8010111c:	83 c4 10             	add    $0x10,%esp
  return f;
8010111f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101122:	c9                   	leave  
80101123:	c3                   	ret    

80101124 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101124:	f3 0f 1e fb          	endbr32 
80101128:	55                   	push   %ebp
80101129:	89 e5                	mov    %esp,%ebp
8010112b:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010112e:	83 ec 0c             	sub    $0xc,%esp
80101131:	68 40 10 11 80       	push   $0x80111040
80101136:	e8 a3 40 00 00       	call   801051de <acquire>
8010113b:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010113e:	8b 45 08             	mov    0x8(%ebp),%eax
80101141:	8b 40 04             	mov    0x4(%eax),%eax
80101144:	85 c0                	test   %eax,%eax
80101146:	7f 0d                	jg     80101155 <fileclose+0x31>
    panic("fileclose");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 91 87 10 80       	push   $0x80108791
80101150:	e8 7c f4 ff ff       	call   801005d1 <panic>
  if(--f->ref > 0){
80101155:	8b 45 08             	mov    0x8(%ebp),%eax
80101158:	8b 40 04             	mov    0x4(%eax),%eax
8010115b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010115e:	8b 45 08             	mov    0x8(%ebp),%eax
80101161:	89 50 04             	mov    %edx,0x4(%eax)
80101164:	8b 45 08             	mov    0x8(%ebp),%eax
80101167:	8b 40 04             	mov    0x4(%eax),%eax
8010116a:	85 c0                	test   %eax,%eax
8010116c:	7e 15                	jle    80101183 <fileclose+0x5f>
    release(&ftable.lock);
8010116e:	83 ec 0c             	sub    $0xc,%esp
80101171:	68 40 10 11 80       	push   $0x80111040
80101176:	e8 d5 40 00 00       	call   80105250 <release>
8010117b:	83 c4 10             	add    $0x10,%esp
8010117e:	e9 8b 00 00 00       	jmp    8010120e <fileclose+0xea>
    return;
  }
  ff = *f;
80101183:	8b 45 08             	mov    0x8(%ebp),%eax
80101186:	8b 10                	mov    (%eax),%edx
80101188:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010118b:	8b 50 04             	mov    0x4(%eax),%edx
8010118e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101191:	8b 50 08             	mov    0x8(%eax),%edx
80101194:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101197:	8b 50 0c             	mov    0xc(%eax),%edx
8010119a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010119d:	8b 50 10             	mov    0x10(%eax),%edx
801011a0:	89 55 f0             	mov    %edx,-0x10(%ebp)
801011a3:	8b 40 14             	mov    0x14(%eax),%eax
801011a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801011b3:	8b 45 08             	mov    0x8(%ebp),%eax
801011b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801011bc:	83 ec 0c             	sub    $0xc,%esp
801011bf:	68 40 10 11 80       	push   $0x80111040
801011c4:	e8 87 40 00 00       	call   80105250 <release>
801011c9:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
801011cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011cf:	83 f8 01             	cmp    $0x1,%eax
801011d2:	75 19                	jne    801011ed <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
801011d4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801011d8:	0f be d0             	movsbl %al,%edx
801011db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011de:	83 ec 08             	sub    $0x8,%esp
801011e1:	52                   	push   %edx
801011e2:	50                   	push   %eax
801011e3:	e8 2b 2f 00 00       	call   80104113 <pipeclose>
801011e8:	83 c4 10             	add    $0x10,%esp
801011eb:	eb 21                	jmp    8010120e <fileclose+0xea>
  else if(ff.type == FD_INODE){
801011ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011f0:	83 f8 02             	cmp    $0x2,%eax
801011f3:	75 19                	jne    8010120e <fileclose+0xea>
    begin_op();
801011f5:	e8 e3 24 00 00       	call   801036dd <begin_op>
    iput(ff.ip);
801011fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011fd:	83 ec 0c             	sub    $0xc,%esp
80101200:	50                   	push   %eax
80101201:	e8 71 0a 00 00       	call   80101c77 <iput>
80101206:	83 c4 10             	add    $0x10,%esp
    end_op();
80101209:	e8 5f 25 00 00       	call   8010376d <end_op>
  }
}
8010120e:	c9                   	leave  
8010120f:	c3                   	ret    

80101210 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101210:	f3 0f 1e fb          	endbr32 
80101214:	55                   	push   %ebp
80101215:	89 e5                	mov    %esp,%ebp
80101217:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010121a:	8b 45 08             	mov    0x8(%ebp),%eax
8010121d:	8b 00                	mov    (%eax),%eax
8010121f:	83 f8 02             	cmp    $0x2,%eax
80101222:	75 40                	jne    80101264 <filestat+0x54>
    ilock(f->ip);
80101224:	8b 45 08             	mov    0x8(%ebp),%eax
80101227:	8b 40 10             	mov    0x10(%eax),%eax
8010122a:	83 ec 0c             	sub    $0xc,%esp
8010122d:	50                   	push   %eax
8010122e:	e8 db 08 00 00       	call   80101b0e <ilock>
80101233:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101236:	8b 45 08             	mov    0x8(%ebp),%eax
80101239:	8b 40 10             	mov    0x10(%eax),%eax
8010123c:	83 ec 08             	sub    $0x8,%esp
8010123f:	ff 75 0c             	pushl  0xc(%ebp)
80101242:	50                   	push   %eax
80101243:	e8 84 0d 00 00       	call   80101fcc <stati>
80101248:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010124b:	8b 45 08             	mov    0x8(%ebp),%eax
8010124e:	8b 40 10             	mov    0x10(%eax),%eax
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	50                   	push   %eax
80101255:	e8 cb 09 00 00       	call   80101c25 <iunlock>
8010125a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010125d:	b8 00 00 00 00       	mov    $0x0,%eax
80101262:	eb 05                	jmp    80101269 <filestat+0x59>
  }
  return -1;
80101264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101269:	c9                   	leave  
8010126a:	c3                   	ret    

8010126b <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010126b:	f3 0f 1e fb          	endbr32 
8010126f:	55                   	push   %ebp
80101270:	89 e5                	mov    %esp,%ebp
80101272:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010127c:	84 c0                	test   %al,%al
8010127e:	75 0a                	jne    8010128a <fileread+0x1f>
    return -1;
80101280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101285:	e9 9b 00 00 00       	jmp    80101325 <fileread+0xba>
  if(f->type == FD_PIPE)
8010128a:	8b 45 08             	mov    0x8(%ebp),%eax
8010128d:	8b 00                	mov    (%eax),%eax
8010128f:	83 f8 01             	cmp    $0x1,%eax
80101292:	75 1a                	jne    801012ae <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101294:	8b 45 08             	mov    0x8(%ebp),%eax
80101297:	8b 40 0c             	mov    0xc(%eax),%eax
8010129a:	83 ec 04             	sub    $0x4,%esp
8010129d:	ff 75 10             	pushl  0x10(%ebp)
801012a0:	ff 75 0c             	pushl  0xc(%ebp)
801012a3:	50                   	push   %eax
801012a4:	e8 1f 30 00 00       	call   801042c8 <piperead>
801012a9:	83 c4 10             	add    $0x10,%esp
801012ac:	eb 77                	jmp    80101325 <fileread+0xba>
  if(f->type == FD_INODE){
801012ae:	8b 45 08             	mov    0x8(%ebp),%eax
801012b1:	8b 00                	mov    (%eax),%eax
801012b3:	83 f8 02             	cmp    $0x2,%eax
801012b6:	75 60                	jne    80101318 <fileread+0xad>
    ilock(f->ip);
801012b8:	8b 45 08             	mov    0x8(%ebp),%eax
801012bb:	8b 40 10             	mov    0x10(%eax),%eax
801012be:	83 ec 0c             	sub    $0xc,%esp
801012c1:	50                   	push   %eax
801012c2:	e8 47 08 00 00       	call   80101b0e <ilock>
801012c7:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801012ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	8b 50 14             	mov    0x14(%eax),%edx
801012d3:	8b 45 08             	mov    0x8(%ebp),%eax
801012d6:	8b 40 10             	mov    0x10(%eax),%eax
801012d9:	51                   	push   %ecx
801012da:	52                   	push   %edx
801012db:	ff 75 0c             	pushl  0xc(%ebp)
801012de:	50                   	push   %eax
801012df:	e8 32 0d 00 00       	call   80102016 <readi>
801012e4:	83 c4 10             	add    $0x10,%esp
801012e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012ee:	7e 11                	jle    80101301 <fileread+0x96>
      f->off += r;
801012f0:	8b 45 08             	mov    0x8(%ebp),%eax
801012f3:	8b 50 14             	mov    0x14(%eax),%edx
801012f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012f9:	01 c2                	add    %eax,%edx
801012fb:	8b 45 08             	mov    0x8(%ebp),%eax
801012fe:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101301:	8b 45 08             	mov    0x8(%ebp),%eax
80101304:	8b 40 10             	mov    0x10(%eax),%eax
80101307:	83 ec 0c             	sub    $0xc,%esp
8010130a:	50                   	push   %eax
8010130b:	e8 15 09 00 00       	call   80101c25 <iunlock>
80101310:	83 c4 10             	add    $0x10,%esp
    return r;
80101313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101316:	eb 0d                	jmp    80101325 <fileread+0xba>
  }
  panic("fileread");
80101318:	83 ec 0c             	sub    $0xc,%esp
8010131b:	68 9b 87 10 80       	push   $0x8010879b
80101320:	e8 ac f2 ff ff       	call   801005d1 <panic>
}
80101325:	c9                   	leave  
80101326:	c3                   	ret    

80101327 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101327:	f3 0f 1e fb          	endbr32 
8010132b:	55                   	push   %ebp
8010132c:	89 e5                	mov    %esp,%ebp
8010132e:	53                   	push   %ebx
8010132f:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101332:	8b 45 08             	mov    0x8(%ebp),%eax
80101335:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101339:	84 c0                	test   %al,%al
8010133b:	75 0a                	jne    80101347 <filewrite+0x20>
    return -1;
8010133d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101342:	e9 1b 01 00 00       	jmp    80101462 <filewrite+0x13b>
  if(f->type == FD_PIPE)
80101347:	8b 45 08             	mov    0x8(%ebp),%eax
8010134a:	8b 00                	mov    (%eax),%eax
8010134c:	83 f8 01             	cmp    $0x1,%eax
8010134f:	75 1d                	jne    8010136e <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101351:	8b 45 08             	mov    0x8(%ebp),%eax
80101354:	8b 40 0c             	mov    0xc(%eax),%eax
80101357:	83 ec 04             	sub    $0x4,%esp
8010135a:	ff 75 10             	pushl  0x10(%ebp)
8010135d:	ff 75 0c             	pushl  0xc(%ebp)
80101360:	50                   	push   %eax
80101361:	e8 5c 2e 00 00       	call   801041c2 <pipewrite>
80101366:	83 c4 10             	add    $0x10,%esp
80101369:	e9 f4 00 00 00       	jmp    80101462 <filewrite+0x13b>
  if(f->type == FD_INODE){
8010136e:	8b 45 08             	mov    0x8(%ebp),%eax
80101371:	8b 00                	mov    (%eax),%eax
80101373:	83 f8 02             	cmp    $0x2,%eax
80101376:	0f 85 d9 00 00 00    	jne    80101455 <filewrite+0x12e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
8010137c:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010138a:	e9 a3 00 00 00       	jmp    80101432 <filewrite+0x10b>
      int n1 = n - i;
8010138f:	8b 45 10             	mov    0x10(%ebp),%eax
80101392:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101395:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101398:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010139b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010139e:	7e 06                	jle    801013a6 <filewrite+0x7f>
        n1 = max;
801013a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801013a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801013a6:	e8 32 23 00 00       	call   801036dd <begin_op>
      ilock(f->ip);
801013ab:	8b 45 08             	mov    0x8(%ebp),%eax
801013ae:	8b 40 10             	mov    0x10(%eax),%eax
801013b1:	83 ec 0c             	sub    $0xc,%esp
801013b4:	50                   	push   %eax
801013b5:	e8 54 07 00 00       	call   80101b0e <ilock>
801013ba:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801013bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801013c0:	8b 45 08             	mov    0x8(%ebp),%eax
801013c3:	8b 50 14             	mov    0x14(%eax),%edx
801013c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801013cc:	01 c3                	add    %eax,%ebx
801013ce:	8b 45 08             	mov    0x8(%ebp),%eax
801013d1:	8b 40 10             	mov    0x10(%eax),%eax
801013d4:	51                   	push   %ecx
801013d5:	52                   	push   %edx
801013d6:	53                   	push   %ebx
801013d7:	50                   	push   %eax
801013d8:	e8 92 0d 00 00       	call   8010216f <writei>
801013dd:	83 c4 10             	add    $0x10,%esp
801013e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013e7:	7e 11                	jle    801013fa <filewrite+0xd3>
        f->off += r;
801013e9:	8b 45 08             	mov    0x8(%ebp),%eax
801013ec:	8b 50 14             	mov    0x14(%eax),%edx
801013ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f2:	01 c2                	add    %eax,%edx
801013f4:	8b 45 08             	mov    0x8(%ebp),%eax
801013f7:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013fa:	8b 45 08             	mov    0x8(%ebp),%eax
801013fd:	8b 40 10             	mov    0x10(%eax),%eax
80101400:	83 ec 0c             	sub    $0xc,%esp
80101403:	50                   	push   %eax
80101404:	e8 1c 08 00 00       	call   80101c25 <iunlock>
80101409:	83 c4 10             	add    $0x10,%esp
      end_op();
8010140c:	e8 5c 23 00 00       	call   8010376d <end_op>

      if(r < 0)
80101411:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101415:	78 29                	js     80101440 <filewrite+0x119>
        break;
      if(r != n1)
80101417:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010141a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010141d:	74 0d                	je     8010142c <filewrite+0x105>
        panic("short filewrite");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 a4 87 10 80       	push   $0x801087a4
80101427:	e8 a5 f1 ff ff       	call   801005d1 <panic>
      i += r;
8010142c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010142f:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
80101432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101435:	3b 45 10             	cmp    0x10(%ebp),%eax
80101438:	0f 8c 51 ff ff ff    	jl     8010138f <filewrite+0x68>
8010143e:	eb 01                	jmp    80101441 <filewrite+0x11a>
        break;
80101440:	90                   	nop
    }
    return i == n ? n : -1;
80101441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101444:	3b 45 10             	cmp    0x10(%ebp),%eax
80101447:	75 05                	jne    8010144e <filewrite+0x127>
80101449:	8b 45 10             	mov    0x10(%ebp),%eax
8010144c:	eb 14                	jmp    80101462 <filewrite+0x13b>
8010144e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101453:	eb 0d                	jmp    80101462 <filewrite+0x13b>
  }
  panic("filewrite");
80101455:	83 ec 0c             	sub    $0xc,%esp
80101458:	68 b4 87 10 80       	push   $0x801087b4
8010145d:	e8 6f f1 ff ff       	call   801005d1 <panic>
}
80101462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101465:	c9                   	leave  
80101466:	c3                   	ret    

80101467 <filelseek>:
//my function filelseek
//the function used in tp1 is saved in /sys_exp/tp1, in tp2 we must not treat 
//negative offsets so we use uint type
int
filelseek(struct file *f, uint offset, int whence)
{
80101467:	f3 0f 1e fb          	endbr32 
8010146b:	55                   	push   %ebp
8010146c:	89 e5                	mov    %esp,%ebp
8010146e:	83 ec 10             	sub    $0x10,%esp
    uint size = f->ip->size;
80101471:	8b 45 08             	mov    0x8(%ebp),%eax
80101474:	8b 40 10             	mov    0x10(%eax),%eax
80101477:	8b 40 58             	mov    0x58(%eax),%eax
8010147a:	89 45 fc             	mov    %eax,-0x4(%ebp)

    if (offset > size)
8010147d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101480:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80101483:	76 07                	jbe    8010148c <filelseek+0x25>
    {
        return -1;
80101485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010148a:	eb 43                	jmp    801014cf <filelseek+0x68>
    }
    

    if (whence == 0)
8010148c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101490:	75 0b                	jne    8010149d <filelseek+0x36>
    {
        f->off = offset;
80101492:	8b 45 08             	mov    0x8(%ebp),%eax
80101495:	8b 55 0c             	mov    0xc(%ebp),%edx
80101498:	89 50 14             	mov    %edx,0x14(%eax)
8010149b:	eb 2d                	jmp    801014ca <filelseek+0x63>
    }
    else if (whence == 1)
8010149d:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
801014a1:	75 13                	jne    801014b6 <filelseek+0x4f>
    {
        f->off += offset;
801014a3:	8b 45 08             	mov    0x8(%ebp),%eax
801014a6:	8b 50 14             	mov    0x14(%eax),%edx
801014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801014ac:	01 c2                	add    %eax,%edx
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	89 50 14             	mov    %edx,0x14(%eax)
801014b4:	eb 14                	jmp    801014ca <filelseek+0x63>
    }
    else if (whence == 2)
801014b6:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
801014ba:	75 0e                	jne    801014ca <filelseek+0x63>
    {
        f->off = size - offset;
801014bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801014bf:	2b 45 0c             	sub    0xc(%ebp),%eax
801014c2:	89 c2                	mov    %eax,%edx
801014c4:	8b 45 08             	mov    0x8(%ebp),%eax
801014c7:	89 50 14             	mov    %edx,0x14(%eax)
    }
    
    return 0;
801014ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801014cf:	c9                   	leave  
801014d0:	c3                   	ret    

801014d1 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014d1:	f3 0f 1e fb          	endbr32 
801014d5:	55                   	push   %ebp
801014d6:	89 e5                	mov    %esp,%ebp
801014d8:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801014db:	8b 45 08             	mov    0x8(%ebp),%eax
801014de:	83 ec 08             	sub    $0x8,%esp
801014e1:	6a 01                	push   $0x1
801014e3:	50                   	push   %eax
801014e4:	e8 ee ec ff ff       	call   801001d7 <bread>
801014e9:	83 c4 10             	add    $0x10,%esp
801014ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014f2:	83 c0 5c             	add    $0x5c,%eax
801014f5:	83 ec 04             	sub    $0x4,%esp
801014f8:	6a 1c                	push   $0x1c
801014fa:	50                   	push   %eax
801014fb:	ff 75 0c             	pushl  0xc(%ebp)
801014fe:	e8 41 40 00 00       	call   80105544 <memmove>
80101503:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101506:	83 ec 0c             	sub    $0xc,%esp
80101509:	ff 75 f4             	pushl  -0xc(%ebp)
8010150c:	e8 50 ed ff ff       	call   80100261 <brelse>
80101511:	83 c4 10             	add    $0x10,%esp
}
80101514:	90                   	nop
80101515:	c9                   	leave  
80101516:	c3                   	ret    

80101517 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101517:	f3 0f 1e fb          	endbr32 
8010151b:	55                   	push   %ebp
8010151c:	89 e5                	mov    %esp,%ebp
8010151e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101521:	8b 55 0c             	mov    0xc(%ebp),%edx
80101524:	8b 45 08             	mov    0x8(%ebp),%eax
80101527:	83 ec 08             	sub    $0x8,%esp
8010152a:	52                   	push   %edx
8010152b:	50                   	push   %eax
8010152c:	e8 a6 ec ff ff       	call   801001d7 <bread>
80101531:	83 c4 10             	add    $0x10,%esp
80101534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010153a:	83 c0 5c             	add    $0x5c,%eax
8010153d:	83 ec 04             	sub    $0x4,%esp
80101540:	68 00 02 00 00       	push   $0x200
80101545:	6a 00                	push   $0x0
80101547:	50                   	push   %eax
80101548:	e8 30 3f 00 00       	call   8010547d <memset>
8010154d:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
80101553:	ff 75 f4             	pushl  -0xc(%ebp)
80101556:	e8 cb 23 00 00       	call   80103926 <log_write>
8010155b:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010155e:	83 ec 0c             	sub    $0xc,%esp
80101561:	ff 75 f4             	pushl  -0xc(%ebp)
80101564:	e8 f8 ec ff ff       	call   80100261 <brelse>
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	90                   	nop
8010156d:	c9                   	leave  
8010156e:	c3                   	ret    

8010156f <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010156f:	f3 0f 1e fb          	endbr32 
80101573:	55                   	push   %ebp
80101574:	89 e5                	mov    %esp,%ebp
80101576:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101579:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101587:	e9 13 01 00 00       	jmp    8010169f <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
8010158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010158f:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101595:	85 c0                	test   %eax,%eax
80101597:	0f 48 c2             	cmovs  %edx,%eax
8010159a:	c1 f8 0c             	sar    $0xc,%eax
8010159d:	89 c2                	mov    %eax,%edx
8010159f:	a1 58 1a 11 80       	mov    0x80111a58,%eax
801015a4:	01 d0                	add    %edx,%eax
801015a6:	83 ec 08             	sub    $0x8,%esp
801015a9:	50                   	push   %eax
801015aa:	ff 75 08             	pushl  0x8(%ebp)
801015ad:	e8 25 ec ff ff       	call   801001d7 <bread>
801015b2:	83 c4 10             	add    $0x10,%esp
801015b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015bf:	e9 a6 00 00 00       	jmp    8010166a <balloc+0xfb>
      m = 1 << (bi % 8);
801015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c7:	99                   	cltd   
801015c8:	c1 ea 1d             	shr    $0x1d,%edx
801015cb:	01 d0                	add    %edx,%eax
801015cd:	83 e0 07             	and    $0x7,%eax
801015d0:	29 d0                	sub    %edx,%eax
801015d2:	ba 01 00 00 00       	mov    $0x1,%edx
801015d7:	89 c1                	mov    %eax,%ecx
801015d9:	d3 e2                	shl    %cl,%edx
801015db:	89 d0                	mov    %edx,%eax
801015dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e3:	8d 50 07             	lea    0x7(%eax),%edx
801015e6:	85 c0                	test   %eax,%eax
801015e8:	0f 48 c2             	cmovs  %edx,%eax
801015eb:	c1 f8 03             	sar    $0x3,%eax
801015ee:	89 c2                	mov    %eax,%edx
801015f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015f3:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801015f8:	0f b6 c0             	movzbl %al,%eax
801015fb:	23 45 e8             	and    -0x18(%ebp),%eax
801015fe:	85 c0                	test   %eax,%eax
80101600:	75 64                	jne    80101666 <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101602:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101605:	8d 50 07             	lea    0x7(%eax),%edx
80101608:	85 c0                	test   %eax,%eax
8010160a:	0f 48 c2             	cmovs  %edx,%eax
8010160d:	c1 f8 03             	sar    $0x3,%eax
80101610:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101613:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101618:	89 d1                	mov    %edx,%ecx
8010161a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010161d:	09 ca                	or     %ecx,%edx
8010161f:	89 d1                	mov    %edx,%ecx
80101621:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101624:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101628:	83 ec 0c             	sub    $0xc,%esp
8010162b:	ff 75 ec             	pushl  -0x14(%ebp)
8010162e:	e8 f3 22 00 00       	call   80103926 <log_write>
80101633:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101636:	83 ec 0c             	sub    $0xc,%esp
80101639:	ff 75 ec             	pushl  -0x14(%ebp)
8010163c:	e8 20 ec ff ff       	call   80100261 <brelse>
80101641:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101644:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101647:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164a:	01 c2                	add    %eax,%edx
8010164c:	8b 45 08             	mov    0x8(%ebp),%eax
8010164f:	83 ec 08             	sub    $0x8,%esp
80101652:	52                   	push   %edx
80101653:	50                   	push   %eax
80101654:	e8 be fe ff ff       	call   80101517 <bzero>
80101659:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010165c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101662:	01 d0                	add    %edx,%eax
80101664:	eb 57                	jmp    801016bd <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101666:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010166a:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101671:	7f 17                	jg     8010168a <balloc+0x11b>
80101673:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101676:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101679:	01 d0                	add    %edx,%eax
8010167b:	89 c2                	mov    %eax,%edx
8010167d:	a1 40 1a 11 80       	mov    0x80111a40,%eax
80101682:	39 c2                	cmp    %eax,%edx
80101684:	0f 82 3a ff ff ff    	jb     801015c4 <balloc+0x55>
      }
    }
    brelse(bp);
8010168a:	83 ec 0c             	sub    $0xc,%esp
8010168d:	ff 75 ec             	pushl  -0x14(%ebp)
80101690:	e8 cc eb ff ff       	call   80100261 <brelse>
80101695:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101698:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010169f:	8b 15 40 1a 11 80    	mov    0x80111a40,%edx
801016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a8:	39 c2                	cmp    %eax,%edx
801016aa:	0f 87 dc fe ff ff    	ja     8010158c <balloc+0x1d>
  }
  panic("balloc: out of blocks");
801016b0:	83 ec 0c             	sub    $0xc,%esp
801016b3:	68 c0 87 10 80       	push   $0x801087c0
801016b8:	e8 14 ef ff ff       	call   801005d1 <panic>
}
801016bd:	c9                   	leave  
801016be:	c3                   	ret    

801016bf <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016bf:	f3 0f 1e fb          	endbr32 
801016c3:	55                   	push   %ebp
801016c4:	89 e5                	mov    %esp,%ebp
801016c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801016c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801016cc:	c1 e8 0c             	shr    $0xc,%eax
801016cf:	89 c2                	mov    %eax,%edx
801016d1:	a1 58 1a 11 80       	mov    0x80111a58,%eax
801016d6:	01 c2                	add    %eax,%edx
801016d8:	8b 45 08             	mov    0x8(%ebp),%eax
801016db:	83 ec 08             	sub    $0x8,%esp
801016de:	52                   	push   %edx
801016df:	50                   	push   %eax
801016e0:	e8 f2 ea ff ff       	call   801001d7 <bread>
801016e5:	83 c4 10             	add    $0x10,%esp
801016e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801016ee:	25 ff 0f 00 00       	and    $0xfff,%eax
801016f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f9:	99                   	cltd   
801016fa:	c1 ea 1d             	shr    $0x1d,%edx
801016fd:	01 d0                	add    %edx,%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	29 d0                	sub    %edx,%eax
80101704:	ba 01 00 00 00       	mov    $0x1,%edx
80101709:	89 c1                	mov    %eax,%ecx
8010170b:	d3 e2                	shl    %cl,%edx
8010170d:	89 d0                	mov    %edx,%eax
8010170f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101712:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101715:	8d 50 07             	lea    0x7(%eax),%edx
80101718:	85 c0                	test   %eax,%eax
8010171a:	0f 48 c2             	cmovs  %edx,%eax
8010171d:	c1 f8 03             	sar    $0x3,%eax
80101720:	89 c2                	mov    %eax,%edx
80101722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101725:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010172a:	0f b6 c0             	movzbl %al,%eax
8010172d:	23 45 ec             	and    -0x14(%ebp),%eax
80101730:	85 c0                	test   %eax,%eax
80101732:	75 0d                	jne    80101741 <bfree+0x82>
    panic("freeing free block");
80101734:	83 ec 0c             	sub    $0xc,%esp
80101737:	68 d6 87 10 80       	push   $0x801087d6
8010173c:	e8 90 ee ff ff       	call   801005d1 <panic>
  bp->data[bi/8] &= ~m;
80101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101744:	8d 50 07             	lea    0x7(%eax),%edx
80101747:	85 c0                	test   %eax,%eax
80101749:	0f 48 c2             	cmovs  %edx,%eax
8010174c:	c1 f8 03             	sar    $0x3,%eax
8010174f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101752:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101757:	89 d1                	mov    %edx,%ecx
80101759:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010175c:	f7 d2                	not    %edx
8010175e:	21 ca                	and    %ecx,%edx
80101760:	89 d1                	mov    %edx,%ecx
80101762:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101765:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101769:	83 ec 0c             	sub    $0xc,%esp
8010176c:	ff 75 f4             	pushl  -0xc(%ebp)
8010176f:	e8 b2 21 00 00       	call   80103926 <log_write>
80101774:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	ff 75 f4             	pushl  -0xc(%ebp)
8010177d:	e8 df ea ff ff       	call   80100261 <brelse>
80101782:	83 c4 10             	add    $0x10,%esp
}
80101785:	90                   	nop
80101786:	c9                   	leave  
80101787:	c3                   	ret    

80101788 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101788:	f3 0f 1e fb          	endbr32 
8010178c:	55                   	push   %ebp
8010178d:	89 e5                	mov    %esp,%ebp
8010178f:	57                   	push   %edi
80101790:	56                   	push   %esi
80101791:	53                   	push   %ebx
80101792:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101795:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010179c:	83 ec 08             	sub    $0x8,%esp
8010179f:	68 e9 87 10 80       	push   $0x801087e9
801017a4:	68 60 1a 11 80       	push   $0x80111a60
801017a9:	e8 0a 3a 00 00       	call   801051b8 <initlock>
801017ae:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801017b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801017b8:	eb 2d                	jmp    801017e7 <iinit+0x5f>
    initsleeplock(&icache.inode[i].lock, "inode");
801017ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017bd:	89 d0                	mov    %edx,%eax
801017bf:	c1 e0 03             	shl    $0x3,%eax
801017c2:	01 d0                	add    %edx,%eax
801017c4:	c1 e0 04             	shl    $0x4,%eax
801017c7:	83 c0 30             	add    $0x30,%eax
801017ca:	05 60 1a 11 80       	add    $0x80111a60,%eax
801017cf:	83 c0 10             	add    $0x10,%eax
801017d2:	83 ec 08             	sub    $0x8,%esp
801017d5:	68 f0 87 10 80       	push   $0x801087f0
801017da:	50                   	push   %eax
801017db:	e8 45 38 00 00       	call   80105025 <initsleeplock>
801017e0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801017e3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801017e7:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801017eb:	7e cd                	jle    801017ba <iinit+0x32>
  }

  readsb(dev, &sb);
801017ed:	83 ec 08             	sub    $0x8,%esp
801017f0:	68 40 1a 11 80       	push   $0x80111a40
801017f5:	ff 75 08             	pushl  0x8(%ebp)
801017f8:	e8 d4 fc ff ff       	call   801014d1 <readsb>
801017fd:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101800:	a1 58 1a 11 80       	mov    0x80111a58,%eax
80101805:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101808:	8b 3d 54 1a 11 80    	mov    0x80111a54,%edi
8010180e:	8b 35 50 1a 11 80    	mov    0x80111a50,%esi
80101814:	8b 1d 4c 1a 11 80    	mov    0x80111a4c,%ebx
8010181a:	8b 0d 48 1a 11 80    	mov    0x80111a48,%ecx
80101820:	8b 15 44 1a 11 80    	mov    0x80111a44,%edx
80101826:	a1 40 1a 11 80       	mov    0x80111a40,%eax
8010182b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010182e:	57                   	push   %edi
8010182f:	56                   	push   %esi
80101830:	53                   	push   %ebx
80101831:	51                   	push   %ecx
80101832:	52                   	push   %edx
80101833:	50                   	push   %eax
80101834:	68 f8 87 10 80       	push   $0x801087f8
80101839:	e8 da eb ff ff       	call   80100418 <cprintf>
8010183e:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101841:	90                   	nop
80101842:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101845:	5b                   	pop    %ebx
80101846:	5e                   	pop    %esi
80101847:	5f                   	pop    %edi
80101848:	5d                   	pop    %ebp
80101849:	c3                   	ret    

8010184a <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010184a:	f3 0f 1e fb          	endbr32 
8010184e:	55                   	push   %ebp
8010184f:	89 e5                	mov    %esp,%ebp
80101851:	83 ec 28             	sub    $0x28,%esp
80101854:	8b 45 0c             	mov    0xc(%ebp),%eax
80101857:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010185b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101862:	e9 9e 00 00 00       	jmp    80101905 <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
80101867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186a:	c1 e8 03             	shr    $0x3,%eax
8010186d:	89 c2                	mov    %eax,%edx
8010186f:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101874:	01 d0                	add    %edx,%eax
80101876:	83 ec 08             	sub    $0x8,%esp
80101879:	50                   	push   %eax
8010187a:	ff 75 08             	pushl  0x8(%ebp)
8010187d:	e8 55 e9 ff ff       	call   801001d7 <bread>
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101888:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101891:	83 e0 07             	and    $0x7,%eax
80101894:	c1 e0 06             	shl    $0x6,%eax
80101897:	01 d0                	add    %edx,%eax
80101899:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010189c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010189f:	0f b7 00             	movzwl (%eax),%eax
801018a2:	66 85 c0             	test   %ax,%ax
801018a5:	75 4c                	jne    801018f3 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
801018a7:	83 ec 04             	sub    $0x4,%esp
801018aa:	6a 40                	push   $0x40
801018ac:	6a 00                	push   $0x0
801018ae:	ff 75 ec             	pushl  -0x14(%ebp)
801018b1:	e8 c7 3b 00 00       	call   8010547d <memset>
801018b6:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801018b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018bc:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801018c0:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801018c3:	83 ec 0c             	sub    $0xc,%esp
801018c6:	ff 75 f0             	pushl  -0x10(%ebp)
801018c9:	e8 58 20 00 00       	call   80103926 <log_write>
801018ce:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801018d1:	83 ec 0c             	sub    $0xc,%esp
801018d4:	ff 75 f0             	pushl  -0x10(%ebp)
801018d7:	e8 85 e9 ff ff       	call   80100261 <brelse>
801018dc:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e2:	83 ec 08             	sub    $0x8,%esp
801018e5:	50                   	push   %eax
801018e6:	ff 75 08             	pushl  0x8(%ebp)
801018e9:	e8 fc 00 00 00       	call   801019ea <iget>
801018ee:	83 c4 10             	add    $0x10,%esp
801018f1:	eb 30                	jmp    80101923 <ialloc+0xd9>
    }
    brelse(bp);
801018f3:	83 ec 0c             	sub    $0xc,%esp
801018f6:	ff 75 f0             	pushl  -0x10(%ebp)
801018f9:	e8 63 e9 ff ff       	call   80100261 <brelse>
801018fe:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101901:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101905:	8b 15 48 1a 11 80    	mov    0x80111a48,%edx
8010190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190e:	39 c2                	cmp    %eax,%edx
80101910:	0f 87 51 ff ff ff    	ja     80101867 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
80101916:	83 ec 0c             	sub    $0xc,%esp
80101919:	68 4b 88 10 80       	push   $0x8010884b
8010191e:	e8 ae ec ff ff       	call   801005d1 <panic>
}
80101923:	c9                   	leave  
80101924:	c3                   	ret    

80101925 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101925:	f3 0f 1e fb          	endbr32 
80101929:	55                   	push   %ebp
8010192a:	89 e5                	mov    %esp,%ebp
8010192c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010192f:	8b 45 08             	mov    0x8(%ebp),%eax
80101932:	8b 40 04             	mov    0x4(%eax),%eax
80101935:	c1 e8 03             	shr    $0x3,%eax
80101938:	89 c2                	mov    %eax,%edx
8010193a:	a1 54 1a 11 80       	mov    0x80111a54,%eax
8010193f:	01 c2                	add    %eax,%edx
80101941:	8b 45 08             	mov    0x8(%ebp),%eax
80101944:	8b 00                	mov    (%eax),%eax
80101946:	83 ec 08             	sub    $0x8,%esp
80101949:	52                   	push   %edx
8010194a:	50                   	push   %eax
8010194b:	e8 87 e8 ff ff       	call   801001d7 <bread>
80101950:	83 c4 10             	add    $0x10,%esp
80101953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101959:	8d 50 5c             	lea    0x5c(%eax),%edx
8010195c:	8b 45 08             	mov    0x8(%ebp),%eax
8010195f:	8b 40 04             	mov    0x4(%eax),%eax
80101962:	83 e0 07             	and    $0x7,%eax
80101965:	c1 e0 06             	shl    $0x6,%eax
80101968:	01 d0                	add    %edx,%eax
8010196a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
80101970:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101974:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101977:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010197a:	8b 45 08             	mov    0x8(%ebp),%eax
8010197d:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101981:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101984:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101988:	8b 45 08             	mov    0x8(%ebp),%eax
8010198b:	0f b7 50 54          	movzwl 0x54(%eax),%edx
8010198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101992:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101996:	8b 45 08             	mov    0x8(%ebp),%eax
80101999:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010199d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a0:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801019a4:	8b 45 08             	mov    0x8(%ebp),%eax
801019a7:	8b 50 58             	mov    0x58(%eax),%edx
801019aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ad:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019b0:	8b 45 08             	mov    0x8(%ebp),%eax
801019b3:	8d 50 5c             	lea    0x5c(%eax),%edx
801019b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b9:	83 c0 0c             	add    $0xc,%eax
801019bc:	83 ec 04             	sub    $0x4,%esp
801019bf:	6a 34                	push   $0x34
801019c1:	52                   	push   %edx
801019c2:	50                   	push   %eax
801019c3:	e8 7c 3b 00 00       	call   80105544 <memmove>
801019c8:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019cb:	83 ec 0c             	sub    $0xc,%esp
801019ce:	ff 75 f4             	pushl  -0xc(%ebp)
801019d1:	e8 50 1f 00 00       	call   80103926 <log_write>
801019d6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019d9:	83 ec 0c             	sub    $0xc,%esp
801019dc:	ff 75 f4             	pushl  -0xc(%ebp)
801019df:	e8 7d e8 ff ff       	call   80100261 <brelse>
801019e4:	83 c4 10             	add    $0x10,%esp
}
801019e7:	90                   	nop
801019e8:	c9                   	leave  
801019e9:	c3                   	ret    

801019ea <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019ea:	f3 0f 1e fb          	endbr32 
801019ee:	55                   	push   %ebp
801019ef:	89 e5                	mov    %esp,%ebp
801019f1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019f4:	83 ec 0c             	sub    $0xc,%esp
801019f7:	68 60 1a 11 80       	push   $0x80111a60
801019fc:	e8 dd 37 00 00       	call   801051de <acquire>
80101a01:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101a04:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a0b:	c7 45 f4 94 1a 11 80 	movl   $0x80111a94,-0xc(%ebp)
80101a12:	eb 60                	jmp    80101a74 <iget+0x8a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a17:	8b 40 08             	mov    0x8(%eax),%eax
80101a1a:	85 c0                	test   %eax,%eax
80101a1c:	7e 39                	jle    80101a57 <iget+0x6d>
80101a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a21:	8b 00                	mov    (%eax),%eax
80101a23:	39 45 08             	cmp    %eax,0x8(%ebp)
80101a26:	75 2f                	jne    80101a57 <iget+0x6d>
80101a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a2b:	8b 40 04             	mov    0x4(%eax),%eax
80101a2e:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101a31:	75 24                	jne    80101a57 <iget+0x6d>
      ip->ref++;
80101a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a36:	8b 40 08             	mov    0x8(%eax),%eax
80101a39:	8d 50 01             	lea    0x1(%eax),%edx
80101a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a3f:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a42:	83 ec 0c             	sub    $0xc,%esp
80101a45:	68 60 1a 11 80       	push   $0x80111a60
80101a4a:	e8 01 38 00 00       	call   80105250 <release>
80101a4f:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a55:	eb 77                	jmp    80101ace <iget+0xe4>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a5b:	75 10                	jne    80101a6d <iget+0x83>
80101a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a60:	8b 40 08             	mov    0x8(%eax),%eax
80101a63:	85 c0                	test   %eax,%eax
80101a65:	75 06                	jne    80101a6d <iget+0x83>
      empty = ip;
80101a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a6d:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101a74:	81 7d f4 b4 36 11 80 	cmpl   $0x801136b4,-0xc(%ebp)
80101a7b:	72 97                	jb     80101a14 <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a81:	75 0d                	jne    80101a90 <iget+0xa6>
    panic("iget: no inodes");
80101a83:	83 ec 0c             	sub    $0xc,%esp
80101a86:	68 5d 88 10 80       	push   $0x8010885d
80101a8b:	e8 41 eb ff ff       	call   801005d1 <panic>

  ip = empty;
80101a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a99:	8b 55 08             	mov    0x8(%ebp),%edx
80101a9c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101aa4:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aaa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab4:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101abb:	83 ec 0c             	sub    $0xc,%esp
80101abe:	68 60 1a 11 80       	push   $0x80111a60
80101ac3:	e8 88 37 00 00       	call   80105250 <release>
80101ac8:	83 c4 10             	add    $0x10,%esp

  return ip;
80101acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101ace:	c9                   	leave  
80101acf:	c3                   	ret    

80101ad0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101ad0:	f3 0f 1e fb          	endbr32 
80101ad4:	55                   	push   %ebp
80101ad5:	89 e5                	mov    %esp,%ebp
80101ad7:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ada:	83 ec 0c             	sub    $0xc,%esp
80101add:	68 60 1a 11 80       	push   $0x80111a60
80101ae2:	e8 f7 36 00 00       	call   801051de <acquire>
80101ae7:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101aea:	8b 45 08             	mov    0x8(%ebp),%eax
80101aed:	8b 40 08             	mov    0x8(%eax),%eax
80101af0:	8d 50 01             	lea    0x1(%eax),%edx
80101af3:	8b 45 08             	mov    0x8(%ebp),%eax
80101af6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101af9:	83 ec 0c             	sub    $0xc,%esp
80101afc:	68 60 1a 11 80       	push   $0x80111a60
80101b01:	e8 4a 37 00 00       	call   80105250 <release>
80101b06:	83 c4 10             	add    $0x10,%esp
  return ip;
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101b0c:	c9                   	leave  
80101b0d:	c3                   	ret    

80101b0e <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101b0e:	f3 0f 1e fb          	endbr32 
80101b12:	55                   	push   %ebp
80101b13:	89 e5                	mov    %esp,%ebp
80101b15:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b1c:	74 0a                	je     80101b28 <ilock+0x1a>
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	8b 40 08             	mov    0x8(%eax),%eax
80101b24:	85 c0                	test   %eax,%eax
80101b26:	7f 0d                	jg     80101b35 <ilock+0x27>
    panic("ilock");
80101b28:	83 ec 0c             	sub    $0xc,%esp
80101b2b:	68 6d 88 10 80       	push   $0x8010886d
80101b30:	e8 9c ea ff ff       	call   801005d1 <panic>

  acquiresleep(&ip->lock);
80101b35:	8b 45 08             	mov    0x8(%ebp),%eax
80101b38:	83 c0 0c             	add    $0xc,%eax
80101b3b:	83 ec 0c             	sub    $0xc,%esp
80101b3e:	50                   	push   %eax
80101b3f:	e8 21 35 00 00       	call   80105065 <acquiresleep>
80101b44:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101b47:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b4d:	85 c0                	test   %eax,%eax
80101b4f:	0f 85 cd 00 00 00    	jne    80101c22 <ilock+0x114>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b55:	8b 45 08             	mov    0x8(%ebp),%eax
80101b58:	8b 40 04             	mov    0x4(%eax),%eax
80101b5b:	c1 e8 03             	shr    $0x3,%eax
80101b5e:	89 c2                	mov    %eax,%edx
80101b60:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101b65:	01 c2                	add    %eax,%edx
80101b67:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6a:	8b 00                	mov    (%eax),%eax
80101b6c:	83 ec 08             	sub    $0x8,%esp
80101b6f:	52                   	push   %edx
80101b70:	50                   	push   %eax
80101b71:	e8 61 e6 ff ff       	call   801001d7 <bread>
80101b76:	83 c4 10             	add    $0x10,%esp
80101b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b7f:	8d 50 5c             	lea    0x5c(%eax),%edx
80101b82:	8b 45 08             	mov    0x8(%ebp),%eax
80101b85:	8b 40 04             	mov    0x4(%eax),%eax
80101b88:	83 e0 07             	and    $0x7,%eax
80101b8b:	c1 e0 06             	shl    $0x6,%eax
80101b8e:	01 d0                	add    %edx,%eax
80101b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b96:	0f b7 10             	movzwl (%eax),%edx
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba3:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80101baa:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bb1:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bbf:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc6:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bcd:	8b 50 08             	mov    0x8(%eax),%edx
80101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd3:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd9:	8d 50 0c             	lea    0xc(%eax),%edx
80101bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdf:	83 c0 5c             	add    $0x5c,%eax
80101be2:	83 ec 04             	sub    $0x4,%esp
80101be5:	6a 34                	push   $0x34
80101be7:	52                   	push   %edx
80101be8:	50                   	push   %eax
80101be9:	e8 56 39 00 00       	call   80105544 <memmove>
80101bee:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	ff 75 f4             	pushl  -0xc(%ebp)
80101bf7:	e8 65 e6 ff ff       	call   80100261 <brelse>
80101bfc:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101bff:	8b 45 08             	mov    0x8(%ebp),%eax
80101c02:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101c10:	66 85 c0             	test   %ax,%ax
80101c13:	75 0d                	jne    80101c22 <ilock+0x114>
      panic("ilock: no type");
80101c15:	83 ec 0c             	sub    $0xc,%esp
80101c18:	68 73 88 10 80       	push   $0x80108873
80101c1d:	e8 af e9 ff ff       	call   801005d1 <panic>
  }
}
80101c22:	90                   	nop
80101c23:	c9                   	leave  
80101c24:	c3                   	ret    

80101c25 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c25:	f3 0f 1e fb          	endbr32 
80101c29:	55                   	push   %ebp
80101c2a:	89 e5                	mov    %esp,%ebp
80101c2c:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c33:	74 20                	je     80101c55 <iunlock+0x30>
80101c35:	8b 45 08             	mov    0x8(%ebp),%eax
80101c38:	83 c0 0c             	add    $0xc,%eax
80101c3b:	83 ec 0c             	sub    $0xc,%esp
80101c3e:	50                   	push   %eax
80101c3f:	e8 db 34 00 00       	call   8010511f <holdingsleep>
80101c44:	83 c4 10             	add    $0x10,%esp
80101c47:	85 c0                	test   %eax,%eax
80101c49:	74 0a                	je     80101c55 <iunlock+0x30>
80101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4e:	8b 40 08             	mov    0x8(%eax),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	7f 0d                	jg     80101c62 <iunlock+0x3d>
    panic("iunlock");
80101c55:	83 ec 0c             	sub    $0xc,%esp
80101c58:	68 82 88 10 80       	push   $0x80108882
80101c5d:	e8 6f e9 ff ff       	call   801005d1 <panic>

  releasesleep(&ip->lock);
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	83 c0 0c             	add    $0xc,%eax
80101c68:	83 ec 0c             	sub    $0xc,%esp
80101c6b:	50                   	push   %eax
80101c6c:	e8 5c 34 00 00       	call   801050cd <releasesleep>
80101c71:	83 c4 10             	add    $0x10,%esp
}
80101c74:	90                   	nop
80101c75:	c9                   	leave  
80101c76:	c3                   	ret    

80101c77 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c77:	f3 0f 1e fb          	endbr32 
80101c7b:	55                   	push   %ebp
80101c7c:	89 e5                	mov    %esp,%ebp
80101c7e:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101c81:	8b 45 08             	mov    0x8(%ebp),%eax
80101c84:	83 c0 0c             	add    $0xc,%eax
80101c87:	83 ec 0c             	sub    $0xc,%esp
80101c8a:	50                   	push   %eax
80101c8b:	e8 d5 33 00 00       	call   80105065 <acquiresleep>
80101c90:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c99:	85 c0                	test   %eax,%eax
80101c9b:	74 6a                	je     80101d07 <iput+0x90>
80101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101ca4:	66 85 c0             	test   %ax,%ax
80101ca7:	75 5e                	jne    80101d07 <iput+0x90>
    acquire(&icache.lock);
80101ca9:	83 ec 0c             	sub    $0xc,%esp
80101cac:	68 60 1a 11 80       	push   $0x80111a60
80101cb1:	e8 28 35 00 00       	call   801051de <acquire>
80101cb6:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	8b 40 08             	mov    0x8(%eax),%eax
80101cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	68 60 1a 11 80       	push   $0x80111a60
80101cca:	e8 81 35 00 00       	call   80105250 <release>
80101ccf:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101cd2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101cd6:	75 2f                	jne    80101d07 <iput+0x90>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101cd8:	83 ec 0c             	sub    $0xc,%esp
80101cdb:	ff 75 08             	pushl  0x8(%ebp)
80101cde:	e8 b5 01 00 00       	call   80101e98 <itrunc>
80101ce3:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce9:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	ff 75 08             	pushl  0x8(%ebp)
80101cf5:	e8 2b fc ff ff       	call   80101925 <iupdate>
80101cfa:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101d07:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0a:	83 c0 0c             	add    $0xc,%eax
80101d0d:	83 ec 0c             	sub    $0xc,%esp
80101d10:	50                   	push   %eax
80101d11:	e8 b7 33 00 00       	call   801050cd <releasesleep>
80101d16:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101d19:	83 ec 0c             	sub    $0xc,%esp
80101d1c:	68 60 1a 11 80       	push   $0x80111a60
80101d21:	e8 b8 34 00 00       	call   801051de <acquire>
80101d26:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 40 08             	mov    0x8(%eax),%eax
80101d2f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	68 60 1a 11 80       	push   $0x80111a60
80101d40:	e8 0b 35 00 00       	call   80105250 <release>
80101d45:	83 c4 10             	add    $0x10,%esp
}
80101d48:	90                   	nop
80101d49:	c9                   	leave  
80101d4a:	c3                   	ret    

80101d4b <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d4b:	f3 0f 1e fb          	endbr32 
80101d4f:	55                   	push   %ebp
80101d50:	89 e5                	mov    %esp,%ebp
80101d52:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101d55:	83 ec 0c             	sub    $0xc,%esp
80101d58:	ff 75 08             	pushl  0x8(%ebp)
80101d5b:	e8 c5 fe ff ff       	call   80101c25 <iunlock>
80101d60:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101d63:	83 ec 0c             	sub    $0xc,%esp
80101d66:	ff 75 08             	pushl  0x8(%ebp)
80101d69:	e8 09 ff ff ff       	call   80101c77 <iput>
80101d6e:	83 c4 10             	add    $0x10,%esp
}
80101d71:	90                   	nop
80101d72:	c9                   	leave  
80101d73:	c3                   	ret    

80101d74 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d74:	f3 0f 1e fb          	endbr32 
80101d78:	55                   	push   %ebp
80101d79:	89 e5                	mov    %esp,%ebp
80101d7b:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d7e:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d82:	77 42                	ja     80101dc6 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
80101d84:	8b 45 08             	mov    0x8(%ebp),%eax
80101d87:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d8a:	83 c2 14             	add    $0x14,%edx
80101d8d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d98:	75 24                	jne    80101dbe <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9d:	8b 00                	mov    (%eax),%eax
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	50                   	push   %eax
80101da3:	e8 c7 f7 ff ff       	call   8010156f <balloc>
80101da8:	83 c4 10             	add    $0x10,%esp
80101dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dae:	8b 45 08             	mov    0x8(%ebp),%eax
80101db1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101db4:	8d 4a 14             	lea    0x14(%edx),%ecx
80101db7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dba:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dc1:	e9 d0 00 00 00       	jmp    80101e96 <bmap+0x122>
  }
  bn -= NDIRECT;
80101dc6:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101dca:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101dce:	0f 87 b5 00 00 00    	ja     80101e89 <bmap+0x115>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101de4:	75 20                	jne    80101e06 <bmap+0x92>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101de6:	8b 45 08             	mov    0x8(%ebp),%eax
80101de9:	8b 00                	mov    (%eax),%eax
80101deb:	83 ec 0c             	sub    $0xc,%esp
80101dee:	50                   	push   %eax
80101def:	e8 7b f7 ff ff       	call   8010156f <balloc>
80101df4:	83 c4 10             	add    $0x10,%esp
80101df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e00:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	8b 00                	mov    (%eax),%eax
80101e0b:	83 ec 08             	sub    $0x8,%esp
80101e0e:	ff 75 f4             	pushl  -0xc(%ebp)
80101e11:	50                   	push   %eax
80101e12:	e8 c0 e3 ff ff       	call   801001d7 <bread>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e20:	83 c0 5c             	add    $0x5c,%eax
80101e23:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e26:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e33:	01 d0                	add    %edx,%eax
80101e35:	8b 00                	mov    (%eax),%eax
80101e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e3e:	75 36                	jne    80101e76 <bmap+0x102>
      a[bn] = addr = balloc(ip->dev);
80101e40:	8b 45 08             	mov    0x8(%ebp),%eax
80101e43:	8b 00                	mov    (%eax),%eax
80101e45:	83 ec 0c             	sub    $0xc,%esp
80101e48:	50                   	push   %eax
80101e49:	e8 21 f7 ff ff       	call   8010156f <balloc>
80101e4e:	83 c4 10             	add    $0x10,%esp
80101e51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e61:	01 c2                	add    %eax,%edx
80101e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e66:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	ff 75 f0             	pushl  -0x10(%ebp)
80101e6e:	e8 b3 1a 00 00       	call   80103926 <log_write>
80101e73:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101e76:	83 ec 0c             	sub    $0xc,%esp
80101e79:	ff 75 f0             	pushl  -0x10(%ebp)
80101e7c:	e8 e0 e3 ff ff       	call   80100261 <brelse>
80101e81:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e87:	eb 0d                	jmp    80101e96 <bmap+0x122>
  }

  panic("bmap: out of range");
80101e89:	83 ec 0c             	sub    $0xc,%esp
80101e8c:	68 8a 88 10 80       	push   $0x8010888a
80101e91:	e8 3b e7 ff ff       	call   801005d1 <panic>
}
80101e96:	c9                   	leave  
80101e97:	c3                   	ret    

80101e98 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e98:	f3 0f 1e fb          	endbr32 
80101e9c:	55                   	push   %ebp
80101e9d:	89 e5                	mov    %esp,%ebp
80101e9f:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ea2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ea9:	eb 45                	jmp    80101ef0 <itrunc+0x58>
    if(ip->addrs[i]){
80101eab:	8b 45 08             	mov    0x8(%ebp),%eax
80101eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eb1:	83 c2 14             	add    $0x14,%edx
80101eb4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101eb8:	85 c0                	test   %eax,%eax
80101eba:	74 30                	je     80101eec <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ec2:	83 c2 14             	add    $0x14,%edx
80101ec5:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ec9:	8b 55 08             	mov    0x8(%ebp),%edx
80101ecc:	8b 12                	mov    (%edx),%edx
80101ece:	83 ec 08             	sub    $0x8,%esp
80101ed1:	50                   	push   %eax
80101ed2:	52                   	push   %edx
80101ed3:	e8 e7 f7 ff ff       	call   801016bf <bfree>
80101ed8:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ede:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ee1:	83 c2 14             	add    $0x14,%edx
80101ee4:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101eeb:	00 
  for(i = 0; i < NDIRECT; i++){
80101eec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ef0:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ef4:	7e b5                	jle    80101eab <itrunc+0x13>
    }
  }

  if(ip->addrs[NDIRECT]){
80101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef9:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101eff:	85 c0                	test   %eax,%eax
80101f01:	0f 84 aa 00 00 00    	je     80101fb1 <itrunc+0x119>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f07:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0a:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101f10:	8b 45 08             	mov    0x8(%ebp),%eax
80101f13:	8b 00                	mov    (%eax),%eax
80101f15:	83 ec 08             	sub    $0x8,%esp
80101f18:	52                   	push   %edx
80101f19:	50                   	push   %eax
80101f1a:	e8 b8 e2 ff ff       	call   801001d7 <bread>
80101f1f:	83 c4 10             	add    $0x10,%esp
80101f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f28:	83 c0 5c             	add    $0x5c,%eax
80101f2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f35:	eb 3c                	jmp    80101f73 <itrunc+0xdb>
      if(a[j])
80101f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f44:	01 d0                	add    %edx,%eax
80101f46:	8b 00                	mov    (%eax),%eax
80101f48:	85 c0                	test   %eax,%eax
80101f4a:	74 23                	je     80101f6f <itrunc+0xd7>
        bfree(ip->dev, a[j]);
80101f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f59:	01 d0                	add    %edx,%eax
80101f5b:	8b 00                	mov    (%eax),%eax
80101f5d:	8b 55 08             	mov    0x8(%ebp),%edx
80101f60:	8b 12                	mov    (%edx),%edx
80101f62:	83 ec 08             	sub    $0x8,%esp
80101f65:	50                   	push   %eax
80101f66:	52                   	push   %edx
80101f67:	e8 53 f7 ff ff       	call   801016bf <bfree>
80101f6c:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101f6f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f76:	83 f8 7f             	cmp    $0x7f,%eax
80101f79:	76 bc                	jbe    80101f37 <itrunc+0x9f>
    }
    brelse(bp);
80101f7b:	83 ec 0c             	sub    $0xc,%esp
80101f7e:	ff 75 ec             	pushl  -0x14(%ebp)
80101f81:	e8 db e2 ff ff       	call   80100261 <brelse>
80101f86:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f89:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8c:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101f92:	8b 55 08             	mov    0x8(%ebp),%edx
80101f95:	8b 12                	mov    (%edx),%edx
80101f97:	83 ec 08             	sub    $0x8,%esp
80101f9a:	50                   	push   %eax
80101f9b:	52                   	push   %edx
80101f9c:	e8 1e f7 ff ff       	call   801016bf <bfree>
80101fa1:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa7:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101fae:	00 00 00 
  }

  ip->size = 0;
80101fb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb4:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101fbb:	83 ec 0c             	sub    $0xc,%esp
80101fbe:	ff 75 08             	pushl  0x8(%ebp)
80101fc1:	e8 5f f9 ff ff       	call   80101925 <iupdate>
80101fc6:	83 c4 10             	add    $0x10,%esp
}
80101fc9:	90                   	nop
80101fca:	c9                   	leave  
80101fcb:	c3                   	ret    

80101fcc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101fcc:	f3 0f 1e fb          	endbr32 
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd6:	8b 00                	mov    (%eax),%eax
80101fd8:	89 c2                	mov    %eax,%edx
80101fda:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdd:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe3:	8b 50 04             	mov    0x4(%eax),%edx
80101fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe9:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101fec:	8b 45 08             	mov    0x8(%ebp),%eax
80101fef:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff6:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffc:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80102000:	8b 45 0c             	mov    0xc(%ebp),%eax
80102003:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102007:	8b 45 08             	mov    0x8(%ebp),%eax
8010200a:	8b 50 58             	mov    0x58(%eax),%edx
8010200d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102010:	89 50 10             	mov    %edx,0x10(%eax)
}
80102013:	90                   	nop
80102014:	5d                   	pop    %ebp
80102015:	c3                   	ret    

80102016 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102016:	f3 0f 1e fb          	endbr32 
8010201a:	55                   	push   %ebp
8010201b:	89 e5                	mov    %esp,%ebp
8010201d:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102020:	8b 45 08             	mov    0x8(%ebp),%eax
80102023:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102027:	66 83 f8 03          	cmp    $0x3,%ax
8010202b:	75 5c                	jne    80102089 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010202d:	8b 45 08             	mov    0x8(%ebp),%eax
80102030:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102034:	66 85 c0             	test   %ax,%ax
80102037:	78 20                	js     80102059 <readi+0x43>
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102040:	66 83 f8 09          	cmp    $0x9,%ax
80102044:	7f 13                	jg     80102059 <readi+0x43>
80102046:	8b 45 08             	mov    0x8(%ebp),%eax
80102049:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010204d:	98                   	cwtl   
8010204e:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80102055:	85 c0                	test   %eax,%eax
80102057:	75 0a                	jne    80102063 <readi+0x4d>
      return -1;
80102059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010205e:	e9 0a 01 00 00       	jmp    8010216d <readi+0x157>
    return devsw[ip->major].read(ip, dst, n, off);
80102063:	8b 45 08             	mov    0x8(%ebp),%eax
80102066:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010206a:	98                   	cwtl   
8010206b:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80102072:	8b 55 14             	mov    0x14(%ebp),%edx
80102075:	ff 75 10             	pushl  0x10(%ebp)
80102078:	52                   	push   %edx
80102079:	ff 75 0c             	pushl  0xc(%ebp)
8010207c:	ff 75 08             	pushl  0x8(%ebp)
8010207f:	ff d0                	call   *%eax
80102081:	83 c4 10             	add    $0x10,%esp
80102084:	e9 e4 00 00 00       	jmp    8010216d <readi+0x157>
  }

  if(off > ip->size || off + n < off)
80102089:	8b 45 08             	mov    0x8(%ebp),%eax
8010208c:	8b 40 58             	mov    0x58(%eax),%eax
8010208f:	39 45 10             	cmp    %eax,0x10(%ebp)
80102092:	77 0d                	ja     801020a1 <readi+0x8b>
80102094:	8b 55 10             	mov    0x10(%ebp),%edx
80102097:	8b 45 14             	mov    0x14(%ebp),%eax
8010209a:	01 d0                	add    %edx,%eax
8010209c:	39 45 10             	cmp    %eax,0x10(%ebp)
8010209f:	76 0a                	jbe    801020ab <readi+0x95>
    return -1;
801020a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a6:	e9 c2 00 00 00       	jmp    8010216d <readi+0x157>
  if(off + n > ip->size)
801020ab:	8b 55 10             	mov    0x10(%ebp),%edx
801020ae:	8b 45 14             	mov    0x14(%ebp),%eax
801020b1:	01 c2                	add    %eax,%edx
801020b3:	8b 45 08             	mov    0x8(%ebp),%eax
801020b6:	8b 40 58             	mov    0x58(%eax),%eax
801020b9:	39 c2                	cmp    %eax,%edx
801020bb:	76 0c                	jbe    801020c9 <readi+0xb3>
    n = ip->size - off;
801020bd:	8b 45 08             	mov    0x8(%ebp),%eax
801020c0:	8b 40 58             	mov    0x58(%eax),%eax
801020c3:	2b 45 10             	sub    0x10(%ebp),%eax
801020c6:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020d0:	e9 89 00 00 00       	jmp    8010215e <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020d5:	8b 45 10             	mov    0x10(%ebp),%eax
801020d8:	c1 e8 09             	shr    $0x9,%eax
801020db:	83 ec 08             	sub    $0x8,%esp
801020de:	50                   	push   %eax
801020df:	ff 75 08             	pushl  0x8(%ebp)
801020e2:	e8 8d fc ff ff       	call   80101d74 <bmap>
801020e7:	83 c4 10             	add    $0x10,%esp
801020ea:	8b 55 08             	mov    0x8(%ebp),%edx
801020ed:	8b 12                	mov    (%edx),%edx
801020ef:	83 ec 08             	sub    $0x8,%esp
801020f2:	50                   	push   %eax
801020f3:	52                   	push   %edx
801020f4:	e8 de e0 ff ff       	call   801001d7 <bread>
801020f9:	83 c4 10             	add    $0x10,%esp
801020fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102102:	25 ff 01 00 00       	and    $0x1ff,%eax
80102107:	ba 00 02 00 00       	mov    $0x200,%edx
8010210c:	29 c2                	sub    %eax,%edx
8010210e:	8b 45 14             	mov    0x14(%ebp),%eax
80102111:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102114:	39 c2                	cmp    %eax,%edx
80102116:	0f 46 c2             	cmovbe %edx,%eax
80102119:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010211c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010211f:	8d 50 5c             	lea    0x5c(%eax),%edx
80102122:	8b 45 10             	mov    0x10(%ebp),%eax
80102125:	25 ff 01 00 00       	and    $0x1ff,%eax
8010212a:	01 d0                	add    %edx,%eax
8010212c:	83 ec 04             	sub    $0x4,%esp
8010212f:	ff 75 ec             	pushl  -0x14(%ebp)
80102132:	50                   	push   %eax
80102133:	ff 75 0c             	pushl  0xc(%ebp)
80102136:	e8 09 34 00 00       	call   80105544 <memmove>
8010213b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010213e:	83 ec 0c             	sub    $0xc,%esp
80102141:	ff 75 f0             	pushl  -0x10(%ebp)
80102144:	e8 18 e1 ff ff       	call   80100261 <brelse>
80102149:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010214c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010214f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102152:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102155:	01 45 10             	add    %eax,0x10(%ebp)
80102158:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010215b:	01 45 0c             	add    %eax,0xc(%ebp)
8010215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102161:	3b 45 14             	cmp    0x14(%ebp),%eax
80102164:	0f 82 6b ff ff ff    	jb     801020d5 <readi+0xbf>
  }
  return n;
8010216a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010216d:	c9                   	leave  
8010216e:	c3                   	ret    

8010216f <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010216f:	f3 0f 1e fb          	endbr32 
80102173:	55                   	push   %ebp
80102174:	89 e5                	mov    %esp,%ebp
80102176:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102179:	8b 45 08             	mov    0x8(%ebp),%eax
8010217c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102180:	66 83 f8 03          	cmp    $0x3,%ax
80102184:	75 5c                	jne    801021e2 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102186:	8b 45 08             	mov    0x8(%ebp),%eax
80102189:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010218d:	66 85 c0             	test   %ax,%ax
80102190:	78 20                	js     801021b2 <writei+0x43>
80102192:	8b 45 08             	mov    0x8(%ebp),%eax
80102195:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102199:	66 83 f8 09          	cmp    $0x9,%ax
8010219d:	7f 13                	jg     801021b2 <writei+0x43>
8010219f:	8b 45 08             	mov    0x8(%ebp),%eax
801021a2:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021a6:	98                   	cwtl   
801021a7:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
801021ae:	85 c0                	test   %eax,%eax
801021b0:	75 0a                	jne    801021bc <writei+0x4d>
      return -1;
801021b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b7:	e9 3b 01 00 00       	jmp    801022f7 <writei+0x188>
    return devsw[ip->major].write(ip, src, n, off);
801021bc:	8b 45 08             	mov    0x8(%ebp),%eax
801021bf:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021c3:	98                   	cwtl   
801021c4:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
801021cb:	8b 55 14             	mov    0x14(%ebp),%edx
801021ce:	ff 75 10             	pushl  0x10(%ebp)
801021d1:	52                   	push   %edx
801021d2:	ff 75 0c             	pushl  0xc(%ebp)
801021d5:	ff 75 08             	pushl  0x8(%ebp)
801021d8:	ff d0                	call   *%eax
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	e9 15 01 00 00       	jmp    801022f7 <writei+0x188>
  }

  if(off > ip->size || off + n < off)
801021e2:	8b 45 08             	mov    0x8(%ebp),%eax
801021e5:	8b 40 58             	mov    0x58(%eax),%eax
801021e8:	39 45 10             	cmp    %eax,0x10(%ebp)
801021eb:	77 0d                	ja     801021fa <writei+0x8b>
801021ed:	8b 55 10             	mov    0x10(%ebp),%edx
801021f0:	8b 45 14             	mov    0x14(%ebp),%eax
801021f3:	01 d0                	add    %edx,%eax
801021f5:	39 45 10             	cmp    %eax,0x10(%ebp)
801021f8:	76 0a                	jbe    80102204 <writei+0x95>
    return -1;
801021fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021ff:	e9 f3 00 00 00       	jmp    801022f7 <writei+0x188>
  if(off + n > MAXFILE*BSIZE)
80102204:	8b 55 10             	mov    0x10(%ebp),%edx
80102207:	8b 45 14             	mov    0x14(%ebp),%eax
8010220a:	01 d0                	add    %edx,%eax
8010220c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102211:	76 0a                	jbe    8010221d <writei+0xae>
    return -1;
80102213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102218:	e9 da 00 00 00       	jmp    801022f7 <writei+0x188>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010221d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102224:	e9 97 00 00 00       	jmp    801022c0 <writei+0x151>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102229:	8b 45 10             	mov    0x10(%ebp),%eax
8010222c:	c1 e8 09             	shr    $0x9,%eax
8010222f:	83 ec 08             	sub    $0x8,%esp
80102232:	50                   	push   %eax
80102233:	ff 75 08             	pushl  0x8(%ebp)
80102236:	e8 39 fb ff ff       	call   80101d74 <bmap>
8010223b:	83 c4 10             	add    $0x10,%esp
8010223e:	8b 55 08             	mov    0x8(%ebp),%edx
80102241:	8b 12                	mov    (%edx),%edx
80102243:	83 ec 08             	sub    $0x8,%esp
80102246:	50                   	push   %eax
80102247:	52                   	push   %edx
80102248:	e8 8a df ff ff       	call   801001d7 <bread>
8010224d:	83 c4 10             	add    $0x10,%esp
80102250:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102253:	8b 45 10             	mov    0x10(%ebp),%eax
80102256:	25 ff 01 00 00       	and    $0x1ff,%eax
8010225b:	ba 00 02 00 00       	mov    $0x200,%edx
80102260:	29 c2                	sub    %eax,%edx
80102262:	8b 45 14             	mov    0x14(%ebp),%eax
80102265:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102268:	39 c2                	cmp    %eax,%edx
8010226a:	0f 46 c2             	cmovbe %edx,%eax
8010226d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102270:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102273:	8d 50 5c             	lea    0x5c(%eax),%edx
80102276:	8b 45 10             	mov    0x10(%ebp),%eax
80102279:	25 ff 01 00 00       	and    $0x1ff,%eax
8010227e:	01 d0                	add    %edx,%eax
80102280:	83 ec 04             	sub    $0x4,%esp
80102283:	ff 75 ec             	pushl  -0x14(%ebp)
80102286:	ff 75 0c             	pushl  0xc(%ebp)
80102289:	50                   	push   %eax
8010228a:	e8 b5 32 00 00       	call   80105544 <memmove>
8010228f:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102292:	83 ec 0c             	sub    $0xc,%esp
80102295:	ff 75 f0             	pushl  -0x10(%ebp)
80102298:	e8 89 16 00 00       	call   80103926 <log_write>
8010229d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801022a0:	83 ec 0c             	sub    $0xc,%esp
801022a3:	ff 75 f0             	pushl  -0x10(%ebp)
801022a6:	e8 b6 df ff ff       	call   80100261 <brelse>
801022ab:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022b1:	01 45 f4             	add    %eax,-0xc(%ebp)
801022b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022b7:	01 45 10             	add    %eax,0x10(%ebp)
801022ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022bd:	01 45 0c             	add    %eax,0xc(%ebp)
801022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c3:	3b 45 14             	cmp    0x14(%ebp),%eax
801022c6:	0f 82 5d ff ff ff    	jb     80102229 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
801022cc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801022d0:	74 22                	je     801022f4 <writei+0x185>
801022d2:	8b 45 08             	mov    0x8(%ebp),%eax
801022d5:	8b 40 58             	mov    0x58(%eax),%eax
801022d8:	39 45 10             	cmp    %eax,0x10(%ebp)
801022db:	76 17                	jbe    801022f4 <writei+0x185>
    ip->size = off;
801022dd:	8b 45 08             	mov    0x8(%ebp),%eax
801022e0:	8b 55 10             	mov    0x10(%ebp),%edx
801022e3:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801022e6:	83 ec 0c             	sub    $0xc,%esp
801022e9:	ff 75 08             	pushl  0x8(%ebp)
801022ec:	e8 34 f6 ff ff       	call   80101925 <iupdate>
801022f1:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801022f4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801022f7:	c9                   	leave  
801022f8:	c3                   	ret    

801022f9 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801022f9:	f3 0f 1e fb          	endbr32 
801022fd:	55                   	push   %ebp
801022fe:	89 e5                	mov    %esp,%ebp
80102300:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102303:	83 ec 04             	sub    $0x4,%esp
80102306:	6a 0e                	push   $0xe
80102308:	ff 75 0c             	pushl  0xc(%ebp)
8010230b:	ff 75 08             	pushl  0x8(%ebp)
8010230e:	e8 cf 32 00 00       	call   801055e2 <strncmp>
80102313:	83 c4 10             	add    $0x10,%esp
}
80102316:	c9                   	leave  
80102317:	c3                   	ret    

80102318 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102318:	f3 0f 1e fb          	endbr32 
8010231c:	55                   	push   %ebp
8010231d:	89 e5                	mov    %esp,%ebp
8010231f:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102322:	8b 45 08             	mov    0x8(%ebp),%eax
80102325:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102329:	66 83 f8 01          	cmp    $0x1,%ax
8010232d:	74 0d                	je     8010233c <dirlookup+0x24>
    panic("dirlookup not DIR");
8010232f:	83 ec 0c             	sub    $0xc,%esp
80102332:	68 9d 88 10 80       	push   $0x8010889d
80102337:	e8 95 e2 ff ff       	call   801005d1 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010233c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102343:	eb 7b                	jmp    801023c0 <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102345:	6a 10                	push   $0x10
80102347:	ff 75 f4             	pushl  -0xc(%ebp)
8010234a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234d:	50                   	push   %eax
8010234e:	ff 75 08             	pushl  0x8(%ebp)
80102351:	e8 c0 fc ff ff       	call   80102016 <readi>
80102356:	83 c4 10             	add    $0x10,%esp
80102359:	83 f8 10             	cmp    $0x10,%eax
8010235c:	74 0d                	je     8010236b <dirlookup+0x53>
      panic("dirlookup read");
8010235e:	83 ec 0c             	sub    $0xc,%esp
80102361:	68 af 88 10 80       	push   $0x801088af
80102366:	e8 66 e2 ff ff       	call   801005d1 <panic>
    if(de.inum == 0)
8010236b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010236f:	66 85 c0             	test   %ax,%ax
80102372:	74 47                	je     801023bb <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
80102374:	83 ec 08             	sub    $0x8,%esp
80102377:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010237a:	83 c0 02             	add    $0x2,%eax
8010237d:	50                   	push   %eax
8010237e:	ff 75 0c             	pushl  0xc(%ebp)
80102381:	e8 73 ff ff ff       	call   801022f9 <namecmp>
80102386:	83 c4 10             	add    $0x10,%esp
80102389:	85 c0                	test   %eax,%eax
8010238b:	75 2f                	jne    801023bc <dirlookup+0xa4>
      // entry matches path element
      if(poff)
8010238d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102391:	74 08                	je     8010239b <dirlookup+0x83>
        *poff = off;
80102393:	8b 45 10             	mov    0x10(%ebp),%eax
80102396:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102399:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010239b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010239f:	0f b7 c0             	movzwl %ax,%eax
801023a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
801023a8:	8b 00                	mov    (%eax),%eax
801023aa:	83 ec 08             	sub    $0x8,%esp
801023ad:	ff 75 f0             	pushl  -0x10(%ebp)
801023b0:	50                   	push   %eax
801023b1:	e8 34 f6 ff ff       	call   801019ea <iget>
801023b6:	83 c4 10             	add    $0x10,%esp
801023b9:	eb 19                	jmp    801023d4 <dirlookup+0xbc>
      continue;
801023bb:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
801023bc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801023c0:	8b 45 08             	mov    0x8(%ebp),%eax
801023c3:	8b 40 58             	mov    0x58(%eax),%eax
801023c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801023c9:	0f 82 76 ff ff ff    	jb     80102345 <dirlookup+0x2d>
    }
  }

  return 0;
801023cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023d4:	c9                   	leave  
801023d5:	c3                   	ret    

801023d6 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023d6:	f3 0f 1e fb          	endbr32 
801023da:	55                   	push   %ebp
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023e0:	83 ec 04             	sub    $0x4,%esp
801023e3:	6a 00                	push   $0x0
801023e5:	ff 75 0c             	pushl  0xc(%ebp)
801023e8:	ff 75 08             	pushl  0x8(%ebp)
801023eb:	e8 28 ff ff ff       	call   80102318 <dirlookup>
801023f0:	83 c4 10             	add    $0x10,%esp
801023f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023fa:	74 18                	je     80102414 <dirlink+0x3e>
    iput(ip);
801023fc:	83 ec 0c             	sub    $0xc,%esp
801023ff:	ff 75 f0             	pushl  -0x10(%ebp)
80102402:	e8 70 f8 ff ff       	call   80101c77 <iput>
80102407:	83 c4 10             	add    $0x10,%esp
    return -1;
8010240a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010240f:	e9 9c 00 00 00       	jmp    801024b0 <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102414:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010241b:	eb 39                	jmp    80102456 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102420:	6a 10                	push   $0x10
80102422:	50                   	push   %eax
80102423:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102426:	50                   	push   %eax
80102427:	ff 75 08             	pushl  0x8(%ebp)
8010242a:	e8 e7 fb ff ff       	call   80102016 <readi>
8010242f:	83 c4 10             	add    $0x10,%esp
80102432:	83 f8 10             	cmp    $0x10,%eax
80102435:	74 0d                	je     80102444 <dirlink+0x6e>
      panic("dirlink read");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 be 88 10 80       	push   $0x801088be
8010243f:	e8 8d e1 ff ff       	call   801005d1 <panic>
    if(de.inum == 0)
80102444:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102448:	66 85 c0             	test   %ax,%ax
8010244b:	74 18                	je     80102465 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102450:	83 c0 10             	add    $0x10,%eax
80102453:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102456:	8b 45 08             	mov    0x8(%ebp),%eax
80102459:	8b 50 58             	mov    0x58(%eax),%edx
8010245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245f:	39 c2                	cmp    %eax,%edx
80102461:	77 ba                	ja     8010241d <dirlink+0x47>
80102463:	eb 01                	jmp    80102466 <dirlink+0x90>
      break;
80102465:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102466:	83 ec 04             	sub    $0x4,%esp
80102469:	6a 0e                	push   $0xe
8010246b:	ff 75 0c             	pushl  0xc(%ebp)
8010246e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102471:	83 c0 02             	add    $0x2,%eax
80102474:	50                   	push   %eax
80102475:	e8 c2 31 00 00       	call   8010563c <strncpy>
8010247a:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010247d:	8b 45 10             	mov    0x10(%ebp),%eax
80102480:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102484:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102487:	6a 10                	push   $0x10
80102489:	50                   	push   %eax
8010248a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010248d:	50                   	push   %eax
8010248e:	ff 75 08             	pushl  0x8(%ebp)
80102491:	e8 d9 fc ff ff       	call   8010216f <writei>
80102496:	83 c4 10             	add    $0x10,%esp
80102499:	83 f8 10             	cmp    $0x10,%eax
8010249c:	74 0d                	je     801024ab <dirlink+0xd5>
    panic("dirlink");
8010249e:	83 ec 0c             	sub    $0xc,%esp
801024a1:	68 cb 88 10 80       	push   $0x801088cb
801024a6:	e8 26 e1 ff ff       	call   801005d1 <panic>

  return 0;
801024ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024b0:	c9                   	leave  
801024b1:	c3                   	ret    

801024b2 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801024b2:	f3 0f 1e fb          	endbr32 
801024b6:	55                   	push   %ebp
801024b7:	89 e5                	mov    %esp,%ebp
801024b9:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801024bc:	eb 04                	jmp    801024c2 <skipelem+0x10>
    path++;
801024be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801024c2:	8b 45 08             	mov    0x8(%ebp),%eax
801024c5:	0f b6 00             	movzbl (%eax),%eax
801024c8:	3c 2f                	cmp    $0x2f,%al
801024ca:	74 f2                	je     801024be <skipelem+0xc>
  if(*path == 0)
801024cc:	8b 45 08             	mov    0x8(%ebp),%eax
801024cf:	0f b6 00             	movzbl (%eax),%eax
801024d2:	84 c0                	test   %al,%al
801024d4:	75 07                	jne    801024dd <skipelem+0x2b>
    return 0;
801024d6:	b8 00 00 00 00       	mov    $0x0,%eax
801024db:	eb 77                	jmp    80102554 <skipelem+0xa2>
  s = path;
801024dd:	8b 45 08             	mov    0x8(%ebp),%eax
801024e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024e3:	eb 04                	jmp    801024e9 <skipelem+0x37>
    path++;
801024e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801024e9:	8b 45 08             	mov    0x8(%ebp),%eax
801024ec:	0f b6 00             	movzbl (%eax),%eax
801024ef:	3c 2f                	cmp    $0x2f,%al
801024f1:	74 0a                	je     801024fd <skipelem+0x4b>
801024f3:	8b 45 08             	mov    0x8(%ebp),%eax
801024f6:	0f b6 00             	movzbl (%eax),%eax
801024f9:	84 c0                	test   %al,%al
801024fb:	75 e8                	jne    801024e5 <skipelem+0x33>
  len = path - s;
801024fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102500:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102503:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102506:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010250a:	7e 15                	jle    80102521 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010250c:	83 ec 04             	sub    $0x4,%esp
8010250f:	6a 0e                	push   $0xe
80102511:	ff 75 f4             	pushl  -0xc(%ebp)
80102514:	ff 75 0c             	pushl  0xc(%ebp)
80102517:	e8 28 30 00 00       	call   80105544 <memmove>
8010251c:	83 c4 10             	add    $0x10,%esp
8010251f:	eb 26                	jmp    80102547 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102521:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102524:	83 ec 04             	sub    $0x4,%esp
80102527:	50                   	push   %eax
80102528:	ff 75 f4             	pushl  -0xc(%ebp)
8010252b:	ff 75 0c             	pushl  0xc(%ebp)
8010252e:	e8 11 30 00 00       	call   80105544 <memmove>
80102533:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102536:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102539:	8b 45 0c             	mov    0xc(%ebp),%eax
8010253c:	01 d0                	add    %edx,%eax
8010253e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102541:	eb 04                	jmp    80102547 <skipelem+0x95>
    path++;
80102543:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102547:	8b 45 08             	mov    0x8(%ebp),%eax
8010254a:	0f b6 00             	movzbl (%eax),%eax
8010254d:	3c 2f                	cmp    $0x2f,%al
8010254f:	74 f2                	je     80102543 <skipelem+0x91>
  return path;
80102551:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102554:	c9                   	leave  
80102555:	c3                   	ret    

80102556 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102556:	f3 0f 1e fb          	endbr32 
8010255a:	55                   	push   %ebp
8010255b:	89 e5                	mov    %esp,%ebp
8010255d:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102560:	8b 45 08             	mov    0x8(%ebp),%eax
80102563:	0f b6 00             	movzbl (%eax),%eax
80102566:	3c 2f                	cmp    $0x2f,%al
80102568:	75 17                	jne    80102581 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
8010256a:	83 ec 08             	sub    $0x8,%esp
8010256d:	6a 01                	push   $0x1
8010256f:	6a 01                	push   $0x1
80102571:	e8 74 f4 ff ff       	call   801019ea <iget>
80102576:	83 c4 10             	add    $0x10,%esp
80102579:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010257c:	e9 ba 00 00 00       	jmp    8010263b <namex+0xe5>
  else
    ip = idup(myproc()->cwd);
80102581:	e8 16 1f 00 00       	call   8010449c <myproc>
80102586:	8b 40 68             	mov    0x68(%eax),%eax
80102589:	83 ec 0c             	sub    $0xc,%esp
8010258c:	50                   	push   %eax
8010258d:	e8 3e f5 ff ff       	call   80101ad0 <idup>
80102592:	83 c4 10             	add    $0x10,%esp
80102595:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102598:	e9 9e 00 00 00       	jmp    8010263b <namex+0xe5>
    ilock(ip);
8010259d:	83 ec 0c             	sub    $0xc,%esp
801025a0:	ff 75 f4             	pushl  -0xc(%ebp)
801025a3:	e8 66 f5 ff ff       	call   80101b0e <ilock>
801025a8:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ae:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801025b2:	66 83 f8 01          	cmp    $0x1,%ax
801025b6:	74 18                	je     801025d0 <namex+0x7a>
      iunlockput(ip);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	ff 75 f4             	pushl  -0xc(%ebp)
801025be:	e8 88 f7 ff ff       	call   80101d4b <iunlockput>
801025c3:	83 c4 10             	add    $0x10,%esp
      return 0;
801025c6:	b8 00 00 00 00       	mov    $0x0,%eax
801025cb:	e9 a7 00 00 00       	jmp    80102677 <namex+0x121>
    }
    if(nameiparent && *path == '\0'){
801025d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025d4:	74 20                	je     801025f6 <namex+0xa0>
801025d6:	8b 45 08             	mov    0x8(%ebp),%eax
801025d9:	0f b6 00             	movzbl (%eax),%eax
801025dc:	84 c0                	test   %al,%al
801025de:	75 16                	jne    801025f6 <namex+0xa0>
      // Stop one level early.
      iunlock(ip);
801025e0:	83 ec 0c             	sub    $0xc,%esp
801025e3:	ff 75 f4             	pushl  -0xc(%ebp)
801025e6:	e8 3a f6 ff ff       	call   80101c25 <iunlock>
801025eb:	83 c4 10             	add    $0x10,%esp
      return ip;
801025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025f1:	e9 81 00 00 00       	jmp    80102677 <namex+0x121>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801025f6:	83 ec 04             	sub    $0x4,%esp
801025f9:	6a 00                	push   $0x0
801025fb:	ff 75 10             	pushl  0x10(%ebp)
801025fe:	ff 75 f4             	pushl  -0xc(%ebp)
80102601:	e8 12 fd ff ff       	call   80102318 <dirlookup>
80102606:	83 c4 10             	add    $0x10,%esp
80102609:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010260c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102610:	75 15                	jne    80102627 <namex+0xd1>
      iunlockput(ip);
80102612:	83 ec 0c             	sub    $0xc,%esp
80102615:	ff 75 f4             	pushl  -0xc(%ebp)
80102618:	e8 2e f7 ff ff       	call   80101d4b <iunlockput>
8010261d:	83 c4 10             	add    $0x10,%esp
      return 0;
80102620:	b8 00 00 00 00       	mov    $0x0,%eax
80102625:	eb 50                	jmp    80102677 <namex+0x121>
    }
    iunlockput(ip);
80102627:	83 ec 0c             	sub    $0xc,%esp
8010262a:	ff 75 f4             	pushl  -0xc(%ebp)
8010262d:	e8 19 f7 ff ff       	call   80101d4b <iunlockput>
80102632:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102635:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102638:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
8010263b:	83 ec 08             	sub    $0x8,%esp
8010263e:	ff 75 10             	pushl  0x10(%ebp)
80102641:	ff 75 08             	pushl  0x8(%ebp)
80102644:	e8 69 fe ff ff       	call   801024b2 <skipelem>
80102649:	83 c4 10             	add    $0x10,%esp
8010264c:	89 45 08             	mov    %eax,0x8(%ebp)
8010264f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102653:	0f 85 44 ff ff ff    	jne    8010259d <namex+0x47>
  }
  if(nameiparent){
80102659:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010265d:	74 15                	je     80102674 <namex+0x11e>
    iput(ip);
8010265f:	83 ec 0c             	sub    $0xc,%esp
80102662:	ff 75 f4             	pushl  -0xc(%ebp)
80102665:	e8 0d f6 ff ff       	call   80101c77 <iput>
8010266a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010266d:	b8 00 00 00 00       	mov    $0x0,%eax
80102672:	eb 03                	jmp    80102677 <namex+0x121>
  }
  return ip;
80102674:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102677:	c9                   	leave  
80102678:	c3                   	ret    

80102679 <namei>:

struct inode*
namei(char *path)
{
80102679:	f3 0f 1e fb          	endbr32 
8010267d:	55                   	push   %ebp
8010267e:	89 e5                	mov    %esp,%ebp
80102680:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102683:	83 ec 04             	sub    $0x4,%esp
80102686:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102689:	50                   	push   %eax
8010268a:	6a 00                	push   $0x0
8010268c:	ff 75 08             	pushl  0x8(%ebp)
8010268f:	e8 c2 fe ff ff       	call   80102556 <namex>
80102694:	83 c4 10             	add    $0x10,%esp
}
80102697:	c9                   	leave  
80102698:	c3                   	ret    

80102699 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102699:	f3 0f 1e fb          	endbr32 
8010269d:	55                   	push   %ebp
8010269e:	89 e5                	mov    %esp,%ebp
801026a0:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801026a3:	83 ec 04             	sub    $0x4,%esp
801026a6:	ff 75 0c             	pushl  0xc(%ebp)
801026a9:	6a 01                	push   $0x1
801026ab:	ff 75 08             	pushl  0x8(%ebp)
801026ae:	e8 a3 fe ff ff       	call   80102556 <namex>
801026b3:	83 c4 10             	add    $0x10,%esp
}
801026b6:	c9                   	leave  
801026b7:	c3                   	ret    

801026b8 <inb>:
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 14             	sub    $0x14,%esp
801026be:	8b 45 08             	mov    0x8(%ebp),%eax
801026c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801026c9:	89 c2                	mov    %eax,%edx
801026cb:	ec                   	in     (%dx),%al
801026cc:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801026cf:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801026d3:	c9                   	leave  
801026d4:	c3                   	ret    

801026d5 <insl>:
{
801026d5:	55                   	push   %ebp
801026d6:	89 e5                	mov    %esp,%ebp
801026d8:	57                   	push   %edi
801026d9:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801026da:	8b 55 08             	mov    0x8(%ebp),%edx
801026dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026e0:	8b 45 10             	mov    0x10(%ebp),%eax
801026e3:	89 cb                	mov    %ecx,%ebx
801026e5:	89 df                	mov    %ebx,%edi
801026e7:	89 c1                	mov    %eax,%ecx
801026e9:	fc                   	cld    
801026ea:	f3 6d                	rep insl (%dx),%es:(%edi)
801026ec:	89 c8                	mov    %ecx,%eax
801026ee:	89 fb                	mov    %edi,%ebx
801026f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801026f3:	89 45 10             	mov    %eax,0x10(%ebp)
}
801026f6:	90                   	nop
801026f7:	5b                   	pop    %ebx
801026f8:	5f                   	pop    %edi
801026f9:	5d                   	pop    %ebp
801026fa:	c3                   	ret    

801026fb <outb>:
{
801026fb:	55                   	push   %ebp
801026fc:	89 e5                	mov    %esp,%ebp
801026fe:	83 ec 08             	sub    $0x8,%esp
80102701:	8b 45 08             	mov    0x8(%ebp),%eax
80102704:	8b 55 0c             	mov    0xc(%ebp),%edx
80102707:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010270b:	89 d0                	mov    %edx,%eax
8010270d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102710:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102714:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102718:	ee                   	out    %al,(%dx)
}
80102719:	90                   	nop
8010271a:	c9                   	leave  
8010271b:	c3                   	ret    

8010271c <outsl>:
{
8010271c:	55                   	push   %ebp
8010271d:	89 e5                	mov    %esp,%ebp
8010271f:	56                   	push   %esi
80102720:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102721:	8b 55 08             	mov    0x8(%ebp),%edx
80102724:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102727:	8b 45 10             	mov    0x10(%ebp),%eax
8010272a:	89 cb                	mov    %ecx,%ebx
8010272c:	89 de                	mov    %ebx,%esi
8010272e:	89 c1                	mov    %eax,%ecx
80102730:	fc                   	cld    
80102731:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102733:	89 c8                	mov    %ecx,%eax
80102735:	89 f3                	mov    %esi,%ebx
80102737:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010273a:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010273d:	90                   	nop
8010273e:	5b                   	pop    %ebx
8010273f:	5e                   	pop    %esi
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    

80102742 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102742:	f3 0f 1e fb          	endbr32 
80102746:	55                   	push   %ebp
80102747:	89 e5                	mov    %esp,%ebp
80102749:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010274c:	90                   	nop
8010274d:	68 f7 01 00 00       	push   $0x1f7
80102752:	e8 61 ff ff ff       	call   801026b8 <inb>
80102757:	83 c4 04             	add    $0x4,%esp
8010275a:	0f b6 c0             	movzbl %al,%eax
8010275d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102760:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102763:	25 c0 00 00 00       	and    $0xc0,%eax
80102768:	83 f8 40             	cmp    $0x40,%eax
8010276b:	75 e0                	jne    8010274d <idewait+0xb>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010276d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102771:	74 11                	je     80102784 <idewait+0x42>
80102773:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102776:	83 e0 21             	and    $0x21,%eax
80102779:	85 c0                	test   %eax,%eax
8010277b:	74 07                	je     80102784 <idewait+0x42>
    return -1;
8010277d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102782:	eb 05                	jmp    80102789 <idewait+0x47>
  return 0;
80102784:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102789:	c9                   	leave  
8010278a:	c3                   	ret    

8010278b <ideinit>:

void
ideinit(void)
{
8010278b:	f3 0f 1e fb          	endbr32 
8010278f:	55                   	push   %ebp
80102790:	89 e5                	mov    %esp,%ebp
80102792:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102795:	83 ec 08             	sub    $0x8,%esp
80102798:	68 d3 88 10 80       	push   $0x801088d3
8010279d:	68 e0 b5 10 80       	push   $0x8010b5e0
801027a2:	e8 11 2a 00 00       	call   801051b8 <initlock>
801027a7:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801027aa:	a1 80 3d 11 80       	mov    0x80113d80,%eax
801027af:	83 e8 01             	sub    $0x1,%eax
801027b2:	83 ec 08             	sub    $0x8,%esp
801027b5:	50                   	push   %eax
801027b6:	6a 0e                	push   $0xe
801027b8:	e8 bb 04 00 00       	call   80102c78 <ioapicenable>
801027bd:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	6a 00                	push   $0x0
801027c5:	e8 78 ff ff ff       	call   80102742 <idewait>
801027ca:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801027cd:	83 ec 08             	sub    $0x8,%esp
801027d0:	68 f0 00 00 00       	push   $0xf0
801027d5:	68 f6 01 00 00       	push   $0x1f6
801027da:	e8 1c ff ff ff       	call   801026fb <outb>
801027df:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801027e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027e9:	eb 24                	jmp    8010280f <ideinit+0x84>
    if(inb(0x1f7) != 0){
801027eb:	83 ec 0c             	sub    $0xc,%esp
801027ee:	68 f7 01 00 00       	push   $0x1f7
801027f3:	e8 c0 fe ff ff       	call   801026b8 <inb>
801027f8:	83 c4 10             	add    $0x10,%esp
801027fb:	84 c0                	test   %al,%al
801027fd:	74 0c                	je     8010280b <ideinit+0x80>
      havedisk1 = 1;
801027ff:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
80102806:	00 00 00 
      break;
80102809:	eb 0d                	jmp    80102818 <ideinit+0x8d>
  for(i=0; i<1000; i++){
8010280b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010280f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102816:	7e d3                	jle    801027eb <ideinit+0x60>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102818:	83 ec 08             	sub    $0x8,%esp
8010281b:	68 e0 00 00 00       	push   $0xe0
80102820:	68 f6 01 00 00       	push   $0x1f6
80102825:	e8 d1 fe ff ff       	call   801026fb <outb>
8010282a:	83 c4 10             	add    $0x10,%esp
}
8010282d:	90                   	nop
8010282e:	c9                   	leave  
8010282f:	c3                   	ret    

80102830 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102830:	f3 0f 1e fb          	endbr32 
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010283a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010283e:	75 0d                	jne    8010284d <idestart+0x1d>
    panic("idestart");
80102840:	83 ec 0c             	sub    $0xc,%esp
80102843:	68 d7 88 10 80       	push   $0x801088d7
80102848:	e8 84 dd ff ff       	call   801005d1 <panic>
  if(b->blockno >= FSSIZE)
8010284d:	8b 45 08             	mov    0x8(%ebp),%eax
80102850:	8b 40 08             	mov    0x8(%eax),%eax
80102853:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102858:	76 0d                	jbe    80102867 <idestart+0x37>
    panic("incorrect blockno");
8010285a:	83 ec 0c             	sub    $0xc,%esp
8010285d:	68 e0 88 10 80       	push   $0x801088e0
80102862:	e8 6a dd ff ff       	call   801005d1 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102867:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010286e:	8b 45 08             	mov    0x8(%ebp),%eax
80102871:	8b 50 08             	mov    0x8(%eax),%edx
80102874:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102877:	0f af c2             	imul   %edx,%eax
8010287a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010287d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102881:	75 07                	jne    8010288a <idestart+0x5a>
80102883:	b8 20 00 00 00       	mov    $0x20,%eax
80102888:	eb 05                	jmp    8010288f <idestart+0x5f>
8010288a:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010288f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102892:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102896:	75 07                	jne    8010289f <idestart+0x6f>
80102898:	b8 30 00 00 00       	mov    $0x30,%eax
8010289d:	eb 05                	jmp    801028a4 <idestart+0x74>
8010289f:	b8 c5 00 00 00       	mov    $0xc5,%eax
801028a4:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801028a7:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801028ab:	7e 0d                	jle    801028ba <idestart+0x8a>
801028ad:	83 ec 0c             	sub    $0xc,%esp
801028b0:	68 d7 88 10 80       	push   $0x801088d7
801028b5:	e8 17 dd ff ff       	call   801005d1 <panic>

  idewait(0);
801028ba:	83 ec 0c             	sub    $0xc,%esp
801028bd:	6a 00                	push   $0x0
801028bf:	e8 7e fe ff ff       	call   80102742 <idewait>
801028c4:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801028c7:	83 ec 08             	sub    $0x8,%esp
801028ca:	6a 00                	push   $0x0
801028cc:	68 f6 03 00 00       	push   $0x3f6
801028d1:	e8 25 fe ff ff       	call   801026fb <outb>
801028d6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028dc:	0f b6 c0             	movzbl %al,%eax
801028df:	83 ec 08             	sub    $0x8,%esp
801028e2:	50                   	push   %eax
801028e3:	68 f2 01 00 00       	push   $0x1f2
801028e8:	e8 0e fe ff ff       	call   801026fb <outb>
801028ed:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801028f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028f3:	0f b6 c0             	movzbl %al,%eax
801028f6:	83 ec 08             	sub    $0x8,%esp
801028f9:	50                   	push   %eax
801028fa:	68 f3 01 00 00       	push   $0x1f3
801028ff:	e8 f7 fd ff ff       	call   801026fb <outb>
80102904:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102907:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010290a:	c1 f8 08             	sar    $0x8,%eax
8010290d:	0f b6 c0             	movzbl %al,%eax
80102910:	83 ec 08             	sub    $0x8,%esp
80102913:	50                   	push   %eax
80102914:	68 f4 01 00 00       	push   $0x1f4
80102919:	e8 dd fd ff ff       	call   801026fb <outb>
8010291e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102924:	c1 f8 10             	sar    $0x10,%eax
80102927:	0f b6 c0             	movzbl %al,%eax
8010292a:	83 ec 08             	sub    $0x8,%esp
8010292d:	50                   	push   %eax
8010292e:	68 f5 01 00 00       	push   $0x1f5
80102933:	e8 c3 fd ff ff       	call   801026fb <outb>
80102938:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010293b:	8b 45 08             	mov    0x8(%ebp),%eax
8010293e:	8b 40 04             	mov    0x4(%eax),%eax
80102941:	c1 e0 04             	shl    $0x4,%eax
80102944:	83 e0 10             	and    $0x10,%eax
80102947:	89 c2                	mov    %eax,%edx
80102949:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010294c:	c1 f8 18             	sar    $0x18,%eax
8010294f:	83 e0 0f             	and    $0xf,%eax
80102952:	09 d0                	or     %edx,%eax
80102954:	83 c8 e0             	or     $0xffffffe0,%eax
80102957:	0f b6 c0             	movzbl %al,%eax
8010295a:	83 ec 08             	sub    $0x8,%esp
8010295d:	50                   	push   %eax
8010295e:	68 f6 01 00 00       	push   $0x1f6
80102963:	e8 93 fd ff ff       	call   801026fb <outb>
80102968:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010296b:	8b 45 08             	mov    0x8(%ebp),%eax
8010296e:	8b 00                	mov    (%eax),%eax
80102970:	83 e0 04             	and    $0x4,%eax
80102973:	85 c0                	test   %eax,%eax
80102975:	74 35                	je     801029ac <idestart+0x17c>
    outb(0x1f7, write_cmd);
80102977:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010297a:	0f b6 c0             	movzbl %al,%eax
8010297d:	83 ec 08             	sub    $0x8,%esp
80102980:	50                   	push   %eax
80102981:	68 f7 01 00 00       	push   $0x1f7
80102986:	e8 70 fd ff ff       	call   801026fb <outb>
8010298b:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010298e:	8b 45 08             	mov    0x8(%ebp),%eax
80102991:	83 c0 5c             	add    $0x5c,%eax
80102994:	83 ec 04             	sub    $0x4,%esp
80102997:	68 80 00 00 00       	push   $0x80
8010299c:	50                   	push   %eax
8010299d:	68 f0 01 00 00       	push   $0x1f0
801029a2:	e8 75 fd ff ff       	call   8010271c <outsl>
801029a7:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
801029aa:	eb 17                	jmp    801029c3 <idestart+0x193>
    outb(0x1f7, read_cmd);
801029ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029af:	0f b6 c0             	movzbl %al,%eax
801029b2:	83 ec 08             	sub    $0x8,%esp
801029b5:	50                   	push   %eax
801029b6:	68 f7 01 00 00       	push   $0x1f7
801029bb:	e8 3b fd ff ff       	call   801026fb <outb>
801029c0:	83 c4 10             	add    $0x10,%esp
}
801029c3:	90                   	nop
801029c4:	c9                   	leave  
801029c5:	c3                   	ret    

801029c6 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801029c6:	f3 0f 1e fb          	endbr32 
801029ca:	55                   	push   %ebp
801029cb:	89 e5                	mov    %esp,%ebp
801029cd:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801029d0:	83 ec 0c             	sub    $0xc,%esp
801029d3:	68 e0 b5 10 80       	push   $0x8010b5e0
801029d8:	e8 01 28 00 00       	call   801051de <acquire>
801029dd:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
801029e0:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801029e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801029ec:	75 15                	jne    80102a03 <ideintr+0x3d>
    release(&idelock);
801029ee:	83 ec 0c             	sub    $0xc,%esp
801029f1:	68 e0 b5 10 80       	push   $0x8010b5e0
801029f6:	e8 55 28 00 00       	call   80105250 <release>
801029fb:	83 c4 10             	add    $0x10,%esp
    return;
801029fe:	e9 9a 00 00 00       	jmp    80102a9d <ideintr+0xd7>
  }
  idequeue = b->qnext;
80102a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a06:	8b 40 58             	mov    0x58(%eax),%eax
80102a09:	a3 14 b6 10 80       	mov    %eax,0x8010b614

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a11:	8b 00                	mov    (%eax),%eax
80102a13:	83 e0 04             	and    $0x4,%eax
80102a16:	85 c0                	test   %eax,%eax
80102a18:	75 2d                	jne    80102a47 <ideintr+0x81>
80102a1a:	83 ec 0c             	sub    $0xc,%esp
80102a1d:	6a 01                	push   $0x1
80102a1f:	e8 1e fd ff ff       	call   80102742 <idewait>
80102a24:	83 c4 10             	add    $0x10,%esp
80102a27:	85 c0                	test   %eax,%eax
80102a29:	78 1c                	js     80102a47 <ideintr+0x81>
    insl(0x1f0, b->data, BSIZE/4);
80102a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2e:	83 c0 5c             	add    $0x5c,%eax
80102a31:	83 ec 04             	sub    $0x4,%esp
80102a34:	68 80 00 00 00       	push   $0x80
80102a39:	50                   	push   %eax
80102a3a:	68 f0 01 00 00       	push   $0x1f0
80102a3f:	e8 91 fc ff ff       	call   801026d5 <insl>
80102a44:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4a:	8b 00                	mov    (%eax),%eax
80102a4c:	83 c8 02             	or     $0x2,%eax
80102a4f:	89 c2                	mov    %eax,%edx
80102a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a54:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a59:	8b 00                	mov    (%eax),%eax
80102a5b:	83 e0 fb             	and    $0xfffffffb,%eax
80102a5e:	89 c2                	mov    %eax,%edx
80102a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a63:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a65:	83 ec 0c             	sub    $0xc,%esp
80102a68:	ff 75 f4             	pushl  -0xc(%ebp)
80102a6b:	e8 f4 23 00 00       	call   80104e64 <wakeup>
80102a70:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a73:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102a78:	85 c0                	test   %eax,%eax
80102a7a:	74 11                	je     80102a8d <ideintr+0xc7>
    idestart(idequeue);
80102a7c:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102a81:	83 ec 0c             	sub    $0xc,%esp
80102a84:	50                   	push   %eax
80102a85:	e8 a6 fd ff ff       	call   80102830 <idestart>
80102a8a:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102a8d:	83 ec 0c             	sub    $0xc,%esp
80102a90:	68 e0 b5 10 80       	push   $0x8010b5e0
80102a95:	e8 b6 27 00 00       	call   80105250 <release>
80102a9a:	83 c4 10             	add    $0x10,%esp
}
80102a9d:	c9                   	leave  
80102a9e:	c3                   	ret    

80102a9f <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a9f:	f3 0f 1e fb          	endbr32 
80102aa3:	55                   	push   %ebp
80102aa4:	89 e5                	mov    %esp,%ebp
80102aa6:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80102aac:	83 c0 0c             	add    $0xc,%eax
80102aaf:	83 ec 0c             	sub    $0xc,%esp
80102ab2:	50                   	push   %eax
80102ab3:	e8 67 26 00 00       	call   8010511f <holdingsleep>
80102ab8:	83 c4 10             	add    $0x10,%esp
80102abb:	85 c0                	test   %eax,%eax
80102abd:	75 0d                	jne    80102acc <iderw+0x2d>
    panic("iderw: buf not locked");
80102abf:	83 ec 0c             	sub    $0xc,%esp
80102ac2:	68 f2 88 10 80       	push   $0x801088f2
80102ac7:	e8 05 db ff ff       	call   801005d1 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102acc:	8b 45 08             	mov    0x8(%ebp),%eax
80102acf:	8b 00                	mov    (%eax),%eax
80102ad1:	83 e0 06             	and    $0x6,%eax
80102ad4:	83 f8 02             	cmp    $0x2,%eax
80102ad7:	75 0d                	jne    80102ae6 <iderw+0x47>
    panic("iderw: nothing to do");
80102ad9:	83 ec 0c             	sub    $0xc,%esp
80102adc:	68 08 89 10 80       	push   $0x80108908
80102ae1:	e8 eb da ff ff       	call   801005d1 <panic>
  if(b->dev != 0 && !havedisk1)
80102ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae9:	8b 40 04             	mov    0x4(%eax),%eax
80102aec:	85 c0                	test   %eax,%eax
80102aee:	74 16                	je     80102b06 <iderw+0x67>
80102af0:	a1 18 b6 10 80       	mov    0x8010b618,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	75 0d                	jne    80102b06 <iderw+0x67>
    panic("iderw: ide disk 1 not present");
80102af9:	83 ec 0c             	sub    $0xc,%esp
80102afc:	68 1d 89 10 80       	push   $0x8010891d
80102b01:	e8 cb da ff ff       	call   801005d1 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102b06:	83 ec 0c             	sub    $0xc,%esp
80102b09:	68 e0 b5 10 80       	push   $0x8010b5e0
80102b0e:	e8 cb 26 00 00       	call   801051de <acquire>
80102b13:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102b16:	8b 45 08             	mov    0x8(%ebp),%eax
80102b19:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b20:	c7 45 f4 14 b6 10 80 	movl   $0x8010b614,-0xc(%ebp)
80102b27:	eb 0b                	jmp    80102b34 <iderw+0x95>
80102b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2c:	8b 00                	mov    (%eax),%eax
80102b2e:	83 c0 58             	add    $0x58,%eax
80102b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b37:	8b 00                	mov    (%eax),%eax
80102b39:	85 c0                	test   %eax,%eax
80102b3b:	75 ec                	jne    80102b29 <iderw+0x8a>
    ;
  *pp = b;
80102b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b40:	8b 55 08             	mov    0x8(%ebp),%edx
80102b43:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102b45:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102b4a:	39 45 08             	cmp    %eax,0x8(%ebp)
80102b4d:	75 23                	jne    80102b72 <iderw+0xd3>
    idestart(b);
80102b4f:	83 ec 0c             	sub    $0xc,%esp
80102b52:	ff 75 08             	pushl  0x8(%ebp)
80102b55:	e8 d6 fc ff ff       	call   80102830 <idestart>
80102b5a:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b5d:	eb 13                	jmp    80102b72 <iderw+0xd3>
    sleep(b, &idelock);
80102b5f:	83 ec 08             	sub    $0x8,%esp
80102b62:	68 e0 b5 10 80       	push   $0x8010b5e0
80102b67:	ff 75 08             	pushl  0x8(%ebp)
80102b6a:	e8 06 22 00 00       	call   80104d75 <sleep>
80102b6f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b72:	8b 45 08             	mov    0x8(%ebp),%eax
80102b75:	8b 00                	mov    (%eax),%eax
80102b77:	83 e0 06             	and    $0x6,%eax
80102b7a:	83 f8 02             	cmp    $0x2,%eax
80102b7d:	75 e0                	jne    80102b5f <iderw+0xc0>
  }


  release(&idelock);
80102b7f:	83 ec 0c             	sub    $0xc,%esp
80102b82:	68 e0 b5 10 80       	push   $0x8010b5e0
80102b87:	e8 c4 26 00 00       	call   80105250 <release>
80102b8c:	83 c4 10             	add    $0x10,%esp
}
80102b8f:	90                   	nop
80102b90:	c9                   	leave  
80102b91:	c3                   	ret    

80102b92 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102b92:	f3 0f 1e fb          	endbr32 
80102b96:	55                   	push   %ebp
80102b97:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b99:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102b9e:	8b 55 08             	mov    0x8(%ebp),%edx
80102ba1:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102ba3:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102ba8:	8b 40 10             	mov    0x10(%eax),%eax
}
80102bab:	5d                   	pop    %ebp
80102bac:	c3                   	ret    

80102bad <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102bad:	f3 0f 1e fb          	endbr32 
80102bb1:	55                   	push   %ebp
80102bb2:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102bb4:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bb9:	8b 55 08             	mov    0x8(%ebp),%edx
80102bbc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102bbe:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80102bc6:	89 50 10             	mov    %edx,0x10(%eax)
}
80102bc9:	90                   	nop
80102bca:	5d                   	pop    %ebp
80102bcb:	c3                   	ret    

80102bcc <ioapicinit>:

void
ioapicinit(void)
{
80102bcc:	f3 0f 1e fb          	endbr32 
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102bd6:	c7 05 b4 36 11 80 00 	movl   $0xfec00000,0x801136b4
80102bdd:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102be0:	6a 01                	push   $0x1
80102be2:	e8 ab ff ff ff       	call   80102b92 <ioapicread>
80102be7:	83 c4 04             	add    $0x4,%esp
80102bea:	c1 e8 10             	shr    $0x10,%eax
80102bed:	25 ff 00 00 00       	and    $0xff,%eax
80102bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102bf5:	6a 00                	push   $0x0
80102bf7:	e8 96 ff ff ff       	call   80102b92 <ioapicread>
80102bfc:	83 c4 04             	add    $0x4,%esp
80102bff:	c1 e8 18             	shr    $0x18,%eax
80102c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102c05:	0f b6 05 e0 37 11 80 	movzbl 0x801137e0,%eax
80102c0c:	0f b6 c0             	movzbl %al,%eax
80102c0f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102c12:	74 10                	je     80102c24 <ioapicinit+0x58>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c14:	83 ec 0c             	sub    $0xc,%esp
80102c17:	68 3c 89 10 80       	push   $0x8010893c
80102c1c:	e8 f7 d7 ff ff       	call   80100418 <cprintf>
80102c21:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c2b:	eb 3f                	jmp    80102c6c <ioapicinit+0xa0>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c30:	83 c0 20             	add    $0x20,%eax
80102c33:	0d 00 00 01 00       	or     $0x10000,%eax
80102c38:	89 c2                	mov    %eax,%edx
80102c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3d:	83 c0 08             	add    $0x8,%eax
80102c40:	01 c0                	add    %eax,%eax
80102c42:	83 ec 08             	sub    $0x8,%esp
80102c45:	52                   	push   %edx
80102c46:	50                   	push   %eax
80102c47:	e8 61 ff ff ff       	call   80102bad <ioapicwrite>
80102c4c:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c52:	83 c0 08             	add    $0x8,%eax
80102c55:	01 c0                	add    %eax,%eax
80102c57:	83 c0 01             	add    $0x1,%eax
80102c5a:	83 ec 08             	sub    $0x8,%esp
80102c5d:	6a 00                	push   $0x0
80102c5f:	50                   	push   %eax
80102c60:	e8 48 ff ff ff       	call   80102bad <ioapicwrite>
80102c65:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102c68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102c72:	7e b9                	jle    80102c2d <ioapicinit+0x61>
  }
}
80102c74:	90                   	nop
80102c75:	90                   	nop
80102c76:	c9                   	leave  
80102c77:	c3                   	ret    

80102c78 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c78:	f3 0f 1e fb          	endbr32 
80102c7c:	55                   	push   %ebp
80102c7d:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c82:	83 c0 20             	add    $0x20,%eax
80102c85:	89 c2                	mov    %eax,%edx
80102c87:	8b 45 08             	mov    0x8(%ebp),%eax
80102c8a:	83 c0 08             	add    $0x8,%eax
80102c8d:	01 c0                	add    %eax,%eax
80102c8f:	52                   	push   %edx
80102c90:	50                   	push   %eax
80102c91:	e8 17 ff ff ff       	call   80102bad <ioapicwrite>
80102c96:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c99:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c9c:	c1 e0 18             	shl    $0x18,%eax
80102c9f:	89 c2                	mov    %eax,%edx
80102ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca4:	83 c0 08             	add    $0x8,%eax
80102ca7:	01 c0                	add    %eax,%eax
80102ca9:	83 c0 01             	add    $0x1,%eax
80102cac:	52                   	push   %edx
80102cad:	50                   	push   %eax
80102cae:	e8 fa fe ff ff       	call   80102bad <ioapicwrite>
80102cb3:	83 c4 08             	add    $0x8,%esp
}
80102cb6:	90                   	nop
80102cb7:	c9                   	leave  
80102cb8:	c3                   	ret    

80102cb9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102cb9:	f3 0f 1e fb          	endbr32 
80102cbd:	55                   	push   %ebp
80102cbe:	89 e5                	mov    %esp,%ebp
80102cc0:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102cc3:	83 ec 08             	sub    $0x8,%esp
80102cc6:	68 6e 89 10 80       	push   $0x8010896e
80102ccb:	68 c0 36 11 80       	push   $0x801136c0
80102cd0:	e8 e3 24 00 00       	call   801051b8 <initlock>
80102cd5:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102cd8:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102cdf:	00 00 00 
  freerange(vstart, vend);
80102ce2:	83 ec 08             	sub    $0x8,%esp
80102ce5:	ff 75 0c             	pushl  0xc(%ebp)
80102ce8:	ff 75 08             	pushl  0x8(%ebp)
80102ceb:	e8 2e 00 00 00       	call   80102d1e <freerange>
80102cf0:	83 c4 10             	add    $0x10,%esp
}
80102cf3:	90                   	nop
80102cf4:	c9                   	leave  
80102cf5:	c3                   	ret    

80102cf6 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102cf6:	f3 0f 1e fb          	endbr32 
80102cfa:	55                   	push   %ebp
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102d00:	83 ec 08             	sub    $0x8,%esp
80102d03:	ff 75 0c             	pushl  0xc(%ebp)
80102d06:	ff 75 08             	pushl  0x8(%ebp)
80102d09:	e8 10 00 00 00       	call   80102d1e <freerange>
80102d0e:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102d11:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
80102d18:	00 00 00 
}
80102d1b:	90                   	nop
80102d1c:	c9                   	leave  
80102d1d:	c3                   	ret    

80102d1e <freerange>:

void
freerange(void *vstart, void *vend)
{
80102d1e:	f3 0f 1e fb          	endbr32 
80102d22:	55                   	push   %ebp
80102d23:	89 e5                	mov    %esp,%ebp
80102d25:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102d28:	8b 45 08             	mov    0x8(%ebp),%eax
80102d2b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d38:	eb 15                	jmp    80102d4f <freerange+0x31>
    kfree(p);
80102d3a:	83 ec 0c             	sub    $0xc,%esp
80102d3d:	ff 75 f4             	pushl  -0xc(%ebp)
80102d40:	e8 1b 00 00 00       	call   80102d60 <kfree>
80102d45:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d48:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d52:	05 00 10 00 00       	add    $0x1000,%eax
80102d57:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102d5a:	73 de                	jae    80102d3a <freerange+0x1c>
}
80102d5c:	90                   	nop
80102d5d:	90                   	nop
80102d5e:	c9                   	leave  
80102d5f:	c3                   	ret    

80102d60 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d60:	f3 0f 1e fb          	endbr32 
80102d64:	55                   	push   %ebp
80102d65:	89 e5                	mov    %esp,%ebp
80102d67:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d6d:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 18                	jne    80102d8e <kfree+0x2e>
80102d76:	81 7d 08 28 65 11 80 	cmpl   $0x80116528,0x8(%ebp)
80102d7d:	72 0f                	jb     80102d8e <kfree+0x2e>
80102d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d82:	05 00 00 00 80       	add    $0x80000000,%eax
80102d87:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d8c:	76 0d                	jbe    80102d9b <kfree+0x3b>
    panic("kfree");
80102d8e:	83 ec 0c             	sub    $0xc,%esp
80102d91:	68 73 89 10 80       	push   $0x80108973
80102d96:	e8 36 d8 ff ff       	call   801005d1 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d9b:	83 ec 04             	sub    $0x4,%esp
80102d9e:	68 00 10 00 00       	push   $0x1000
80102da3:	6a 01                	push   $0x1
80102da5:	ff 75 08             	pushl  0x8(%ebp)
80102da8:	e8 d0 26 00 00       	call   8010547d <memset>
80102dad:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102db0:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102db5:	85 c0                	test   %eax,%eax
80102db7:	74 10                	je     80102dc9 <kfree+0x69>
    acquire(&kmem.lock);
80102db9:	83 ec 0c             	sub    $0xc,%esp
80102dbc:	68 c0 36 11 80       	push   $0x801136c0
80102dc1:	e8 18 24 00 00       	call   801051de <acquire>
80102dc6:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80102dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102dcf:	8b 15 f8 36 11 80    	mov    0x801136f8,%edx
80102dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dd8:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ddd:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102de2:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102de7:	85 c0                	test   %eax,%eax
80102de9:	74 10                	je     80102dfb <kfree+0x9b>
    release(&kmem.lock);
80102deb:	83 ec 0c             	sub    $0xc,%esp
80102dee:	68 c0 36 11 80       	push   $0x801136c0
80102df3:	e8 58 24 00 00       	call   80105250 <release>
80102df8:	83 c4 10             	add    $0x10,%esp
}
80102dfb:	90                   	nop
80102dfc:	c9                   	leave  
80102dfd:	c3                   	ret    

80102dfe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102dfe:	f3 0f 1e fb          	endbr32 
80102e02:	55                   	push   %ebp
80102e03:	89 e5                	mov    %esp,%ebp
80102e05:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102e08:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102e0d:	85 c0                	test   %eax,%eax
80102e0f:	74 10                	je     80102e21 <kalloc+0x23>
    acquire(&kmem.lock);
80102e11:	83 ec 0c             	sub    $0xc,%esp
80102e14:	68 c0 36 11 80       	push   $0x801136c0
80102e19:	e8 c0 23 00 00       	call   801051de <acquire>
80102e1e:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102e21:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102e2d:	74 0a                	je     80102e39 <kalloc+0x3b>
    kmem.freelist = r->next;
80102e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e32:	8b 00                	mov    (%eax),%eax
80102e34:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102e39:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102e3e:	85 c0                	test   %eax,%eax
80102e40:	74 10                	je     80102e52 <kalloc+0x54>
    release(&kmem.lock);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	68 c0 36 11 80       	push   $0x801136c0
80102e4a:	e8 01 24 00 00       	call   80105250 <release>
80102e4f:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e55:	c9                   	leave  
80102e56:	c3                   	ret    

80102e57 <inb>:
{
80102e57:	55                   	push   %ebp
80102e58:	89 e5                	mov    %esp,%ebp
80102e5a:	83 ec 14             	sub    $0x14,%esp
80102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80102e60:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e64:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e68:	89 c2                	mov    %eax,%edx
80102e6a:	ec                   	in     (%dx),%al
80102e6b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e6e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e72:	c9                   	leave  
80102e73:	c3                   	ret    

80102e74 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e74:	f3 0f 1e fb          	endbr32 
80102e78:	55                   	push   %ebp
80102e79:	89 e5                	mov    %esp,%ebp
80102e7b:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e7e:	6a 64                	push   $0x64
80102e80:	e8 d2 ff ff ff       	call   80102e57 <inb>
80102e85:	83 c4 04             	add    $0x4,%esp
80102e88:	0f b6 c0             	movzbl %al,%eax
80102e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e91:	83 e0 01             	and    $0x1,%eax
80102e94:	85 c0                	test   %eax,%eax
80102e96:	75 0a                	jne    80102ea2 <kbdgetc+0x2e>
    return -1;
80102e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e9d:	e9 23 01 00 00       	jmp    80102fc5 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102ea2:	6a 60                	push   $0x60
80102ea4:	e8 ae ff ff ff       	call   80102e57 <inb>
80102ea9:	83 c4 04             	add    $0x4,%esp
80102eac:	0f b6 c0             	movzbl %al,%eax
80102eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102eb2:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102eb9:	75 17                	jne    80102ed2 <kbdgetc+0x5e>
    shift |= E0ESC;
80102ebb:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102ec0:	83 c8 40             	or     $0x40,%eax
80102ec3:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102ec8:	b8 00 00 00 00       	mov    $0x0,%eax
80102ecd:	e9 f3 00 00 00       	jmp    80102fc5 <kbdgetc+0x151>
  } else if(data & 0x80){
80102ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ed5:	25 80 00 00 00       	and    $0x80,%eax
80102eda:	85 c0                	test   %eax,%eax
80102edc:	74 45                	je     80102f23 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ede:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102ee3:	83 e0 40             	and    $0x40,%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	75 08                	jne    80102ef2 <kbdgetc+0x7e>
80102eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eed:	83 e0 7f             	and    $0x7f,%eax
80102ef0:	eb 03                	jmp    80102ef5 <kbdgetc+0x81>
80102ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102efb:	05 20 90 10 80       	add    $0x80109020,%eax
80102f00:	0f b6 00             	movzbl (%eax),%eax
80102f03:	83 c8 40             	or     $0x40,%eax
80102f06:	0f b6 c0             	movzbl %al,%eax
80102f09:	f7 d0                	not    %eax
80102f0b:	89 c2                	mov    %eax,%edx
80102f0d:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102f12:	21 d0                	and    %edx,%eax
80102f14:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102f19:	b8 00 00 00 00       	mov    $0x0,%eax
80102f1e:	e9 a2 00 00 00       	jmp    80102fc5 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102f23:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102f28:	83 e0 40             	and    $0x40,%eax
80102f2b:	85 c0                	test   %eax,%eax
80102f2d:	74 14                	je     80102f43 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f2f:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102f36:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102f3b:	83 e0 bf             	and    $0xffffffbf,%eax
80102f3e:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  }

  shift |= shiftcode[data];
80102f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f46:	05 20 90 10 80       	add    $0x80109020,%eax
80102f4b:	0f b6 00             	movzbl (%eax),%eax
80102f4e:	0f b6 d0             	movzbl %al,%edx
80102f51:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102f56:	09 d0                	or     %edx,%eax
80102f58:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  shift ^= togglecode[data];
80102f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f60:	05 20 91 10 80       	add    $0x80109120,%eax
80102f65:	0f b6 00             	movzbl (%eax),%eax
80102f68:	0f b6 d0             	movzbl %al,%edx
80102f6b:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102f70:	31 d0                	xor    %edx,%eax
80102f72:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f77:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102f7c:	83 e0 03             	and    $0x3,%eax
80102f7f:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f89:	01 d0                	add    %edx,%eax
80102f8b:	0f b6 00             	movzbl (%eax),%eax
80102f8e:	0f b6 c0             	movzbl %al,%eax
80102f91:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102f94:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102f99:	83 e0 08             	and    $0x8,%eax
80102f9c:	85 c0                	test   %eax,%eax
80102f9e:	74 22                	je     80102fc2 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102fa0:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102fa4:	76 0c                	jbe    80102fb2 <kbdgetc+0x13e>
80102fa6:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102faa:	77 06                	ja     80102fb2 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102fac:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102fb0:	eb 10                	jmp    80102fc2 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102fb2:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102fb6:	76 0a                	jbe    80102fc2 <kbdgetc+0x14e>
80102fb8:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102fbc:	77 04                	ja     80102fc2 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102fbe:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102fc5:	c9                   	leave  
80102fc6:	c3                   	ret    

80102fc7 <kbdintr>:

void
kbdintr(void)
{
80102fc7:	f3 0f 1e fb          	endbr32 
80102fcb:	55                   	push   %ebp
80102fcc:	89 e5                	mov    %esp,%ebp
80102fce:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102fd1:	83 ec 0c             	sub    $0xc,%esp
80102fd4:	68 74 2e 10 80       	push   $0x80102e74
80102fd9:	e8 93 d8 ff ff       	call   80100871 <consoleintr>
80102fde:	83 c4 10             	add    $0x10,%esp
}
80102fe1:	90                   	nop
80102fe2:	c9                   	leave  
80102fe3:	c3                   	ret    

80102fe4 <inb>:
{
80102fe4:	55                   	push   %ebp
80102fe5:	89 e5                	mov    %esp,%ebp
80102fe7:	83 ec 14             	sub    $0x14,%esp
80102fea:	8b 45 08             	mov    0x8(%ebp),%eax
80102fed:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ff5:	89 c2                	mov    %eax,%edx
80102ff7:	ec                   	in     (%dx),%al
80102ff8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ffb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102fff:	c9                   	leave  
80103000:	c3                   	ret    

80103001 <outb>:
{
80103001:	55                   	push   %ebp
80103002:	89 e5                	mov    %esp,%ebp
80103004:	83 ec 08             	sub    $0x8,%esp
80103007:	8b 45 08             	mov    0x8(%ebp),%eax
8010300a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010300d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103011:	89 d0                	mov    %edx,%eax
80103013:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103016:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010301a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010301e:	ee                   	out    %al,(%dx)
}
8010301f:	90                   	nop
80103020:	c9                   	leave  
80103021:	c3                   	ret    

80103022 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103022:	f3 0f 1e fb          	endbr32 
80103026:	55                   	push   %ebp
80103027:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80103029:	a1 fc 36 11 80       	mov    0x801136fc,%eax
8010302e:	8b 55 08             	mov    0x8(%ebp),%edx
80103031:	c1 e2 02             	shl    $0x2,%edx
80103034:	01 c2                	add    %eax,%edx
80103036:	8b 45 0c             	mov    0xc(%ebp),%eax
80103039:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010303b:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103040:	83 c0 20             	add    $0x20,%eax
80103043:	8b 00                	mov    (%eax),%eax
}
80103045:	90                   	nop
80103046:	5d                   	pop    %ebp
80103047:	c3                   	ret    

80103048 <lapicinit>:

void
lapicinit(void)
{
80103048:	f3 0f 1e fb          	endbr32 
8010304c:	55                   	push   %ebp
8010304d:	89 e5                	mov    %esp,%ebp
  if(!lapic)
8010304f:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	0f 84 0c 01 00 00    	je     80103168 <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010305c:	68 3f 01 00 00       	push   $0x13f
80103061:	6a 3c                	push   $0x3c
80103063:	e8 ba ff ff ff       	call   80103022 <lapicw>
80103068:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010306b:	6a 0b                	push   $0xb
8010306d:	68 f8 00 00 00       	push   $0xf8
80103072:	e8 ab ff ff ff       	call   80103022 <lapicw>
80103077:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010307a:	68 20 00 02 00       	push   $0x20020
8010307f:	68 c8 00 00 00       	push   $0xc8
80103084:	e8 99 ff ff ff       	call   80103022 <lapicw>
80103089:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
8010308c:	68 80 96 98 00       	push   $0x989680
80103091:	68 e0 00 00 00       	push   $0xe0
80103096:	e8 87 ff ff ff       	call   80103022 <lapicw>
8010309b:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010309e:	68 00 00 01 00       	push   $0x10000
801030a3:	68 d4 00 00 00       	push   $0xd4
801030a8:	e8 75 ff ff ff       	call   80103022 <lapicw>
801030ad:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801030b0:	68 00 00 01 00       	push   $0x10000
801030b5:	68 d8 00 00 00       	push   $0xd8
801030ba:	e8 63 ff ff ff       	call   80103022 <lapicw>
801030bf:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030c2:	a1 fc 36 11 80       	mov    0x801136fc,%eax
801030c7:	83 c0 30             	add    $0x30,%eax
801030ca:	8b 00                	mov    (%eax),%eax
801030cc:	c1 e8 10             	shr    $0x10,%eax
801030cf:	25 fc 00 00 00       	and    $0xfc,%eax
801030d4:	85 c0                	test   %eax,%eax
801030d6:	74 12                	je     801030ea <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
801030d8:	68 00 00 01 00       	push   $0x10000
801030dd:	68 d0 00 00 00       	push   $0xd0
801030e2:	e8 3b ff ff ff       	call   80103022 <lapicw>
801030e7:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801030ea:	6a 33                	push   $0x33
801030ec:	68 dc 00 00 00       	push   $0xdc
801030f1:	e8 2c ff ff ff       	call   80103022 <lapicw>
801030f6:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801030f9:	6a 00                	push   $0x0
801030fb:	68 a0 00 00 00       	push   $0xa0
80103100:	e8 1d ff ff ff       	call   80103022 <lapicw>
80103105:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103108:	6a 00                	push   $0x0
8010310a:	68 a0 00 00 00       	push   $0xa0
8010310f:	e8 0e ff ff ff       	call   80103022 <lapicw>
80103114:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103117:	6a 00                	push   $0x0
80103119:	6a 2c                	push   $0x2c
8010311b:	e8 02 ff ff ff       	call   80103022 <lapicw>
80103120:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103123:	6a 00                	push   $0x0
80103125:	68 c4 00 00 00       	push   $0xc4
8010312a:	e8 f3 fe ff ff       	call   80103022 <lapicw>
8010312f:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103132:	68 00 85 08 00       	push   $0x88500
80103137:	68 c0 00 00 00       	push   $0xc0
8010313c:	e8 e1 fe ff ff       	call   80103022 <lapicw>
80103141:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103144:	90                   	nop
80103145:	a1 fc 36 11 80       	mov    0x801136fc,%eax
8010314a:	05 00 03 00 00       	add    $0x300,%eax
8010314f:	8b 00                	mov    (%eax),%eax
80103151:	25 00 10 00 00       	and    $0x1000,%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	75 eb                	jne    80103145 <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010315a:	6a 00                	push   $0x0
8010315c:	6a 20                	push   $0x20
8010315e:	e8 bf fe ff ff       	call   80103022 <lapicw>
80103163:	83 c4 08             	add    $0x8,%esp
80103166:	eb 01                	jmp    80103169 <lapicinit+0x121>
    return;
80103168:	90                   	nop
}
80103169:	c9                   	leave  
8010316a:	c3                   	ret    

8010316b <lapicid>:

int
lapicid(void)
{
8010316b:	f3 0f 1e fb          	endbr32 
8010316f:	55                   	push   %ebp
80103170:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103172:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103177:	85 c0                	test   %eax,%eax
80103179:	75 07                	jne    80103182 <lapicid+0x17>
    return 0;
8010317b:	b8 00 00 00 00       	mov    $0x0,%eax
80103180:	eb 0d                	jmp    8010318f <lapicid+0x24>
  return lapic[ID] >> 24;
80103182:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103187:	83 c0 20             	add    $0x20,%eax
8010318a:	8b 00                	mov    (%eax),%eax
8010318c:	c1 e8 18             	shr    $0x18,%eax
}
8010318f:	5d                   	pop    %ebp
80103190:	c3                   	ret    

80103191 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103191:	f3 0f 1e fb          	endbr32 
80103195:	55                   	push   %ebp
80103196:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103198:	a1 fc 36 11 80       	mov    0x801136fc,%eax
8010319d:	85 c0                	test   %eax,%eax
8010319f:	74 0c                	je     801031ad <lapiceoi+0x1c>
    lapicw(EOI, 0);
801031a1:	6a 00                	push   $0x0
801031a3:	6a 2c                	push   $0x2c
801031a5:	e8 78 fe ff ff       	call   80103022 <lapicw>
801031aa:	83 c4 08             	add    $0x8,%esp
}
801031ad:	90                   	nop
801031ae:	c9                   	leave  
801031af:	c3                   	ret    

801031b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031b0:	f3 0f 1e fb          	endbr32 
801031b4:	55                   	push   %ebp
801031b5:	89 e5                	mov    %esp,%ebp
}
801031b7:	90                   	nop
801031b8:	5d                   	pop    %ebp
801031b9:	c3                   	ret    

801031ba <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031ba:	f3 0f 1e fb          	endbr32 
801031be:	55                   	push   %ebp
801031bf:	89 e5                	mov    %esp,%ebp
801031c1:	83 ec 14             	sub    $0x14,%esp
801031c4:	8b 45 08             	mov    0x8(%ebp),%eax
801031c7:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801031ca:	6a 0f                	push   $0xf
801031cc:	6a 70                	push   $0x70
801031ce:	e8 2e fe ff ff       	call   80103001 <outb>
801031d3:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801031d6:	6a 0a                	push   $0xa
801031d8:	6a 71                	push   $0x71
801031da:	e8 22 fe ff ff       	call   80103001 <outb>
801031df:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801031e2:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801031e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031ec:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801031f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801031f4:	c1 e8 04             	shr    $0x4,%eax
801031f7:	89 c2                	mov    %eax,%edx
801031f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801031fc:	83 c0 02             	add    $0x2,%eax
801031ff:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103202:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103206:	c1 e0 18             	shl    $0x18,%eax
80103209:	50                   	push   %eax
8010320a:	68 c4 00 00 00       	push   $0xc4
8010320f:	e8 0e fe ff ff       	call   80103022 <lapicw>
80103214:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103217:	68 00 c5 00 00       	push   $0xc500
8010321c:	68 c0 00 00 00       	push   $0xc0
80103221:	e8 fc fd ff ff       	call   80103022 <lapicw>
80103226:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103229:	68 c8 00 00 00       	push   $0xc8
8010322e:	e8 7d ff ff ff       	call   801031b0 <microdelay>
80103233:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103236:	68 00 85 00 00       	push   $0x8500
8010323b:	68 c0 00 00 00       	push   $0xc0
80103240:	e8 dd fd ff ff       	call   80103022 <lapicw>
80103245:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103248:	6a 64                	push   $0x64
8010324a:	e8 61 ff ff ff       	call   801031b0 <microdelay>
8010324f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103259:	eb 3d                	jmp    80103298 <lapicstartap+0xde>
    lapicw(ICRHI, apicid<<24);
8010325b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010325f:	c1 e0 18             	shl    $0x18,%eax
80103262:	50                   	push   %eax
80103263:	68 c4 00 00 00       	push   $0xc4
80103268:	e8 b5 fd ff ff       	call   80103022 <lapicw>
8010326d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103270:	8b 45 0c             	mov    0xc(%ebp),%eax
80103273:	c1 e8 0c             	shr    $0xc,%eax
80103276:	80 cc 06             	or     $0x6,%ah
80103279:	50                   	push   %eax
8010327a:	68 c0 00 00 00       	push   $0xc0
8010327f:	e8 9e fd ff ff       	call   80103022 <lapicw>
80103284:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103287:	68 c8 00 00 00       	push   $0xc8
8010328c:	e8 1f ff ff ff       	call   801031b0 <microdelay>
80103291:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103294:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103298:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010329c:	7e bd                	jle    8010325b <lapicstartap+0xa1>
  }
}
8010329e:	90                   	nop
8010329f:	90                   	nop
801032a0:	c9                   	leave  
801032a1:	c3                   	ret    

801032a2 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
801032a2:	f3 0f 1e fb          	endbr32 
801032a6:	55                   	push   %ebp
801032a7:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801032a9:	8b 45 08             	mov    0x8(%ebp),%eax
801032ac:	0f b6 c0             	movzbl %al,%eax
801032af:	50                   	push   %eax
801032b0:	6a 70                	push   $0x70
801032b2:	e8 4a fd ff ff       	call   80103001 <outb>
801032b7:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801032ba:	68 c8 00 00 00       	push   $0xc8
801032bf:	e8 ec fe ff ff       	call   801031b0 <microdelay>
801032c4:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801032c7:	6a 71                	push   $0x71
801032c9:	e8 16 fd ff ff       	call   80102fe4 <inb>
801032ce:	83 c4 04             	add    $0x4,%esp
801032d1:	0f b6 c0             	movzbl %al,%eax
}
801032d4:	c9                   	leave  
801032d5:	c3                   	ret    

801032d6 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801032d6:	f3 0f 1e fb          	endbr32 
801032da:	55                   	push   %ebp
801032db:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801032dd:	6a 00                	push   $0x0
801032df:	e8 be ff ff ff       	call   801032a2 <cmos_read>
801032e4:	83 c4 04             	add    $0x4,%esp
801032e7:	8b 55 08             	mov    0x8(%ebp),%edx
801032ea:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801032ec:	6a 02                	push   $0x2
801032ee:	e8 af ff ff ff       	call   801032a2 <cmos_read>
801032f3:	83 c4 04             	add    $0x4,%esp
801032f6:	8b 55 08             	mov    0x8(%ebp),%edx
801032f9:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801032fc:	6a 04                	push   $0x4
801032fe:	e8 9f ff ff ff       	call   801032a2 <cmos_read>
80103303:	83 c4 04             	add    $0x4,%esp
80103306:	8b 55 08             	mov    0x8(%ebp),%edx
80103309:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010330c:	6a 07                	push   $0x7
8010330e:	e8 8f ff ff ff       	call   801032a2 <cmos_read>
80103313:	83 c4 04             	add    $0x4,%esp
80103316:	8b 55 08             	mov    0x8(%ebp),%edx
80103319:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010331c:	6a 08                	push   $0x8
8010331e:	e8 7f ff ff ff       	call   801032a2 <cmos_read>
80103323:	83 c4 04             	add    $0x4,%esp
80103326:	8b 55 08             	mov    0x8(%ebp),%edx
80103329:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010332c:	6a 09                	push   $0x9
8010332e:	e8 6f ff ff ff       	call   801032a2 <cmos_read>
80103333:	83 c4 04             	add    $0x4,%esp
80103336:	8b 55 08             	mov    0x8(%ebp),%edx
80103339:	89 42 14             	mov    %eax,0x14(%edx)
}
8010333c:	90                   	nop
8010333d:	c9                   	leave  
8010333e:	c3                   	ret    

8010333f <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010333f:	f3 0f 1e fb          	endbr32 
80103343:	55                   	push   %ebp
80103344:	89 e5                	mov    %esp,%ebp
80103346:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103349:	6a 0b                	push   $0xb
8010334b:	e8 52 ff ff ff       	call   801032a2 <cmos_read>
80103350:	83 c4 04             	add    $0x4,%esp
80103353:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103359:	83 e0 04             	and    $0x4,%eax
8010335c:	85 c0                	test   %eax,%eax
8010335e:	0f 94 c0             	sete   %al
80103361:	0f b6 c0             	movzbl %al,%eax
80103364:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103367:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010336a:	50                   	push   %eax
8010336b:	e8 66 ff ff ff       	call   801032d6 <fill_rtcdate>
80103370:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103373:	6a 0a                	push   $0xa
80103375:	e8 28 ff ff ff       	call   801032a2 <cmos_read>
8010337a:	83 c4 04             	add    $0x4,%esp
8010337d:	25 80 00 00 00       	and    $0x80,%eax
80103382:	85 c0                	test   %eax,%eax
80103384:	75 27                	jne    801033ad <cmostime+0x6e>
        continue;
    fill_rtcdate(&t2);
80103386:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103389:	50                   	push   %eax
8010338a:	e8 47 ff ff ff       	call   801032d6 <fill_rtcdate>
8010338f:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103392:	83 ec 04             	sub    $0x4,%esp
80103395:	6a 18                	push   $0x18
80103397:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010339a:	50                   	push   %eax
8010339b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010339e:	50                   	push   %eax
8010339f:	e8 44 21 00 00       	call   801054e8 <memcmp>
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 05                	je     801033b0 <cmostime+0x71>
801033ab:	eb ba                	jmp    80103367 <cmostime+0x28>
        continue;
801033ad:	90                   	nop
    fill_rtcdate(&t1);
801033ae:	eb b7                	jmp    80103367 <cmostime+0x28>
      break;
801033b0:	90                   	nop
  }

  // convert
  if(bcd) {
801033b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801033b5:	0f 84 b4 00 00 00    	je     8010346f <cmostime+0x130>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801033bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033be:	c1 e8 04             	shr    $0x4,%eax
801033c1:	89 c2                	mov    %eax,%edx
801033c3:	89 d0                	mov    %edx,%eax
801033c5:	c1 e0 02             	shl    $0x2,%eax
801033c8:	01 d0                	add    %edx,%eax
801033ca:	01 c0                	add    %eax,%eax
801033cc:	89 c2                	mov    %eax,%edx
801033ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
801033d1:	83 e0 0f             	and    $0xf,%eax
801033d4:	01 d0                	add    %edx,%eax
801033d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801033d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033dc:	c1 e8 04             	shr    $0x4,%eax
801033df:	89 c2                	mov    %eax,%edx
801033e1:	89 d0                	mov    %edx,%eax
801033e3:	c1 e0 02             	shl    $0x2,%eax
801033e6:	01 d0                	add    %edx,%eax
801033e8:	01 c0                	add    %eax,%eax
801033ea:	89 c2                	mov    %eax,%edx
801033ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801033ef:	83 e0 0f             	and    $0xf,%eax
801033f2:	01 d0                	add    %edx,%eax
801033f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801033f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033fa:	c1 e8 04             	shr    $0x4,%eax
801033fd:	89 c2                	mov    %eax,%edx
801033ff:	89 d0                	mov    %edx,%eax
80103401:	c1 e0 02             	shl    $0x2,%eax
80103404:	01 d0                	add    %edx,%eax
80103406:	01 c0                	add    %eax,%eax
80103408:	89 c2                	mov    %eax,%edx
8010340a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010340d:	83 e0 0f             	and    $0xf,%eax
80103410:	01 d0                	add    %edx,%eax
80103412:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103418:	c1 e8 04             	shr    $0x4,%eax
8010341b:	89 c2                	mov    %eax,%edx
8010341d:	89 d0                	mov    %edx,%eax
8010341f:	c1 e0 02             	shl    $0x2,%eax
80103422:	01 d0                	add    %edx,%eax
80103424:	01 c0                	add    %eax,%eax
80103426:	89 c2                	mov    %eax,%edx
80103428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010342b:	83 e0 0f             	and    $0xf,%eax
8010342e:	01 d0                	add    %edx,%eax
80103430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103433:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103436:	c1 e8 04             	shr    $0x4,%eax
80103439:	89 c2                	mov    %eax,%edx
8010343b:	89 d0                	mov    %edx,%eax
8010343d:	c1 e0 02             	shl    $0x2,%eax
80103440:	01 d0                	add    %edx,%eax
80103442:	01 c0                	add    %eax,%eax
80103444:	89 c2                	mov    %eax,%edx
80103446:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103449:	83 e0 0f             	and    $0xf,%eax
8010344c:	01 d0                	add    %edx,%eax
8010344e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103451:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103454:	c1 e8 04             	shr    $0x4,%eax
80103457:	89 c2                	mov    %eax,%edx
80103459:	89 d0                	mov    %edx,%eax
8010345b:	c1 e0 02             	shl    $0x2,%eax
8010345e:	01 d0                	add    %edx,%eax
80103460:	01 c0                	add    %eax,%eax
80103462:	89 c2                	mov    %eax,%edx
80103464:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103467:	83 e0 0f             	and    $0xf,%eax
8010346a:	01 d0                	add    %edx,%eax
8010346c:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010346f:	8b 45 08             	mov    0x8(%ebp),%eax
80103472:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103475:	89 10                	mov    %edx,(%eax)
80103477:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010347a:	89 50 04             	mov    %edx,0x4(%eax)
8010347d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103480:	89 50 08             	mov    %edx,0x8(%eax)
80103483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103486:	89 50 0c             	mov    %edx,0xc(%eax)
80103489:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010348c:	89 50 10             	mov    %edx,0x10(%eax)
8010348f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103492:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103495:	8b 45 08             	mov    0x8(%ebp),%eax
80103498:	8b 40 14             	mov    0x14(%eax),%eax
8010349b:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801034a1:	8b 45 08             	mov    0x8(%ebp),%eax
801034a4:	89 50 14             	mov    %edx,0x14(%eax)
}
801034a7:	90                   	nop
801034a8:	c9                   	leave  
801034a9:	c3                   	ret    

801034aa <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801034aa:	f3 0f 1e fb          	endbr32 
801034ae:	55                   	push   %ebp
801034af:	89 e5                	mov    %esp,%ebp
801034b1:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801034b4:	83 ec 08             	sub    $0x8,%esp
801034b7:	68 79 89 10 80       	push   $0x80108979
801034bc:	68 00 37 11 80       	push   $0x80113700
801034c1:	e8 f2 1c 00 00       	call   801051b8 <initlock>
801034c6:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801034c9:	83 ec 08             	sub    $0x8,%esp
801034cc:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034cf:	50                   	push   %eax
801034d0:	ff 75 08             	pushl  0x8(%ebp)
801034d3:	e8 f9 df ff ff       	call   801014d1 <readsb>
801034d8:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801034db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034de:	a3 34 37 11 80       	mov    %eax,0x80113734
  log.size = sb.nlog;
801034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801034e6:	a3 38 37 11 80       	mov    %eax,0x80113738
  log.dev = dev;
801034eb:	8b 45 08             	mov    0x8(%ebp),%eax
801034ee:	a3 44 37 11 80       	mov    %eax,0x80113744
  recover_from_log();
801034f3:	e8 bf 01 00 00       	call   801036b7 <recover_from_log>
}
801034f8:	90                   	nop
801034f9:	c9                   	leave  
801034fa:	c3                   	ret    

801034fb <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801034fb:	f3 0f 1e fb          	endbr32 
801034ff:	55                   	push   %ebp
80103500:	89 e5                	mov    %esp,%ebp
80103502:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103505:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010350c:	e9 95 00 00 00       	jmp    801035a6 <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103511:	8b 15 34 37 11 80    	mov    0x80113734,%edx
80103517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010351a:	01 d0                	add    %edx,%eax
8010351c:	83 c0 01             	add    $0x1,%eax
8010351f:	89 c2                	mov    %eax,%edx
80103521:	a1 44 37 11 80       	mov    0x80113744,%eax
80103526:	83 ec 08             	sub    $0x8,%esp
80103529:	52                   	push   %edx
8010352a:	50                   	push   %eax
8010352b:	e8 a7 cc ff ff       	call   801001d7 <bread>
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103539:	83 c0 10             	add    $0x10,%eax
8010353c:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
80103543:	89 c2                	mov    %eax,%edx
80103545:	a1 44 37 11 80       	mov    0x80113744,%eax
8010354a:	83 ec 08             	sub    $0x8,%esp
8010354d:	52                   	push   %edx
8010354e:	50                   	push   %eax
8010354f:	e8 83 cc ff ff       	call   801001d7 <bread>
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010355a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010355d:	8d 50 5c             	lea    0x5c(%eax),%edx
80103560:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103563:	83 c0 5c             	add    $0x5c,%eax
80103566:	83 ec 04             	sub    $0x4,%esp
80103569:	68 00 02 00 00       	push   $0x200
8010356e:	52                   	push   %edx
8010356f:	50                   	push   %eax
80103570:	e8 cf 1f 00 00       	call   80105544 <memmove>
80103575:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103578:	83 ec 0c             	sub    $0xc,%esp
8010357b:	ff 75 ec             	pushl  -0x14(%ebp)
8010357e:	e8 91 cc ff ff       	call   80100214 <bwrite>
80103583:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	ff 75 f0             	pushl  -0x10(%ebp)
8010358c:	e8 d0 cc ff ff       	call   80100261 <brelse>
80103591:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103594:	83 ec 0c             	sub    $0xc,%esp
80103597:	ff 75 ec             	pushl  -0x14(%ebp)
8010359a:	e8 c2 cc ff ff       	call   80100261 <brelse>
8010359f:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801035a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035a6:	a1 48 37 11 80       	mov    0x80113748,%eax
801035ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035ae:	0f 8c 5d ff ff ff    	jl     80103511 <install_trans+0x16>
  }
}
801035b4:	90                   	nop
801035b5:	90                   	nop
801035b6:	c9                   	leave  
801035b7:	c3                   	ret    

801035b8 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801035b8:	f3 0f 1e fb          	endbr32 
801035bc:	55                   	push   %ebp
801035bd:	89 e5                	mov    %esp,%ebp
801035bf:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801035c2:	a1 34 37 11 80       	mov    0x80113734,%eax
801035c7:	89 c2                	mov    %eax,%edx
801035c9:	a1 44 37 11 80       	mov    0x80113744,%eax
801035ce:	83 ec 08             	sub    $0x8,%esp
801035d1:	52                   	push   %edx
801035d2:	50                   	push   %eax
801035d3:	e8 ff cb ff ff       	call   801001d7 <bread>
801035d8:	83 c4 10             	add    $0x10,%esp
801035db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801035de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e1:	83 c0 5c             	add    $0x5c,%eax
801035e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801035e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ea:	8b 00                	mov    (%eax),%eax
801035ec:	a3 48 37 11 80       	mov    %eax,0x80113748
  for (i = 0; i < log.lh.n; i++) {
801035f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035f8:	eb 1b                	jmp    80103615 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
801035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103600:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103604:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103607:	83 c2 10             	add    $0x10,%edx
8010360a:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103611:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103615:	a1 48 37 11 80       	mov    0x80113748,%eax
8010361a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010361d:	7c db                	jl     801035fa <read_head+0x42>
  }
  brelse(buf);
8010361f:	83 ec 0c             	sub    $0xc,%esp
80103622:	ff 75 f0             	pushl  -0x10(%ebp)
80103625:	e8 37 cc ff ff       	call   80100261 <brelse>
8010362a:	83 c4 10             	add    $0x10,%esp
}
8010362d:	90                   	nop
8010362e:	c9                   	leave  
8010362f:	c3                   	ret    

80103630 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103630:	f3 0f 1e fb          	endbr32 
80103634:	55                   	push   %ebp
80103635:	89 e5                	mov    %esp,%ebp
80103637:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010363a:	a1 34 37 11 80       	mov    0x80113734,%eax
8010363f:	89 c2                	mov    %eax,%edx
80103641:	a1 44 37 11 80       	mov    0x80113744,%eax
80103646:	83 ec 08             	sub    $0x8,%esp
80103649:	52                   	push   %edx
8010364a:	50                   	push   %eax
8010364b:	e8 87 cb ff ff       	call   801001d7 <bread>
80103650:	83 c4 10             	add    $0x10,%esp
80103653:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103659:	83 c0 5c             	add    $0x5c,%eax
8010365c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010365f:	8b 15 48 37 11 80    	mov    0x80113748,%edx
80103665:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103668:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010366a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103671:	eb 1b                	jmp    8010368e <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
80103673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103676:	83 c0 10             	add    $0x10,%eax
80103679:	8b 0c 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%ecx
80103680:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103683:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103686:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010368a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010368e:	a1 48 37 11 80       	mov    0x80113748,%eax
80103693:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103696:	7c db                	jl     80103673 <write_head+0x43>
  }
  bwrite(buf);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	ff 75 f0             	pushl  -0x10(%ebp)
8010369e:	e8 71 cb ff ff       	call   80100214 <bwrite>
801036a3:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801036a6:	83 ec 0c             	sub    $0xc,%esp
801036a9:	ff 75 f0             	pushl  -0x10(%ebp)
801036ac:	e8 b0 cb ff ff       	call   80100261 <brelse>
801036b1:	83 c4 10             	add    $0x10,%esp
}
801036b4:	90                   	nop
801036b5:	c9                   	leave  
801036b6:	c3                   	ret    

801036b7 <recover_from_log>:

static void
recover_from_log(void)
{
801036b7:	f3 0f 1e fb          	endbr32 
801036bb:	55                   	push   %ebp
801036bc:	89 e5                	mov    %esp,%ebp
801036be:	83 ec 08             	sub    $0x8,%esp
  read_head();
801036c1:	e8 f2 fe ff ff       	call   801035b8 <read_head>
  install_trans(); // if committed, copy from log to disk
801036c6:	e8 30 fe ff ff       	call   801034fb <install_trans>
  log.lh.n = 0;
801036cb:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
801036d2:	00 00 00 
  write_head(); // clear the log
801036d5:	e8 56 ff ff ff       	call   80103630 <write_head>
}
801036da:	90                   	nop
801036db:	c9                   	leave  
801036dc:	c3                   	ret    

801036dd <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801036dd:	f3 0f 1e fb          	endbr32 
801036e1:	55                   	push   %ebp
801036e2:	89 e5                	mov    %esp,%ebp
801036e4:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801036e7:	83 ec 0c             	sub    $0xc,%esp
801036ea:	68 00 37 11 80       	push   $0x80113700
801036ef:	e8 ea 1a 00 00       	call   801051de <acquire>
801036f4:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801036f7:	a1 40 37 11 80       	mov    0x80113740,%eax
801036fc:	85 c0                	test   %eax,%eax
801036fe:	74 17                	je     80103717 <begin_op+0x3a>
      sleep(&log, &log.lock);
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	68 00 37 11 80       	push   $0x80113700
80103708:	68 00 37 11 80       	push   $0x80113700
8010370d:	e8 63 16 00 00       	call   80104d75 <sleep>
80103712:	83 c4 10             	add    $0x10,%esp
80103715:	eb e0                	jmp    801036f7 <begin_op+0x1a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103717:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
8010371d:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103722:	8d 50 01             	lea    0x1(%eax),%edx
80103725:	89 d0                	mov    %edx,%eax
80103727:	c1 e0 02             	shl    $0x2,%eax
8010372a:	01 d0                	add    %edx,%eax
8010372c:	01 c0                	add    %eax,%eax
8010372e:	01 c8                	add    %ecx,%eax
80103730:	83 f8 1e             	cmp    $0x1e,%eax
80103733:	7e 17                	jle    8010374c <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103735:	83 ec 08             	sub    $0x8,%esp
80103738:	68 00 37 11 80       	push   $0x80113700
8010373d:	68 00 37 11 80       	push   $0x80113700
80103742:	e8 2e 16 00 00       	call   80104d75 <sleep>
80103747:	83 c4 10             	add    $0x10,%esp
8010374a:	eb ab                	jmp    801036f7 <begin_op+0x1a>
    } else {
      log.outstanding += 1;
8010374c:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103751:	83 c0 01             	add    $0x1,%eax
80103754:	a3 3c 37 11 80       	mov    %eax,0x8011373c
      release(&log.lock);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	68 00 37 11 80       	push   $0x80113700
80103761:	e8 ea 1a 00 00       	call   80105250 <release>
80103766:	83 c4 10             	add    $0x10,%esp
      break;
80103769:	90                   	nop
    }
  }
}
8010376a:	90                   	nop
8010376b:	c9                   	leave  
8010376c:	c3                   	ret    

8010376d <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010376d:	f3 0f 1e fb          	endbr32 
80103771:	55                   	push   %ebp
80103772:	89 e5                	mov    %esp,%ebp
80103774:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010377e:	83 ec 0c             	sub    $0xc,%esp
80103781:	68 00 37 11 80       	push   $0x80113700
80103786:	e8 53 1a 00 00       	call   801051de <acquire>
8010378b:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010378e:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103793:	83 e8 01             	sub    $0x1,%eax
80103796:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  if(log.committing)
8010379b:	a1 40 37 11 80       	mov    0x80113740,%eax
801037a0:	85 c0                	test   %eax,%eax
801037a2:	74 0d                	je     801037b1 <end_op+0x44>
    panic("log.committing");
801037a4:	83 ec 0c             	sub    $0xc,%esp
801037a7:	68 7d 89 10 80       	push   $0x8010897d
801037ac:	e8 20 ce ff ff       	call   801005d1 <panic>
  if(log.outstanding == 0){
801037b1:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801037b6:	85 c0                	test   %eax,%eax
801037b8:	75 13                	jne    801037cd <end_op+0x60>
    do_commit = 1;
801037ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801037c1:	c7 05 40 37 11 80 01 	movl   $0x1,0x80113740
801037c8:	00 00 00 
801037cb:	eb 10                	jmp    801037dd <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801037cd:	83 ec 0c             	sub    $0xc,%esp
801037d0:	68 00 37 11 80       	push   $0x80113700
801037d5:	e8 8a 16 00 00       	call   80104e64 <wakeup>
801037da:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801037dd:	83 ec 0c             	sub    $0xc,%esp
801037e0:	68 00 37 11 80       	push   $0x80113700
801037e5:	e8 66 1a 00 00       	call   80105250 <release>
801037ea:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801037ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037f1:	74 3f                	je     80103832 <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801037f3:	e8 fa 00 00 00       	call   801038f2 <commit>
    acquire(&log.lock);
801037f8:	83 ec 0c             	sub    $0xc,%esp
801037fb:	68 00 37 11 80       	push   $0x80113700
80103800:	e8 d9 19 00 00       	call   801051de <acquire>
80103805:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103808:	c7 05 40 37 11 80 00 	movl   $0x0,0x80113740
8010380f:	00 00 00 
    wakeup(&log);
80103812:	83 ec 0c             	sub    $0xc,%esp
80103815:	68 00 37 11 80       	push   $0x80113700
8010381a:	e8 45 16 00 00       	call   80104e64 <wakeup>
8010381f:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103822:	83 ec 0c             	sub    $0xc,%esp
80103825:	68 00 37 11 80       	push   $0x80113700
8010382a:	e8 21 1a 00 00       	call   80105250 <release>
8010382f:	83 c4 10             	add    $0x10,%esp
  }
}
80103832:	90                   	nop
80103833:	c9                   	leave  
80103834:	c3                   	ret    

80103835 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103835:	f3 0f 1e fb          	endbr32 
80103839:	55                   	push   %ebp
8010383a:	89 e5                	mov    %esp,%ebp
8010383c:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010383f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103846:	e9 95 00 00 00       	jmp    801038e0 <write_log+0xab>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010384b:	8b 15 34 37 11 80    	mov    0x80113734,%edx
80103851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103854:	01 d0                	add    %edx,%eax
80103856:	83 c0 01             	add    $0x1,%eax
80103859:	89 c2                	mov    %eax,%edx
8010385b:	a1 44 37 11 80       	mov    0x80113744,%eax
80103860:	83 ec 08             	sub    $0x8,%esp
80103863:	52                   	push   %edx
80103864:	50                   	push   %eax
80103865:	e8 6d c9 ff ff       	call   801001d7 <bread>
8010386a:	83 c4 10             	add    $0x10,%esp
8010386d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103873:	83 c0 10             	add    $0x10,%eax
80103876:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
8010387d:	89 c2                	mov    %eax,%edx
8010387f:	a1 44 37 11 80       	mov    0x80113744,%eax
80103884:	83 ec 08             	sub    $0x8,%esp
80103887:	52                   	push   %edx
80103888:	50                   	push   %eax
80103889:	e8 49 c9 ff ff       	call   801001d7 <bread>
8010388e:	83 c4 10             	add    $0x10,%esp
80103891:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103894:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103897:	8d 50 5c             	lea    0x5c(%eax),%edx
8010389a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389d:	83 c0 5c             	add    $0x5c,%eax
801038a0:	83 ec 04             	sub    $0x4,%esp
801038a3:	68 00 02 00 00       	push   $0x200
801038a8:	52                   	push   %edx
801038a9:	50                   	push   %eax
801038aa:	e8 95 1c 00 00       	call   80105544 <memmove>
801038af:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	ff 75 f0             	pushl  -0x10(%ebp)
801038b8:	e8 57 c9 ff ff       	call   80100214 <bwrite>
801038bd:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801038c0:	83 ec 0c             	sub    $0xc,%esp
801038c3:	ff 75 ec             	pushl  -0x14(%ebp)
801038c6:	e8 96 c9 ff ff       	call   80100261 <brelse>
801038cb:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801038ce:	83 ec 0c             	sub    $0xc,%esp
801038d1:	ff 75 f0             	pushl  -0x10(%ebp)
801038d4:	e8 88 c9 ff ff       	call   80100261 <brelse>
801038d9:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801038dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038e0:	a1 48 37 11 80       	mov    0x80113748,%eax
801038e5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801038e8:	0f 8c 5d ff ff ff    	jl     8010384b <write_log+0x16>
  }
}
801038ee:	90                   	nop
801038ef:	90                   	nop
801038f0:	c9                   	leave  
801038f1:	c3                   	ret    

801038f2 <commit>:

static void
commit()
{
801038f2:	f3 0f 1e fb          	endbr32 
801038f6:	55                   	push   %ebp
801038f7:	89 e5                	mov    %esp,%ebp
801038f9:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801038fc:	a1 48 37 11 80       	mov    0x80113748,%eax
80103901:	85 c0                	test   %eax,%eax
80103903:	7e 1e                	jle    80103923 <commit+0x31>
    write_log();     // Write modified blocks from cache to log
80103905:	e8 2b ff ff ff       	call   80103835 <write_log>
    write_head();    // Write header to disk -- the real commit
8010390a:	e8 21 fd ff ff       	call   80103630 <write_head>
    install_trans(); // Now install writes to home locations
8010390f:	e8 e7 fb ff ff       	call   801034fb <install_trans>
    log.lh.n = 0;
80103914:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
8010391b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010391e:	e8 0d fd ff ff       	call   80103630 <write_head>
  }
}
80103923:	90                   	nop
80103924:	c9                   	leave  
80103925:	c3                   	ret    

80103926 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103926:	f3 0f 1e fb          	endbr32 
8010392a:	55                   	push   %ebp
8010392b:	89 e5                	mov    %esp,%ebp
8010392d:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103930:	a1 48 37 11 80       	mov    0x80113748,%eax
80103935:	83 f8 1d             	cmp    $0x1d,%eax
80103938:	7f 12                	jg     8010394c <log_write+0x26>
8010393a:	a1 48 37 11 80       	mov    0x80113748,%eax
8010393f:	8b 15 38 37 11 80    	mov    0x80113738,%edx
80103945:	83 ea 01             	sub    $0x1,%edx
80103948:	39 d0                	cmp    %edx,%eax
8010394a:	7c 0d                	jl     80103959 <log_write+0x33>
    panic("too big a transaction");
8010394c:	83 ec 0c             	sub    $0xc,%esp
8010394f:	68 8c 89 10 80       	push   $0x8010898c
80103954:	e8 78 cc ff ff       	call   801005d1 <panic>
  if (log.outstanding < 1)
80103959:	a1 3c 37 11 80       	mov    0x8011373c,%eax
8010395e:	85 c0                	test   %eax,%eax
80103960:	7f 0d                	jg     8010396f <log_write+0x49>
    panic("log_write outside of trans");
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 a2 89 10 80       	push   $0x801089a2
8010396a:	e8 62 cc ff ff       	call   801005d1 <panic>

  acquire(&log.lock);
8010396f:	83 ec 0c             	sub    $0xc,%esp
80103972:	68 00 37 11 80       	push   $0x80113700
80103977:	e8 62 18 00 00       	call   801051de <acquire>
8010397c:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010397f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103986:	eb 1d                	jmp    801039a5 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010398b:	83 c0 10             	add    $0x10,%eax
8010398e:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
80103995:	89 c2                	mov    %eax,%edx
80103997:	8b 45 08             	mov    0x8(%ebp),%eax
8010399a:	8b 40 08             	mov    0x8(%eax),%eax
8010399d:	39 c2                	cmp    %eax,%edx
8010399f:	74 10                	je     801039b1 <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
801039a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039a5:	a1 48 37 11 80       	mov    0x80113748,%eax
801039aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039ad:	7c d9                	jl     80103988 <log_write+0x62>
801039af:	eb 01                	jmp    801039b2 <log_write+0x8c>
      break;
801039b1:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801039b2:	8b 45 08             	mov    0x8(%ebp),%eax
801039b5:	8b 40 08             	mov    0x8(%eax),%eax
801039b8:	89 c2                	mov    %eax,%edx
801039ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039bd:	83 c0 10             	add    $0x10,%eax
801039c0:	89 14 85 0c 37 11 80 	mov    %edx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
801039c7:	a1 48 37 11 80       	mov    0x80113748,%eax
801039cc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039cf:	75 0d                	jne    801039de <log_write+0xb8>
    log.lh.n++;
801039d1:	a1 48 37 11 80       	mov    0x80113748,%eax
801039d6:	83 c0 01             	add    $0x1,%eax
801039d9:	a3 48 37 11 80       	mov    %eax,0x80113748
  b->flags |= B_DIRTY; // prevent eviction
801039de:	8b 45 08             	mov    0x8(%ebp),%eax
801039e1:	8b 00                	mov    (%eax),%eax
801039e3:	83 c8 04             	or     $0x4,%eax
801039e6:	89 c2                	mov    %eax,%edx
801039e8:	8b 45 08             	mov    0x8(%ebp),%eax
801039eb:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801039ed:	83 ec 0c             	sub    $0xc,%esp
801039f0:	68 00 37 11 80       	push   $0x80113700
801039f5:	e8 56 18 00 00       	call   80105250 <release>
801039fa:	83 c4 10             	add    $0x10,%esp
}
801039fd:	90                   	nop
801039fe:	c9                   	leave  
801039ff:	c3                   	ret    

80103a00 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a06:	8b 55 08             	mov    0x8(%ebp),%edx
80103a09:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a0f:	f0 87 02             	lock xchg %eax,(%edx)
80103a12:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a18:	c9                   	leave  
80103a19:	c3                   	ret    

80103a1a <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a1a:	f3 0f 1e fb          	endbr32 
80103a1e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103a22:	83 e4 f0             	and    $0xfffffff0,%esp
80103a25:	ff 71 fc             	pushl  -0x4(%ecx)
80103a28:	55                   	push   %ebp
80103a29:	89 e5                	mov    %esp,%ebp
80103a2b:	51                   	push   %ecx
80103a2c:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a2f:	83 ec 08             	sub    $0x8,%esp
80103a32:	68 00 00 40 80       	push   $0x80400000
80103a37:	68 28 65 11 80       	push   $0x80116528
80103a3c:	e8 78 f2 ff ff       	call   80102cb9 <kinit1>
80103a41:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103a44:	e8 d2 44 00 00       	call   80107f1b <kvmalloc>
  mpinit();        // detect other processors
80103a49:	e8 d9 03 00 00       	call   80103e27 <mpinit>
  lapicinit();     // interrupt controller
80103a4e:	e8 f5 f5 ff ff       	call   80103048 <lapicinit>
  seginit();       // segment descriptors
80103a53:	e8 9e 3f 00 00       	call   801079f6 <seginit>
  picinit();       // disable pic
80103a58:	e8 35 05 00 00       	call   80103f92 <picinit>
  ioapicinit();    // another interrupt controller
80103a5d:	e8 6a f1 ff ff       	call   80102bcc <ioapicinit>
  consoleinit();   // console hardware
80103a62:	e8 43 d1 ff ff       	call   80100baa <consoleinit>
  uartinit();      // serial port
80103a67:	e8 13 33 00 00       	call   80106d7f <uartinit>
  pinit();         // process table
80103a6c:	e8 6e 09 00 00       	call   801043df <pinit>
  tvinit();        // trap vectors
80103a71:	e8 dc 2e 00 00       	call   80106952 <tvinit>
  binit();         // buffer cache
80103a76:	e8 b9 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a7b:	e8 bc d5 ff ff       	call   8010103c <fileinit>
  ideinit();       // disk 
80103a80:	e8 06 ed ff ff       	call   8010278b <ideinit>
  startothers();   // start other processors
80103a85:	e8 88 00 00 00       	call   80103b12 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a8a:	83 ec 08             	sub    $0x8,%esp
80103a8d:	68 00 00 00 8e       	push   $0x8e000000
80103a92:	68 00 00 40 80       	push   $0x80400000
80103a97:	e8 5a f2 ff ff       	call   80102cf6 <kinit2>
80103a9c:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103a9f:	e8 31 0b 00 00       	call   801045d5 <userinit>
  mpmain();        // finish this processor's setup
80103aa4:	e8 1e 00 00 00       	call   80103ac7 <mpmain>

80103aa9 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103aa9:	f3 0f 1e fb          	endbr32 
80103aad:	55                   	push   %ebp
80103aae:	89 e5                	mov    %esp,%ebp
80103ab0:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103ab3:	e8 7f 44 00 00       	call   80107f37 <switchkvm>
  seginit();
80103ab8:	e8 39 3f 00 00       	call   801079f6 <seginit>
  lapicinit();
80103abd:	e8 86 f5 ff ff       	call   80103048 <lapicinit>
  mpmain();
80103ac2:	e8 00 00 00 00       	call   80103ac7 <mpmain>

80103ac7 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103ac7:	f3 0f 1e fb          	endbr32 
80103acb:	55                   	push   %ebp
80103acc:	89 e5                	mov    %esp,%ebp
80103ace:	53                   	push   %ebx
80103acf:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103ad2:	e8 2a 09 00 00       	call   80104401 <cpuid>
80103ad7:	89 c3                	mov    %eax,%ebx
80103ad9:	e8 23 09 00 00       	call   80104401 <cpuid>
80103ade:	83 ec 04             	sub    $0x4,%esp
80103ae1:	53                   	push   %ebx
80103ae2:	50                   	push   %eax
80103ae3:	68 bd 89 10 80       	push   $0x801089bd
80103ae8:	e8 2b c9 ff ff       	call   80100418 <cprintf>
80103aed:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103af0:	e8 d7 2f 00 00       	call   80106acc <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103af5:	e8 26 09 00 00       	call   80104420 <mycpu>
80103afa:	05 a0 00 00 00       	add    $0xa0,%eax
80103aff:	83 ec 08             	sub    $0x8,%esp
80103b02:	6a 01                	push   $0x1
80103b04:	50                   	push   %eax
80103b05:	e8 f6 fe ff ff       	call   80103a00 <xchg>
80103b0a:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103b0d:	e8 62 10 00 00       	call   80104b74 <scheduler>

80103b12 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b12:	f3 0f 1e fb          	endbr32 
80103b16:	55                   	push   %ebp
80103b17:	89 e5                	mov    %esp,%ebp
80103b19:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103b1c:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b23:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b28:	83 ec 04             	sub    $0x4,%esp
80103b2b:	50                   	push   %eax
80103b2c:	68 ec b4 10 80       	push   $0x8010b4ec
80103b31:	ff 75 f0             	pushl  -0x10(%ebp)
80103b34:	e8 0b 1a 00 00       	call   80105544 <memmove>
80103b39:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103b3c:	c7 45 f4 00 38 11 80 	movl   $0x80113800,-0xc(%ebp)
80103b43:	eb 79                	jmp    80103bbe <startothers+0xac>
    if(c == mycpu())  // We've started already.
80103b45:	e8 d6 08 00 00       	call   80104420 <mycpu>
80103b4a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b4d:	74 67                	je     80103bb6 <startothers+0xa4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b4f:	e8 aa f2 ff ff       	call   80102dfe <kalloc>
80103b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5a:	83 e8 04             	sub    $0x4,%eax
80103b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b60:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b66:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6b:	83 e8 08             	sub    $0x8,%eax
80103b6e:	c7 00 a9 3a 10 80    	movl   $0x80103aa9,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103b74:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
80103b79:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b82:	83 e8 0c             	sub    $0xc,%eax
80103b85:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b8a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b93:	0f b6 00             	movzbl (%eax),%eax
80103b96:	0f b6 c0             	movzbl %al,%eax
80103b99:	83 ec 08             	sub    $0x8,%esp
80103b9c:	52                   	push   %edx
80103b9d:	50                   	push   %eax
80103b9e:	e8 17 f6 ff ff       	call   801031ba <lapicstartap>
80103ba3:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103ba6:	90                   	nop
80103ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103baa:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103bb0:	85 c0                	test   %eax,%eax
80103bb2:	74 f3                	je     80103ba7 <startothers+0x95>
80103bb4:	eb 01                	jmp    80103bb7 <startothers+0xa5>
      continue;
80103bb6:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103bb7:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103bbe:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103bc3:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103bc9:	05 00 38 11 80       	add    $0x80113800,%eax
80103bce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103bd1:	0f 82 6e ff ff ff    	jb     80103b45 <startothers+0x33>
      ;
  }
}
80103bd7:	90                   	nop
80103bd8:	90                   	nop
80103bd9:	c9                   	leave  
80103bda:	c3                   	ret    

80103bdb <inb>:
{
80103bdb:	55                   	push   %ebp
80103bdc:	89 e5                	mov    %esp,%ebp
80103bde:	83 ec 14             	sub    $0x14,%esp
80103be1:	8b 45 08             	mov    0x8(%ebp),%eax
80103be4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103be8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103bec:	89 c2                	mov    %eax,%edx
80103bee:	ec                   	in     (%dx),%al
80103bef:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103bf2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103bf6:	c9                   	leave  
80103bf7:	c3                   	ret    

80103bf8 <outb>:
{
80103bf8:	55                   	push   %ebp
80103bf9:	89 e5                	mov    %esp,%ebp
80103bfb:	83 ec 08             	sub    $0x8,%esp
80103bfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103c01:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103c08:	89 d0                	mov    %edx,%eax
80103c0a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c0d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c11:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c15:	ee                   	out    %al,(%dx)
}
80103c16:	90                   	nop
80103c17:	c9                   	leave  
80103c18:	c3                   	ret    

80103c19 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103c19:	f3 0f 1e fb          	endbr32 
80103c1d:	55                   	push   %ebp
80103c1e:	89 e5                	mov    %esp,%ebp
80103c20:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103c23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c31:	eb 15                	jmp    80103c48 <sum+0x2f>
    sum += addr[i];
80103c33:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c36:	8b 45 08             	mov    0x8(%ebp),%eax
80103c39:	01 d0                	add    %edx,%eax
80103c3b:	0f b6 00             	movzbl (%eax),%eax
80103c3e:	0f b6 c0             	movzbl %al,%eax
80103c41:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c44:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c4e:	7c e3                	jl     80103c33 <sum+0x1a>
  return sum;
80103c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c53:	c9                   	leave  
80103c54:	c3                   	ret    

80103c55 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c55:	f3 0f 1e fb          	endbr32 
80103c59:	55                   	push   %ebp
80103c5a:	89 e5                	mov    %esp,%ebp
80103c5c:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c62:	05 00 00 00 80       	add    $0x80000000,%eax
80103c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c70:	01 d0                	add    %edx,%eax
80103c72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c7b:	eb 36                	jmp    80103cb3 <mpsearch1+0x5e>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c7d:	83 ec 04             	sub    $0x4,%esp
80103c80:	6a 04                	push   $0x4
80103c82:	68 d4 89 10 80       	push   $0x801089d4
80103c87:	ff 75 f4             	pushl  -0xc(%ebp)
80103c8a:	e8 59 18 00 00       	call   801054e8 <memcmp>
80103c8f:	83 c4 10             	add    $0x10,%esp
80103c92:	85 c0                	test   %eax,%eax
80103c94:	75 19                	jne    80103caf <mpsearch1+0x5a>
80103c96:	83 ec 08             	sub    $0x8,%esp
80103c99:	6a 10                	push   $0x10
80103c9b:	ff 75 f4             	pushl  -0xc(%ebp)
80103c9e:	e8 76 ff ff ff       	call   80103c19 <sum>
80103ca3:	83 c4 10             	add    $0x10,%esp
80103ca6:	84 c0                	test   %al,%al
80103ca8:	75 05                	jne    80103caf <mpsearch1+0x5a>
      return (struct mp*)p;
80103caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cad:	eb 11                	jmp    80103cc0 <mpsearch1+0x6b>
  for(p = addr; p < e; p += sizeof(struct mp))
80103caf:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cb9:	72 c2                	jb     80103c7d <mpsearch1+0x28>
  return 0;
80103cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103cc0:	c9                   	leave  
80103cc1:	c3                   	ret    

80103cc2 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103cc2:	f3 0f 1e fb          	endbr32 
80103cc6:	55                   	push   %ebp
80103cc7:	89 e5                	mov    %esp,%ebp
80103cc9:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ccc:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd6:	83 c0 0f             	add    $0xf,%eax
80103cd9:	0f b6 00             	movzbl (%eax),%eax
80103cdc:	0f b6 c0             	movzbl %al,%eax
80103cdf:	c1 e0 08             	shl    $0x8,%eax
80103ce2:	89 c2                	mov    %eax,%edx
80103ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce7:	83 c0 0e             	add    $0xe,%eax
80103cea:	0f b6 00             	movzbl (%eax),%eax
80103ced:	0f b6 c0             	movzbl %al,%eax
80103cf0:	09 d0                	or     %edx,%eax
80103cf2:	c1 e0 04             	shl    $0x4,%eax
80103cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cfc:	74 21                	je     80103d1f <mpsearch+0x5d>
    if((mp = mpsearch1(p, 1024)))
80103cfe:	83 ec 08             	sub    $0x8,%esp
80103d01:	68 00 04 00 00       	push   $0x400
80103d06:	ff 75 f0             	pushl  -0x10(%ebp)
80103d09:	e8 47 ff ff ff       	call   80103c55 <mpsearch1>
80103d0e:	83 c4 10             	add    $0x10,%esp
80103d11:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d18:	74 51                	je     80103d6b <mpsearch+0xa9>
      return mp;
80103d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d1d:	eb 61                	jmp    80103d80 <mpsearch+0xbe>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d22:	83 c0 14             	add    $0x14,%eax
80103d25:	0f b6 00             	movzbl (%eax),%eax
80103d28:	0f b6 c0             	movzbl %al,%eax
80103d2b:	c1 e0 08             	shl    $0x8,%eax
80103d2e:	89 c2                	mov    %eax,%edx
80103d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d33:	83 c0 13             	add    $0x13,%eax
80103d36:	0f b6 00             	movzbl (%eax),%eax
80103d39:	0f b6 c0             	movzbl %al,%eax
80103d3c:	09 d0                	or     %edx,%eax
80103d3e:	c1 e0 0a             	shl    $0xa,%eax
80103d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d47:	2d 00 04 00 00       	sub    $0x400,%eax
80103d4c:	83 ec 08             	sub    $0x8,%esp
80103d4f:	68 00 04 00 00       	push   $0x400
80103d54:	50                   	push   %eax
80103d55:	e8 fb fe ff ff       	call   80103c55 <mpsearch1>
80103d5a:	83 c4 10             	add    $0x10,%esp
80103d5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d64:	74 05                	je     80103d6b <mpsearch+0xa9>
      return mp;
80103d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d69:	eb 15                	jmp    80103d80 <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d6b:	83 ec 08             	sub    $0x8,%esp
80103d6e:	68 00 00 01 00       	push   $0x10000
80103d73:	68 00 00 0f 00       	push   $0xf0000
80103d78:	e8 d8 fe ff ff       	call   80103c55 <mpsearch1>
80103d7d:	83 c4 10             	add    $0x10,%esp
}
80103d80:	c9                   	leave  
80103d81:	c3                   	ret    

80103d82 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d82:	f3 0f 1e fb          	endbr32 
80103d86:	55                   	push   %ebp
80103d87:	89 e5                	mov    %esp,%ebp
80103d89:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d8c:	e8 31 ff ff ff       	call   80103cc2 <mpsearch>
80103d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d98:	74 0a                	je     80103da4 <mpconfig+0x22>
80103d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9d:	8b 40 04             	mov    0x4(%eax),%eax
80103da0:	85 c0                	test   %eax,%eax
80103da2:	75 07                	jne    80103dab <mpconfig+0x29>
    return 0;
80103da4:	b8 00 00 00 00       	mov    $0x0,%eax
80103da9:	eb 7a                	jmp    80103e25 <mpconfig+0xa3>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dae:	8b 40 04             	mov    0x4(%eax),%eax
80103db1:	05 00 00 00 80       	add    $0x80000000,%eax
80103db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103db9:	83 ec 04             	sub    $0x4,%esp
80103dbc:	6a 04                	push   $0x4
80103dbe:	68 d9 89 10 80       	push   $0x801089d9
80103dc3:	ff 75 f0             	pushl  -0x10(%ebp)
80103dc6:	e8 1d 17 00 00       	call   801054e8 <memcmp>
80103dcb:	83 c4 10             	add    $0x10,%esp
80103dce:	85 c0                	test   %eax,%eax
80103dd0:	74 07                	je     80103dd9 <mpconfig+0x57>
    return 0;
80103dd2:	b8 00 00 00 00       	mov    $0x0,%eax
80103dd7:	eb 4c                	jmp    80103e25 <mpconfig+0xa3>
  if(conf->version != 1 && conf->version != 4)
80103dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ddc:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103de0:	3c 01                	cmp    $0x1,%al
80103de2:	74 12                	je     80103df6 <mpconfig+0x74>
80103de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de7:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103deb:	3c 04                	cmp    $0x4,%al
80103ded:	74 07                	je     80103df6 <mpconfig+0x74>
    return 0;
80103def:	b8 00 00 00 00       	mov    $0x0,%eax
80103df4:	eb 2f                	jmp    80103e25 <mpconfig+0xa3>
  if(sum((uchar*)conf, conf->length) != 0)
80103df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103dfd:	0f b7 c0             	movzwl %ax,%eax
80103e00:	83 ec 08             	sub    $0x8,%esp
80103e03:	50                   	push   %eax
80103e04:	ff 75 f0             	pushl  -0x10(%ebp)
80103e07:	e8 0d fe ff ff       	call   80103c19 <sum>
80103e0c:	83 c4 10             	add    $0x10,%esp
80103e0f:	84 c0                	test   %al,%al
80103e11:	74 07                	je     80103e1a <mpconfig+0x98>
    return 0;
80103e13:	b8 00 00 00 00       	mov    $0x0,%eax
80103e18:	eb 0b                	jmp    80103e25 <mpconfig+0xa3>
  *pmp = mp;
80103e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e20:	89 10                	mov    %edx,(%eax)
  return conf;
80103e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e25:	c9                   	leave  
80103e26:	c3                   	ret    

80103e27 <mpinit>:

void
mpinit(void)
{
80103e27:	f3 0f 1e fb          	endbr32 
80103e2b:	55                   	push   %ebp
80103e2c:	89 e5                	mov    %esp,%ebp
80103e2e:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103e31:	83 ec 0c             	sub    $0xc,%esp
80103e34:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103e37:	50                   	push   %eax
80103e38:	e8 45 ff ff ff       	call   80103d82 <mpconfig>
80103e3d:	83 c4 10             	add    $0x10,%esp
80103e40:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e47:	75 0d                	jne    80103e56 <mpinit+0x2f>
    panic("Expect to run on an SMP");
80103e49:	83 ec 0c             	sub    $0xc,%esp
80103e4c:	68 de 89 10 80       	push   $0x801089de
80103e51:	e8 7b c7 ff ff       	call   801005d1 <panic>
  ismp = 1;
80103e56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e60:	8b 40 24             	mov    0x24(%eax),%eax
80103e63:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e6b:	83 c0 2c             	add    $0x2c,%eax
80103e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e74:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e78:	0f b7 d0             	movzwl %ax,%edx
80103e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e7e:	01 d0                	add    %edx,%eax
80103e80:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103e83:	e9 8c 00 00 00       	jmp    80103f14 <mpinit+0xed>
    switch(*p){
80103e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e8b:	0f b6 00             	movzbl (%eax),%eax
80103e8e:	0f b6 c0             	movzbl %al,%eax
80103e91:	83 f8 04             	cmp    $0x4,%eax
80103e94:	7f 76                	jg     80103f0c <mpinit+0xe5>
80103e96:	83 f8 03             	cmp    $0x3,%eax
80103e99:	7d 6b                	jge    80103f06 <mpinit+0xdf>
80103e9b:	83 f8 02             	cmp    $0x2,%eax
80103e9e:	74 4e                	je     80103eee <mpinit+0xc7>
80103ea0:	83 f8 02             	cmp    $0x2,%eax
80103ea3:	7f 67                	jg     80103f0c <mpinit+0xe5>
80103ea5:	85 c0                	test   %eax,%eax
80103ea7:	74 07                	je     80103eb0 <mpinit+0x89>
80103ea9:	83 f8 01             	cmp    $0x1,%eax
80103eac:	74 58                	je     80103f06 <mpinit+0xdf>
80103eae:	eb 5c                	jmp    80103f0c <mpinit+0xe5>
    case MPPROC:
      proc = (struct mpproc*)p;
80103eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103eb6:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103ebb:	83 f8 07             	cmp    $0x7,%eax
80103ebe:	7f 28                	jg     80103ee8 <mpinit+0xc1>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103ec0:	8b 15 80 3d 11 80    	mov    0x80113d80,%edx
80103ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ec9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ecd:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103ed3:	81 c2 00 38 11 80    	add    $0x80113800,%edx
80103ed9:	88 02                	mov    %al,(%edx)
        ncpu++;
80103edb:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103ee0:	83 c0 01             	add    $0x1,%eax
80103ee3:	a3 80 3d 11 80       	mov    %eax,0x80113d80
      }
      p += sizeof(struct mpproc);
80103ee8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103eec:	eb 26                	jmp    80103f14 <mpinit+0xed>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ef1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ef7:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103efb:	a2 e0 37 11 80       	mov    %al,0x801137e0
      p += sizeof(struct mpioapic);
80103f00:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f04:	eb 0e                	jmp    80103f14 <mpinit+0xed>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103f06:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103f0a:	eb 08                	jmp    80103f14 <mpinit+0xed>
    default:
      ismp = 0;
80103f0c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103f13:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f17:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103f1a:	0f 82 68 ff ff ff    	jb     80103e88 <mpinit+0x61>
    }
  }
  if(!ismp)
80103f20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f24:	75 0d                	jne    80103f33 <mpinit+0x10c>
    panic("Didn't find a suitable machine");
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	68 f8 89 10 80       	push   $0x801089f8
80103f2e:	e8 9e c6 ff ff       	call   801005d1 <panic>

  if(mp->imcrp){
80103f33:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f36:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f3a:	84 c0                	test   %al,%al
80103f3c:	74 30                	je     80103f6e <mpinit+0x147>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f3e:	83 ec 08             	sub    $0x8,%esp
80103f41:	6a 70                	push   $0x70
80103f43:	6a 22                	push   $0x22
80103f45:	e8 ae fc ff ff       	call   80103bf8 <outb>
80103f4a:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f4d:	83 ec 0c             	sub    $0xc,%esp
80103f50:	6a 23                	push   $0x23
80103f52:	e8 84 fc ff ff       	call   80103bdb <inb>
80103f57:	83 c4 10             	add    $0x10,%esp
80103f5a:	83 c8 01             	or     $0x1,%eax
80103f5d:	0f b6 c0             	movzbl %al,%eax
80103f60:	83 ec 08             	sub    $0x8,%esp
80103f63:	50                   	push   %eax
80103f64:	6a 23                	push   $0x23
80103f66:	e8 8d fc ff ff       	call   80103bf8 <outb>
80103f6b:	83 c4 10             	add    $0x10,%esp
  }
}
80103f6e:	90                   	nop
80103f6f:	c9                   	leave  
80103f70:	c3                   	ret    

80103f71 <outb>:
{
80103f71:	55                   	push   %ebp
80103f72:	89 e5                	mov    %esp,%ebp
80103f74:	83 ec 08             	sub    $0x8,%esp
80103f77:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f7d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103f81:	89 d0                	mov    %edx,%eax
80103f83:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f86:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f8a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f8e:	ee                   	out    %al,(%dx)
}
80103f8f:	90                   	nop
80103f90:	c9                   	leave  
80103f91:	c3                   	ret    

80103f92 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103f92:	f3 0f 1e fb          	endbr32 
80103f96:	55                   	push   %ebp
80103f97:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103f99:	68 ff 00 00 00       	push   $0xff
80103f9e:	6a 21                	push   $0x21
80103fa0:	e8 cc ff ff ff       	call   80103f71 <outb>
80103fa5:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103fa8:	68 ff 00 00 00       	push   $0xff
80103fad:	68 a1 00 00 00       	push   $0xa1
80103fb2:	e8 ba ff ff ff       	call   80103f71 <outb>
80103fb7:	83 c4 08             	add    $0x8,%esp
}
80103fba:	90                   	nop
80103fbb:	c9                   	leave  
80103fbc:	c3                   	ret    

80103fbd <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fbd:	f3 0f 1e fb          	endbr32 
80103fc1:	55                   	push   %ebp
80103fc2:	89 e5                	mov    %esp,%ebp
80103fc4:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fce:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fda:	8b 10                	mov    (%eax),%edx
80103fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdf:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fe1:	e8 78 d0 ff ff       	call   8010105e <filealloc>
80103fe6:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe9:	89 02                	mov    %eax,(%edx)
80103feb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fee:	8b 00                	mov    (%eax),%eax
80103ff0:	85 c0                	test   %eax,%eax
80103ff2:	0f 84 c8 00 00 00    	je     801040c0 <pipealloc+0x103>
80103ff8:	e8 61 d0 ff ff       	call   8010105e <filealloc>
80103ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
80104000:	89 02                	mov    %eax,(%edx)
80104002:	8b 45 0c             	mov    0xc(%ebp),%eax
80104005:	8b 00                	mov    (%eax),%eax
80104007:	85 c0                	test   %eax,%eax
80104009:	0f 84 b1 00 00 00    	je     801040c0 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010400f:	e8 ea ed ff ff       	call   80102dfe <kalloc>
80104014:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010401b:	0f 84 a2 00 00 00    	je     801040c3 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80104021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104024:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010402b:	00 00 00 
  p->writeopen = 1;
8010402e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104031:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104038:	00 00 00 
  p->nwrite = 0;
8010403b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104045:	00 00 00 
  p->nread = 0;
80104048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104052:	00 00 00 
  initlock(&p->lock, "pipe");
80104055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104058:	83 ec 08             	sub    $0x8,%esp
8010405b:	68 17 8a 10 80       	push   $0x80108a17
80104060:	50                   	push   %eax
80104061:	e8 52 11 00 00       	call   801051b8 <initlock>
80104066:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104069:	8b 45 08             	mov    0x8(%ebp),%eax
8010406c:	8b 00                	mov    (%eax),%eax
8010406e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104074:	8b 45 08             	mov    0x8(%ebp),%eax
80104077:	8b 00                	mov    (%eax),%eax
80104079:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010407d:	8b 45 08             	mov    0x8(%ebp),%eax
80104080:	8b 00                	mov    (%eax),%eax
80104082:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104086:	8b 45 08             	mov    0x8(%ebp),%eax
80104089:	8b 00                	mov    (%eax),%eax
8010408b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010408e:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104091:	8b 45 0c             	mov    0xc(%ebp),%eax
80104094:	8b 00                	mov    (%eax),%eax
80104096:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010409c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010409f:	8b 00                	mov    (%eax),%eax
801040a1:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a8:	8b 00                	mov    (%eax),%eax
801040aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b1:	8b 00                	mov    (%eax),%eax
801040b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040b6:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040b9:	b8 00 00 00 00       	mov    $0x0,%eax
801040be:	eb 51                	jmp    80104111 <pipealloc+0x154>
    goto bad;
801040c0:	90                   	nop
801040c1:	eb 01                	jmp    801040c4 <pipealloc+0x107>
    goto bad;
801040c3:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
801040c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040c8:	74 0e                	je     801040d8 <pipealloc+0x11b>
    kfree((char*)p);
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	ff 75 f4             	pushl  -0xc(%ebp)
801040d0:	e8 8b ec ff ff       	call   80102d60 <kfree>
801040d5:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040d8:	8b 45 08             	mov    0x8(%ebp),%eax
801040db:	8b 00                	mov    (%eax),%eax
801040dd:	85 c0                	test   %eax,%eax
801040df:	74 11                	je     801040f2 <pipealloc+0x135>
    fileclose(*f0);
801040e1:	8b 45 08             	mov    0x8(%ebp),%eax
801040e4:	8b 00                	mov    (%eax),%eax
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	50                   	push   %eax
801040ea:	e8 35 d0 ff ff       	call   80101124 <fileclose>
801040ef:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f5:	8b 00                	mov    (%eax),%eax
801040f7:	85 c0                	test   %eax,%eax
801040f9:	74 11                	je     8010410c <pipealloc+0x14f>
    fileclose(*f1);
801040fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fe:	8b 00                	mov    (%eax),%eax
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	50                   	push   %eax
80104104:	e8 1b d0 ff ff       	call   80101124 <fileclose>
80104109:	83 c4 10             	add    $0x10,%esp
  return -1;
8010410c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104111:	c9                   	leave  
80104112:	c3                   	ret    

80104113 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104113:	f3 0f 1e fb          	endbr32 
80104117:	55                   	push   %ebp
80104118:	89 e5                	mov    %esp,%ebp
8010411a:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010411d:	8b 45 08             	mov    0x8(%ebp),%eax
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	50                   	push   %eax
80104124:	e8 b5 10 00 00       	call   801051de <acquire>
80104129:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010412c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104130:	74 23                	je     80104155 <pipeclose+0x42>
    p->writeopen = 0;
80104132:	8b 45 08             	mov    0x8(%ebp),%eax
80104135:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010413c:	00 00 00 
    wakeup(&p->nread);
8010413f:	8b 45 08             	mov    0x8(%ebp),%eax
80104142:	05 34 02 00 00       	add    $0x234,%eax
80104147:	83 ec 0c             	sub    $0xc,%esp
8010414a:	50                   	push   %eax
8010414b:	e8 14 0d 00 00       	call   80104e64 <wakeup>
80104150:	83 c4 10             	add    $0x10,%esp
80104153:	eb 21                	jmp    80104176 <pipeclose+0x63>
  } else {
    p->readopen = 0;
80104155:	8b 45 08             	mov    0x8(%ebp),%eax
80104158:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010415f:	00 00 00 
    wakeup(&p->nwrite);
80104162:	8b 45 08             	mov    0x8(%ebp),%eax
80104165:	05 38 02 00 00       	add    $0x238,%eax
8010416a:	83 ec 0c             	sub    $0xc,%esp
8010416d:	50                   	push   %eax
8010416e:	e8 f1 0c 00 00       	call   80104e64 <wakeup>
80104173:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104176:	8b 45 08             	mov    0x8(%ebp),%eax
80104179:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010417f:	85 c0                	test   %eax,%eax
80104181:	75 2c                	jne    801041af <pipeclose+0x9c>
80104183:	8b 45 08             	mov    0x8(%ebp),%eax
80104186:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010418c:	85 c0                	test   %eax,%eax
8010418e:	75 1f                	jne    801041af <pipeclose+0x9c>
    release(&p->lock);
80104190:	8b 45 08             	mov    0x8(%ebp),%eax
80104193:	83 ec 0c             	sub    $0xc,%esp
80104196:	50                   	push   %eax
80104197:	e8 b4 10 00 00       	call   80105250 <release>
8010419c:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010419f:	83 ec 0c             	sub    $0xc,%esp
801041a2:	ff 75 08             	pushl  0x8(%ebp)
801041a5:	e8 b6 eb ff ff       	call   80102d60 <kfree>
801041aa:	83 c4 10             	add    $0x10,%esp
801041ad:	eb 10                	jmp    801041bf <pipeclose+0xac>
  } else
    release(&p->lock);
801041af:	8b 45 08             	mov    0x8(%ebp),%eax
801041b2:	83 ec 0c             	sub    $0xc,%esp
801041b5:	50                   	push   %eax
801041b6:	e8 95 10 00 00       	call   80105250 <release>
801041bb:	83 c4 10             	add    $0x10,%esp
}
801041be:	90                   	nop
801041bf:	90                   	nop
801041c0:	c9                   	leave  
801041c1:	c3                   	ret    

801041c2 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041c2:	f3 0f 1e fb          	endbr32 
801041c6:	55                   	push   %ebp
801041c7:	89 e5                	mov    %esp,%ebp
801041c9:	53                   	push   %ebx
801041ca:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801041cd:	8b 45 08             	mov    0x8(%ebp),%eax
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	50                   	push   %eax
801041d4:	e8 05 10 00 00       	call   801051de <acquire>
801041d9:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041e3:	e9 ad 00 00 00       	jmp    80104295 <pipewrite+0xd3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
801041e8:	8b 45 08             	mov    0x8(%ebp),%eax
801041eb:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041f1:	85 c0                	test   %eax,%eax
801041f3:	74 0c                	je     80104201 <pipewrite+0x3f>
801041f5:	e8 a2 02 00 00       	call   8010449c <myproc>
801041fa:	8b 40 24             	mov    0x24(%eax),%eax
801041fd:	85 c0                	test   %eax,%eax
801041ff:	74 19                	je     8010421a <pipewrite+0x58>
        release(&p->lock);
80104201:	8b 45 08             	mov    0x8(%ebp),%eax
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	50                   	push   %eax
80104208:	e8 43 10 00 00       	call   80105250 <release>
8010420d:	83 c4 10             	add    $0x10,%esp
        return -1;
80104210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104215:	e9 a9 00 00 00       	jmp    801042c3 <pipewrite+0x101>
      }
      wakeup(&p->nread);
8010421a:	8b 45 08             	mov    0x8(%ebp),%eax
8010421d:	05 34 02 00 00       	add    $0x234,%eax
80104222:	83 ec 0c             	sub    $0xc,%esp
80104225:	50                   	push   %eax
80104226:	e8 39 0c 00 00       	call   80104e64 <wakeup>
8010422b:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010422e:	8b 45 08             	mov    0x8(%ebp),%eax
80104231:	8b 55 08             	mov    0x8(%ebp),%edx
80104234:	81 c2 38 02 00 00    	add    $0x238,%edx
8010423a:	83 ec 08             	sub    $0x8,%esp
8010423d:	50                   	push   %eax
8010423e:	52                   	push   %edx
8010423f:	e8 31 0b 00 00       	call   80104d75 <sleep>
80104244:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104247:	8b 45 08             	mov    0x8(%ebp),%eax
8010424a:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104250:	8b 45 08             	mov    0x8(%ebp),%eax
80104253:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104259:	05 00 02 00 00       	add    $0x200,%eax
8010425e:	39 c2                	cmp    %eax,%edx
80104260:	74 86                	je     801041e8 <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104262:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104265:	8b 45 0c             	mov    0xc(%ebp),%eax
80104268:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010426b:	8b 45 08             	mov    0x8(%ebp),%eax
8010426e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104274:	8d 48 01             	lea    0x1(%eax),%ecx
80104277:	8b 55 08             	mov    0x8(%ebp),%edx
8010427a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104280:	25 ff 01 00 00       	and    $0x1ff,%eax
80104285:	89 c1                	mov    %eax,%ecx
80104287:	0f b6 13             	movzbl (%ebx),%edx
8010428a:	8b 45 08             	mov    0x8(%ebp),%eax
8010428d:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80104291:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104298:	3b 45 10             	cmp    0x10(%ebp),%eax
8010429b:	7c aa                	jl     80104247 <pipewrite+0x85>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010429d:	8b 45 08             	mov    0x8(%ebp),%eax
801042a0:	05 34 02 00 00       	add    $0x234,%eax
801042a5:	83 ec 0c             	sub    $0xc,%esp
801042a8:	50                   	push   %eax
801042a9:	e8 b6 0b 00 00       	call   80104e64 <wakeup>
801042ae:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042b1:	8b 45 08             	mov    0x8(%ebp),%eax
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	50                   	push   %eax
801042b8:	e8 93 0f 00 00       	call   80105250 <release>
801042bd:	83 c4 10             	add    $0x10,%esp
  return n;
801042c0:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042c6:	c9                   	leave  
801042c7:	c3                   	ret    

801042c8 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042c8:	f3 0f 1e fb          	endbr32 
801042cc:	55                   	push   %ebp
801042cd:	89 e5                	mov    %esp,%ebp
801042cf:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042d2:	8b 45 08             	mov    0x8(%ebp),%eax
801042d5:	83 ec 0c             	sub    $0xc,%esp
801042d8:	50                   	push   %eax
801042d9:	e8 00 0f 00 00       	call   801051de <acquire>
801042de:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042e1:	eb 3e                	jmp    80104321 <piperead+0x59>
    if(myproc()->killed){
801042e3:	e8 b4 01 00 00       	call   8010449c <myproc>
801042e8:	8b 40 24             	mov    0x24(%eax),%eax
801042eb:	85 c0                	test   %eax,%eax
801042ed:	74 19                	je     80104308 <piperead+0x40>
      release(&p->lock);
801042ef:	8b 45 08             	mov    0x8(%ebp),%eax
801042f2:	83 ec 0c             	sub    $0xc,%esp
801042f5:	50                   	push   %eax
801042f6:	e8 55 0f 00 00       	call   80105250 <release>
801042fb:	83 c4 10             	add    $0x10,%esp
      return -1;
801042fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104303:	e9 be 00 00 00       	jmp    801043c6 <piperead+0xfe>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104308:	8b 45 08             	mov    0x8(%ebp),%eax
8010430b:	8b 55 08             	mov    0x8(%ebp),%edx
8010430e:	81 c2 34 02 00 00    	add    $0x234,%edx
80104314:	83 ec 08             	sub    $0x8,%esp
80104317:	50                   	push   %eax
80104318:	52                   	push   %edx
80104319:	e8 57 0a 00 00       	call   80104d75 <sleep>
8010431e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104321:	8b 45 08             	mov    0x8(%ebp),%eax
80104324:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010432a:	8b 45 08             	mov    0x8(%ebp),%eax
8010432d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104333:	39 c2                	cmp    %eax,%edx
80104335:	75 0d                	jne    80104344 <piperead+0x7c>
80104337:	8b 45 08             	mov    0x8(%ebp),%eax
8010433a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104340:	85 c0                	test   %eax,%eax
80104342:	75 9f                	jne    801042e3 <piperead+0x1b>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104344:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010434b:	eb 48                	jmp    80104395 <piperead+0xcd>
    if(p->nread == p->nwrite)
8010434d:	8b 45 08             	mov    0x8(%ebp),%eax
80104350:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104356:	8b 45 08             	mov    0x8(%ebp),%eax
80104359:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010435f:	39 c2                	cmp    %eax,%edx
80104361:	74 3c                	je     8010439f <piperead+0xd7>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104363:	8b 45 08             	mov    0x8(%ebp),%eax
80104366:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010436c:	8d 48 01             	lea    0x1(%eax),%ecx
8010436f:	8b 55 08             	mov    0x8(%ebp),%edx
80104372:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104378:	25 ff 01 00 00       	and    $0x1ff,%eax
8010437d:	89 c1                	mov    %eax,%ecx
8010437f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104382:	8b 45 0c             	mov    0xc(%ebp),%eax
80104385:	01 c2                	add    %eax,%edx
80104387:	8b 45 08             	mov    0x8(%ebp),%eax
8010438a:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010438f:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104391:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104398:	3b 45 10             	cmp    0x10(%ebp),%eax
8010439b:	7c b0                	jl     8010434d <piperead+0x85>
8010439d:	eb 01                	jmp    801043a0 <piperead+0xd8>
      break;
8010439f:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043a0:	8b 45 08             	mov    0x8(%ebp),%eax
801043a3:	05 38 02 00 00       	add    $0x238,%eax
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	50                   	push   %eax
801043ac:	e8 b3 0a 00 00       	call   80104e64 <wakeup>
801043b1:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043b4:	8b 45 08             	mov    0x8(%ebp),%eax
801043b7:	83 ec 0c             	sub    $0xc,%esp
801043ba:	50                   	push   %eax
801043bb:	e8 90 0e 00 00       	call   80105250 <release>
801043c0:	83 c4 10             	add    $0x10,%esp
  return i;
801043c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043c6:	c9                   	leave  
801043c7:	c3                   	ret    

801043c8 <readeflags>:
{
801043c8:	55                   	push   %ebp
801043c9:	89 e5                	mov    %esp,%ebp
801043cb:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043ce:	9c                   	pushf  
801043cf:	58                   	pop    %eax
801043d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043d6:	c9                   	leave  
801043d7:	c3                   	ret    

801043d8 <sti>:
{
801043d8:	55                   	push   %ebp
801043d9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043db:	fb                   	sti    
}
801043dc:	90                   	nop
801043dd:	5d                   	pop    %ebp
801043de:	c3                   	ret    

801043df <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043df:	f3 0f 1e fb          	endbr32 
801043e3:	55                   	push   %ebp
801043e4:	89 e5                	mov    %esp,%ebp
801043e6:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043e9:	83 ec 08             	sub    $0x8,%esp
801043ec:	68 1c 8a 10 80       	push   $0x80108a1c
801043f1:	68 a0 3d 11 80       	push   $0x80113da0
801043f6:	e8 bd 0d 00 00       	call   801051b8 <initlock>
801043fb:	83 c4 10             	add    $0x10,%esp
}
801043fe:	90                   	nop
801043ff:	c9                   	leave  
80104400:	c3                   	ret    

80104401 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104401:	f3 0f 1e fb          	endbr32 
80104405:	55                   	push   %ebp
80104406:	89 e5                	mov    %esp,%ebp
80104408:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010440b:	e8 10 00 00 00       	call   80104420 <mycpu>
80104410:	2d 00 38 11 80       	sub    $0x80113800,%eax
80104415:	c1 f8 04             	sar    $0x4,%eax
80104418:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010441e:	c9                   	leave  
8010441f:	c3                   	ret    

80104420 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010442a:	e8 99 ff ff ff       	call   801043c8 <readeflags>
8010442f:	25 00 02 00 00       	and    $0x200,%eax
80104434:	85 c0                	test   %eax,%eax
80104436:	74 0d                	je     80104445 <mycpu+0x25>
    panic("mycpu called with interrupts enabled\n");
80104438:	83 ec 0c             	sub    $0xc,%esp
8010443b:	68 24 8a 10 80       	push   $0x80108a24
80104440:	e8 8c c1 ff ff       	call   801005d1 <panic>
  
  apicid = lapicid();
80104445:	e8 21 ed ff ff       	call   8010316b <lapicid>
8010444a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010444d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104454:	eb 2d                	jmp    80104483 <mycpu+0x63>
    if (cpus[i].apicid == apicid)
80104456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104459:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010445f:	05 00 38 11 80       	add    $0x80113800,%eax
80104464:	0f b6 00             	movzbl (%eax),%eax
80104467:	0f b6 c0             	movzbl %al,%eax
8010446a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010446d:	75 10                	jne    8010447f <mycpu+0x5f>
      return &cpus[i];
8010446f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104472:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104478:	05 00 38 11 80       	add    $0x80113800,%eax
8010447d:	eb 1b                	jmp    8010449a <mycpu+0x7a>
  for (i = 0; i < ncpu; ++i) {
8010447f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104483:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80104488:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010448b:	7c c9                	jl     80104456 <mycpu+0x36>
  }
  panic("unknown apicid\n");
8010448d:	83 ec 0c             	sub    $0xc,%esp
80104490:	68 4a 8a 10 80       	push   $0x80108a4a
80104495:	e8 37 c1 ff ff       	call   801005d1 <panic>
}
8010449a:	c9                   	leave  
8010449b:	c3                   	ret    

8010449c <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
8010449c:	f3 0f 1e fb          	endbr32 
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801044a6:	e8 bf 0e 00 00       	call   8010536a <pushcli>
  c = mycpu();
801044ab:	e8 70 ff ff ff       	call   80104420 <mycpu>
801044b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801044b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b6:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801044bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801044bf:	e8 f7 0e 00 00       	call   801053bb <popcli>
  return p;
801044c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801044c7:	c9                   	leave  
801044c8:	c3                   	ret    

801044c9 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801044c9:	f3 0f 1e fb          	endbr32 
801044cd:	55                   	push   %ebp
801044ce:	89 e5                	mov    %esp,%ebp
801044d0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	68 a0 3d 11 80       	push   $0x80113da0
801044db:	e8 fe 0c 00 00       	call   801051de <acquire>
801044e0:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044e3:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801044ea:	eb 0e                	jmp    801044fa <allocproc+0x31>
    if(p->state == UNUSED)
801044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ef:	8b 40 0c             	mov    0xc(%eax),%eax
801044f2:	85 c0                	test   %eax,%eax
801044f4:	74 27                	je     8010451d <allocproc+0x54>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f6:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801044fa:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104501:	72 e9                	jb     801044ec <allocproc+0x23>
      goto found;

  release(&ptable.lock);
80104503:	83 ec 0c             	sub    $0xc,%esp
80104506:	68 a0 3d 11 80       	push   $0x80113da0
8010450b:	e8 40 0d 00 00       	call   80105250 <release>
80104510:	83 c4 10             	add    $0x10,%esp
  return 0;
80104513:	b8 00 00 00 00       	mov    $0x0,%eax
80104518:	e9 b6 00 00 00       	jmp    801045d3 <allocproc+0x10a>
      goto found;
8010451d:	90                   	nop
8010451e:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
80104522:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104525:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010452c:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104531:	8d 50 01             	lea    0x1(%eax),%edx
80104534:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
8010453a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010453d:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	68 a0 3d 11 80       	push   $0x80113da0
80104548:	e8 03 0d 00 00       	call   80105250 <release>
8010454d:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104550:	e8 a9 e8 ff ff       	call   80102dfe <kalloc>
80104555:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104558:	89 42 08             	mov    %eax,0x8(%edx)
8010455b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455e:	8b 40 08             	mov    0x8(%eax),%eax
80104561:	85 c0                	test   %eax,%eax
80104563:	75 11                	jne    80104576 <allocproc+0xad>
    p->state = UNUSED;
80104565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104568:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010456f:	b8 00 00 00 00       	mov    $0x0,%eax
80104574:	eb 5d                	jmp    801045d3 <allocproc+0x10a>
  }
  sp = p->kstack + KSTACKSIZE;
80104576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104579:	8b 40 08             	mov    0x8(%eax),%eax
8010457c:	05 00 10 00 00       	add    $0x1000,%eax
80104581:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104584:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010458e:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104591:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104595:	ba 0c 69 10 80       	mov    $0x8010690c,%edx
8010459a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010459d:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010459f:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045a9:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	8b 40 1c             	mov    0x1c(%eax),%eax
801045b2:	83 ec 04             	sub    $0x4,%esp
801045b5:	6a 14                	push   $0x14
801045b7:	6a 00                	push   $0x0
801045b9:	50                   	push   %eax
801045ba:	e8 be 0e 00 00       	call   8010547d <memset>
801045bf:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c5:	8b 40 1c             	mov    0x1c(%eax),%eax
801045c8:	ba 2b 4d 10 80       	mov    $0x80104d2b,%edx
801045cd:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801045d3:	c9                   	leave  
801045d4:	c3                   	ret    

801045d5 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801045d5:	f3 0f 1e fb          	endbr32 
801045d9:	55                   	push   %ebp
801045da:	89 e5                	mov    %esp,%ebp
801045dc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801045df:	e8 e5 fe ff ff       	call   801044c9 <allocproc>
801045e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
801045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ea:	a3 20 b6 10 80       	mov    %eax,0x8010b620
  if((p->pgdir = setupkvm()) == 0)
801045ef:	e8 8a 38 00 00       	call   80107e7e <setupkvm>
801045f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045f7:	89 42 04             	mov    %eax,0x4(%edx)
801045fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fd:	8b 40 04             	mov    0x4(%eax),%eax
80104600:	85 c0                	test   %eax,%eax
80104602:	75 0d                	jne    80104611 <userinit+0x3c>
    panic("userinit: out of memory?");
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	68 5a 8a 10 80       	push   $0x80108a5a
8010460c:	e8 c0 bf ff ff       	call   801005d1 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104611:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104619:	8b 40 04             	mov    0x4(%eax),%eax
8010461c:	83 ec 04             	sub    $0x4,%esp
8010461f:	52                   	push   %edx
80104620:	68 c0 b4 10 80       	push   $0x8010b4c0
80104625:	50                   	push   %eax
80104626:	e8 cc 3a 00 00       	call   801080f7 <inituvm>
8010462b:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010462e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104631:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463a:	8b 40 18             	mov    0x18(%eax),%eax
8010463d:	83 ec 04             	sub    $0x4,%esp
80104640:	6a 4c                	push   $0x4c
80104642:	6a 00                	push   $0x0
80104644:	50                   	push   %eax
80104645:	e8 33 0e 00 00       	call   8010547d <memset>
8010464a:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010464d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104650:	8b 40 18             	mov    0x18(%eax),%eax
80104653:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465c:	8b 40 18             	mov    0x18(%eax),%eax
8010465f:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104668:	8b 50 18             	mov    0x18(%eax),%edx
8010466b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466e:	8b 40 18             	mov    0x18(%eax),%eax
80104671:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104675:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467c:	8b 50 18             	mov    0x18(%eax),%edx
8010467f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104682:	8b 40 18             	mov    0x18(%eax),%eax
80104685:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104689:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104690:	8b 40 18             	mov    0x18(%eax),%eax
80104693:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469d:	8b 40 18             	mov    0x18(%eax),%eax
801046a0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801046a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046aa:	8b 40 18             	mov    0x18(%eax),%eax
801046ad:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801046b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b7:	83 c0 6c             	add    $0x6c,%eax
801046ba:	83 ec 04             	sub    $0x4,%esp
801046bd:	6a 10                	push   $0x10
801046bf:	68 73 8a 10 80       	push   $0x80108a73
801046c4:	50                   	push   %eax
801046c5:	e8 ce 0f 00 00       	call   80105698 <safestrcpy>
801046ca:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801046cd:	83 ec 0c             	sub    $0xc,%esp
801046d0:	68 7c 8a 10 80       	push   $0x80108a7c
801046d5:	e8 9f df ff ff       	call   80102679 <namei>
801046da:	83 c4 10             	add    $0x10,%esp
801046dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046e0:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801046e3:	83 ec 0c             	sub    $0xc,%esp
801046e6:	68 a0 3d 11 80       	push   $0x80113da0
801046eb:	e8 ee 0a 00 00       	call   801051de <acquire>
801046f0:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
801046f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801046fd:	83 ec 0c             	sub    $0xc,%esp
80104700:	68 a0 3d 11 80       	push   $0x80113da0
80104705:	e8 46 0b 00 00       	call   80105250 <release>
8010470a:	83 c4 10             	add    $0x10,%esp
}
8010470d:	90                   	nop
8010470e:	c9                   	leave  
8010470f:	c3                   	ret    

80104710 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
8010471a:	e8 7d fd ff ff       	call   8010449c <myproc>
8010471f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104722:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104725:	8b 00                	mov    (%eax),%eax
80104727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010472a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010472e:	7e 2e                	jle    8010475e <growproc+0x4e>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104730:	8b 55 08             	mov    0x8(%ebp),%edx
80104733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104736:	01 c2                	add    %eax,%edx
80104738:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010473b:	8b 40 04             	mov    0x4(%eax),%eax
8010473e:	83 ec 04             	sub    $0x4,%esp
80104741:	52                   	push   %edx
80104742:	ff 75 f4             	pushl  -0xc(%ebp)
80104745:	50                   	push   %eax
80104746:	e8 f1 3a 00 00       	call   8010823c <allocuvm>
8010474b:	83 c4 10             	add    $0x10,%esp
8010474e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104755:	75 3b                	jne    80104792 <growproc+0x82>
      return -1;
80104757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010475c:	eb 4f                	jmp    801047ad <growproc+0x9d>
  } else if(n < 0){
8010475e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104762:	79 2e                	jns    80104792 <growproc+0x82>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104764:	8b 55 08             	mov    0x8(%ebp),%edx
80104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476a:	01 c2                	add    %eax,%edx
8010476c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010476f:	8b 40 04             	mov    0x4(%eax),%eax
80104772:	83 ec 04             	sub    $0x4,%esp
80104775:	52                   	push   %edx
80104776:	ff 75 f4             	pushl  -0xc(%ebp)
80104779:	50                   	push   %eax
8010477a:	e8 c6 3b 00 00       	call   80108345 <deallocuvm>
8010477f:	83 c4 10             	add    $0x10,%esp
80104782:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104785:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104789:	75 07                	jne    80104792 <growproc+0x82>
      return -1;
8010478b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104790:	eb 1b                	jmp    801047ad <growproc+0x9d>
  }
  curproc->sz = sz;
80104792:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104795:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104798:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
8010479a:	83 ec 0c             	sub    $0xc,%esp
8010479d:	ff 75 f0             	pushl  -0x10(%ebp)
801047a0:	e8 af 37 00 00       	call   80107f54 <switchuvm>
801047a5:	83 c4 10             	add    $0x10,%esp
  return 0;
801047a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047ad:	c9                   	leave  
801047ae:	c3                   	ret    

801047af <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801047af:	f3 0f 1e fb          	endbr32 
801047b3:	55                   	push   %ebp
801047b4:	89 e5                	mov    %esp,%ebp
801047b6:	57                   	push   %edi
801047b7:	56                   	push   %esi
801047b8:	53                   	push   %ebx
801047b9:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801047bc:	e8 db fc ff ff       	call   8010449c <myproc>
801047c1:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801047c4:	e8 00 fd ff ff       	call   801044c9 <allocproc>
801047c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801047cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801047d0:	75 0a                	jne    801047dc <fork+0x2d>
    return -1;
801047d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d7:	e9 48 01 00 00       	jmp    80104924 <fork+0x175>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801047dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047df:	8b 10                	mov    (%eax),%edx
801047e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e4:	8b 40 04             	mov    0x4(%eax),%eax
801047e7:	83 ec 08             	sub    $0x8,%esp
801047ea:	52                   	push   %edx
801047eb:	50                   	push   %eax
801047ec:	e8 fe 3c 00 00       	call   801084ef <copyuvm>
801047f1:	83 c4 10             	add    $0x10,%esp
801047f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047f7:	89 42 04             	mov    %eax,0x4(%edx)
801047fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801047fd:	8b 40 04             	mov    0x4(%eax),%eax
80104800:	85 c0                	test   %eax,%eax
80104802:	75 30                	jne    80104834 <fork+0x85>
    kfree(np->kstack);
80104804:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104807:	8b 40 08             	mov    0x8(%eax),%eax
8010480a:	83 ec 0c             	sub    $0xc,%esp
8010480d:	50                   	push   %eax
8010480e:	e8 4d e5 ff ff       	call   80102d60 <kfree>
80104813:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104816:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104819:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104820:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104823:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010482a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010482f:	e9 f0 00 00 00       	jmp    80104924 <fork+0x175>
  }
  np->sz = curproc->sz;
80104834:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104837:	8b 10                	mov    (%eax),%edx
80104839:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010483c:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010483e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104841:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104844:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104847:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010484a:	8b 48 18             	mov    0x18(%eax),%ecx
8010484d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104850:	8b 40 18             	mov    0x18(%eax),%eax
80104853:	89 c2                	mov    %eax,%edx
80104855:	89 cb                	mov    %ecx,%ebx
80104857:	b8 13 00 00 00       	mov    $0x13,%eax
8010485c:	89 d7                	mov    %edx,%edi
8010485e:	89 de                	mov    %ebx,%esi
80104860:	89 c1                	mov    %eax,%ecx
80104862:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104864:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104867:	8b 40 18             	mov    0x18(%eax),%eax
8010486a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104871:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104878:	eb 3b                	jmp    801048b5 <fork+0x106>
    if(curproc->ofile[i])
8010487a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010487d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104880:	83 c2 08             	add    $0x8,%edx
80104883:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104887:	85 c0                	test   %eax,%eax
80104889:	74 26                	je     801048b1 <fork+0x102>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010488b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010488e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104891:	83 c2 08             	add    $0x8,%edx
80104894:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104898:	83 ec 0c             	sub    $0xc,%esp
8010489b:	50                   	push   %eax
8010489c:	e8 2e c8 ff ff       	call   801010cf <filedup>
801048a1:	83 c4 10             	add    $0x10,%esp
801048a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801048a7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801048aa:	83 c1 08             	add    $0x8,%ecx
801048ad:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801048b1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048b5:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048b9:	7e bf                	jle    8010487a <fork+0xcb>
  np->cwd = idup(curproc->cwd);
801048bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048be:	8b 40 68             	mov    0x68(%eax),%eax
801048c1:	83 ec 0c             	sub    $0xc,%esp
801048c4:	50                   	push   %eax
801048c5:	e8 06 d2 ff ff       	call   80101ad0 <idup>
801048ca:	83 c4 10             	add    $0x10,%esp
801048cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801048d0:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801048d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d6:	8d 50 6c             	lea    0x6c(%eax),%edx
801048d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048dc:	83 c0 6c             	add    $0x6c,%eax
801048df:	83 ec 04             	sub    $0x4,%esp
801048e2:	6a 10                	push   $0x10
801048e4:	52                   	push   %edx
801048e5:	50                   	push   %eax
801048e6:	e8 ad 0d 00 00       	call   80105698 <safestrcpy>
801048eb:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801048ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
801048f1:	8b 40 10             	mov    0x10(%eax),%eax
801048f4:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
801048f7:	83 ec 0c             	sub    $0xc,%esp
801048fa:	68 a0 3d 11 80       	push   $0x80113da0
801048ff:	e8 da 08 00 00       	call   801051de <acquire>
80104904:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104907:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010490a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104911:	83 ec 0c             	sub    $0xc,%esp
80104914:	68 a0 3d 11 80       	push   $0x80113da0
80104919:	e8 32 09 00 00       	call   80105250 <release>
8010491e:	83 c4 10             	add    $0x10,%esp

  return pid;
80104921:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104924:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104927:	5b                   	pop    %ebx
80104928:	5e                   	pop    %esi
80104929:	5f                   	pop    %edi
8010492a:	5d                   	pop    %ebp
8010492b:	c3                   	ret    

8010492c <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010492c:	f3 0f 1e fb          	endbr32 
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104936:	e8 61 fb ff ff       	call   8010449c <myproc>
8010493b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010493e:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104943:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104946:	75 0d                	jne    80104955 <exit+0x29>
    panic("init exiting");
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	68 7e 8a 10 80       	push   $0x80108a7e
80104950:	e8 7c bc ff ff       	call   801005d1 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104955:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010495c:	eb 3f                	jmp    8010499d <exit+0x71>
    if(curproc->ofile[fd]){
8010495e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104961:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104964:	83 c2 08             	add    $0x8,%edx
80104967:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010496b:	85 c0                	test   %eax,%eax
8010496d:	74 2a                	je     80104999 <exit+0x6d>
      fileclose(curproc->ofile[fd]);
8010496f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104972:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104975:	83 c2 08             	add    $0x8,%edx
80104978:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010497c:	83 ec 0c             	sub    $0xc,%esp
8010497f:	50                   	push   %eax
80104980:	e8 9f c7 ff ff       	call   80101124 <fileclose>
80104985:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104988:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010498b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010498e:	83 c2 08             	add    $0x8,%edx
80104991:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104998:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104999:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010499d:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801049a1:	7e bb                	jle    8010495e <exit+0x32>
    }
  }

  begin_op();
801049a3:	e8 35 ed ff ff       	call   801036dd <begin_op>
  iput(curproc->cwd);
801049a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ab:	8b 40 68             	mov    0x68(%eax),%eax
801049ae:	83 ec 0c             	sub    $0xc,%esp
801049b1:	50                   	push   %eax
801049b2:	e8 c0 d2 ff ff       	call   80101c77 <iput>
801049b7:	83 c4 10             	add    $0x10,%esp
  end_op();
801049ba:	e8 ae ed ff ff       	call   8010376d <end_op>
  curproc->cwd = 0;
801049bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049c2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	68 a0 3d 11 80       	push   $0x80113da0
801049d1:	e8 08 08 00 00       	call   801051de <acquire>
801049d6:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801049d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049dc:	8b 40 14             	mov    0x14(%eax),%eax
801049df:	83 ec 0c             	sub    $0xc,%esp
801049e2:	50                   	push   %eax
801049e3:	e8 38 04 00 00       	call   80104e20 <wakeup1>
801049e8:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049eb:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801049f2:	eb 37                	jmp    80104a2b <exit+0xff>
    if(p->parent == curproc){
801049f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f7:	8b 40 14             	mov    0x14(%eax),%eax
801049fa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801049fd:	75 28                	jne    80104a27 <exit+0xfb>
      p->parent = initproc;
801049ff:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
80104a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a08:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104a11:	83 f8 05             	cmp    $0x5,%eax
80104a14:	75 11                	jne    80104a27 <exit+0xfb>
        wakeup1(initproc);
80104a16:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104a1b:	83 ec 0c             	sub    $0xc,%esp
80104a1e:	50                   	push   %eax
80104a1f:	e8 fc 03 00 00       	call   80104e20 <wakeup1>
80104a24:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a27:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a2b:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104a32:	72 c0                	jb     801049f4 <exit+0xc8>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a37:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104a3e:	e8 ed 01 00 00       	call   80104c30 <sched>
  panic("zombie exit");
80104a43:	83 ec 0c             	sub    $0xc,%esp
80104a46:	68 8b 8a 10 80       	push   $0x80108a8b
80104a4b:	e8 81 bb ff ff       	call   801005d1 <panic>

80104a50 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104a5a:	e8 3d fa ff ff       	call   8010449c <myproc>
80104a5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104a62:	83 ec 0c             	sub    $0xc,%esp
80104a65:	68 a0 3d 11 80       	push   $0x80113da0
80104a6a:	e8 6f 07 00 00       	call   801051de <acquire>
80104a6f:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104a72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a79:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104a80:	e9 a1 00 00 00       	jmp    80104b26 <wait+0xd6>
      if(p->parent != curproc)
80104a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a88:	8b 40 14             	mov    0x14(%eax),%eax
80104a8b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104a8e:	0f 85 8d 00 00 00    	jne    80104b21 <wait+0xd1>
        continue;
      havekids = 1;
80104a94:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9e:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa1:	83 f8 05             	cmp    $0x5,%eax
80104aa4:	75 7c                	jne    80104b22 <wait+0xd2>
        // Found one.
        pid = p->pid;
80104aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa9:	8b 40 10             	mov    0x10(%eax),%eax
80104aac:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab2:	8b 40 08             	mov    0x8(%eax),%eax
80104ab5:	83 ec 0c             	sub    $0xc,%esp
80104ab8:	50                   	push   %eax
80104ab9:	e8 a2 e2 ff ff       	call   80102d60 <kfree>
80104abe:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ace:	8b 40 04             	mov    0x4(%eax),%eax
80104ad1:	83 ec 0c             	sub    $0xc,%esp
80104ad4:	50                   	push   %eax
80104ad5:	e8 33 39 00 00       	call   8010840d <freevm>
80104ada:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aea:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af4:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afb:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	68 a0 3d 11 80       	push   $0x80113da0
80104b14:	e8 37 07 00 00       	call   80105250 <release>
80104b19:	83 c4 10             	add    $0x10,%esp
        return pid;
80104b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104b1f:	eb 51                	jmp    80104b72 <wait+0x122>
        continue;
80104b21:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b22:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b26:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104b2d:	0f 82 52 ff ff ff    	jb     80104a85 <wait+0x35>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104b33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b37:	74 0a                	je     80104b43 <wait+0xf3>
80104b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b3c:	8b 40 24             	mov    0x24(%eax),%eax
80104b3f:	85 c0                	test   %eax,%eax
80104b41:	74 17                	je     80104b5a <wait+0x10a>
      release(&ptable.lock);
80104b43:	83 ec 0c             	sub    $0xc,%esp
80104b46:	68 a0 3d 11 80       	push   $0x80113da0
80104b4b:	e8 00 07 00 00       	call   80105250 <release>
80104b50:	83 c4 10             	add    $0x10,%esp
      return -1;
80104b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b58:	eb 18                	jmp    80104b72 <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104b5a:	83 ec 08             	sub    $0x8,%esp
80104b5d:	68 a0 3d 11 80       	push   $0x80113da0
80104b62:	ff 75 ec             	pushl  -0x14(%ebp)
80104b65:	e8 0b 02 00 00       	call   80104d75 <sleep>
80104b6a:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b6d:	e9 00 ff ff ff       	jmp    80104a72 <wait+0x22>
  }
}
80104b72:	c9                   	leave  
80104b73:	c3                   	ret    

80104b74 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104b74:	f3 0f 1e fb          	endbr32 
80104b78:	55                   	push   %ebp
80104b79:	89 e5                	mov    %esp,%ebp
80104b7b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104b7e:	e8 9d f8 ff ff       	call   80104420 <mycpu>
80104b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b89:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104b90:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104b93:	e8 40 f8 ff ff       	call   801043d8 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	68 a0 3d 11 80       	push   $0x80113da0
80104ba0:	e8 39 06 00 00       	call   801051de <acquire>
80104ba5:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ba8:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104baf:	eb 61                	jmp    80104c12 <scheduler+0x9e>
      if(p->state != RUNNABLE)
80104bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb4:	8b 40 0c             	mov    0xc(%eax),%eax
80104bb7:	83 f8 03             	cmp    $0x3,%eax
80104bba:	75 51                	jne    80104c0d <scheduler+0x99>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bc2:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104bc8:	83 ec 0c             	sub    $0xc,%esp
80104bcb:	ff 75 f4             	pushl  -0xc(%ebp)
80104bce:	e8 81 33 00 00       	call   80107f54 <switchuvm>
80104bd3:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd9:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be3:	8b 40 1c             	mov    0x1c(%eax),%eax
80104be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104be9:	83 c2 04             	add    $0x4,%edx
80104bec:	83 ec 08             	sub    $0x8,%esp
80104bef:	50                   	push   %eax
80104bf0:	52                   	push   %edx
80104bf1:	e8 1b 0b 00 00       	call   80105711 <swtch>
80104bf6:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104bf9:	e8 39 33 00 00       	call   80107f37 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c01:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104c08:	00 00 00 
80104c0b:	eb 01                	jmp    80104c0e <scheduler+0x9a>
        continue;
80104c0d:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c0e:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104c12:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104c19:	72 96                	jb     80104bb1 <scheduler+0x3d>
    }
    release(&ptable.lock);
80104c1b:	83 ec 0c             	sub    $0xc,%esp
80104c1e:	68 a0 3d 11 80       	push   $0x80113da0
80104c23:	e8 28 06 00 00       	call   80105250 <release>
80104c28:	83 c4 10             	add    $0x10,%esp
    sti();
80104c2b:	e9 63 ff ff ff       	jmp    80104b93 <scheduler+0x1f>

80104c30 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104c3a:	e8 5d f8 ff ff       	call   8010449c <myproc>
80104c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104c42:	83 ec 0c             	sub    $0xc,%esp
80104c45:	68 a0 3d 11 80       	push   $0x80113da0
80104c4a:	e8 d6 06 00 00       	call   80105325 <holding>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	85 c0                	test   %eax,%eax
80104c54:	75 0d                	jne    80104c63 <sched+0x33>
    panic("sched ptable.lock");
80104c56:	83 ec 0c             	sub    $0xc,%esp
80104c59:	68 97 8a 10 80       	push   $0x80108a97
80104c5e:	e8 6e b9 ff ff       	call   801005d1 <panic>
  if(mycpu()->ncli != 1)
80104c63:	e8 b8 f7 ff ff       	call   80104420 <mycpu>
80104c68:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c6e:	83 f8 01             	cmp    $0x1,%eax
80104c71:	74 0d                	je     80104c80 <sched+0x50>
    panic("sched locks");
80104c73:	83 ec 0c             	sub    $0xc,%esp
80104c76:	68 a9 8a 10 80       	push   $0x80108aa9
80104c7b:	e8 51 b9 ff ff       	call   801005d1 <panic>
  if(p->state == RUNNING)
80104c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c83:	8b 40 0c             	mov    0xc(%eax),%eax
80104c86:	83 f8 04             	cmp    $0x4,%eax
80104c89:	75 0d                	jne    80104c98 <sched+0x68>
    panic("sched running");
80104c8b:	83 ec 0c             	sub    $0xc,%esp
80104c8e:	68 b5 8a 10 80       	push   $0x80108ab5
80104c93:	e8 39 b9 ff ff       	call   801005d1 <panic>
  if(readeflags()&FL_IF)
80104c98:	e8 2b f7 ff ff       	call   801043c8 <readeflags>
80104c9d:	25 00 02 00 00       	and    $0x200,%eax
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	74 0d                	je     80104cb3 <sched+0x83>
    panic("sched interruptible");
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	68 c3 8a 10 80       	push   $0x80108ac3
80104cae:	e8 1e b9 ff ff       	call   801005d1 <panic>
  intena = mycpu()->intena;
80104cb3:	e8 68 f7 ff ff       	call   80104420 <mycpu>
80104cb8:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104cc1:	e8 5a f7 ff ff       	call   80104420 <mycpu>
80104cc6:	8b 40 04             	mov    0x4(%eax),%eax
80104cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ccc:	83 c2 1c             	add    $0x1c,%edx
80104ccf:	83 ec 08             	sub    $0x8,%esp
80104cd2:	50                   	push   %eax
80104cd3:	52                   	push   %edx
80104cd4:	e8 38 0a 00 00       	call   80105711 <swtch>
80104cd9:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104cdc:	e8 3f f7 ff ff       	call   80104420 <mycpu>
80104ce1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ce4:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104cea:	90                   	nop
80104ceb:	c9                   	leave  
80104cec:	c3                   	ret    

80104ced <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104ced:	f3 0f 1e fb          	endbr32 
80104cf1:	55                   	push   %ebp
80104cf2:	89 e5                	mov    %esp,%ebp
80104cf4:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104cf7:	83 ec 0c             	sub    $0xc,%esp
80104cfa:	68 a0 3d 11 80       	push   $0x80113da0
80104cff:	e8 da 04 00 00       	call   801051de <acquire>
80104d04:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104d07:	e8 90 f7 ff ff       	call   8010449c <myproc>
80104d0c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104d13:	e8 18 ff ff ff       	call   80104c30 <sched>
  release(&ptable.lock);
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	68 a0 3d 11 80       	push   $0x80113da0
80104d20:	e8 2b 05 00 00       	call   80105250 <release>
80104d25:	83 c4 10             	add    $0x10,%esp
}
80104d28:	90                   	nop
80104d29:	c9                   	leave  
80104d2a:	c3                   	ret    

80104d2b <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d2b:	f3 0f 1e fb          	endbr32 
80104d2f:	55                   	push   %ebp
80104d30:	89 e5                	mov    %esp,%ebp
80104d32:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d35:	83 ec 0c             	sub    $0xc,%esp
80104d38:	68 a0 3d 11 80       	push   $0x80113da0
80104d3d:	e8 0e 05 00 00       	call   80105250 <release>
80104d42:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104d45:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104d4a:	85 c0                	test   %eax,%eax
80104d4c:	74 24                	je     80104d72 <forkret+0x47>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104d4e:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80104d55:	00 00 00 
    iinit(ROOTDEV);
80104d58:	83 ec 0c             	sub    $0xc,%esp
80104d5b:	6a 01                	push   $0x1
80104d5d:	e8 26 ca ff ff       	call   80101788 <iinit>
80104d62:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104d65:	83 ec 0c             	sub    $0xc,%esp
80104d68:	6a 01                	push   $0x1
80104d6a:	e8 3b e7 ff ff       	call   801034aa <initlog>
80104d6f:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104d72:	90                   	nop
80104d73:	c9                   	leave  
80104d74:	c3                   	ret    

80104d75 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104d75:	f3 0f 1e fb          	endbr32 
80104d79:	55                   	push   %ebp
80104d7a:	89 e5                	mov    %esp,%ebp
80104d7c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104d7f:	e8 18 f7 ff ff       	call   8010449c <myproc>
80104d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d8b:	75 0d                	jne    80104d9a <sleep+0x25>
    panic("sleep");
80104d8d:	83 ec 0c             	sub    $0xc,%esp
80104d90:	68 d7 8a 10 80       	push   $0x80108ad7
80104d95:	e8 37 b8 ff ff       	call   801005d1 <panic>

  if(lk == 0)
80104d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104d9e:	75 0d                	jne    80104dad <sleep+0x38>
    panic("sleep without lk");
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	68 dd 8a 10 80       	push   $0x80108add
80104da8:	e8 24 b8 ff ff       	call   801005d1 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104dad:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104db4:	74 1e                	je     80104dd4 <sleep+0x5f>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104db6:	83 ec 0c             	sub    $0xc,%esp
80104db9:	68 a0 3d 11 80       	push   $0x80113da0
80104dbe:	e8 1b 04 00 00       	call   801051de <acquire>
80104dc3:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104dc6:	83 ec 0c             	sub    $0xc,%esp
80104dc9:	ff 75 0c             	pushl  0xc(%ebp)
80104dcc:	e8 7f 04 00 00       	call   80105250 <release>
80104dd1:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd7:	8b 55 08             	mov    0x8(%ebp),%edx
80104dda:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104de7:	e8 44 fe ff ff       	call   80104c30 <sched>

  // Tidy up.
  p->chan = 0;
80104dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104def:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104df6:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104dfd:	74 1e                	je     80104e1d <sleep+0xa8>
    release(&ptable.lock);
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	68 a0 3d 11 80       	push   $0x80113da0
80104e07:	e8 44 04 00 00       	call   80105250 <release>
80104e0c:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104e0f:	83 ec 0c             	sub    $0xc,%esp
80104e12:	ff 75 0c             	pushl  0xc(%ebp)
80104e15:	e8 c4 03 00 00       	call   801051de <acquire>
80104e1a:	83 c4 10             	add    $0x10,%esp
  }
}
80104e1d:	90                   	nop
80104e1e:	c9                   	leave  
80104e1f:	c3                   	ret    

80104e20 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e2a:	c7 45 fc d4 3d 11 80 	movl   $0x80113dd4,-0x4(%ebp)
80104e31:	eb 24                	jmp    80104e57 <wakeup1+0x37>
    if(p->state == SLEEPING && p->chan == chan)
80104e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e36:	8b 40 0c             	mov    0xc(%eax),%eax
80104e39:	83 f8 02             	cmp    $0x2,%eax
80104e3c:	75 15                	jne    80104e53 <wakeup1+0x33>
80104e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e41:	8b 40 20             	mov    0x20(%eax),%eax
80104e44:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e47:	75 0a                	jne    80104e53 <wakeup1+0x33>
      p->state = RUNNABLE;
80104e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e4c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e53:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104e57:	81 7d fc d4 5c 11 80 	cmpl   $0x80115cd4,-0x4(%ebp)
80104e5e:	72 d3                	jb     80104e33 <wakeup1+0x13>
}
80104e60:	90                   	nop
80104e61:	90                   	nop
80104e62:	c9                   	leave  
80104e63:	c3                   	ret    

80104e64 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104e64:	f3 0f 1e fb          	endbr32 
80104e68:	55                   	push   %ebp
80104e69:	89 e5                	mov    %esp,%ebp
80104e6b:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104e6e:	83 ec 0c             	sub    $0xc,%esp
80104e71:	68 a0 3d 11 80       	push   $0x80113da0
80104e76:	e8 63 03 00 00       	call   801051de <acquire>
80104e7b:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104e7e:	83 ec 0c             	sub    $0xc,%esp
80104e81:	ff 75 08             	pushl  0x8(%ebp)
80104e84:	e8 97 ff ff ff       	call   80104e20 <wakeup1>
80104e89:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	68 a0 3d 11 80       	push   $0x80113da0
80104e94:	e8 b7 03 00 00       	call   80105250 <release>
80104e99:	83 c4 10             	add    $0x10,%esp
}
80104e9c:	90                   	nop
80104e9d:	c9                   	leave  
80104e9e:	c3                   	ret    

80104e9f <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104e9f:	f3 0f 1e fb          	endbr32 
80104ea3:	55                   	push   %ebp
80104ea4:	89 e5                	mov    %esp,%ebp
80104ea6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104ea9:	83 ec 0c             	sub    $0xc,%esp
80104eac:	68 a0 3d 11 80       	push   $0x80113da0
80104eb1:	e8 28 03 00 00       	call   801051de <acquire>
80104eb6:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eb9:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104ec0:	eb 45                	jmp    80104f07 <kill+0x68>
    if(p->pid == pid){
80104ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec5:	8b 40 10             	mov    0x10(%eax),%eax
80104ec8:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ecb:	75 36                	jne    80104f03 <kill+0x64>
      p->killed = 1;
80104ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eda:	8b 40 0c             	mov    0xc(%eax),%eax
80104edd:	83 f8 02             	cmp    $0x2,%eax
80104ee0:	75 0a                	jne    80104eec <kill+0x4d>
        p->state = RUNNABLE;
80104ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104eec:	83 ec 0c             	sub    $0xc,%esp
80104eef:	68 a0 3d 11 80       	push   $0x80113da0
80104ef4:	e8 57 03 00 00       	call   80105250 <release>
80104ef9:	83 c4 10             	add    $0x10,%esp
      return 0;
80104efc:	b8 00 00 00 00       	mov    $0x0,%eax
80104f01:	eb 22                	jmp    80104f25 <kill+0x86>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f03:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104f07:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104f0e:	72 b2                	jb     80104ec2 <kill+0x23>
    }
  }
  release(&ptable.lock);
80104f10:	83 ec 0c             	sub    $0xc,%esp
80104f13:	68 a0 3d 11 80       	push   $0x80113da0
80104f18:	e8 33 03 00 00       	call   80105250 <release>
80104f1d:	83 c4 10             	add    $0x10,%esp
  return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    

80104f27 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f27:	f3 0f 1e fb          	endbr32 
80104f2b:	55                   	push   %ebp
80104f2c:	89 e5                	mov    %esp,%ebp
80104f2e:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f31:	c7 45 f0 d4 3d 11 80 	movl   $0x80113dd4,-0x10(%ebp)
80104f38:	e9 d7 00 00 00       	jmp    80105014 <procdump+0xed>
    if(p->state == UNUSED)
80104f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f40:	8b 40 0c             	mov    0xc(%eax),%eax
80104f43:	85 c0                	test   %eax,%eax
80104f45:	0f 84 c4 00 00 00    	je     8010500f <procdump+0xe8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f4e:	8b 40 0c             	mov    0xc(%eax),%eax
80104f51:	83 f8 05             	cmp    $0x5,%eax
80104f54:	77 23                	ja     80104f79 <procdump+0x52>
80104f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f59:	8b 40 0c             	mov    0xc(%eax),%eax
80104f5c:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104f63:	85 c0                	test   %eax,%eax
80104f65:	74 12                	je     80104f79 <procdump+0x52>
      state = states[p->state];
80104f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f6a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f6d:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f77:	eb 07                	jmp    80104f80 <procdump+0x59>
    else
      state = "???";
80104f79:	c7 45 ec ee 8a 10 80 	movl   $0x80108aee,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f83:	8d 50 6c             	lea    0x6c(%eax),%edx
80104f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f89:	8b 40 10             	mov    0x10(%eax),%eax
80104f8c:	52                   	push   %edx
80104f8d:	ff 75 ec             	pushl  -0x14(%ebp)
80104f90:	50                   	push   %eax
80104f91:	68 f2 8a 10 80       	push   $0x80108af2
80104f96:	e8 7d b4 ff ff       	call   80100418 <cprintf>
80104f9b:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa1:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa4:	83 f8 02             	cmp    $0x2,%eax
80104fa7:	75 54                	jne    80104ffd <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fac:	8b 40 1c             	mov    0x1c(%eax),%eax
80104faf:	8b 40 0c             	mov    0xc(%eax),%eax
80104fb2:	83 c0 08             	add    $0x8,%eax
80104fb5:	89 c2                	mov    %eax,%edx
80104fb7:	83 ec 08             	sub    $0x8,%esp
80104fba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fbd:	50                   	push   %eax
80104fbe:	52                   	push   %edx
80104fbf:	e8 e2 02 00 00       	call   801052a6 <getcallerpcs>
80104fc4:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104fc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fce:	eb 1c                	jmp    80104fec <procdump+0xc5>
        cprintf(" %p", pc[i]);
80104fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd3:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fd7:	83 ec 08             	sub    $0x8,%esp
80104fda:	50                   	push   %eax
80104fdb:	68 fb 8a 10 80       	push   $0x80108afb
80104fe0:	e8 33 b4 ff ff       	call   80100418 <cprintf>
80104fe5:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104fe8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104fec:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ff0:	7f 0b                	jg     80104ffd <procdump+0xd6>
80104ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ff9:	85 c0                	test   %eax,%eax
80104ffb:	75 d3                	jne    80104fd0 <procdump+0xa9>
    }
    cprintf("\n");
80104ffd:	83 ec 0c             	sub    $0xc,%esp
80105000:	68 ff 8a 10 80       	push   $0x80108aff
80105005:	e8 0e b4 ff ff       	call   80100418 <cprintf>
8010500a:	83 c4 10             	add    $0x10,%esp
8010500d:	eb 01                	jmp    80105010 <procdump+0xe9>
      continue;
8010500f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105010:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80105014:	81 7d f0 d4 5c 11 80 	cmpl   $0x80115cd4,-0x10(%ebp)
8010501b:	0f 82 1c ff ff ff    	jb     80104f3d <procdump+0x16>
  }
}
80105021:	90                   	nop
80105022:	90                   	nop
80105023:	c9                   	leave  
80105024:	c3                   	ret    

80105025 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105025:	f3 0f 1e fb          	endbr32 
80105029:	55                   	push   %ebp
8010502a:	89 e5                	mov    %esp,%ebp
8010502c:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
8010502f:	8b 45 08             	mov    0x8(%ebp),%eax
80105032:	83 c0 04             	add    $0x4,%eax
80105035:	83 ec 08             	sub    $0x8,%esp
80105038:	68 2b 8b 10 80       	push   $0x80108b2b
8010503d:	50                   	push   %eax
8010503e:	e8 75 01 00 00       	call   801051b8 <initlock>
80105043:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80105046:	8b 45 08             	mov    0x8(%ebp),%eax
80105049:	8b 55 0c             	mov    0xc(%ebp),%edx
8010504c:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
8010504f:	8b 45 08             	mov    0x8(%ebp),%eax
80105052:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80105058:	8b 45 08             	mov    0x8(%ebp),%eax
8010505b:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80105062:	90                   	nop
80105063:	c9                   	leave  
80105064:	c3                   	ret    

80105065 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105065:	f3 0f 1e fb          	endbr32 
80105069:	55                   	push   %ebp
8010506a:	89 e5                	mov    %esp,%ebp
8010506c:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010506f:	8b 45 08             	mov    0x8(%ebp),%eax
80105072:	83 c0 04             	add    $0x4,%eax
80105075:	83 ec 0c             	sub    $0xc,%esp
80105078:	50                   	push   %eax
80105079:	e8 60 01 00 00       	call   801051de <acquire>
8010507e:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105081:	eb 15                	jmp    80105098 <acquiresleep+0x33>
    sleep(lk, &lk->lk);
80105083:	8b 45 08             	mov    0x8(%ebp),%eax
80105086:	83 c0 04             	add    $0x4,%eax
80105089:	83 ec 08             	sub    $0x8,%esp
8010508c:	50                   	push   %eax
8010508d:	ff 75 08             	pushl  0x8(%ebp)
80105090:	e8 e0 fc ff ff       	call   80104d75 <sleep>
80105095:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105098:	8b 45 08             	mov    0x8(%ebp),%eax
8010509b:	8b 00                	mov    (%eax),%eax
8010509d:	85 c0                	test   %eax,%eax
8010509f:	75 e2                	jne    80105083 <acquiresleep+0x1e>
  }
  lk->locked = 1;
801050a1:	8b 45 08             	mov    0x8(%ebp),%eax
801050a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
801050aa:	e8 ed f3 ff ff       	call   8010449c <myproc>
801050af:	8b 50 10             	mov    0x10(%eax),%edx
801050b2:	8b 45 08             	mov    0x8(%ebp),%eax
801050b5:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801050b8:	8b 45 08             	mov    0x8(%ebp),%eax
801050bb:	83 c0 04             	add    $0x4,%eax
801050be:	83 ec 0c             	sub    $0xc,%esp
801050c1:	50                   	push   %eax
801050c2:	e8 89 01 00 00       	call   80105250 <release>
801050c7:	83 c4 10             	add    $0x10,%esp
}
801050ca:	90                   	nop
801050cb:	c9                   	leave  
801050cc:	c3                   	ret    

801050cd <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801050cd:	f3 0f 1e fb          	endbr32 
801050d1:	55                   	push   %ebp
801050d2:	89 e5                	mov    %esp,%ebp
801050d4:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801050d7:	8b 45 08             	mov    0x8(%ebp),%eax
801050da:	83 c0 04             	add    $0x4,%eax
801050dd:	83 ec 0c             	sub    $0xc,%esp
801050e0:	50                   	push   %eax
801050e1:	e8 f8 00 00 00       	call   801051de <acquire>
801050e6:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801050e9:	8b 45 08             	mov    0x8(%ebp),%eax
801050ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801050f2:	8b 45 08             	mov    0x8(%ebp),%eax
801050f5:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801050fc:	83 ec 0c             	sub    $0xc,%esp
801050ff:	ff 75 08             	pushl  0x8(%ebp)
80105102:	e8 5d fd ff ff       	call   80104e64 <wakeup>
80105107:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
8010510a:	8b 45 08             	mov    0x8(%ebp),%eax
8010510d:	83 c0 04             	add    $0x4,%eax
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	50                   	push   %eax
80105114:	e8 37 01 00 00       	call   80105250 <release>
80105119:	83 c4 10             	add    $0x10,%esp
}
8010511c:	90                   	nop
8010511d:	c9                   	leave  
8010511e:	c3                   	ret    

8010511f <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010511f:	f3 0f 1e fb          	endbr32 
80105123:	55                   	push   %ebp
80105124:	89 e5                	mov    %esp,%ebp
80105126:	53                   	push   %ebx
80105127:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
8010512a:	8b 45 08             	mov    0x8(%ebp),%eax
8010512d:	83 c0 04             	add    $0x4,%eax
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	50                   	push   %eax
80105134:	e8 a5 00 00 00       	call   801051de <acquire>
80105139:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
8010513c:	8b 45 08             	mov    0x8(%ebp),%eax
8010513f:	8b 00                	mov    (%eax),%eax
80105141:	85 c0                	test   %eax,%eax
80105143:	74 19                	je     8010515e <holdingsleep+0x3f>
80105145:	8b 45 08             	mov    0x8(%ebp),%eax
80105148:	8b 58 3c             	mov    0x3c(%eax),%ebx
8010514b:	e8 4c f3 ff ff       	call   8010449c <myproc>
80105150:	8b 40 10             	mov    0x10(%eax),%eax
80105153:	39 c3                	cmp    %eax,%ebx
80105155:	75 07                	jne    8010515e <holdingsleep+0x3f>
80105157:	b8 01 00 00 00       	mov    $0x1,%eax
8010515c:	eb 05                	jmp    80105163 <holdingsleep+0x44>
8010515e:	b8 00 00 00 00       	mov    $0x0,%eax
80105163:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80105166:	8b 45 08             	mov    0x8(%ebp),%eax
80105169:	83 c0 04             	add    $0x4,%eax
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	50                   	push   %eax
80105170:	e8 db 00 00 00       	call   80105250 <release>
80105175:	83 c4 10             	add    $0x10,%esp
  return r;
80105178:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010517b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010517e:	c9                   	leave  
8010517f:	c3                   	ret    

80105180 <readeflags>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105186:	9c                   	pushf  
80105187:	58                   	pop    %eax
80105188:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010518b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010518e:	c9                   	leave  
8010518f:	c3                   	ret    

80105190 <cli>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105193:	fa                   	cli    
}
80105194:	90                   	nop
80105195:	5d                   	pop    %ebp
80105196:	c3                   	ret    

80105197 <sti>:
{
80105197:	55                   	push   %ebp
80105198:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010519a:	fb                   	sti    
}
8010519b:	90                   	nop
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    

8010519e <xchg>:
{
8010519e:	55                   	push   %ebp
8010519f:	89 e5                	mov    %esp,%ebp
801051a1:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801051a4:	8b 55 08             	mov    0x8(%ebp),%edx
801051a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801051aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051ad:	f0 87 02             	lock xchg %eax,(%edx)
801051b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801051b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051b6:	c9                   	leave  
801051b7:	c3                   	ret    

801051b8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801051b8:	f3 0f 1e fb          	endbr32 
801051bc:	55                   	push   %ebp
801051bd:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801051bf:	8b 45 08             	mov    0x8(%ebp),%eax
801051c2:	8b 55 0c             	mov    0xc(%ebp),%edx
801051c5:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801051c8:	8b 45 08             	mov    0x8(%ebp),%eax
801051cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801051d1:	8b 45 08             	mov    0x8(%ebp),%eax
801051d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801051db:	90                   	nop
801051dc:	5d                   	pop    %ebp
801051dd:	c3                   	ret    

801051de <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801051de:	f3 0f 1e fb          	endbr32 
801051e2:	55                   	push   %ebp
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	53                   	push   %ebx
801051e6:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801051e9:	e8 7c 01 00 00       	call   8010536a <pushcli>
  if(holding(lk))
801051ee:	8b 45 08             	mov    0x8(%ebp),%eax
801051f1:	83 ec 0c             	sub    $0xc,%esp
801051f4:	50                   	push   %eax
801051f5:	e8 2b 01 00 00       	call   80105325 <holding>
801051fa:	83 c4 10             	add    $0x10,%esp
801051fd:	85 c0                	test   %eax,%eax
801051ff:	74 0d                	je     8010520e <acquire+0x30>
    panic("acquire");
80105201:	83 ec 0c             	sub    $0xc,%esp
80105204:	68 36 8b 10 80       	push   $0x80108b36
80105209:	e8 c3 b3 ff ff       	call   801005d1 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010520e:	90                   	nop
8010520f:	8b 45 08             	mov    0x8(%ebp),%eax
80105212:	83 ec 08             	sub    $0x8,%esp
80105215:	6a 01                	push   $0x1
80105217:	50                   	push   %eax
80105218:	e8 81 ff ff ff       	call   8010519e <xchg>
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	85 c0                	test   %eax,%eax
80105222:	75 eb                	jne    8010520f <acquire+0x31>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80105224:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105229:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010522c:	e8 ef f1 ff ff       	call   80104420 <mycpu>
80105231:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80105234:	8b 45 08             	mov    0x8(%ebp),%eax
80105237:	83 c0 0c             	add    $0xc,%eax
8010523a:	83 ec 08             	sub    $0x8,%esp
8010523d:	50                   	push   %eax
8010523e:	8d 45 08             	lea    0x8(%ebp),%eax
80105241:	50                   	push   %eax
80105242:	e8 5f 00 00 00       	call   801052a6 <getcallerpcs>
80105247:	83 c4 10             	add    $0x10,%esp
}
8010524a:	90                   	nop
8010524b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010524e:	c9                   	leave  
8010524f:	c3                   	ret    

80105250 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010525a:	83 ec 0c             	sub    $0xc,%esp
8010525d:	ff 75 08             	pushl  0x8(%ebp)
80105260:	e8 c0 00 00 00       	call   80105325 <holding>
80105265:	83 c4 10             	add    $0x10,%esp
80105268:	85 c0                	test   %eax,%eax
8010526a:	75 0d                	jne    80105279 <release+0x29>
    panic("release");
8010526c:	83 ec 0c             	sub    $0xc,%esp
8010526f:	68 3e 8b 10 80       	push   $0x80108b3e
80105274:	e8 58 b3 ff ff       	call   801005d1 <panic>

  lk->pcs[0] = 0;
80105279:	8b 45 08             	mov    0x8(%ebp),%eax
8010527c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105283:	8b 45 08             	mov    0x8(%ebp),%eax
80105286:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010528d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105292:	8b 45 08             	mov    0x8(%ebp),%eax
80105295:	8b 55 08             	mov    0x8(%ebp),%edx
80105298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
8010529e:	e8 18 01 00 00       	call   801053bb <popcli>
}
801052a3:	90                   	nop
801052a4:	c9                   	leave  
801052a5:	c3                   	ret    

801052a6 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801052a6:	f3 0f 1e fb          	endbr32 
801052aa:	55                   	push   %ebp
801052ab:	89 e5                	mov    %esp,%ebp
801052ad:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801052b0:	8b 45 08             	mov    0x8(%ebp),%eax
801052b3:	83 e8 08             	sub    $0x8,%eax
801052b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801052b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801052c0:	eb 38                	jmp    801052fa <getcallerpcs+0x54>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801052c6:	74 53                	je     8010531b <getcallerpcs+0x75>
801052c8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801052cf:	76 4a                	jbe    8010531b <getcallerpcs+0x75>
801052d1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801052d5:	74 44                	je     8010531b <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801052e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e4:	01 c2                	add    %eax,%edx
801052e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052e9:	8b 40 04             	mov    0x4(%eax),%eax
801052ec:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801052ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052f1:	8b 00                	mov    (%eax),%eax
801052f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801052f6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801052fa:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801052fe:	7e c2                	jle    801052c2 <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
80105300:	eb 19                	jmp    8010531b <getcallerpcs+0x75>
    pcs[i] = 0;
80105302:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010530c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010530f:	01 d0                	add    %edx,%eax
80105311:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105317:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010531b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010531f:	7e e1                	jle    80105302 <getcallerpcs+0x5c>
}
80105321:	90                   	nop
80105322:	90                   	nop
80105323:	c9                   	leave  
80105324:	c3                   	ret    

80105325 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105325:	f3 0f 1e fb          	endbr32 
80105329:	55                   	push   %ebp
8010532a:	89 e5                	mov    %esp,%ebp
8010532c:	53                   	push   %ebx
8010532d:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
80105330:	e8 35 00 00 00       	call   8010536a <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105335:	8b 45 08             	mov    0x8(%ebp),%eax
80105338:	8b 00                	mov    (%eax),%eax
8010533a:	85 c0                	test   %eax,%eax
8010533c:	74 16                	je     80105354 <holding+0x2f>
8010533e:	8b 45 08             	mov    0x8(%ebp),%eax
80105341:	8b 58 08             	mov    0x8(%eax),%ebx
80105344:	e8 d7 f0 ff ff       	call   80104420 <mycpu>
80105349:	39 c3                	cmp    %eax,%ebx
8010534b:	75 07                	jne    80105354 <holding+0x2f>
8010534d:	b8 01 00 00 00       	mov    $0x1,%eax
80105352:	eb 05                	jmp    80105359 <holding+0x34>
80105354:	b8 00 00 00 00       	mov    $0x0,%eax
80105359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010535c:	e8 5a 00 00 00       	call   801053bb <popcli>
  return r;
80105361:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105364:	83 c4 14             	add    $0x14,%esp
80105367:	5b                   	pop    %ebx
80105368:	5d                   	pop    %ebp
80105369:	c3                   	ret    

8010536a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010536a:	f3 0f 1e fb          	endbr32 
8010536e:	55                   	push   %ebp
8010536f:	89 e5                	mov    %esp,%ebp
80105371:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105374:	e8 07 fe ff ff       	call   80105180 <readeflags>
80105379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
8010537c:	e8 0f fe ff ff       	call   80105190 <cli>
  if(mycpu()->ncli == 0)
80105381:	e8 9a f0 ff ff       	call   80104420 <mycpu>
80105386:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010538c:	85 c0                	test   %eax,%eax
8010538e:	75 14                	jne    801053a4 <pushcli+0x3a>
    mycpu()->intena = eflags & FL_IF;
80105390:	e8 8b f0 ff ff       	call   80104420 <mycpu>
80105395:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105398:	81 e2 00 02 00 00    	and    $0x200,%edx
8010539e:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
801053a4:	e8 77 f0 ff ff       	call   80104420 <mycpu>
801053a9:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801053af:	83 c2 01             	add    $0x1,%edx
801053b2:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
801053b8:	90                   	nop
801053b9:	c9                   	leave  
801053ba:	c3                   	ret    

801053bb <popcli>:

void
popcli(void)
{
801053bb:	f3 0f 1e fb          	endbr32 
801053bf:	55                   	push   %ebp
801053c0:	89 e5                	mov    %esp,%ebp
801053c2:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801053c5:	e8 b6 fd ff ff       	call   80105180 <readeflags>
801053ca:	25 00 02 00 00       	and    $0x200,%eax
801053cf:	85 c0                	test   %eax,%eax
801053d1:	74 0d                	je     801053e0 <popcli+0x25>
    panic("popcli - interruptible");
801053d3:	83 ec 0c             	sub    $0xc,%esp
801053d6:	68 46 8b 10 80       	push   $0x80108b46
801053db:	e8 f1 b1 ff ff       	call   801005d1 <panic>
  if(--mycpu()->ncli < 0)
801053e0:	e8 3b f0 ff ff       	call   80104420 <mycpu>
801053e5:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801053eb:	83 ea 01             	sub    $0x1,%edx
801053ee:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801053f4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801053fa:	85 c0                	test   %eax,%eax
801053fc:	79 0d                	jns    8010540b <popcli+0x50>
    panic("popcli");
801053fe:	83 ec 0c             	sub    $0xc,%esp
80105401:	68 5d 8b 10 80       	push   $0x80108b5d
80105406:	e8 c6 b1 ff ff       	call   801005d1 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010540b:	e8 10 f0 ff ff       	call   80104420 <mycpu>
80105410:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105416:	85 c0                	test   %eax,%eax
80105418:	75 14                	jne    8010542e <popcli+0x73>
8010541a:	e8 01 f0 ff ff       	call   80104420 <mycpu>
8010541f:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105425:	85 c0                	test   %eax,%eax
80105427:	74 05                	je     8010542e <popcli+0x73>
    sti();
80105429:	e8 69 fd ff ff       	call   80105197 <sti>
}
8010542e:	90                   	nop
8010542f:	c9                   	leave  
80105430:	c3                   	ret    

80105431 <stosb>:
{
80105431:	55                   	push   %ebp
80105432:	89 e5                	mov    %esp,%ebp
80105434:	57                   	push   %edi
80105435:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105436:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105439:	8b 55 10             	mov    0x10(%ebp),%edx
8010543c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010543f:	89 cb                	mov    %ecx,%ebx
80105441:	89 df                	mov    %ebx,%edi
80105443:	89 d1                	mov    %edx,%ecx
80105445:	fc                   	cld    
80105446:	f3 aa                	rep stos %al,%es:(%edi)
80105448:	89 ca                	mov    %ecx,%edx
8010544a:	89 fb                	mov    %edi,%ebx
8010544c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010544f:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105452:	90                   	nop
80105453:	5b                   	pop    %ebx
80105454:	5f                   	pop    %edi
80105455:	5d                   	pop    %ebp
80105456:	c3                   	ret    

80105457 <stosl>:
{
80105457:	55                   	push   %ebp
80105458:	89 e5                	mov    %esp,%ebp
8010545a:	57                   	push   %edi
8010545b:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010545c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010545f:	8b 55 10             	mov    0x10(%ebp),%edx
80105462:	8b 45 0c             	mov    0xc(%ebp),%eax
80105465:	89 cb                	mov    %ecx,%ebx
80105467:	89 df                	mov    %ebx,%edi
80105469:	89 d1                	mov    %edx,%ecx
8010546b:	fc                   	cld    
8010546c:	f3 ab                	rep stos %eax,%es:(%edi)
8010546e:	89 ca                	mov    %ecx,%edx
80105470:	89 fb                	mov    %edi,%ebx
80105472:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105475:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105478:	90                   	nop
80105479:	5b                   	pop    %ebx
8010547a:	5f                   	pop    %edi
8010547b:	5d                   	pop    %ebp
8010547c:	c3                   	ret    

8010547d <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010547d:	f3 0f 1e fb          	endbr32 
80105481:	55                   	push   %ebp
80105482:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105484:	8b 45 08             	mov    0x8(%ebp),%eax
80105487:	83 e0 03             	and    $0x3,%eax
8010548a:	85 c0                	test   %eax,%eax
8010548c:	75 43                	jne    801054d1 <memset+0x54>
8010548e:	8b 45 10             	mov    0x10(%ebp),%eax
80105491:	83 e0 03             	and    $0x3,%eax
80105494:	85 c0                	test   %eax,%eax
80105496:	75 39                	jne    801054d1 <memset+0x54>
    c &= 0xFF;
80105498:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010549f:	8b 45 10             	mov    0x10(%ebp),%eax
801054a2:	c1 e8 02             	shr    $0x2,%eax
801054a5:	89 c1                	mov    %eax,%ecx
801054a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054aa:	c1 e0 18             	shl    $0x18,%eax
801054ad:	89 c2                	mov    %eax,%edx
801054af:	8b 45 0c             	mov    0xc(%ebp),%eax
801054b2:	c1 e0 10             	shl    $0x10,%eax
801054b5:	09 c2                	or     %eax,%edx
801054b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ba:	c1 e0 08             	shl    $0x8,%eax
801054bd:	09 d0                	or     %edx,%eax
801054bf:	0b 45 0c             	or     0xc(%ebp),%eax
801054c2:	51                   	push   %ecx
801054c3:	50                   	push   %eax
801054c4:	ff 75 08             	pushl  0x8(%ebp)
801054c7:	e8 8b ff ff ff       	call   80105457 <stosl>
801054cc:	83 c4 0c             	add    $0xc,%esp
801054cf:	eb 12                	jmp    801054e3 <memset+0x66>
  } else
    stosb(dst, c, n);
801054d1:	8b 45 10             	mov    0x10(%ebp),%eax
801054d4:	50                   	push   %eax
801054d5:	ff 75 0c             	pushl  0xc(%ebp)
801054d8:	ff 75 08             	pushl  0x8(%ebp)
801054db:	e8 51 ff ff ff       	call   80105431 <stosb>
801054e0:	83 c4 0c             	add    $0xc,%esp
  return dst;
801054e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801054e6:	c9                   	leave  
801054e7:	c3                   	ret    

801054e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801054e8:	f3 0f 1e fb          	endbr32 
801054ec:	55                   	push   %ebp
801054ed:	89 e5                	mov    %esp,%ebp
801054ef:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801054f2:	8b 45 08             	mov    0x8(%ebp),%eax
801054f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801054f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801054fe:	eb 30                	jmp    80105530 <memcmp+0x48>
    if(*s1 != *s2)
80105500:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105503:	0f b6 10             	movzbl (%eax),%edx
80105506:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105509:	0f b6 00             	movzbl (%eax),%eax
8010550c:	38 c2                	cmp    %al,%dl
8010550e:	74 18                	je     80105528 <memcmp+0x40>
      return *s1 - *s2;
80105510:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105513:	0f b6 00             	movzbl (%eax),%eax
80105516:	0f b6 d0             	movzbl %al,%edx
80105519:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010551c:	0f b6 00             	movzbl (%eax),%eax
8010551f:	0f b6 c0             	movzbl %al,%eax
80105522:	29 c2                	sub    %eax,%edx
80105524:	89 d0                	mov    %edx,%eax
80105526:	eb 1a                	jmp    80105542 <memcmp+0x5a>
    s1++, s2++;
80105528:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010552c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80105530:	8b 45 10             	mov    0x10(%ebp),%eax
80105533:	8d 50 ff             	lea    -0x1(%eax),%edx
80105536:	89 55 10             	mov    %edx,0x10(%ebp)
80105539:	85 c0                	test   %eax,%eax
8010553b:	75 c3                	jne    80105500 <memcmp+0x18>
  }

  return 0;
8010553d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105542:	c9                   	leave  
80105543:	c3                   	ret    

80105544 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105544:	f3 0f 1e fb          	endbr32 
80105548:	55                   	push   %ebp
80105549:	89 e5                	mov    %esp,%ebp
8010554b:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010554e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105554:	8b 45 08             	mov    0x8(%ebp),%eax
80105557:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010555a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010555d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105560:	73 54                	jae    801055b6 <memmove+0x72>
80105562:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105565:	8b 45 10             	mov    0x10(%ebp),%eax
80105568:	01 d0                	add    %edx,%eax
8010556a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
8010556d:	73 47                	jae    801055b6 <memmove+0x72>
    s += n;
8010556f:	8b 45 10             	mov    0x10(%ebp),%eax
80105572:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105575:	8b 45 10             	mov    0x10(%ebp),%eax
80105578:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010557b:	eb 13                	jmp    80105590 <memmove+0x4c>
      *--d = *--s;
8010557d:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105581:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105585:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105588:	0f b6 10             	movzbl (%eax),%edx
8010558b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010558e:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105590:	8b 45 10             	mov    0x10(%ebp),%eax
80105593:	8d 50 ff             	lea    -0x1(%eax),%edx
80105596:	89 55 10             	mov    %edx,0x10(%ebp)
80105599:	85 c0                	test   %eax,%eax
8010559b:	75 e0                	jne    8010557d <memmove+0x39>
  if(s < d && s + n > d){
8010559d:	eb 24                	jmp    801055c3 <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
8010559f:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055a2:	8d 42 01             	lea    0x1(%edx),%eax
801055a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
801055a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055ab:	8d 48 01             	lea    0x1(%eax),%ecx
801055ae:	89 4d f8             	mov    %ecx,-0x8(%ebp)
801055b1:	0f b6 12             	movzbl (%edx),%edx
801055b4:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801055b6:	8b 45 10             	mov    0x10(%ebp),%eax
801055b9:	8d 50 ff             	lea    -0x1(%eax),%edx
801055bc:	89 55 10             	mov    %edx,0x10(%ebp)
801055bf:	85 c0                	test   %eax,%eax
801055c1:	75 dc                	jne    8010559f <memmove+0x5b>

  return dst;
801055c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801055c6:	c9                   	leave  
801055c7:	c3                   	ret    

801055c8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801055c8:	f3 0f 1e fb          	endbr32 
801055cc:	55                   	push   %ebp
801055cd:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801055cf:	ff 75 10             	pushl  0x10(%ebp)
801055d2:	ff 75 0c             	pushl  0xc(%ebp)
801055d5:	ff 75 08             	pushl  0x8(%ebp)
801055d8:	e8 67 ff ff ff       	call   80105544 <memmove>
801055dd:	83 c4 0c             	add    $0xc,%esp
}
801055e0:	c9                   	leave  
801055e1:	c3                   	ret    

801055e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801055e2:	f3 0f 1e fb          	endbr32 
801055e6:	55                   	push   %ebp
801055e7:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801055e9:	eb 0c                	jmp    801055f7 <strncmp+0x15>
    n--, p++, q++;
801055eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801055ef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801055f3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801055f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055fb:	74 1a                	je     80105617 <strncmp+0x35>
801055fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105600:	0f b6 00             	movzbl (%eax),%eax
80105603:	84 c0                	test   %al,%al
80105605:	74 10                	je     80105617 <strncmp+0x35>
80105607:	8b 45 08             	mov    0x8(%ebp),%eax
8010560a:	0f b6 10             	movzbl (%eax),%edx
8010560d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105610:	0f b6 00             	movzbl (%eax),%eax
80105613:	38 c2                	cmp    %al,%dl
80105615:	74 d4                	je     801055eb <strncmp+0x9>
  if(n == 0)
80105617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010561b:	75 07                	jne    80105624 <strncmp+0x42>
    return 0;
8010561d:	b8 00 00 00 00       	mov    $0x0,%eax
80105622:	eb 16                	jmp    8010563a <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
80105624:	8b 45 08             	mov    0x8(%ebp),%eax
80105627:	0f b6 00             	movzbl (%eax),%eax
8010562a:	0f b6 d0             	movzbl %al,%edx
8010562d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105630:	0f b6 00             	movzbl (%eax),%eax
80105633:	0f b6 c0             	movzbl %al,%eax
80105636:	29 c2                	sub    %eax,%edx
80105638:	89 d0                	mov    %edx,%eax
}
8010563a:	5d                   	pop    %ebp
8010563b:	c3                   	ret    

8010563c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010563c:	f3 0f 1e fb          	endbr32 
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105646:	8b 45 08             	mov    0x8(%ebp),%eax
80105649:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010564c:	90                   	nop
8010564d:	8b 45 10             	mov    0x10(%ebp),%eax
80105650:	8d 50 ff             	lea    -0x1(%eax),%edx
80105653:	89 55 10             	mov    %edx,0x10(%ebp)
80105656:	85 c0                	test   %eax,%eax
80105658:	7e 2c                	jle    80105686 <strncpy+0x4a>
8010565a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010565d:	8d 42 01             	lea    0x1(%edx),%eax
80105660:	89 45 0c             	mov    %eax,0xc(%ebp)
80105663:	8b 45 08             	mov    0x8(%ebp),%eax
80105666:	8d 48 01             	lea    0x1(%eax),%ecx
80105669:	89 4d 08             	mov    %ecx,0x8(%ebp)
8010566c:	0f b6 12             	movzbl (%edx),%edx
8010566f:	88 10                	mov    %dl,(%eax)
80105671:	0f b6 00             	movzbl (%eax),%eax
80105674:	84 c0                	test   %al,%al
80105676:	75 d5                	jne    8010564d <strncpy+0x11>
    ;
  while(n-- > 0)
80105678:	eb 0c                	jmp    80105686 <strncpy+0x4a>
    *s++ = 0;
8010567a:	8b 45 08             	mov    0x8(%ebp),%eax
8010567d:	8d 50 01             	lea    0x1(%eax),%edx
80105680:	89 55 08             	mov    %edx,0x8(%ebp)
80105683:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105686:	8b 45 10             	mov    0x10(%ebp),%eax
80105689:	8d 50 ff             	lea    -0x1(%eax),%edx
8010568c:	89 55 10             	mov    %edx,0x10(%ebp)
8010568f:	85 c0                	test   %eax,%eax
80105691:	7f e7                	jg     8010567a <strncpy+0x3e>
  return os;
80105693:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105696:	c9                   	leave  
80105697:	c3                   	ret    

80105698 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105698:	f3 0f 1e fb          	endbr32 
8010569c:	55                   	push   %ebp
8010569d:	89 e5                	mov    %esp,%ebp
8010569f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801056a2:	8b 45 08             	mov    0x8(%ebp),%eax
801056a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801056a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056ac:	7f 05                	jg     801056b3 <safestrcpy+0x1b>
    return os;
801056ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b1:	eb 31                	jmp    801056e4 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
801056b3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056bb:	7e 1e                	jle    801056db <safestrcpy+0x43>
801056bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801056c0:	8d 42 01             	lea    0x1(%edx),%eax
801056c3:	89 45 0c             	mov    %eax,0xc(%ebp)
801056c6:	8b 45 08             	mov    0x8(%ebp),%eax
801056c9:	8d 48 01             	lea    0x1(%eax),%ecx
801056cc:	89 4d 08             	mov    %ecx,0x8(%ebp)
801056cf:	0f b6 12             	movzbl (%edx),%edx
801056d2:	88 10                	mov    %dl,(%eax)
801056d4:	0f b6 00             	movzbl (%eax),%eax
801056d7:	84 c0                	test   %al,%al
801056d9:	75 d8                	jne    801056b3 <safestrcpy+0x1b>
    ;
  *s = 0;
801056db:	8b 45 08             	mov    0x8(%ebp),%eax
801056de:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801056e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801056e4:	c9                   	leave  
801056e5:	c3                   	ret    

801056e6 <strlen>:

int
strlen(const char *s)
{
801056e6:	f3 0f 1e fb          	endbr32 
801056ea:	55                   	push   %ebp
801056eb:	89 e5                	mov    %esp,%ebp
801056ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801056f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056f7:	eb 04                	jmp    801056fd <strlen+0x17>
801056f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105700:	8b 45 08             	mov    0x8(%ebp),%eax
80105703:	01 d0                	add    %edx,%eax
80105705:	0f b6 00             	movzbl (%eax),%eax
80105708:	84 c0                	test   %al,%al
8010570a:	75 ed                	jne    801056f9 <strlen+0x13>
    ;
  return n;
8010570c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010570f:	c9                   	leave  
80105710:	c3                   	ret    

80105711 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105711:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105715:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105719:	55                   	push   %ebp
  pushl %ebx
8010571a:	53                   	push   %ebx
  pushl %esi
8010571b:	56                   	push   %esi
  pushl %edi
8010571c:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010571d:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010571f:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105721:	5f                   	pop    %edi
  popl %esi
80105722:	5e                   	pop    %esi
  popl %ebx
80105723:	5b                   	pop    %ebx
  popl %ebp
80105724:	5d                   	pop    %ebp
  ret
80105725:	c3                   	ret    

80105726 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105726:	f3 0f 1e fb          	endbr32 
8010572a:	55                   	push   %ebp
8010572b:	89 e5                	mov    %esp,%ebp
8010572d:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105730:	e8 67 ed ff ff       	call   8010449c <myproc>
80105735:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573b:	8b 00                	mov    (%eax),%eax
8010573d:	39 45 08             	cmp    %eax,0x8(%ebp)
80105740:	73 0f                	jae    80105751 <fetchint+0x2b>
80105742:	8b 45 08             	mov    0x8(%ebp),%eax
80105745:	8d 50 04             	lea    0x4(%eax),%edx
80105748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574b:	8b 00                	mov    (%eax),%eax
8010574d:	39 c2                	cmp    %eax,%edx
8010574f:	76 07                	jbe    80105758 <fetchint+0x32>
    return -1;
80105751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105756:	eb 0f                	jmp    80105767 <fetchint+0x41>
  *ip = *(int*)(addr);
80105758:	8b 45 08             	mov    0x8(%ebp),%eax
8010575b:	8b 10                	mov    (%eax),%edx
8010575d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105760:	89 10                	mov    %edx,(%eax)
  return 0;
80105762:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105767:	c9                   	leave  
80105768:	c3                   	ret    

80105769 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105769:	f3 0f 1e fb          	endbr32 
8010576d:	55                   	push   %ebp
8010576e:	89 e5                	mov    %esp,%ebp
80105770:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105773:	e8 24 ed ff ff       	call   8010449c <myproc>
80105778:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
8010577b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010577e:	8b 00                	mov    (%eax),%eax
80105780:	39 45 08             	cmp    %eax,0x8(%ebp)
80105783:	72 07                	jb     8010578c <fetchstr+0x23>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010578a:	eb 43                	jmp    801057cf <fetchstr+0x66>
  *pp = (char*)addr;
8010578c:	8b 55 08             	mov    0x8(%ebp),%edx
8010578f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105792:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105794:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105797:	8b 00                	mov    (%eax),%eax
80105799:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
8010579c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010579f:	8b 00                	mov    (%eax),%eax
801057a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057a4:	eb 1c                	jmp    801057c2 <fetchstr+0x59>
    if(*s == 0)
801057a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a9:	0f b6 00             	movzbl (%eax),%eax
801057ac:	84 c0                	test   %al,%al
801057ae:	75 0e                	jne    801057be <fetchstr+0x55>
      return s - *pp;
801057b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057b3:	8b 00                	mov    (%eax),%eax
801057b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057b8:	29 c2                	sub    %eax,%edx
801057ba:	89 d0                	mov    %edx,%eax
801057bc:	eb 11                	jmp    801057cf <fetchstr+0x66>
  for(s = *pp; s < ep; s++){
801057be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801057c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801057c8:	72 dc                	jb     801057a6 <fetchstr+0x3d>
  }
  return -1;
801057ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057cf:	c9                   	leave  
801057d0:	c3                   	ret    

801057d1 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801057d1:	f3 0f 1e fb          	endbr32 
801057d5:	55                   	push   %ebp
801057d6:	89 e5                	mov    %esp,%ebp
801057d8:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801057db:	e8 bc ec ff ff       	call   8010449c <myproc>
801057e0:	8b 40 18             	mov    0x18(%eax),%eax
801057e3:	8b 40 44             	mov    0x44(%eax),%eax
801057e6:	8b 55 08             	mov    0x8(%ebp),%edx
801057e9:	c1 e2 02             	shl    $0x2,%edx
801057ec:	01 d0                	add    %edx,%eax
801057ee:	83 c0 04             	add    $0x4,%eax
801057f1:	83 ec 08             	sub    $0x8,%esp
801057f4:	ff 75 0c             	pushl  0xc(%ebp)
801057f7:	50                   	push   %eax
801057f8:	e8 29 ff ff ff       	call   80105726 <fetchint>
801057fd:	83 c4 10             	add    $0x10,%esp
}
80105800:	c9                   	leave  
80105801:	c3                   	ret    

80105802 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105802:	f3 0f 1e fb          	endbr32 
80105806:	55                   	push   %ebp
80105807:	89 e5                	mov    %esp,%ebp
80105809:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
8010580c:	e8 8b ec ff ff       	call   8010449c <myproc>
80105811:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105814:	83 ec 08             	sub    $0x8,%esp
80105817:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010581a:	50                   	push   %eax
8010581b:	ff 75 08             	pushl  0x8(%ebp)
8010581e:	e8 ae ff ff ff       	call   801057d1 <argint>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	85 c0                	test   %eax,%eax
80105828:	79 07                	jns    80105831 <argptr+0x2f>
    return -1;
8010582a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582f:	eb 3b                	jmp    8010586c <argptr+0x6a>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105831:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105835:	78 1f                	js     80105856 <argptr+0x54>
80105837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583a:	8b 00                	mov    (%eax),%eax
8010583c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010583f:	39 d0                	cmp    %edx,%eax
80105841:	76 13                	jbe    80105856 <argptr+0x54>
80105843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105846:	89 c2                	mov    %eax,%edx
80105848:	8b 45 10             	mov    0x10(%ebp),%eax
8010584b:	01 c2                	add    %eax,%edx
8010584d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105850:	8b 00                	mov    (%eax),%eax
80105852:	39 c2                	cmp    %eax,%edx
80105854:	76 07                	jbe    8010585d <argptr+0x5b>
    return -1;
80105856:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585b:	eb 0f                	jmp    8010586c <argptr+0x6a>
  *pp = (char*)i;
8010585d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105860:	89 c2                	mov    %eax,%edx
80105862:	8b 45 0c             	mov    0xc(%ebp),%eax
80105865:	89 10                	mov    %edx,(%eax)
  return 0;
80105867:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010586c:	c9                   	leave  
8010586d:	c3                   	ret    

8010586e <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010586e:	f3 0f 1e fb          	endbr32 
80105872:	55                   	push   %ebp
80105873:	89 e5                	mov    %esp,%ebp
80105875:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105878:	83 ec 08             	sub    $0x8,%esp
8010587b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587e:	50                   	push   %eax
8010587f:	ff 75 08             	pushl  0x8(%ebp)
80105882:	e8 4a ff ff ff       	call   801057d1 <argint>
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	85 c0                	test   %eax,%eax
8010588c:	79 07                	jns    80105895 <argstr+0x27>
    return -1;
8010588e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105893:	eb 12                	jmp    801058a7 <argstr+0x39>
  return fetchstr(addr, pp);
80105895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105898:	83 ec 08             	sub    $0x8,%esp
8010589b:	ff 75 0c             	pushl  0xc(%ebp)
8010589e:	50                   	push   %eax
8010589f:	e8 c5 fe ff ff       	call   80105769 <fetchstr>
801058a4:	83 c4 10             	add    $0x10,%esp
}
801058a7:	c9                   	leave  
801058a8:	c3                   	ret    

801058a9 <syscall>:
[SYS_lseek]   sys_lseek,
};

void
syscall(void)
{
801058a9:	f3 0f 1e fb          	endbr32 
801058ad:	55                   	push   %ebp
801058ae:	89 e5                	mov    %esp,%ebp
801058b0:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
801058b3:	e8 e4 eb ff ff       	call   8010449c <myproc>
801058b8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801058bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058be:	8b 40 18             	mov    0x18(%eax),%eax
801058c1:	8b 40 1c             	mov    0x1c(%eax),%eax
801058c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801058c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058cb:	7e 2f                	jle    801058fc <syscall+0x53>
801058cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d0:	83 f8 16             	cmp    $0x16,%eax
801058d3:	77 27                	ja     801058fc <syscall+0x53>
801058d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d8:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801058df:	85 c0                	test   %eax,%eax
801058e1:	74 19                	je     801058fc <syscall+0x53>
    curproc->tf->eax = syscalls[num]();
801058e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e6:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801058ed:	ff d0                	call   *%eax
801058ef:	89 c2                	mov    %eax,%edx
801058f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f4:	8b 40 18             	mov    0x18(%eax),%eax
801058f7:	89 50 1c             	mov    %edx,0x1c(%eax)
801058fa:	eb 2c                	jmp    80105928 <syscall+0x7f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801058fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ff:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105905:	8b 40 10             	mov    0x10(%eax),%eax
80105908:	ff 75 f0             	pushl  -0x10(%ebp)
8010590b:	52                   	push   %edx
8010590c:	50                   	push   %eax
8010590d:	68 64 8b 10 80       	push   $0x80108b64
80105912:	e8 01 ab ff ff       	call   80100418 <cprintf>
80105917:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
8010591a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591d:	8b 40 18             	mov    0x18(%eax),%eax
80105920:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105927:	90                   	nop
80105928:	90                   	nop
80105929:	c9                   	leave  
8010592a:	c3                   	ret    

8010592b <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010592b:	f3 0f 1e fb          	endbr32 
8010592f:	55                   	push   %ebp
80105930:	89 e5                	mov    %esp,%ebp
80105932:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105935:	83 ec 08             	sub    $0x8,%esp
80105938:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010593b:	50                   	push   %eax
8010593c:	ff 75 08             	pushl  0x8(%ebp)
8010593f:	e8 8d fe ff ff       	call   801057d1 <argint>
80105944:	83 c4 10             	add    $0x10,%esp
80105947:	85 c0                	test   %eax,%eax
80105949:	79 07                	jns    80105952 <argfd+0x27>
    return -1;
8010594b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105950:	eb 4f                	jmp    801059a1 <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105952:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105955:	85 c0                	test   %eax,%eax
80105957:	78 20                	js     80105979 <argfd+0x4e>
80105959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595c:	83 f8 0f             	cmp    $0xf,%eax
8010595f:	7f 18                	jg     80105979 <argfd+0x4e>
80105961:	e8 36 eb ff ff       	call   8010449c <myproc>
80105966:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105969:	83 c2 08             	add    $0x8,%edx
8010596c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105970:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105977:	75 07                	jne    80105980 <argfd+0x55>
    return -1;
80105979:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597e:	eb 21                	jmp    801059a1 <argfd+0x76>
  if(pfd)
80105980:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105984:	74 08                	je     8010598e <argfd+0x63>
    *pfd = fd;
80105986:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105989:	8b 45 0c             	mov    0xc(%ebp),%eax
8010598c:	89 10                	mov    %edx,(%eax)
  if(pf)
8010598e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105992:	74 08                	je     8010599c <argfd+0x71>
    *pf = f;
80105994:	8b 45 10             	mov    0x10(%ebp),%eax
80105997:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010599a:	89 10                	mov    %edx,(%eax)
  return 0;
8010599c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059a1:	c9                   	leave  
801059a2:	c3                   	ret    

801059a3 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801059a3:	f3 0f 1e fb          	endbr32 
801059a7:	55                   	push   %ebp
801059a8:	89 e5                	mov    %esp,%ebp
801059aa:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801059ad:	e8 ea ea ff ff       	call   8010449c <myproc>
801059b2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801059b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801059bc:	eb 2a                	jmp    801059e8 <fdalloc+0x45>
    if(curproc->ofile[fd] == 0){
801059be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059c4:	83 c2 08             	add    $0x8,%edx
801059c7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059cb:	85 c0                	test   %eax,%eax
801059cd:	75 15                	jne    801059e4 <fdalloc+0x41>
      curproc->ofile[fd] = f;
801059cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059d5:	8d 4a 08             	lea    0x8(%edx),%ecx
801059d8:	8b 55 08             	mov    0x8(%ebp),%edx
801059db:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801059df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e2:	eb 0f                	jmp    801059f3 <fdalloc+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801059e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801059e8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059ec:	7e d0                	jle    801059be <fdalloc+0x1b>
    }
  }
  return -1;
801059ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f3:	c9                   	leave  
801059f4:	c3                   	ret    

801059f5 <sys_dup>:

int
sys_dup(void)
{
801059f5:	f3 0f 1e fb          	endbr32 
801059f9:	55                   	push   %ebp
801059fa:	89 e5                	mov    %esp,%ebp
801059fc:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801059ff:	83 ec 04             	sub    $0x4,%esp
80105a02:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a05:	50                   	push   %eax
80105a06:	6a 00                	push   $0x0
80105a08:	6a 00                	push   $0x0
80105a0a:	e8 1c ff ff ff       	call   8010592b <argfd>
80105a0f:	83 c4 10             	add    $0x10,%esp
80105a12:	85 c0                	test   %eax,%eax
80105a14:	79 07                	jns    80105a1d <sys_dup+0x28>
    return -1;
80105a16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1b:	eb 31                	jmp    80105a4e <sys_dup+0x59>
  if((fd=fdalloc(f)) < 0)
80105a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	50                   	push   %eax
80105a24:	e8 7a ff ff ff       	call   801059a3 <fdalloc>
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a33:	79 07                	jns    80105a3c <sys_dup+0x47>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb 12                	jmp    80105a4e <sys_dup+0x59>
  filedup(f);
80105a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3f:	83 ec 0c             	sub    $0xc,%esp
80105a42:	50                   	push   %eax
80105a43:	e8 87 b6 ff ff       	call   801010cf <filedup>
80105a48:	83 c4 10             	add    $0x10,%esp
  return fd;
80105a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    

80105a50 <sys_read>:

int
sys_read(void)
{
80105a50:	f3 0f 1e fb          	endbr32 
80105a54:	55                   	push   %ebp
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a5a:	83 ec 04             	sub    $0x4,%esp
80105a5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a60:	50                   	push   %eax
80105a61:	6a 00                	push   $0x0
80105a63:	6a 00                	push   $0x0
80105a65:	e8 c1 fe ff ff       	call   8010592b <argfd>
80105a6a:	83 c4 10             	add    $0x10,%esp
80105a6d:	85 c0                	test   %eax,%eax
80105a6f:	78 2e                	js     80105a9f <sys_read+0x4f>
80105a71:	83 ec 08             	sub    $0x8,%esp
80105a74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a77:	50                   	push   %eax
80105a78:	6a 02                	push   $0x2
80105a7a:	e8 52 fd ff ff       	call   801057d1 <argint>
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	85 c0                	test   %eax,%eax
80105a84:	78 19                	js     80105a9f <sys_read+0x4f>
80105a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a89:	83 ec 04             	sub    $0x4,%esp
80105a8c:	50                   	push   %eax
80105a8d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a90:	50                   	push   %eax
80105a91:	6a 01                	push   $0x1
80105a93:	e8 6a fd ff ff       	call   80105802 <argptr>
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	85 c0                	test   %eax,%eax
80105a9d:	79 07                	jns    80105aa6 <sys_read+0x56>
    return -1;
80105a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa4:	eb 17                	jmp    80105abd <sys_read+0x6d>
  return fileread(f, p, n);
80105aa6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105aa9:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aaf:	83 ec 04             	sub    $0x4,%esp
80105ab2:	51                   	push   %ecx
80105ab3:	52                   	push   %edx
80105ab4:	50                   	push   %eax
80105ab5:	e8 b1 b7 ff ff       	call   8010126b <fileread>
80105aba:	83 c4 10             	add    $0x10,%esp
}
80105abd:	c9                   	leave  
80105abe:	c3                   	ret    

80105abf <sys_write>:

int
sys_write(void)
{
80105abf:	f3 0f 1e fb          	endbr32 
80105ac3:	55                   	push   %ebp
80105ac4:	89 e5                	mov    %esp,%ebp
80105ac6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ac9:	83 ec 04             	sub    $0x4,%esp
80105acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105acf:	50                   	push   %eax
80105ad0:	6a 00                	push   $0x0
80105ad2:	6a 00                	push   $0x0
80105ad4:	e8 52 fe ff ff       	call   8010592b <argfd>
80105ad9:	83 c4 10             	add    $0x10,%esp
80105adc:	85 c0                	test   %eax,%eax
80105ade:	78 2e                	js     80105b0e <sys_write+0x4f>
80105ae0:	83 ec 08             	sub    $0x8,%esp
80105ae3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ae6:	50                   	push   %eax
80105ae7:	6a 02                	push   $0x2
80105ae9:	e8 e3 fc ff ff       	call   801057d1 <argint>
80105aee:	83 c4 10             	add    $0x10,%esp
80105af1:	85 c0                	test   %eax,%eax
80105af3:	78 19                	js     80105b0e <sys_write+0x4f>
80105af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af8:	83 ec 04             	sub    $0x4,%esp
80105afb:	50                   	push   %eax
80105afc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aff:	50                   	push   %eax
80105b00:	6a 01                	push   $0x1
80105b02:	e8 fb fc ff ff       	call   80105802 <argptr>
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	79 07                	jns    80105b15 <sys_write+0x56>
    return -1;
80105b0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b13:	eb 17                	jmp    80105b2c <sys_write+0x6d>
  return filewrite(f, p, n);
80105b15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b18:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1e:	83 ec 04             	sub    $0x4,%esp
80105b21:	51                   	push   %ecx
80105b22:	52                   	push   %edx
80105b23:	50                   	push   %eax
80105b24:	e8 fe b7 ff ff       	call   80101327 <filewrite>
80105b29:	83 c4 10             	add    $0x10,%esp
}
80105b2c:	c9                   	leave  
80105b2d:	c3                   	ret    

80105b2e <sys_close>:

int
sys_close(void)
{
80105b2e:	f3 0f 1e fb          	endbr32 
80105b32:	55                   	push   %ebp
80105b33:	89 e5                	mov    %esp,%ebp
80105b35:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105b38:	83 ec 04             	sub    $0x4,%esp
80105b3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b3e:	50                   	push   %eax
80105b3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b42:	50                   	push   %eax
80105b43:	6a 00                	push   $0x0
80105b45:	e8 e1 fd ff ff       	call   8010592b <argfd>
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	79 07                	jns    80105b58 <sys_close+0x2a>
    return -1;
80105b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b56:	eb 27                	jmp    80105b7f <sys_close+0x51>
  myproc()->ofile[fd] = 0;
80105b58:	e8 3f e9 ff ff       	call   8010449c <myproc>
80105b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b60:	83 c2 08             	add    $0x8,%edx
80105b63:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105b6a:	00 
  fileclose(f);
80105b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6e:	83 ec 0c             	sub    $0xc,%esp
80105b71:	50                   	push   %eax
80105b72:	e8 ad b5 ff ff       	call   80101124 <fileclose>
80105b77:	83 c4 10             	add    $0x10,%esp
  return 0;
80105b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b7f:	c9                   	leave  
80105b80:	c3                   	ret    

80105b81 <sys_lseek>:


// ajout de lseek par moi meme
int
sys_lseek(void)
{
80105b81:	f3 0f 1e fb          	endbr32 
80105b85:	55                   	push   %ebp
80105b86:	89 e5                	mov    %esp,%ebp
80105b88:	83 ec 18             	sub    $0x18,%esp
  uint offset;
  int whence;
  struct file *f;

  if(argfd(0, 0, &f) < 0 || argint(1, (int*)&offset) < 0 || argint(2, &whence) < 0)
80105b8b:	83 ec 04             	sub    $0x4,%esp
80105b8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b91:	50                   	push   %eax
80105b92:	6a 00                	push   $0x0
80105b94:	6a 00                	push   $0x0
80105b96:	e8 90 fd ff ff       	call   8010592b <argfd>
80105b9b:	83 c4 10             	add    $0x10,%esp
80105b9e:	85 c0                	test   %eax,%eax
80105ba0:	78 2a                	js     80105bcc <sys_lseek+0x4b>
80105ba2:	83 ec 08             	sub    $0x8,%esp
80105ba5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ba8:	50                   	push   %eax
80105ba9:	6a 01                	push   $0x1
80105bab:	e8 21 fc ff ff       	call   801057d1 <argint>
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	85 c0                	test   %eax,%eax
80105bb5:	78 15                	js     80105bcc <sys_lseek+0x4b>
80105bb7:	83 ec 08             	sub    $0x8,%esp
80105bba:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bbd:	50                   	push   %eax
80105bbe:	6a 02                	push   $0x2
80105bc0:	e8 0c fc ff ff       	call   801057d1 <argint>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	79 07                	jns    80105bd3 <sys_lseek+0x52>
    return -1;
80105bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd1:	eb 17                	jmp    80105bea <sys_lseek+0x69>
  
  return filelseek(f ,offset ,whence);
80105bd3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105bdc:	83 ec 04             	sub    $0x4,%esp
80105bdf:	51                   	push   %ecx
80105be0:	52                   	push   %edx
80105be1:	50                   	push   %eax
80105be2:	e8 80 b8 ff ff       	call   80101467 <filelseek>
80105be7:	83 c4 10             	add    $0x10,%esp

}
80105bea:	c9                   	leave  
80105beb:	c3                   	ret    

80105bec <sys_fstat>:


int
sys_fstat(void)
{
80105bec:	f3 0f 1e fb          	endbr32 
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105bf6:	83 ec 04             	sub    $0x4,%esp
80105bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bfc:	50                   	push   %eax
80105bfd:	6a 00                	push   $0x0
80105bff:	6a 00                	push   $0x0
80105c01:	e8 25 fd ff ff       	call   8010592b <argfd>
80105c06:	83 c4 10             	add    $0x10,%esp
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	78 17                	js     80105c24 <sys_fstat+0x38>
80105c0d:	83 ec 04             	sub    $0x4,%esp
80105c10:	6a 14                	push   $0x14
80105c12:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c15:	50                   	push   %eax
80105c16:	6a 01                	push   $0x1
80105c18:	e8 e5 fb ff ff       	call   80105802 <argptr>
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	85 c0                	test   %eax,%eax
80105c22:	79 07                	jns    80105c2b <sys_fstat+0x3f>
    return -1;
80105c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c29:	eb 13                	jmp    80105c3e <sys_fstat+0x52>
  return filestat(f, st);
80105c2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c31:	83 ec 08             	sub    $0x8,%esp
80105c34:	52                   	push   %edx
80105c35:	50                   	push   %eax
80105c36:	e8 d5 b5 ff ff       	call   80101210 <filestat>
80105c3b:	83 c4 10             	add    $0x10,%esp
}
80105c3e:	c9                   	leave  
80105c3f:	c3                   	ret    

80105c40 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c4a:	83 ec 08             	sub    $0x8,%esp
80105c4d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c50:	50                   	push   %eax
80105c51:	6a 00                	push   $0x0
80105c53:	e8 16 fc ff ff       	call   8010586e <argstr>
80105c58:	83 c4 10             	add    $0x10,%esp
80105c5b:	85 c0                	test   %eax,%eax
80105c5d:	78 15                	js     80105c74 <sys_link+0x34>
80105c5f:	83 ec 08             	sub    $0x8,%esp
80105c62:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105c65:	50                   	push   %eax
80105c66:	6a 01                	push   $0x1
80105c68:	e8 01 fc ff ff       	call   8010586e <argstr>
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	85 c0                	test   %eax,%eax
80105c72:	79 0a                	jns    80105c7e <sys_link+0x3e>
    return -1;
80105c74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c79:	e9 68 01 00 00       	jmp    80105de6 <sys_link+0x1a6>

  begin_op();
80105c7e:	e8 5a da ff ff       	call   801036dd <begin_op>
  if((ip = namei(old)) == 0){
80105c83:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105c86:	83 ec 0c             	sub    $0xc,%esp
80105c89:	50                   	push   %eax
80105c8a:	e8 ea c9 ff ff       	call   80102679 <namei>
80105c8f:	83 c4 10             	add    $0x10,%esp
80105c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c99:	75 0f                	jne    80105caa <sys_link+0x6a>
    end_op();
80105c9b:	e8 cd da ff ff       	call   8010376d <end_op>
    return -1;
80105ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca5:	e9 3c 01 00 00       	jmp    80105de6 <sys_link+0x1a6>
  }

  ilock(ip);
80105caa:	83 ec 0c             	sub    $0xc,%esp
80105cad:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb0:	e8 59 be ff ff       	call   80101b0e <ilock>
80105cb5:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbb:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105cbf:	66 83 f8 01          	cmp    $0x1,%ax
80105cc3:	75 1d                	jne    80105ce2 <sys_link+0xa2>
    iunlockput(ip);
80105cc5:	83 ec 0c             	sub    $0xc,%esp
80105cc8:	ff 75 f4             	pushl  -0xc(%ebp)
80105ccb:	e8 7b c0 ff ff       	call   80101d4b <iunlockput>
80105cd0:	83 c4 10             	add    $0x10,%esp
    end_op();
80105cd3:	e8 95 da ff ff       	call   8010376d <end_op>
    return -1;
80105cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdd:	e9 04 01 00 00       	jmp    80105de6 <sys_link+0x1a6>
  }

  ip->nlink++;
80105ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce5:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ce9:	83 c0 01             	add    $0x1,%eax
80105cec:	89 c2                	mov    %eax,%edx
80105cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf1:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105cf5:	83 ec 0c             	sub    $0xc,%esp
80105cf8:	ff 75 f4             	pushl  -0xc(%ebp)
80105cfb:	e8 25 bc ff ff       	call   80101925 <iupdate>
80105d00:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105d03:	83 ec 0c             	sub    $0xc,%esp
80105d06:	ff 75 f4             	pushl  -0xc(%ebp)
80105d09:	e8 17 bf ff ff       	call   80101c25 <iunlock>
80105d0e:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105d11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d14:	83 ec 08             	sub    $0x8,%esp
80105d17:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105d1a:	52                   	push   %edx
80105d1b:	50                   	push   %eax
80105d1c:	e8 78 c9 ff ff       	call   80102699 <nameiparent>
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d2b:	74 71                	je     80105d9e <sys_link+0x15e>
    goto bad;
  ilock(dp);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	ff 75 f0             	pushl  -0x10(%ebp)
80105d33:	e8 d6 bd ff ff       	call   80101b0e <ilock>
80105d38:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d3e:	8b 10                	mov    (%eax),%edx
80105d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d43:	8b 00                	mov    (%eax),%eax
80105d45:	39 c2                	cmp    %eax,%edx
80105d47:	75 1d                	jne    80105d66 <sys_link+0x126>
80105d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4c:	8b 40 04             	mov    0x4(%eax),%eax
80105d4f:	83 ec 04             	sub    $0x4,%esp
80105d52:	50                   	push   %eax
80105d53:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105d56:	50                   	push   %eax
80105d57:	ff 75 f0             	pushl  -0x10(%ebp)
80105d5a:	e8 77 c6 ff ff       	call   801023d6 <dirlink>
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	85 c0                	test   %eax,%eax
80105d64:	79 10                	jns    80105d76 <sys_link+0x136>
    iunlockput(dp);
80105d66:	83 ec 0c             	sub    $0xc,%esp
80105d69:	ff 75 f0             	pushl  -0x10(%ebp)
80105d6c:	e8 da bf ff ff       	call   80101d4b <iunlockput>
80105d71:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d74:	eb 29                	jmp    80105d9f <sys_link+0x15f>
  }
  iunlockput(dp);
80105d76:	83 ec 0c             	sub    $0xc,%esp
80105d79:	ff 75 f0             	pushl  -0x10(%ebp)
80105d7c:	e8 ca bf ff ff       	call   80101d4b <iunlockput>
80105d81:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105d84:	83 ec 0c             	sub    $0xc,%esp
80105d87:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8a:	e8 e8 be ff ff       	call   80101c77 <iput>
80105d8f:	83 c4 10             	add    $0x10,%esp

  end_op();
80105d92:	e8 d6 d9 ff ff       	call   8010376d <end_op>

  return 0;
80105d97:	b8 00 00 00 00       	mov    $0x0,%eax
80105d9c:	eb 48                	jmp    80105de6 <sys_link+0x1a6>
    goto bad;
80105d9e:	90                   	nop

bad:
  ilock(ip);
80105d9f:	83 ec 0c             	sub    $0xc,%esp
80105da2:	ff 75 f4             	pushl  -0xc(%ebp)
80105da5:	e8 64 bd ff ff       	call   80101b0e <ilock>
80105daa:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105db4:	83 e8 01             	sub    $0x1,%eax
80105db7:	89 c2                	mov    %eax,%edx
80105db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbc:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	ff 75 f4             	pushl  -0xc(%ebp)
80105dc6:	e8 5a bb ff ff       	call   80101925 <iupdate>
80105dcb:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105dce:	83 ec 0c             	sub    $0xc,%esp
80105dd1:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd4:	e8 72 bf ff ff       	call   80101d4b <iunlockput>
80105dd9:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ddc:	e8 8c d9 ff ff       	call   8010376d <end_op>
  return -1;
80105de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105de6:	c9                   	leave  
80105de7:	c3                   	ret    

80105de8 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105de8:	f3 0f 1e fb          	endbr32 
80105dec:	55                   	push   %ebp
80105ded:	89 e5                	mov    %esp,%ebp
80105def:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105df2:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105df9:	eb 40                	jmp    80105e3b <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfe:	6a 10                	push   $0x10
80105e00:	50                   	push   %eax
80105e01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e04:	50                   	push   %eax
80105e05:	ff 75 08             	pushl  0x8(%ebp)
80105e08:	e8 09 c2 ff ff       	call   80102016 <readi>
80105e0d:	83 c4 10             	add    $0x10,%esp
80105e10:	83 f8 10             	cmp    $0x10,%eax
80105e13:	74 0d                	je     80105e22 <isdirempty+0x3a>
      panic("isdirempty: readi");
80105e15:	83 ec 0c             	sub    $0xc,%esp
80105e18:	68 80 8b 10 80       	push   $0x80108b80
80105e1d:	e8 af a7 ff ff       	call   801005d1 <panic>
    if(de.inum != 0)
80105e22:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e26:	66 85 c0             	test   %ax,%ax
80105e29:	74 07                	je     80105e32 <isdirempty+0x4a>
      return 0;
80105e2b:	b8 00 00 00 00       	mov    $0x0,%eax
80105e30:	eb 1b                	jmp    80105e4d <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e35:	83 c0 10             	add    $0x10,%eax
80105e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80105e3e:	8b 50 58             	mov    0x58(%eax),%edx
80105e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e44:	39 c2                	cmp    %eax,%edx
80105e46:	77 b3                	ja     80105dfb <isdirempty+0x13>
  }
  return 1;
80105e48:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e4d:	c9                   	leave  
80105e4e:	c3                   	ret    

80105e4f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105e4f:	f3 0f 1e fb          	endbr32 
80105e53:	55                   	push   %ebp
80105e54:	89 e5                	mov    %esp,%ebp
80105e56:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105e59:	83 ec 08             	sub    $0x8,%esp
80105e5c:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105e5f:	50                   	push   %eax
80105e60:	6a 00                	push   $0x0
80105e62:	e8 07 fa ff ff       	call   8010586e <argstr>
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	79 0a                	jns    80105e78 <sys_unlink+0x29>
    return -1;
80105e6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e73:	e9 bf 01 00 00       	jmp    80106037 <sys_unlink+0x1e8>

  begin_op();
80105e78:	e8 60 d8 ff ff       	call   801036dd <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e80:	83 ec 08             	sub    $0x8,%esp
80105e83:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105e86:	52                   	push   %edx
80105e87:	50                   	push   %eax
80105e88:	e8 0c c8 ff ff       	call   80102699 <nameiparent>
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e97:	75 0f                	jne    80105ea8 <sys_unlink+0x59>
    end_op();
80105e99:	e8 cf d8 ff ff       	call   8010376d <end_op>
    return -1;
80105e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea3:	e9 8f 01 00 00       	jmp    80106037 <sys_unlink+0x1e8>
  }

  ilock(dp);
80105ea8:	83 ec 0c             	sub    $0xc,%esp
80105eab:	ff 75 f4             	pushl  -0xc(%ebp)
80105eae:	e8 5b bc ff ff       	call   80101b0e <ilock>
80105eb3:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105eb6:	83 ec 08             	sub    $0x8,%esp
80105eb9:	68 92 8b 10 80       	push   $0x80108b92
80105ebe:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ec1:	50                   	push   %eax
80105ec2:	e8 32 c4 ff ff       	call   801022f9 <namecmp>
80105ec7:	83 c4 10             	add    $0x10,%esp
80105eca:	85 c0                	test   %eax,%eax
80105ecc:	0f 84 49 01 00 00    	je     8010601b <sys_unlink+0x1cc>
80105ed2:	83 ec 08             	sub    $0x8,%esp
80105ed5:	68 94 8b 10 80       	push   $0x80108b94
80105eda:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105edd:	50                   	push   %eax
80105ede:	e8 16 c4 ff ff       	call   801022f9 <namecmp>
80105ee3:	83 c4 10             	add    $0x10,%esp
80105ee6:	85 c0                	test   %eax,%eax
80105ee8:	0f 84 2d 01 00 00    	je     8010601b <sys_unlink+0x1cc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105eee:	83 ec 04             	sub    $0x4,%esp
80105ef1:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ef4:	50                   	push   %eax
80105ef5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ef8:	50                   	push   %eax
80105ef9:	ff 75 f4             	pushl  -0xc(%ebp)
80105efc:	e8 17 c4 ff ff       	call   80102318 <dirlookup>
80105f01:	83 c4 10             	add    $0x10,%esp
80105f04:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f0b:	0f 84 0d 01 00 00    	je     8010601e <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
80105f11:	83 ec 0c             	sub    $0xc,%esp
80105f14:	ff 75 f0             	pushl  -0x10(%ebp)
80105f17:	e8 f2 bb ff ff       	call   80101b0e <ilock>
80105f1c:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f22:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105f26:	66 85 c0             	test   %ax,%ax
80105f29:	7f 0d                	jg     80105f38 <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
80105f2b:	83 ec 0c             	sub    $0xc,%esp
80105f2e:	68 97 8b 10 80       	push   $0x80108b97
80105f33:	e8 99 a6 ff ff       	call   801005d1 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f3f:	66 83 f8 01          	cmp    $0x1,%ax
80105f43:	75 25                	jne    80105f6a <sys_unlink+0x11b>
80105f45:	83 ec 0c             	sub    $0xc,%esp
80105f48:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4b:	e8 98 fe ff ff       	call   80105de8 <isdirempty>
80105f50:	83 c4 10             	add    $0x10,%esp
80105f53:	85 c0                	test   %eax,%eax
80105f55:	75 13                	jne    80105f6a <sys_unlink+0x11b>
    iunlockput(ip);
80105f57:	83 ec 0c             	sub    $0xc,%esp
80105f5a:	ff 75 f0             	pushl  -0x10(%ebp)
80105f5d:	e8 e9 bd ff ff       	call   80101d4b <iunlockput>
80105f62:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105f65:	e9 b5 00 00 00       	jmp    8010601f <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
80105f6a:	83 ec 04             	sub    $0x4,%esp
80105f6d:	6a 10                	push   $0x10
80105f6f:	6a 00                	push   $0x0
80105f71:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f74:	50                   	push   %eax
80105f75:	e8 03 f5 ff ff       	call   8010547d <memset>
80105f7a:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105f80:	6a 10                	push   $0x10
80105f82:	50                   	push   %eax
80105f83:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f86:	50                   	push   %eax
80105f87:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8a:	e8 e0 c1 ff ff       	call   8010216f <writei>
80105f8f:	83 c4 10             	add    $0x10,%esp
80105f92:	83 f8 10             	cmp    $0x10,%eax
80105f95:	74 0d                	je     80105fa4 <sys_unlink+0x155>
    panic("unlink: writei");
80105f97:	83 ec 0c             	sub    $0xc,%esp
80105f9a:	68 a9 8b 10 80       	push   $0x80108ba9
80105f9f:	e8 2d a6 ff ff       	call   801005d1 <panic>
  if(ip->type == T_DIR){
80105fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105fab:	66 83 f8 01          	cmp    $0x1,%ax
80105faf:	75 21                	jne    80105fd2 <sys_unlink+0x183>
    dp->nlink--;
80105fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb4:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105fb8:	83 e8 01             	sub    $0x1,%eax
80105fbb:	89 c2                	mov    %eax,%edx
80105fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc0:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105fc4:	83 ec 0c             	sub    $0xc,%esp
80105fc7:	ff 75 f4             	pushl  -0xc(%ebp)
80105fca:	e8 56 b9 ff ff       	call   80101925 <iupdate>
80105fcf:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105fd2:	83 ec 0c             	sub    $0xc,%esp
80105fd5:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd8:	e8 6e bd ff ff       	call   80101d4b <iunlockput>
80105fdd:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe3:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105fe7:	83 e8 01             	sub    $0x1,%eax
80105fea:	89 c2                	mov    %eax,%edx
80105fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fef:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105ff3:	83 ec 0c             	sub    $0xc,%esp
80105ff6:	ff 75 f0             	pushl  -0x10(%ebp)
80105ff9:	e8 27 b9 ff ff       	call   80101925 <iupdate>
80105ffe:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106001:	83 ec 0c             	sub    $0xc,%esp
80106004:	ff 75 f0             	pushl  -0x10(%ebp)
80106007:	e8 3f bd ff ff       	call   80101d4b <iunlockput>
8010600c:	83 c4 10             	add    $0x10,%esp

  end_op();
8010600f:	e8 59 d7 ff ff       	call   8010376d <end_op>

  return 0;
80106014:	b8 00 00 00 00       	mov    $0x0,%eax
80106019:	eb 1c                	jmp    80106037 <sys_unlink+0x1e8>
    goto bad;
8010601b:	90                   	nop
8010601c:	eb 01                	jmp    8010601f <sys_unlink+0x1d0>
    goto bad;
8010601e:	90                   	nop

bad:
  iunlockput(dp);
8010601f:	83 ec 0c             	sub    $0xc,%esp
80106022:	ff 75 f4             	pushl  -0xc(%ebp)
80106025:	e8 21 bd ff ff       	call   80101d4b <iunlockput>
8010602a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010602d:	e8 3b d7 ff ff       	call   8010376d <end_op>
  return -1;
80106032:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106037:	c9                   	leave  
80106038:	c3                   	ret    

80106039 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106039:	f3 0f 1e fb          	endbr32 
8010603d:	55                   	push   %ebp
8010603e:	89 e5                	mov    %esp,%ebp
80106040:	83 ec 38             	sub    $0x38,%esp
80106043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106046:	8b 55 10             	mov    0x10(%ebp),%edx
80106049:	8b 45 14             	mov    0x14(%ebp),%eax
8010604c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106050:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106054:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106058:	83 ec 08             	sub    $0x8,%esp
8010605b:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010605e:	50                   	push   %eax
8010605f:	ff 75 08             	pushl  0x8(%ebp)
80106062:	e8 32 c6 ff ff       	call   80102699 <nameiparent>
80106067:	83 c4 10             	add    $0x10,%esp
8010606a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010606d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106071:	75 0a                	jne    8010607d <create+0x44>
    return 0;
80106073:	b8 00 00 00 00       	mov    $0x0,%eax
80106078:	e9 8e 01 00 00       	jmp    8010620b <create+0x1d2>
  ilock(dp);
8010607d:	83 ec 0c             	sub    $0xc,%esp
80106080:	ff 75 f4             	pushl  -0xc(%ebp)
80106083:	e8 86 ba ff ff       	call   80101b0e <ilock>
80106088:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
8010608b:	83 ec 04             	sub    $0x4,%esp
8010608e:	6a 00                	push   $0x0
80106090:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106093:	50                   	push   %eax
80106094:	ff 75 f4             	pushl  -0xc(%ebp)
80106097:	e8 7c c2 ff ff       	call   80102318 <dirlookup>
8010609c:	83 c4 10             	add    $0x10,%esp
8010609f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060a6:	74 50                	je     801060f8 <create+0xbf>
    iunlockput(dp);
801060a8:	83 ec 0c             	sub    $0xc,%esp
801060ab:	ff 75 f4             	pushl  -0xc(%ebp)
801060ae:	e8 98 bc ff ff       	call   80101d4b <iunlockput>
801060b3:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801060b6:	83 ec 0c             	sub    $0xc,%esp
801060b9:	ff 75 f0             	pushl  -0x10(%ebp)
801060bc:	e8 4d ba ff ff       	call   80101b0e <ilock>
801060c1:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801060c4:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801060c9:	75 15                	jne    801060e0 <create+0xa7>
801060cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ce:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801060d2:	66 83 f8 02          	cmp    $0x2,%ax
801060d6:	75 08                	jne    801060e0 <create+0xa7>
      return ip;
801060d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060db:	e9 2b 01 00 00       	jmp    8010620b <create+0x1d2>
    iunlockput(ip);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	ff 75 f0             	pushl  -0x10(%ebp)
801060e6:	e8 60 bc ff ff       	call   80101d4b <iunlockput>
801060eb:	83 c4 10             	add    $0x10,%esp
    return 0;
801060ee:	b8 00 00 00 00       	mov    $0x0,%eax
801060f3:	e9 13 01 00 00       	jmp    8010620b <create+0x1d2>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801060f8:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801060fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ff:	8b 00                	mov    (%eax),%eax
80106101:	83 ec 08             	sub    $0x8,%esp
80106104:	52                   	push   %edx
80106105:	50                   	push   %eax
80106106:	e8 3f b7 ff ff       	call   8010184a <ialloc>
8010610b:	83 c4 10             	add    $0x10,%esp
8010610e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106111:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106115:	75 0d                	jne    80106124 <create+0xeb>
    panic("create: ialloc");
80106117:	83 ec 0c             	sub    $0xc,%esp
8010611a:	68 b8 8b 10 80       	push   $0x80108bb8
8010611f:	e8 ad a4 ff ff       	call   801005d1 <panic>

  ilock(ip);
80106124:	83 ec 0c             	sub    $0xc,%esp
80106127:	ff 75 f0             	pushl  -0x10(%ebp)
8010612a:	e8 df b9 ff ff       	call   80101b0e <ilock>
8010612f:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106132:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106135:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106139:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
8010613d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106140:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106144:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80106148:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614b:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80106151:	83 ec 0c             	sub    $0xc,%esp
80106154:	ff 75 f0             	pushl  -0x10(%ebp)
80106157:	e8 c9 b7 ff ff       	call   80101925 <iupdate>
8010615c:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010615f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106164:	75 6a                	jne    801061d0 <create+0x197>
    dp->nlink++;  // for ".."
80106166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106169:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010616d:	83 c0 01             	add    $0x1,%eax
80106170:	89 c2                	mov    %eax,%edx
80106172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106175:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106179:	83 ec 0c             	sub    $0xc,%esp
8010617c:	ff 75 f4             	pushl  -0xc(%ebp)
8010617f:	e8 a1 b7 ff ff       	call   80101925 <iupdate>
80106184:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106187:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618a:	8b 40 04             	mov    0x4(%eax),%eax
8010618d:	83 ec 04             	sub    $0x4,%esp
80106190:	50                   	push   %eax
80106191:	68 92 8b 10 80       	push   $0x80108b92
80106196:	ff 75 f0             	pushl  -0x10(%ebp)
80106199:	e8 38 c2 ff ff       	call   801023d6 <dirlink>
8010619e:	83 c4 10             	add    $0x10,%esp
801061a1:	85 c0                	test   %eax,%eax
801061a3:	78 1e                	js     801061c3 <create+0x18a>
801061a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a8:	8b 40 04             	mov    0x4(%eax),%eax
801061ab:	83 ec 04             	sub    $0x4,%esp
801061ae:	50                   	push   %eax
801061af:	68 94 8b 10 80       	push   $0x80108b94
801061b4:	ff 75 f0             	pushl  -0x10(%ebp)
801061b7:	e8 1a c2 ff ff       	call   801023d6 <dirlink>
801061bc:	83 c4 10             	add    $0x10,%esp
801061bf:	85 c0                	test   %eax,%eax
801061c1:	79 0d                	jns    801061d0 <create+0x197>
      panic("create dots");
801061c3:	83 ec 0c             	sub    $0xc,%esp
801061c6:	68 c7 8b 10 80       	push   $0x80108bc7
801061cb:	e8 01 a4 ff ff       	call   801005d1 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801061d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d3:	8b 40 04             	mov    0x4(%eax),%eax
801061d6:	83 ec 04             	sub    $0x4,%esp
801061d9:	50                   	push   %eax
801061da:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801061dd:	50                   	push   %eax
801061de:	ff 75 f4             	pushl  -0xc(%ebp)
801061e1:	e8 f0 c1 ff ff       	call   801023d6 <dirlink>
801061e6:	83 c4 10             	add    $0x10,%esp
801061e9:	85 c0                	test   %eax,%eax
801061eb:	79 0d                	jns    801061fa <create+0x1c1>
    panic("create: dirlink");
801061ed:	83 ec 0c             	sub    $0xc,%esp
801061f0:	68 d3 8b 10 80       	push   $0x80108bd3
801061f5:	e8 d7 a3 ff ff       	call   801005d1 <panic>

  iunlockput(dp);
801061fa:	83 ec 0c             	sub    $0xc,%esp
801061fd:	ff 75 f4             	pushl  -0xc(%ebp)
80106200:	e8 46 bb ff ff       	call   80101d4b <iunlockput>
80106205:	83 c4 10             	add    $0x10,%esp

  return ip;
80106208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010620b:	c9                   	leave  
8010620c:	c3                   	ret    

8010620d <sys_open>:

int
sys_open(void)
{
8010620d:	f3 0f 1e fb          	endbr32 
80106211:	55                   	push   %ebp
80106212:	89 e5                	mov    %esp,%ebp
80106214:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106217:	83 ec 08             	sub    $0x8,%esp
8010621a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010621d:	50                   	push   %eax
8010621e:	6a 00                	push   $0x0
80106220:	e8 49 f6 ff ff       	call   8010586e <argstr>
80106225:	83 c4 10             	add    $0x10,%esp
80106228:	85 c0                	test   %eax,%eax
8010622a:	78 15                	js     80106241 <sys_open+0x34>
8010622c:	83 ec 08             	sub    $0x8,%esp
8010622f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106232:	50                   	push   %eax
80106233:	6a 01                	push   $0x1
80106235:	e8 97 f5 ff ff       	call   801057d1 <argint>
8010623a:	83 c4 10             	add    $0x10,%esp
8010623d:	85 c0                	test   %eax,%eax
8010623f:	79 0a                	jns    8010624b <sys_open+0x3e>
    return -1;
80106241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106246:	e9 61 01 00 00       	jmp    801063ac <sys_open+0x19f>

  begin_op();
8010624b:	e8 8d d4 ff ff       	call   801036dd <begin_op>

  if(omode & O_CREATE){
80106250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106253:	25 00 02 00 00       	and    $0x200,%eax
80106258:	85 c0                	test   %eax,%eax
8010625a:	74 2a                	je     80106286 <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
8010625c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010625f:	6a 00                	push   $0x0
80106261:	6a 00                	push   $0x0
80106263:	6a 02                	push   $0x2
80106265:	50                   	push   %eax
80106266:	e8 ce fd ff ff       	call   80106039 <create>
8010626b:	83 c4 10             	add    $0x10,%esp
8010626e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106275:	75 75                	jne    801062ec <sys_open+0xdf>
      end_op();
80106277:	e8 f1 d4 ff ff       	call   8010376d <end_op>
      return -1;
8010627c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106281:	e9 26 01 00 00       	jmp    801063ac <sys_open+0x19f>
    }
  } else {
    if((ip = namei(path)) == 0){
80106286:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106289:	83 ec 0c             	sub    $0xc,%esp
8010628c:	50                   	push   %eax
8010628d:	e8 e7 c3 ff ff       	call   80102679 <namei>
80106292:	83 c4 10             	add    $0x10,%esp
80106295:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106298:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010629c:	75 0f                	jne    801062ad <sys_open+0xa0>
      end_op();
8010629e:	e8 ca d4 ff ff       	call   8010376d <end_op>
      return -1;
801062a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a8:	e9 ff 00 00 00       	jmp    801063ac <sys_open+0x19f>
    }
    ilock(ip);
801062ad:	83 ec 0c             	sub    $0xc,%esp
801062b0:	ff 75 f4             	pushl  -0xc(%ebp)
801062b3:	e8 56 b8 ff ff       	call   80101b0e <ilock>
801062b8:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801062bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062be:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801062c2:	66 83 f8 01          	cmp    $0x1,%ax
801062c6:	75 24                	jne    801062ec <sys_open+0xdf>
801062c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062cb:	85 c0                	test   %eax,%eax
801062cd:	74 1d                	je     801062ec <sys_open+0xdf>
      iunlockput(ip);
801062cf:	83 ec 0c             	sub    $0xc,%esp
801062d2:	ff 75 f4             	pushl  -0xc(%ebp)
801062d5:	e8 71 ba ff ff       	call   80101d4b <iunlockput>
801062da:	83 c4 10             	add    $0x10,%esp
      end_op();
801062dd:	e8 8b d4 ff ff       	call   8010376d <end_op>
      return -1;
801062e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e7:	e9 c0 00 00 00       	jmp    801063ac <sys_open+0x19f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801062ec:	e8 6d ad ff ff       	call   8010105e <filealloc>
801062f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062f8:	74 17                	je     80106311 <sys_open+0x104>
801062fa:	83 ec 0c             	sub    $0xc,%esp
801062fd:	ff 75 f0             	pushl  -0x10(%ebp)
80106300:	e8 9e f6 ff ff       	call   801059a3 <fdalloc>
80106305:	83 c4 10             	add    $0x10,%esp
80106308:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010630b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010630f:	79 2e                	jns    8010633f <sys_open+0x132>
    if(f)
80106311:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106315:	74 0e                	je     80106325 <sys_open+0x118>
      fileclose(f);
80106317:	83 ec 0c             	sub    $0xc,%esp
8010631a:	ff 75 f0             	pushl  -0x10(%ebp)
8010631d:	e8 02 ae ff ff       	call   80101124 <fileclose>
80106322:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106325:	83 ec 0c             	sub    $0xc,%esp
80106328:	ff 75 f4             	pushl  -0xc(%ebp)
8010632b:	e8 1b ba ff ff       	call   80101d4b <iunlockput>
80106330:	83 c4 10             	add    $0x10,%esp
    end_op();
80106333:	e8 35 d4 ff ff       	call   8010376d <end_op>
    return -1;
80106338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633d:	eb 6d                	jmp    801063ac <sys_open+0x19f>
  }
  iunlock(ip);
8010633f:	83 ec 0c             	sub    $0xc,%esp
80106342:	ff 75 f4             	pushl  -0xc(%ebp)
80106345:	e8 db b8 ff ff       	call   80101c25 <iunlock>
8010634a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010634d:	e8 1b d4 ff ff       	call   8010376d <end_op>

  f->type = FD_INODE;
80106352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106355:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010635b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106361:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106364:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106367:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010636e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106371:	83 e0 01             	and    $0x1,%eax
80106374:	85 c0                	test   %eax,%eax
80106376:	0f 94 c0             	sete   %al
80106379:	89 c2                	mov    %eax,%edx
8010637b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010637e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106384:	83 e0 01             	and    $0x1,%eax
80106387:	85 c0                	test   %eax,%eax
80106389:	75 0a                	jne    80106395 <sys_open+0x188>
8010638b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010638e:	83 e0 02             	and    $0x2,%eax
80106391:	85 c0                	test   %eax,%eax
80106393:	74 07                	je     8010639c <sys_open+0x18f>
80106395:	b8 01 00 00 00       	mov    $0x1,%eax
8010639a:	eb 05                	jmp    801063a1 <sys_open+0x194>
8010639c:	b8 00 00 00 00       	mov    $0x0,%eax
801063a1:	89 c2                	mov    %eax,%edx
801063a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a6:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801063a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801063ac:	c9                   	leave  
801063ad:	c3                   	ret    

801063ae <sys_mkdir>:

int
sys_mkdir(void)
{
801063ae:	f3 0f 1e fb          	endbr32 
801063b2:	55                   	push   %ebp
801063b3:	89 e5                	mov    %esp,%ebp
801063b5:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801063b8:	e8 20 d3 ff ff       	call   801036dd <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801063bd:	83 ec 08             	sub    $0x8,%esp
801063c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063c3:	50                   	push   %eax
801063c4:	6a 00                	push   $0x0
801063c6:	e8 a3 f4 ff ff       	call   8010586e <argstr>
801063cb:	83 c4 10             	add    $0x10,%esp
801063ce:	85 c0                	test   %eax,%eax
801063d0:	78 1b                	js     801063ed <sys_mkdir+0x3f>
801063d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d5:	6a 00                	push   $0x0
801063d7:	6a 00                	push   $0x0
801063d9:	6a 01                	push   $0x1
801063db:	50                   	push   %eax
801063dc:	e8 58 fc ff ff       	call   80106039 <create>
801063e1:	83 c4 10             	add    $0x10,%esp
801063e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063eb:	75 0c                	jne    801063f9 <sys_mkdir+0x4b>
    end_op();
801063ed:	e8 7b d3 ff ff       	call   8010376d <end_op>
    return -1;
801063f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f7:	eb 18                	jmp    80106411 <sys_mkdir+0x63>
  }
  iunlockput(ip);
801063f9:	83 ec 0c             	sub    $0xc,%esp
801063fc:	ff 75 f4             	pushl  -0xc(%ebp)
801063ff:	e8 47 b9 ff ff       	call   80101d4b <iunlockput>
80106404:	83 c4 10             	add    $0x10,%esp
  end_op();
80106407:	e8 61 d3 ff ff       	call   8010376d <end_op>
  return 0;
8010640c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106411:	c9                   	leave  
80106412:	c3                   	ret    

80106413 <sys_mknod>:

int
sys_mknod(void)
{
80106413:	f3 0f 1e fb          	endbr32 
80106417:	55                   	push   %ebp
80106418:	89 e5                	mov    %esp,%ebp
8010641a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010641d:	e8 bb d2 ff ff       	call   801036dd <begin_op>
  if((argstr(0, &path)) < 0 ||
80106422:	83 ec 08             	sub    $0x8,%esp
80106425:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106428:	50                   	push   %eax
80106429:	6a 00                	push   $0x0
8010642b:	e8 3e f4 ff ff       	call   8010586e <argstr>
80106430:	83 c4 10             	add    $0x10,%esp
80106433:	85 c0                	test   %eax,%eax
80106435:	78 4f                	js     80106486 <sys_mknod+0x73>
     argint(1, &major) < 0 ||
80106437:	83 ec 08             	sub    $0x8,%esp
8010643a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010643d:	50                   	push   %eax
8010643e:	6a 01                	push   $0x1
80106440:	e8 8c f3 ff ff       	call   801057d1 <argint>
80106445:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80106448:	85 c0                	test   %eax,%eax
8010644a:	78 3a                	js     80106486 <sys_mknod+0x73>
     argint(2, &minor) < 0 ||
8010644c:	83 ec 08             	sub    $0x8,%esp
8010644f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106452:	50                   	push   %eax
80106453:	6a 02                	push   $0x2
80106455:	e8 77 f3 ff ff       	call   801057d1 <argint>
8010645a:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
8010645d:	85 c0                	test   %eax,%eax
8010645f:	78 25                	js     80106486 <sys_mknod+0x73>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106461:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106464:	0f bf c8             	movswl %ax,%ecx
80106467:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010646a:	0f bf d0             	movswl %ax,%edx
8010646d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106470:	51                   	push   %ecx
80106471:	52                   	push   %edx
80106472:	6a 03                	push   $0x3
80106474:	50                   	push   %eax
80106475:	e8 bf fb ff ff       	call   80106039 <create>
8010647a:	83 c4 10             	add    $0x10,%esp
8010647d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80106480:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106484:	75 0c                	jne    80106492 <sys_mknod+0x7f>
    end_op();
80106486:	e8 e2 d2 ff ff       	call   8010376d <end_op>
    return -1;
8010648b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106490:	eb 18                	jmp    801064aa <sys_mknod+0x97>
  }
  iunlockput(ip);
80106492:	83 ec 0c             	sub    $0xc,%esp
80106495:	ff 75 f4             	pushl  -0xc(%ebp)
80106498:	e8 ae b8 ff ff       	call   80101d4b <iunlockput>
8010649d:	83 c4 10             	add    $0x10,%esp
  end_op();
801064a0:	e8 c8 d2 ff ff       	call   8010376d <end_op>
  return 0;
801064a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064aa:	c9                   	leave  
801064ab:	c3                   	ret    

801064ac <sys_chdir>:

int
sys_chdir(void)
{
801064ac:	f3 0f 1e fb          	endbr32 
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801064b6:	e8 e1 df ff ff       	call   8010449c <myproc>
801064bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
801064be:	e8 1a d2 ff ff       	call   801036dd <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801064c3:	83 ec 08             	sub    $0x8,%esp
801064c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064c9:	50                   	push   %eax
801064ca:	6a 00                	push   $0x0
801064cc:	e8 9d f3 ff ff       	call   8010586e <argstr>
801064d1:	83 c4 10             	add    $0x10,%esp
801064d4:	85 c0                	test   %eax,%eax
801064d6:	78 18                	js     801064f0 <sys_chdir+0x44>
801064d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064db:	83 ec 0c             	sub    $0xc,%esp
801064de:	50                   	push   %eax
801064df:	e8 95 c1 ff ff       	call   80102679 <namei>
801064e4:	83 c4 10             	add    $0x10,%esp
801064e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064ee:	75 0c                	jne    801064fc <sys_chdir+0x50>
    end_op();
801064f0:	e8 78 d2 ff ff       	call   8010376d <end_op>
    return -1;
801064f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fa:	eb 68                	jmp    80106564 <sys_chdir+0xb8>
  }
  ilock(ip);
801064fc:	83 ec 0c             	sub    $0xc,%esp
801064ff:	ff 75 f0             	pushl  -0x10(%ebp)
80106502:	e8 07 b6 ff ff       	call   80101b0e <ilock>
80106507:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010650a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010650d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106511:	66 83 f8 01          	cmp    $0x1,%ax
80106515:	74 1a                	je     80106531 <sys_chdir+0x85>
    iunlockput(ip);
80106517:	83 ec 0c             	sub    $0xc,%esp
8010651a:	ff 75 f0             	pushl  -0x10(%ebp)
8010651d:	e8 29 b8 ff ff       	call   80101d4b <iunlockput>
80106522:	83 c4 10             	add    $0x10,%esp
    end_op();
80106525:	e8 43 d2 ff ff       	call   8010376d <end_op>
    return -1;
8010652a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652f:	eb 33                	jmp    80106564 <sys_chdir+0xb8>
  }
  iunlock(ip);
80106531:	83 ec 0c             	sub    $0xc,%esp
80106534:	ff 75 f0             	pushl  -0x10(%ebp)
80106537:	e8 e9 b6 ff ff       	call   80101c25 <iunlock>
8010653c:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
8010653f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106542:	8b 40 68             	mov    0x68(%eax),%eax
80106545:	83 ec 0c             	sub    $0xc,%esp
80106548:	50                   	push   %eax
80106549:	e8 29 b7 ff ff       	call   80101c77 <iput>
8010654e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106551:	e8 17 d2 ff ff       	call   8010376d <end_op>
  curproc->cwd = ip;
80106556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106559:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010655c:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010655f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106564:	c9                   	leave  
80106565:	c3                   	ret    

80106566 <sys_exec>:

int
sys_exec(void)
{
80106566:	f3 0f 1e fb          	endbr32 
8010656a:	55                   	push   %ebp
8010656b:	89 e5                	mov    %esp,%ebp
8010656d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106573:	83 ec 08             	sub    $0x8,%esp
80106576:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106579:	50                   	push   %eax
8010657a:	6a 00                	push   $0x0
8010657c:	e8 ed f2 ff ff       	call   8010586e <argstr>
80106581:	83 c4 10             	add    $0x10,%esp
80106584:	85 c0                	test   %eax,%eax
80106586:	78 18                	js     801065a0 <sys_exec+0x3a>
80106588:	83 ec 08             	sub    $0x8,%esp
8010658b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106591:	50                   	push   %eax
80106592:	6a 01                	push   $0x1
80106594:	e8 38 f2 ff ff       	call   801057d1 <argint>
80106599:	83 c4 10             	add    $0x10,%esp
8010659c:	85 c0                	test   %eax,%eax
8010659e:	79 0a                	jns    801065aa <sys_exec+0x44>
    return -1;
801065a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a5:	e9 c6 00 00 00       	jmp    80106670 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
801065aa:	83 ec 04             	sub    $0x4,%esp
801065ad:	68 80 00 00 00       	push   $0x80
801065b2:	6a 00                	push   $0x0
801065b4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065ba:	50                   	push   %eax
801065bb:	e8 bd ee ff ff       	call   8010547d <memset>
801065c0:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801065c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801065ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065cd:	83 f8 1f             	cmp    $0x1f,%eax
801065d0:	76 0a                	jbe    801065dc <sys_exec+0x76>
      return -1;
801065d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d7:	e9 94 00 00 00       	jmp    80106670 <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801065dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065df:	c1 e0 02             	shl    $0x2,%eax
801065e2:	89 c2                	mov    %eax,%edx
801065e4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801065ea:	01 c2                	add    %eax,%edx
801065ec:	83 ec 08             	sub    $0x8,%esp
801065ef:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801065f5:	50                   	push   %eax
801065f6:	52                   	push   %edx
801065f7:	e8 2a f1 ff ff       	call   80105726 <fetchint>
801065fc:	83 c4 10             	add    $0x10,%esp
801065ff:	85 c0                	test   %eax,%eax
80106601:	79 07                	jns    8010660a <sys_exec+0xa4>
      return -1;
80106603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106608:	eb 66                	jmp    80106670 <sys_exec+0x10a>
    if(uarg == 0){
8010660a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106610:	85 c0                	test   %eax,%eax
80106612:	75 27                	jne    8010663b <sys_exec+0xd5>
      argv[i] = 0;
80106614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106617:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010661e:	00 00 00 00 
      break;
80106622:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106626:	83 ec 08             	sub    $0x8,%esp
80106629:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010662f:	52                   	push   %edx
80106630:	50                   	push   %eax
80106631:	e8 c3 a5 ff ff       	call   80100bf9 <exec>
80106636:	83 c4 10             	add    $0x10,%esp
80106639:	eb 35                	jmp    80106670 <sys_exec+0x10a>
    if(fetchstr(uarg, &argv[i]) < 0)
8010663b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106641:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106644:	c1 e2 02             	shl    $0x2,%edx
80106647:	01 c2                	add    %eax,%edx
80106649:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010664f:	83 ec 08             	sub    $0x8,%esp
80106652:	52                   	push   %edx
80106653:	50                   	push   %eax
80106654:	e8 10 f1 ff ff       	call   80105769 <fetchstr>
80106659:	83 c4 10             	add    $0x10,%esp
8010665c:	85 c0                	test   %eax,%eax
8010665e:	79 07                	jns    80106667 <sys_exec+0x101>
      return -1;
80106660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106665:	eb 09                	jmp    80106670 <sys_exec+0x10a>
  for(i=0;; i++){
80106667:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
8010666b:	e9 5a ff ff ff       	jmp    801065ca <sys_exec+0x64>
}
80106670:	c9                   	leave  
80106671:	c3                   	ret    

80106672 <sys_pipe>:

int
sys_pipe(void)
{
80106672:	f3 0f 1e fb          	endbr32 
80106676:	55                   	push   %ebp
80106677:	89 e5                	mov    %esp,%ebp
80106679:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010667c:	83 ec 04             	sub    $0x4,%esp
8010667f:	6a 08                	push   $0x8
80106681:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106684:	50                   	push   %eax
80106685:	6a 00                	push   $0x0
80106687:	e8 76 f1 ff ff       	call   80105802 <argptr>
8010668c:	83 c4 10             	add    $0x10,%esp
8010668f:	85 c0                	test   %eax,%eax
80106691:	79 0a                	jns    8010669d <sys_pipe+0x2b>
    return -1;
80106693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106698:	e9 ae 00 00 00       	jmp    8010674b <sys_pipe+0xd9>
  if(pipealloc(&rf, &wf) < 0)
8010669d:	83 ec 08             	sub    $0x8,%esp
801066a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066a3:	50                   	push   %eax
801066a4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066a7:	50                   	push   %eax
801066a8:	e8 10 d9 ff ff       	call   80103fbd <pipealloc>
801066ad:	83 c4 10             	add    $0x10,%esp
801066b0:	85 c0                	test   %eax,%eax
801066b2:	79 0a                	jns    801066be <sys_pipe+0x4c>
    return -1;
801066b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b9:	e9 8d 00 00 00       	jmp    8010674b <sys_pipe+0xd9>
  fd0 = -1;
801066be:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066c8:	83 ec 0c             	sub    $0xc,%esp
801066cb:	50                   	push   %eax
801066cc:	e8 d2 f2 ff ff       	call   801059a3 <fdalloc>
801066d1:	83 c4 10             	add    $0x10,%esp
801066d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066db:	78 18                	js     801066f5 <sys_pipe+0x83>
801066dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066e0:	83 ec 0c             	sub    $0xc,%esp
801066e3:	50                   	push   %eax
801066e4:	e8 ba f2 ff ff       	call   801059a3 <fdalloc>
801066e9:	83 c4 10             	add    $0x10,%esp
801066ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066f3:	79 3e                	jns    80106733 <sys_pipe+0xc1>
    if(fd0 >= 0)
801066f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066f9:	78 13                	js     8010670e <sys_pipe+0x9c>
      myproc()->ofile[fd0] = 0;
801066fb:	e8 9c dd ff ff       	call   8010449c <myproc>
80106700:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106703:	83 c2 08             	add    $0x8,%edx
80106706:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010670d:	00 
    fileclose(rf);
8010670e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106711:	83 ec 0c             	sub    $0xc,%esp
80106714:	50                   	push   %eax
80106715:	e8 0a aa ff ff       	call   80101124 <fileclose>
8010671a:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010671d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106720:	83 ec 0c             	sub    $0xc,%esp
80106723:	50                   	push   %eax
80106724:	e8 fb a9 ff ff       	call   80101124 <fileclose>
80106729:	83 c4 10             	add    $0x10,%esp
    return -1;
8010672c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106731:	eb 18                	jmp    8010674b <sys_pipe+0xd9>
  }
  fd[0] = fd0;
80106733:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106736:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106739:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010673b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010673e:	8d 50 04             	lea    0x4(%eax),%edx
80106741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106744:	89 02                	mov    %eax,(%edx)
  return 0;
80106746:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010674b:	c9                   	leave  
8010674c:	c3                   	ret    

8010674d <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010674d:	f3 0f 1e fb          	endbr32 
80106751:	55                   	push   %ebp
80106752:	89 e5                	mov    %esp,%ebp
80106754:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106757:	e8 53 e0 ff ff       	call   801047af <fork>
}
8010675c:	c9                   	leave  
8010675d:	c3                   	ret    

8010675e <sys_exit>:

int
sys_exit(void)
{
8010675e:	f3 0f 1e fb          	endbr32 
80106762:	55                   	push   %ebp
80106763:	89 e5                	mov    %esp,%ebp
80106765:	83 ec 08             	sub    $0x8,%esp
  exit();
80106768:	e8 bf e1 ff ff       	call   8010492c <exit>
  return 0;  // not reached
8010676d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106772:	c9                   	leave  
80106773:	c3                   	ret    

80106774 <sys_wait>:

int
sys_wait(void)
{
80106774:	f3 0f 1e fb          	endbr32 
80106778:	55                   	push   %ebp
80106779:	89 e5                	mov    %esp,%ebp
8010677b:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010677e:	e8 cd e2 ff ff       	call   80104a50 <wait>
}
80106783:	c9                   	leave  
80106784:	c3                   	ret    

80106785 <sys_kill>:

int
sys_kill(void)
{
80106785:	f3 0f 1e fb          	endbr32 
80106789:	55                   	push   %ebp
8010678a:	89 e5                	mov    %esp,%ebp
8010678c:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010678f:	83 ec 08             	sub    $0x8,%esp
80106792:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106795:	50                   	push   %eax
80106796:	6a 00                	push   $0x0
80106798:	e8 34 f0 ff ff       	call   801057d1 <argint>
8010679d:	83 c4 10             	add    $0x10,%esp
801067a0:	85 c0                	test   %eax,%eax
801067a2:	79 07                	jns    801067ab <sys_kill+0x26>
    return -1;
801067a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067a9:	eb 0f                	jmp    801067ba <sys_kill+0x35>
  return kill(pid);
801067ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ae:	83 ec 0c             	sub    $0xc,%esp
801067b1:	50                   	push   %eax
801067b2:	e8 e8 e6 ff ff       	call   80104e9f <kill>
801067b7:	83 c4 10             	add    $0x10,%esp
}
801067ba:	c9                   	leave  
801067bb:	c3                   	ret    

801067bc <sys_getpid>:

int
sys_getpid(void)
{
801067bc:	f3 0f 1e fb          	endbr32 
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801067c6:	e8 d1 dc ff ff       	call   8010449c <myproc>
801067cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801067ce:	c9                   	leave  
801067cf:	c3                   	ret    

801067d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801067d0:	f3 0f 1e fb          	endbr32 
801067d4:	55                   	push   %ebp
801067d5:	89 e5                	mov    %esp,%ebp
801067d7:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801067da:	83 ec 08             	sub    $0x8,%esp
801067dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067e0:	50                   	push   %eax
801067e1:	6a 00                	push   $0x0
801067e3:	e8 e9 ef ff ff       	call   801057d1 <argint>
801067e8:	83 c4 10             	add    $0x10,%esp
801067eb:	85 c0                	test   %eax,%eax
801067ed:	79 07                	jns    801067f6 <sys_sbrk+0x26>
    return -1;
801067ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f4:	eb 27                	jmp    8010681d <sys_sbrk+0x4d>
  addr = myproc()->sz;
801067f6:	e8 a1 dc ff ff       	call   8010449c <myproc>
801067fb:	8b 00                	mov    (%eax),%eax
801067fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106800:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106803:	83 ec 0c             	sub    $0xc,%esp
80106806:	50                   	push   %eax
80106807:	e8 04 df ff ff       	call   80104710 <growproc>
8010680c:	83 c4 10             	add    $0x10,%esp
8010680f:	85 c0                	test   %eax,%eax
80106811:	79 07                	jns    8010681a <sys_sbrk+0x4a>
    return -1;
80106813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106818:	eb 03                	jmp    8010681d <sys_sbrk+0x4d>
  return addr;
8010681a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010681d:	c9                   	leave  
8010681e:	c3                   	ret    

8010681f <sys_sleep>:

int
sys_sleep(void)
{
8010681f:	f3 0f 1e fb          	endbr32 
80106823:	55                   	push   %ebp
80106824:	89 e5                	mov    %esp,%ebp
80106826:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106829:	83 ec 08             	sub    $0x8,%esp
8010682c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010682f:	50                   	push   %eax
80106830:	6a 00                	push   $0x0
80106832:	e8 9a ef ff ff       	call   801057d1 <argint>
80106837:	83 c4 10             	add    $0x10,%esp
8010683a:	85 c0                	test   %eax,%eax
8010683c:	79 07                	jns    80106845 <sys_sleep+0x26>
    return -1;
8010683e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106843:	eb 76                	jmp    801068bb <sys_sleep+0x9c>
  acquire(&tickslock);
80106845:	83 ec 0c             	sub    $0xc,%esp
80106848:	68 e0 5c 11 80       	push   $0x80115ce0
8010684d:	e8 8c e9 ff ff       	call   801051de <acquire>
80106852:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106855:	a1 20 65 11 80       	mov    0x80116520,%eax
8010685a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010685d:	eb 38                	jmp    80106897 <sys_sleep+0x78>
    if(myproc()->killed){
8010685f:	e8 38 dc ff ff       	call   8010449c <myproc>
80106864:	8b 40 24             	mov    0x24(%eax),%eax
80106867:	85 c0                	test   %eax,%eax
80106869:	74 17                	je     80106882 <sys_sleep+0x63>
      release(&tickslock);
8010686b:	83 ec 0c             	sub    $0xc,%esp
8010686e:	68 e0 5c 11 80       	push   $0x80115ce0
80106873:	e8 d8 e9 ff ff       	call   80105250 <release>
80106878:	83 c4 10             	add    $0x10,%esp
      return -1;
8010687b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106880:	eb 39                	jmp    801068bb <sys_sleep+0x9c>
    }
    sleep(&ticks, &tickslock);
80106882:	83 ec 08             	sub    $0x8,%esp
80106885:	68 e0 5c 11 80       	push   $0x80115ce0
8010688a:	68 20 65 11 80       	push   $0x80116520
8010688f:	e8 e1 e4 ff ff       	call   80104d75 <sleep>
80106894:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106897:	a1 20 65 11 80       	mov    0x80116520,%eax
8010689c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010689f:	8b 55 f0             	mov    -0x10(%ebp),%edx
801068a2:	39 d0                	cmp    %edx,%eax
801068a4:	72 b9                	jb     8010685f <sys_sleep+0x40>
  }
  release(&tickslock);
801068a6:	83 ec 0c             	sub    $0xc,%esp
801068a9:	68 e0 5c 11 80       	push   $0x80115ce0
801068ae:	e8 9d e9 ff ff       	call   80105250 <release>
801068b3:	83 c4 10             	add    $0x10,%esp
  return 0;
801068b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068bb:	c9                   	leave  
801068bc:	c3                   	ret    

801068bd <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801068bd:	f3 0f 1e fb          	endbr32 
801068c1:	55                   	push   %ebp
801068c2:	89 e5                	mov    %esp,%ebp
801068c4:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
801068c7:	83 ec 0c             	sub    $0xc,%esp
801068ca:	68 e0 5c 11 80       	push   $0x80115ce0
801068cf:	e8 0a e9 ff ff       	call   801051de <acquire>
801068d4:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801068d7:	a1 20 65 11 80       	mov    0x80116520,%eax
801068dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801068df:	83 ec 0c             	sub    $0xc,%esp
801068e2:	68 e0 5c 11 80       	push   $0x80115ce0
801068e7:	e8 64 e9 ff ff       	call   80105250 <release>
801068ec:	83 c4 10             	add    $0x10,%esp
  return xticks;
801068ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801068f2:	c9                   	leave  
801068f3:	c3                   	ret    

801068f4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801068f4:	1e                   	push   %ds
  pushl %es
801068f5:	06                   	push   %es
  pushl %fs
801068f6:	0f a0                	push   %fs
  pushl %gs
801068f8:	0f a8                	push   %gs
  pushal
801068fa:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801068fb:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801068ff:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106901:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106903:	54                   	push   %esp
  call trap
80106904:	e8 df 01 00 00       	call   80106ae8 <trap>
  addl $4, %esp
80106909:	83 c4 04             	add    $0x4,%esp

8010690c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010690c:	61                   	popa   
  popl %gs
8010690d:	0f a9                	pop    %gs
  popl %fs
8010690f:	0f a1                	pop    %fs
  popl %es
80106911:	07                   	pop    %es
  popl %ds
80106912:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106913:	83 c4 08             	add    $0x8,%esp
  iret
80106916:	cf                   	iret   

80106917 <lidt>:
{
80106917:	55                   	push   %ebp
80106918:	89 e5                	mov    %esp,%ebp
8010691a:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010691d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106920:	83 e8 01             	sub    $0x1,%eax
80106923:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106927:	8b 45 08             	mov    0x8(%ebp),%eax
8010692a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010692e:	8b 45 08             	mov    0x8(%ebp),%eax
80106931:	c1 e8 10             	shr    $0x10,%eax
80106934:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106938:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010693b:	0f 01 18             	lidtl  (%eax)
}
8010693e:	90                   	nop
8010693f:	c9                   	leave  
80106940:	c3                   	ret    

80106941 <rcr2>:

static inline uint
rcr2(void)
{
80106941:	55                   	push   %ebp
80106942:	89 e5                	mov    %esp,%ebp
80106944:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106947:	0f 20 d0             	mov    %cr2,%eax
8010694a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010694d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106950:	c9                   	leave  
80106951:	c3                   	ret    

80106952 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106952:	f3 0f 1e fb          	endbr32 
80106956:	55                   	push   %ebp
80106957:	89 e5                	mov    %esp,%ebp
80106959:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010695c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106963:	e9 c3 00 00 00       	jmp    80106a2b <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010696b:	8b 04 85 7c b0 10 80 	mov    -0x7fef4f84(,%eax,4),%eax
80106972:	89 c2                	mov    %eax,%edx
80106974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106977:	66 89 14 c5 20 5d 11 	mov    %dx,-0x7feea2e0(,%eax,8)
8010697e:	80 
8010697f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106982:	66 c7 04 c5 22 5d 11 	movw   $0x8,-0x7feea2de(,%eax,8)
80106989:	80 08 00 
8010698c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010698f:	0f b6 14 c5 24 5d 11 	movzbl -0x7feea2dc(,%eax,8),%edx
80106996:	80 
80106997:	83 e2 e0             	and    $0xffffffe0,%edx
8010699a:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
801069a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069a4:	0f b6 14 c5 24 5d 11 	movzbl -0x7feea2dc(,%eax,8),%edx
801069ab:	80 
801069ac:	83 e2 1f             	and    $0x1f,%edx
801069af:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
801069b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069b9:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
801069c0:	80 
801069c1:	83 e2 f0             	and    $0xfffffff0,%edx
801069c4:	83 ca 0e             	or     $0xe,%edx
801069c7:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
801069ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d1:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
801069d8:	80 
801069d9:	83 e2 ef             	and    $0xffffffef,%edx
801069dc:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
801069e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069e6:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
801069ed:	80 
801069ee:	83 e2 9f             	and    $0xffffff9f,%edx
801069f1:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
801069f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069fb:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
80106a02:	80 
80106a03:	83 ca 80             	or     $0xffffff80,%edx
80106a06:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
80106a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a10:	8b 04 85 7c b0 10 80 	mov    -0x7fef4f84(,%eax,4),%eax
80106a17:	c1 e8 10             	shr    $0x10,%eax
80106a1a:	89 c2                	mov    %eax,%edx
80106a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a1f:	66 89 14 c5 26 5d 11 	mov    %dx,-0x7feea2da(,%eax,8)
80106a26:	80 
  for(i = 0; i < 256; i++)
80106a27:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106a2b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106a32:	0f 8e 30 ff ff ff    	jle    80106968 <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a38:	a1 7c b1 10 80       	mov    0x8010b17c,%eax
80106a3d:	66 a3 20 5f 11 80    	mov    %ax,0x80115f20
80106a43:	66 c7 05 22 5f 11 80 	movw   $0x8,0x80115f22
80106a4a:	08 00 
80106a4c:	0f b6 05 24 5f 11 80 	movzbl 0x80115f24,%eax
80106a53:	83 e0 e0             	and    $0xffffffe0,%eax
80106a56:	a2 24 5f 11 80       	mov    %al,0x80115f24
80106a5b:	0f b6 05 24 5f 11 80 	movzbl 0x80115f24,%eax
80106a62:	83 e0 1f             	and    $0x1f,%eax
80106a65:	a2 24 5f 11 80       	mov    %al,0x80115f24
80106a6a:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
80106a71:	83 c8 0f             	or     $0xf,%eax
80106a74:	a2 25 5f 11 80       	mov    %al,0x80115f25
80106a79:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
80106a80:	83 e0 ef             	and    $0xffffffef,%eax
80106a83:	a2 25 5f 11 80       	mov    %al,0x80115f25
80106a88:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
80106a8f:	83 c8 60             	or     $0x60,%eax
80106a92:	a2 25 5f 11 80       	mov    %al,0x80115f25
80106a97:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
80106a9e:	83 c8 80             	or     $0xffffff80,%eax
80106aa1:	a2 25 5f 11 80       	mov    %al,0x80115f25
80106aa6:	a1 7c b1 10 80       	mov    0x8010b17c,%eax
80106aab:	c1 e8 10             	shr    $0x10,%eax
80106aae:	66 a3 26 5f 11 80    	mov    %ax,0x80115f26

  initlock(&tickslock, "time");
80106ab4:	83 ec 08             	sub    $0x8,%esp
80106ab7:	68 e4 8b 10 80       	push   $0x80108be4
80106abc:	68 e0 5c 11 80       	push   $0x80115ce0
80106ac1:	e8 f2 e6 ff ff       	call   801051b8 <initlock>
80106ac6:	83 c4 10             	add    $0x10,%esp
}
80106ac9:	90                   	nop
80106aca:	c9                   	leave  
80106acb:	c3                   	ret    

80106acc <idtinit>:

void
idtinit(void)
{
80106acc:	f3 0f 1e fb          	endbr32 
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106ad3:	68 00 08 00 00       	push   $0x800
80106ad8:	68 20 5d 11 80       	push   $0x80115d20
80106add:	e8 35 fe ff ff       	call   80106917 <lidt>
80106ae2:	83 c4 08             	add    $0x8,%esp
}
80106ae5:	90                   	nop
80106ae6:	c9                   	leave  
80106ae7:	c3                   	ret    

80106ae8 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106ae8:	f3 0f 1e fb          	endbr32 
80106aec:	55                   	push   %ebp
80106aed:	89 e5                	mov    %esp,%ebp
80106aef:	57                   	push   %edi
80106af0:	56                   	push   %esi
80106af1:	53                   	push   %ebx
80106af2:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106af5:	8b 45 08             	mov    0x8(%ebp),%eax
80106af8:	8b 40 30             	mov    0x30(%eax),%eax
80106afb:	83 f8 40             	cmp    $0x40,%eax
80106afe:	75 3b                	jne    80106b3b <trap+0x53>
    if(myproc()->killed)
80106b00:	e8 97 d9 ff ff       	call   8010449c <myproc>
80106b05:	8b 40 24             	mov    0x24(%eax),%eax
80106b08:	85 c0                	test   %eax,%eax
80106b0a:	74 05                	je     80106b11 <trap+0x29>
      exit();
80106b0c:	e8 1b de ff ff       	call   8010492c <exit>
    myproc()->tf = tf;
80106b11:	e8 86 d9 ff ff       	call   8010449c <myproc>
80106b16:	8b 55 08             	mov    0x8(%ebp),%edx
80106b19:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106b1c:	e8 88 ed ff ff       	call   801058a9 <syscall>
    if(myproc()->killed)
80106b21:	e8 76 d9 ff ff       	call   8010449c <myproc>
80106b26:	8b 40 24             	mov    0x24(%eax),%eax
80106b29:	85 c0                	test   %eax,%eax
80106b2b:	0f 84 07 02 00 00    	je     80106d38 <trap+0x250>
      exit();
80106b31:	e8 f6 dd ff ff       	call   8010492c <exit>
    return;
80106b36:	e9 fd 01 00 00       	jmp    80106d38 <trap+0x250>
  }

  switch(tf->trapno){
80106b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3e:	8b 40 30             	mov    0x30(%eax),%eax
80106b41:	83 e8 20             	sub    $0x20,%eax
80106b44:	83 f8 1f             	cmp    $0x1f,%eax
80106b47:	0f 87 b6 00 00 00    	ja     80106c03 <trap+0x11b>
80106b4d:	8b 04 85 8c 8c 10 80 	mov    -0x7fef7374(,%eax,4),%eax
80106b54:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106b57:	e8 a5 d8 ff ff       	call   80104401 <cpuid>
80106b5c:	85 c0                	test   %eax,%eax
80106b5e:	75 3d                	jne    80106b9d <trap+0xb5>
      acquire(&tickslock);
80106b60:	83 ec 0c             	sub    $0xc,%esp
80106b63:	68 e0 5c 11 80       	push   $0x80115ce0
80106b68:	e8 71 e6 ff ff       	call   801051de <acquire>
80106b6d:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106b70:	a1 20 65 11 80       	mov    0x80116520,%eax
80106b75:	83 c0 01             	add    $0x1,%eax
80106b78:	a3 20 65 11 80       	mov    %eax,0x80116520
      wakeup(&ticks);
80106b7d:	83 ec 0c             	sub    $0xc,%esp
80106b80:	68 20 65 11 80       	push   $0x80116520
80106b85:	e8 da e2 ff ff       	call   80104e64 <wakeup>
80106b8a:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106b8d:	83 ec 0c             	sub    $0xc,%esp
80106b90:	68 e0 5c 11 80       	push   $0x80115ce0
80106b95:	e8 b6 e6 ff ff       	call   80105250 <release>
80106b9a:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106b9d:	e8 ef c5 ff ff       	call   80103191 <lapiceoi>
    break;
80106ba2:	e9 11 01 00 00       	jmp    80106cb8 <trap+0x1d0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106ba7:	e8 1a be ff ff       	call   801029c6 <ideintr>
    lapiceoi();
80106bac:	e8 e0 c5 ff ff       	call   80103191 <lapiceoi>
    break;
80106bb1:	e9 02 01 00 00       	jmp    80106cb8 <trap+0x1d0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106bb6:	e8 0c c4 ff ff       	call   80102fc7 <kbdintr>
    lapiceoi();
80106bbb:	e8 d1 c5 ff ff       	call   80103191 <lapiceoi>
    break;
80106bc0:	e9 f3 00 00 00       	jmp    80106cb8 <trap+0x1d0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106bc5:	e8 50 03 00 00       	call   80106f1a <uartintr>
    lapiceoi();
80106bca:	e8 c2 c5 ff ff       	call   80103191 <lapiceoi>
    break;
80106bcf:	e9 e4 00 00 00       	jmp    80106cb8 <trap+0x1d0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd7:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106bda:	8b 45 08             	mov    0x8(%ebp),%eax
80106bdd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106be1:	0f b7 d8             	movzwl %ax,%ebx
80106be4:	e8 18 d8 ff ff       	call   80104401 <cpuid>
80106be9:	56                   	push   %esi
80106bea:	53                   	push   %ebx
80106beb:	50                   	push   %eax
80106bec:	68 ec 8b 10 80       	push   $0x80108bec
80106bf1:	e8 22 98 ff ff       	call   80100418 <cprintf>
80106bf6:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106bf9:	e8 93 c5 ff ff       	call   80103191 <lapiceoi>
    break;
80106bfe:	e9 b5 00 00 00       	jmp    80106cb8 <trap+0x1d0>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106c03:	e8 94 d8 ff ff       	call   8010449c <myproc>
80106c08:	85 c0                	test   %eax,%eax
80106c0a:	74 11                	je     80106c1d <trap+0x135>
80106c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c13:	0f b7 c0             	movzwl %ax,%eax
80106c16:	83 e0 03             	and    $0x3,%eax
80106c19:	85 c0                	test   %eax,%eax
80106c1b:	75 39                	jne    80106c56 <trap+0x16e>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c1d:	e8 1f fd ff ff       	call   80106941 <rcr2>
80106c22:	89 c3                	mov    %eax,%ebx
80106c24:	8b 45 08             	mov    0x8(%ebp),%eax
80106c27:	8b 70 38             	mov    0x38(%eax),%esi
80106c2a:	e8 d2 d7 ff ff       	call   80104401 <cpuid>
80106c2f:	8b 55 08             	mov    0x8(%ebp),%edx
80106c32:	8b 52 30             	mov    0x30(%edx),%edx
80106c35:	83 ec 0c             	sub    $0xc,%esp
80106c38:	53                   	push   %ebx
80106c39:	56                   	push   %esi
80106c3a:	50                   	push   %eax
80106c3b:	52                   	push   %edx
80106c3c:	68 10 8c 10 80       	push   $0x80108c10
80106c41:	e8 d2 97 ff ff       	call   80100418 <cprintf>
80106c46:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106c49:	83 ec 0c             	sub    $0xc,%esp
80106c4c:	68 42 8c 10 80       	push   $0x80108c42
80106c51:	e8 7b 99 ff ff       	call   801005d1 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c56:	e8 e6 fc ff ff       	call   80106941 <rcr2>
80106c5b:	89 c6                	mov    %eax,%esi
80106c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c60:	8b 40 38             	mov    0x38(%eax),%eax
80106c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c66:	e8 96 d7 ff ff       	call   80104401 <cpuid>
80106c6b:	89 c3                	mov    %eax,%ebx
80106c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c70:	8b 48 34             	mov    0x34(%eax),%ecx
80106c73:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106c76:	8b 45 08             	mov    0x8(%ebp),%eax
80106c79:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106c7c:	e8 1b d8 ff ff       	call   8010449c <myproc>
80106c81:	8d 50 6c             	lea    0x6c(%eax),%edx
80106c84:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106c87:	e8 10 d8 ff ff       	call   8010449c <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c8c:	8b 40 10             	mov    0x10(%eax),%eax
80106c8f:	56                   	push   %esi
80106c90:	ff 75 e4             	pushl  -0x1c(%ebp)
80106c93:	53                   	push   %ebx
80106c94:	ff 75 e0             	pushl  -0x20(%ebp)
80106c97:	57                   	push   %edi
80106c98:	ff 75 dc             	pushl  -0x24(%ebp)
80106c9b:	50                   	push   %eax
80106c9c:	68 48 8c 10 80       	push   $0x80108c48
80106ca1:	e8 72 97 ff ff       	call   80100418 <cprintf>
80106ca6:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106ca9:	e8 ee d7 ff ff       	call   8010449c <myproc>
80106cae:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106cb5:	eb 01                	jmp    80106cb8 <trap+0x1d0>
    break;
80106cb7:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106cb8:	e8 df d7 ff ff       	call   8010449c <myproc>
80106cbd:	85 c0                	test   %eax,%eax
80106cbf:	74 23                	je     80106ce4 <trap+0x1fc>
80106cc1:	e8 d6 d7 ff ff       	call   8010449c <myproc>
80106cc6:	8b 40 24             	mov    0x24(%eax),%eax
80106cc9:	85 c0                	test   %eax,%eax
80106ccb:	74 17                	je     80106ce4 <trap+0x1fc>
80106ccd:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106cd4:	0f b7 c0             	movzwl %ax,%eax
80106cd7:	83 e0 03             	and    $0x3,%eax
80106cda:	83 f8 03             	cmp    $0x3,%eax
80106cdd:	75 05                	jne    80106ce4 <trap+0x1fc>
    exit();
80106cdf:	e8 48 dc ff ff       	call   8010492c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106ce4:	e8 b3 d7 ff ff       	call   8010449c <myproc>
80106ce9:	85 c0                	test   %eax,%eax
80106ceb:	74 1d                	je     80106d0a <trap+0x222>
80106ced:	e8 aa d7 ff ff       	call   8010449c <myproc>
80106cf2:	8b 40 0c             	mov    0xc(%eax),%eax
80106cf5:	83 f8 04             	cmp    $0x4,%eax
80106cf8:	75 10                	jne    80106d0a <trap+0x222>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80106cfd:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106d00:	83 f8 20             	cmp    $0x20,%eax
80106d03:	75 05                	jne    80106d0a <trap+0x222>
    yield();
80106d05:	e8 e3 df ff ff       	call   80104ced <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d0a:	e8 8d d7 ff ff       	call   8010449c <myproc>
80106d0f:	85 c0                	test   %eax,%eax
80106d11:	74 26                	je     80106d39 <trap+0x251>
80106d13:	e8 84 d7 ff ff       	call   8010449c <myproc>
80106d18:	8b 40 24             	mov    0x24(%eax),%eax
80106d1b:	85 c0                	test   %eax,%eax
80106d1d:	74 1a                	je     80106d39 <trap+0x251>
80106d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d22:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d26:	0f b7 c0             	movzwl %ax,%eax
80106d29:	83 e0 03             	and    $0x3,%eax
80106d2c:	83 f8 03             	cmp    $0x3,%eax
80106d2f:	75 08                	jne    80106d39 <trap+0x251>
    exit();
80106d31:	e8 f6 db ff ff       	call   8010492c <exit>
80106d36:	eb 01                	jmp    80106d39 <trap+0x251>
    return;
80106d38:	90                   	nop
}
80106d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d3c:	5b                   	pop    %ebx
80106d3d:	5e                   	pop    %esi
80106d3e:	5f                   	pop    %edi
80106d3f:	5d                   	pop    %ebp
80106d40:	c3                   	ret    

80106d41 <inb>:
{
80106d41:	55                   	push   %ebp
80106d42:	89 e5                	mov    %esp,%ebp
80106d44:	83 ec 14             	sub    $0x14,%esp
80106d47:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d4e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106d52:	89 c2                	mov    %eax,%edx
80106d54:	ec                   	in     (%dx),%al
80106d55:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106d58:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106d5c:	c9                   	leave  
80106d5d:	c3                   	ret    

80106d5e <outb>:
{
80106d5e:	55                   	push   %ebp
80106d5f:	89 e5                	mov    %esp,%ebp
80106d61:	83 ec 08             	sub    $0x8,%esp
80106d64:	8b 45 08             	mov    0x8(%ebp),%eax
80106d67:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d6a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106d6e:	89 d0                	mov    %edx,%eax
80106d70:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d73:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d77:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d7b:	ee                   	out    %al,(%dx)
}
80106d7c:	90                   	nop
80106d7d:	c9                   	leave  
80106d7e:	c3                   	ret    

80106d7f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106d7f:	f3 0f 1e fb          	endbr32 
80106d83:	55                   	push   %ebp
80106d84:	89 e5                	mov    %esp,%ebp
80106d86:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106d89:	6a 00                	push   $0x0
80106d8b:	68 fa 03 00 00       	push   $0x3fa
80106d90:	e8 c9 ff ff ff       	call   80106d5e <outb>
80106d95:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106d98:	68 80 00 00 00       	push   $0x80
80106d9d:	68 fb 03 00 00       	push   $0x3fb
80106da2:	e8 b7 ff ff ff       	call   80106d5e <outb>
80106da7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106daa:	6a 0c                	push   $0xc
80106dac:	68 f8 03 00 00       	push   $0x3f8
80106db1:	e8 a8 ff ff ff       	call   80106d5e <outb>
80106db6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106db9:	6a 00                	push   $0x0
80106dbb:	68 f9 03 00 00       	push   $0x3f9
80106dc0:	e8 99 ff ff ff       	call   80106d5e <outb>
80106dc5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106dc8:	6a 03                	push   $0x3
80106dca:	68 fb 03 00 00       	push   $0x3fb
80106dcf:	e8 8a ff ff ff       	call   80106d5e <outb>
80106dd4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106dd7:	6a 00                	push   $0x0
80106dd9:	68 fc 03 00 00       	push   $0x3fc
80106dde:	e8 7b ff ff ff       	call   80106d5e <outb>
80106de3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106de6:	6a 01                	push   $0x1
80106de8:	68 f9 03 00 00       	push   $0x3f9
80106ded:	e8 6c ff ff ff       	call   80106d5e <outb>
80106df2:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106df5:	68 fd 03 00 00       	push   $0x3fd
80106dfa:	e8 42 ff ff ff       	call   80106d41 <inb>
80106dff:	83 c4 04             	add    $0x4,%esp
80106e02:	3c ff                	cmp    $0xff,%al
80106e04:	74 61                	je     80106e67 <uartinit+0xe8>
    return;
  uart = 1;
80106e06:	c7 05 24 b6 10 80 01 	movl   $0x1,0x8010b624
80106e0d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106e10:	68 fa 03 00 00       	push   $0x3fa
80106e15:	e8 27 ff ff ff       	call   80106d41 <inb>
80106e1a:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106e1d:	68 f8 03 00 00       	push   $0x3f8
80106e22:	e8 1a ff ff ff       	call   80106d41 <inb>
80106e27:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106e2a:	83 ec 08             	sub    $0x8,%esp
80106e2d:	6a 00                	push   $0x0
80106e2f:	6a 04                	push   $0x4
80106e31:	e8 42 be ff ff       	call   80102c78 <ioapicenable>
80106e36:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e39:	c7 45 f4 0c 8d 10 80 	movl   $0x80108d0c,-0xc(%ebp)
80106e40:	eb 19                	jmp    80106e5b <uartinit+0xdc>
    uartputc(*p);
80106e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e45:	0f b6 00             	movzbl (%eax),%eax
80106e48:	0f be c0             	movsbl %al,%eax
80106e4b:	83 ec 0c             	sub    $0xc,%esp
80106e4e:	50                   	push   %eax
80106e4f:	e8 16 00 00 00       	call   80106e6a <uartputc>
80106e54:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106e57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e5e:	0f b6 00             	movzbl (%eax),%eax
80106e61:	84 c0                	test   %al,%al
80106e63:	75 dd                	jne    80106e42 <uartinit+0xc3>
80106e65:	eb 01                	jmp    80106e68 <uartinit+0xe9>
    return;
80106e67:	90                   	nop
}
80106e68:	c9                   	leave  
80106e69:	c3                   	ret    

80106e6a <uartputc>:

void
uartputc(int c)
{
80106e6a:	f3 0f 1e fb          	endbr32 
80106e6e:	55                   	push   %ebp
80106e6f:	89 e5                	mov    %esp,%ebp
80106e71:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106e74:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106e79:	85 c0                	test   %eax,%eax
80106e7b:	74 53                	je     80106ed0 <uartputc+0x66>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106e84:	eb 11                	jmp    80106e97 <uartputc+0x2d>
    microdelay(10);
80106e86:	83 ec 0c             	sub    $0xc,%esp
80106e89:	6a 0a                	push   $0xa
80106e8b:	e8 20 c3 ff ff       	call   801031b0 <microdelay>
80106e90:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e93:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e97:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106e9b:	7f 1a                	jg     80106eb7 <uartputc+0x4d>
80106e9d:	83 ec 0c             	sub    $0xc,%esp
80106ea0:	68 fd 03 00 00       	push   $0x3fd
80106ea5:	e8 97 fe ff ff       	call   80106d41 <inb>
80106eaa:	83 c4 10             	add    $0x10,%esp
80106ead:	0f b6 c0             	movzbl %al,%eax
80106eb0:	83 e0 20             	and    $0x20,%eax
80106eb3:	85 c0                	test   %eax,%eax
80106eb5:	74 cf                	je     80106e86 <uartputc+0x1c>
  outb(COM1+0, c);
80106eb7:	8b 45 08             	mov    0x8(%ebp),%eax
80106eba:	0f b6 c0             	movzbl %al,%eax
80106ebd:	83 ec 08             	sub    $0x8,%esp
80106ec0:	50                   	push   %eax
80106ec1:	68 f8 03 00 00       	push   $0x3f8
80106ec6:	e8 93 fe ff ff       	call   80106d5e <outb>
80106ecb:	83 c4 10             	add    $0x10,%esp
80106ece:	eb 01                	jmp    80106ed1 <uartputc+0x67>
    return;
80106ed0:	90                   	nop
}
80106ed1:	c9                   	leave  
80106ed2:	c3                   	ret    

80106ed3 <uartgetc>:

static int
uartgetc(void)
{
80106ed3:	f3 0f 1e fb          	endbr32 
80106ed7:	55                   	push   %ebp
80106ed8:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106eda:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106edf:	85 c0                	test   %eax,%eax
80106ee1:	75 07                	jne    80106eea <uartgetc+0x17>
    return -1;
80106ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ee8:	eb 2e                	jmp    80106f18 <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
80106eea:	68 fd 03 00 00       	push   $0x3fd
80106eef:	e8 4d fe ff ff       	call   80106d41 <inb>
80106ef4:	83 c4 04             	add    $0x4,%esp
80106ef7:	0f b6 c0             	movzbl %al,%eax
80106efa:	83 e0 01             	and    $0x1,%eax
80106efd:	85 c0                	test   %eax,%eax
80106eff:	75 07                	jne    80106f08 <uartgetc+0x35>
    return -1;
80106f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f06:	eb 10                	jmp    80106f18 <uartgetc+0x45>
  return inb(COM1+0);
80106f08:	68 f8 03 00 00       	push   $0x3f8
80106f0d:	e8 2f fe ff ff       	call   80106d41 <inb>
80106f12:	83 c4 04             	add    $0x4,%esp
80106f15:	0f b6 c0             	movzbl %al,%eax
}
80106f18:	c9                   	leave  
80106f19:	c3                   	ret    

80106f1a <uartintr>:

void
uartintr(void)
{
80106f1a:	f3 0f 1e fb          	endbr32 
80106f1e:	55                   	push   %ebp
80106f1f:	89 e5                	mov    %esp,%ebp
80106f21:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106f24:	83 ec 0c             	sub    $0xc,%esp
80106f27:	68 d3 6e 10 80       	push   $0x80106ed3
80106f2c:	e8 40 99 ff ff       	call   80100871 <consoleintr>
80106f31:	83 c4 10             	add    $0x10,%esp
}
80106f34:	90                   	nop
80106f35:	c9                   	leave  
80106f36:	c3                   	ret    

80106f37 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $0
80106f39:	6a 00                	push   $0x0
  jmp alltraps
80106f3b:	e9 b4 f9 ff ff       	jmp    801068f4 <alltraps>

80106f40 <vector1>:
.globl vector1
vector1:
  pushl $0
80106f40:	6a 00                	push   $0x0
  pushl $1
80106f42:	6a 01                	push   $0x1
  jmp alltraps
80106f44:	e9 ab f9 ff ff       	jmp    801068f4 <alltraps>

80106f49 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f49:	6a 00                	push   $0x0
  pushl $2
80106f4b:	6a 02                	push   $0x2
  jmp alltraps
80106f4d:	e9 a2 f9 ff ff       	jmp    801068f4 <alltraps>

80106f52 <vector3>:
.globl vector3
vector3:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $3
80106f54:	6a 03                	push   $0x3
  jmp alltraps
80106f56:	e9 99 f9 ff ff       	jmp    801068f4 <alltraps>

80106f5b <vector4>:
.globl vector4
vector4:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $4
80106f5d:	6a 04                	push   $0x4
  jmp alltraps
80106f5f:	e9 90 f9 ff ff       	jmp    801068f4 <alltraps>

80106f64 <vector5>:
.globl vector5
vector5:
  pushl $0
80106f64:	6a 00                	push   $0x0
  pushl $5
80106f66:	6a 05                	push   $0x5
  jmp alltraps
80106f68:	e9 87 f9 ff ff       	jmp    801068f4 <alltraps>

80106f6d <vector6>:
.globl vector6
vector6:
  pushl $0
80106f6d:	6a 00                	push   $0x0
  pushl $6
80106f6f:	6a 06                	push   $0x6
  jmp alltraps
80106f71:	e9 7e f9 ff ff       	jmp    801068f4 <alltraps>

80106f76 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $7
80106f78:	6a 07                	push   $0x7
  jmp alltraps
80106f7a:	e9 75 f9 ff ff       	jmp    801068f4 <alltraps>

80106f7f <vector8>:
.globl vector8
vector8:
  pushl $8
80106f7f:	6a 08                	push   $0x8
  jmp alltraps
80106f81:	e9 6e f9 ff ff       	jmp    801068f4 <alltraps>

80106f86 <vector9>:
.globl vector9
vector9:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $9
80106f88:	6a 09                	push   $0x9
  jmp alltraps
80106f8a:	e9 65 f9 ff ff       	jmp    801068f4 <alltraps>

80106f8f <vector10>:
.globl vector10
vector10:
  pushl $10
80106f8f:	6a 0a                	push   $0xa
  jmp alltraps
80106f91:	e9 5e f9 ff ff       	jmp    801068f4 <alltraps>

80106f96 <vector11>:
.globl vector11
vector11:
  pushl $11
80106f96:	6a 0b                	push   $0xb
  jmp alltraps
80106f98:	e9 57 f9 ff ff       	jmp    801068f4 <alltraps>

80106f9d <vector12>:
.globl vector12
vector12:
  pushl $12
80106f9d:	6a 0c                	push   $0xc
  jmp alltraps
80106f9f:	e9 50 f9 ff ff       	jmp    801068f4 <alltraps>

80106fa4 <vector13>:
.globl vector13
vector13:
  pushl $13
80106fa4:	6a 0d                	push   $0xd
  jmp alltraps
80106fa6:	e9 49 f9 ff ff       	jmp    801068f4 <alltraps>

80106fab <vector14>:
.globl vector14
vector14:
  pushl $14
80106fab:	6a 0e                	push   $0xe
  jmp alltraps
80106fad:	e9 42 f9 ff ff       	jmp    801068f4 <alltraps>

80106fb2 <vector15>:
.globl vector15
vector15:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $15
80106fb4:	6a 0f                	push   $0xf
  jmp alltraps
80106fb6:	e9 39 f9 ff ff       	jmp    801068f4 <alltraps>

80106fbb <vector16>:
.globl vector16
vector16:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $16
80106fbd:	6a 10                	push   $0x10
  jmp alltraps
80106fbf:	e9 30 f9 ff ff       	jmp    801068f4 <alltraps>

80106fc4 <vector17>:
.globl vector17
vector17:
  pushl $17
80106fc4:	6a 11                	push   $0x11
  jmp alltraps
80106fc6:	e9 29 f9 ff ff       	jmp    801068f4 <alltraps>

80106fcb <vector18>:
.globl vector18
vector18:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $18
80106fcd:	6a 12                	push   $0x12
  jmp alltraps
80106fcf:	e9 20 f9 ff ff       	jmp    801068f4 <alltraps>

80106fd4 <vector19>:
.globl vector19
vector19:
  pushl $0
80106fd4:	6a 00                	push   $0x0
  pushl $19
80106fd6:	6a 13                	push   $0x13
  jmp alltraps
80106fd8:	e9 17 f9 ff ff       	jmp    801068f4 <alltraps>

80106fdd <vector20>:
.globl vector20
vector20:
  pushl $0
80106fdd:	6a 00                	push   $0x0
  pushl $20
80106fdf:	6a 14                	push   $0x14
  jmp alltraps
80106fe1:	e9 0e f9 ff ff       	jmp    801068f4 <alltraps>

80106fe6 <vector21>:
.globl vector21
vector21:
  pushl $0
80106fe6:	6a 00                	push   $0x0
  pushl $21
80106fe8:	6a 15                	push   $0x15
  jmp alltraps
80106fea:	e9 05 f9 ff ff       	jmp    801068f4 <alltraps>

80106fef <vector22>:
.globl vector22
vector22:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $22
80106ff1:	6a 16                	push   $0x16
  jmp alltraps
80106ff3:	e9 fc f8 ff ff       	jmp    801068f4 <alltraps>

80106ff8 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ff8:	6a 00                	push   $0x0
  pushl $23
80106ffa:	6a 17                	push   $0x17
  jmp alltraps
80106ffc:	e9 f3 f8 ff ff       	jmp    801068f4 <alltraps>

80107001 <vector24>:
.globl vector24
vector24:
  pushl $0
80107001:	6a 00                	push   $0x0
  pushl $24
80107003:	6a 18                	push   $0x18
  jmp alltraps
80107005:	e9 ea f8 ff ff       	jmp    801068f4 <alltraps>

8010700a <vector25>:
.globl vector25
vector25:
  pushl $0
8010700a:	6a 00                	push   $0x0
  pushl $25
8010700c:	6a 19                	push   $0x19
  jmp alltraps
8010700e:	e9 e1 f8 ff ff       	jmp    801068f4 <alltraps>

80107013 <vector26>:
.globl vector26
vector26:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $26
80107015:	6a 1a                	push   $0x1a
  jmp alltraps
80107017:	e9 d8 f8 ff ff       	jmp    801068f4 <alltraps>

8010701c <vector27>:
.globl vector27
vector27:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $27
8010701e:	6a 1b                	push   $0x1b
  jmp alltraps
80107020:	e9 cf f8 ff ff       	jmp    801068f4 <alltraps>

80107025 <vector28>:
.globl vector28
vector28:
  pushl $0
80107025:	6a 00                	push   $0x0
  pushl $28
80107027:	6a 1c                	push   $0x1c
  jmp alltraps
80107029:	e9 c6 f8 ff ff       	jmp    801068f4 <alltraps>

8010702e <vector29>:
.globl vector29
vector29:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $29
80107030:	6a 1d                	push   $0x1d
  jmp alltraps
80107032:	e9 bd f8 ff ff       	jmp    801068f4 <alltraps>

80107037 <vector30>:
.globl vector30
vector30:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $30
80107039:	6a 1e                	push   $0x1e
  jmp alltraps
8010703b:	e9 b4 f8 ff ff       	jmp    801068f4 <alltraps>

80107040 <vector31>:
.globl vector31
vector31:
  pushl $0
80107040:	6a 00                	push   $0x0
  pushl $31
80107042:	6a 1f                	push   $0x1f
  jmp alltraps
80107044:	e9 ab f8 ff ff       	jmp    801068f4 <alltraps>

80107049 <vector32>:
.globl vector32
vector32:
  pushl $0
80107049:	6a 00                	push   $0x0
  pushl $32
8010704b:	6a 20                	push   $0x20
  jmp alltraps
8010704d:	e9 a2 f8 ff ff       	jmp    801068f4 <alltraps>

80107052 <vector33>:
.globl vector33
vector33:
  pushl $0
80107052:	6a 00                	push   $0x0
  pushl $33
80107054:	6a 21                	push   $0x21
  jmp alltraps
80107056:	e9 99 f8 ff ff       	jmp    801068f4 <alltraps>

8010705b <vector34>:
.globl vector34
vector34:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $34
8010705d:	6a 22                	push   $0x22
  jmp alltraps
8010705f:	e9 90 f8 ff ff       	jmp    801068f4 <alltraps>

80107064 <vector35>:
.globl vector35
vector35:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $35
80107066:	6a 23                	push   $0x23
  jmp alltraps
80107068:	e9 87 f8 ff ff       	jmp    801068f4 <alltraps>

8010706d <vector36>:
.globl vector36
vector36:
  pushl $0
8010706d:	6a 00                	push   $0x0
  pushl $36
8010706f:	6a 24                	push   $0x24
  jmp alltraps
80107071:	e9 7e f8 ff ff       	jmp    801068f4 <alltraps>

80107076 <vector37>:
.globl vector37
vector37:
  pushl $0
80107076:	6a 00                	push   $0x0
  pushl $37
80107078:	6a 25                	push   $0x25
  jmp alltraps
8010707a:	e9 75 f8 ff ff       	jmp    801068f4 <alltraps>

8010707f <vector38>:
.globl vector38
vector38:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $38
80107081:	6a 26                	push   $0x26
  jmp alltraps
80107083:	e9 6c f8 ff ff       	jmp    801068f4 <alltraps>

80107088 <vector39>:
.globl vector39
vector39:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $39
8010708a:	6a 27                	push   $0x27
  jmp alltraps
8010708c:	e9 63 f8 ff ff       	jmp    801068f4 <alltraps>

80107091 <vector40>:
.globl vector40
vector40:
  pushl $0
80107091:	6a 00                	push   $0x0
  pushl $40
80107093:	6a 28                	push   $0x28
  jmp alltraps
80107095:	e9 5a f8 ff ff       	jmp    801068f4 <alltraps>

8010709a <vector41>:
.globl vector41
vector41:
  pushl $0
8010709a:	6a 00                	push   $0x0
  pushl $41
8010709c:	6a 29                	push   $0x29
  jmp alltraps
8010709e:	e9 51 f8 ff ff       	jmp    801068f4 <alltraps>

801070a3 <vector42>:
.globl vector42
vector42:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $42
801070a5:	6a 2a                	push   $0x2a
  jmp alltraps
801070a7:	e9 48 f8 ff ff       	jmp    801068f4 <alltraps>

801070ac <vector43>:
.globl vector43
vector43:
  pushl $0
801070ac:	6a 00                	push   $0x0
  pushl $43
801070ae:	6a 2b                	push   $0x2b
  jmp alltraps
801070b0:	e9 3f f8 ff ff       	jmp    801068f4 <alltraps>

801070b5 <vector44>:
.globl vector44
vector44:
  pushl $0
801070b5:	6a 00                	push   $0x0
  pushl $44
801070b7:	6a 2c                	push   $0x2c
  jmp alltraps
801070b9:	e9 36 f8 ff ff       	jmp    801068f4 <alltraps>

801070be <vector45>:
.globl vector45
vector45:
  pushl $0
801070be:	6a 00                	push   $0x0
  pushl $45
801070c0:	6a 2d                	push   $0x2d
  jmp alltraps
801070c2:	e9 2d f8 ff ff       	jmp    801068f4 <alltraps>

801070c7 <vector46>:
.globl vector46
vector46:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $46
801070c9:	6a 2e                	push   $0x2e
  jmp alltraps
801070cb:	e9 24 f8 ff ff       	jmp    801068f4 <alltraps>

801070d0 <vector47>:
.globl vector47
vector47:
  pushl $0
801070d0:	6a 00                	push   $0x0
  pushl $47
801070d2:	6a 2f                	push   $0x2f
  jmp alltraps
801070d4:	e9 1b f8 ff ff       	jmp    801068f4 <alltraps>

801070d9 <vector48>:
.globl vector48
vector48:
  pushl $0
801070d9:	6a 00                	push   $0x0
  pushl $48
801070db:	6a 30                	push   $0x30
  jmp alltraps
801070dd:	e9 12 f8 ff ff       	jmp    801068f4 <alltraps>

801070e2 <vector49>:
.globl vector49
vector49:
  pushl $0
801070e2:	6a 00                	push   $0x0
  pushl $49
801070e4:	6a 31                	push   $0x31
  jmp alltraps
801070e6:	e9 09 f8 ff ff       	jmp    801068f4 <alltraps>

801070eb <vector50>:
.globl vector50
vector50:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $50
801070ed:	6a 32                	push   $0x32
  jmp alltraps
801070ef:	e9 00 f8 ff ff       	jmp    801068f4 <alltraps>

801070f4 <vector51>:
.globl vector51
vector51:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $51
801070f6:	6a 33                	push   $0x33
  jmp alltraps
801070f8:	e9 f7 f7 ff ff       	jmp    801068f4 <alltraps>

801070fd <vector52>:
.globl vector52
vector52:
  pushl $0
801070fd:	6a 00                	push   $0x0
  pushl $52
801070ff:	6a 34                	push   $0x34
  jmp alltraps
80107101:	e9 ee f7 ff ff       	jmp    801068f4 <alltraps>

80107106 <vector53>:
.globl vector53
vector53:
  pushl $0
80107106:	6a 00                	push   $0x0
  pushl $53
80107108:	6a 35                	push   $0x35
  jmp alltraps
8010710a:	e9 e5 f7 ff ff       	jmp    801068f4 <alltraps>

8010710f <vector54>:
.globl vector54
vector54:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $54
80107111:	6a 36                	push   $0x36
  jmp alltraps
80107113:	e9 dc f7 ff ff       	jmp    801068f4 <alltraps>

80107118 <vector55>:
.globl vector55
vector55:
  pushl $0
80107118:	6a 00                	push   $0x0
  pushl $55
8010711a:	6a 37                	push   $0x37
  jmp alltraps
8010711c:	e9 d3 f7 ff ff       	jmp    801068f4 <alltraps>

80107121 <vector56>:
.globl vector56
vector56:
  pushl $0
80107121:	6a 00                	push   $0x0
  pushl $56
80107123:	6a 38                	push   $0x38
  jmp alltraps
80107125:	e9 ca f7 ff ff       	jmp    801068f4 <alltraps>

8010712a <vector57>:
.globl vector57
vector57:
  pushl $0
8010712a:	6a 00                	push   $0x0
  pushl $57
8010712c:	6a 39                	push   $0x39
  jmp alltraps
8010712e:	e9 c1 f7 ff ff       	jmp    801068f4 <alltraps>

80107133 <vector58>:
.globl vector58
vector58:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $58
80107135:	6a 3a                	push   $0x3a
  jmp alltraps
80107137:	e9 b8 f7 ff ff       	jmp    801068f4 <alltraps>

8010713c <vector59>:
.globl vector59
vector59:
  pushl $0
8010713c:	6a 00                	push   $0x0
  pushl $59
8010713e:	6a 3b                	push   $0x3b
  jmp alltraps
80107140:	e9 af f7 ff ff       	jmp    801068f4 <alltraps>

80107145 <vector60>:
.globl vector60
vector60:
  pushl $0
80107145:	6a 00                	push   $0x0
  pushl $60
80107147:	6a 3c                	push   $0x3c
  jmp alltraps
80107149:	e9 a6 f7 ff ff       	jmp    801068f4 <alltraps>

8010714e <vector61>:
.globl vector61
vector61:
  pushl $0
8010714e:	6a 00                	push   $0x0
  pushl $61
80107150:	6a 3d                	push   $0x3d
  jmp alltraps
80107152:	e9 9d f7 ff ff       	jmp    801068f4 <alltraps>

80107157 <vector62>:
.globl vector62
vector62:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $62
80107159:	6a 3e                	push   $0x3e
  jmp alltraps
8010715b:	e9 94 f7 ff ff       	jmp    801068f4 <alltraps>

80107160 <vector63>:
.globl vector63
vector63:
  pushl $0
80107160:	6a 00                	push   $0x0
  pushl $63
80107162:	6a 3f                	push   $0x3f
  jmp alltraps
80107164:	e9 8b f7 ff ff       	jmp    801068f4 <alltraps>

80107169 <vector64>:
.globl vector64
vector64:
  pushl $0
80107169:	6a 00                	push   $0x0
  pushl $64
8010716b:	6a 40                	push   $0x40
  jmp alltraps
8010716d:	e9 82 f7 ff ff       	jmp    801068f4 <alltraps>

80107172 <vector65>:
.globl vector65
vector65:
  pushl $0
80107172:	6a 00                	push   $0x0
  pushl $65
80107174:	6a 41                	push   $0x41
  jmp alltraps
80107176:	e9 79 f7 ff ff       	jmp    801068f4 <alltraps>

8010717b <vector66>:
.globl vector66
vector66:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $66
8010717d:	6a 42                	push   $0x42
  jmp alltraps
8010717f:	e9 70 f7 ff ff       	jmp    801068f4 <alltraps>

80107184 <vector67>:
.globl vector67
vector67:
  pushl $0
80107184:	6a 00                	push   $0x0
  pushl $67
80107186:	6a 43                	push   $0x43
  jmp alltraps
80107188:	e9 67 f7 ff ff       	jmp    801068f4 <alltraps>

8010718d <vector68>:
.globl vector68
vector68:
  pushl $0
8010718d:	6a 00                	push   $0x0
  pushl $68
8010718f:	6a 44                	push   $0x44
  jmp alltraps
80107191:	e9 5e f7 ff ff       	jmp    801068f4 <alltraps>

80107196 <vector69>:
.globl vector69
vector69:
  pushl $0
80107196:	6a 00                	push   $0x0
  pushl $69
80107198:	6a 45                	push   $0x45
  jmp alltraps
8010719a:	e9 55 f7 ff ff       	jmp    801068f4 <alltraps>

8010719f <vector70>:
.globl vector70
vector70:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $70
801071a1:	6a 46                	push   $0x46
  jmp alltraps
801071a3:	e9 4c f7 ff ff       	jmp    801068f4 <alltraps>

801071a8 <vector71>:
.globl vector71
vector71:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $71
801071aa:	6a 47                	push   $0x47
  jmp alltraps
801071ac:	e9 43 f7 ff ff       	jmp    801068f4 <alltraps>

801071b1 <vector72>:
.globl vector72
vector72:
  pushl $0
801071b1:	6a 00                	push   $0x0
  pushl $72
801071b3:	6a 48                	push   $0x48
  jmp alltraps
801071b5:	e9 3a f7 ff ff       	jmp    801068f4 <alltraps>

801071ba <vector73>:
.globl vector73
vector73:
  pushl $0
801071ba:	6a 00                	push   $0x0
  pushl $73
801071bc:	6a 49                	push   $0x49
  jmp alltraps
801071be:	e9 31 f7 ff ff       	jmp    801068f4 <alltraps>

801071c3 <vector74>:
.globl vector74
vector74:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $74
801071c5:	6a 4a                	push   $0x4a
  jmp alltraps
801071c7:	e9 28 f7 ff ff       	jmp    801068f4 <alltraps>

801071cc <vector75>:
.globl vector75
vector75:
  pushl $0
801071cc:	6a 00                	push   $0x0
  pushl $75
801071ce:	6a 4b                	push   $0x4b
  jmp alltraps
801071d0:	e9 1f f7 ff ff       	jmp    801068f4 <alltraps>

801071d5 <vector76>:
.globl vector76
vector76:
  pushl $0
801071d5:	6a 00                	push   $0x0
  pushl $76
801071d7:	6a 4c                	push   $0x4c
  jmp alltraps
801071d9:	e9 16 f7 ff ff       	jmp    801068f4 <alltraps>

801071de <vector77>:
.globl vector77
vector77:
  pushl $0
801071de:	6a 00                	push   $0x0
  pushl $77
801071e0:	6a 4d                	push   $0x4d
  jmp alltraps
801071e2:	e9 0d f7 ff ff       	jmp    801068f4 <alltraps>

801071e7 <vector78>:
.globl vector78
vector78:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $78
801071e9:	6a 4e                	push   $0x4e
  jmp alltraps
801071eb:	e9 04 f7 ff ff       	jmp    801068f4 <alltraps>

801071f0 <vector79>:
.globl vector79
vector79:
  pushl $0
801071f0:	6a 00                	push   $0x0
  pushl $79
801071f2:	6a 4f                	push   $0x4f
  jmp alltraps
801071f4:	e9 fb f6 ff ff       	jmp    801068f4 <alltraps>

801071f9 <vector80>:
.globl vector80
vector80:
  pushl $0
801071f9:	6a 00                	push   $0x0
  pushl $80
801071fb:	6a 50                	push   $0x50
  jmp alltraps
801071fd:	e9 f2 f6 ff ff       	jmp    801068f4 <alltraps>

80107202 <vector81>:
.globl vector81
vector81:
  pushl $0
80107202:	6a 00                	push   $0x0
  pushl $81
80107204:	6a 51                	push   $0x51
  jmp alltraps
80107206:	e9 e9 f6 ff ff       	jmp    801068f4 <alltraps>

8010720b <vector82>:
.globl vector82
vector82:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $82
8010720d:	6a 52                	push   $0x52
  jmp alltraps
8010720f:	e9 e0 f6 ff ff       	jmp    801068f4 <alltraps>

80107214 <vector83>:
.globl vector83
vector83:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $83
80107216:	6a 53                	push   $0x53
  jmp alltraps
80107218:	e9 d7 f6 ff ff       	jmp    801068f4 <alltraps>

8010721d <vector84>:
.globl vector84
vector84:
  pushl $0
8010721d:	6a 00                	push   $0x0
  pushl $84
8010721f:	6a 54                	push   $0x54
  jmp alltraps
80107221:	e9 ce f6 ff ff       	jmp    801068f4 <alltraps>

80107226 <vector85>:
.globl vector85
vector85:
  pushl $0
80107226:	6a 00                	push   $0x0
  pushl $85
80107228:	6a 55                	push   $0x55
  jmp alltraps
8010722a:	e9 c5 f6 ff ff       	jmp    801068f4 <alltraps>

8010722f <vector86>:
.globl vector86
vector86:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $86
80107231:	6a 56                	push   $0x56
  jmp alltraps
80107233:	e9 bc f6 ff ff       	jmp    801068f4 <alltraps>

80107238 <vector87>:
.globl vector87
vector87:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $87
8010723a:	6a 57                	push   $0x57
  jmp alltraps
8010723c:	e9 b3 f6 ff ff       	jmp    801068f4 <alltraps>

80107241 <vector88>:
.globl vector88
vector88:
  pushl $0
80107241:	6a 00                	push   $0x0
  pushl $88
80107243:	6a 58                	push   $0x58
  jmp alltraps
80107245:	e9 aa f6 ff ff       	jmp    801068f4 <alltraps>

8010724a <vector89>:
.globl vector89
vector89:
  pushl $0
8010724a:	6a 00                	push   $0x0
  pushl $89
8010724c:	6a 59                	push   $0x59
  jmp alltraps
8010724e:	e9 a1 f6 ff ff       	jmp    801068f4 <alltraps>

80107253 <vector90>:
.globl vector90
vector90:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $90
80107255:	6a 5a                	push   $0x5a
  jmp alltraps
80107257:	e9 98 f6 ff ff       	jmp    801068f4 <alltraps>

8010725c <vector91>:
.globl vector91
vector91:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $91
8010725e:	6a 5b                	push   $0x5b
  jmp alltraps
80107260:	e9 8f f6 ff ff       	jmp    801068f4 <alltraps>

80107265 <vector92>:
.globl vector92
vector92:
  pushl $0
80107265:	6a 00                	push   $0x0
  pushl $92
80107267:	6a 5c                	push   $0x5c
  jmp alltraps
80107269:	e9 86 f6 ff ff       	jmp    801068f4 <alltraps>

8010726e <vector93>:
.globl vector93
vector93:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $93
80107270:	6a 5d                	push   $0x5d
  jmp alltraps
80107272:	e9 7d f6 ff ff       	jmp    801068f4 <alltraps>

80107277 <vector94>:
.globl vector94
vector94:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $94
80107279:	6a 5e                	push   $0x5e
  jmp alltraps
8010727b:	e9 74 f6 ff ff       	jmp    801068f4 <alltraps>

80107280 <vector95>:
.globl vector95
vector95:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $95
80107282:	6a 5f                	push   $0x5f
  jmp alltraps
80107284:	e9 6b f6 ff ff       	jmp    801068f4 <alltraps>

80107289 <vector96>:
.globl vector96
vector96:
  pushl $0
80107289:	6a 00                	push   $0x0
  pushl $96
8010728b:	6a 60                	push   $0x60
  jmp alltraps
8010728d:	e9 62 f6 ff ff       	jmp    801068f4 <alltraps>

80107292 <vector97>:
.globl vector97
vector97:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $97
80107294:	6a 61                	push   $0x61
  jmp alltraps
80107296:	e9 59 f6 ff ff       	jmp    801068f4 <alltraps>

8010729b <vector98>:
.globl vector98
vector98:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $98
8010729d:	6a 62                	push   $0x62
  jmp alltraps
8010729f:	e9 50 f6 ff ff       	jmp    801068f4 <alltraps>

801072a4 <vector99>:
.globl vector99
vector99:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $99
801072a6:	6a 63                	push   $0x63
  jmp alltraps
801072a8:	e9 47 f6 ff ff       	jmp    801068f4 <alltraps>

801072ad <vector100>:
.globl vector100
vector100:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $100
801072af:	6a 64                	push   $0x64
  jmp alltraps
801072b1:	e9 3e f6 ff ff       	jmp    801068f4 <alltraps>

801072b6 <vector101>:
.globl vector101
vector101:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $101
801072b8:	6a 65                	push   $0x65
  jmp alltraps
801072ba:	e9 35 f6 ff ff       	jmp    801068f4 <alltraps>

801072bf <vector102>:
.globl vector102
vector102:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $102
801072c1:	6a 66                	push   $0x66
  jmp alltraps
801072c3:	e9 2c f6 ff ff       	jmp    801068f4 <alltraps>

801072c8 <vector103>:
.globl vector103
vector103:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $103
801072ca:	6a 67                	push   $0x67
  jmp alltraps
801072cc:	e9 23 f6 ff ff       	jmp    801068f4 <alltraps>

801072d1 <vector104>:
.globl vector104
vector104:
  pushl $0
801072d1:	6a 00                	push   $0x0
  pushl $104
801072d3:	6a 68                	push   $0x68
  jmp alltraps
801072d5:	e9 1a f6 ff ff       	jmp    801068f4 <alltraps>

801072da <vector105>:
.globl vector105
vector105:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $105
801072dc:	6a 69                	push   $0x69
  jmp alltraps
801072de:	e9 11 f6 ff ff       	jmp    801068f4 <alltraps>

801072e3 <vector106>:
.globl vector106
vector106:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $106
801072e5:	6a 6a                	push   $0x6a
  jmp alltraps
801072e7:	e9 08 f6 ff ff       	jmp    801068f4 <alltraps>

801072ec <vector107>:
.globl vector107
vector107:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $107
801072ee:	6a 6b                	push   $0x6b
  jmp alltraps
801072f0:	e9 ff f5 ff ff       	jmp    801068f4 <alltraps>

801072f5 <vector108>:
.globl vector108
vector108:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $108
801072f7:	6a 6c                	push   $0x6c
  jmp alltraps
801072f9:	e9 f6 f5 ff ff       	jmp    801068f4 <alltraps>

801072fe <vector109>:
.globl vector109
vector109:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $109
80107300:	6a 6d                	push   $0x6d
  jmp alltraps
80107302:	e9 ed f5 ff ff       	jmp    801068f4 <alltraps>

80107307 <vector110>:
.globl vector110
vector110:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $110
80107309:	6a 6e                	push   $0x6e
  jmp alltraps
8010730b:	e9 e4 f5 ff ff       	jmp    801068f4 <alltraps>

80107310 <vector111>:
.globl vector111
vector111:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $111
80107312:	6a 6f                	push   $0x6f
  jmp alltraps
80107314:	e9 db f5 ff ff       	jmp    801068f4 <alltraps>

80107319 <vector112>:
.globl vector112
vector112:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $112
8010731b:	6a 70                	push   $0x70
  jmp alltraps
8010731d:	e9 d2 f5 ff ff       	jmp    801068f4 <alltraps>

80107322 <vector113>:
.globl vector113
vector113:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $113
80107324:	6a 71                	push   $0x71
  jmp alltraps
80107326:	e9 c9 f5 ff ff       	jmp    801068f4 <alltraps>

8010732b <vector114>:
.globl vector114
vector114:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $114
8010732d:	6a 72                	push   $0x72
  jmp alltraps
8010732f:	e9 c0 f5 ff ff       	jmp    801068f4 <alltraps>

80107334 <vector115>:
.globl vector115
vector115:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $115
80107336:	6a 73                	push   $0x73
  jmp alltraps
80107338:	e9 b7 f5 ff ff       	jmp    801068f4 <alltraps>

8010733d <vector116>:
.globl vector116
vector116:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $116
8010733f:	6a 74                	push   $0x74
  jmp alltraps
80107341:	e9 ae f5 ff ff       	jmp    801068f4 <alltraps>

80107346 <vector117>:
.globl vector117
vector117:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $117
80107348:	6a 75                	push   $0x75
  jmp alltraps
8010734a:	e9 a5 f5 ff ff       	jmp    801068f4 <alltraps>

8010734f <vector118>:
.globl vector118
vector118:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $118
80107351:	6a 76                	push   $0x76
  jmp alltraps
80107353:	e9 9c f5 ff ff       	jmp    801068f4 <alltraps>

80107358 <vector119>:
.globl vector119
vector119:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $119
8010735a:	6a 77                	push   $0x77
  jmp alltraps
8010735c:	e9 93 f5 ff ff       	jmp    801068f4 <alltraps>

80107361 <vector120>:
.globl vector120
vector120:
  pushl $0
80107361:	6a 00                	push   $0x0
  pushl $120
80107363:	6a 78                	push   $0x78
  jmp alltraps
80107365:	e9 8a f5 ff ff       	jmp    801068f4 <alltraps>

8010736a <vector121>:
.globl vector121
vector121:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $121
8010736c:	6a 79                	push   $0x79
  jmp alltraps
8010736e:	e9 81 f5 ff ff       	jmp    801068f4 <alltraps>

80107373 <vector122>:
.globl vector122
vector122:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $122
80107375:	6a 7a                	push   $0x7a
  jmp alltraps
80107377:	e9 78 f5 ff ff       	jmp    801068f4 <alltraps>

8010737c <vector123>:
.globl vector123
vector123:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $123
8010737e:	6a 7b                	push   $0x7b
  jmp alltraps
80107380:	e9 6f f5 ff ff       	jmp    801068f4 <alltraps>

80107385 <vector124>:
.globl vector124
vector124:
  pushl $0
80107385:	6a 00                	push   $0x0
  pushl $124
80107387:	6a 7c                	push   $0x7c
  jmp alltraps
80107389:	e9 66 f5 ff ff       	jmp    801068f4 <alltraps>

8010738e <vector125>:
.globl vector125
vector125:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $125
80107390:	6a 7d                	push   $0x7d
  jmp alltraps
80107392:	e9 5d f5 ff ff       	jmp    801068f4 <alltraps>

80107397 <vector126>:
.globl vector126
vector126:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $126
80107399:	6a 7e                	push   $0x7e
  jmp alltraps
8010739b:	e9 54 f5 ff ff       	jmp    801068f4 <alltraps>

801073a0 <vector127>:
.globl vector127
vector127:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $127
801073a2:	6a 7f                	push   $0x7f
  jmp alltraps
801073a4:	e9 4b f5 ff ff       	jmp    801068f4 <alltraps>

801073a9 <vector128>:
.globl vector128
vector128:
  pushl $0
801073a9:	6a 00                	push   $0x0
  pushl $128
801073ab:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801073b0:	e9 3f f5 ff ff       	jmp    801068f4 <alltraps>

801073b5 <vector129>:
.globl vector129
vector129:
  pushl $0
801073b5:	6a 00                	push   $0x0
  pushl $129
801073b7:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801073bc:	e9 33 f5 ff ff       	jmp    801068f4 <alltraps>

801073c1 <vector130>:
.globl vector130
vector130:
  pushl $0
801073c1:	6a 00                	push   $0x0
  pushl $130
801073c3:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801073c8:	e9 27 f5 ff ff       	jmp    801068f4 <alltraps>

801073cd <vector131>:
.globl vector131
vector131:
  pushl $0
801073cd:	6a 00                	push   $0x0
  pushl $131
801073cf:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801073d4:	e9 1b f5 ff ff       	jmp    801068f4 <alltraps>

801073d9 <vector132>:
.globl vector132
vector132:
  pushl $0
801073d9:	6a 00                	push   $0x0
  pushl $132
801073db:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801073e0:	e9 0f f5 ff ff       	jmp    801068f4 <alltraps>

801073e5 <vector133>:
.globl vector133
vector133:
  pushl $0
801073e5:	6a 00                	push   $0x0
  pushl $133
801073e7:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801073ec:	e9 03 f5 ff ff       	jmp    801068f4 <alltraps>

801073f1 <vector134>:
.globl vector134
vector134:
  pushl $0
801073f1:	6a 00                	push   $0x0
  pushl $134
801073f3:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801073f8:	e9 f7 f4 ff ff       	jmp    801068f4 <alltraps>

801073fd <vector135>:
.globl vector135
vector135:
  pushl $0
801073fd:	6a 00                	push   $0x0
  pushl $135
801073ff:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107404:	e9 eb f4 ff ff       	jmp    801068f4 <alltraps>

80107409 <vector136>:
.globl vector136
vector136:
  pushl $0
80107409:	6a 00                	push   $0x0
  pushl $136
8010740b:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107410:	e9 df f4 ff ff       	jmp    801068f4 <alltraps>

80107415 <vector137>:
.globl vector137
vector137:
  pushl $0
80107415:	6a 00                	push   $0x0
  pushl $137
80107417:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010741c:	e9 d3 f4 ff ff       	jmp    801068f4 <alltraps>

80107421 <vector138>:
.globl vector138
vector138:
  pushl $0
80107421:	6a 00                	push   $0x0
  pushl $138
80107423:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107428:	e9 c7 f4 ff ff       	jmp    801068f4 <alltraps>

8010742d <vector139>:
.globl vector139
vector139:
  pushl $0
8010742d:	6a 00                	push   $0x0
  pushl $139
8010742f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107434:	e9 bb f4 ff ff       	jmp    801068f4 <alltraps>

80107439 <vector140>:
.globl vector140
vector140:
  pushl $0
80107439:	6a 00                	push   $0x0
  pushl $140
8010743b:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107440:	e9 af f4 ff ff       	jmp    801068f4 <alltraps>

80107445 <vector141>:
.globl vector141
vector141:
  pushl $0
80107445:	6a 00                	push   $0x0
  pushl $141
80107447:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010744c:	e9 a3 f4 ff ff       	jmp    801068f4 <alltraps>

80107451 <vector142>:
.globl vector142
vector142:
  pushl $0
80107451:	6a 00                	push   $0x0
  pushl $142
80107453:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107458:	e9 97 f4 ff ff       	jmp    801068f4 <alltraps>

8010745d <vector143>:
.globl vector143
vector143:
  pushl $0
8010745d:	6a 00                	push   $0x0
  pushl $143
8010745f:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107464:	e9 8b f4 ff ff       	jmp    801068f4 <alltraps>

80107469 <vector144>:
.globl vector144
vector144:
  pushl $0
80107469:	6a 00                	push   $0x0
  pushl $144
8010746b:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107470:	e9 7f f4 ff ff       	jmp    801068f4 <alltraps>

80107475 <vector145>:
.globl vector145
vector145:
  pushl $0
80107475:	6a 00                	push   $0x0
  pushl $145
80107477:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010747c:	e9 73 f4 ff ff       	jmp    801068f4 <alltraps>

80107481 <vector146>:
.globl vector146
vector146:
  pushl $0
80107481:	6a 00                	push   $0x0
  pushl $146
80107483:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107488:	e9 67 f4 ff ff       	jmp    801068f4 <alltraps>

8010748d <vector147>:
.globl vector147
vector147:
  pushl $0
8010748d:	6a 00                	push   $0x0
  pushl $147
8010748f:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107494:	e9 5b f4 ff ff       	jmp    801068f4 <alltraps>

80107499 <vector148>:
.globl vector148
vector148:
  pushl $0
80107499:	6a 00                	push   $0x0
  pushl $148
8010749b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801074a0:	e9 4f f4 ff ff       	jmp    801068f4 <alltraps>

801074a5 <vector149>:
.globl vector149
vector149:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $149
801074a7:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801074ac:	e9 43 f4 ff ff       	jmp    801068f4 <alltraps>

801074b1 <vector150>:
.globl vector150
vector150:
  pushl $0
801074b1:	6a 00                	push   $0x0
  pushl $150
801074b3:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801074b8:	e9 37 f4 ff ff       	jmp    801068f4 <alltraps>

801074bd <vector151>:
.globl vector151
vector151:
  pushl $0
801074bd:	6a 00                	push   $0x0
  pushl $151
801074bf:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801074c4:	e9 2b f4 ff ff       	jmp    801068f4 <alltraps>

801074c9 <vector152>:
.globl vector152
vector152:
  pushl $0
801074c9:	6a 00                	push   $0x0
  pushl $152
801074cb:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801074d0:	e9 1f f4 ff ff       	jmp    801068f4 <alltraps>

801074d5 <vector153>:
.globl vector153
vector153:
  pushl $0
801074d5:	6a 00                	push   $0x0
  pushl $153
801074d7:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801074dc:	e9 13 f4 ff ff       	jmp    801068f4 <alltraps>

801074e1 <vector154>:
.globl vector154
vector154:
  pushl $0
801074e1:	6a 00                	push   $0x0
  pushl $154
801074e3:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801074e8:	e9 07 f4 ff ff       	jmp    801068f4 <alltraps>

801074ed <vector155>:
.globl vector155
vector155:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $155
801074ef:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801074f4:	e9 fb f3 ff ff       	jmp    801068f4 <alltraps>

801074f9 <vector156>:
.globl vector156
vector156:
  pushl $0
801074f9:	6a 00                	push   $0x0
  pushl $156
801074fb:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107500:	e9 ef f3 ff ff       	jmp    801068f4 <alltraps>

80107505 <vector157>:
.globl vector157
vector157:
  pushl $0
80107505:	6a 00                	push   $0x0
  pushl $157
80107507:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010750c:	e9 e3 f3 ff ff       	jmp    801068f4 <alltraps>

80107511 <vector158>:
.globl vector158
vector158:
  pushl $0
80107511:	6a 00                	push   $0x0
  pushl $158
80107513:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107518:	e9 d7 f3 ff ff       	jmp    801068f4 <alltraps>

8010751d <vector159>:
.globl vector159
vector159:
  pushl $0
8010751d:	6a 00                	push   $0x0
  pushl $159
8010751f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107524:	e9 cb f3 ff ff       	jmp    801068f4 <alltraps>

80107529 <vector160>:
.globl vector160
vector160:
  pushl $0
80107529:	6a 00                	push   $0x0
  pushl $160
8010752b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107530:	e9 bf f3 ff ff       	jmp    801068f4 <alltraps>

80107535 <vector161>:
.globl vector161
vector161:
  pushl $0
80107535:	6a 00                	push   $0x0
  pushl $161
80107537:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010753c:	e9 b3 f3 ff ff       	jmp    801068f4 <alltraps>

80107541 <vector162>:
.globl vector162
vector162:
  pushl $0
80107541:	6a 00                	push   $0x0
  pushl $162
80107543:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107548:	e9 a7 f3 ff ff       	jmp    801068f4 <alltraps>

8010754d <vector163>:
.globl vector163
vector163:
  pushl $0
8010754d:	6a 00                	push   $0x0
  pushl $163
8010754f:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107554:	e9 9b f3 ff ff       	jmp    801068f4 <alltraps>

80107559 <vector164>:
.globl vector164
vector164:
  pushl $0
80107559:	6a 00                	push   $0x0
  pushl $164
8010755b:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107560:	e9 8f f3 ff ff       	jmp    801068f4 <alltraps>

80107565 <vector165>:
.globl vector165
vector165:
  pushl $0
80107565:	6a 00                	push   $0x0
  pushl $165
80107567:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010756c:	e9 83 f3 ff ff       	jmp    801068f4 <alltraps>

80107571 <vector166>:
.globl vector166
vector166:
  pushl $0
80107571:	6a 00                	push   $0x0
  pushl $166
80107573:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107578:	e9 77 f3 ff ff       	jmp    801068f4 <alltraps>

8010757d <vector167>:
.globl vector167
vector167:
  pushl $0
8010757d:	6a 00                	push   $0x0
  pushl $167
8010757f:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107584:	e9 6b f3 ff ff       	jmp    801068f4 <alltraps>

80107589 <vector168>:
.globl vector168
vector168:
  pushl $0
80107589:	6a 00                	push   $0x0
  pushl $168
8010758b:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107590:	e9 5f f3 ff ff       	jmp    801068f4 <alltraps>

80107595 <vector169>:
.globl vector169
vector169:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $169
80107597:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010759c:	e9 53 f3 ff ff       	jmp    801068f4 <alltraps>

801075a1 <vector170>:
.globl vector170
vector170:
  pushl $0
801075a1:	6a 00                	push   $0x0
  pushl $170
801075a3:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801075a8:	e9 47 f3 ff ff       	jmp    801068f4 <alltraps>

801075ad <vector171>:
.globl vector171
vector171:
  pushl $0
801075ad:	6a 00                	push   $0x0
  pushl $171
801075af:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801075b4:	e9 3b f3 ff ff       	jmp    801068f4 <alltraps>

801075b9 <vector172>:
.globl vector172
vector172:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $172
801075bb:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801075c0:	e9 2f f3 ff ff       	jmp    801068f4 <alltraps>

801075c5 <vector173>:
.globl vector173
vector173:
  pushl $0
801075c5:	6a 00                	push   $0x0
  pushl $173
801075c7:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801075cc:	e9 23 f3 ff ff       	jmp    801068f4 <alltraps>

801075d1 <vector174>:
.globl vector174
vector174:
  pushl $0
801075d1:	6a 00                	push   $0x0
  pushl $174
801075d3:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801075d8:	e9 17 f3 ff ff       	jmp    801068f4 <alltraps>

801075dd <vector175>:
.globl vector175
vector175:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $175
801075df:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801075e4:	e9 0b f3 ff ff       	jmp    801068f4 <alltraps>

801075e9 <vector176>:
.globl vector176
vector176:
  pushl $0
801075e9:	6a 00                	push   $0x0
  pushl $176
801075eb:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801075f0:	e9 ff f2 ff ff       	jmp    801068f4 <alltraps>

801075f5 <vector177>:
.globl vector177
vector177:
  pushl $0
801075f5:	6a 00                	push   $0x0
  pushl $177
801075f7:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801075fc:	e9 f3 f2 ff ff       	jmp    801068f4 <alltraps>

80107601 <vector178>:
.globl vector178
vector178:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $178
80107603:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107608:	e9 e7 f2 ff ff       	jmp    801068f4 <alltraps>

8010760d <vector179>:
.globl vector179
vector179:
  pushl $0
8010760d:	6a 00                	push   $0x0
  pushl $179
8010760f:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107614:	e9 db f2 ff ff       	jmp    801068f4 <alltraps>

80107619 <vector180>:
.globl vector180
vector180:
  pushl $0
80107619:	6a 00                	push   $0x0
  pushl $180
8010761b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107620:	e9 cf f2 ff ff       	jmp    801068f4 <alltraps>

80107625 <vector181>:
.globl vector181
vector181:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $181
80107627:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010762c:	e9 c3 f2 ff ff       	jmp    801068f4 <alltraps>

80107631 <vector182>:
.globl vector182
vector182:
  pushl $0
80107631:	6a 00                	push   $0x0
  pushl $182
80107633:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107638:	e9 b7 f2 ff ff       	jmp    801068f4 <alltraps>

8010763d <vector183>:
.globl vector183
vector183:
  pushl $0
8010763d:	6a 00                	push   $0x0
  pushl $183
8010763f:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107644:	e9 ab f2 ff ff       	jmp    801068f4 <alltraps>

80107649 <vector184>:
.globl vector184
vector184:
  pushl $0
80107649:	6a 00                	push   $0x0
  pushl $184
8010764b:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107650:	e9 9f f2 ff ff       	jmp    801068f4 <alltraps>

80107655 <vector185>:
.globl vector185
vector185:
  pushl $0
80107655:	6a 00                	push   $0x0
  pushl $185
80107657:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010765c:	e9 93 f2 ff ff       	jmp    801068f4 <alltraps>

80107661 <vector186>:
.globl vector186
vector186:
  pushl $0
80107661:	6a 00                	push   $0x0
  pushl $186
80107663:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107668:	e9 87 f2 ff ff       	jmp    801068f4 <alltraps>

8010766d <vector187>:
.globl vector187
vector187:
  pushl $0
8010766d:	6a 00                	push   $0x0
  pushl $187
8010766f:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107674:	e9 7b f2 ff ff       	jmp    801068f4 <alltraps>

80107679 <vector188>:
.globl vector188
vector188:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $188
8010767b:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107680:	e9 6f f2 ff ff       	jmp    801068f4 <alltraps>

80107685 <vector189>:
.globl vector189
vector189:
  pushl $0
80107685:	6a 00                	push   $0x0
  pushl $189
80107687:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010768c:	e9 63 f2 ff ff       	jmp    801068f4 <alltraps>

80107691 <vector190>:
.globl vector190
vector190:
  pushl $0
80107691:	6a 00                	push   $0x0
  pushl $190
80107693:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107698:	e9 57 f2 ff ff       	jmp    801068f4 <alltraps>

8010769d <vector191>:
.globl vector191
vector191:
  pushl $0
8010769d:	6a 00                	push   $0x0
  pushl $191
8010769f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801076a4:	e9 4b f2 ff ff       	jmp    801068f4 <alltraps>

801076a9 <vector192>:
.globl vector192
vector192:
  pushl $0
801076a9:	6a 00                	push   $0x0
  pushl $192
801076ab:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801076b0:	e9 3f f2 ff ff       	jmp    801068f4 <alltraps>

801076b5 <vector193>:
.globl vector193
vector193:
  pushl $0
801076b5:	6a 00                	push   $0x0
  pushl $193
801076b7:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801076bc:	e9 33 f2 ff ff       	jmp    801068f4 <alltraps>

801076c1 <vector194>:
.globl vector194
vector194:
  pushl $0
801076c1:	6a 00                	push   $0x0
  pushl $194
801076c3:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801076c8:	e9 27 f2 ff ff       	jmp    801068f4 <alltraps>

801076cd <vector195>:
.globl vector195
vector195:
  pushl $0
801076cd:	6a 00                	push   $0x0
  pushl $195
801076cf:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801076d4:	e9 1b f2 ff ff       	jmp    801068f4 <alltraps>

801076d9 <vector196>:
.globl vector196
vector196:
  pushl $0
801076d9:	6a 00                	push   $0x0
  pushl $196
801076db:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801076e0:	e9 0f f2 ff ff       	jmp    801068f4 <alltraps>

801076e5 <vector197>:
.globl vector197
vector197:
  pushl $0
801076e5:	6a 00                	push   $0x0
  pushl $197
801076e7:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801076ec:	e9 03 f2 ff ff       	jmp    801068f4 <alltraps>

801076f1 <vector198>:
.globl vector198
vector198:
  pushl $0
801076f1:	6a 00                	push   $0x0
  pushl $198
801076f3:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801076f8:	e9 f7 f1 ff ff       	jmp    801068f4 <alltraps>

801076fd <vector199>:
.globl vector199
vector199:
  pushl $0
801076fd:	6a 00                	push   $0x0
  pushl $199
801076ff:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107704:	e9 eb f1 ff ff       	jmp    801068f4 <alltraps>

80107709 <vector200>:
.globl vector200
vector200:
  pushl $0
80107709:	6a 00                	push   $0x0
  pushl $200
8010770b:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107710:	e9 df f1 ff ff       	jmp    801068f4 <alltraps>

80107715 <vector201>:
.globl vector201
vector201:
  pushl $0
80107715:	6a 00                	push   $0x0
  pushl $201
80107717:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010771c:	e9 d3 f1 ff ff       	jmp    801068f4 <alltraps>

80107721 <vector202>:
.globl vector202
vector202:
  pushl $0
80107721:	6a 00                	push   $0x0
  pushl $202
80107723:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107728:	e9 c7 f1 ff ff       	jmp    801068f4 <alltraps>

8010772d <vector203>:
.globl vector203
vector203:
  pushl $0
8010772d:	6a 00                	push   $0x0
  pushl $203
8010772f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107734:	e9 bb f1 ff ff       	jmp    801068f4 <alltraps>

80107739 <vector204>:
.globl vector204
vector204:
  pushl $0
80107739:	6a 00                	push   $0x0
  pushl $204
8010773b:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107740:	e9 af f1 ff ff       	jmp    801068f4 <alltraps>

80107745 <vector205>:
.globl vector205
vector205:
  pushl $0
80107745:	6a 00                	push   $0x0
  pushl $205
80107747:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010774c:	e9 a3 f1 ff ff       	jmp    801068f4 <alltraps>

80107751 <vector206>:
.globl vector206
vector206:
  pushl $0
80107751:	6a 00                	push   $0x0
  pushl $206
80107753:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107758:	e9 97 f1 ff ff       	jmp    801068f4 <alltraps>

8010775d <vector207>:
.globl vector207
vector207:
  pushl $0
8010775d:	6a 00                	push   $0x0
  pushl $207
8010775f:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107764:	e9 8b f1 ff ff       	jmp    801068f4 <alltraps>

80107769 <vector208>:
.globl vector208
vector208:
  pushl $0
80107769:	6a 00                	push   $0x0
  pushl $208
8010776b:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107770:	e9 7f f1 ff ff       	jmp    801068f4 <alltraps>

80107775 <vector209>:
.globl vector209
vector209:
  pushl $0
80107775:	6a 00                	push   $0x0
  pushl $209
80107777:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010777c:	e9 73 f1 ff ff       	jmp    801068f4 <alltraps>

80107781 <vector210>:
.globl vector210
vector210:
  pushl $0
80107781:	6a 00                	push   $0x0
  pushl $210
80107783:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107788:	e9 67 f1 ff ff       	jmp    801068f4 <alltraps>

8010778d <vector211>:
.globl vector211
vector211:
  pushl $0
8010778d:	6a 00                	push   $0x0
  pushl $211
8010778f:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107794:	e9 5b f1 ff ff       	jmp    801068f4 <alltraps>

80107799 <vector212>:
.globl vector212
vector212:
  pushl $0
80107799:	6a 00                	push   $0x0
  pushl $212
8010779b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801077a0:	e9 4f f1 ff ff       	jmp    801068f4 <alltraps>

801077a5 <vector213>:
.globl vector213
vector213:
  pushl $0
801077a5:	6a 00                	push   $0x0
  pushl $213
801077a7:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801077ac:	e9 43 f1 ff ff       	jmp    801068f4 <alltraps>

801077b1 <vector214>:
.globl vector214
vector214:
  pushl $0
801077b1:	6a 00                	push   $0x0
  pushl $214
801077b3:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801077b8:	e9 37 f1 ff ff       	jmp    801068f4 <alltraps>

801077bd <vector215>:
.globl vector215
vector215:
  pushl $0
801077bd:	6a 00                	push   $0x0
  pushl $215
801077bf:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801077c4:	e9 2b f1 ff ff       	jmp    801068f4 <alltraps>

801077c9 <vector216>:
.globl vector216
vector216:
  pushl $0
801077c9:	6a 00                	push   $0x0
  pushl $216
801077cb:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801077d0:	e9 1f f1 ff ff       	jmp    801068f4 <alltraps>

801077d5 <vector217>:
.globl vector217
vector217:
  pushl $0
801077d5:	6a 00                	push   $0x0
  pushl $217
801077d7:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801077dc:	e9 13 f1 ff ff       	jmp    801068f4 <alltraps>

801077e1 <vector218>:
.globl vector218
vector218:
  pushl $0
801077e1:	6a 00                	push   $0x0
  pushl $218
801077e3:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801077e8:	e9 07 f1 ff ff       	jmp    801068f4 <alltraps>

801077ed <vector219>:
.globl vector219
vector219:
  pushl $0
801077ed:	6a 00                	push   $0x0
  pushl $219
801077ef:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801077f4:	e9 fb f0 ff ff       	jmp    801068f4 <alltraps>

801077f9 <vector220>:
.globl vector220
vector220:
  pushl $0
801077f9:	6a 00                	push   $0x0
  pushl $220
801077fb:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107800:	e9 ef f0 ff ff       	jmp    801068f4 <alltraps>

80107805 <vector221>:
.globl vector221
vector221:
  pushl $0
80107805:	6a 00                	push   $0x0
  pushl $221
80107807:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010780c:	e9 e3 f0 ff ff       	jmp    801068f4 <alltraps>

80107811 <vector222>:
.globl vector222
vector222:
  pushl $0
80107811:	6a 00                	push   $0x0
  pushl $222
80107813:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107818:	e9 d7 f0 ff ff       	jmp    801068f4 <alltraps>

8010781d <vector223>:
.globl vector223
vector223:
  pushl $0
8010781d:	6a 00                	push   $0x0
  pushl $223
8010781f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107824:	e9 cb f0 ff ff       	jmp    801068f4 <alltraps>

80107829 <vector224>:
.globl vector224
vector224:
  pushl $0
80107829:	6a 00                	push   $0x0
  pushl $224
8010782b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107830:	e9 bf f0 ff ff       	jmp    801068f4 <alltraps>

80107835 <vector225>:
.globl vector225
vector225:
  pushl $0
80107835:	6a 00                	push   $0x0
  pushl $225
80107837:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010783c:	e9 b3 f0 ff ff       	jmp    801068f4 <alltraps>

80107841 <vector226>:
.globl vector226
vector226:
  pushl $0
80107841:	6a 00                	push   $0x0
  pushl $226
80107843:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107848:	e9 a7 f0 ff ff       	jmp    801068f4 <alltraps>

8010784d <vector227>:
.globl vector227
vector227:
  pushl $0
8010784d:	6a 00                	push   $0x0
  pushl $227
8010784f:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107854:	e9 9b f0 ff ff       	jmp    801068f4 <alltraps>

80107859 <vector228>:
.globl vector228
vector228:
  pushl $0
80107859:	6a 00                	push   $0x0
  pushl $228
8010785b:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107860:	e9 8f f0 ff ff       	jmp    801068f4 <alltraps>

80107865 <vector229>:
.globl vector229
vector229:
  pushl $0
80107865:	6a 00                	push   $0x0
  pushl $229
80107867:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010786c:	e9 83 f0 ff ff       	jmp    801068f4 <alltraps>

80107871 <vector230>:
.globl vector230
vector230:
  pushl $0
80107871:	6a 00                	push   $0x0
  pushl $230
80107873:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107878:	e9 77 f0 ff ff       	jmp    801068f4 <alltraps>

8010787d <vector231>:
.globl vector231
vector231:
  pushl $0
8010787d:	6a 00                	push   $0x0
  pushl $231
8010787f:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107884:	e9 6b f0 ff ff       	jmp    801068f4 <alltraps>

80107889 <vector232>:
.globl vector232
vector232:
  pushl $0
80107889:	6a 00                	push   $0x0
  pushl $232
8010788b:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107890:	e9 5f f0 ff ff       	jmp    801068f4 <alltraps>

80107895 <vector233>:
.globl vector233
vector233:
  pushl $0
80107895:	6a 00                	push   $0x0
  pushl $233
80107897:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010789c:	e9 53 f0 ff ff       	jmp    801068f4 <alltraps>

801078a1 <vector234>:
.globl vector234
vector234:
  pushl $0
801078a1:	6a 00                	push   $0x0
  pushl $234
801078a3:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801078a8:	e9 47 f0 ff ff       	jmp    801068f4 <alltraps>

801078ad <vector235>:
.globl vector235
vector235:
  pushl $0
801078ad:	6a 00                	push   $0x0
  pushl $235
801078af:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801078b4:	e9 3b f0 ff ff       	jmp    801068f4 <alltraps>

801078b9 <vector236>:
.globl vector236
vector236:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $236
801078bb:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801078c0:	e9 2f f0 ff ff       	jmp    801068f4 <alltraps>

801078c5 <vector237>:
.globl vector237
vector237:
  pushl $0
801078c5:	6a 00                	push   $0x0
  pushl $237
801078c7:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801078cc:	e9 23 f0 ff ff       	jmp    801068f4 <alltraps>

801078d1 <vector238>:
.globl vector238
vector238:
  pushl $0
801078d1:	6a 00                	push   $0x0
  pushl $238
801078d3:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801078d8:	e9 17 f0 ff ff       	jmp    801068f4 <alltraps>

801078dd <vector239>:
.globl vector239
vector239:
  pushl $0
801078dd:	6a 00                	push   $0x0
  pushl $239
801078df:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801078e4:	e9 0b f0 ff ff       	jmp    801068f4 <alltraps>

801078e9 <vector240>:
.globl vector240
vector240:
  pushl $0
801078e9:	6a 00                	push   $0x0
  pushl $240
801078eb:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801078f0:	e9 ff ef ff ff       	jmp    801068f4 <alltraps>

801078f5 <vector241>:
.globl vector241
vector241:
  pushl $0
801078f5:	6a 00                	push   $0x0
  pushl $241
801078f7:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801078fc:	e9 f3 ef ff ff       	jmp    801068f4 <alltraps>

80107901 <vector242>:
.globl vector242
vector242:
  pushl $0
80107901:	6a 00                	push   $0x0
  pushl $242
80107903:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107908:	e9 e7 ef ff ff       	jmp    801068f4 <alltraps>

8010790d <vector243>:
.globl vector243
vector243:
  pushl $0
8010790d:	6a 00                	push   $0x0
  pushl $243
8010790f:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107914:	e9 db ef ff ff       	jmp    801068f4 <alltraps>

80107919 <vector244>:
.globl vector244
vector244:
  pushl $0
80107919:	6a 00                	push   $0x0
  pushl $244
8010791b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107920:	e9 cf ef ff ff       	jmp    801068f4 <alltraps>

80107925 <vector245>:
.globl vector245
vector245:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $245
80107927:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010792c:	e9 c3 ef ff ff       	jmp    801068f4 <alltraps>

80107931 <vector246>:
.globl vector246
vector246:
  pushl $0
80107931:	6a 00                	push   $0x0
  pushl $246
80107933:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107938:	e9 b7 ef ff ff       	jmp    801068f4 <alltraps>

8010793d <vector247>:
.globl vector247
vector247:
  pushl $0
8010793d:	6a 00                	push   $0x0
  pushl $247
8010793f:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107944:	e9 ab ef ff ff       	jmp    801068f4 <alltraps>

80107949 <vector248>:
.globl vector248
vector248:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $248
8010794b:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107950:	e9 9f ef ff ff       	jmp    801068f4 <alltraps>

80107955 <vector249>:
.globl vector249
vector249:
  pushl $0
80107955:	6a 00                	push   $0x0
  pushl $249
80107957:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010795c:	e9 93 ef ff ff       	jmp    801068f4 <alltraps>

80107961 <vector250>:
.globl vector250
vector250:
  pushl $0
80107961:	6a 00                	push   $0x0
  pushl $250
80107963:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107968:	e9 87 ef ff ff       	jmp    801068f4 <alltraps>

8010796d <vector251>:
.globl vector251
vector251:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $251
8010796f:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107974:	e9 7b ef ff ff       	jmp    801068f4 <alltraps>

80107979 <vector252>:
.globl vector252
vector252:
  pushl $0
80107979:	6a 00                	push   $0x0
  pushl $252
8010797b:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107980:	e9 6f ef ff ff       	jmp    801068f4 <alltraps>

80107985 <vector253>:
.globl vector253
vector253:
  pushl $0
80107985:	6a 00                	push   $0x0
  pushl $253
80107987:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010798c:	e9 63 ef ff ff       	jmp    801068f4 <alltraps>

80107991 <vector254>:
.globl vector254
vector254:
  pushl $0
80107991:	6a 00                	push   $0x0
  pushl $254
80107993:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107998:	e9 57 ef ff ff       	jmp    801068f4 <alltraps>

8010799d <vector255>:
.globl vector255
vector255:
  pushl $0
8010799d:	6a 00                	push   $0x0
  pushl $255
8010799f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801079a4:	e9 4b ef ff ff       	jmp    801068f4 <alltraps>

801079a9 <lgdt>:
{
801079a9:	55                   	push   %ebp
801079aa:	89 e5                	mov    %esp,%ebp
801079ac:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801079af:	8b 45 0c             	mov    0xc(%ebp),%eax
801079b2:	83 e8 01             	sub    $0x1,%eax
801079b5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801079b9:	8b 45 08             	mov    0x8(%ebp),%eax
801079bc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801079c0:	8b 45 08             	mov    0x8(%ebp),%eax
801079c3:	c1 e8 10             	shr    $0x10,%eax
801079c6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801079ca:	8d 45 fa             	lea    -0x6(%ebp),%eax
801079cd:	0f 01 10             	lgdtl  (%eax)
}
801079d0:	90                   	nop
801079d1:	c9                   	leave  
801079d2:	c3                   	ret    

801079d3 <ltr>:
{
801079d3:	55                   	push   %ebp
801079d4:	89 e5                	mov    %esp,%ebp
801079d6:	83 ec 04             	sub    $0x4,%esp
801079d9:	8b 45 08             	mov    0x8(%ebp),%eax
801079dc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801079e0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801079e4:	0f 00 d8             	ltr    %ax
}
801079e7:	90                   	nop
801079e8:	c9                   	leave  
801079e9:	c3                   	ret    

801079ea <lcr3>:

static inline void
lcr3(uint val)
{
801079ea:	55                   	push   %ebp
801079eb:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079ed:	8b 45 08             	mov    0x8(%ebp),%eax
801079f0:	0f 22 d8             	mov    %eax,%cr3
}
801079f3:	90                   	nop
801079f4:	5d                   	pop    %ebp
801079f5:	c3                   	ret    

801079f6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801079f6:	f3 0f 1e fb          	endbr32 
801079fa:	55                   	push   %ebp
801079fb:	89 e5                	mov    %esp,%ebp
801079fd:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107a00:	e8 fc c9 ff ff       	call   80104401 <cpuid>
80107a05:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107a0b:	05 00 38 11 80       	add    $0x80113800,%eax
80107a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a16:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a28:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a33:	83 e2 f0             	and    $0xfffffff0,%edx
80107a36:	83 ca 0a             	or     $0xa,%edx
80107a39:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a43:	83 ca 10             	or     $0x10,%edx
80107a46:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a50:	83 e2 9f             	and    $0xffffff9f,%edx
80107a53:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a59:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a5d:	83 ca 80             	or     $0xffffff80,%edx
80107a60:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a66:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a6a:	83 ca 0f             	or     $0xf,%edx
80107a6d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a73:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a77:	83 e2 ef             	and    $0xffffffef,%edx
80107a7a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a80:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a84:	83 e2 df             	and    $0xffffffdf,%edx
80107a87:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a91:	83 ca 40             	or     $0x40,%edx
80107a94:	88 50 7e             	mov    %dl,0x7e(%eax)
80107a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107a9e:	83 ca 80             	or     $0xffffff80,%edx
80107aa1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa7:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aae:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107ab5:	ff ff 
80107ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aba:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107ac1:	00 00 
80107ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac6:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ad7:	83 e2 f0             	and    $0xfffffff0,%edx
80107ada:	83 ca 02             	or     $0x2,%edx
80107add:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107aed:	83 ca 10             	or     $0x10,%edx
80107af0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b00:	83 e2 9f             	and    $0xffffff9f,%edx
80107b03:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b13:	83 ca 80             	or     $0xffffff80,%edx
80107b16:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b26:	83 ca 0f             	or     $0xf,%edx
80107b29:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b32:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b39:	83 e2 ef             	and    $0xffffffef,%edx
80107b3c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b45:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b4c:	83 e2 df             	and    $0xffffffdf,%edx
80107b4f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b58:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b5f:	83 ca 40             	or     $0x40,%edx
80107b62:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b72:	83 ca 80             	or     $0xffffff80,%edx
80107b75:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b88:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107b8f:	ff ff 
80107b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b94:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107b9b:	00 00 
80107b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba0:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107baa:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107bb1:	83 e2 f0             	and    $0xfffffff0,%edx
80107bb4:	83 ca 0a             	or     $0xa,%edx
80107bb7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107bc7:	83 ca 10             	or     $0x10,%edx
80107bca:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107bda:	83 ca 60             	or     $0x60,%edx
80107bdd:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107bed:	83 ca 80             	or     $0xffffff80,%edx
80107bf0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c00:	83 ca 0f             	or     $0xf,%edx
80107c03:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c13:	83 e2 ef             	and    $0xffffffef,%edx
80107c16:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c26:	83 e2 df             	and    $0xffffffdf,%edx
80107c29:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c32:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c39:	83 ca 40             	or     $0x40,%edx
80107c3c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c45:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c4c:	83 ca 80             	or     $0xffffff80,%edx
80107c4f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c58:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c62:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107c69:	ff ff 
80107c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6e:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107c75:	00 00 
80107c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7a:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c84:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c8b:	83 e2 f0             	and    $0xfffffff0,%edx
80107c8e:	83 ca 02             	or     $0x2,%edx
80107c91:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ca1:	83 ca 10             	or     $0x10,%edx
80107ca4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cad:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107cb4:	83 ca 60             	or     $0x60,%edx
80107cb7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107cc7:	83 ca 80             	or     $0xffffff80,%edx
80107cca:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107cda:	83 ca 0f             	or     $0xf,%edx
80107cdd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ced:	83 e2 ef             	and    $0xffffffef,%edx
80107cf0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d00:	83 e2 df             	and    $0xffffffdf,%edx
80107d03:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d13:	83 ca 40             	or     $0x40,%edx
80107d16:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107d26:	83 ca 80             	or     $0xffffff80,%edx
80107d29:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d32:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3c:	83 c0 70             	add    $0x70,%eax
80107d3f:	83 ec 08             	sub    $0x8,%esp
80107d42:	6a 30                	push   $0x30
80107d44:	50                   	push   %eax
80107d45:	e8 5f fc ff ff       	call   801079a9 <lgdt>
80107d4a:	83 c4 10             	add    $0x10,%esp
}
80107d4d:	90                   	nop
80107d4e:	c9                   	leave  
80107d4f:	c3                   	ret    

80107d50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107d50:	f3 0f 1e fb          	endbr32 
80107d54:	55                   	push   %ebp
80107d55:	89 e5                	mov    %esp,%ebp
80107d57:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d5d:	c1 e8 16             	shr    $0x16,%eax
80107d60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d67:	8b 45 08             	mov    0x8(%ebp),%eax
80107d6a:	01 d0                	add    %edx,%eax
80107d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d72:	8b 00                	mov    (%eax),%eax
80107d74:	83 e0 01             	and    $0x1,%eax
80107d77:	85 c0                	test   %eax,%eax
80107d79:	74 14                	je     80107d8f <walkpgdir+0x3f>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d7e:	8b 00                	mov    (%eax),%eax
80107d80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d85:	05 00 00 00 80       	add    $0x80000000,%eax
80107d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d8d:	eb 42                	jmp    80107dd1 <walkpgdir+0x81>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107d93:	74 0e                	je     80107da3 <walkpgdir+0x53>
80107d95:	e8 64 b0 ff ff       	call   80102dfe <kalloc>
80107d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107da1:	75 07                	jne    80107daa <walkpgdir+0x5a>
      return 0;
80107da3:	b8 00 00 00 00       	mov    $0x0,%eax
80107da8:	eb 3e                	jmp    80107de8 <walkpgdir+0x98>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107daa:	83 ec 04             	sub    $0x4,%esp
80107dad:	68 00 10 00 00       	push   $0x1000
80107db2:	6a 00                	push   $0x0
80107db4:	ff 75 f4             	pushl  -0xc(%ebp)
80107db7:	e8 c1 d6 ff ff       	call   8010547d <memset>
80107dbc:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc2:	05 00 00 00 80       	add    $0x80000000,%eax
80107dc7:	83 c8 07             	or     $0x7,%eax
80107dca:	89 c2                	mov    %eax,%edx
80107dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dcf:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dd4:	c1 e8 0c             	shr    $0xc,%eax
80107dd7:	25 ff 03 00 00       	and    $0x3ff,%eax
80107ddc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de6:	01 d0                	add    %edx,%eax
}
80107de8:	c9                   	leave  
80107de9:	c3                   	ret    

80107dea <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107dea:	f3 0f 1e fb          	endbr32 
80107dee:	55                   	push   %ebp
80107def:	89 e5                	mov    %esp,%ebp
80107df1:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107df4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107df7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107dff:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e02:	8b 45 10             	mov    0x10(%ebp),%eax
80107e05:	01 d0                	add    %edx,%eax
80107e07:	83 e8 01             	sub    $0x1,%eax
80107e0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107e12:	83 ec 04             	sub    $0x4,%esp
80107e15:	6a 01                	push   $0x1
80107e17:	ff 75 f4             	pushl  -0xc(%ebp)
80107e1a:	ff 75 08             	pushl  0x8(%ebp)
80107e1d:	e8 2e ff ff ff       	call   80107d50 <walkpgdir>
80107e22:	83 c4 10             	add    $0x10,%esp
80107e25:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107e28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e2c:	75 07                	jne    80107e35 <mappages+0x4b>
      return -1;
80107e2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e33:	eb 47                	jmp    80107e7c <mappages+0x92>
    if(*pte & PTE_P)
80107e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e38:	8b 00                	mov    (%eax),%eax
80107e3a:	83 e0 01             	and    $0x1,%eax
80107e3d:	85 c0                	test   %eax,%eax
80107e3f:	74 0d                	je     80107e4e <mappages+0x64>
      panic("remap");
80107e41:	83 ec 0c             	sub    $0xc,%esp
80107e44:	68 14 8d 10 80       	push   $0x80108d14
80107e49:	e8 83 87 ff ff       	call   801005d1 <panic>
    *pte = pa | perm | PTE_P;
80107e4e:	8b 45 18             	mov    0x18(%ebp),%eax
80107e51:	0b 45 14             	or     0x14(%ebp),%eax
80107e54:	83 c8 01             	or     $0x1,%eax
80107e57:	89 c2                	mov    %eax,%edx
80107e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e5c:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107e64:	74 10                	je     80107e76 <mappages+0x8c>
      break;
    a += PGSIZE;
80107e66:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107e6d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107e74:	eb 9c                	jmp    80107e12 <mappages+0x28>
      break;
80107e76:	90                   	nop
  }
  return 0;
80107e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e7c:	c9                   	leave  
80107e7d:	c3                   	ret    

80107e7e <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107e7e:	f3 0f 1e fb          	endbr32 
80107e82:	55                   	push   %ebp
80107e83:	89 e5                	mov    %esp,%ebp
80107e85:	53                   	push   %ebx
80107e86:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107e89:	e8 70 af ff ff       	call   80102dfe <kalloc>
80107e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e95:	75 07                	jne    80107e9e <setupkvm+0x20>
    return 0;
80107e97:	b8 00 00 00 00       	mov    $0x0,%eax
80107e9c:	eb 78                	jmp    80107f16 <setupkvm+0x98>
  memset(pgdir, 0, PGSIZE);
80107e9e:	83 ec 04             	sub    $0x4,%esp
80107ea1:	68 00 10 00 00       	push   $0x1000
80107ea6:	6a 00                	push   $0x0
80107ea8:	ff 75 f0             	pushl  -0x10(%ebp)
80107eab:	e8 cd d5 ff ff       	call   8010547d <memset>
80107eb0:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107eb3:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
80107eba:	eb 4e                	jmp    80107f0a <setupkvm+0x8c>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebf:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec5:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecb:	8b 58 08             	mov    0x8(%eax),%ebx
80107ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed1:	8b 40 04             	mov    0x4(%eax),%eax
80107ed4:	29 c3                	sub    %eax,%ebx
80107ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed9:	8b 00                	mov    (%eax),%eax
80107edb:	83 ec 0c             	sub    $0xc,%esp
80107ede:	51                   	push   %ecx
80107edf:	52                   	push   %edx
80107ee0:	53                   	push   %ebx
80107ee1:	50                   	push   %eax
80107ee2:	ff 75 f0             	pushl  -0x10(%ebp)
80107ee5:	e8 00 ff ff ff       	call   80107dea <mappages>
80107eea:	83 c4 20             	add    $0x20,%esp
80107eed:	85 c0                	test   %eax,%eax
80107eef:	79 15                	jns    80107f06 <setupkvm+0x88>
      freevm(pgdir);
80107ef1:	83 ec 0c             	sub    $0xc,%esp
80107ef4:	ff 75 f0             	pushl  -0x10(%ebp)
80107ef7:	e8 11 05 00 00       	call   8010840d <freevm>
80107efc:	83 c4 10             	add    $0x10,%esp
      return 0;
80107eff:	b8 00 00 00 00       	mov    $0x0,%eax
80107f04:	eb 10                	jmp    80107f16 <setupkvm+0x98>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f06:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107f0a:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
80107f11:	72 a9                	jb     80107ebc <setupkvm+0x3e>
    }
  return pgdir;
80107f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107f16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107f19:	c9                   	leave  
80107f1a:	c3                   	ret    

80107f1b <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107f1b:	f3 0f 1e fb          	endbr32 
80107f1f:	55                   	push   %ebp
80107f20:	89 e5                	mov    %esp,%ebp
80107f22:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f25:	e8 54 ff ff ff       	call   80107e7e <setupkvm>
80107f2a:	a3 24 65 11 80       	mov    %eax,0x80116524
  switchkvm();
80107f2f:	e8 03 00 00 00       	call   80107f37 <switchkvm>
}
80107f34:	90                   	nop
80107f35:	c9                   	leave  
80107f36:	c3                   	ret    

80107f37 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107f37:	f3 0f 1e fb          	endbr32 
80107f3b:	55                   	push   %ebp
80107f3c:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f3e:	a1 24 65 11 80       	mov    0x80116524,%eax
80107f43:	05 00 00 00 80       	add    $0x80000000,%eax
80107f48:	50                   	push   %eax
80107f49:	e8 9c fa ff ff       	call   801079ea <lcr3>
80107f4e:	83 c4 04             	add    $0x4,%esp
}
80107f51:	90                   	nop
80107f52:	c9                   	leave  
80107f53:	c3                   	ret    

80107f54 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107f54:	f3 0f 1e fb          	endbr32 
80107f58:	55                   	push   %ebp
80107f59:	89 e5                	mov    %esp,%ebp
80107f5b:	56                   	push   %esi
80107f5c:	53                   	push   %ebx
80107f5d:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107f60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107f64:	75 0d                	jne    80107f73 <switchuvm+0x1f>
    panic("switchuvm: no process");
80107f66:	83 ec 0c             	sub    $0xc,%esp
80107f69:	68 1a 8d 10 80       	push   $0x80108d1a
80107f6e:	e8 5e 86 ff ff       	call   801005d1 <panic>
  if(p->kstack == 0)
80107f73:	8b 45 08             	mov    0x8(%ebp),%eax
80107f76:	8b 40 08             	mov    0x8(%eax),%eax
80107f79:	85 c0                	test   %eax,%eax
80107f7b:	75 0d                	jne    80107f8a <switchuvm+0x36>
    panic("switchuvm: no kstack");
80107f7d:	83 ec 0c             	sub    $0xc,%esp
80107f80:	68 30 8d 10 80       	push   $0x80108d30
80107f85:	e8 47 86 ff ff       	call   801005d1 <panic>
  if(p->pgdir == 0)
80107f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8d:	8b 40 04             	mov    0x4(%eax),%eax
80107f90:	85 c0                	test   %eax,%eax
80107f92:	75 0d                	jne    80107fa1 <switchuvm+0x4d>
    panic("switchuvm: no pgdir");
80107f94:	83 ec 0c             	sub    $0xc,%esp
80107f97:	68 45 8d 10 80       	push   $0x80108d45
80107f9c:	e8 30 86 ff ff       	call   801005d1 <panic>

  pushcli();
80107fa1:	e8 c4 d3 ff ff       	call   8010536a <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107fa6:	e8 75 c4 ff ff       	call   80104420 <mycpu>
80107fab:	89 c3                	mov    %eax,%ebx
80107fad:	e8 6e c4 ff ff       	call   80104420 <mycpu>
80107fb2:	83 c0 08             	add    $0x8,%eax
80107fb5:	89 c6                	mov    %eax,%esi
80107fb7:	e8 64 c4 ff ff       	call   80104420 <mycpu>
80107fbc:	83 c0 08             	add    $0x8,%eax
80107fbf:	c1 e8 10             	shr    $0x10,%eax
80107fc2:	88 45 f7             	mov    %al,-0x9(%ebp)
80107fc5:	e8 56 c4 ff ff       	call   80104420 <mycpu>
80107fca:	83 c0 08             	add    $0x8,%eax
80107fcd:	c1 e8 18             	shr    $0x18,%eax
80107fd0:	89 c2                	mov    %eax,%edx
80107fd2:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107fd9:	67 00 
80107fdb:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107fe2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107fe6:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107fec:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107ff3:	83 e0 f0             	and    $0xfffffff0,%eax
80107ff6:	83 c8 09             	or     $0x9,%eax
80107ff9:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107fff:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108006:	83 c8 10             	or     $0x10,%eax
80108009:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010800f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108016:	83 e0 9f             	and    $0xffffff9f,%eax
80108019:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010801f:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108026:	83 c8 80             	or     $0xffffff80,%eax
80108029:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010802f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108036:	83 e0 f0             	and    $0xfffffff0,%eax
80108039:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010803f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108046:	83 e0 ef             	and    $0xffffffef,%eax
80108049:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010804f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108056:	83 e0 df             	and    $0xffffffdf,%eax
80108059:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010805f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108066:	83 c8 40             	or     $0x40,%eax
80108069:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010806f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108076:	83 e0 7f             	and    $0x7f,%eax
80108079:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010807f:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80108085:	e8 96 c3 ff ff       	call   80104420 <mycpu>
8010808a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108091:	83 e2 ef             	and    $0xffffffef,%edx
80108094:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010809a:	e8 81 c3 ff ff       	call   80104420 <mycpu>
8010809f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801080a5:	8b 45 08             	mov    0x8(%ebp),%eax
801080a8:	8b 40 08             	mov    0x8(%eax),%eax
801080ab:	89 c3                	mov    %eax,%ebx
801080ad:	e8 6e c3 ff ff       	call   80104420 <mycpu>
801080b2:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
801080b8:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801080bb:	e8 60 c3 ff ff       	call   80104420 <mycpu>
801080c0:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801080c6:	83 ec 0c             	sub    $0xc,%esp
801080c9:	6a 28                	push   $0x28
801080cb:	e8 03 f9 ff ff       	call   801079d3 <ltr>
801080d0:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801080d3:	8b 45 08             	mov    0x8(%ebp),%eax
801080d6:	8b 40 04             	mov    0x4(%eax),%eax
801080d9:	05 00 00 00 80       	add    $0x80000000,%eax
801080de:	83 ec 0c             	sub    $0xc,%esp
801080e1:	50                   	push   %eax
801080e2:	e8 03 f9 ff ff       	call   801079ea <lcr3>
801080e7:	83 c4 10             	add    $0x10,%esp
  popcli();
801080ea:	e8 cc d2 ff ff       	call   801053bb <popcli>
}
801080ef:	90                   	nop
801080f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080f3:	5b                   	pop    %ebx
801080f4:	5e                   	pop    %esi
801080f5:	5d                   	pop    %ebp
801080f6:	c3                   	ret    

801080f7 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801080f7:	f3 0f 1e fb          	endbr32 
801080fb:	55                   	push   %ebp
801080fc:	89 e5                	mov    %esp,%ebp
801080fe:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108101:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108108:	76 0d                	jbe    80108117 <inituvm+0x20>
    panic("inituvm: more than a page");
8010810a:	83 ec 0c             	sub    $0xc,%esp
8010810d:	68 59 8d 10 80       	push   $0x80108d59
80108112:	e8 ba 84 ff ff       	call   801005d1 <panic>
  mem = kalloc();
80108117:	e8 e2 ac ff ff       	call   80102dfe <kalloc>
8010811c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010811f:	83 ec 04             	sub    $0x4,%esp
80108122:	68 00 10 00 00       	push   $0x1000
80108127:	6a 00                	push   $0x0
80108129:	ff 75 f4             	pushl  -0xc(%ebp)
8010812c:	e8 4c d3 ff ff       	call   8010547d <memset>
80108131:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108137:	05 00 00 00 80       	add    $0x80000000,%eax
8010813c:	83 ec 0c             	sub    $0xc,%esp
8010813f:	6a 06                	push   $0x6
80108141:	50                   	push   %eax
80108142:	68 00 10 00 00       	push   $0x1000
80108147:	6a 00                	push   $0x0
80108149:	ff 75 08             	pushl  0x8(%ebp)
8010814c:	e8 99 fc ff ff       	call   80107dea <mappages>
80108151:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108154:	83 ec 04             	sub    $0x4,%esp
80108157:	ff 75 10             	pushl  0x10(%ebp)
8010815a:	ff 75 0c             	pushl  0xc(%ebp)
8010815d:	ff 75 f4             	pushl  -0xc(%ebp)
80108160:	e8 df d3 ff ff       	call   80105544 <memmove>
80108165:	83 c4 10             	add    $0x10,%esp
}
80108168:	90                   	nop
80108169:	c9                   	leave  
8010816a:	c3                   	ret    

8010816b <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010816b:	f3 0f 1e fb          	endbr32 
8010816f:	55                   	push   %ebp
80108170:	89 e5                	mov    %esp,%ebp
80108172:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108175:	8b 45 0c             	mov    0xc(%ebp),%eax
80108178:	25 ff 0f 00 00       	and    $0xfff,%eax
8010817d:	85 c0                	test   %eax,%eax
8010817f:	74 0d                	je     8010818e <loaduvm+0x23>
    panic("loaduvm: addr must be page aligned");
80108181:	83 ec 0c             	sub    $0xc,%esp
80108184:	68 74 8d 10 80       	push   $0x80108d74
80108189:	e8 43 84 ff ff       	call   801005d1 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010818e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108195:	e9 8f 00 00 00       	jmp    80108229 <loaduvm+0xbe>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010819a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010819d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a0:	01 d0                	add    %edx,%eax
801081a2:	83 ec 04             	sub    $0x4,%esp
801081a5:	6a 00                	push   $0x0
801081a7:	50                   	push   %eax
801081a8:	ff 75 08             	pushl  0x8(%ebp)
801081ab:	e8 a0 fb ff ff       	call   80107d50 <walkpgdir>
801081b0:	83 c4 10             	add    $0x10,%esp
801081b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801081b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081ba:	75 0d                	jne    801081c9 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
801081bc:	83 ec 0c             	sub    $0xc,%esp
801081bf:	68 97 8d 10 80       	push   $0x80108d97
801081c4:	e8 08 84 ff ff       	call   801005d1 <panic>
    pa = PTE_ADDR(*pte);
801081c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081cc:	8b 00                	mov    (%eax),%eax
801081ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801081d6:	8b 45 18             	mov    0x18(%ebp),%eax
801081d9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801081dc:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801081e1:	77 0b                	ja     801081ee <loaduvm+0x83>
      n = sz - i;
801081e3:	8b 45 18             	mov    0x18(%ebp),%eax
801081e6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801081e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081ec:	eb 07                	jmp    801081f5 <loaduvm+0x8a>
    else
      n = PGSIZE;
801081ee:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801081f5:	8b 55 14             	mov    0x14(%ebp),%edx
801081f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fb:	01 d0                	add    %edx,%eax
801081fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108200:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108206:	ff 75 f0             	pushl  -0x10(%ebp)
80108209:	50                   	push   %eax
8010820a:	52                   	push   %edx
8010820b:	ff 75 10             	pushl  0x10(%ebp)
8010820e:	e8 03 9e ff ff       	call   80102016 <readi>
80108213:	83 c4 10             	add    $0x10,%esp
80108216:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80108219:	74 07                	je     80108222 <loaduvm+0xb7>
      return -1;
8010821b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108220:	eb 18                	jmp    8010823a <loaduvm+0xcf>
  for(i = 0; i < sz; i += PGSIZE){
80108222:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822c:	3b 45 18             	cmp    0x18(%ebp),%eax
8010822f:	0f 82 65 ff ff ff    	jb     8010819a <loaduvm+0x2f>
  }
  return 0;
80108235:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010823a:	c9                   	leave  
8010823b:	c3                   	ret    

8010823c <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010823c:	f3 0f 1e fb          	endbr32 
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108246:	8b 45 10             	mov    0x10(%ebp),%eax
80108249:	85 c0                	test   %eax,%eax
8010824b:	79 0a                	jns    80108257 <allocuvm+0x1b>
    return 0;
8010824d:	b8 00 00 00 00       	mov    $0x0,%eax
80108252:	e9 ec 00 00 00       	jmp    80108343 <allocuvm+0x107>
  if(newsz < oldsz)
80108257:	8b 45 10             	mov    0x10(%ebp),%eax
8010825a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010825d:	73 08                	jae    80108267 <allocuvm+0x2b>
    return oldsz;
8010825f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108262:	e9 dc 00 00 00       	jmp    80108343 <allocuvm+0x107>

  a = PGROUNDUP(oldsz);
80108267:	8b 45 0c             	mov    0xc(%ebp),%eax
8010826a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010826f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108277:	e9 b8 00 00 00       	jmp    80108334 <allocuvm+0xf8>
    mem = kalloc();
8010827c:	e8 7d ab ff ff       	call   80102dfe <kalloc>
80108281:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108284:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108288:	75 2e                	jne    801082b8 <allocuvm+0x7c>
      cprintf("allocuvm out of memory\n");
8010828a:	83 ec 0c             	sub    $0xc,%esp
8010828d:	68 b5 8d 10 80       	push   $0x80108db5
80108292:	e8 81 81 ff ff       	call   80100418 <cprintf>
80108297:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010829a:	83 ec 04             	sub    $0x4,%esp
8010829d:	ff 75 0c             	pushl  0xc(%ebp)
801082a0:	ff 75 10             	pushl  0x10(%ebp)
801082a3:	ff 75 08             	pushl  0x8(%ebp)
801082a6:	e8 9a 00 00 00       	call   80108345 <deallocuvm>
801082ab:	83 c4 10             	add    $0x10,%esp
      return 0;
801082ae:	b8 00 00 00 00       	mov    $0x0,%eax
801082b3:	e9 8b 00 00 00       	jmp    80108343 <allocuvm+0x107>
    }
    memset(mem, 0, PGSIZE);
801082b8:	83 ec 04             	sub    $0x4,%esp
801082bb:	68 00 10 00 00       	push   $0x1000
801082c0:	6a 00                	push   $0x0
801082c2:	ff 75 f0             	pushl  -0x10(%ebp)
801082c5:	e8 b3 d1 ff ff       	call   8010547d <memset>
801082ca:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801082cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801082d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d9:	83 ec 0c             	sub    $0xc,%esp
801082dc:	6a 06                	push   $0x6
801082de:	52                   	push   %edx
801082df:	68 00 10 00 00       	push   $0x1000
801082e4:	50                   	push   %eax
801082e5:	ff 75 08             	pushl  0x8(%ebp)
801082e8:	e8 fd fa ff ff       	call   80107dea <mappages>
801082ed:	83 c4 20             	add    $0x20,%esp
801082f0:	85 c0                	test   %eax,%eax
801082f2:	79 39                	jns    8010832d <allocuvm+0xf1>
      cprintf("allocuvm out of memory (2)\n");
801082f4:	83 ec 0c             	sub    $0xc,%esp
801082f7:	68 cd 8d 10 80       	push   $0x80108dcd
801082fc:	e8 17 81 ff ff       	call   80100418 <cprintf>
80108301:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108304:	83 ec 04             	sub    $0x4,%esp
80108307:	ff 75 0c             	pushl  0xc(%ebp)
8010830a:	ff 75 10             	pushl  0x10(%ebp)
8010830d:	ff 75 08             	pushl  0x8(%ebp)
80108310:	e8 30 00 00 00       	call   80108345 <deallocuvm>
80108315:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80108318:	83 ec 0c             	sub    $0xc,%esp
8010831b:	ff 75 f0             	pushl  -0x10(%ebp)
8010831e:	e8 3d aa ff ff       	call   80102d60 <kfree>
80108323:	83 c4 10             	add    $0x10,%esp
      return 0;
80108326:	b8 00 00 00 00       	mov    $0x0,%eax
8010832b:	eb 16                	jmp    80108343 <allocuvm+0x107>
  for(; a < newsz; a += PGSIZE){
8010832d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108337:	3b 45 10             	cmp    0x10(%ebp),%eax
8010833a:	0f 82 3c ff ff ff    	jb     8010827c <allocuvm+0x40>
    }
  }
  return newsz;
80108340:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108343:	c9                   	leave  
80108344:	c3                   	ret    

80108345 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108345:	f3 0f 1e fb          	endbr32 
80108349:	55                   	push   %ebp
8010834a:	89 e5                	mov    %esp,%ebp
8010834c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010834f:	8b 45 10             	mov    0x10(%ebp),%eax
80108352:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108355:	72 08                	jb     8010835f <deallocuvm+0x1a>
    return oldsz;
80108357:	8b 45 0c             	mov    0xc(%ebp),%eax
8010835a:	e9 ac 00 00 00       	jmp    8010840b <deallocuvm+0xc6>

  a = PGROUNDUP(newsz);
8010835f:	8b 45 10             	mov    0x10(%ebp),%eax
80108362:	05 ff 0f 00 00       	add    $0xfff,%eax
80108367:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010836c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010836f:	e9 88 00 00 00       	jmp    801083fc <deallocuvm+0xb7>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108377:	83 ec 04             	sub    $0x4,%esp
8010837a:	6a 00                	push   $0x0
8010837c:	50                   	push   %eax
8010837d:	ff 75 08             	pushl  0x8(%ebp)
80108380:	e8 cb f9 ff ff       	call   80107d50 <walkpgdir>
80108385:	83 c4 10             	add    $0x10,%esp
80108388:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010838b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010838f:	75 16                	jne    801083a7 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108394:	c1 e8 16             	shr    $0x16,%eax
80108397:	83 c0 01             	add    $0x1,%eax
8010839a:	c1 e0 16             	shl    $0x16,%eax
8010839d:	2d 00 10 00 00       	sub    $0x1000,%eax
801083a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083a5:	eb 4e                	jmp    801083f5 <deallocuvm+0xb0>
    else if((*pte & PTE_P) != 0){
801083a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083aa:	8b 00                	mov    (%eax),%eax
801083ac:	83 e0 01             	and    $0x1,%eax
801083af:	85 c0                	test   %eax,%eax
801083b1:	74 42                	je     801083f5 <deallocuvm+0xb0>
      pa = PTE_ADDR(*pte);
801083b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083b6:	8b 00                	mov    (%eax),%eax
801083b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801083c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083c4:	75 0d                	jne    801083d3 <deallocuvm+0x8e>
        panic("kfree");
801083c6:	83 ec 0c             	sub    $0xc,%esp
801083c9:	68 e9 8d 10 80       	push   $0x80108de9
801083ce:	e8 fe 81 ff ff       	call   801005d1 <panic>
      char *v = P2V(pa);
801083d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083d6:	05 00 00 00 80       	add    $0x80000000,%eax
801083db:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801083de:	83 ec 0c             	sub    $0xc,%esp
801083e1:	ff 75 e8             	pushl  -0x18(%ebp)
801083e4:	e8 77 a9 ff ff       	call   80102d60 <kfree>
801083e9:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801083ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801083f5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108402:	0f 82 6c ff ff ff    	jb     80108374 <deallocuvm+0x2f>
    }
  }
  return newsz;
80108408:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010840b:	c9                   	leave  
8010840c:	c3                   	ret    

8010840d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010840d:	f3 0f 1e fb          	endbr32 
80108411:	55                   	push   %ebp
80108412:	89 e5                	mov    %esp,%ebp
80108414:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108417:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010841b:	75 0d                	jne    8010842a <freevm+0x1d>
    panic("freevm: no pgdir");
8010841d:	83 ec 0c             	sub    $0xc,%esp
80108420:	68 ef 8d 10 80       	push   $0x80108def
80108425:	e8 a7 81 ff ff       	call   801005d1 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010842a:	83 ec 04             	sub    $0x4,%esp
8010842d:	6a 00                	push   $0x0
8010842f:	68 00 00 00 80       	push   $0x80000000
80108434:	ff 75 08             	pushl  0x8(%ebp)
80108437:	e8 09 ff ff ff       	call   80108345 <deallocuvm>
8010843c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010843f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108446:	eb 48                	jmp    80108490 <freevm+0x83>
    if(pgdir[i] & PTE_P){
80108448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108452:	8b 45 08             	mov    0x8(%ebp),%eax
80108455:	01 d0                	add    %edx,%eax
80108457:	8b 00                	mov    (%eax),%eax
80108459:	83 e0 01             	and    $0x1,%eax
8010845c:	85 c0                	test   %eax,%eax
8010845e:	74 2c                	je     8010848c <freevm+0x7f>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010846a:	8b 45 08             	mov    0x8(%ebp),%eax
8010846d:	01 d0                	add    %edx,%eax
8010846f:	8b 00                	mov    (%eax),%eax
80108471:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108476:	05 00 00 00 80       	add    $0x80000000,%eax
8010847b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010847e:	83 ec 0c             	sub    $0xc,%esp
80108481:	ff 75 f0             	pushl  -0x10(%ebp)
80108484:	e8 d7 a8 ff ff       	call   80102d60 <kfree>
80108489:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010848c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108490:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108497:	76 af                	jbe    80108448 <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
80108499:	83 ec 0c             	sub    $0xc,%esp
8010849c:	ff 75 08             	pushl  0x8(%ebp)
8010849f:	e8 bc a8 ff ff       	call   80102d60 <kfree>
801084a4:	83 c4 10             	add    $0x10,%esp
}
801084a7:	90                   	nop
801084a8:	c9                   	leave  
801084a9:	c3                   	ret    

801084aa <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801084aa:	f3 0f 1e fb          	endbr32 
801084ae:	55                   	push   %ebp
801084af:	89 e5                	mov    %esp,%ebp
801084b1:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801084b4:	83 ec 04             	sub    $0x4,%esp
801084b7:	6a 00                	push   $0x0
801084b9:	ff 75 0c             	pushl  0xc(%ebp)
801084bc:	ff 75 08             	pushl  0x8(%ebp)
801084bf:	e8 8c f8 ff ff       	call   80107d50 <walkpgdir>
801084c4:	83 c4 10             	add    $0x10,%esp
801084c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801084ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801084ce:	75 0d                	jne    801084dd <clearpteu+0x33>
    panic("clearpteu");
801084d0:	83 ec 0c             	sub    $0xc,%esp
801084d3:	68 00 8e 10 80       	push   $0x80108e00
801084d8:	e8 f4 80 ff ff       	call   801005d1 <panic>
  *pte &= ~PTE_U;
801084dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e0:	8b 00                	mov    (%eax),%eax
801084e2:	83 e0 fb             	and    $0xfffffffb,%eax
801084e5:	89 c2                	mov    %eax,%edx
801084e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ea:	89 10                	mov    %edx,(%eax)
}
801084ec:	90                   	nop
801084ed:	c9                   	leave  
801084ee:	c3                   	ret    

801084ef <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801084ef:	f3 0f 1e fb          	endbr32 
801084f3:	55                   	push   %ebp
801084f4:	89 e5                	mov    %esp,%ebp
801084f6:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801084f9:	e8 80 f9 ff ff       	call   80107e7e <setupkvm>
801084fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108501:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108505:	75 0a                	jne    80108511 <copyuvm+0x22>
    return 0;
80108507:	b8 00 00 00 00       	mov    $0x0,%eax
8010850c:	e9 f8 00 00 00       	jmp    80108609 <copyuvm+0x11a>
  for(i = 0; i < sz; i += PGSIZE){
80108511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108518:	e9 c7 00 00 00       	jmp    801085e4 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010851d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108520:	83 ec 04             	sub    $0x4,%esp
80108523:	6a 00                	push   $0x0
80108525:	50                   	push   %eax
80108526:	ff 75 08             	pushl  0x8(%ebp)
80108529:	e8 22 f8 ff ff       	call   80107d50 <walkpgdir>
8010852e:	83 c4 10             	add    $0x10,%esp
80108531:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108534:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108538:	75 0d                	jne    80108547 <copyuvm+0x58>
      panic("copyuvm: pte should exist");
8010853a:	83 ec 0c             	sub    $0xc,%esp
8010853d:	68 0a 8e 10 80       	push   $0x80108e0a
80108542:	e8 8a 80 ff ff       	call   801005d1 <panic>
    if(!(*pte & PTE_P))
80108547:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010854a:	8b 00                	mov    (%eax),%eax
8010854c:	83 e0 01             	and    $0x1,%eax
8010854f:	85 c0                	test   %eax,%eax
80108551:	75 0d                	jne    80108560 <copyuvm+0x71>
      panic("copyuvm: page not present");
80108553:	83 ec 0c             	sub    $0xc,%esp
80108556:	68 24 8e 10 80       	push   $0x80108e24
8010855b:	e8 71 80 ff ff       	call   801005d1 <panic>
    pa = PTE_ADDR(*pte);
80108560:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108563:	8b 00                	mov    (%eax),%eax
80108565:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010856a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010856d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108570:	8b 00                	mov    (%eax),%eax
80108572:	25 ff 0f 00 00       	and    $0xfff,%eax
80108577:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010857a:	e8 7f a8 ff ff       	call   80102dfe <kalloc>
8010857f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108582:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108586:	74 6d                	je     801085f5 <copyuvm+0x106>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108588:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010858b:	05 00 00 00 80       	add    $0x80000000,%eax
80108590:	83 ec 04             	sub    $0x4,%esp
80108593:	68 00 10 00 00       	push   $0x1000
80108598:	50                   	push   %eax
80108599:	ff 75 e0             	pushl  -0x20(%ebp)
8010859c:	e8 a3 cf ff ff       	call   80105544 <memmove>
801085a1:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801085a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801085a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801085aa:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801085b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b3:	83 ec 0c             	sub    $0xc,%esp
801085b6:	52                   	push   %edx
801085b7:	51                   	push   %ecx
801085b8:	68 00 10 00 00       	push   $0x1000
801085bd:	50                   	push   %eax
801085be:	ff 75 f0             	pushl  -0x10(%ebp)
801085c1:	e8 24 f8 ff ff       	call   80107dea <mappages>
801085c6:	83 c4 20             	add    $0x20,%esp
801085c9:	85 c0                	test   %eax,%eax
801085cb:	79 10                	jns    801085dd <copyuvm+0xee>
      kfree(mem);
801085cd:	83 ec 0c             	sub    $0xc,%esp
801085d0:	ff 75 e0             	pushl  -0x20(%ebp)
801085d3:	e8 88 a7 ff ff       	call   80102d60 <kfree>
801085d8:	83 c4 10             	add    $0x10,%esp
      goto bad;
801085db:	eb 19                	jmp    801085f6 <copyuvm+0x107>
  for(i = 0; i < sz; i += PGSIZE){
801085dd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801085ea:	0f 82 2d ff ff ff    	jb     8010851d <copyuvm+0x2e>
    }
  }
  return d;
801085f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085f3:	eb 14                	jmp    80108609 <copyuvm+0x11a>
      goto bad;
801085f5:	90                   	nop

bad:
  freevm(d);
801085f6:	83 ec 0c             	sub    $0xc,%esp
801085f9:	ff 75 f0             	pushl  -0x10(%ebp)
801085fc:	e8 0c fe ff ff       	call   8010840d <freevm>
80108601:	83 c4 10             	add    $0x10,%esp
  return 0;
80108604:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108609:	c9                   	leave  
8010860a:	c3                   	ret    

8010860b <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010860b:	f3 0f 1e fb          	endbr32 
8010860f:	55                   	push   %ebp
80108610:	89 e5                	mov    %esp,%ebp
80108612:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108615:	83 ec 04             	sub    $0x4,%esp
80108618:	6a 00                	push   $0x0
8010861a:	ff 75 0c             	pushl  0xc(%ebp)
8010861d:	ff 75 08             	pushl  0x8(%ebp)
80108620:	e8 2b f7 ff ff       	call   80107d50 <walkpgdir>
80108625:	83 c4 10             	add    $0x10,%esp
80108628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010862b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010862e:	8b 00                	mov    (%eax),%eax
80108630:	83 e0 01             	and    $0x1,%eax
80108633:	85 c0                	test   %eax,%eax
80108635:	75 07                	jne    8010863e <uva2ka+0x33>
    return 0;
80108637:	b8 00 00 00 00       	mov    $0x0,%eax
8010863c:	eb 22                	jmp    80108660 <uva2ka+0x55>
  if((*pte & PTE_U) == 0)
8010863e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108641:	8b 00                	mov    (%eax),%eax
80108643:	83 e0 04             	and    $0x4,%eax
80108646:	85 c0                	test   %eax,%eax
80108648:	75 07                	jne    80108651 <uva2ka+0x46>
    return 0;
8010864a:	b8 00 00 00 00       	mov    $0x0,%eax
8010864f:	eb 0f                	jmp    80108660 <uva2ka+0x55>
  return (char*)P2V(PTE_ADDR(*pte));
80108651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108654:	8b 00                	mov    (%eax),%eax
80108656:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010865b:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108660:	c9                   	leave  
80108661:	c3                   	ret    

80108662 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108662:	f3 0f 1e fb          	endbr32 
80108666:	55                   	push   %ebp
80108667:	89 e5                	mov    %esp,%ebp
80108669:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010866c:	8b 45 10             	mov    0x10(%ebp),%eax
8010866f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108672:	eb 7f                	jmp    801086f3 <copyout+0x91>
    va0 = (uint)PGROUNDDOWN(va);
80108674:	8b 45 0c             	mov    0xc(%ebp),%eax
80108677:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010867c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010867f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108682:	83 ec 08             	sub    $0x8,%esp
80108685:	50                   	push   %eax
80108686:	ff 75 08             	pushl  0x8(%ebp)
80108689:	e8 7d ff ff ff       	call   8010860b <uva2ka>
8010868e:	83 c4 10             	add    $0x10,%esp
80108691:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108694:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108698:	75 07                	jne    801086a1 <copyout+0x3f>
      return -1;
8010869a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010869f:	eb 61                	jmp    80108702 <copyout+0xa0>
    n = PGSIZE - (va - va0);
801086a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086a4:	2b 45 0c             	sub    0xc(%ebp),%eax
801086a7:	05 00 10 00 00       	add    $0x1000,%eax
801086ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801086af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086b2:	3b 45 14             	cmp    0x14(%ebp),%eax
801086b5:	76 06                	jbe    801086bd <copyout+0x5b>
      n = len;
801086b7:	8b 45 14             	mov    0x14(%ebp),%eax
801086ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801086bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801086c0:	2b 45 ec             	sub    -0x14(%ebp),%eax
801086c3:	89 c2                	mov    %eax,%edx
801086c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801086c8:	01 d0                	add    %edx,%eax
801086ca:	83 ec 04             	sub    $0x4,%esp
801086cd:	ff 75 f0             	pushl  -0x10(%ebp)
801086d0:	ff 75 f4             	pushl  -0xc(%ebp)
801086d3:	50                   	push   %eax
801086d4:	e8 6b ce ff ff       	call   80105544 <memmove>
801086d9:	83 c4 10             	add    $0x10,%esp
    len -= n;
801086dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086df:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801086e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086e5:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801086e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086eb:	05 00 10 00 00       	add    $0x1000,%eax
801086f0:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801086f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801086f7:	0f 85 77 ff ff ff    	jne    80108674 <copyout+0x12>
  }
  return 0;
801086fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108702:	c9                   	leave  
80108703:	c3                   	ret    
