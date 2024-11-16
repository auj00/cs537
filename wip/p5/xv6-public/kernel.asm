
kernel:     file format elf32-i386


Disassembly of section .text:

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
80100028:	bc d0 b5 11 80       	mov    $0x8011b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 7a 10 80       	push   $0x80107a60
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 d5 43 00 00       	call   80104430 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 7a 10 80       	push   $0x80107a67
80100097:	50                   	push   %eax
80100098:	e8 63 42 00 00       	call   80104300 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 17 45 00 00       	call   80104600 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 39 44 00 00       	call   801045a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 41 00 00       	call   80104340 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 21 00 00       	call   801022f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 7a 10 80       	push   $0x80107a6e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 1d 42 00 00       	call   801043e0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 7a 10 80       	push   $0x80107a7f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 41 00 00       	call   801043e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 41 00 00       	call   801043a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 e0 43 00 00       	call   80104600 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 2f 43 00 00       	jmp    801045a0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 7a 10 80       	push   $0x80107a86
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 5b 43 00 00       	call   80104600 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ce 3d 00 00       	call   801040a0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 e9 36 00 00       	call   801039d0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 a5 42 00 00       	call   801045a0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 8c 14 00 00       	call   80101790 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 4f 42 00 00       	call   801045a0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 36 14 00 00       	call   80101790 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 7a 10 80       	push   $0x80107a8d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 d8 84 10 80 	movl   $0x801084d8,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 83 40 00 00       	call   80104450 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 7a 10 80       	push   $0x80107aa1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 61 60 00 00       	call   80106480 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 76 5f 00 00       	call   80106480 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 6a 5f 00 00       	call   80106480 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 5e 5f 00 00       	call   80106480 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 0a 42 00 00       	call   80104760 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 55 41 00 00       	call   801046c0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 7a 10 80       	push   $0x80107aa5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 cc 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 50 40 00 00       	call   80104600 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 b7 3f 00 00       	call   801045a0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 9e 11 00 00       	call   80101790 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 d0 7a 10 80 	movzbl -0x7fef8530(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 13 3e 00 00       	call   80104600 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf b8 7a 10 80       	mov    $0x80107ab8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 40 3d 00 00       	call   801045a0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 7a 10 80       	push   $0x80107abf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 68 3d 00 00       	call   80104600 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 cb 3b 00 00       	call   801045a0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 2d 38 00 00       	jmp    80104240 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 17 37 00 00       	call   80104160 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 c8 7a 10 80       	push   $0x80107ac8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 bb 39 00 00       	call   80104430 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 0f 2f 00 00       	call   801039d0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 12 03 00 00    	je     80100df4 <exec+0x344>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 a3 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 a2 0f 00 00       	call   80101aa0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 11 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b0f:	e8 cc 22 00 00       	call   80102de0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 a7 6b 00 00       	call   801076e0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 bc 02 00 00    	je     80100e13 <exec+0x363>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 98 00 00 00       	jmp    80100c00 <exec+0x150>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 76                	jne    80100bef <exec+0x13f>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 91 00 00 00    	jb     80100c1c <exec+0x16c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	0f 82 85 00 00 00    	jb     80100c1c <exec+0x16c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b97:	83 ec 04             	sub    $0x4,%esp
80100b9a:	50                   	push   %eax
80100b9b:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100ba1:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba7:	e8 54 69 00 00       	call   80107500 <allocuvm>
80100bac:	83 c4 10             	add    $0x10,%esp
80100baf:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb5:	85 c0                	test   %eax,%eax
80100bb7:	74 63                	je     80100c1c <exec+0x16c>
    if(ph.vaddr % PGSIZE != 0)
80100bb9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc4:	75 56                	jne    80100c1c <exec+0x16c>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz, ph.flags) < 0)
80100bc6:	83 ec 08             	sub    $0x8,%esp
80100bc9:	ff b5 1c ff ff ff    	push   -0xe4(%ebp)
80100bcf:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bd5:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bdb:	53                   	push   %ebx
80100bdc:	50                   	push   %eax
80100bdd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100be3:	e8 e8 67 00 00       	call   801073d0 <loaduvm>
80100be8:	83 c4 20             	add    $0x20,%esp
80100beb:	85 c0                	test   %eax,%eax
80100bed:	78 2d                	js     80100c1c <exec+0x16c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bef:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bf6:	83 c7 01             	add    $0x1,%edi
80100bf9:	83 c6 20             	add    $0x20,%esi
80100bfc:	39 f8                	cmp    %edi,%eax
80100bfe:	7e 38                	jle    80100c38 <exec+0x188>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c00:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c06:	6a 20                	push   $0x20
80100c08:	56                   	push   %esi
80100c09:	50                   	push   %eax
80100c0a:	53                   	push   %ebx
80100c0b:	e8 90 0e 00 00       	call   80101aa0 <readi>
80100c10:	83 c4 10             	add    $0x10,%esp
80100c13:	83 f8 20             	cmp    $0x20,%eax
80100c16:	0f 84 54 ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c1c:	83 ec 0c             	sub    $0xc,%esp
80100c1f:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c25:	e8 36 6a 00 00       	call   80107660 <freevm>
  if(ip){
80100c2a:	83 c4 10             	add    $0x10,%esp
80100c2d:	e9 d4 fe ff ff       	jmp    80100b06 <exec+0x56>
80100c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sz = PGROUNDUP(sz);
80100c38:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c3e:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c44:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c4a:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c50:	83 ec 0c             	sub    $0xc,%esp
80100c53:	53                   	push   %ebx
80100c54:	e8 c7 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c59:	e8 82 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c5e:	83 c4 0c             	add    $0xc,%esp
80100c61:	56                   	push   %esi
80100c62:	57                   	push   %edi
80100c63:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c69:	57                   	push   %edi
80100c6a:	e8 91 68 00 00       	call   80107500 <allocuvm>
80100c6f:	83 c4 10             	add    $0x10,%esp
80100c72:	89 c6                	mov    %eax,%esi
80100c74:	85 c0                	test   %eax,%eax
80100c76:	0f 84 94 00 00 00    	je     80100d10 <exec+0x260>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7c:	83 ec 08             	sub    $0x8,%esp
80100c7f:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c85:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c87:	50                   	push   %eax
80100c88:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c89:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c8b:	e8 f0 6a 00 00       	call   80107780 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c93:	83 c4 10             	add    $0x10,%esp
80100c96:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c9c:	8b 00                	mov    (%eax),%eax
80100c9e:	85 c0                	test   %eax,%eax
80100ca0:	0f 84 8b 00 00 00    	je     80100d31 <exec+0x281>
80100ca6:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100cac:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cb2:	eb 23                	jmp    80100cd7 <exec+0x227>
80100cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cbb:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cc2:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cc5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ccb:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cce:	85 c0                	test   %eax,%eax
80100cd0:	74 59                	je     80100d2b <exec+0x27b>
    if(argc >= MAXARG)
80100cd2:	83 ff 20             	cmp    $0x20,%edi
80100cd5:	74 39                	je     80100d10 <exec+0x260>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd7:	83 ec 0c             	sub    $0xc,%esp
80100cda:	50                   	push   %eax
80100cdb:	e8 e0 3b 00 00       	call   801048c0 <strlen>
80100ce0:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce2:	58                   	pop    %eax
80100ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce6:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce9:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cec:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cef:	e8 cc 3b 00 00       	call   801048c0 <strlen>
80100cf4:	83 c0 01             	add    $0x1,%eax
80100cf7:	50                   	push   %eax
80100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cfb:	ff 34 b8             	push   (%eax,%edi,4)
80100cfe:	53                   	push   %ebx
80100cff:	56                   	push   %esi
80100d00:	e8 4b 6c 00 00       	call   80107950 <copyout>
80100d05:	83 c4 20             	add    $0x20,%esp
80100d08:	85 c0                	test   %eax,%eax
80100d0a:	79 ac                	jns    80100cb8 <exec+0x208>
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d10:	83 ec 0c             	sub    $0xc,%esp
80100d13:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d19:	e8 42 69 00 00       	call   80107660 <freevm>
80100d1e:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d26:	e9 f1 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d2b:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d31:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d38:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d3a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d41:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d45:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d47:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d4a:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d50:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d52:	50                   	push   %eax
80100d53:	52                   	push   %edx
80100d54:	53                   	push   %ebx
80100d55:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d5b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d62:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d65:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d6b:	e8 e0 6b 00 00       	call   80107950 <copyout>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	85 c0                	test   %eax,%eax
80100d75:	78 99                	js     80100d10 <exec+0x260>
  for(last=s=path; *s; s++)
80100d77:	8b 45 08             	mov    0x8(%ebp),%eax
80100d7a:	8b 55 08             	mov    0x8(%ebp),%edx
80100d7d:	0f b6 00             	movzbl (%eax),%eax
80100d80:	84 c0                	test   %al,%al
80100d82:	74 1b                	je     80100d9f <exec+0x2ef>
80100d84:	89 d1                	mov    %edx,%ecx
80100d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d8d:	8d 76 00             	lea    0x0(%esi),%esi
      last = s+1;
80100d90:	83 c1 01             	add    $0x1,%ecx
80100d93:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d95:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d98:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d9b:	84 c0                	test   %al,%al
80100d9d:	75 f1                	jne    80100d90 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d9f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100da5:	83 ec 04             	sub    $0x4,%esp
80100da8:	6a 10                	push   $0x10
80100daa:	89 f8                	mov    %edi,%eax
80100dac:	52                   	push   %edx
80100dad:	83 c0 6c             	add    $0x6c,%eax
80100db0:	50                   	push   %eax
80100db1:	e8 ca 3a 00 00       	call   80104880 <safestrcpy>
  curproc->pgdir = pgdir;
80100db6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dbc:	89 f8                	mov    %edi,%eax
80100dbe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100dc1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100dc3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dc6:	89 c1                	mov    %eax,%ecx
80100dc8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dce:	8b 40 18             	mov    0x18(%eax),%eax
80100dd1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dd4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dd7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dda:	89 0c 24             	mov    %ecx,(%esp)
80100ddd:	e8 5e 64 00 00       	call   80107240 <switchuvm>
  freevm(oldpgdir);
80100de2:	89 3c 24             	mov    %edi,(%esp)
80100de5:	e8 76 68 00 00       	call   80107660 <freevm>
  return 0;
80100dea:	83 c4 10             	add    $0x10,%esp
80100ded:	31 c0                	xor    %eax,%eax
80100def:	e9 28 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100df4:	e8 e7 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100df9:	83 ec 0c             	sub    $0xc,%esp
80100dfc:	68 e1 7a 10 80       	push   $0x80107ae1
80100e01:	e8 9a f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0e:	e9 09 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e13:	be 00 20 00 00       	mov    $0x2000,%esi
80100e18:	31 ff                	xor    %edi,%edi
80100e1a:	e9 31 fe ff ff       	jmp    80100c50 <exec+0x1a0>
80100e1f:	90                   	nop

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 ed 7a 10 80       	push   $0x80107aed
80100e2b:	68 60 ff 10 80       	push   $0x8010ff60
80100e30:	e8 fb 35 00 00       	call   80104430 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e4c:	68 60 ff 10 80       	push   $0x8010ff60
80100e51:	e8 aa 37 00 00       	call   80104600 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 60 ff 10 80       	push   $0x8010ff60
80100e81:	e8 1a 37 00 00       	call   801045a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 60 ff 10 80       	push   $0x8010ff60
80100e9a:	e8 01 37 00 00       	call   801045a0 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 60 ff 10 80       	push   $0x8010ff60
80100ebf:	e8 3c 37 00 00       	call   80104600 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 60 ff 10 80       	push   $0x8010ff60
80100edc:	e8 bf 36 00 00       	call   801045a0 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 f4 7a 10 80       	push   $0x80107af4
80100ef0:	e8 8b f4 ff ff       	call   80100380 <panic>
80100ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 60 ff 10 80       	push   $0x8010ff60
80100f11:	e8 ea 36 00 00       	call   80104600 <acquire>
  if(f->ref < 1)
80100f16:	8b 53 04             	mov    0x4(%ebx),%edx
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 d2                	test   %edx,%edx
80100f1e:	0f 8e a5 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 ea 01             	sub    $0x1,%edx
80100f27:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2a:	75 44                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f2c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f30:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f33:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f3e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f44:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f4c:	e8 4f 36 00 00       	call   801045a0 <release>

  if(ff.type == FD_PIPE)
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	83 ff 01             	cmp    $0x1,%edi
80100f57:	74 57                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f59:	83 ff 02             	cmp    $0x2,%edi
80100f5c:	74 2a                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 1d 36 00 00       	jmp    801045a0 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 e3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	push   -0x20(%ebp)
80100f93:	e8 28 09 00 00       	call   801018c0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 39 1e 00 00       	jmp    80102de0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 82 25 00 00       	call   80103540 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 fc 7a 10 80       	push   $0x80107afc
80100fd1:	e8 aa f3 ff ff       	call   80100380 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	push   0x10(%ebx)
80100ff5:	e8 96 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	push   0xc(%ebp)
80100fff:	ff 73 10             	push   0x10(%ebx)
80101002:	e8 69 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	push   0x10(%ebx)
8010100b:	e8 60 08 00 00       	call   80101870 <iunlock>
    return 0;
  }
  return -1;
}
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101013:	83 c4 10             	add    $0x10,%esp
80101016:	31 c0                	xor    %eax,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	push   0x10(%ebx)
8010105a:	e8 31 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	push   0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	push   0x10(%ebx)
80101067:	e8 34 0a 00 00       	call   80101aa0 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	89 c6                	mov    %eax,%esi
80101071:	85 c0                	test   %eax,%eax
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 ed 07 00 00       	call   80101870 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 3e 26 00 00       	jmp    801036e0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 06 7b 10 80       	push   $0x80107b06
801010b7:	e8 c4 f2 ff ff       	call   80100380 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 bd 00 00 00    	je     8010119f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 bf 00 00 00    	je     801011ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 c8 00 00 00    	jne    801011be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 30                	jg     8010112f <filewrite+0x6f>
801010ff:	e9 94 00 00 00       	jmp    80101198 <filewrite+0xd8>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 57 07 00 00       	call   80101870 <iunlock>
      end_op();
80101119:	e8 c2 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp
80101124:	39 c7                	cmp    %eax,%edi
80101126:	75 5c                	jne    80101184 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101128:	01 fe                	add    %edi,%esi
    while(i < n){
8010112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010112d:	7e 69                	jle    80101198 <filewrite+0xd8>
      int n1 = n - i;
8010112f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101132:	b8 00 06 00 00       	mov    $0x600,%eax
80101137:	29 f7                	sub    %esi,%edi
80101139:	39 c7                	cmp    %eax,%edi
8010113b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010113e:	e8 2d 1c 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 73 10             	push   0x10(%ebx)
80101149:	e8 42 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101151:	57                   	push   %edi
80101152:	ff 73 14             	push   0x14(%ebx)
80101155:	01 f0                	add    %esi,%eax
80101157:	50                   	push   %eax
80101158:	ff 73 10             	push   0x10(%ebx)
8010115b:	e8 40 0a 00 00       	call   80101ba0 <writei>
80101160:	83 c4 20             	add    $0x20,%esp
80101163:	85 c0                	test   %eax,%eax
80101165:	7f a1                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	ff 73 10             	push   0x10(%ebx)
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	e8 fb 06 00 00       	call   80101870 <iunlock>
      end_op();
80101175:	e8 66 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	85 c0                	test   %eax,%eax
80101182:	75 1b                	jne    8010119f <filewrite+0xdf>
        panic("short filewrite");
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	68 0f 7b 10 80       	push   $0x80107b0f
8010118c:	e8 ef f1 ff ff       	call   80100380 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101198:	89 f0                	mov    %esi,%eax
8010119a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010119d:	74 05                	je     801011a4 <filewrite+0xe4>
8010119f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a7:	5b                   	pop    %ebx
801011a8:	5e                   	pop    %esi
801011a9:	5f                   	pop    %edi
801011aa:	5d                   	pop    %ebp
801011ab:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801011af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b9:	e9 22 24 00 00       	jmp    801035e0 <pipewrite>
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 15 7b 10 80       	push   $0x80107b15
801011c6:	e8 b5 f1 ff ff       	call   80100380 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
801011f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011f8:	83 e1 07             	and    $0x7,%ecx
801011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101200:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101206:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101208:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010120d:	85 c1                	test   %eax,%ecx
8010120f:	74 23                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101211:	f7 d0                	not    %eax
  log_write(bp);
80101213:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101216:	21 c8                	and    %ecx,%eax
80101218:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010121c:	56                   	push   %esi
8010121d:	e8 2e 1d 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 1f 7b 10 80       	push   $0x80107b1f
8010123c:	e8 3f f1 ff ff       	call   80100380 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	push   -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	push   -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 32 7b 10 80       	push   $0x80107b32
801012f9:	e8 82 f0 ff ff       	call   80100380 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 3e 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	push   -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 86 33 00 00       	call   801046c0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 0e 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 60 09 11 80       	push   $0x80110960
8010137a:	e8 81 32 00 00       	call   80104600 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
801013b1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013bf:	72 e1                	jb     801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 60 09 11 80       	push   $0x80110960
801013e7:	e8 b4 31 00 00       	call   801045a0 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c0 01             	add    $0x1,%eax
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101412:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 86 31 00 00       	call   801045a0 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101433:	73 10                	jae    80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 48 7b 10 80       	push   $0x80107b48
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 8c 00 00 00    	jbe    80101500 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 a2 00 00 00    	ja     80101522 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	85 c0                	test   %eax,%eax
80101488:	74 5e                	je     801014e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148a:	83 ec 08             	sub    $0x8,%esp
8010148d:	50                   	push   %eax
8010148e:	ff 36                	push   (%esi)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101495:	83 c4 10             	add    $0x10,%esp
80101498:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010149c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010149e:	8b 3b                	mov    (%ebx),%edi
801014a0:	85 ff                	test   %edi,%edi
801014a2:	74 1c                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	52                   	push   %edx
801014a8:	e8 43 ed ff ff       	call   801001f0 <brelse>
801014ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b3:	89 f8                	mov    %edi,%eax
801014b5:	5b                   	pop    %ebx
801014b6:	5e                   	pop    %esi
801014b7:	5f                   	pop    %edi
801014b8:	5d                   	pop    %ebp
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014c3:	8b 06                	mov    (%esi),%eax
801014c5:	e8 86 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 03                	mov    %eax,(%ebx)
801014d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014d4:	52                   	push   %edx
801014d5:	e8 76 1a 00 00       	call   80102f50 <log_write>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	eb c2                	jmp    801014a4 <bmap+0x44>
801014e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e8:	8b 06                	mov    (%esi),%eax
801014ea:	e8 61 fd ff ff       	call   80101250 <balloc>
801014ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014f5:	eb 93                	jmp    8010148a <bmap+0x2a>
801014f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101500:	8d 5a 14             	lea    0x14(%edx),%ebx
80101503:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101507:	85 ff                	test   %edi,%edi
80101509:	75 a5                	jne    801014b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010150b:	8b 00                	mov    (%eax),%eax
8010150d:	e8 3e fd ff ff       	call   80101250 <balloc>
80101512:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101516:	89 c7                	mov    %eax,%edi
}
80101518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151b:	5b                   	pop    %ebx
8010151c:	89 f8                	mov    %edi,%eax
8010151e:	5e                   	pop    %esi
8010151f:	5f                   	pop    %edi
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
  panic("bmap: out of range");
80101522:	83 ec 0c             	sub    $0xc,%esp
80101525:	68 58 7b 10 80       	push   $0x80107b58
8010152a:	e8 51 ee ff ff       	call   80100380 <panic>
8010152f:	90                   	nop

80101530 <readsb>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101538:	83 ec 08             	sub    $0x8,%esp
8010153b:	6a 01                	push   $0x1
8010153d:	ff 75 08             	push   0x8(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101548:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	6a 1c                	push   $0x1c
8010154f:	50                   	push   %eax
80101550:	56                   	push   %esi
80101551:	e8 0a 32 00 00       	call   80104760 <memmove>
  brelse(bp);
80101556:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101559:	83 c4 10             	add    $0x10,%esp
}
8010155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5d                   	pop    %ebp
  brelse(bp);
80101562:	e9 89 ec ff ff       	jmp    801001f0 <brelse>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax

80101570 <iinit>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	53                   	push   %ebx
80101574:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101579:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010157c:	68 6b 7b 10 80       	push   $0x80107b6b
80101581:	68 60 09 11 80       	push   $0x80110960
80101586:	e8 a5 2e 00 00       	call   80104430 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101590:	83 ec 08             	sub    $0x8,%esp
80101593:	68 72 7b 10 80       	push   $0x80107b72
80101598:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101599:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010159f:	e8 5c 2d 00 00       	call   80104300 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015a4:	83 c4 10             	add    $0x10,%esp
801015a7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015ad:	75 e1                	jne    80101590 <iinit+0x20>
  bp = bread(dev, 1);
801015af:	83 ec 08             	sub    $0x8,%esp
801015b2:	6a 01                	push   $0x1
801015b4:	ff 75 08             	push   0x8(%ebp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015c4:	6a 1c                	push   $0x1c
801015c6:	50                   	push   %eax
801015c7:	68 b4 25 11 80       	push   $0x801125b4
801015cc:	e8 8f 31 00 00       	call   80104760 <memmove>
  brelse(bp);
801015d1:	89 1c 24             	mov    %ebx,(%esp)
801015d4:	e8 17 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d9:	ff 35 cc 25 11 80    	push   0x801125cc
801015df:	ff 35 c8 25 11 80    	push   0x801125c8
801015e5:	ff 35 c4 25 11 80    	push   0x801125c4
801015eb:	ff 35 c0 25 11 80    	push   0x801125c0
801015f1:	ff 35 bc 25 11 80    	push   0x801125bc
801015f7:	ff 35 b8 25 11 80    	push   0x801125b8
801015fd:	ff 35 b4 25 11 80    	push   0x801125b4
80101603:	68 d8 7b 10 80       	push   $0x80107bd8
80101608:	e8 93 f0 ff ff       	call   801006a0 <cprintf>
}
8010160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101610:	83 c4 30             	add    $0x30,%esp
80101613:	c9                   	leave  
80101614:	c3                   	ret    
80101615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ialloc>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 1c             	sub    $0x1c,%esp
80101629:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101633:	8b 75 08             	mov    0x8(%ebp),%esi
80101636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101639:	0f 86 91 00 00 00    	jbe    801016d0 <ialloc+0xb0>
8010163f:	bf 01 00 00 00       	mov    $0x1,%edi
80101644:	eb 21                	jmp    80101667 <ialloc+0x47>
80101646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 1d 30 00 00       	call   801046c0 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 9b 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 90 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 78 7b 10 80       	push   $0x80107b78
801016d8:	e8 a3 ec ff ff       	call   80100380 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	83 ec 08             	sub    $0x8,%esp
801016f1:	c1 e8 03             	shr    $0x3,%eax
801016f4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016fa:	50                   	push   %eax
801016fb:	ff 73 a4             	push   -0x5c(%ebx)
801016fe:	e8 cd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101703:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101707:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101719:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010171c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101720:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101723:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101727:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010172f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101733:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101737:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173d:	6a 34                	push   $0x34
8010173f:	53                   	push   %ebx
80101740:	50                   	push   %eax
80101741:	e8 1a 30 00 00       	call   80104760 <memmove>
  log_write(bp);
80101746:	89 34 24             	mov    %esi,(%esp)
80101749:	e8 02 18 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010174e:	89 75 08             	mov    %esi,0x8(%ebp)
80101751:	83 c4 10             	add    $0x10,%esp
}
80101754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101757:	5b                   	pop    %ebx
80101758:	5e                   	pop    %esi
80101759:	5d                   	pop    %ebp
  brelse(bp);
8010175a:	e9 91 ea ff ff       	jmp    801001f0 <brelse>
8010175f:	90                   	nop

80101760 <idup>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	83 ec 10             	sub    $0x10,%esp
80101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176a:	68 60 09 11 80       	push   $0x80110960
8010176f:	e8 8c 2e 00 00       	call   80104600 <acquire>
  ip->ref++;
80101774:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101778:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010177f:	e8 1c 2e 00 00       	call   801045a0 <release>
}
80101784:	89 d8                	mov    %ebx,%eax
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave  
8010178a:	c3                   	ret    
8010178b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010178f:	90                   	nop

80101790 <ilock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	0f 84 b7 00 00 00    	je     80101857 <ilock+0xc7>
801017a0:	8b 53 08             	mov    0x8(%ebx),%edx
801017a3:	85 d2                	test   %edx,%edx
801017a5:	0f 8e ac 00 00 00    	jle    80101857 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017ab:	83 ec 0c             	sub    $0xc,%esp
801017ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b1:	50                   	push   %eax
801017b2:	e8 89 2b 00 00       	call   80104340 <acquiresleep>
  if(ip->valid == 0){
801017b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ba:	83 c4 10             	add    $0x10,%esp
801017bd:	85 c0                	test   %eax,%eax
801017bf:	74 0f                	je     801017d0 <ilock+0x40>
}
801017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c4:	5b                   	pop    %ebx
801017c5:	5e                   	pop    %esi
801017c6:	5d                   	pop    %ebp
801017c7:	c3                   	ret    
801017c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 03             	shr    $0x3,%eax
801017d9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	push   (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101803:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101807:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010180b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010180f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101813:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101817:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010181b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010181e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 33 2f 00 00       	call   80104760 <memmove>
    brelse(bp);
8010182d:	89 34 24             	mov    %esi,(%esp)
80101830:	e8 bb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010183d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101844:	0f 85 77 ff ff ff    	jne    801017c1 <ilock+0x31>
      panic("ilock: no type");
8010184a:	83 ec 0c             	sub    $0xc,%esp
8010184d:	68 90 7b 10 80       	push   $0x80107b90
80101852:	e8 29 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 8a 7b 10 80       	push   $0x80107b8a
8010185f:	e8 1c eb ff ff       	call   80100380 <panic>
80101864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <iunlock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	74 28                	je     801018a4 <iunlock+0x34>
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101882:	56                   	push   %esi
80101883:	e8 58 2b 00 00       	call   801043e0 <holdingsleep>
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 c0                	test   %eax,%eax
8010188d:	74 15                	je     801018a4 <iunlock+0x34>
8010188f:	8b 43 08             	mov    0x8(%ebx),%eax
80101892:	85 c0                	test   %eax,%eax
80101894:	7e 0e                	jle    801018a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101896:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101899:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010189f:	e9 fc 2a 00 00       	jmp    801043a0 <releasesleep>
    panic("iunlock");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 9f 7b 10 80       	push   $0x80107b9f
801018ac:	e8 cf ea ff ff       	call   80100380 <panic>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iput>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 28             	sub    $0x28,%esp
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018cf:	57                   	push   %edi
801018d0:	e8 6b 2a 00 00       	call   80104340 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 d2                	test   %edx,%edx
801018dd:	74 07                	je     801018e6 <iput+0x26>
801018df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e4:	74 32                	je     80101918 <iput+0x58>
  releasesleep(&ip->lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	57                   	push   %edi
801018ea:	e8 b1 2a 00 00       	call   801043a0 <releasesleep>
  acquire(&icache.lock);
801018ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018f6:	e8 05 2d 00 00       	call   80104600 <acquire>
  ip->ref--;
801018fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101909:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5f                   	pop    %edi
8010190f:	5d                   	pop    %ebp
  release(&icache.lock);
80101910:	e9 8b 2c 00 00       	jmp    801045a0 <release>
80101915:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101918:	83 ec 0c             	sub    $0xc,%esp
8010191b:	68 60 09 11 80       	push   $0x80110960
80101920:	e8 db 2c 00 00       	call   80104600 <acquire>
    int r = ip->ref;
80101925:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101928:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010192f:	e8 6c 2c 00 00       	call   801045a0 <release>
    if(r == 1){
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	83 fe 01             	cmp    $0x1,%esi
8010193a:	75 aa                	jne    801018e6 <iput+0x26>
8010193c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101942:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101945:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101948:	89 cf                	mov    %ecx,%edi
8010194a:	eb 0b                	jmp    80101957 <iput+0x97>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101950:	83 c6 04             	add    $0x4,%esi
80101953:	39 fe                	cmp    %edi,%esi
80101955:	74 19                	je     80101970 <iput+0xb0>
    if(ip->addrs[i]){
80101957:	8b 16                	mov    (%esi),%edx
80101959:	85 d2                	test   %edx,%edx
8010195b:	74 f3                	je     80101950 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010195d:	8b 03                	mov    (%ebx),%eax
8010195f:	e8 6c f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
80101964:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010196a:	eb e4                	jmp    80101950 <iput+0x90>
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101970:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101976:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101979:	85 c0                	test   %eax,%eax
8010197b:	75 2d                	jne    801019aa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010197d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101980:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101987:	53                   	push   %ebx
80101988:	e8 53 fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
8010198d:	31 c0                	xor    %eax,%eax
8010198f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101993:	89 1c 24             	mov    %ebx,(%esp)
80101996:	e8 45 fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
8010199b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019a2:	83 c4 10             	add    $0x10,%esp
801019a5:	e9 3c ff ff ff       	jmp    801018e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019aa:	83 ec 08             	sub    $0x8,%esp
801019ad:	50                   	push   %eax
801019ae:	ff 33                	push   (%ebx)
801019b0:	e8 1b e7 ff ff       	call   801000d0 <bread>
801019b5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c7:	89 cf                	mov    %ecx,%edi
801019c9:	eb 0c                	jmp    801019d7 <iput+0x117>
801019cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019cf:	90                   	nop
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 0f                	je     801019e6 <iput+0x126>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x110>
    brelse(bp);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	ff 75 e4             	push   -0x1c(%ebp)
801019ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ef:	e8 fc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019f4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019fa:	8b 03                	mov    (%ebx),%eax
801019fc:	e8 cf f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a01:	83 c4 10             	add    $0x10,%esp
80101a04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a0b:	00 00 00 
80101a0e:	e9 6a ff ff ff       	jmp    8010197d <iput+0xbd>
80101a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 34                	je     80101a60 <iunlockput+0x40>
80101a2c:	83 ec 0c             	sub    $0xc,%esp
80101a2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a32:	56                   	push   %esi
80101a33:	e8 a8 29 00 00       	call   801043e0 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 21                	je     80101a60 <iunlockput+0x40>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 1a                	jle    80101a60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 51 29 00 00       	call   801043a0 <releasesleep>
  iput(ip);
80101a4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a52:	83 c4 10             	add    $0x10,%esp
}
80101a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5d                   	pop    %ebp
  iput(ip);
80101a5b:	e9 60 fe ff ff       	jmp    801018c0 <iput>
    panic("iunlock");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 9f 7b 10 80       	push   $0x80107b9f
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	8b 55 08             	mov    0x8(%ebp),%edx
80101a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a79:	8b 0a                	mov    (%edx),%ecx
80101a7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a93:	8b 52 58             	mov    0x58(%edx),%edx
80101a96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 a7 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	8b 40 58             	mov    0x58(%eax),%eax
80101acf:	39 c6                	cmp    %eax,%esi
80101ad1:	0f 87 ba 00 00 00    	ja     80101b91 <readi+0xf1>
80101ad7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ada:	31 c9                	xor    %ecx,%ecx
80101adc:	89 da                	mov    %ebx,%edx
80101ade:	01 f2                	add    %esi,%edx
80101ae0:	0f 92 c1             	setb   %cl
80101ae3:	89 cf                	mov    %ecx,%edi
80101ae5:	0f 82 a6 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aeb:	89 c1                	mov    %eax,%ecx
80101aed:	29 f1                	sub    %esi,%ecx
80101aef:	39 d0                	cmp    %edx,%eax
80101af1:	0f 43 cb             	cmovae %ebx,%ecx
80101af4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101af7:	85 c9                	test   %ecx,%ecx
80101af9:	74 67                	je     80101b62 <readi+0xc2>
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 51 f9 ff ff       	call   80101460 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	push   (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b22:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b24:	89 f0                	mov    %esi,%eax
80101b26:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b30:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b32:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b36:	39 d9                	cmp    %ebx,%ecx
80101b38:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3b:	83 c4 0c             	add    $0xc,%esp
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	push   -0x20(%ebp)
80101b47:	e8 14 2c 00 00       	call   80104760 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 b7 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	0f 87 e7 00 00 00    	ja     80101cbc <writei+0x11c>
80101bd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bd8:	31 d2                	xor    %edx,%edx
80101bda:	89 f8                	mov    %edi,%eax
80101bdc:	01 f0                	add    %esi,%eax
80101bde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101be6:	0f 87 d0 00 00 00    	ja     80101cbc <writei+0x11c>
80101bec:	85 d2                	test   %edx,%edx
80101bee:	0f 85 c8 00 00 00    	jne    80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bfb:	85 ff                	test   %edi,%edi
80101bfd:	74 72                	je     80101c71 <writei+0xd1>
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 51 f8 ff ff       	call   80101460 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	push   (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c30:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c34:	39 d9                	cmp    %ebx,%ecx
80101c36:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	push   -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 18 2b 00 00       	call   80104760 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 00 13 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 ed 2a 00 00       	call   801047d0 <strncmp>
}
80101ce3:	c9                   	leave  
80101ce4:	c3                   	ret    
80101ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 7e fd ff ff       	call   80101aa0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 8e 2a 00 00       	call   801047d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret    
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 e9 f5 ff ff       	call   80101360 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret    
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 b9 7b 10 80       	push   $0x80107bb9
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 a7 7b 10 80       	push   $0x80107ba7
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 64 01 00 00    	je     80101f1e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 11 1c 00 00       	call   801039d0 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 31 28 00 00       	call   80104600 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 c1 27 00 00       	call   801045a0 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
    path++;
80101e32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 24 29 00 00       	call   80104760 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 37 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 cd 00 00 00    	jne    80101f34 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 22 01 00 00    	je     80101f99 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	89 c7                	mov    %eax,%edi
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	0f 84 e1 00 00 00    	je     80101f76 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e9b:	52                   	push   %edx
80101e9c:	e8 3f 25 00 00       	call   801043e0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 30 01 00 00    	je     80101fdc <namex+0x23c>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e 25 01 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101eb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	52                   	push   %edx
80101ebe:	e8 dd 24 00 00       	call   801043a0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
80101ec6:	89 fe                	mov    %edi,%esi
80101ec8:	e8 f3 f9 ff ff       	call   801018c0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101edb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 70 28 00 00       	call   80104760 <memmove>
    name[len] = 0;
80101ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 02 00             	movb   $0x0,(%edx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 be 00 00 00    	jne    80101fc9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f1e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f23:	b8 01 00 00 00       	mov    $0x1,%eax
80101f28:	e8 33 f4 ff ff       	call   80101360 <iget>
80101f2d:	89 c6                	mov    %eax,%esi
80101f2f:	e9 b7 fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f3a:	53                   	push   %ebx
80101f3b:	e8 a0 24 00 00       	call   801043e0 <holdingsleep>
80101f40:	83 c4 10             	add    $0x10,%esp
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 84 91 00 00 00    	je     80101fdc <namex+0x23c>
80101f4b:	8b 46 08             	mov    0x8(%esi),%eax
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	0f 8e 86 00 00 00    	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	53                   	push   %ebx
80101f5a:	e8 41 24 00 00       	call   801043a0 <releasesleep>
  iput(ip);
80101f5f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f62:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f64:	e8 57 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f76:	83 ec 0c             	sub    $0xc,%esp
80101f79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f7c:	52                   	push   %edx
80101f7d:	e8 5e 24 00 00       	call   801043e0 <holdingsleep>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	85 c0                	test   %eax,%eax
80101f87:	74 53                	je     80101fdc <namex+0x23c>
80101f89:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f8c:	85 c9                	test   %ecx,%ecx
80101f8e:	7e 4c                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f93:	83 ec 0c             	sub    $0xc,%esp
80101f96:	52                   	push   %edx
80101f97:	eb c1                	jmp    80101f5a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f99:	83 ec 0c             	sub    $0xc,%esp
80101f9c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9f:	53                   	push   %ebx
80101fa0:	e8 3b 24 00 00       	call   801043e0 <holdingsleep>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	74 30                	je     80101fdc <namex+0x23c>
80101fac:	8b 7e 08             	mov    0x8(%esi),%edi
80101faf:	85 ff                	test   %edi,%edi
80101fb1:	7e 29                	jle    80101fdc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb3:	83 ec 0c             	sub    $0xc,%esp
80101fb6:	53                   	push   %ebx
80101fb7:	e8 e4 23 00 00       	call   801043a0 <releasesleep>
}
80101fbc:	83 c4 10             	add    $0x10,%esp
}
80101fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	5b                   	pop    %ebx
80101fc5:	5e                   	pop    %esi
80101fc6:	5f                   	pop    %edi
80101fc7:	5d                   	pop    %ebp
80101fc8:	c3                   	ret    
    iput(ip);
80101fc9:	83 ec 0c             	sub    $0xc,%esp
80101fcc:	56                   	push   %esi
    return 0;
80101fcd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fcf:	e8 ec f8 ff ff       	call   801018c0 <iput>
    return 0;
80101fd4:	83 c4 10             	add    $0x10,%esp
80101fd7:	e9 2f ff ff ff       	jmp    80101f0b <namex+0x16b>
    panic("iunlock");
80101fdc:	83 ec 0c             	sub    $0xc,%esp
80101fdf:	68 9f 7b 10 80       	push   $0x80107b9f
80101fe4:	e8 97 e3 ff ff       	call   80100380 <panic>
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 e9 fc ff ff       	call   80101cf0 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 6e fa ff ff       	call   80101aa0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 ce 27 00 00       	call   80104820 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102052:	6a 10                	push   $0x10
  de.inum = inum;
80102054:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102057:	57                   	push   %edi
80102058:	56                   	push   %esi
80102059:	53                   	push   %ebx
  de.inum = inum;
8010205a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010205e:	e8 3d fb ff ff       	call   80101ba0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret    
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 42 f8 ff ff       	call   801018c0 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 c8 7b 10 80       	push   $0x80107bc8
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 b2 81 10 80       	push   $0x801081b2
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 dd fc ff ff       	call   80101da0 <namex>
}
801020c3:	c9                   	leave  
801020c4:	c3                   	ret    
801020c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 bc fc ff ff       	jmp    80101da0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211e:	66 90                	xchg   %ax,%ax
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret    
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld    
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 34 7c 10 80       	push   $0x80107c34
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 2b 7c 10 80       	push   $0x80107c2b
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 46 7c 10 80       	push   $0x80107c46
801021db:	68 00 26 11 80       	push   $0x80112600
801021e0:	e8 4b 22 00 00       	call   80104430 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 00 26 11 80       	push   $0x80112600
8010225e:	e8 9d 23 00 00       	call   80104600 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 63                	je     801022d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 33                	mov    (%ebx),%esi
8010227a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102280:	75 2f                	jne    801022b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228e:	66 90                	xchg   %ax,%ax
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c1                	mov    %eax,%ecx
80102293:	83 e1 c0             	and    $0xffffffc0,%ecx
80102296:	80 f9 40             	cmp    $0x40,%cl
80102299:	75 f5                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229b:	a8 21                	test   $0x21,%al
8010229d:	75 12                	jne    801022b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010229f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ac:	fc                   	cld    
801022ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b7:	83 ce 02             	or     $0x2,%esi
801022ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022bc:	53                   	push   %ebx
801022bd:	e8 9e 1e 00 00       	call   80104160 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	74 05                	je     801022d3 <ideintr+0x83>
    idestart(idequeue);
801022ce:	e8 1d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	68 00 26 11 80       	push   $0x80112600
801022db:	e8 c0 22 00 00       	call   801045a0 <release>

  release(&idelock);
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 dd 20 00 00       	call   801043e0 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c3 00 00 00    	je     801023d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 a8 00 00 00    	je     801023c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 87 00 00 00    	je     801023b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 00 26 11 80       	push   $0x80112600
80102338:	e8 c3 22 00 00       	call   80104600 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102342:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 c0                	test   %eax,%eax
8010234e:	74 60                	je     801023b0 <iderw+0xc0>
80102350:	89 c2                	mov    %eax,%edx
80102352:	8b 40 58             	mov    0x58(%eax),%eax
80102355:	85 c0                	test   %eax,%eax
80102357:	75 f7                	jne    80102350 <iderw+0x60>
80102359:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010235c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010235e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102364:	74 3a                	je     801023a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102366:	8b 03                	mov    (%ebx),%eax
80102368:	83 e0 06             	and    $0x6,%eax
8010236b:	83 f8 02             	cmp    $0x2,%eax
8010236e:	74 1b                	je     8010238b <iderw+0x9b>
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 00 26 11 80       	push   $0x80112600
80102378:	53                   	push   %ebx
80102379:	e8 22 1d 00 00       	call   801040a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x80>
  }


  release(&idelock);
8010238b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 05 22 00 00       	jmp    801045a0 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 49 fd ff ff       	call   801020f0 <idestart>
801023a7:	eb bd                	jmp    80102366 <iderw+0x76>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023b5:	eb a5                	jmp    8010235c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 75 7c 10 80       	push   $0x80107c75
801023bf:	e8 bc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 60 7c 10 80       	push   $0x80107c60
801023cc:	e8 af df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 4a 7c 10 80       	push   $0x80107c4a
801023d9:	e8 a2 df ff ff       	call   80100380 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023e8:	00 c0 fe 
{
801023eb:	89 e5                	mov    %esp,%ebp
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
  ioapic->reg = reg;
801023ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023f6:	00 00 00 
  return ioapic->data;
801023f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102402:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102408:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010240e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102415:	c1 ee 10             	shr    $0x10,%esi
80102418:	89 f0                	mov    %esi,%eax
8010241a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010241d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102420:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102423:	39 c2                	cmp    %eax,%edx
80102425:	74 16                	je     8010243d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 94 7c 10 80       	push   $0x80107c94
8010242f:	e8 6c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102434:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010243a:	83 c4 10             	add    $0x10,%esp
8010243d:	83 c6 21             	add    $0x21,%esi
{
80102440:	ba 10 00 00 00       	mov    $0x10,%edx
80102445:	b8 20 00 00 00       	mov    $0x20,%eax
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102469:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248d:	8d 76 00             	lea    0x0(%esi),%esi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb d0 b5 11 80    	cmp    $0x8011b5d0,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 b9 21 00 00       	call   801046c0 <memset>

  if(kmem.use_lock)
80102507:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 78 26 11 80       	mov    0x80112678,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102520:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave  
8010252e:	c3                   	ret    
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 26 11 80       	push   $0x80112640
80102538:	e8 c3 20 00 00       	call   80104600 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 48 20 00 00       	jmp    801045a0 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 c6 7c 10 80       	push   $0x80107cc6
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 cc 7c 10 80       	push   $0x80107ccc
80102630:	68 40 26 11 80       	push   $0x80112640
80102635:	e8 f6 1d 00 00       	call   80104430 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102647:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102690 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102690:	a1 74 26 11 80       	mov    0x80112674,%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 1f                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102699:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 0e                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a2:	8b 10                	mov    (%eax),%edx
801026a4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026aa:	c3                   	ret    
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	c3                   	ret    
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 40 26 11 80       	push   $0x80112640
801026c3:	e8 38 1f 00 00       	call   80104600 <acquire>
  r = kmem.freelist;
801026c8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026cd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 40 26 11 80       	push   $0x80112640
801026f1:	e8 aa 1e 00 00       	call   801045a0 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102700:	ba 64 00 00 00       	mov    $0x64,%edx
80102705:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102706:	a8 01                	test   $0x1,%al
80102708:	0f 84 c2 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
8010270e:	55                   	push   %ebp
8010270f:	ba 60 00 00 00       	mov    $0x60,%edx
80102714:	89 e5                	mov    %esp,%ebp
80102716:	53                   	push   %ebx
80102717:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102718:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010271e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102721:	3c e0                	cmp    $0xe0,%al
80102723:	74 5b                	je     80102780 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102725:	89 da                	mov    %ebx,%edx
80102727:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010272a:	84 c0                	test   %al,%al
8010272c:	78 62                	js     80102790 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010272e:	85 d2                	test   %edx,%edx
80102730:	74 09                	je     8010273b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102732:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102735:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102738:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010273b:	0f b6 91 00 7e 10 80 	movzbl -0x7fef8200(%ecx),%edx
  shift ^= togglecode[data];
80102742:	0f b6 81 00 7d 10 80 	movzbl -0x7fef8300(%ecx),%eax
  shift |= shiftcode[data];
80102749:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010274b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010274f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102755:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102758:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275b:	8b 04 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%eax
80102762:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102766:	74 0b                	je     80102773 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102768:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276b:	83 fa 19             	cmp    $0x19,%edx
8010276e:	77 48                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102770:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102776:	c9                   	leave  
80102777:	c3                   	ret    
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010278b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278e:	c9                   	leave  
8010278f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 d2                	test   %edx,%edx
80102795:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102798:	0f b6 81 00 7e 10 80 	movzbl -0x7fef8200(%ecx),%eax
8010279f:	83 c8 40             	or     $0x40,%eax
801027a2:	0f b6 c0             	movzbl %al,%eax
801027a5:	f7 d0                	not    %eax
801027a7:	21 d8                	and    %ebx,%eax
}
801027a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027ac:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027b1:	31 c0                	xor    %eax,%eax
}
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    
801027b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c1:	c9                   	leave  
      c += 'a' - 'A';
801027c2:	83 f9 1a             	cmp    $0x1a,%ecx
801027c5:	0f 42 c2             	cmovb  %edx,%eax
}
801027c8:	c3                   	ret    
801027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027e6:	68 00 27 10 80       	push   $0x80102700
801027eb:	e8 90 e0 ff ff       	call   80100880 <consoleintr>
}
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102800:	a1 80 26 11 80       	mov    0x80112680,%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	0f 84 cb 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
8010280d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102814:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010282e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102848:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102855:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285b:	8b 50 30             	mov    0x30(%eax),%edx
8010285e:	c1 ea 10             	shr    $0x10,%edx
80102861:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102867:	75 77                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
80102869:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102876:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
801028b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret    
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 77 ff ff ff       	jmp    80102869 <lapicinit+0x69>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 80 26 11 80       	mov    0x80112680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret    
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret    
80102913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 80 26 11 80       	mov    0x80112680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret    
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret    
80102941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave  
801029de:	c3                   	ret    
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 da                	mov    %ebx,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 da                	mov    %ebx,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a67:	84 c0                	test   %al,%al
80102a69:	78 9d                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	0f b6 fa             	movzbl %dl,%edi
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a80:	89 da                	mov    %ebx,%edx
80102a82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a99:	31 c0                	xor    %eax,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
80102ab0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 da                	mov    %ebx,%edx
80102ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
80102ad2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 da                	mov    %ebx,%edx
80102ad7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 da                	mov    %ebx,%edx
80102ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aeb:	b8 09 00 00 00       	mov    $0x9,%eax
80102af0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af1:	89 ca                	mov    %ecx,%edx
80102af3:	ec                   	in     (%dx),%al
80102af4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102afd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b00:	6a 18                	push   $0x18
80102b02:	50                   	push   %eax
80102b03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b06:	50                   	push   %eax
80102b07:	e8 04 1c 00 00       	call   80104710 <memcmp>
80102b0c:	83 c4 10             	add    $0x10,%esp
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	0f 85 f1 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b1b:	75 78                	jne    80102b95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b95:	8b 75 08             	mov    0x8(%ebp),%esi
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 06                	mov    %eax,(%esi)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 46 04             	mov    %eax,0x4(%esi)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 46 08             	mov    %eax,0x8(%esi)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 46 0c             	mov    %eax,0xc(%esi)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 46 10             	mov    %eax,0x10(%esi)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 e4 26 11 80    	push   0x801126e4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c14:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 27 1b 00 00       	call   80104760 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret    
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret    
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 d4 26 11 80    	push   0x801126d4
80102c7d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave  
80102cca:	c3                   	ret    
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 00 7f 10 80       	push   $0x80107f00
80102cdf:	68 a0 26 11 80       	push   $0x801126a0
80102ce4:	e8 47 17 00 00       	call   80104430 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 3b e8 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d07:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave  
80102d66:	c3                   	ret    
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 a0 26 11 80       	push   $0x801126a0
80102d7b:	e8 80 18 00 00       	call   80104600 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 a0 26 11 80       	push   $0x801126a0
80102d90:	68 a0 26 11 80       	push   $0x801126a0
80102d95:	e8 06 13 00 00       	call   801040a0 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dab:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102dc7:	68 a0 26 11 80       	push   $0x801126a0
80102dcc:	e8 cf 17 00 00       	call   801045a0 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    
80102dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 a0 26 11 80       	push   $0x801126a0
80102dee:	e8 0d 18 00 00       	call   80104600 <acquire>
  log.outstanding -= 1;
80102df3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102df8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 a0 26 11 80       	push   $0x801126a0
80102e2c:	e8 6f 17 00 00       	call   801045a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 a0 26 11 80       	push   $0x801126a0
80102e46:	e8 b5 17 00 00       	call   80104600 <acquire>
    wakeup(&log);
80102e4b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e52:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e59:	00 00 00 
    wakeup(&log);
80102e5c:	e8 ff 12 00 00       	call   80104160 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e68:	e8 33 17 00 00       	call   801045a0 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret    
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102ea4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 97 18 00 00       	call   80104760 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 a0 26 11 80       	push   $0x801126a0
80102f18:	e8 43 12 00 00       	call   80104160 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f24:	e8 77 16 00 00       	call   801045a0 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret    
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 04 7f 10 80       	push   $0x80107f04
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	0f 8f 85 00 00 00    	jg     80102fee <log_write+0x9e>
80102f69:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f6e:	83 e8 01             	sub    $0x1,%eax
80102f71:	39 c2                	cmp    %eax,%edx
80102f73:	7d 79                	jge    80102fee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f75:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	7e 7d                	jle    80102ffb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 a0 26 11 80       	push   $0x801126a0
80102f86:	e8 75 16 00 00       	call   80104600 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	85 d2                	test   %edx,%edx
80102f96:	7e 4a                	jle    80102fe2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f98:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	31 c0                	xor    %eax,%eax
80102f9d:	eb 08                	jmp    80102fa7 <log_write+0x57>
80102f9f:	90                   	nop
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fc4:	c9                   	leave  
  release(&log.lock);
80102fc5:	e9 d6 15 00 00       	jmp    801045a0 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x67>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x87>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 13 7f 10 80       	push   $0x80107f13
80102ff6:	e8 85 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 29 7f 10 80       	push   $0x80107f29
80103003:	e8 78 d3 ff ff       	call   80100380 <panic>
80103008:	66 90                	xchg   %ax,%ax
8010300a:	66 90                	xchg   %ax,%ax
8010300c:	66 90                	xchg   %ax,%ax
8010300e:	66 90                	xchg   %ax,%ax

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 94 09 00 00       	call   801039b0 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 8d 09 00 00       	call   801039b0 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 44 7f 10 80       	push   $0x80107f44
8010302d:	e8 6e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 f9 2e 00 00       	call   80105f30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 14 09 00 00       	call   80103950 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 41 0c 00 00       	call   80103c90 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 d5 41 00 00       	call   80107230 <switchkvm>
  seginit();
8010305b:	e8 c0 3f 00 00       	call   80107020 <seginit>
  lapicinit();
80103060:	e8 9b f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103065:	e8 a6 ff ff ff       	call   80103010 <mpmain>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103074:	83 e4 f0             	and    $0xfffffff0,%esp
80103077:	ff 71 fc             	push   -0x4(%ecx)
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	53                   	push   %ebx
8010307e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010307f:	83 ec 08             	sub    $0x8,%esp
80103082:	68 00 00 40 80       	push   $0x80400000
80103087:	68 d0 b5 11 80       	push   $0x8011b5d0
8010308c:	e8 8f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 ca 46 00 00       	call   80107760 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 85 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 7b 3f 00 00       	call   80107020 <seginit>
  picinit();       // disable pic
801030a5:	e8 76 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 31 f3 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 ac d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 e7 32 00 00       	call   801063a0 <uartinit>
  pinit();         // process table
801030b9:	e8 72 08 00 00       	call   80103930 <pinit>
  tvinit();        // trap vectors
801030be:	e8 ed 2d 00 00       	call   80105eb0 <tvinit>
  binit();         // buffer cache
801030c3:	e8 78 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030c8:	e8 53 dd ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801030cd:	e8 fe f0 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d2:	83 c4 0c             	add    $0xc,%esp
801030d5:	68 8a 00 00 00       	push   $0x8a
801030da:	68 8c b4 10 80       	push   $0x8010b48c
801030df:	68 00 70 00 80       	push   $0x80007000
801030e4:	e8 77 16 00 00       	call   80104760 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030f3:	00 00 00 
801030f6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030fb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103100:	76 7e                	jbe    80103180 <main+0x110>
80103102:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103107:	eb 20                	jmp    80103129 <main+0xb9>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103110:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 57                	jae    80103180 <main+0x110>
    if(c == mycpu())  // We've started already.
80103129:	e8 22 08 00 00       	call   80103950 <mycpu>
8010312e:	39 c3                	cmp    %eax,%ebx
80103130:	74 de                	je     80103110 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103132:	e8 59 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103137:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010313a:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
80103141:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103144:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010314b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
80103153:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103158:	0f b6 03             	movzbl (%ebx),%eax
8010315b:	68 00 70 00 00       	push   $0x7000
80103160:	50                   	push   %eax
80103161:	e8 ea f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0x100>
8010317a:	eb 94                	jmp    80103110 <main+0xa0>
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 00 00 00 8e       	push   $0x8e000000
80103188:	68 00 00 40 80       	push   $0x80400000
8010318d:	e8 2e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103192:	e8 69 08 00 00       	call   80103a00 <userinit>
  mpmain();        // finish this processor's setup
80103197:	e8 74 fe ff ff       	call   80103010 <mpmain>
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 58 7f 10 80       	push   $0x80107f58
801031d3:	56                   	push   %esi
801031d4:	e8 37 15 00 00       	call   80104710 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
80103214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103229:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103230:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103237:	c1 e0 08             	shl    $0x8,%eax
8010323a:	09 d0                	or     %edx,%eax
8010323c:	c1 e0 04             	shl    $0x4,%eax
8010323f:	75 1b                	jne    8010325c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103241:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103248:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010324f:	c1 e0 08             	shl    $0x8,%eax
80103252:	09 d0                	or     %edx,%eax
80103254:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103257:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010325c:	ba 00 04 00 00       	mov    $0x400,%edx
80103261:	e8 3a ff ff ff       	call   801031a0 <mpsearch1>
80103266:	89 c3                	mov    %eax,%ebx
80103268:	85 c0                	test   %eax,%eax
8010326a:	0f 84 40 01 00 00    	je     801033b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103270:	8b 73 04             	mov    0x4(%ebx),%esi
80103273:	85 f6                	test   %esi,%esi
80103275:	0f 84 25 01 00 00    	je     801033a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103284:	6a 04                	push   $0x4
80103286:	68 5d 7f 10 80       	push   $0x80107f5d
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 7c 14 00 00       	call   80104710 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 01 01 00 00    	jne    801033a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010329f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032a6:	3c 01                	cmp    $0x1,%al
801032a8:	74 08                	je     801032b2 <mpinit+0x92>
801032aa:	3c 04                	cmp    $0x4,%al
801032ac:	0f 85 ee 00 00 00    	jne    801033a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032b9:	66 85 d2             	test   %dx,%dx
801032bc:	74 22                	je     801032e0 <mpinit+0xc0>
801032be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032c3:	31 d2                	xor    %edx,%edx
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032d4:	39 c7                	cmp    %eax,%edi
801032d6:	75 f0                	jne    801032c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032d8:	84 d2                	test   %dl,%dl
801032da:	0f 85 c0 00 00 00    	jne    801033a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032e6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103300:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103307:	90                   	nop
80103308:	39 d0                	cmp    %edx,%eax
8010330a:	73 15                	jae    80103321 <mpinit+0x101>
    switch(*p){
8010330c:	0f b6 08             	movzbl (%eax),%ecx
8010330f:	80 f9 02             	cmp    $0x2,%cl
80103312:	74 4c                	je     80103360 <mpinit+0x140>
80103314:	77 3a                	ja     80103350 <mpinit+0x130>
80103316:	84 c9                	test   %cl,%cl
80103318:	74 56                	je     80103370 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010331a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	39 d0                	cmp    %edx,%eax
8010331f:	72 eb                	jb     8010330c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103324:	85 f6                	test   %esi,%esi
80103326:	0f 84 d9 00 00 00    	je     80103405 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103330:	74 15                	je     80103347 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103332:	b8 70 00 00 00       	mov    $0x70,%eax
80103337:	ba 22 00 00 00       	mov    $0x22,%edx
8010333c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333d:	ba 23 00 00 00       	mov    $0x23,%edx
80103342:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103343:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ee                   	out    %al,(%dx)
  }
}
80103347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334a:	5b                   	pop    %ebx
8010334b:	5e                   	pop    %esi
8010334c:	5f                   	pop    %edi
8010334d:	5d                   	pop    %ebp
8010334e:	c3                   	ret    
8010334f:	90                   	nop
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 c2                	jbe    8010331a <mpinit+0xfa>
80103358:	31 f6                	xor    %esi,%esi
8010335a:	eb ac                	jmp    80103308 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010336d:	eb 99                	jmp    80103308 <mpinit+0xe8>
8010336f:	90                   	nop
      if(ncpu < NCPU) {
80103370:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 6c ff ff ff       	jmp    80103308 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 62 7f 10 80       	push   $0x80107f62
801033a8:	e8 d3 cf ff ff       	call   80100380 <panic>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033b5:	eb 13                	jmp    801033ca <mpinit+0x1aa>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 d6                	je     801033a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 58 7f 10 80       	push   $0x80107f58
801033d7:	53                   	push   %ebx
801033d8:	e8 33 13 00 00       	call   80104710 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1a0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1a0>
80103400:	e9 6b fe ff ff       	jmp    80103270 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 7c 7f 10 80       	push   $0x80107f7c
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret    
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 e0 d9 ff ff       	call   80100e40 <filealloc>
80103460:	89 03                	mov    %eax,(%ebx)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 d1 d9 ff ff       	call   80100e40 <filealloc>
8010346f:	89 06                	mov    %eax,(%esi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c7                	mov    %eax,%edi
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 9b 7f 10 80       	push   $0x80107f9b
801034b8:	50                   	push   %eax
801034b9:	e8 72 0f 00 00       	call   80104430 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 03                	mov    (%ebx),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 03                	mov    (%ebx),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 03                	mov    (%ebx),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 06                	mov    (%esi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 f1 d9 ff ff       	call   80100f00 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 06                	mov    (%esi),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 df d9 ff ff       	call   80100f00 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 ac 10 00 00       	call   80104600 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 65                	je     801035c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 ec 0b 00 00       	call   80104160 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 15                	je     801035a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 07 10 00 00       	jmp    801045a0 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 f7 0f 00 00       	call   801045a0 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 16 ef ff ff       	jmp    801024d0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 87 0b 00 00       	call   80104160 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb 99                	jmp    80103577 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 0e 10 00 00       	call   80104600 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c0 00 00 00    	jle    801036c0 <pipewrite+0xe0>
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103603:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103612:	03 45 10             	add    0x10(%ebp),%eax
80103615:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103624:	89 ca                	mov    %ecx,%edx
80103626:	05 00 02 00 00       	add    $0x200,%eax
8010362b:	39 c1                	cmp    %eax,%ecx
8010362d:	74 3f                	je     8010366e <pipewrite+0x8e>
8010362f:	eb 67                	jmp    80103698 <pipewrite+0xb8>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103638:	e8 93 03 00 00       	call   801039d0 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 13 0b 00 00       	call   80104160 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 4a 0a 00 00       	call   801040a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103656:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103662:	83 c4 10             	add    $0x10,%esp
80103665:	05 00 02 00 00       	add    $0x200,%eax
8010366a:	39 c2                	cmp    %eax,%edx
8010366c:	75 2a                	jne    80103698 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010366e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	75 c0                	jne    80103638 <pipewrite+0x58>
        release(&p->lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	53                   	push   %ebx
8010367c:	e8 1f 0f 00 00       	call   801045a0 <release>
        return -1;
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ad:	83 c6 01             	add    $0x1,%esi
801036b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ba:	0f 85 58 ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c9:	50                   	push   %eax
801036ca:	e8 91 0a 00 00       	call   80104160 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 c9 0e 00 00       	call   801045a0 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb aa                	jmp    80103689 <pipewrite+0xa9>
801036df:	90                   	nop

801036e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	56                   	push   %esi
801036f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036f6:	e8 05 0f 00 00       	call   80104600 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 bb 02 00 00       	call   801039d0 <myproc>
80103715:	8b 48 24             	mov    0x24(%eax),%ecx
80103718:	85 c9                	test   %ecx,%ecx
8010371a:	0f 85 80 00 00 00    	jne    801037a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	e8 76 09 00 00       	call   801040a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103739:	75 0a                	jne    80103745 <piperead+0x65>
8010373b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 cb                	jne    80103710 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	8b 55 10             	mov    0x10(%ebp),%edx
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	85 d2                	test   %edx,%edx
8010374c:	7f 20                	jg     8010376e <piperead+0x8e>
8010374e:	eb 2c                	jmp    8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 d5 09 00 00       	call   80104160 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 0d 0e 00 00       	call   801045a0 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret    
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 f2 0d 00 00       	call   801045a0 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret    
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 20 2d 11 80       	push   $0x80112d20
801037d1:	e8 2a 0e 00 00       	call   80104600 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 17                	jmp    801037f2 <allocproc+0x32>
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
801037e6:	81 fb 54 9d 11 80    	cmp    $0x80119d54,%ebx
801037ec:	0f 84 be 00 00 00    	je     801038b0 <allocproc+0xf0>
    if(p->state == UNUSED)
801037f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037f5:	85 c0                	test   %eax,%eax
801037f7:	75 e7                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037fe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103801:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103808:	89 43 10             	mov    %eax,0x10(%ebx)
8010380b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010380e:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103813:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103819:	e8 82 0d 00 00       	call   801045a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010381e:	e8 6d ee ff ff       	call   80102690 <kalloc>
80103823:	83 c4 10             	add    $0x10,%esp
80103826:	89 43 08             	mov    %eax,0x8(%ebx)
80103829:	85 c0                	test   %eax,%eax
8010382b:	0f 84 98 00 00 00    	je     801038c9 <allocproc+0x109>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103831:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103837:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010383f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103842:	c7 40 14 98 5e 10 80 	movl   $0x80105e98,0x14(%eax)
  p->context = (struct context*)sp;
80103849:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010384c:	6a 14                	push   $0x14
8010384e:	6a 00                	push   $0x0
80103850:	50                   	push   %eax
80103851:	e8 6a 0e 00 00       	call   801046c0 <memset>
  p->context->eip = (uint)forkret;
80103856:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103859:	8d 93 bc 01 00 00    	lea    0x1bc(%ebx),%edx
8010385f:	83 c4 10             	add    $0x10,%esp
80103862:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)

  // ----- p5 -----

  // initialize the memory mapping meta-data
  for(int i=0; i<16; i++)
80103869:	8d 43 7c             	lea    0x7c(%ebx),%eax
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    // struct initialization
    p->mapinfo[i].start_addr = -1;
80103870:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  for(int i=0; i<16; i++)
80103876:	83 c0 14             	add    $0x14,%eax
    p->mapinfo[i].end_addr = -1;
80103879:	c7 40 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%eax)
    p->mapinfo[i].map_length = -1;
80103880:	c7 40 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%eax)
    p->mapinfo[i].pages_in_map = -1;
80103887:	c7 40 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%eax)
    p->mapinfo[i].file_desc = -1;
8010388e:	c7 40 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%eax)
  for(int i=0; i<16; i++)
80103895:	39 d0                	cmp    %edx,%eax
80103897:	75 d7                	jne    80103870 <allocproc+0xb0>
  }

  // set number of memory maps for the process = 0
  p->num_maps = 0;
80103899:	c7 83 bc 01 00 00 00 	movl   $0x0,0x1bc(%ebx)
801038a0:	00 00 00 
  // memset(p->start_addr, -1, 16*sizeof(int));
  // memset(p->map_length, -1, 16*sizeof(int));
  // memset(p->pages_in_map, -1, 16*sizeof(int));
  // memset(p->file_desc, -1, 16*sizeof(int));
  return p;
}
801038a3:	89 d8                	mov    %ebx,%eax
801038a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a8:	c9                   	leave  
801038a9:	c3                   	ret    
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038b5:	68 20 2d 11 80       	push   $0x80112d20
801038ba:	e8 e1 0c 00 00       	call   801045a0 <release>
}
801038bf:	89 d8                	mov    %ebx,%eax
  return 0;
801038c1:	83 c4 10             	add    $0x10,%esp
}
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave  
801038c8:	c3                   	ret    
    p->state = UNUSED;
801038c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038d0:	31 db                	xor    %ebx,%ebx
}
801038d2:	89 d8                	mov    %ebx,%eax
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038e6:	68 20 2d 11 80       	push   $0x80112d20
801038eb:	e8 b0 0c 00 00       	call   801045a0 <release>

  if (first) {
801038f0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	85 c0                	test   %eax,%eax
801038fa:	75 04                	jne    80103900 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038fc:	c9                   	leave  
801038fd:	c3                   	ret    
801038fe:	66 90                	xchg   %ax,%ax
    first = 0;
80103900:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103907:	00 00 00 
    iinit(ROOTDEV);
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	6a 01                	push   $0x1
8010390f:	e8 5c dc ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010391b:	e8 b0 f3 ff ff       	call   80102cd0 <initlog>
}
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	c9                   	leave  
80103924:	c3                   	ret    
80103925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103930 <pinit>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103936:	68 a0 7f 10 80       	push   $0x80107fa0
8010393b:	68 20 2d 11 80       	push   $0x80112d20
80103940:	e8 eb 0a 00 00       	call   80104430 <initlock>
}
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	c9                   	leave  
80103949:	c3                   	ret    
8010394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103950 <mycpu>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103955:	9c                   	pushf  
80103956:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103957:	f6 c4 02             	test   $0x2,%ah
8010395a:	75 46                	jne    801039a2 <mycpu+0x52>
  apicid = lapicid();
8010395c:	e8 9f ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103961:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103967:	85 f6                	test   %esi,%esi
80103969:	7e 2a                	jle    80103995 <mycpu+0x45>
8010396b:	31 d2                	xor    %edx,%edx
8010396d:	eb 08                	jmp    80103977 <mycpu+0x27>
8010396f:	90                   	nop
80103970:	83 c2 01             	add    $0x1,%edx
80103973:	39 f2                	cmp    %esi,%edx
80103975:	74 1e                	je     80103995 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103977:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010397d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103984:	39 c3                	cmp    %eax,%ebx
80103986:	75 e8                	jne    80103970 <mycpu+0x20>
}
80103988:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010398b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103991:	5b                   	pop    %ebx
80103992:	5e                   	pop    %esi
80103993:	5d                   	pop    %ebp
80103994:	c3                   	ret    
  panic("unknown apicid\n");
80103995:	83 ec 0c             	sub    $0xc,%esp
80103998:	68 a7 7f 10 80       	push   $0x80107fa7
8010399d:	e8 de c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039a2:	83 ec 0c             	sub    $0xc,%esp
801039a5:	68 84 80 10 80       	push   $0x80108084
801039aa:	e8 d1 c9 ff ff       	call   80100380 <panic>
801039af:	90                   	nop

801039b0 <cpuid>:
cpuid() {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039b6:	e8 95 ff ff ff       	call   80103950 <mycpu>
}
801039bb:	c9                   	leave  
  return mycpu()-cpus;
801039bc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801039c1:	c1 f8 04             	sar    $0x4,%eax
801039c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ca:	c3                   	ret    
801039cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop

801039d0 <myproc>:
myproc(void) {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039d7:	e8 d4 0a 00 00       	call   801044b0 <pushcli>
  c = mycpu();
801039dc:	e8 6f ff ff ff       	call   80103950 <mycpu>
  p = c->proc;
801039e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039e7:	e8 14 0b 00 00       	call   80104500 <popcli>
}
801039ec:	89 d8                	mov    %ebx,%eax
801039ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f1:	c9                   	leave  
801039f2:	c3                   	ret    
801039f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a00 <userinit>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a07:	e8 b4 fd ff ff       	call   801037c0 <allocproc>
80103a0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a0e:	a3 54 9d 11 80       	mov    %eax,0x80119d54
  if((p->pgdir = setupkvm()) == 0)
80103a13:	e8 c8 3c 00 00       	call   801076e0 <setupkvm>
80103a18:	89 43 04             	mov    %eax,0x4(%ebx)
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	0f 84 bd 00 00 00    	je     80103ae0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a23:	83 ec 04             	sub    $0x4,%esp
80103a26:	68 2c 00 00 00       	push   $0x2c
80103a2b:	68 60 b4 10 80       	push   $0x8010b460
80103a30:	50                   	push   %eax
80103a31:	e8 1a 39 00 00       	call   80107350 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a36:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a3f:	6a 4c                	push   $0x4c
80103a41:	6a 00                	push   $0x0
80103a43:	ff 73 18             	push   0x18(%ebx)
80103a46:	e8 75 0c 00 00       	call   801046c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a53:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a56:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a71:	8b 43 18             	mov    0x18(%ebx),%eax
80103a74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a78:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a86:	8b 43 18             	mov    0x18(%ebx),%eax
80103a89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a90:	8b 43 18             	mov    0x18(%ebx),%eax
80103a93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a9d:	6a 10                	push   $0x10
80103a9f:	68 d0 7f 10 80       	push   $0x80107fd0
80103aa4:	50                   	push   %eax
80103aa5:	e8 d6 0d 00 00       	call   80104880 <safestrcpy>
  p->cwd = namei("/");
80103aaa:	c7 04 24 d9 7f 10 80 	movl   $0x80107fd9,(%esp)
80103ab1:	e8 fa e5 ff ff       	call   801020b0 <namei>
80103ab6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ab9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ac0:	e8 3b 0b 00 00       	call   80104600 <acquire>
  p->state = RUNNABLE;
80103ac5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103acc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ad3:	e8 c8 0a 00 00       	call   801045a0 <release>
}
80103ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103adb:	83 c4 10             	add    $0x10,%esp
80103ade:	c9                   	leave  
80103adf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ae0:	83 ec 0c             	sub    $0xc,%esp
80103ae3:	68 b7 7f 10 80       	push   $0x80107fb7
80103ae8:	e8 93 c8 ff ff       	call   80100380 <panic>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi

80103af0 <growproc>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
80103af5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103af8:	e8 b3 09 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103afd:	e8 4e fe ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b08:	e8 f3 09 00 00       	call   80104500 <popcli>
  sz = curproc->sz;
80103b0d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b0f:	85 f6                	test   %esi,%esi
80103b11:	7f 1d                	jg     80103b30 <growproc+0x40>
  } else if(n < 0){
80103b13:	75 3b                	jne    80103b50 <growproc+0x60>
  switchuvm(curproc);
80103b15:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b18:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b1a:	53                   	push   %ebx
80103b1b:	e8 20 37 00 00       	call   80107240 <switchuvm>
  return 0;
80103b20:	83 c4 10             	add    $0x10,%esp
80103b23:	31 c0                	xor    %eax,%eax
}
80103b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b28:	5b                   	pop    %ebx
80103b29:	5e                   	pop    %esi
80103b2a:	5d                   	pop    %ebp
80103b2b:	c3                   	ret    
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	push   0x4(%ebx)
80103b3a:	e8 c1 39 00 00       	call   80107500 <allocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 cf                	jne    80103b15 <growproc+0x25>
      return -1;
80103b46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b4b:	eb d8                	jmp    80103b25 <growproc+0x35>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c6                	add    %eax,%esi
80103b55:	56                   	push   %esi
80103b56:	50                   	push   %eax
80103b57:	ff 73 04             	push   0x4(%ebx)
80103b5a:	e8 d1 3a 00 00       	call   80107630 <deallocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 af                	jne    80103b15 <growproc+0x25>
80103b66:	eb de                	jmp    80103b46 <growproc+0x56>
80103b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop

80103b70 <fork>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b79:	e8 32 09 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103b7e:	e8 cd fd ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b89:	e8 72 09 00 00       	call   80104500 <popcli>
  if((np = allocproc()) == 0){
80103b8e:	e8 2d fc ff ff       	call   801037c0 <allocproc>
80103b93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b96:	85 c0                	test   %eax,%eax
80103b98:	0f 84 b7 00 00 00    	je     80103c55 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b9e:	83 ec 08             	sub    $0x8,%esp
80103ba1:	ff 33                	push   (%ebx)
80103ba3:	89 c7                	mov    %eax,%edi
80103ba5:	ff 73 04             	push   0x4(%ebx)
80103ba8:	e8 23 3c 00 00       	call   801077d0 <copyuvm>
80103bad:	83 c4 10             	add    $0x10,%esp
80103bb0:	89 47 04             	mov    %eax,0x4(%edi)
80103bb3:	85 c0                	test   %eax,%eax
80103bb5:	0f 84 a1 00 00 00    	je     80103c5c <fork+0xec>
  np->sz = curproc->sz;
80103bbb:	8b 03                	mov    (%ebx),%eax
80103bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bc0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bc2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bc5:	89 c8                	mov    %ecx,%eax
80103bc7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bca:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bcf:	8b 73 18             	mov    0x18(%ebx),%esi
80103bd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bd4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bd6:	8b 40 18             	mov    0x18(%eax),%eax
80103bd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103be0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 13                	je     80103bfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 bf d2 ff ff       	call   80100eb0 <filedup>
80103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bfb:	83 c6 01             	add    $0x1,%esi
80103bfe:	83 fe 10             	cmp    $0x10,%esi
80103c01:	75 dd                	jne    80103be0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c0c:	e8 4f db ff ff       	call   80101760 <idup>
80103c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	53                   	push   %ebx
80103c20:	50                   	push   %eax
80103c21:	e8 5a 0c 00 00       	call   80104880 <safestrcpy>
  pid = np->pid;
80103c26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c29:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c30:	e8 cb 09 00 00       	call   80104600 <acquire>
  np->state = RUNNABLE;
80103c35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c3c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c43:	e8 58 09 00 00       	call   801045a0 <release>
  return pid;
80103c48:	83 c4 10             	add    $0x10,%esp
}
80103c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c4e:	89 d8                	mov    %ebx,%eax
80103c50:	5b                   	pop    %ebx
80103c51:	5e                   	pop    %esi
80103c52:	5f                   	pop    %edi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret    
    return -1;
80103c55:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c5a:	eb ef                	jmp    80103c4b <fork+0xdb>
    kfree(np->kstack);
80103c5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c5f:	83 ec 0c             	sub    $0xc,%esp
80103c62:	ff 73 08             	push   0x8(%ebx)
80103c65:	e8 66 e8 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103c6a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c71:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c74:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c80:	eb c9                	jmp    80103c4b <fork+0xdb>
80103c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c90 <scheduler>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c99:	e8 b2 fc ff ff       	call   80103950 <mycpu>
  c->proc = 0;
80103c9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ca5:	00 00 00 
  struct cpu *c = mycpu();
80103ca8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103caa:	8d 78 04             	lea    0x4(%eax),%edi
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103cb0:	fb                   	sti    
    acquire(&ptable.lock);
80103cb1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103cb9:	68 20 2d 11 80       	push   $0x80112d20
80103cbe:	e8 3d 09 00 00       	call   80104600 <acquire>
80103cc3:	83 c4 10             	add    $0x10,%esp
80103cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103cd0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cd4:	75 33                	jne    80103d09 <scheduler+0x79>
      switchuvm(p);
80103cd6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cd9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cdf:	53                   	push   %ebx
80103ce0:	e8 5b 35 00 00       	call   80107240 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ce5:	58                   	pop    %eax
80103ce6:	5a                   	pop    %edx
80103ce7:	ff 73 1c             	push   0x1c(%ebx)
80103cea:	57                   	push   %edi
      p->state = RUNNING;
80103ceb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cf2:	e8 e4 0b 00 00       	call   801048db <swtch>
      switchkvm();
80103cf7:	e8 34 35 00 00       	call   80107230 <switchkvm>
      c->proc = 0;
80103cfc:	83 c4 10             	add    $0x10,%esp
80103cff:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d06:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d09:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
80103d0f:	81 fb 54 9d 11 80    	cmp    $0x80119d54,%ebx
80103d15:	75 b9                	jne    80103cd0 <scheduler+0x40>
    release(&ptable.lock);
80103d17:	83 ec 0c             	sub    $0xc,%esp
80103d1a:	68 20 2d 11 80       	push   $0x80112d20
80103d1f:	e8 7c 08 00 00       	call   801045a0 <release>
    sti();
80103d24:	83 c4 10             	add    $0x10,%esp
80103d27:	eb 87                	jmp    80103cb0 <scheduler+0x20>
80103d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d30 <sched>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
  pushcli();
80103d35:	e8 76 07 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103d3a:	e8 11 fc ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103d3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d45:	e8 b6 07 00 00       	call   80104500 <popcli>
  if(!holding(&ptable.lock))
80103d4a:	83 ec 0c             	sub    $0xc,%esp
80103d4d:	68 20 2d 11 80       	push   $0x80112d20
80103d52:	e8 09 08 00 00       	call   80104560 <holding>
80103d57:	83 c4 10             	add    $0x10,%esp
80103d5a:	85 c0                	test   %eax,%eax
80103d5c:	74 4f                	je     80103dad <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d5e:	e8 ed fb ff ff       	call   80103950 <mycpu>
80103d63:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d6a:	75 68                	jne    80103dd4 <sched+0xa4>
  if(p->state == RUNNING)
80103d6c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d70:	74 55                	je     80103dc7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d72:	9c                   	pushf  
80103d73:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d74:	f6 c4 02             	test   $0x2,%ah
80103d77:	75 41                	jne    80103dba <sched+0x8a>
  intena = mycpu()->intena;
80103d79:	e8 d2 fb ff ff       	call   80103950 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d7e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d81:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d87:	e8 c4 fb ff ff       	call   80103950 <mycpu>
80103d8c:	83 ec 08             	sub    $0x8,%esp
80103d8f:	ff 70 04             	push   0x4(%eax)
80103d92:	53                   	push   %ebx
80103d93:	e8 43 0b 00 00       	call   801048db <swtch>
  mycpu()->intena = intena;
80103d98:	e8 b3 fb ff ff       	call   80103950 <mycpu>
}
80103d9d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103da0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103da9:	5b                   	pop    %ebx
80103daa:	5e                   	pop    %esi
80103dab:	5d                   	pop    %ebp
80103dac:	c3                   	ret    
    panic("sched ptable.lock");
80103dad:	83 ec 0c             	sub    $0xc,%esp
80103db0:	68 db 7f 10 80       	push   $0x80107fdb
80103db5:	e8 c6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 07 80 10 80       	push   $0x80108007
80103dc2:	e8 b9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103dc7:	83 ec 0c             	sub    $0xc,%esp
80103dca:	68 f9 7f 10 80       	push   $0x80107ff9
80103dcf:	e8 ac c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	68 ed 7f 10 80       	push   $0x80107fed
80103ddc:	e8 9f c5 ff ff       	call   80100380 <panic>
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103def:	90                   	nop

80103df0 <exit>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103df9:	e8 d2 fb ff ff       	call   801039d0 <myproc>
  if(curproc == initproc)
80103dfe:	39 05 54 9d 11 80    	cmp    %eax,0x80119d54
80103e04:	0f 84 07 01 00 00    	je     80103f11 <exit+0x121>
80103e0a:	89 c3                	mov    %eax,%ebx
80103e0c:	8d 70 28             	lea    0x28(%eax),%esi
80103e0f:	8d 78 68             	lea    0x68(%eax),%edi
80103e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e18:	8b 06                	mov    (%esi),%eax
80103e1a:	85 c0                	test   %eax,%eax
80103e1c:	74 12                	je     80103e30 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e1e:	83 ec 0c             	sub    $0xc,%esp
80103e21:	50                   	push   %eax
80103e22:	e8 d9 d0 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80103e27:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e2d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e30:	83 c6 04             	add    $0x4,%esi
80103e33:	39 f7                	cmp    %esi,%edi
80103e35:	75 e1                	jne    80103e18 <exit+0x28>
  begin_op();
80103e37:	e8 34 ef ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
80103e3c:	83 ec 0c             	sub    $0xc,%esp
80103e3f:	ff 73 68             	push   0x68(%ebx)
80103e42:	e8 79 da ff ff       	call   801018c0 <iput>
  end_op();
80103e47:	e8 94 ef ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103e4c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e5a:	e8 a1 07 00 00       	call   80104600 <acquire>
  wakeup1(curproc->parent);
80103e5f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e62:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e65:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e6a:	eb 10                	jmp    80103e7c <exit+0x8c>
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e70:	05 c0 01 00 00       	add    $0x1c0,%eax
80103e75:	3d 54 9d 11 80       	cmp    $0x80119d54,%eax
80103e7a:	74 1e                	je     80103e9a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103e7c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e80:	75 ee                	jne    80103e70 <exit+0x80>
80103e82:	3b 50 20             	cmp    0x20(%eax),%edx
80103e85:	75 e9                	jne    80103e70 <exit+0x80>
      p->state = RUNNABLE;
80103e87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8e:	05 c0 01 00 00       	add    $0x1c0,%eax
80103e93:	3d 54 9d 11 80       	cmp    $0x80119d54,%eax
80103e98:	75 e2                	jne    80103e7c <exit+0x8c>
      p->parent = initproc;
80103e9a:	8b 0d 54 9d 11 80    	mov    0x80119d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ea5:	eb 17                	jmp    80103ebe <exit+0xce>
80103ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eae:	66 90                	xchg   %ax,%ax
80103eb0:	81 c2 c0 01 00 00    	add    $0x1c0,%edx
80103eb6:	81 fa 54 9d 11 80    	cmp    $0x80119d54,%edx
80103ebc:	74 3a                	je     80103ef8 <exit+0x108>
    if(p->parent == curproc){
80103ebe:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103ec1:	75 ed                	jne    80103eb0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103ec3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ec7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eca:	75 e4                	jne    80103eb0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ecc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ed1:	eb 11                	jmp    80103ee4 <exit+0xf4>
80103ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed7:	90                   	nop
80103ed8:	05 c0 01 00 00       	add    $0x1c0,%eax
80103edd:	3d 54 9d 11 80       	cmp    $0x80119d54,%eax
80103ee2:	74 cc                	je     80103eb0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103ee4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ee8:	75 ee                	jne    80103ed8 <exit+0xe8>
80103eea:	3b 48 20             	cmp    0x20(%eax),%ecx
80103eed:	75 e9                	jne    80103ed8 <exit+0xe8>
      p->state = RUNNABLE;
80103eef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ef6:	eb e0                	jmp    80103ed8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103ef8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103eff:	e8 2c fe ff ff       	call   80103d30 <sched>
  panic("zombie exit");
80103f04:	83 ec 0c             	sub    $0xc,%esp
80103f07:	68 28 80 10 80       	push   $0x80108028
80103f0c:	e8 6f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f11:	83 ec 0c             	sub    $0xc,%esp
80103f14:	68 1b 80 10 80       	push   $0x8010801b
80103f19:	e8 62 c4 ff ff       	call   80100380 <panic>
80103f1e:	66 90                	xchg   %ax,%ax

80103f20 <wait>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	56                   	push   %esi
80103f24:	53                   	push   %ebx
  pushcli();
80103f25:	e8 86 05 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103f2a:	e8 21 fa ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103f2f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f35:	e8 c6 05 00 00       	call   80104500 <popcli>
  acquire(&ptable.lock);
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 20 2d 11 80       	push   $0x80112d20
80103f42:	e8 b9 06 00 00       	call   80104600 <acquire>
80103f47:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f4a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f4c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f51:	eb 13                	jmp    80103f66 <wait+0x46>
80103f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f57:	90                   	nop
80103f58:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
80103f5e:	81 fb 54 9d 11 80    	cmp    $0x80119d54,%ebx
80103f64:	74 1e                	je     80103f84 <wait+0x64>
      if(p->parent != curproc)
80103f66:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f69:	75 ed                	jne    80103f58 <wait+0x38>
      if(p->state == ZOMBIE){
80103f6b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f6f:	74 5f                	je     80103fd0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f71:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
      havekids = 1;
80103f77:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7c:	81 fb 54 9d 11 80    	cmp    $0x80119d54,%ebx
80103f82:	75 e2                	jne    80103f66 <wait+0x46>
    if(!havekids || curproc->killed){
80103f84:	85 c0                	test   %eax,%eax
80103f86:	0f 84 9a 00 00 00    	je     80104026 <wait+0x106>
80103f8c:	8b 46 24             	mov    0x24(%esi),%eax
80103f8f:	85 c0                	test   %eax,%eax
80103f91:	0f 85 8f 00 00 00    	jne    80104026 <wait+0x106>
  pushcli();
80103f97:	e8 14 05 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80103f9c:	e8 af f9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103fa1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fa7:	e8 54 05 00 00       	call   80104500 <popcli>
  if(p == 0)
80103fac:	85 db                	test   %ebx,%ebx
80103fae:	0f 84 89 00 00 00    	je     8010403d <wait+0x11d>
  p->chan = chan;
80103fb4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fb7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fbe:	e8 6d fd ff ff       	call   80103d30 <sched>
  p->chan = 0;
80103fc3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fca:	e9 7b ff ff ff       	jmp    80103f4a <wait+0x2a>
80103fcf:	90                   	nop
        kfree(p->kstack);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fd3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fd6:	ff 73 08             	push   0x8(%ebx)
80103fd9:	e8 f2 e4 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
80103fde:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fe5:	5a                   	pop    %edx
80103fe6:	ff 73 04             	push   0x4(%ebx)
80103fe9:	e8 72 36 00 00       	call   80107660 <freevm>
        p->pid = 0;
80103fee:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ff5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ffc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104000:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104007:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010400e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104015:	e8 86 05 00 00       	call   801045a0 <release>
        return pid;
8010401a:	83 c4 10             	add    $0x10,%esp
}
8010401d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104020:	89 f0                	mov    %esi,%eax
80104022:	5b                   	pop    %ebx
80104023:	5e                   	pop    %esi
80104024:	5d                   	pop    %ebp
80104025:	c3                   	ret    
      release(&ptable.lock);
80104026:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104029:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010402e:	68 20 2d 11 80       	push   $0x80112d20
80104033:	e8 68 05 00 00       	call   801045a0 <release>
      return -1;
80104038:	83 c4 10             	add    $0x10,%esp
8010403b:	eb e0                	jmp    8010401d <wait+0xfd>
    panic("sleep");
8010403d:	83 ec 0c             	sub    $0xc,%esp
80104040:	68 34 80 10 80       	push   $0x80108034
80104045:	e8 36 c3 ff ff       	call   80100380 <panic>
8010404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104050 <yield>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104057:	68 20 2d 11 80       	push   $0x80112d20
8010405c:	e8 9f 05 00 00       	call   80104600 <acquire>
  pushcli();
80104061:	e8 4a 04 00 00       	call   801044b0 <pushcli>
  c = mycpu();
80104066:	e8 e5 f8 ff ff       	call   80103950 <mycpu>
  p = c->proc;
8010406b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104071:	e8 8a 04 00 00       	call   80104500 <popcli>
  myproc()->state = RUNNABLE;
80104076:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010407d:	e8 ae fc ff ff       	call   80103d30 <sched>
  release(&ptable.lock);
80104082:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104089:	e8 12 05 00 00       	call   801045a0 <release>
}
8010408e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104091:	83 c4 10             	add    $0x10,%esp
80104094:	c9                   	leave  
80104095:	c3                   	ret    
80104096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409d:	8d 76 00             	lea    0x0(%esi),%esi

801040a0 <sleep>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	57                   	push   %edi
801040a4:	56                   	push   %esi
801040a5:	53                   	push   %ebx
801040a6:	83 ec 0c             	sub    $0xc,%esp
801040a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040af:	e8 fc 03 00 00       	call   801044b0 <pushcli>
  c = mycpu();
801040b4:	e8 97 f8 ff ff       	call   80103950 <mycpu>
  p = c->proc;
801040b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040bf:	e8 3c 04 00 00       	call   80104500 <popcli>
  if(p == 0)
801040c4:	85 db                	test   %ebx,%ebx
801040c6:	0f 84 87 00 00 00    	je     80104153 <sleep+0xb3>
  if(lk == 0)
801040cc:	85 f6                	test   %esi,%esi
801040ce:	74 76                	je     80104146 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040d0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801040d6:	74 50                	je     80104128 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	68 20 2d 11 80       	push   $0x80112d20
801040e0:	e8 1b 05 00 00       	call   80104600 <acquire>
    release(lk);
801040e5:	89 34 24             	mov    %esi,(%esp)
801040e8:	e8 b3 04 00 00       	call   801045a0 <release>
  p->chan = chan;
801040ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040f7:	e8 34 fc ff ff       	call   80103d30 <sched>
  p->chan = 0;
801040fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104103:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010410a:	e8 91 04 00 00       	call   801045a0 <release>
    acquire(lk);
8010410f:	89 75 08             	mov    %esi,0x8(%ebp)
80104112:	83 c4 10             	add    $0x10,%esp
}
80104115:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104118:	5b                   	pop    %ebx
80104119:	5e                   	pop    %esi
8010411a:	5f                   	pop    %edi
8010411b:	5d                   	pop    %ebp
    acquire(lk);
8010411c:	e9 df 04 00 00       	jmp    80104600 <acquire>
80104121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104128:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010412b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104132:	e8 f9 fb ff ff       	call   80103d30 <sched>
  p->chan = 0;
80104137:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010413e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104141:	5b                   	pop    %ebx
80104142:	5e                   	pop    %esi
80104143:	5f                   	pop    %edi
80104144:	5d                   	pop    %ebp
80104145:	c3                   	ret    
    panic("sleep without lk");
80104146:	83 ec 0c             	sub    $0xc,%esp
80104149:	68 3a 80 10 80       	push   $0x8010803a
8010414e:	e8 2d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104153:	83 ec 0c             	sub    $0xc,%esp
80104156:	68 34 80 10 80       	push   $0x80108034
8010415b:	e8 20 c2 ff ff       	call   80100380 <panic>

80104160 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010416a:	68 20 2d 11 80       	push   $0x80112d20
8010416f:	e8 8c 04 00 00       	call   80104600 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104177:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010417c:	eb 0e                	jmp    8010418c <wakeup+0x2c>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	05 c0 01 00 00       	add    $0x1c0,%eax
80104185:	3d 54 9d 11 80       	cmp    $0x80119d54,%eax
8010418a:	74 1e                	je     801041aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010418c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104190:	75 ee                	jne    80104180 <wakeup+0x20>
80104192:	3b 58 20             	cmp    0x20(%eax),%ebx
80104195:	75 e9                	jne    80104180 <wakeup+0x20>
      p->state = RUNNABLE;
80104197:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419e:	05 c0 01 00 00       	add    $0x1c0,%eax
801041a3:	3d 54 9d 11 80       	cmp    $0x80119d54,%eax
801041a8:	75 e2                	jne    8010418c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801041aa:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b4:	c9                   	leave  
  release(&ptable.lock);
801041b5:	e9 e6 03 00 00       	jmp    801045a0 <release>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ca:	68 20 2d 11 80       	push   $0x80112d20
801041cf:	e8 2c 04 00 00       	call   80104600 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041dc:	eb 0e                	jmp    801041ec <kill+0x2c>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	05 c0 01 00 00       	add    $0x1c0,%eax
801041e5:	3d 54 9d 11 80       	cmp    $0x80119d54,%eax
801041ea:	74 34                	je     80104220 <kill+0x60>
    if(p->pid == pid){
801041ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801041ef:	75 ef                	jne    801041e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041fc:	75 07                	jne    80104205 <kill+0x45>
        p->state = RUNNABLE;
801041fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	68 20 2d 11 80       	push   $0x80112d20
8010420d:	e8 8e 03 00 00       	call   801045a0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104215:	83 c4 10             	add    $0x10,%esp
80104218:	31 c0                	xor    %eax,%eax
}
8010421a:	c9                   	leave  
8010421b:	c3                   	ret    
8010421c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104220:	83 ec 0c             	sub    $0xc,%esp
80104223:	68 20 2d 11 80       	push   $0x80112d20
80104228:	e8 73 03 00 00       	call   801045a0 <release>
}
8010422d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104230:	83 c4 10             	add    $0x10,%esp
80104233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104238:	c9                   	leave  
80104239:	c3                   	ret    
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104248:	53                   	push   %ebx
80104249:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010424e:	83 ec 3c             	sub    $0x3c,%esp
80104251:	eb 27                	jmp    8010427a <procdump+0x3a>
80104253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104257:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 d8 84 10 80       	push   $0x801084d8
80104260:	e8 3b c4 ff ff       	call   801006a0 <cprintf>
80104265:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104268:	81 c3 c0 01 00 00    	add    $0x1c0,%ebx
8010426e:	81 fb c0 9d 11 80    	cmp    $0x80119dc0,%ebx
80104274:	0f 84 7e 00 00 00    	je     801042f8 <procdump+0xb8>
    if(p->state == UNUSED)
8010427a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	74 e7                	je     80104268 <procdump+0x28>
      state = "???";
80104281:	ba 4b 80 10 80       	mov    $0x8010804b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104286:	83 f8 05             	cmp    $0x5,%eax
80104289:	77 11                	ja     8010429c <procdump+0x5c>
8010428b:	8b 14 85 ac 80 10 80 	mov    -0x7fef7f54(,%eax,4),%edx
      state = "???";
80104292:	b8 4b 80 10 80       	mov    $0x8010804b,%eax
80104297:	85 d2                	test   %edx,%edx
80104299:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010429c:	53                   	push   %ebx
8010429d:	52                   	push   %edx
8010429e:	ff 73 a4             	push   -0x5c(%ebx)
801042a1:	68 4f 80 10 80       	push   $0x8010804f
801042a6:	e8 f5 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042b2:	75 a4                	jne    80104258 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042b4:	83 ec 08             	sub    $0x8,%esp
801042b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042ba:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042bd:	50                   	push   %eax
801042be:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042c1:	8b 40 0c             	mov    0xc(%eax),%eax
801042c4:	83 c0 08             	add    $0x8,%eax
801042c7:	50                   	push   %eax
801042c8:	e8 83 01 00 00       	call   80104450 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042cd:	83 c4 10             	add    $0x10,%esp
801042d0:	8b 17                	mov    (%edi),%edx
801042d2:	85 d2                	test   %edx,%edx
801042d4:	74 82                	je     80104258 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042dc:	52                   	push   %edx
801042dd:	68 a1 7a 10 80       	push   $0x80107aa1
801042e2:	e8 b9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042e7:	83 c4 10             	add    $0x10,%esp
801042ea:	39 fe                	cmp    %edi,%esi
801042ec:	75 e2                	jne    801042d0 <procdump+0x90>
801042ee:	e9 65 ff ff ff       	jmp    80104258 <procdump+0x18>
801042f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f7:	90                   	nop
  }
}
801042f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042fb:	5b                   	pop    %ebx
801042fc:	5e                   	pop    %esi
801042fd:	5f                   	pop    %edi
801042fe:	5d                   	pop    %ebp
801042ff:	c3                   	ret    

80104300 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 0c             	sub    $0xc,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010430a:	68 c4 80 10 80       	push   $0x801080c4
8010430f:	8d 43 04             	lea    0x4(%ebx),%eax
80104312:	50                   	push   %eax
80104313:	e8 18 01 00 00       	call   80104430 <initlock>
  lk->name = name;
80104318:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010431b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104321:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104324:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010432b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010432e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104331:	c9                   	leave  
80104332:	c3                   	ret    
80104333:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104348:	8d 73 04             	lea    0x4(%ebx),%esi
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	56                   	push   %esi
8010434f:	e8 ac 02 00 00       	call   80104600 <acquire>
  while (lk->locked) {
80104354:	8b 13                	mov    (%ebx),%edx
80104356:	83 c4 10             	add    $0x10,%esp
80104359:	85 d2                	test   %edx,%edx
8010435b:	74 16                	je     80104373 <acquiresleep+0x33>
8010435d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104360:	83 ec 08             	sub    $0x8,%esp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
80104365:	e8 36 fd ff ff       	call   801040a0 <sleep>
  while (lk->locked) {
8010436a:	8b 03                	mov    (%ebx),%eax
8010436c:	83 c4 10             	add    $0x10,%esp
8010436f:	85 c0                	test   %eax,%eax
80104371:	75 ed                	jne    80104360 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104373:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104379:	e8 52 f6 ff ff       	call   801039d0 <myproc>
8010437e:	8b 40 10             	mov    0x10(%eax),%eax
80104381:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104384:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104387:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010438a:	5b                   	pop    %ebx
8010438b:	5e                   	pop    %esi
8010438c:	5d                   	pop    %ebp
  release(&lk->lk);
8010438d:	e9 0e 02 00 00       	jmp    801045a0 <release>
80104392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043a8:	8d 73 04             	lea    0x4(%ebx),%esi
801043ab:	83 ec 0c             	sub    $0xc,%esp
801043ae:	56                   	push   %esi
801043af:	e8 4c 02 00 00       	call   80104600 <acquire>
  lk->locked = 0;
801043b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043c1:	89 1c 24             	mov    %ebx,(%esp)
801043c4:	e8 97 fd ff ff       	call   80104160 <wakeup>
  release(&lk->lk);
801043c9:	89 75 08             	mov    %esi,0x8(%ebp)
801043cc:	83 c4 10             	add    $0x10,%esp
}
801043cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d2:	5b                   	pop    %ebx
801043d3:	5e                   	pop    %esi
801043d4:	5d                   	pop    %ebp
  release(&lk->lk);
801043d5:	e9 c6 01 00 00       	jmp    801045a0 <release>
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	31 ff                	xor    %edi,%edi
801043e6:	56                   	push   %esi
801043e7:	53                   	push   %ebx
801043e8:	83 ec 18             	sub    $0x18,%esp
801043eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043ee:	8d 73 04             	lea    0x4(%ebx),%esi
801043f1:	56                   	push   %esi
801043f2:	e8 09 02 00 00       	call   80104600 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043f7:	8b 03                	mov    (%ebx),%eax
801043f9:	83 c4 10             	add    $0x10,%esp
801043fc:	85 c0                	test   %eax,%eax
801043fe:	75 18                	jne    80104418 <holdingsleep+0x38>
  release(&lk->lk);
80104400:	83 ec 0c             	sub    $0xc,%esp
80104403:	56                   	push   %esi
80104404:	e8 97 01 00 00       	call   801045a0 <release>
  return r;
}
80104409:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010440c:	89 f8                	mov    %edi,%eax
8010440e:	5b                   	pop    %ebx
8010440f:	5e                   	pop    %esi
80104410:	5f                   	pop    %edi
80104411:	5d                   	pop    %ebp
80104412:	c3                   	ret    
80104413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104417:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104418:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010441b:	e8 b0 f5 ff ff       	call   801039d0 <myproc>
80104420:	39 58 10             	cmp    %ebx,0x10(%eax)
80104423:	0f 94 c0             	sete   %al
80104426:	0f b6 c0             	movzbl %al,%eax
80104429:	89 c7                	mov    %eax,%edi
8010442b:	eb d3                	jmp    80104400 <holdingsleep+0x20>
8010442d:	66 90                	xchg   %ax,%ax
8010442f:	90                   	nop

80104430 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104436:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010443f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104442:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104449:	5d                   	pop    %ebp
8010444a:	c3                   	ret    
8010444b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010444f:	90                   	nop

80104450 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104450:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104451:	31 d2                	xor    %edx,%edx
{
80104453:	89 e5                	mov    %esp,%ebp
80104455:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104456:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104459:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010445c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010445f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104460:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104466:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010446c:	77 1a                	ja     80104488 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010446e:	8b 58 04             	mov    0x4(%eax),%ebx
80104471:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104474:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104477:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104479:	83 fa 0a             	cmp    $0xa,%edx
8010447c:	75 e2                	jne    80104460 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010447e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104481:	c9                   	leave  
80104482:	c3                   	ret    
80104483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104487:	90                   	nop
  for(; i < 10; i++)
80104488:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010448b:	8d 51 28             	lea    0x28(%ecx),%edx
8010448e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104496:	83 c0 04             	add    $0x4,%eax
80104499:	39 d0                	cmp    %edx,%eax
8010449b:	75 f3                	jne    80104490 <getcallerpcs+0x40>
}
8010449d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a0:	c9                   	leave  
801044a1:	c3                   	ret    
801044a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 04             	sub    $0x4,%esp
801044b7:	9c                   	pushf  
801044b8:	5b                   	pop    %ebx
  asm volatile("cli");
801044b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ba:	e8 91 f4 ff ff       	call   80103950 <mycpu>
801044bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044c5:	85 c0                	test   %eax,%eax
801044c7:	74 17                	je     801044e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044c9:	e8 82 f4 ff ff       	call   80103950 <mycpu>
801044ce:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044e0:	e8 6b f4 ff ff       	call   80103950 <mycpu>
801044e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044f1:	eb d6                	jmp    801044c9 <pushcli+0x19>
801044f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104500 <popcli>:

void
popcli(void)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104506:	9c                   	pushf  
80104507:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104508:	f6 c4 02             	test   $0x2,%ah
8010450b:	75 35                	jne    80104542 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010450d:	e8 3e f4 ff ff       	call   80103950 <mycpu>
80104512:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104519:	78 34                	js     8010454f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010451b:	e8 30 f4 ff ff       	call   80103950 <mycpu>
80104520:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104526:	85 d2                	test   %edx,%edx
80104528:	74 06                	je     80104530 <popcli+0x30>
    sti();
}
8010452a:	c9                   	leave  
8010452b:	c3                   	ret    
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104530:	e8 1b f4 ff ff       	call   80103950 <mycpu>
80104535:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010453b:	85 c0                	test   %eax,%eax
8010453d:	74 eb                	je     8010452a <popcli+0x2a>
  asm volatile("sti");
8010453f:	fb                   	sti    
}
80104540:	c9                   	leave  
80104541:	c3                   	ret    
    panic("popcli - interruptible");
80104542:	83 ec 0c             	sub    $0xc,%esp
80104545:	68 cf 80 10 80       	push   $0x801080cf
8010454a:	e8 31 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	68 e6 80 10 80       	push   $0x801080e6
80104557:	e8 24 be ff ff       	call   80100380 <panic>
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104560 <holding>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 75 08             	mov    0x8(%ebp),%esi
80104568:	31 db                	xor    %ebx,%ebx
  pushcli();
8010456a:	e8 41 ff ff ff       	call   801044b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010456f:	8b 06                	mov    (%esi),%eax
80104571:	85 c0                	test   %eax,%eax
80104573:	75 0b                	jne    80104580 <holding+0x20>
  popcli();
80104575:	e8 86 ff ff ff       	call   80104500 <popcli>
}
8010457a:	89 d8                	mov    %ebx,%eax
8010457c:	5b                   	pop    %ebx
8010457d:	5e                   	pop    %esi
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104580:	8b 5e 08             	mov    0x8(%esi),%ebx
80104583:	e8 c8 f3 ff ff       	call   80103950 <mycpu>
80104588:	39 c3                	cmp    %eax,%ebx
8010458a:	0f 94 c3             	sete   %bl
  popcli();
8010458d:	e8 6e ff ff ff       	call   80104500 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104592:	0f b6 db             	movzbl %bl,%ebx
}
80104595:	89 d8                	mov    %ebx,%eax
80104597:	5b                   	pop    %ebx
80104598:	5e                   	pop    %esi
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret    
8010459b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop

801045a0 <release>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045a8:	e8 03 ff ff ff       	call   801044b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045ad:	8b 03                	mov    (%ebx),%eax
801045af:	85 c0                	test   %eax,%eax
801045b1:	75 15                	jne    801045c8 <release+0x28>
  popcli();
801045b3:	e8 48 ff ff ff       	call   80104500 <popcli>
    panic("release");
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 ed 80 10 80       	push   $0x801080ed
801045c0:	e8 bb bd ff ff       	call   80100380 <panic>
801045c5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801045c8:	8b 73 08             	mov    0x8(%ebx),%esi
801045cb:	e8 80 f3 ff ff       	call   80103950 <mycpu>
801045d0:	39 c6                	cmp    %eax,%esi
801045d2:	75 df                	jne    801045b3 <release+0x13>
  popcli();
801045d4:	e8 27 ff ff ff       	call   80104500 <popcli>
  lk->pcs[0] = 0;
801045d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045e0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045e7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f5:	5b                   	pop    %ebx
801045f6:	5e                   	pop    %esi
801045f7:	5d                   	pop    %ebp
  popcli();
801045f8:	e9 03 ff ff ff       	jmp    80104500 <popcli>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi

80104600 <acquire>:
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104607:	e8 a4 fe ff ff       	call   801044b0 <pushcli>
  if(holding(lk))
8010460c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010460f:	e8 9c fe ff ff       	call   801044b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104614:	8b 03                	mov    (%ebx),%eax
80104616:	85 c0                	test   %eax,%eax
80104618:	75 7e                	jne    80104698 <acquire+0x98>
  popcli();
8010461a:	e8 e1 fe ff ff       	call   80104500 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010461f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104628:	8b 55 08             	mov    0x8(%ebp),%edx
8010462b:	89 c8                	mov    %ecx,%eax
8010462d:	f0 87 02             	lock xchg %eax,(%edx)
80104630:	85 c0                	test   %eax,%eax
80104632:	75 f4                	jne    80104628 <acquire+0x28>
  __sync_synchronize();
80104634:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010463c:	e8 0f f3 ff ff       	call   80103950 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104641:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104644:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104646:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104649:	31 c0                	xor    %eax,%eax
8010464b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104650:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104656:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010465c:	77 1a                	ja     80104678 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010465e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104661:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104665:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104668:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010466a:	83 f8 0a             	cmp    $0xa,%eax
8010466d:	75 e1                	jne    80104650 <acquire+0x50>
}
8010466f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104672:	c9                   	leave  
80104673:	c3                   	ret    
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104678:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010467c:	8d 51 34             	lea    0x34(%ecx),%edx
8010467f:	90                   	nop
    pcs[i] = 0;
80104680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104686:	83 c0 04             	add    $0x4,%eax
80104689:	39 c2                	cmp    %eax,%edx
8010468b:	75 f3                	jne    80104680 <acquire+0x80>
}
8010468d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104690:	c9                   	leave  
80104691:	c3                   	ret    
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104698:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010469b:	e8 b0 f2 ff ff       	call   80103950 <mycpu>
801046a0:	39 c3                	cmp    %eax,%ebx
801046a2:	0f 85 72 ff ff ff    	jne    8010461a <acquire+0x1a>
  popcli();
801046a8:	e8 53 fe ff ff       	call   80104500 <popcli>
    panic("acquire");
801046ad:	83 ec 0c             	sub    $0xc,%esp
801046b0:	68 f5 80 10 80       	push   $0x801080f5
801046b5:	e8 c6 bc ff ff       	call   80100380 <panic>
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	8b 55 08             	mov    0x8(%ebp),%edx
801046c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046ca:	53                   	push   %ebx
801046cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046ce:	89 d7                	mov    %edx,%edi
801046d0:	09 cf                	or     %ecx,%edi
801046d2:	83 e7 03             	and    $0x3,%edi
801046d5:	75 29                	jne    80104700 <memset+0x40>
    c &= 0xFF;
801046d7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046da:	c1 e0 18             	shl    $0x18,%eax
801046dd:	89 fb                	mov    %edi,%ebx
801046df:	c1 e9 02             	shr    $0x2,%ecx
801046e2:	c1 e3 10             	shl    $0x10,%ebx
801046e5:	09 d8                	or     %ebx,%eax
801046e7:	09 f8                	or     %edi,%eax
801046e9:	c1 e7 08             	shl    $0x8,%edi
801046ec:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046ee:	89 d7                	mov    %edx,%edi
801046f0:	fc                   	cld    
801046f1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046f3:	5b                   	pop    %ebx
801046f4:	89 d0                	mov    %edx,%eax
801046f6:	5f                   	pop    %edi
801046f7:	5d                   	pop    %ebp
801046f8:	c3                   	ret    
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104700:	89 d7                	mov    %edx,%edi
80104702:	fc                   	cld    
80104703:	f3 aa                	rep stos %al,%es:(%edi)
80104705:	5b                   	pop    %ebx
80104706:	89 d0                	mov    %edx,%eax
80104708:	5f                   	pop    %edi
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop

80104710 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	8b 75 10             	mov    0x10(%ebp),%esi
80104717:	8b 55 08             	mov    0x8(%ebp),%edx
8010471a:	53                   	push   %ebx
8010471b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010471e:	85 f6                	test   %esi,%esi
80104720:	74 2e                	je     80104750 <memcmp+0x40>
80104722:	01 c6                	add    %eax,%esi
80104724:	eb 14                	jmp    8010473a <memcmp+0x2a>
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104730:	83 c0 01             	add    $0x1,%eax
80104733:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104736:	39 f0                	cmp    %esi,%eax
80104738:	74 16                	je     80104750 <memcmp+0x40>
    if(*s1 != *s2)
8010473a:	0f b6 0a             	movzbl (%edx),%ecx
8010473d:	0f b6 18             	movzbl (%eax),%ebx
80104740:	38 d9                	cmp    %bl,%cl
80104742:	74 ec                	je     80104730 <memcmp+0x20>
      return *s1 - *s2;
80104744:	0f b6 c1             	movzbl %cl,%eax
80104747:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104749:	5b                   	pop    %ebx
8010474a:	5e                   	pop    %esi
8010474b:	5d                   	pop    %ebp
8010474c:	c3                   	ret    
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
80104750:	5b                   	pop    %ebx
  return 0;
80104751:	31 c0                	xor    %eax,%eax
}
80104753:	5e                   	pop    %esi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
80104756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475d:	8d 76 00             	lea    0x0(%esi),%esi

80104760 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	8b 55 08             	mov    0x8(%ebp),%edx
80104767:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010476a:	56                   	push   %esi
8010476b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010476e:	39 d6                	cmp    %edx,%esi
80104770:	73 26                	jae    80104798 <memmove+0x38>
80104772:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104775:	39 fa                	cmp    %edi,%edx
80104777:	73 1f                	jae    80104798 <memmove+0x38>
80104779:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010477c:	85 c9                	test   %ecx,%ecx
8010477e:	74 0c                	je     8010478c <memmove+0x2c>
      *--d = *--s;
80104780:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104784:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104787:	83 e8 01             	sub    $0x1,%eax
8010478a:	73 f4                	jae    80104780 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010478c:	5e                   	pop    %esi
8010478d:	89 d0                	mov    %edx,%eax
8010478f:	5f                   	pop    %edi
80104790:	5d                   	pop    %ebp
80104791:	c3                   	ret    
80104792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104798:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010479b:	89 d7                	mov    %edx,%edi
8010479d:	85 c9                	test   %ecx,%ecx
8010479f:	74 eb                	je     8010478c <memmove+0x2c>
801047a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047a9:	39 c6                	cmp    %eax,%esi
801047ab:	75 fb                	jne    801047a8 <memmove+0x48>
}
801047ad:	5e                   	pop    %esi
801047ae:	89 d0                	mov    %edx,%eax
801047b0:	5f                   	pop    %edi
801047b1:	5d                   	pop    %ebp
801047b2:	c3                   	ret    
801047b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047c0:	eb 9e                	jmp    80104760 <memmove>
801047c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	8b 75 10             	mov    0x10(%ebp),%esi
801047d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047da:	53                   	push   %ebx
801047db:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801047de:	85 f6                	test   %esi,%esi
801047e0:	74 2e                	je     80104810 <strncmp+0x40>
801047e2:	01 d6                	add    %edx,%esi
801047e4:	eb 18                	jmp    801047fe <strncmp+0x2e>
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
801047f0:	38 d8                	cmp    %bl,%al
801047f2:	75 14                	jne    80104808 <strncmp+0x38>
    n--, p++, q++;
801047f4:	83 c2 01             	add    $0x1,%edx
801047f7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047fa:	39 f2                	cmp    %esi,%edx
801047fc:	74 12                	je     80104810 <strncmp+0x40>
801047fe:	0f b6 01             	movzbl (%ecx),%eax
80104801:	0f b6 1a             	movzbl (%edx),%ebx
80104804:	84 c0                	test   %al,%al
80104806:	75 e8                	jne    801047f0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104808:	29 d8                	sub    %ebx,%eax
}
8010480a:	5b                   	pop    %ebx
8010480b:	5e                   	pop    %esi
8010480c:	5d                   	pop    %ebp
8010480d:	c3                   	ret    
8010480e:	66 90                	xchg   %ax,%ax
80104810:	5b                   	pop    %ebx
    return 0;
80104811:	31 c0                	xor    %eax,%eax
}
80104813:	5e                   	pop    %esi
80104814:	5d                   	pop    %ebp
80104815:	c3                   	ret    
80104816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481d:	8d 76 00             	lea    0x0(%esi),%esi

80104820 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	8b 75 08             	mov    0x8(%ebp),%esi
80104828:	53                   	push   %ebx
80104829:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010482c:	89 f0                	mov    %esi,%eax
8010482e:	eb 15                	jmp    80104845 <strncpy+0x25>
80104830:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104834:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104837:	83 c0 01             	add    $0x1,%eax
8010483a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010483e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104841:	84 d2                	test   %dl,%dl
80104843:	74 09                	je     8010484e <strncpy+0x2e>
80104845:	89 cb                	mov    %ecx,%ebx
80104847:	83 e9 01             	sub    $0x1,%ecx
8010484a:	85 db                	test   %ebx,%ebx
8010484c:	7f e2                	jg     80104830 <strncpy+0x10>
    ;
  while(n-- > 0)
8010484e:	89 c2                	mov    %eax,%edx
80104850:	85 c9                	test   %ecx,%ecx
80104852:	7e 17                	jle    8010486b <strncpy+0x4b>
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104858:	83 c2 01             	add    $0x1,%edx
8010485b:	89 c1                	mov    %eax,%ecx
8010485d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104861:	29 d1                	sub    %edx,%ecx
80104863:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104867:	85 c9                	test   %ecx,%ecx
80104869:	7f ed                	jg     80104858 <strncpy+0x38>
  return os;
}
8010486b:	5b                   	pop    %ebx
8010486c:	89 f0                	mov    %esi,%eax
8010486e:	5e                   	pop    %esi
8010486f:	5f                   	pop    %edi
80104870:	5d                   	pop    %ebp
80104871:	c3                   	ret    
80104872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104880 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	8b 55 10             	mov    0x10(%ebp),%edx
80104887:	8b 75 08             	mov    0x8(%ebp),%esi
8010488a:	53                   	push   %ebx
8010488b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010488e:	85 d2                	test   %edx,%edx
80104890:	7e 25                	jle    801048b7 <safestrcpy+0x37>
80104892:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104896:	89 f2                	mov    %esi,%edx
80104898:	eb 16                	jmp    801048b0 <safestrcpy+0x30>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048a0:	0f b6 08             	movzbl (%eax),%ecx
801048a3:	83 c0 01             	add    $0x1,%eax
801048a6:	83 c2 01             	add    $0x1,%edx
801048a9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048ac:	84 c9                	test   %cl,%cl
801048ae:	74 04                	je     801048b4 <safestrcpy+0x34>
801048b0:	39 d8                	cmp    %ebx,%eax
801048b2:	75 ec                	jne    801048a0 <safestrcpy+0x20>
    ;
  *s = 0;
801048b4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048b7:	89 f0                	mov    %esi,%eax
801048b9:	5b                   	pop    %ebx
801048ba:	5e                   	pop    %esi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret    
801048bd:	8d 76 00             	lea    0x0(%esi),%esi

801048c0 <strlen>:

int
strlen(const char *s)
{
801048c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048c1:	31 c0                	xor    %eax,%eax
{
801048c3:	89 e5                	mov    %esp,%ebp
801048c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048c8:	80 3a 00             	cmpb   $0x0,(%edx)
801048cb:	74 0c                	je     801048d9 <strlen+0x19>
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
801048d0:	83 c0 01             	add    $0x1,%eax
801048d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048d7:	75 f7                	jne    801048d0 <strlen+0x10>
    ;
  return n;
}
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    

801048db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048e3:	55                   	push   %ebp
  pushl %ebx
801048e4:	53                   	push   %ebx
  pushl %esi
801048e5:	56                   	push   %esi
  pushl %edi
801048e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048eb:	5f                   	pop    %edi
  popl %esi
801048ec:	5e                   	pop    %esi
  popl %ebx
801048ed:	5b                   	pop    %ebx
  popl %ebp
801048ee:	5d                   	pop    %ebp
  ret
801048ef:	c3                   	ret    

801048f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
801048f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048fa:	e8 d1 f0 ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ff:	8b 00                	mov    (%eax),%eax
80104901:	39 d8                	cmp    %ebx,%eax
80104903:	76 1b                	jbe    80104920 <fetchint+0x30>
80104905:	8d 53 04             	lea    0x4(%ebx),%edx
80104908:	39 d0                	cmp    %edx,%eax
8010490a:	72 14                	jb     80104920 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010490c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010490f:	8b 13                	mov    (%ebx),%edx
80104911:	89 10                	mov    %edx,(%eax)
  return 0;
80104913:	31 c0                	xor    %eax,%eax
}
80104915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104918:	c9                   	leave  
80104919:	c3                   	ret    
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104925:	eb ee                	jmp    80104915 <fetchint+0x25>
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax

80104930 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010493a:	e8 91 f0 ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz)
8010493f:	39 18                	cmp    %ebx,(%eax)
80104941:	76 2d                	jbe    80104970 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104943:	8b 55 0c             	mov    0xc(%ebp),%edx
80104946:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104948:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010494a:	39 d3                	cmp    %edx,%ebx
8010494c:	73 22                	jae    80104970 <fetchstr+0x40>
8010494e:	89 d8                	mov    %ebx,%eax
80104950:	eb 0d                	jmp    8010495f <fetchstr+0x2f>
80104952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104958:	83 c0 01             	add    $0x1,%eax
8010495b:	39 c2                	cmp    %eax,%edx
8010495d:	76 11                	jbe    80104970 <fetchstr+0x40>
    if(*s == 0)
8010495f:	80 38 00             	cmpb   $0x0,(%eax)
80104962:	75 f4                	jne    80104958 <fetchstr+0x28>
      return s - *pp;
80104964:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104969:	c9                   	leave  
8010496a:	c3                   	ret    
8010496b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop
80104970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104978:	c9                   	leave  
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104985:	e8 46 f0 ff ff       	call   801039d0 <myproc>
8010498a:	8b 55 08             	mov    0x8(%ebp),%edx
8010498d:	8b 40 18             	mov    0x18(%eax),%eax
80104990:	8b 40 44             	mov    0x44(%eax),%eax
80104993:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104996:	e8 35 f0 ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010499b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010499e:	8b 00                	mov    (%eax),%eax
801049a0:	39 c6                	cmp    %eax,%esi
801049a2:	73 1c                	jae    801049c0 <argint+0x40>
801049a4:	8d 53 08             	lea    0x8(%ebx),%edx
801049a7:	39 d0                	cmp    %edx,%eax
801049a9:	72 15                	jb     801049c0 <argint+0x40>
  *ip = *(int*)(addr);
801049ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ae:	8b 53 04             	mov    0x4(%ebx),%edx
801049b1:	89 10                	mov    %edx,(%eax)
  return 0;
801049b3:	31 c0                	xor    %eax,%eax
}
801049b5:	5b                   	pop    %ebx
801049b6:	5e                   	pop    %esi
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049c5:	eb ee                	jmp    801049b5 <argint+0x35>
801049c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049d9:	e8 f2 ef ff ff       	call   801039d0 <myproc>
801049de:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e0:	e8 eb ef ff ff       	call   801039d0 <myproc>
801049e5:	8b 55 08             	mov    0x8(%ebp),%edx
801049e8:	8b 40 18             	mov    0x18(%eax),%eax
801049eb:	8b 40 44             	mov    0x44(%eax),%eax
801049ee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049f1:	e8 da ef ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049f9:	8b 00                	mov    (%eax),%eax
801049fb:	39 c7                	cmp    %eax,%edi
801049fd:	73 31                	jae    80104a30 <argptr+0x60>
801049ff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a02:	39 c8                	cmp    %ecx,%eax
80104a04:	72 2a                	jb     80104a30 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a06:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104a09:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a0c:	85 d2                	test   %edx,%edx
80104a0e:	78 20                	js     80104a30 <argptr+0x60>
80104a10:	8b 16                	mov    (%esi),%edx
80104a12:	39 c2                	cmp    %eax,%edx
80104a14:	76 1a                	jbe    80104a30 <argptr+0x60>
80104a16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a19:	01 c3                	add    %eax,%ebx
80104a1b:	39 da                	cmp    %ebx,%edx
80104a1d:	72 11                	jb     80104a30 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a22:	89 02                	mov    %eax,(%edx)
  return 0;
80104a24:	31 c0                	xor    %eax,%eax
}
80104a26:	83 c4 0c             	add    $0xc,%esp
80104a29:	5b                   	pop    %ebx
80104a2a:	5e                   	pop    %esi
80104a2b:	5f                   	pop    %edi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret    
80104a2e:	66 90                	xchg   %ax,%ax
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	eb ef                	jmp    80104a26 <argptr+0x56>
80104a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a45:	e8 86 ef ff ff       	call   801039d0 <myproc>
80104a4a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a4d:	8b 40 18             	mov    0x18(%eax),%eax
80104a50:	8b 40 44             	mov    0x44(%eax),%eax
80104a53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a56:	e8 75 ef ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a5e:	8b 00                	mov    (%eax),%eax
80104a60:	39 c6                	cmp    %eax,%esi
80104a62:	73 44                	jae    80104aa8 <argstr+0x68>
80104a64:	8d 53 08             	lea    0x8(%ebx),%edx
80104a67:	39 d0                	cmp    %edx,%eax
80104a69:	72 3d                	jb     80104aa8 <argstr+0x68>
  *ip = *(int*)(addr);
80104a6b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a6e:	e8 5d ef ff ff       	call   801039d0 <myproc>
  if(addr >= curproc->sz)
80104a73:	3b 18                	cmp    (%eax),%ebx
80104a75:	73 31                	jae    80104aa8 <argstr+0x68>
  *pp = (char*)addr;
80104a77:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a7a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a7c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a7e:	39 d3                	cmp    %edx,%ebx
80104a80:	73 26                	jae    80104aa8 <argstr+0x68>
80104a82:	89 d8                	mov    %ebx,%eax
80104a84:	eb 11                	jmp    80104a97 <argstr+0x57>
80104a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
80104a90:	83 c0 01             	add    $0x1,%eax
80104a93:	39 c2                	cmp    %eax,%edx
80104a95:	76 11                	jbe    80104aa8 <argstr+0x68>
    if(*s == 0)
80104a97:	80 38 00             	cmpb   $0x0,(%eax)
80104a9a:	75 f4                	jne    80104a90 <argstr+0x50>
      return s - *pp;
80104a9c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a9e:	5b                   	pop    %ebx
80104a9f:	5e                   	pop    %esi
80104aa0:	5d                   	pop    %ebp
80104aa1:	c3                   	ret    
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa8:	5b                   	pop    %ebx
    return -1;
80104aa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aae:	5e                   	pop    %esi
80104aaf:	5d                   	pop    %ebp
80104ab0:	c3                   	ret    
80104ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abf:	90                   	nop

80104ac0 <syscall>:
[SYS_test]    sys_test,
};

void
syscall(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ac7:	e8 04 ef ff ff       	call   801039d0 <myproc>
80104acc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ace:	8b 40 18             	mov    0x18(%eax),%eax
80104ad1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ad4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ad7:	83 fa 19             	cmp    $0x19,%edx
80104ada:	77 24                	ja     80104b00 <syscall+0x40>
80104adc:	8b 14 85 20 81 10 80 	mov    -0x7fef7ee0(,%eax,4),%edx
80104ae3:	85 d2                	test   %edx,%edx
80104ae5:	74 19                	je     80104b00 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ae7:	ff d2                	call   *%edx
80104ae9:	89 c2                	mov    %eax,%edx
80104aeb:	8b 43 18             	mov    0x18(%ebx),%eax
80104aee:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af4:	c9                   	leave  
80104af5:	c3                   	ret    
80104af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b00:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b01:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b04:	50                   	push   %eax
80104b05:	ff 73 10             	push   0x10(%ebx)
80104b08:	68 fd 80 10 80       	push   $0x801080fd
80104b0d:	e8 8e bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104b12:	8b 43 18             	mov    0x18(%ebx),%eax
80104b15:	83 c4 10             	add    $0x10,%esp
80104b18:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b22:	c9                   	leave  
80104b23:	c3                   	ret    
80104b24:	66 90                	xchg   %ax,%ax
80104b26:	66 90                	xchg   %ax,%ax
80104b28:	66 90                	xchg   %ax,%ax
80104b2a:	66 90                	xchg   %ax,%ax
80104b2c:	66 90                	xchg   %ax,%ax
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	57                   	push   %edi
80104b34:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b35:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b38:	53                   	push   %ebx
80104b39:	83 ec 34             	sub    $0x34,%esp
80104b3c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b42:	57                   	push   %edi
80104b43:	50                   	push   %eax
{
80104b44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b47:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b4a:	e8 81 d5 ff ff       	call   801020d0 <nameiparent>
80104b4f:	83 c4 10             	add    $0x10,%esp
80104b52:	85 c0                	test   %eax,%eax
80104b54:	0f 84 46 01 00 00    	je     80104ca0 <create+0x170>
    return 0;
  ilock(dp);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	89 c3                	mov    %eax,%ebx
80104b5f:	50                   	push   %eax
80104b60:	e8 2b cc ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b65:	83 c4 0c             	add    $0xc,%esp
80104b68:	6a 00                	push   $0x0
80104b6a:	57                   	push   %edi
80104b6b:	53                   	push   %ebx
80104b6c:	e8 7f d1 ff ff       	call   80101cf0 <dirlookup>
80104b71:	83 c4 10             	add    $0x10,%esp
80104b74:	89 c6                	mov    %eax,%esi
80104b76:	85 c0                	test   %eax,%eax
80104b78:	74 56                	je     80104bd0 <create+0xa0>
    iunlockput(dp);
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	53                   	push   %ebx
80104b7e:	e8 9d ce ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104b83:	89 34 24             	mov    %esi,(%esp)
80104b86:	e8 05 cc ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b8b:	83 c4 10             	add    $0x10,%esp
80104b8e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b93:	75 1b                	jne    80104bb0 <create+0x80>
80104b95:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b9a:	75 14                	jne    80104bb0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b9f:	89 f0                	mov    %esi,%eax
80104ba1:	5b                   	pop    %ebx
80104ba2:	5e                   	pop    %esi
80104ba3:	5f                   	pop    %edi
80104ba4:	5d                   	pop    %ebp
80104ba5:	c3                   	ret    
80104ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	56                   	push   %esi
    return 0;
80104bb4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104bb6:	e8 65 ce ff ff       	call   80101a20 <iunlockput>
    return 0;
80104bbb:	83 c4 10             	add    $0x10,%esp
}
80104bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bc1:	89 f0                	mov    %esi,%eax
80104bc3:	5b                   	pop    %ebx
80104bc4:	5e                   	pop    %esi
80104bc5:	5f                   	pop    %edi
80104bc6:	5d                   	pop    %ebp
80104bc7:	c3                   	ret    
80104bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104bd0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bd4:	83 ec 08             	sub    $0x8,%esp
80104bd7:	50                   	push   %eax
80104bd8:	ff 33                	push   (%ebx)
80104bda:	e8 41 ca ff ff       	call   80101620 <ialloc>
80104bdf:	83 c4 10             	add    $0x10,%esp
80104be2:	89 c6                	mov    %eax,%esi
80104be4:	85 c0                	test   %eax,%eax
80104be6:	0f 84 cd 00 00 00    	je     80104cb9 <create+0x189>
  ilock(ip);
80104bec:	83 ec 0c             	sub    $0xc,%esp
80104bef:	50                   	push   %eax
80104bf0:	e8 9b cb ff ff       	call   80101790 <ilock>
  ip->major = major;
80104bf5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bf9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bfd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c01:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c05:	b8 01 00 00 00       	mov    $0x1,%eax
80104c0a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c0e:	89 34 24             	mov    %esi,(%esp)
80104c11:	e8 ca ca ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c1e:	74 30                	je     80104c50 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c20:	83 ec 04             	sub    $0x4,%esp
80104c23:	ff 76 04             	push   0x4(%esi)
80104c26:	57                   	push   %edi
80104c27:	53                   	push   %ebx
80104c28:	e8 c3 d3 ff ff       	call   80101ff0 <dirlink>
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	85 c0                	test   %eax,%eax
80104c32:	78 78                	js     80104cac <create+0x17c>
  iunlockput(dp);
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	53                   	push   %ebx
80104c38:	e8 e3 cd ff ff       	call   80101a20 <iunlockput>
  return ip;
80104c3d:	83 c4 10             	add    $0x10,%esp
}
80104c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c43:	89 f0                	mov    %esi,%eax
80104c45:	5b                   	pop    %ebx
80104c46:	5e                   	pop    %esi
80104c47:	5f                   	pop    %edi
80104c48:	5d                   	pop    %ebp
80104c49:	c3                   	ret    
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c50:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c53:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c58:	53                   	push   %ebx
80104c59:	e8 82 ca ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c5e:	83 c4 0c             	add    $0xc,%esp
80104c61:	ff 76 04             	push   0x4(%esi)
80104c64:	68 a8 81 10 80       	push   $0x801081a8
80104c69:	56                   	push   %esi
80104c6a:	e8 81 d3 ff ff       	call   80101ff0 <dirlink>
80104c6f:	83 c4 10             	add    $0x10,%esp
80104c72:	85 c0                	test   %eax,%eax
80104c74:	78 18                	js     80104c8e <create+0x15e>
80104c76:	83 ec 04             	sub    $0x4,%esp
80104c79:	ff 73 04             	push   0x4(%ebx)
80104c7c:	68 a7 81 10 80       	push   $0x801081a7
80104c81:	56                   	push   %esi
80104c82:	e8 69 d3 ff ff       	call   80101ff0 <dirlink>
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	79 92                	jns    80104c20 <create+0xf0>
      panic("create dots");
80104c8e:	83 ec 0c             	sub    $0xc,%esp
80104c91:	68 9b 81 10 80       	push   $0x8010819b
80104c96:	e8 e5 b6 ff ff       	call   80100380 <panic>
80104c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop
}
80104ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ca3:	31 f6                	xor    %esi,%esi
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	89 f0                	mov    %esi,%eax
80104ca8:	5e                   	pop    %esi
80104ca9:	5f                   	pop    %edi
80104caa:	5d                   	pop    %ebp
80104cab:	c3                   	ret    
    panic("create: dirlink");
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	68 aa 81 10 80       	push   $0x801081aa
80104cb4:	e8 c7 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104cb9:	83 ec 0c             	sub    $0xc,%esp
80104cbc:	68 8c 81 10 80       	push   $0x8010818c
80104cc1:	e8 ba b6 ff ff       	call   80100380 <panic>
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi

80104cd0 <sys_dup>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104cd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cdb:	50                   	push   %eax
80104cdc:	6a 00                	push   $0x0
80104cde:	e8 9d fc ff ff       	call   80104980 <argint>
80104ce3:	83 c4 10             	add    $0x10,%esp
80104ce6:	85 c0                	test   %eax,%eax
80104ce8:	78 36                	js     80104d20 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cee:	77 30                	ja     80104d20 <sys_dup+0x50>
80104cf0:	e8 db ec ff ff       	call   801039d0 <myproc>
80104cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cf8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104cfc:	85 f6                	test   %esi,%esi
80104cfe:	74 20                	je     80104d20 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d00:	e8 cb ec ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d05:	31 db                	xor    %ebx,%ebx
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104d10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d14:	85 d2                	test   %edx,%edx
80104d16:	74 18                	je     80104d30 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d18:	83 c3 01             	add    $0x1,%ebx
80104d1b:	83 fb 10             	cmp    $0x10,%ebx
80104d1e:	75 f0                	jne    80104d10 <sys_dup+0x40>
}
80104d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d28:	89 d8                	mov    %ebx,%eax
80104d2a:	5b                   	pop    %ebx
80104d2b:	5e                   	pop    %esi
80104d2c:	5d                   	pop    %ebp
80104d2d:	c3                   	ret    
80104d2e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d30:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d33:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d37:	56                   	push   %esi
80104d38:	e8 73 c1 ff ff       	call   80100eb0 <filedup>
  return fd;
80104d3d:	83 c4 10             	add    $0x10,%esp
}
80104d40:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d43:	89 d8                	mov    %ebx,%eax
80104d45:	5b                   	pop    %ebx
80104d46:	5e                   	pop    %esi
80104d47:	5d                   	pop    %ebp
80104d48:	c3                   	ret    
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d50 <sys_read>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d5b:	53                   	push   %ebx
80104d5c:	6a 00                	push   $0x0
80104d5e:	e8 1d fc ff ff       	call   80104980 <argint>
80104d63:	83 c4 10             	add    $0x10,%esp
80104d66:	85 c0                	test   %eax,%eax
80104d68:	78 5e                	js     80104dc8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d6e:	77 58                	ja     80104dc8 <sys_read+0x78>
80104d70:	e8 5b ec ff ff       	call   801039d0 <myproc>
80104d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d7c:	85 f6                	test   %esi,%esi
80104d7e:	74 48                	je     80104dc8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d80:	83 ec 08             	sub    $0x8,%esp
80104d83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d86:	50                   	push   %eax
80104d87:	6a 02                	push   $0x2
80104d89:	e8 f2 fb ff ff       	call   80104980 <argint>
80104d8e:	83 c4 10             	add    $0x10,%esp
80104d91:	85 c0                	test   %eax,%eax
80104d93:	78 33                	js     80104dc8 <sys_read+0x78>
80104d95:	83 ec 04             	sub    $0x4,%esp
80104d98:	ff 75 f0             	push   -0x10(%ebp)
80104d9b:	53                   	push   %ebx
80104d9c:	6a 01                	push   $0x1
80104d9e:	e8 2d fc ff ff       	call   801049d0 <argptr>
80104da3:	83 c4 10             	add    $0x10,%esp
80104da6:	85 c0                	test   %eax,%eax
80104da8:	78 1e                	js     80104dc8 <sys_read+0x78>
  return fileread(f, p, n);
80104daa:	83 ec 04             	sub    $0x4,%esp
80104dad:	ff 75 f0             	push   -0x10(%ebp)
80104db0:	ff 75 f4             	push   -0xc(%ebp)
80104db3:	56                   	push   %esi
80104db4:	e8 77 c2 ff ff       	call   80101030 <fileread>
80104db9:	83 c4 10             	add    $0x10,%esp
}
80104dbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dbf:	5b                   	pop    %ebx
80104dc0:	5e                   	pop    %esi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret    
80104dc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc7:	90                   	nop
    return -1;
80104dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dcd:	eb ed                	jmp    80104dbc <sys_read+0x6c>
80104dcf:	90                   	nop

80104dd0 <sys_write>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104dd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104dd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ddb:	53                   	push   %ebx
80104ddc:	6a 00                	push   $0x0
80104dde:	e8 9d fb ff ff       	call   80104980 <argint>
80104de3:	83 c4 10             	add    $0x10,%esp
80104de6:	85 c0                	test   %eax,%eax
80104de8:	78 5e                	js     80104e48 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dee:	77 58                	ja     80104e48 <sys_write+0x78>
80104df0:	e8 db eb ff ff       	call   801039d0 <myproc>
80104df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dfc:	85 f6                	test   %esi,%esi
80104dfe:	74 48                	je     80104e48 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e00:	83 ec 08             	sub    $0x8,%esp
80104e03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e06:	50                   	push   %eax
80104e07:	6a 02                	push   $0x2
80104e09:	e8 72 fb ff ff       	call   80104980 <argint>
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	85 c0                	test   %eax,%eax
80104e13:	78 33                	js     80104e48 <sys_write+0x78>
80104e15:	83 ec 04             	sub    $0x4,%esp
80104e18:	ff 75 f0             	push   -0x10(%ebp)
80104e1b:	53                   	push   %ebx
80104e1c:	6a 01                	push   $0x1
80104e1e:	e8 ad fb ff ff       	call   801049d0 <argptr>
80104e23:	83 c4 10             	add    $0x10,%esp
80104e26:	85 c0                	test   %eax,%eax
80104e28:	78 1e                	js     80104e48 <sys_write+0x78>
  return filewrite(f, p, n);
80104e2a:	83 ec 04             	sub    $0x4,%esp
80104e2d:	ff 75 f0             	push   -0x10(%ebp)
80104e30:	ff 75 f4             	push   -0xc(%ebp)
80104e33:	56                   	push   %esi
80104e34:	e8 87 c2 ff ff       	call   801010c0 <filewrite>
80104e39:	83 c4 10             	add    $0x10,%esp
}
80104e3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e3f:	5b                   	pop    %ebx
80104e40:	5e                   	pop    %esi
80104e41:	5d                   	pop    %ebp
80104e42:	c3                   	ret    
80104e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e47:	90                   	nop
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4d:	eb ed                	jmp    80104e3c <sys_write+0x6c>
80104e4f:	90                   	nop

80104e50 <sys_close>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e5b:	50                   	push   %eax
80104e5c:	6a 00                	push   $0x0
80104e5e:	e8 1d fb ff ff       	call   80104980 <argint>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	78 3e                	js     80104ea8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e6e:	77 38                	ja     80104ea8 <sys_close+0x58>
80104e70:	e8 5b eb ff ff       	call   801039d0 <myproc>
80104e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e78:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e7b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e7f:	85 f6                	test   %esi,%esi
80104e81:	74 25                	je     80104ea8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e83:	e8 48 eb ff ff       	call   801039d0 <myproc>
  fileclose(f);
80104e88:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e8b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e92:	00 
  fileclose(f);
80104e93:	56                   	push   %esi
80104e94:	e8 67 c0 ff ff       	call   80100f00 <fileclose>
  return 0;
80104e99:	83 c4 10             	add    $0x10,%esp
80104e9c:	31 c0                	xor    %eax,%eax
}
80104e9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea1:	5b                   	pop    %ebx
80104ea2:	5e                   	pop    %esi
80104ea3:	5d                   	pop    %ebp
80104ea4:	c3                   	ret    
80104ea5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ead:	eb ef                	jmp    80104e9e <sys_close+0x4e>
80104eaf:	90                   	nop

80104eb0 <sys_fstat>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104eb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ebb:	53                   	push   %ebx
80104ebc:	6a 00                	push   $0x0
80104ebe:	e8 bd fa ff ff       	call   80104980 <argint>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	78 46                	js     80104f10 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ece:	77 40                	ja     80104f10 <sys_fstat+0x60>
80104ed0:	e8 fb ea ff ff       	call   801039d0 <myproc>
80104ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ed8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104edc:	85 f6                	test   %esi,%esi
80104ede:	74 30                	je     80104f10 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ee0:	83 ec 04             	sub    $0x4,%esp
80104ee3:	6a 14                	push   $0x14
80104ee5:	53                   	push   %ebx
80104ee6:	6a 01                	push   $0x1
80104ee8:	e8 e3 fa ff ff       	call   801049d0 <argptr>
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	78 1c                	js     80104f10 <sys_fstat+0x60>
  return filestat(f, st);
80104ef4:	83 ec 08             	sub    $0x8,%esp
80104ef7:	ff 75 f4             	push   -0xc(%ebp)
80104efa:	56                   	push   %esi
80104efb:	e8 e0 c0 ff ff       	call   80100fe0 <filestat>
80104f00:	83 c4 10             	add    $0x10,%esp
}
80104f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f06:	5b                   	pop    %ebx
80104f07:	5e                   	pop    %esi
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret    
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f15:	eb ec                	jmp    80104f03 <sys_fstat+0x53>
80104f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <sys_link>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f25:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f28:	53                   	push   %ebx
80104f29:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f2c:	50                   	push   %eax
80104f2d:	6a 00                	push   $0x0
80104f2f:	e8 0c fb ff ff       	call   80104a40 <argstr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	0f 88 fb 00 00 00    	js     8010503a <sys_link+0x11a>
80104f3f:	83 ec 08             	sub    $0x8,%esp
80104f42:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f45:	50                   	push   %eax
80104f46:	6a 01                	push   $0x1
80104f48:	e8 f3 fa ff ff       	call   80104a40 <argstr>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	0f 88 e2 00 00 00    	js     8010503a <sys_link+0x11a>
  begin_op();
80104f58:	e8 13 de ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
80104f5d:	83 ec 0c             	sub    $0xc,%esp
80104f60:	ff 75 d4             	push   -0x2c(%ebp)
80104f63:	e8 48 d1 ff ff       	call   801020b0 <namei>
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	89 c3                	mov    %eax,%ebx
80104f6d:	85 c0                	test   %eax,%eax
80104f6f:	0f 84 e4 00 00 00    	je     80105059 <sys_link+0x139>
  ilock(ip);
80104f75:	83 ec 0c             	sub    $0xc,%esp
80104f78:	50                   	push   %eax
80104f79:	e8 12 c8 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f86:	0f 84 b5 00 00 00    	je     80105041 <sys_link+0x121>
  iupdate(ip);
80104f8c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f8f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f97:	53                   	push   %ebx
80104f98:	e8 43 c7 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
80104f9d:	89 1c 24             	mov    %ebx,(%esp)
80104fa0:	e8 cb c8 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fa5:	58                   	pop    %eax
80104fa6:	5a                   	pop    %edx
80104fa7:	57                   	push   %edi
80104fa8:	ff 75 d0             	push   -0x30(%ebp)
80104fab:	e8 20 d1 ff ff       	call   801020d0 <nameiparent>
80104fb0:	83 c4 10             	add    $0x10,%esp
80104fb3:	89 c6                	mov    %eax,%esi
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	74 5b                	je     80105014 <sys_link+0xf4>
  ilock(dp);
80104fb9:	83 ec 0c             	sub    $0xc,%esp
80104fbc:	50                   	push   %eax
80104fbd:	e8 ce c7 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fc2:	8b 03                	mov    (%ebx),%eax
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	39 06                	cmp    %eax,(%esi)
80104fc9:	75 3d                	jne    80105008 <sys_link+0xe8>
80104fcb:	83 ec 04             	sub    $0x4,%esp
80104fce:	ff 73 04             	push   0x4(%ebx)
80104fd1:	57                   	push   %edi
80104fd2:	56                   	push   %esi
80104fd3:	e8 18 d0 ff ff       	call   80101ff0 <dirlink>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	78 29                	js     80105008 <sys_link+0xe8>
  iunlockput(dp);
80104fdf:	83 ec 0c             	sub    $0xc,%esp
80104fe2:	56                   	push   %esi
80104fe3:	e8 38 ca ff ff       	call   80101a20 <iunlockput>
  iput(ip);
80104fe8:	89 1c 24             	mov    %ebx,(%esp)
80104feb:	e8 d0 c8 ff ff       	call   801018c0 <iput>
  end_op();
80104ff0:	e8 eb dd ff ff       	call   80102de0 <end_op>
  return 0;
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	31 c0                	xor    %eax,%eax
}
80104ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffd:	5b                   	pop    %ebx
80104ffe:	5e                   	pop    %esi
80104fff:	5f                   	pop    %edi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret    
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	56                   	push   %esi
8010500c:	e8 0f ca ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105011:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	53                   	push   %ebx
80105018:	e8 73 c7 ff ff       	call   80101790 <ilock>
  ip->nlink--;
8010501d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105022:	89 1c 24             	mov    %ebx,(%esp)
80105025:	e8 b6 c6 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010502a:	89 1c 24             	mov    %ebx,(%esp)
8010502d:	e8 ee c9 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105032:	e8 a9 dd ff ff       	call   80102de0 <end_op>
  return -1;
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503f:	eb b9                	jmp    80104ffa <sys_link+0xda>
    iunlockput(ip);
80105041:	83 ec 0c             	sub    $0xc,%esp
80105044:	53                   	push   %ebx
80105045:	e8 d6 c9 ff ff       	call   80101a20 <iunlockput>
    end_op();
8010504a:	e8 91 dd ff ff       	call   80102de0 <end_op>
    return -1;
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105057:	eb a1                	jmp    80104ffa <sys_link+0xda>
    end_op();
80105059:	e8 82 dd ff ff       	call   80102de0 <end_op>
    return -1;
8010505e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105063:	eb 95                	jmp    80104ffa <sys_link+0xda>
80105065:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <sys_unlink>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105075:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105078:	53                   	push   %ebx
80105079:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010507c:	50                   	push   %eax
8010507d:	6a 00                	push   $0x0
8010507f:	e8 bc f9 ff ff       	call   80104a40 <argstr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	0f 88 7a 01 00 00    	js     80105209 <sys_unlink+0x199>
  begin_op();
8010508f:	e8 dc dc ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105094:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105097:	83 ec 08             	sub    $0x8,%esp
8010509a:	53                   	push   %ebx
8010509b:	ff 75 c0             	push   -0x40(%ebp)
8010509e:	e8 2d d0 ff ff       	call   801020d0 <nameiparent>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050a9:	85 c0                	test   %eax,%eax
801050ab:	0f 84 62 01 00 00    	je     80105213 <sys_unlink+0x1a3>
  ilock(dp);
801050b1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	57                   	push   %edi
801050b8:	e8 d3 c6 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050bd:	58                   	pop    %eax
801050be:	5a                   	pop    %edx
801050bf:	68 a8 81 10 80       	push   $0x801081a8
801050c4:	53                   	push   %ebx
801050c5:	e8 06 cc ff ff       	call   80101cd0 <namecmp>
801050ca:	83 c4 10             	add    $0x10,%esp
801050cd:	85 c0                	test   %eax,%eax
801050cf:	0f 84 fb 00 00 00    	je     801051d0 <sys_unlink+0x160>
801050d5:	83 ec 08             	sub    $0x8,%esp
801050d8:	68 a7 81 10 80       	push   $0x801081a7
801050dd:	53                   	push   %ebx
801050de:	e8 ed cb ff ff       	call   80101cd0 <namecmp>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	0f 84 e2 00 00 00    	je     801051d0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050ee:	83 ec 04             	sub    $0x4,%esp
801050f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050f4:	50                   	push   %eax
801050f5:	53                   	push   %ebx
801050f6:	57                   	push   %edi
801050f7:	e8 f4 cb ff ff       	call   80101cf0 <dirlookup>
801050fc:	83 c4 10             	add    $0x10,%esp
801050ff:	89 c3                	mov    %eax,%ebx
80105101:	85 c0                	test   %eax,%eax
80105103:	0f 84 c7 00 00 00    	je     801051d0 <sys_unlink+0x160>
  ilock(ip);
80105109:	83 ec 0c             	sub    $0xc,%esp
8010510c:	50                   	push   %eax
8010510d:	e8 7e c6 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105112:	83 c4 10             	add    $0x10,%esp
80105115:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010511a:	0f 8e 1c 01 00 00    	jle    8010523c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105120:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105125:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105128:	74 66                	je     80105190 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010512a:	83 ec 04             	sub    $0x4,%esp
8010512d:	6a 10                	push   $0x10
8010512f:	6a 00                	push   $0x0
80105131:	57                   	push   %edi
80105132:	e8 89 f5 ff ff       	call   801046c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105137:	6a 10                	push   $0x10
80105139:	ff 75 c4             	push   -0x3c(%ebp)
8010513c:	57                   	push   %edi
8010513d:	ff 75 b4             	push   -0x4c(%ebp)
80105140:	e8 5b ca ff ff       	call   80101ba0 <writei>
80105145:	83 c4 20             	add    $0x20,%esp
80105148:	83 f8 10             	cmp    $0x10,%eax
8010514b:	0f 85 de 00 00 00    	jne    8010522f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105151:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105156:	0f 84 94 00 00 00    	je     801051f0 <sys_unlink+0x180>
  iunlockput(dp);
8010515c:	83 ec 0c             	sub    $0xc,%esp
8010515f:	ff 75 b4             	push   -0x4c(%ebp)
80105162:	e8 b9 c8 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105167:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010516c:	89 1c 24             	mov    %ebx,(%esp)
8010516f:	e8 6c c5 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105174:	89 1c 24             	mov    %ebx,(%esp)
80105177:	e8 a4 c8 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010517c:	e8 5f dc ff ff       	call   80102de0 <end_op>
  return 0;
80105181:	83 c4 10             	add    $0x10,%esp
80105184:	31 c0                	xor    %eax,%eax
}
80105186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5f                   	pop    %edi
8010518c:	5d                   	pop    %ebp
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105190:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105194:	76 94                	jbe    8010512a <sys_unlink+0xba>
80105196:	be 20 00 00 00       	mov    $0x20,%esi
8010519b:	eb 0b                	jmp    801051a8 <sys_unlink+0x138>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	83 c6 10             	add    $0x10,%esi
801051a3:	3b 73 58             	cmp    0x58(%ebx),%esi
801051a6:	73 82                	jae    8010512a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051a8:	6a 10                	push   $0x10
801051aa:	56                   	push   %esi
801051ab:	57                   	push   %edi
801051ac:	53                   	push   %ebx
801051ad:	e8 ee c8 ff ff       	call   80101aa0 <readi>
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	83 f8 10             	cmp    $0x10,%eax
801051b8:	75 68                	jne    80105222 <sys_unlink+0x1b2>
    if(de.inum != 0)
801051ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051bf:	74 df                	je     801051a0 <sys_unlink+0x130>
    iunlockput(ip);
801051c1:	83 ec 0c             	sub    $0xc,%esp
801051c4:	53                   	push   %ebx
801051c5:	e8 56 c8 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	ff 75 b4             	push   -0x4c(%ebp)
801051d6:	e8 45 c8 ff ff       	call   80101a20 <iunlockput>
  end_op();
801051db:	e8 00 dc ff ff       	call   80102de0 <end_op>
  return -1;
801051e0:	83 c4 10             	add    $0x10,%esp
801051e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e8:	eb 9c                	jmp    80105186 <sys_unlink+0x116>
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801051f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051f3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051f6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051fb:	50                   	push   %eax
801051fc:	e8 df c4 ff ff       	call   801016e0 <iupdate>
80105201:	83 c4 10             	add    $0x10,%esp
80105204:	e9 53 ff ff ff       	jmp    8010515c <sys_unlink+0xec>
    return -1;
80105209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520e:	e9 73 ff ff ff       	jmp    80105186 <sys_unlink+0x116>
    end_op();
80105213:	e8 c8 db ff ff       	call   80102de0 <end_op>
    return -1;
80105218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521d:	e9 64 ff ff ff       	jmp    80105186 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105222:	83 ec 0c             	sub    $0xc,%esp
80105225:	68 cc 81 10 80       	push   $0x801081cc
8010522a:	e8 51 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	68 de 81 10 80       	push   $0x801081de
80105237:	e8 44 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	68 ba 81 10 80       	push   $0x801081ba
80105244:	e8 37 b1 ff ff       	call   80100380 <panic>
80105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_open>:

int
sys_open(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105255:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105258:	53                   	push   %ebx
80105259:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010525c:	50                   	push   %eax
8010525d:	6a 00                	push   $0x0
8010525f:	e8 dc f7 ff ff       	call   80104a40 <argstr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	0f 88 8e 00 00 00    	js     801052fd <sys_open+0xad>
8010526f:	83 ec 08             	sub    $0x8,%esp
80105272:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105275:	50                   	push   %eax
80105276:	6a 01                	push   $0x1
80105278:	e8 03 f7 ff ff       	call   80104980 <argint>
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	85 c0                	test   %eax,%eax
80105282:	78 79                	js     801052fd <sys_open+0xad>
    return -1;

  begin_op();
80105284:	e8 e7 da ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105289:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010528d:	75 79                	jne    80105308 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	ff 75 e0             	push   -0x20(%ebp)
80105295:	e8 16 ce ff ff       	call   801020b0 <namei>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	89 c6                	mov    %eax,%esi
8010529f:	85 c0                	test   %eax,%eax
801052a1:	0f 84 7e 00 00 00    	je     80105325 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052a7:	83 ec 0c             	sub    $0xc,%esp
801052aa:	50                   	push   %eax
801052ab:	e8 e0 c4 ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052b0:	83 c4 10             	add    $0x10,%esp
801052b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052b8:	0f 84 c2 00 00 00    	je     80105380 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052be:	e8 7d bb ff ff       	call   80100e40 <filealloc>
801052c3:	89 c7                	mov    %eax,%edi
801052c5:	85 c0                	test   %eax,%eax
801052c7:	74 23                	je     801052ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801052c9:	e8 02 e7 ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052d4:	85 d2                	test   %edx,%edx
801052d6:	74 60                	je     80105338 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052d8:	83 c3 01             	add    $0x1,%ebx
801052db:	83 fb 10             	cmp    $0x10,%ebx
801052de:	75 f0                	jne    801052d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	57                   	push   %edi
801052e4:	e8 17 bc ff ff       	call   80100f00 <fileclose>
801052e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	56                   	push   %esi
801052f0:	e8 2b c7 ff ff       	call   80101a20 <iunlockput>
    end_op();
801052f5:	e8 e6 da ff ff       	call   80102de0 <end_op>
    return -1;
801052fa:	83 c4 10             	add    $0x10,%esp
801052fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105302:	eb 6d                	jmp    80105371 <sys_open+0x121>
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010530e:	31 c9                	xor    %ecx,%ecx
80105310:	ba 02 00 00 00       	mov    $0x2,%edx
80105315:	6a 00                	push   $0x0
80105317:	e8 14 f8 ff ff       	call   80104b30 <create>
    if(ip == 0){
8010531c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010531f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105321:	85 c0                	test   %eax,%eax
80105323:	75 99                	jne    801052be <sys_open+0x6e>
      end_op();
80105325:	e8 b6 da ff ff       	call   80102de0 <end_op>
      return -1;
8010532a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010532f:	eb 40                	jmp    80105371 <sys_open+0x121>
80105331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105338:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010533b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010533f:	56                   	push   %esi
80105340:	e8 2b c5 ff ff       	call   80101870 <iunlock>
  end_op();
80105345:	e8 96 da ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
8010534a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105350:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105353:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105356:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105359:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010535b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105362:	f7 d0                	not    %eax
80105364:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105367:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010536a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010536d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105374:	89 d8                	mov    %ebx,%eax
80105376:	5b                   	pop    %ebx
80105377:	5e                   	pop    %esi
80105378:	5f                   	pop    %edi
80105379:	5d                   	pop    %ebp
8010537a:	c3                   	ret    
8010537b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010537f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105380:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105383:	85 c9                	test   %ecx,%ecx
80105385:	0f 84 33 ff ff ff    	je     801052be <sys_open+0x6e>
8010538b:	e9 5c ff ff ff       	jmp    801052ec <sys_open+0x9c>

80105390 <sys_mkdir>:

int
sys_mkdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105396:	e8 d5 d9 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010539b:	83 ec 08             	sub    $0x8,%esp
8010539e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053a1:	50                   	push   %eax
801053a2:	6a 00                	push   $0x0
801053a4:	e8 97 f6 ff ff       	call   80104a40 <argstr>
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	85 c0                	test   %eax,%eax
801053ae:	78 30                	js     801053e0 <sys_mkdir+0x50>
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b6:	31 c9                	xor    %ecx,%ecx
801053b8:	ba 01 00 00 00       	mov    $0x1,%edx
801053bd:	6a 00                	push   $0x0
801053bf:	e8 6c f7 ff ff       	call   80104b30 <create>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	74 15                	je     801053e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053cb:	83 ec 0c             	sub    $0xc,%esp
801053ce:	50                   	push   %eax
801053cf:	e8 4c c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
801053d4:	e8 07 da ff ff       	call   80102de0 <end_op>
  return 0;
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	31 c0                	xor    %eax,%eax
}
801053de:	c9                   	leave  
801053df:	c3                   	ret    
    end_op();
801053e0:	e8 fb d9 ff ff       	call   80102de0 <end_op>
    return -1;
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_mknod>:

int
sys_mknod(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053f6:	e8 75 d9 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053fb:	83 ec 08             	sub    $0x8,%esp
801053fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105401:	50                   	push   %eax
80105402:	6a 00                	push   $0x0
80105404:	e8 37 f6 ff ff       	call   80104a40 <argstr>
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	85 c0                	test   %eax,%eax
8010540e:	78 60                	js     80105470 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105416:	50                   	push   %eax
80105417:	6a 01                	push   $0x1
80105419:	e8 62 f5 ff ff       	call   80104980 <argint>
  if((argstr(0, &path)) < 0 ||
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	85 c0                	test   %eax,%eax
80105423:	78 4b                	js     80105470 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542b:	50                   	push   %eax
8010542c:	6a 02                	push   $0x2
8010542e:	e8 4d f5 ff ff       	call   80104980 <argint>
     argint(1, &major) < 0 ||
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 36                	js     80105470 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010543a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010543e:	83 ec 0c             	sub    $0xc,%esp
80105441:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105445:	ba 03 00 00 00       	mov    $0x3,%edx
8010544a:	50                   	push   %eax
8010544b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010544e:	e8 dd f6 ff ff       	call   80104b30 <create>
     argint(2, &minor) < 0 ||
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	74 16                	je     80105470 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010545a:	83 ec 0c             	sub    $0xc,%esp
8010545d:	50                   	push   %eax
8010545e:	e8 bd c5 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105463:	e8 78 d9 ff ff       	call   80102de0 <end_op>
  return 0;
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	31 c0                	xor    %eax,%eax
}
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    
8010546f:	90                   	nop
    end_op();
80105470:	e8 6b d9 ff ff       	call   80102de0 <end_op>
    return -1;
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010547a:	c9                   	leave  
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_chdir>:

int
sys_chdir(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	53                   	push   %ebx
80105485:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105488:	e8 43 e5 ff ff       	call   801039d0 <myproc>
8010548d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010548f:	e8 dc d8 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105494:	83 ec 08             	sub    $0x8,%esp
80105497:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549a:	50                   	push   %eax
8010549b:	6a 00                	push   $0x0
8010549d:	e8 9e f5 ff ff       	call   80104a40 <argstr>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	85 c0                	test   %eax,%eax
801054a7:	78 77                	js     80105520 <sys_chdir+0xa0>
801054a9:	83 ec 0c             	sub    $0xc,%esp
801054ac:	ff 75 f4             	push   -0xc(%ebp)
801054af:	e8 fc cb ff ff       	call   801020b0 <namei>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	89 c3                	mov    %eax,%ebx
801054b9:	85 c0                	test   %eax,%eax
801054bb:	74 63                	je     80105520 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054bd:	83 ec 0c             	sub    $0xc,%esp
801054c0:	50                   	push   %eax
801054c1:	e8 ca c2 ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
801054c6:	83 c4 10             	add    $0x10,%esp
801054c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054ce:	75 30                	jne    80105500 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	53                   	push   %ebx
801054d4:	e8 97 c3 ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
801054d9:	58                   	pop    %eax
801054da:	ff 76 68             	push   0x68(%esi)
801054dd:	e8 de c3 ff ff       	call   801018c0 <iput>
  end_op();
801054e2:	e8 f9 d8 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
801054e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	31 c0                	xor    %eax,%eax
}
801054ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054f2:	5b                   	pop    %ebx
801054f3:	5e                   	pop    %esi
801054f4:	5d                   	pop    %ebp
801054f5:	c3                   	ret    
801054f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	53                   	push   %ebx
80105504:	e8 17 c5 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105509:	e8 d2 d8 ff ff       	call   80102de0 <end_op>
    return -1;
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105516:	eb d7                	jmp    801054ef <sys_chdir+0x6f>
80105518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
    end_op();
80105520:	e8 bb d8 ff ff       	call   80102de0 <end_op>
    return -1;
80105525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552a:	eb c3                	jmp    801054ef <sys_chdir+0x6f>
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_exec>:

int
sys_exec(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105535:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010553b:	53                   	push   %ebx
8010553c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105542:	50                   	push   %eax
80105543:	6a 00                	push   $0x0
80105545:	e8 f6 f4 ff ff       	call   80104a40 <argstr>
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 c0                	test   %eax,%eax
8010554f:	0f 88 87 00 00 00    	js     801055dc <sys_exec+0xac>
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010555e:	50                   	push   %eax
8010555f:	6a 01                	push   $0x1
80105561:	e8 1a f4 ff ff       	call   80104980 <argint>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	78 6f                	js     801055dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105576:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105578:	68 80 00 00 00       	push   $0x80
8010557d:	6a 00                	push   $0x0
8010557f:	56                   	push   %esi
80105580:	e8 3b f1 ff ff       	call   801046c0 <memset>
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105590:	83 ec 08             	sub    $0x8,%esp
80105593:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105599:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801055a0:	50                   	push   %eax
801055a1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055a7:	01 f8                	add    %edi,%eax
801055a9:	50                   	push   %eax
801055aa:	e8 41 f3 ff ff       	call   801048f0 <fetchint>
801055af:	83 c4 10             	add    $0x10,%esp
801055b2:	85 c0                	test   %eax,%eax
801055b4:	78 26                	js     801055dc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055b6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055bc:	85 c0                	test   %eax,%eax
801055be:	74 30                	je     801055f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055c6:	52                   	push   %edx
801055c7:	50                   	push   %eax
801055c8:	e8 63 f3 ff ff       	call   80104930 <fetchstr>
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 08                	js     801055dc <sys_exec+0xac>
  for(i=0;; i++){
801055d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055d7:	83 fb 20             	cmp    $0x20,%ebx
801055da:	75 b4                	jne    80105590 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e4:	5b                   	pop    %ebx
801055e5:	5e                   	pop    %esi
801055e6:	5f                   	pop    %edi
801055e7:	5d                   	pop    %ebp
801055e8:	c3                   	ret    
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055f7:	00 00 00 00 
  return exec(path, argv);
801055fb:	83 ec 08             	sub    $0x8,%esp
801055fe:	56                   	push   %esi
801055ff:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105605:	e8 a6 b4 ff ff       	call   80100ab0 <exec>
8010560a:	83 c4 10             	add    $0x10,%esp
}
8010560d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105610:	5b                   	pop    %ebx
80105611:	5e                   	pop    %esi
80105612:	5f                   	pop    %edi
80105613:	5d                   	pop    %ebp
80105614:	c3                   	ret    
80105615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_pipe>:

int
sys_pipe(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	57                   	push   %edi
80105624:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105625:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105628:	53                   	push   %ebx
80105629:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010562c:	6a 08                	push   $0x8
8010562e:	50                   	push   %eax
8010562f:	6a 00                	push   $0x0
80105631:	e8 9a f3 ff ff       	call   801049d0 <argptr>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	85 c0                	test   %eax,%eax
8010563b:	78 4a                	js     80105687 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010563d:	83 ec 08             	sub    $0x8,%esp
80105640:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105643:	50                   	push   %eax
80105644:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105647:	50                   	push   %eax
80105648:	e8 f3 dd ff ff       	call   80103440 <pipealloc>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	78 33                	js     80105687 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105654:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105657:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105659:	e8 72 e3 ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010565e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105660:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105664:	85 f6                	test   %esi,%esi
80105666:	74 28                	je     80105690 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105668:	83 c3 01             	add    $0x1,%ebx
8010566b:	83 fb 10             	cmp    $0x10,%ebx
8010566e:	75 f0                	jne    80105660 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	ff 75 e0             	push   -0x20(%ebp)
80105676:	e8 85 b8 ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010567b:	58                   	pop    %eax
8010567c:	ff 75 e4             	push   -0x1c(%ebp)
8010567f:	e8 7c b8 ff ff       	call   80100f00 <fileclose>
    return -1;
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568c:	eb 53                	jmp    801056e1 <sys_pipe+0xc1>
8010568e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105690:	8d 73 08             	lea    0x8(%ebx),%esi
80105693:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105697:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010569a:	e8 31 e3 ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010569f:	31 d2                	xor    %edx,%edx
801056a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056a8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056ac:	85 c9                	test   %ecx,%ecx
801056ae:	74 20                	je     801056d0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801056b0:	83 c2 01             	add    $0x1,%edx
801056b3:	83 fa 10             	cmp    $0x10,%edx
801056b6:	75 f0                	jne    801056a8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801056b8:	e8 13 e3 ff ff       	call   801039d0 <myproc>
801056bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056c4:	00 
801056c5:	eb a9                	jmp    80105670 <sys_pipe+0x50>
801056c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056d0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056d7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056df:	31 c0                	xor    %eax,%eax
}
801056e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e4:	5b                   	pop    %ebx
801056e5:	5e                   	pop    %esi
801056e6:	5f                   	pop    %edi
801056e7:	5d                   	pop    %ebp
801056e8:	c3                   	ret    
801056e9:	66 90                	xchg   %ax,%ax
801056eb:	66 90                	xchg   %ax,%ax
801056ed:	66 90                	xchg   %ax,%ax
801056ef:	90                   	nop

801056f0 <sys_fork>:
};

int
sys_fork(void)
{
  return fork();
801056f0:	e9 7b e4 ff ff       	jmp    80103b70 <fork>
801056f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_exit>:
}

int
sys_exit(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 08             	sub    $0x8,%esp
  exit();
80105706:	e8 e5 e6 ff ff       	call   80103df0 <exit>
  return 0;  // not reached
}
8010570b:	31 c0                	xor    %eax,%eax
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
8010570f:	90                   	nop

80105710 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105710:	e9 0b e8 ff ff       	jmp    80103f20 <wait>
80105715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_kill>:
}

int
sys_kill(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105726:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105729:	50                   	push   %eax
8010572a:	6a 00                	push   $0x0
8010572c:	e8 4f f2 ff ff       	call   80104980 <argint>
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	85 c0                	test   %eax,%eax
80105736:	78 18                	js     80105750 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105738:	83 ec 0c             	sub    $0xc,%esp
8010573b:	ff 75 f4             	push   -0xc(%ebp)
8010573e:	e8 7d ea ff ff       	call   801041c0 <kill>
80105743:	83 c4 10             	add    $0x10,%esp
}
80105746:	c9                   	leave  
80105747:	c3                   	ret    
80105748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574f:	90                   	nop
80105750:	c9                   	leave  
    return -1;
80105751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105756:	c3                   	ret    
80105757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575e:	66 90                	xchg   %ax,%ax

80105760 <sys_getpid>:

int
sys_getpid(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105766:	e8 65 e2 ff ff       	call   801039d0 <myproc>
8010576b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010576e:	c9                   	leave  
8010576f:	c3                   	ret    

80105770 <sys_sbrk>:

int
sys_sbrk(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105774:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105777:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010577a:	50                   	push   %eax
8010577b:	6a 00                	push   $0x0
8010577d:	e8 fe f1 ff ff       	call   80104980 <argint>
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	85 c0                	test   %eax,%eax
80105787:	78 27                	js     801057b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105789:	e8 42 e2 ff ff       	call   801039d0 <myproc>
  if(growproc(n) < 0)
8010578e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105791:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105793:	ff 75 f4             	push   -0xc(%ebp)
80105796:	e8 55 e3 ff ff       	call   80103af0 <growproc>
8010579b:	83 c4 10             	add    $0x10,%esp
8010579e:	85 c0                	test   %eax,%eax
801057a0:	78 0e                	js     801057b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057a2:	89 d8                	mov    %ebx,%eax
801057a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a7:	c9                   	leave  
801057a8:	c3                   	ret    
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057b5:	eb eb                	jmp    801057a2 <sys_sbrk+0x32>
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax

801057c0 <sys_sleep>:

int
sys_sleep(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ca:	50                   	push   %eax
801057cb:	6a 00                	push   $0x0
801057cd:	e8 ae f1 ff ff       	call   80104980 <argint>
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	85 c0                	test   %eax,%eax
801057d7:	0f 88 8a 00 00 00    	js     80105867 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801057dd:	83 ec 0c             	sub    $0xc,%esp
801057e0:	68 80 9d 11 80       	push   $0x80119d80
801057e5:	e8 16 ee ff ff       	call   80104600 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801057ed:	8b 1d 60 9d 11 80    	mov    0x80119d60,%ebx
  while(ticks - ticks0 < n){
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	85 d2                	test   %edx,%edx
801057f8:	75 27                	jne    80105821 <sys_sleep+0x61>
801057fa:	eb 54                	jmp    80105850 <sys_sleep+0x90>
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105800:	83 ec 08             	sub    $0x8,%esp
80105803:	68 80 9d 11 80       	push   $0x80119d80
80105808:	68 60 9d 11 80       	push   $0x80119d60
8010580d:	e8 8e e8 ff ff       	call   801040a0 <sleep>
  while(ticks - ticks0 < n){
80105812:	a1 60 9d 11 80       	mov    0x80119d60,%eax
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	29 d8                	sub    %ebx,%eax
8010581c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010581f:	73 2f                	jae    80105850 <sys_sleep+0x90>
    if(myproc()->killed){
80105821:	e8 aa e1 ff ff       	call   801039d0 <myproc>
80105826:	8b 40 24             	mov    0x24(%eax),%eax
80105829:	85 c0                	test   %eax,%eax
8010582b:	74 d3                	je     80105800 <sys_sleep+0x40>
      release(&tickslock);
8010582d:	83 ec 0c             	sub    $0xc,%esp
80105830:	68 80 9d 11 80       	push   $0x80119d80
80105835:	e8 66 ed ff ff       	call   801045a0 <release>
  }
  release(&tickslock);
  return 0;
}
8010583a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010583d:	83 c4 10             	add    $0x10,%esp
80105840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105845:	c9                   	leave  
80105846:	c3                   	ret    
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	68 80 9d 11 80       	push   $0x80119d80
80105858:	e8 43 ed ff ff       	call   801045a0 <release>
  return 0;
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	31 c0                	xor    %eax,%eax
}
80105862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105865:	c9                   	leave  
80105866:	c3                   	ret    
    return -1;
80105867:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586c:	eb f4                	jmp    80105862 <sys_sleep+0xa2>
8010586e:	66 90                	xchg   %ax,%ax

80105870 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	53                   	push   %ebx
80105874:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105877:	68 80 9d 11 80       	push   $0x80119d80
8010587c:	e8 7f ed ff ff       	call   80104600 <acquire>
  xticks = ticks;
80105881:	8b 1d 60 9d 11 80    	mov    0x80119d60,%ebx
  release(&tickslock);
80105887:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
8010588e:	e8 0d ed ff ff       	call   801045a0 <release>
  return xticks;
}
80105893:	89 d8                	mov    %ebx,%eax
80105895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105898:	c9                   	leave  
80105899:	c3                   	ret    
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058a0 <sys_wmap>:

// ########################### p5 ###########################

// to request physical memory pages 
int sys_wmap(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
  int flags_val;        // MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS
  int fd;             // file descriptor 

  // Extract arguments for sys_call
  // Check : valid arguments provided
  if(argint(0, &start_va)<0 || argint(1, &mem_length)<0 || argint(2, &flags_val)<0 || argint(3, &fd)<0)
801058a5:	8d 45 d8             	lea    -0x28(%ebp),%eax
{
801058a8:	53                   	push   %ebx
801058a9:	83 ec 34             	sub    $0x34,%esp
  if(argint(0, &start_va)<0 || argint(1, &mem_length)<0 || argint(2, &flags_val)<0 || argint(3, &fd)<0)
801058ac:	50                   	push   %eax
801058ad:	6a 00                	push   $0x0
801058af:	e8 cc f0 ff ff       	call   80104980 <argint>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	0f 88 19 01 00 00    	js     801059d8 <sys_wmap+0x138>
801058bf:	83 ec 08             	sub    $0x8,%esp
801058c2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058c5:	50                   	push   %eax
801058c6:	6a 01                	push   $0x1
801058c8:	e8 b3 f0 ff ff       	call   80104980 <argint>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	0f 88 00 01 00 00    	js     801059d8 <sys_wmap+0x138>
801058d8:	83 ec 08             	sub    $0x8,%esp
801058db:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058de:	50                   	push   %eax
801058df:	6a 02                	push   $0x2
801058e1:	e8 9a f0 ff ff       	call   80104980 <argint>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	0f 88 e7 00 00 00    	js     801059d8 <sys_wmap+0x138>
801058f1:	83 ec 08             	sub    $0x8,%esp
801058f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058f7:	50                   	push   %eax
801058f8:	6a 03                	push   $0x3
801058fa:	e8 81 f0 ff ff       	call   80104980 <argint>
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	85 c0                	test   %eax,%eax
80105904:	0f 88 ce 00 00 00    	js     801059d8 <sys_wmap+0x138>
  {
    return FAILED;
  }

  // check : maximum number of memory maps per process = 16
  if(myproc()->num_maps >= 16)
8010590a:	e8 c1 e0 ff ff       	call   801039d0 <myproc>
8010590f:	83 b8 bc 01 00 00 0f 	cmpl   $0xf,0x1bc(%eax)
80105916:	0f 8f bc 00 00 00    	jg     801059d8 <sys_wmap+0x138>
  {
    return FAILED;
  }

  // check : virtual address is a multiple of PGSIZE(4096)
  if(start_va%PGSIZE != 0)
8010591c:	8b 75 d8             	mov    -0x28(%ebp),%esi
    return FAILED;
  }
  

  // check : virtual address belongs [0x60000000, 0x80000000)
  if(!(start_va >= 0x60000000 && start_va < 0x80000000))
8010591f:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
80105925:	0f 85 ad 00 00 00    	jne    801059d8 <sys_wmap+0x138>
8010592b:	81 fe ff ff ff 5f    	cmp    $0x5fffffff,%esi
80105931:	0f 8e a1 00 00 00    	jle    801059d8 <sys_wmap+0x138>
  {
    return FAILED;
  }

  // last va of the user-requested wmap
  int end_va = start_va + mem_length;
80105937:	03 75 dc             	add    -0x24(%ebp),%esi

  // check : overlapping maps
  for (int i = 0; i < 16; i++)
8010593a:	31 db                	xor    %ebx,%ebx
  int end_va = start_va + mem_length;
8010593c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  for (int i = 0; i < 16; i++)
8010593f:	90                   	nop
  {
    if(myproc()->mapinfo[i].start_addr != -1)
80105940:	e8 8b e0 ff ff       	call   801039d0 <myproc>
80105945:	89 c2                	mov    %eax,%edx
80105947:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
8010594a:	83 7c 82 7c ff       	cmpl   $0xffffffff,0x7c(%edx,%eax,4)
8010594f:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
80105956:	74 2b                	je     80105983 <sys_wmap+0xe3>
    {
      int wmap_start = myproc()->mapinfo[i].start_addr;
80105958:	e8 73 e0 ff ff       	call   801039d0 <myproc>
8010595d:	8b 74 07 7c          	mov    0x7c(%edi,%eax,1),%esi
      int wmap_end = myproc()->mapinfo[i].end_addr;
80105961:	e8 6a e0 ff ff       	call   801039d0 <myproc>
80105966:	8b 8c 07 80 00 00 00 	mov    0x80(%edi,%eax,1),%ecx
      
      // new wmap starts within an allocated wmap
      //  if(start_va >= wmap_start && start_va < wmap_end + PGSIZE -1)
      if(start_va >= wmap_start && start_va < wmap_end)
8010596d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105970:	39 f0                	cmp    %esi,%eax
80105972:	7c 04                	jl     80105978 <sys_wmap+0xd8>
80105974:	39 c8                	cmp    %ecx,%eax
80105976:	7c 60                	jl     801059d8 <sys_wmap+0x138>
        // cprintf("debug1\n");
        return FAILED;
      }

      // new wmap ends within an allocated wmap
      if(end_va >= wmap_start && end_va < wmap_end)
80105978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010597b:	39 f0                	cmp    %esi,%eax
8010597d:	7c 04                	jl     80105983 <sys_wmap+0xe3>
8010597f:	39 c8                	cmp    %ecx,%eax
80105981:	7c 55                	jl     801059d8 <sys_wmap+0x138>
  for (int i = 0; i < 16; i++)
80105983:	83 c3 01             	add    $0x1,%ebx
80105986:	83 fb 10             	cmp    $0x10,%ebx
80105989:	75 b5                	jne    80105940 <sys_wmap+0xa0>
    // MAP_SHARED not set
    return -1;
  }

  // check for MAP_FIXED 0x0004
  if(!(flags_val & MAP_FIXED))
8010598b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010598e:	83 e0 0a             	and    $0xa,%eax
80105991:	83 f8 0a             	cmp    $0xa,%eax
80105994:	75 42                	jne    801059d8 <sys_wmap+0x138>
  // }

  // -------------- update memory mapping meta-data --------------

  // increment number of wmaps 
  myproc()->num_maps += 1;
80105996:	e8 35 e0 ff ff       	call   801039d0 <myproc>
  
  for(int i=0; i<16; i++)
8010599b:	31 db                	xor    %ebx,%ebx
  myproc()->num_maps += 1;
8010599d:	83 80 bc 01 00 00 01 	addl   $0x1,0x1bc(%eax)
  for(int i=0; i<16; i++)
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(myproc()->mapinfo[i].start_addr == -1)
801059a8:	e8 23 e0 ff ff       	call   801039d0 <myproc>
801059ad:	8d 34 9b             	lea    (%ebx,%ebx,4),%esi
801059b0:	c1 e6 02             	shl    $0x2,%esi
801059b3:	8b 54 06 7c          	mov    0x7c(%esi,%eax,1),%edx
801059b7:	83 fa ff             	cmp    $0xffffffff,%edx
801059ba:	74 34                	je     801059f0 <sys_wmap+0x150>
  for(int i=0; i<16; i++)
801059bc:	83 c3 01             	add    $0x1,%ebx
801059bf:	83 fb 10             	cmp    $0x10,%ebx
801059c2:	75 e4                	jne    801059a8 <sys_wmap+0x108>
  //   if(start_va == 0x60000000){
  //     cprintf("GOTCHA pte : %x\n", *pte);
  //   }

  // return the starting va of the newly created mapping
  return start_va;
801059c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
}
801059c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059ca:	89 d0                	mov    %edx,%eax
801059cc:	5b                   	pop    %ebx
801059cd:	5e                   	pop    %esi
801059ce:	5f                   	pop    %edi
801059cf:	5d                   	pop    %ebp
801059d0:	c3                   	ret    
801059d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return FAILED;
801059db:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
801059e0:	5b                   	pop    %ebx
801059e1:	89 d0                	mov    %edx,%eax
801059e3:	5e                   	pop    %esi
801059e4:	5f                   	pop    %edi
801059e5:	5d                   	pop    %ebp
801059e6:	c3                   	ret    
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax
801059f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      myproc()->mapinfo[i].start_addr = start_va;
801059f3:	e8 d8 df ff ff       	call   801039d0 <myproc>
801059f8:	8b 7d d8             	mov    -0x28(%ebp),%edi
801059fb:	89 7c 06 7c          	mov    %edi,0x7c(%esi,%eax,1)
      myproc()->mapinfo[i].end_addr = start_va+mem_length-1;
801059ff:	03 7d dc             	add    -0x24(%ebp),%edi
80105a02:	83 ef 01             	sub    $0x1,%edi
80105a05:	e8 c6 df ff ff       	call   801039d0 <myproc>
80105a0a:	89 bc 06 80 00 00 00 	mov    %edi,0x80(%esi,%eax,1)
      myproc()->mapinfo[i].map_length = mem_length;
80105a11:	e8 ba df ff ff       	call   801039d0 <myproc>
80105a16:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105a19:	89 8c 06 84 00 00 00 	mov    %ecx,0x84(%esi,%eax,1)
      myproc()->mapinfo[i].pages_in_map = 0;
80105a20:	e8 ab df ff ff       	call   801039d0 <myproc>
      if(!(flags_val & MAP_ANONYMOUS))
80105a25:	8b 7d e0             	mov    -0x20(%ebp),%edi
      myproc()->mapinfo[i].pages_in_map = 0;
80105a28:	c7 84 06 88 00 00 00 	movl   $0x0,0x88(%esi,%eax,1)
80105a2f:	00 00 00 00 
      if(!(flags_val & MAP_ANONYMOUS))
80105a33:	83 e7 04             	and    $0x4,%edi
80105a36:	75 8c                	jne    801059c4 <sys_wmap+0x124>
  struct file *f = filedup(myproc()->ofile[fd]); // Duplicate the file descriptor
80105a38:	e8 93 df ff ff       	call   801039d0 <myproc>
80105a3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	ff 74 88 28          	push   0x28(%eax,%ecx,4)
80105a47:	e8 64 b4 ff ff       	call   80100eb0 <filedup>
  if (f == 0) {
80105a4c:	83 c4 10             	add    $0x10,%esp
80105a4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105a52:	85 c0                	test   %eax,%eax
  struct file *f = filedup(myproc()->ofile[fd]); // Duplicate the file descriptor
80105a54:	89 c6                	mov    %eax,%esi
  if (f == 0) {
80105a56:	74 80                	je     801059d8 <sys_wmap+0x138>
80105a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
80105a60:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (myproc()->ofile[i] == 0) { // Free slot found
80105a63:	e8 68 df ff ff       	call   801039d0 <myproc>
80105a68:	8d 4f 08             	lea    0x8(%edi),%ecx
80105a6b:	8b 54 b8 28          	mov    0x28(%eax,%edi,4),%edx
80105a6f:	85 d2                	test   %edx,%edx
80105a71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105a74:	74 22                	je     80105a98 <sys_wmap+0x1f8>
  for (int i = 0; i < NOFILE; i++) {
80105a76:	83 c7 01             	add    $0x1,%edi
80105a79:	83 ff 10             	cmp    $0x10,%edi
80105a7c:	75 e2                	jne    80105a60 <sys_wmap+0x1c0>
      fileclose(f); // Close the duplicated file if no slot was found
80105a7e:	83 ec 0c             	sub    $0xc,%esp
80105a81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105a84:	56                   	push   %esi
80105a85:	e8 76 b4 ff ff       	call   80100f00 <fileclose>
      return -1;
80105a8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	e9 32 ff ff ff       	jmp    801059c7 <sys_wmap+0x127>
80105a95:	8d 76 00             	lea    0x0(%esi),%esi
80105a98:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
          myproc()->ofile[i] = f;    // Assign the duplicated file
80105a9b:	e8 30 df ff ff       	call   801039d0 <myproc>
80105aa0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80105aa3:	89 74 88 08          	mov    %esi,0x8(%eax,%ecx,4)
  myproc()->mapinfo[i].file_desc = newfd;
80105aa7:	e8 24 df ff ff       	call   801039d0 <myproc>
        cprintf("flag is set to : %d\n",fd);
80105aac:	83 ec 08             	sub    $0x8,%esp
  myproc()->mapinfo[i].file_desc = newfd;
80105aaf:	8d 14 9b             	lea    (%ebx,%ebx,4),%edx
80105ab2:	89 bc 90 8c 00 00 00 	mov    %edi,0x8c(%eax,%edx,4)
        cprintf("flag is set to : %d\n",fd);
80105ab9:	ff 75 e4             	push   -0x1c(%ebp)
80105abc:	68 ed 81 10 80       	push   $0x801081ed
80105ac1:	e8 da ab ff ff       	call   801006a0 <cprintf>
        if(myproc()->ofile[fd] == 0)
80105ac6:	e8 05 df ff ff       	call   801039d0 <myproc>
80105acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105ace:	83 c4 10             	add    $0x10,%esp
80105ad1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	0f 85 e7 fe ff ff    	jne    801059c4 <sys_wmap+0x124>
          cprintf("NULL NULL");
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 02 82 10 80       	push   $0x80108202
80105ae5:	e8 b6 ab ff ff       	call   801006a0 <cprintf>
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	e9 d2 fe ff ff       	jmp    801059c4 <sys_wmap+0x124>
80105af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_wunmap>:



int sys_wunmap(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
  int start_va;
  if(argint(0, &start_va)<0)
80105b05:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105b08:	53                   	push   %ebx
80105b09:	83 ec 44             	sub    $0x44,%esp
  if(argint(0, &start_va)<0)
80105b0c:	50                   	push   %eax
80105b0d:	6a 00                	push   $0x0
80105b0f:	e8 6c ee ff ff       	call   80104980 <argint>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	0f 88 f0 01 00 00    	js     80105d0f <sys_wunmap+0x20f>

  // int copy_va = start_va;

  // find if a memory map for start_va exists
  int map_index = -1;
  for(int i=0; i<16; i++)
80105b1f:	31 db                	xor    %ebx,%ebx
80105b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if(myproc()->mapinfo[i].start_addr == start_va)
80105b28:	e8 a3 de ff ff       	call   801039d0 <myproc>
80105b2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b30:	89 c2                	mov    %eax,%edx
80105b32:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
80105b35:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
80105b3c:	39 4c 82 7c          	cmp    %ecx,0x7c(%edx,%eax,4)
80105b40:	74 26                	je     80105b68 <sys_wunmap+0x68>
  for(int i=0; i<16; i++)
80105b42:	83 c3 01             	add    $0x1,%ebx
80105b45:	83 fb 10             	cmp    $0x10,%ebx
80105b48:	75 de                	jne    80105b28 <sys_wunmap+0x28>
  }

  // no such memory map exists
  if(map_index == -1)
  {
    cprintf("map_index = -1\n");
80105b4a:	83 ec 0c             	sub    $0xc,%esp
80105b4d:	68 1b 82 10 80       	push   $0x8010821b
80105b52:	e8 49 ab ff ff       	call   801006a0 <cprintf>
    return -1;
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5f:	e9 6c 01 00 00       	jmp    80105cd0 <sys_wunmap+0x1d0>
80105b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // filewrite(f, (char*)myproc()->mapinfo[map_index].start_addr, myproc()->mapinfo[map_index].map_length);

  // reset the metadata

  int fd_2 = myproc()->mapinfo[map_index].file_desc;
80105b68:	e8 63 de ff ff       	call   801039d0 <myproc>
80105b6d:	8b bc 06 8c 00 00 00 	mov    0x8c(%esi,%eax,1),%edi
80105b74:	89 7d d0             	mov    %edi,-0x30(%ebp)

  // free each page in the map, write back to all files that have valid file-backed flag as well
  int curr_addr = myproc()->mapinfo[map_index].start_addr;
80105b77:	e8 54 de ff ff       	call   801039d0 <myproc>
80105b7c:	8b 74 06 7c          	mov    0x7c(%esi,%eax,1),%esi
  struct file *f = 0;
      if(fd_2 != -1){
80105b80:	83 ff ff             	cmp    $0xffffffff,%edi
80105b83:	0f 85 57 01 00 00    	jne    80105ce0 <sys_wunmap+0x1e0>
  struct file *f = 0;
80105b89:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
        // kill the process
        kill(myproc()->pid);
      }
      }
  
  int num_pages_total = myproc()->mapinfo[map_index].map_length/PGSIZE;
80105b90:	e8 3b de ff ff       	call   801039d0 <myproc>
80105b95:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
80105b98:	8d 14 8d 00 00 00 00 	lea    0x0(,%ecx,4),%edx
80105b9f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80105ba2:	8b 84 02 84 00 00 00 	mov    0x84(%edx,%eax,1),%eax
80105ba9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105bac:	85 c0                	test   %eax,%eax
80105bae:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
80105bb4:	0f 49 f8             	cmovns %eax,%edi
  if (myproc()->mapinfo[map_index].map_length % PGSIZE != 0)
80105bb7:	e8 14 de ff ff       	call   801039d0 <myproc>
80105bbc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  int num_pages_total = myproc()->mapinfo[map_index].map_length/PGSIZE;
80105bbf:	c1 ff 0c             	sar    $0xc,%edi
  if (myproc()->mapinfo[map_index].map_length % PGSIZE != 0)
80105bc2:	8b 84 02 84 00 00 00 	mov    0x84(%edx,%eax,1),%eax
80105bc9:	25 ff 0f 00 00       	and    $0xfff,%eax
  {
    num_pages_total += 1;
80105bce:	83 f8 01             	cmp    $0x1,%eax
80105bd1:	83 df ff             	sbb    $0xffffffff,%edi
  }
  for(int i=0; i<num_pages_total; i++)
80105bd4:	89 f8                	mov    %edi,%eax
80105bd6:	c1 e0 0c             	shl    $0xc,%eax
80105bd9:	01 f0                	add    %esi,%eax
80105bdb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105bde:	85 ff                	test   %edi,%edi
80105be0:	0f 8e 89 00 00 00    	jle    80105c6f <sys_wunmap+0x16f>
80105be6:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
80105be9:	eb 0a                	jmp    80105bf5 <sys_wunmap+0xf5>
80105beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop
80105bf0:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
80105bf3:	74 77                	je     80105c6c <sys_wunmap+0x16c>
  {
    
    pte_t *pte = walkpgdir(myproc()->pgdir, (char*)curr_addr, 0);   // get the page-table entry
80105bf5:	e8 d6 dd ff ff       	call   801039d0 <myproc>
80105bfa:	83 ec 04             	sub    $0x4,%esp
80105bfd:	89 f3                	mov    %esi,%ebx
80105bff:	6a 00                	push   $0x0
80105c01:	56                   	push   %esi
    if (pte == 0)
    {
      // page not allocated
      curr_addr += PGSIZE;
80105c02:	81 c6 00 10 00 00    	add    $0x1000,%esi
    pte_t *pte = walkpgdir(myproc()->pgdir, (char*)curr_addr, 0);   // get the page-table entry
80105c08:	ff 70 04             	push   0x4(%eax)
80105c0b:	e8 a0 14 00 00       	call   801070b0 <walkpgdir>
    if (pte == 0)
80105c10:	83 c4 10             	add    $0x10,%esp
    pte_t *pte = walkpgdir(myproc()->pgdir, (char*)curr_addr, 0);   // get the page-table entry
80105c13:	89 c7                	mov    %eax,%edi
    if (pte == 0)
80105c15:	85 c0                	test   %eax,%eax
80105c17:	74 d7                	je     80105bf0 <sys_wunmap+0xf0>
      continue;
    }

    // check if it is filebacked, then write back
    
    if(fd_2 != -1){
80105c19:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
80105c1d:	74 26                	je     80105c45 <sys_wunmap+0x145>
       // File-backed mapping
       f->off = curr_addr - myproc()->mapinfo[map_index].start_addr;
80105c1f:	e8 ac dd ff ff       	call   801039d0 <myproc>
80105c24:	8b 55 cc             	mov    -0x34(%ebp),%edx
80105c27:	89 d9                	mov    %ebx,%ecx
      filewrite(f, (char *)curr_addr, 4096);
80105c29:	83 ec 04             	sub    $0x4,%esp
       f->off = curr_addr - myproc()->mapinfo[map_index].start_addr;
80105c2c:	2b 4c 90 7c          	sub    0x7c(%eax,%edx,4),%ecx
80105c30:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105c33:	89 4a 14             	mov    %ecx,0x14(%edx)
      filewrite(f, (char *)curr_addr, 4096);
80105c36:	68 00 10 00 00       	push   $0x1000
80105c3b:	53                   	push   %ebx
80105c3c:	52                   	push   %edx
80105c3d:	e8 7e b4 ff ff       	call   801010c0 <filewrite>
80105c42:	83 c4 10             	add    $0x10,%esp
    }
    
    // check if it is physically allocated
    if(*pte & PTE_P) {
80105c45:	8b 07                	mov    (%edi),%eax
80105c47:	a8 01                	test   $0x1,%al
80105c49:	74 a5                	je     80105bf0 <sys_wunmap+0xf0>
    int physical_address = PTE_ADDR(*pte);                        // Access the upper 20-bit of PTE
80105c4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    kfree(P2V(physical_address));                                 // free the physical memory
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	05 00 00 00 80       	add    $0x80000000,%eax
80105c58:	50                   	push   %eax
80105c59:	e8 72 c8 ff ff       	call   801024d0 <kfree>
    *pte = 0;        
80105c5e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80105c64:	83 c4 10             	add    $0x10,%esp
  for(int i=0; i<num_pages_total; i++)
80105c67:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
80105c6a:	75 89                	jne    80105bf5 <sys_wunmap+0xf5>
80105c6c:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
    curr_addr += 0x1000;                                          // Increment va to next va

  }

  // myproc()->pages_in_map[map_index] = -1;
  myproc()->mapinfo[map_index].start_addr = -1;
80105c6f:	e8 5c dd ff ff       	call   801039d0 <myproc>
80105c74:	8d 1c 9b             	lea    (%ebx,%ebx,4),%ebx
80105c77:	c1 e3 02             	shl    $0x2,%ebx
80105c7a:	c7 44 03 7c ff ff ff 	movl   $0xffffffff,0x7c(%ebx,%eax,1)
80105c81:	ff 
  myproc()->mapinfo[map_index].end_addr = -1;
80105c82:	e8 49 dd ff ff       	call   801039d0 <myproc>
80105c87:	c7 84 03 80 00 00 00 	movl   $0xffffffff,0x80(%ebx,%eax,1)
80105c8e:	ff ff ff ff 
  myproc()->mapinfo[map_index].map_length = -1;
80105c92:	e8 39 dd ff ff       	call   801039d0 <myproc>
80105c97:	c7 84 03 84 00 00 00 	movl   $0xffffffff,0x84(%ebx,%eax,1)
80105c9e:	ff ff ff ff 
  myproc()->mapinfo[map_index].file_desc = -1;
80105ca2:	e8 29 dd ff ff       	call   801039d0 <myproc>
80105ca7:	c7 84 03 8c 00 00 00 	movl   $0xffffffff,0x8c(%ebx,%eax,1)
80105cae:	ff ff ff ff 
  myproc()->mapinfo[map_index].pages_in_map = -1;
80105cb2:	e8 19 dd ff ff       	call   801039d0 <myproc>
80105cb7:	c7 84 03 88 00 00 00 	movl   $0xffffffff,0x88(%ebx,%eax,1)
80105cbe:	ff ff ff ff 
  myproc()->num_maps -= 1;
80105cc2:	e8 09 dd ff ff       	call   801039d0 <myproc>
80105cc7:	83 a8 bc 01 00 00 01 	subl   $0x1,0x1bc(%eax)

  return 0;
80105cce:	31 c0                	xor    %eax,%eax
}
80105cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd3:	5b                   	pop    %ebx
80105cd4:	5e                   	pop    %esi
80105cd5:	5f                   	pop    %edi
80105cd6:	5d                   	pop    %ebp
80105cd7:	c3                   	ret    
80105cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
      if ((f = myproc()->ofile[fd_2]) == 0)
80105ce0:	e8 eb dc ff ff       	call   801039d0 <myproc>
80105ce5:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80105ce8:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80105cec:	89 45 c8             	mov    %eax,-0x38(%ebp)
80105cef:	85 c0                	test   %eax,%eax
80105cf1:	0f 85 99 fe ff ff    	jne    80105b90 <sys_wunmap+0x90>
        kill(myproc()->pid);
80105cf7:	e8 d4 dc ff ff       	call   801039d0 <myproc>
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	ff 70 10             	push   0x10(%eax)
80105d02:	e8 b9 e4 ff ff       	call   801041c0 <kill>
80105d07:	83 c4 10             	add    $0x10,%esp
80105d0a:	e9 81 fe ff ff       	jmp    80105b90 <sys_wunmap+0x90>
    cprintf("argint failed\n");
80105d0f:	83 ec 0c             	sub    $0xc,%esp
80105d12:	68 0c 82 10 80       	push   $0x8010820c
80105d17:	e8 84 a9 ff ff       	call   801006a0 <cprintf>
    return -1;
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d24:	eb aa                	jmp    80105cd0 <sys_wunmap+0x1d0>
80105d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi

80105d30 <sys_va2pa>:
/*
To translate a virtual address to physical address 
according to the page table for the calling process.
*/
int sys_va2pa(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	53                   	push   %ebx
  // 
  int user_va;
  if(argint(0, &user_va)<0)
80105d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &user_va)<0)
80105d3a:	50                   	push   %eax
80105d3b:	6a 00                	push   $0x0
80105d3d:	e8 3e ec ff ff       	call   80104980 <argint>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	78 49                	js     80105d92 <sys_va2pa+0x62>
  {
    return -1;
  }

  // page-table entry for the given virtual address
  pte_t *pte = walkpgdir(myproc()->pgdir, (char*)user_va, 0);
80105d49:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105d4c:	e8 7f dc ff ff       	call   801039d0 <myproc>
80105d51:	83 ec 04             	sub    $0x4,%esp
80105d54:	6a 00                	push   $0x0
80105d56:	53                   	push   %ebx
80105d57:	ff 70 04             	push   0x4(%eax)
80105d5a:	e8 51 13 00 00       	call   801070b0 <walkpgdir>
  /*null check*/
  if(pte==0)
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	85 c0                	test   %eax,%eax
80105d64:	74 2c                	je     80105d92 <sys_va2pa+0x62>
    return -1;
  }

  // cprintf("pte=%x\n", *pte);
  // check if PTE is present
  if((*pte & PTE_P) == 0)
80105d66:	8b 10                	mov    (%eax),%edx
80105d68:	f6 c2 01             	test   $0x1,%dl
80105d6b:	74 15                	je     80105d82 <sys_va2pa+0x52>
    return FAILED;
  }

  int ppn = PTE_ADDR(*pte);

  int offset = user_va & 0xFFF;
80105d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  int ppn = PTE_ADDR(*pte);
80105d70:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  int offset = user_va & 0xFFF;
80105d76:	25 ff 0f 00 00       	and    $0xfff,%eax
  
  int pa = ppn | offset;
80105d7b:	09 d0                	or     %edx,%eax

  // cprintf("ppn=%x\noffset=%x\npa=%x\n", ppn, offset, pa);
  return pa;
}
80105d7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d80:	c9                   	leave  
80105d81:	c3                   	ret    
    cprintf("YAS!\n");
80105d82:	83 ec 0c             	sub    $0xc,%esp
80105d85:	68 2b 82 10 80       	push   $0x8010822b
80105d8a:	e8 11 a9 ff ff       	call   801006a0 <cprintf>
    return FAILED;
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d97:	eb e4                	jmp    80105d7d <sys_va2pa+0x4d>
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_getwmapinfo>:

int sys_getwmapinfo(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
  // pointer for the struct argument
  struct wmapinfo *ptr;

  // check if argument are present & within allocated 
  // address space
  if(argptr(0, (void*)&ptr, sizeof(*ptr)) < 0)
80105da5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80105da8:	53                   	push   %ebx
80105da9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&ptr, sizeof(*ptr)) < 0)
80105dac:	68 c4 00 00 00       	push   $0xc4
80105db1:	50                   	push   %eax
80105db2:	6a 00                	push   $0x0
80105db4:	e8 17 ec ff ff       	call   801049d0 <argptr>
80105db9:	83 c4 10             	add    $0x10,%esp
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	0f 88 a2 00 00 00    	js     80105e66 <sys_getwmapinfo+0xc6>
  {
    return -1;
  }

  // Null pointer handled
  if(ptr==0)
80105dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dc7:	85 c0                	test   %eax,%eax
80105dc9:	0f 84 97 00 00 00    	je     80105e66 <sys_getwmapinfo+0xc6>
  {
    return -1;
  }

  int index = 0;
  for(int i=0; i<16; i++)
80105dcf:	31 db                	xor    %ebx,%ebx
  int index = 0;
80105dd1:	31 f6                	xor    %esi,%esi
80105dd3:	eb 47                	jmp    80105e1c <sys_getwmapinfo+0x7c>
80105dd5:	8d 76 00             	lea    0x0(%esi),%esi
      // ptr->addr[index] = myproc()->start_addr[i];
      // ptr->length[index] = myproc()->map_length[i];
      // ptr->n_loaded_pages[index] = myproc()->pages_in_map[i];


      ptr->addr[index] = myproc()->mapinfo[i].start_addr;
80105dd8:	e8 f3 db ff ff       	call   801039d0 <myproc>
  for(int i=0; i<16; i++)
80105ddd:	83 c3 01             	add    $0x1,%ebx
      ptr->addr[index] = myproc()->mapinfo[i].start_addr;
80105de0:	8b 54 07 7c          	mov    0x7c(%edi,%eax,1),%edx
80105de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105de7:	89 54 b0 04          	mov    %edx,0x4(%eax,%esi,4)
      ptr->length[index] = myproc()->mapinfo[i].map_length;
80105deb:	e8 e0 db ff ff       	call   801039d0 <myproc>
80105df0:	8b 94 07 84 00 00 00 	mov    0x84(%edi,%eax,1),%edx
80105df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dfa:	89 54 b0 44          	mov    %edx,0x44(%eax,%esi,4)
      ptr->n_loaded_pages[index] = myproc()->mapinfo[i].pages_in_map;
80105dfe:	e8 cd db ff ff       	call   801039d0 <myproc>
80105e03:	8b 94 07 88 00 00 00 	mov    0x88(%edi,%eax,1),%edx
80105e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e0d:	89 94 b0 84 00 00 00 	mov    %edx,0x84(%eax,%esi,4)
      index++;
80105e14:	83 c6 01             	add    $0x1,%esi
  for(int i=0; i<16; i++)
80105e17:	83 fb 10             	cmp    $0x10,%ebx
80105e1a:	74 3e                	je     80105e5a <sys_getwmapinfo+0xba>
    if(myproc()->mapinfo[i].start_addr != -1)
80105e1c:	e8 af db ff ff       	call   801039d0 <myproc>
80105e21:	89 c2                	mov    %eax,%edx
80105e23:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
80105e26:	83 7c 82 7c ff       	cmpl   $0xffffffff,0x7c(%edx,%eax,4)
80105e2b:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
80105e32:	75 a4                	jne    80105dd8 <sys_getwmapinfo+0x38>
    }
    else
    {
      ptr->addr[index] = 0;
80105e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(int i=0; i<16; i++)
80105e37:	83 c3 01             	add    $0x1,%ebx
80105e3a:	8d 14 b0             	lea    (%eax,%esi,4),%edx
      ptr->addr[index] = 0;
80105e3d:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
      ptr->length[index] = 0;
80105e44:	c7 42 44 00 00 00 00 	movl   $0x0,0x44(%edx)
      ptr->n_loaded_pages[index] = 0;
80105e4b:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
80105e52:	00 00 00 
  for(int i=0; i<16; i++)
80105e55:	83 fb 10             	cmp    $0x10,%ebx
80105e58:	75 c2                	jne    80105e1c <sys_getwmapinfo+0x7c>
    }
  }
  ptr->total_mmaps = index;
80105e5a:	89 30                	mov    %esi,(%eax)
  return 0;
80105e5c:	31 c0                	xor    %eax,%eax
}
80105e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e61:	5b                   	pop    %ebx
80105e62:	5e                   	pop    %esi
80105e63:	5f                   	pop    %edi
80105e64:	5d                   	pop    %ebp
80105e65:	c3                   	ret    
    return -1;
80105e66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6b:	eb f1                	jmp    80105e5e <sys_getwmapinfo+0xbe>
80105e6d:	8d 76 00             	lea    0x0(%esi),%esi

80105e70 <sys_test>:
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 08             	sub    $0x8,%esp
80105e76:	e8 55 db ff ff       	call   801039d0 <myproc>
80105e7b:	8b 40 10             	mov    0x10(%eax),%eax
80105e7e:	c9                   	leave  
80105e7f:	c3                   	ret    

80105e80 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e80:	1e                   	push   %ds
  pushl %es
80105e81:	06                   	push   %es
  pushl %fs
80105e82:	0f a0                	push   %fs
  pushl %gs
80105e84:	0f a8                	push   %gs
  pushal
80105e86:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e87:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e8b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e8d:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e8f:	54                   	push   %esp
  call trap
80105e90:	e8 cb 00 00 00       	call   80105f60 <trap>
  addl $4, %esp
80105e95:	83 c4 04             	add    $0x4,%esp

80105e98 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e98:	61                   	popa   
  popl %gs
80105e99:	0f a9                	pop    %gs
  popl %fs
80105e9b:	0f a1                	pop    %fs
  popl %es
80105e9d:	07                   	pop    %es
  popl %ds
80105e9e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e9f:	83 c4 08             	add    $0x8,%esp
  iret
80105ea2:	cf                   	iret   
80105ea3:	66 90                	xchg   %ax,%ax
80105ea5:	66 90                	xchg   %ax,%ax
80105ea7:	66 90                	xchg   %ax,%ax
80105ea9:	66 90                	xchg   %ax,%ax
80105eab:	66 90                	xchg   %ax,%ax
80105ead:	66 90                	xchg   %ax,%ax
80105eaf:	90                   	nop

80105eb0 <tvinit>:
};
uint ticks;

void
tvinit(void)
{
80105eb0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105eb1:	31 c0                	xor    %eax,%eax
{
80105eb3:	89 e5                	mov    %esp,%ebp
80105eb5:	83 ec 08             	sub    $0x8,%esp
80105eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ec0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ec7:	c7 04 c5 c2 9d 11 80 	movl   $0x8e000008,-0x7fee623e(,%eax,8)
80105ece:	08 00 00 8e 
80105ed2:	66 89 14 c5 c0 9d 11 	mov    %dx,-0x7fee6240(,%eax,8)
80105ed9:	80 
80105eda:	c1 ea 10             	shr    $0x10,%edx
80105edd:	66 89 14 c5 c6 9d 11 	mov    %dx,-0x7fee623a(,%eax,8)
80105ee4:	80 
  for(i = 0; i < 256; i++)
80105ee5:	83 c0 01             	add    $0x1,%eax
80105ee8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105eed:	75 d1                	jne    80105ec0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105eef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ef2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105ef7:	c7 05 c2 9f 11 80 08 	movl   $0xef000008,0x80119fc2
80105efe:	00 00 ef 
  initlock(&tickslock, "time");
80105f01:	68 31 82 10 80       	push   $0x80108231
80105f06:	68 80 9d 11 80       	push   $0x80119d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f0b:	66 a3 c0 9f 11 80    	mov    %ax,0x80119fc0
80105f11:	c1 e8 10             	shr    $0x10,%eax
80105f14:	66 a3 c6 9f 11 80    	mov    %ax,0x80119fc6
  initlock(&tickslock, "time");
80105f1a:	e8 11 e5 ff ff       	call   80104430 <initlock>
}
80105f1f:	83 c4 10             	add    $0x10,%esp
80105f22:	c9                   	leave  
80105f23:	c3                   	ret    
80105f24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f2f:	90                   	nop

80105f30 <idtinit>:

void
idtinit(void)
{
80105f30:	55                   	push   %ebp
  pd[0] = size-1;
80105f31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f36:	89 e5                	mov    %esp,%ebp
80105f38:	83 ec 10             	sub    $0x10,%esp
80105f3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f3f:	b8 c0 9d 11 80       	mov    $0x80119dc0,%eax
80105f44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f48:	c1 e8 10             	shr    $0x10,%eax
80105f4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5e:	66 90                	xchg   %ax,%ax

80105f60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	57                   	push   %edi
80105f64:	56                   	push   %esi
80105f65:	53                   	push   %ebx
80105f66:	83 ec 1c             	sub    $0x1c,%esp
80105f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105f6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105f6f:	83 f8 40             	cmp    $0x40,%eax
80105f72:	0f 84 30 01 00 00    	je     801060a8 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f78:	83 e8 0e             	sub    $0xe,%eax
80105f7b:	83 f8 31             	cmp    $0x31,%eax
80105f7e:	0f 87 8c 00 00 00    	ja     80106010 <trap+0xb0>
80105f84:	ff 24 85 7c 83 10 80 	jmp    *-0x7fef7c84(,%eax,4)
80105f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f8f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105f90:	e8 1b da ff ff       	call   801039b0 <cpuid>
80105f95:	85 c0                	test   %eax,%eax
80105f97:	0f 84 3b 03 00 00    	je     801062d8 <trap+0x378>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105f9d:	e8 7e c9 ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fa2:	e8 29 da ff ff       	call   801039d0 <myproc>
80105fa7:	85 c0                	test   %eax,%eax
80105fa9:	74 1d                	je     80105fc8 <trap+0x68>
80105fab:	e8 20 da ff ff       	call   801039d0 <myproc>
80105fb0:	8b 50 24             	mov    0x24(%eax),%edx
80105fb3:	85 d2                	test   %edx,%edx
80105fb5:	74 11                	je     80105fc8 <trap+0x68>
80105fb7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105fbb:	83 e0 03             	and    $0x3,%eax
80105fbe:	66 83 f8 03          	cmp    $0x3,%ax
80105fc2:	0f 84 d8 02 00 00    	je     801062a0 <trap+0x340>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105fc8:	e8 03 da ff ff       	call   801039d0 <myproc>
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	74 0f                	je     80105fe0 <trap+0x80>
80105fd1:	e8 fa d9 ff ff       	call   801039d0 <myproc>
80105fd6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105fda:	0f 84 b0 00 00 00    	je     80106090 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fe0:	e8 eb d9 ff ff       	call   801039d0 <myproc>
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	74 1d                	je     80106006 <trap+0xa6>
80105fe9:	e8 e2 d9 ff ff       	call   801039d0 <myproc>
80105fee:	8b 40 24             	mov    0x24(%eax),%eax
80105ff1:	85 c0                	test   %eax,%eax
80105ff3:	74 11                	je     80106006 <trap+0xa6>
80105ff5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ff9:	83 e0 03             	and    $0x3,%eax
80105ffc:	66 83 f8 03          	cmp    $0x3,%ax
80106000:	0f 84 cf 00 00 00    	je     801060d5 <trap+0x175>
    exit();
}
80106006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106009:	5b                   	pop    %ebx
8010600a:	5e                   	pop    %esi
8010600b:	5f                   	pop    %edi
8010600c:	5d                   	pop    %ebp
8010600d:	c3                   	ret    
8010600e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80106010:	e8 bb d9 ff ff       	call   801039d0 <myproc>
80106015:	8b 7b 38             	mov    0x38(%ebx),%edi
80106018:	85 c0                	test   %eax,%eax
8010601a:	0f 84 25 03 00 00    	je     80106345 <trap+0x3e5>
80106020:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106024:	0f 84 1b 03 00 00    	je     80106345 <trap+0x3e5>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010602a:	0f 20 d1             	mov    %cr2,%ecx
8010602d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106030:	e8 7b d9 ff ff       	call   801039b0 <cpuid>
80106035:	8b 73 30             	mov    0x30(%ebx),%esi
80106038:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010603b:	8b 43 34             	mov    0x34(%ebx),%eax
8010603e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106041:	e8 8a d9 ff ff       	call   801039d0 <myproc>
80106046:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106049:	e8 82 d9 ff ff       	call   801039d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010604e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106051:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106054:	51                   	push   %ecx
80106055:	57                   	push   %edi
80106056:	52                   	push   %edx
80106057:	ff 75 e4             	push   -0x1c(%ebp)
8010605a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010605b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010605e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106061:	56                   	push   %esi
80106062:	ff 70 10             	push   0x10(%eax)
80106065:	68 38 83 10 80       	push   $0x80108338
8010606a:	e8 31 a6 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010606f:	83 c4 20             	add    $0x20,%esp
80106072:	e8 59 d9 ff ff       	call   801039d0 <myproc>
80106077:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010607e:	e8 4d d9 ff ff       	call   801039d0 <myproc>
80106083:	85 c0                	test   %eax,%eax
80106085:	0f 85 20 ff ff ff    	jne    80105fab <trap+0x4b>
8010608b:	e9 38 ff ff ff       	jmp    80105fc8 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80106090:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106094:	0f 85 46 ff ff ff    	jne    80105fe0 <trap+0x80>
    yield();
8010609a:	e8 b1 df ff ff       	call   80104050 <yield>
8010609f:	e9 3c ff ff ff       	jmp    80105fe0 <trap+0x80>
801060a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801060a8:	e8 23 d9 ff ff       	call   801039d0 <myproc>
801060ad:	8b 70 24             	mov    0x24(%eax),%esi
801060b0:	85 f6                	test   %esi,%esi
801060b2:	0f 85 10 02 00 00    	jne    801062c8 <trap+0x368>
    myproc()->tf = tf;
801060b8:	e8 13 d9 ff ff       	call   801039d0 <myproc>
801060bd:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801060c0:	e8 fb e9 ff ff       	call   80104ac0 <syscall>
    if(myproc()->killed)
801060c5:	e8 06 d9 ff ff       	call   801039d0 <myproc>
801060ca:	8b 48 24             	mov    0x24(%eax),%ecx
801060cd:	85 c9                	test   %ecx,%ecx
801060cf:	0f 84 31 ff ff ff    	je     80106006 <trap+0xa6>
}
801060d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d8:	5b                   	pop    %ebx
801060d9:	5e                   	pop    %esi
801060da:	5f                   	pop    %edi
801060db:	5d                   	pop    %ebp
      exit();
801060dc:	e9 0f dd ff ff       	jmp    80103df0 <exit>
801060e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060e8:	8b 7b 38             	mov    0x38(%ebx),%edi
801060eb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801060ef:	e8 bc d8 ff ff       	call   801039b0 <cpuid>
801060f4:	57                   	push   %edi
801060f5:	56                   	push   %esi
801060f6:	50                   	push   %eax
801060f7:	68 6c 82 10 80       	push   $0x8010826c
801060fc:	e8 9f a5 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106101:	e8 1a c8 ff ff       	call   80102920 <lapiceoi>
    break;
80106106:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106109:	e8 c2 d8 ff ff       	call   801039d0 <myproc>
8010610e:	85 c0                	test   %eax,%eax
80106110:	0f 85 95 fe ff ff    	jne    80105fab <trap+0x4b>
80106116:	e9 ad fe ff ff       	jmp    80105fc8 <trap+0x68>
8010611b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010611f:	90                   	nop
    kbdintr();
80106120:	e8 bb c6 ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80106125:	e8 f6 c7 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010612a:	e8 a1 d8 ff ff       	call   801039d0 <myproc>
8010612f:	85 c0                	test   %eax,%eax
80106131:	0f 85 74 fe ff ff    	jne    80105fab <trap+0x4b>
80106137:	e9 8c fe ff ff       	jmp    80105fc8 <trap+0x68>
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106140:	e8 9b 03 00 00       	call   801064e0 <uartintr>
    lapiceoi();
80106145:	e8 d6 c7 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010614a:	e8 81 d8 ff ff       	call   801039d0 <myproc>
8010614f:	85 c0                	test   %eax,%eax
80106151:	0f 85 54 fe ff ff    	jne    80105fab <trap+0x4b>
80106157:	e9 6c fe ff ff       	jmp    80105fc8 <trap+0x68>
8010615c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106160:	e8 eb c0 ff ff       	call   80102250 <ideintr>
80106165:	e9 33 fe ff ff       	jmp    80105f9d <trap+0x3d>
8010616a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106170:	0f 20 d7             	mov    %cr2,%edi
    if(pgflt_va == -1) {
80106173:	83 ff ff             	cmp    $0xffffffff,%edi
80106176:	0f 84 94 01 00 00    	je     80106310 <trap+0x3b0>
{
8010617c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010617f:	31 f6                	xor    %esi,%esi
80106181:	eb 0d                	jmp    80106190 <trap+0x230>
80106183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106187:	90                   	nop
    for(int i=0; i<16; i++)
80106188:	83 c6 01             	add    $0x1,%esi
8010618b:	83 fe 10             	cmp    $0x10,%esi
8010618e:	74 30                	je     801061c0 <trap+0x260>
      if(pgflt_va >= myproc()->mapinfo[i].start_addr && pgflt_va <= myproc()->mapinfo[i].end_addr)
80106190:	e8 3b d8 ff ff       	call   801039d0 <myproc>
80106195:	89 c1                	mov    %eax,%ecx
80106197:	8d 04 b6             	lea    (%esi,%esi,4),%eax
8010619a:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
801061a1:	39 7c 81 7c          	cmp    %edi,0x7c(%ecx,%eax,4)
801061a5:	7f e1                	jg     80106188 <trap+0x228>
801061a7:	e8 24 d8 ff ff       	call   801039d0 <myproc>
801061ac:	39 bc 03 80 00 00 00 	cmp    %edi,0x80(%ebx,%eax,1)
801061b3:	7c d3                	jl     80106188 <trap+0x228>
801061b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801061b8:	eb 23                	jmp    801061dd <trap+0x27d>
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("Segmentation Fault\n");
801061c0:	83 ec 0c             	sub    $0xc,%esp
801061c3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    int map_index = -1;                   
801061c6:	be ff ff ff ff       	mov    $0xffffffff,%esi
      cprintf("Segmentation Fault\n");
801061cb:	68 58 82 10 80       	push   $0x80108258
801061d0:	e8 cb a4 ff ff       	call   801006a0 <cprintf>
      exit();
801061d5:	e8 16 dc ff ff       	call   80103df0 <exit>
801061da:	83 c4 10             	add    $0x10,%esp
    char *mem = kalloc();
801061dd:	e8 ae c4 ff ff       	call   80102690 <kalloc>
    memset(mem, 0, PGSIZE);
801061e2:	83 ec 04             	sub    $0x4,%esp
    int alloc_va = PGROUNDDOWN(pgflt_va);
801061e5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    memset(mem, 0, PGSIZE);
801061eb:	68 00 10 00 00       	push   $0x1000
801061f0:	6a 00                	push   $0x0
801061f2:	50                   	push   %eax
801061f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061f6:	e8 c5 e4 ff ff       	call   801046c0 <memset>
    if (mappages(myproc()->pgdir, (char*)alloc_va, 4096, V2P(mem), PTE_W | PTE_U) == -1)
801061fb:	e8 d0 d7 ff ff       	call   801039d0 <myproc>
80106200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106203:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010620a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106210:	52                   	push   %edx
80106211:	68 00 10 00 00       	push   $0x1000
80106216:	57                   	push   %edi
80106217:	ff 70 04             	push   0x4(%eax)
8010621a:	e8 21 0f 00 00       	call   80107140 <mappages>
8010621f:	83 c4 20             	add    $0x20,%esp
80106222:	83 f8 ff             	cmp    $0xffffffff,%eax
80106225:	0f 84 05 01 00 00    	je     80106330 <trap+0x3d0>
    int fd = myproc()->mapinfo[map_index].file_desc;
8010622b:	e8 a0 d7 ff ff       	call   801039d0 <myproc>
80106230:	8d 14 b6             	lea    (%esi,%esi,4),%edx
80106233:	8b 94 90 8c 00 00 00 	mov    0x8c(%eax,%edx,4),%edx
    if(fd != -1)
8010623a:	83 fa ff             	cmp    $0xffffffff,%edx
8010623d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106240:	74 3b                	je     8010627d <trap+0x31d>
      if((f = myproc()->ofile[fd]) == 0)
80106242:	e8 89 d7 ff ff       	call   801039d0 <myproc>
80106247:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010624a:	8b 54 90 28          	mov    0x28(%eax,%edx,4),%edx
8010624e:	85 d2                	test   %edx,%edx
80106250:	74 58                	je     801062aa <trap+0x34a>
80106252:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      f->off = alloc_va -  myproc()->mapinfo[map_index].start_addr;
80106255:	e8 76 d7 ff ff       	call   801039d0 <myproc>
8010625a:	8d 0c b6             	lea    (%esi,%esi,4),%ecx
8010625d:	89 fa                	mov    %edi,%edx
      fileread(f, (char*)alloc_va, 4096);
8010625f:	83 ec 04             	sub    $0x4,%esp
      f->off = alloc_va -  myproc()->mapinfo[map_index].start_addr;
80106262:	2b 54 88 7c          	sub    0x7c(%eax,%ecx,4),%edx
80106266:	89 d0                	mov    %edx,%eax
80106268:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010626b:	89 42 14             	mov    %eax,0x14(%edx)
      fileread(f, (char*)alloc_va, 4096);
8010626e:	68 00 10 00 00       	push   $0x1000
80106273:	57                   	push   %edi
80106274:	52                   	push   %edx
80106275:	e8 b6 ad ff ff       	call   80101030 <fileread>
8010627a:	83 c4 10             	add    $0x10,%esp
    myproc()->mapinfo[map_index].pages_in_map += 1;
8010627d:	e8 4e d7 ff ff       	call   801039d0 <myproc>
80106282:	8d 14 b6             	lea    (%esi,%esi,4),%edx
80106285:	83 84 90 88 00 00 00 	addl   $0x1,0x88(%eax,%edx,4)
8010628c:	01 
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010628d:	e8 3e d7 ff ff       	call   801039d0 <myproc>
80106292:	85 c0                	test   %eax,%eax
80106294:	0f 85 11 fd ff ff    	jne    80105fab <trap+0x4b>
8010629a:	e9 29 fd ff ff       	jmp    80105fc8 <trap+0x68>
8010629f:	90                   	nop
    exit();
801062a0:	e8 4b db ff ff       	call   80103df0 <exit>
801062a5:	e9 1e fd ff ff       	jmp    80105fc8 <trap+0x68>
        cprintf("NULL pointer to the file structure, has the file with ofile[fd] been opened (sys_open)yet \nOR\n has it been closed?\n");
801062aa:	83 ec 0c             	sub    $0xc,%esp
801062ad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801062b0:	68 90 82 10 80       	push   $0x80108290
801062b5:	e8 e6 a3 ff ff       	call   801006a0 <cprintf>
801062ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801062bd:	83 c4 10             	add    $0x10,%esp
801062c0:	eb 90                	jmp    80106252 <trap+0x2f2>
801062c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801062c8:	e8 23 db ff ff       	call   80103df0 <exit>
801062cd:	e9 e6 fd ff ff       	jmp    801060b8 <trap+0x158>
801062d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801062d8:	83 ec 0c             	sub    $0xc,%esp
801062db:	68 80 9d 11 80       	push   $0x80119d80
801062e0:	e8 1b e3 ff ff       	call   80104600 <acquire>
      wakeup(&ticks);
801062e5:	c7 04 24 60 9d 11 80 	movl   $0x80119d60,(%esp)
      ticks++;
801062ec:	83 05 60 9d 11 80 01 	addl   $0x1,0x80119d60
      wakeup(&ticks);
801062f3:	e8 68 de ff ff       	call   80104160 <wakeup>
      release(&tickslock);
801062f8:	c7 04 24 80 9d 11 80 	movl   $0x80119d80,(%esp)
801062ff:	e8 9c e2 ff ff       	call   801045a0 <release>
80106304:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106307:	e9 91 fc ff ff       	jmp    80105f9d <trap+0x3d>
8010630c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("gotcha 2\n");
80106310:	83 ec 0c             	sub    $0xc,%esp
80106313:	68 36 82 10 80       	push   $0x80108236
80106318:	e8 83 a3 ff ff       	call   801006a0 <cprintf>
      exit();
8010631d:	e8 ce da ff ff       	call   80103df0 <exit>
80106322:	83 c4 10             	add    $0x10,%esp
80106325:	e9 52 fe ff ff       	jmp    8010617c <trap+0x21c>
8010632a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("mappages() failed\n");
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	68 40 82 10 80       	push   $0x80108240
80106338:	e8 63 a3 ff ff       	call   801006a0 <cprintf>
8010633d:	83 c4 10             	add    $0x10,%esp
80106340:	e9 e6 fe ff ff       	jmp    8010622b <trap+0x2cb>
80106345:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106348:	e8 63 d6 ff ff       	call   801039b0 <cpuid>
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	56                   	push   %esi
80106351:	57                   	push   %edi
80106352:	50                   	push   %eax
80106353:	ff 73 30             	push   0x30(%ebx)
80106356:	68 04 83 10 80       	push   $0x80108304
8010635b:	e8 40 a3 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106360:	83 c4 14             	add    $0x14,%esp
80106363:	68 53 82 10 80       	push   $0x80108253
80106368:	e8 13 a0 ff ff       	call   80100380 <panic>
8010636d:	66 90                	xchg   %ax,%ax
8010636f:	90                   	nop

80106370 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106370:	a1 c0 a5 11 80       	mov    0x8011a5c0,%eax
80106375:	85 c0                	test   %eax,%eax
80106377:	74 17                	je     80106390 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106379:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010637e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010637f:	a8 01                	test   $0x1,%al
80106381:	74 0d                	je     80106390 <uartgetc+0x20>
80106383:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106388:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106389:	0f b6 c0             	movzbl %al,%eax
8010638c:	c3                   	ret    
8010638d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106395:	c3                   	ret    
80106396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010639d:	8d 76 00             	lea    0x0(%esi),%esi

801063a0 <uartinit>:
{
801063a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063a1:	31 c9                	xor    %ecx,%ecx
801063a3:	89 c8                	mov    %ecx,%eax
801063a5:	89 e5                	mov    %esp,%ebp
801063a7:	57                   	push   %edi
801063a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801063ad:	56                   	push   %esi
801063ae:	89 fa                	mov    %edi,%edx
801063b0:	53                   	push   %ebx
801063b1:	83 ec 1c             	sub    $0x1c,%esp
801063b4:	ee                   	out    %al,(%dx)
801063b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801063ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801063bf:	89 f2                	mov    %esi,%edx
801063c1:	ee                   	out    %al,(%dx)
801063c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801063c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063cc:	ee                   	out    %al,(%dx)
801063cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801063d2:	89 c8                	mov    %ecx,%eax
801063d4:	89 da                	mov    %ebx,%edx
801063d6:	ee                   	out    %al,(%dx)
801063d7:	b8 03 00 00 00       	mov    $0x3,%eax
801063dc:	89 f2                	mov    %esi,%edx
801063de:	ee                   	out    %al,(%dx)
801063df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063e4:	89 c8                	mov    %ecx,%eax
801063e6:	ee                   	out    %al,(%dx)
801063e7:	b8 01 00 00 00       	mov    $0x1,%eax
801063ec:	89 da                	mov    %ebx,%edx
801063ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063f5:	3c ff                	cmp    $0xff,%al
801063f7:	74 78                	je     80106471 <uartinit+0xd1>
  uart = 1;
801063f9:	c7 05 c0 a5 11 80 01 	movl   $0x1,0x8011a5c0
80106400:	00 00 00 
80106403:	89 fa                	mov    %edi,%edx
80106405:	ec                   	in     (%dx),%al
80106406:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010640b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010640c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010640f:	bf 44 84 10 80       	mov    $0x80108444,%edi
80106414:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106419:	6a 00                	push   $0x0
8010641b:	6a 04                	push   $0x4
8010641d:	e8 6e c0 ff ff       	call   80102490 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106422:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106426:	83 c4 10             	add    $0x10,%esp
80106429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106430:	a1 c0 a5 11 80       	mov    0x8011a5c0,%eax
80106435:	bb 80 00 00 00       	mov    $0x80,%ebx
8010643a:	85 c0                	test   %eax,%eax
8010643c:	75 14                	jne    80106452 <uartinit+0xb2>
8010643e:	eb 23                	jmp    80106463 <uartinit+0xc3>
    microdelay(10);
80106440:	83 ec 0c             	sub    $0xc,%esp
80106443:	6a 0a                	push   $0xa
80106445:	e8 f6 c4 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010644a:	83 c4 10             	add    $0x10,%esp
8010644d:	83 eb 01             	sub    $0x1,%ebx
80106450:	74 07                	je     80106459 <uartinit+0xb9>
80106452:	89 f2                	mov    %esi,%edx
80106454:	ec                   	in     (%dx),%al
80106455:	a8 20                	test   $0x20,%al
80106457:	74 e7                	je     80106440 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106459:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010645d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106462:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106463:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106467:	83 c7 01             	add    $0x1,%edi
8010646a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010646d:	84 c0                	test   %al,%al
8010646f:	75 bf                	jne    80106430 <uartinit+0x90>
}
80106471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106474:	5b                   	pop    %ebx
80106475:	5e                   	pop    %esi
80106476:	5f                   	pop    %edi
80106477:	5d                   	pop    %ebp
80106478:	c3                   	ret    
80106479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106480 <uartputc>:
  if(!uart)
80106480:	a1 c0 a5 11 80       	mov    0x8011a5c0,%eax
80106485:	85 c0                	test   %eax,%eax
80106487:	74 47                	je     801064d0 <uartputc+0x50>
{
80106489:	55                   	push   %ebp
8010648a:	89 e5                	mov    %esp,%ebp
8010648c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010648d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106492:	53                   	push   %ebx
80106493:	bb 80 00 00 00       	mov    $0x80,%ebx
80106498:	eb 18                	jmp    801064b2 <uartputc+0x32>
8010649a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801064a0:	83 ec 0c             	sub    $0xc,%esp
801064a3:	6a 0a                	push   $0xa
801064a5:	e8 96 c4 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064aa:	83 c4 10             	add    $0x10,%esp
801064ad:	83 eb 01             	sub    $0x1,%ebx
801064b0:	74 07                	je     801064b9 <uartputc+0x39>
801064b2:	89 f2                	mov    %esi,%edx
801064b4:	ec                   	in     (%dx),%al
801064b5:	a8 20                	test   $0x20,%al
801064b7:	74 e7                	je     801064a0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064b9:	8b 45 08             	mov    0x8(%ebp),%eax
801064bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064c1:	ee                   	out    %al,(%dx)
}
801064c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064c5:	5b                   	pop    %ebx
801064c6:	5e                   	pop    %esi
801064c7:	5d                   	pop    %ebp
801064c8:	c3                   	ret    
801064c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064d0:	c3                   	ret    
801064d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064df:	90                   	nop

801064e0 <uartintr>:

void
uartintr(void)
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801064e6:	68 70 63 10 80       	push   $0x80106370
801064eb:	e8 90 a3 ff ff       	call   80100880 <consoleintr>
}
801064f0:	83 c4 10             	add    $0x10,%esp
801064f3:	c9                   	leave  
801064f4:	c3                   	ret    

801064f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $0
801064f7:	6a 00                	push   $0x0
  jmp alltraps
801064f9:	e9 82 f9 ff ff       	jmp    80105e80 <alltraps>

801064fe <vector1>:
.globl vector1
vector1:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $1
80106500:	6a 01                	push   $0x1
  jmp alltraps
80106502:	e9 79 f9 ff ff       	jmp    80105e80 <alltraps>

80106507 <vector2>:
.globl vector2
vector2:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $2
80106509:	6a 02                	push   $0x2
  jmp alltraps
8010650b:	e9 70 f9 ff ff       	jmp    80105e80 <alltraps>

80106510 <vector3>:
.globl vector3
vector3:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $3
80106512:	6a 03                	push   $0x3
  jmp alltraps
80106514:	e9 67 f9 ff ff       	jmp    80105e80 <alltraps>

80106519 <vector4>:
.globl vector4
vector4:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $4
8010651b:	6a 04                	push   $0x4
  jmp alltraps
8010651d:	e9 5e f9 ff ff       	jmp    80105e80 <alltraps>

80106522 <vector5>:
.globl vector5
vector5:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $5
80106524:	6a 05                	push   $0x5
  jmp alltraps
80106526:	e9 55 f9 ff ff       	jmp    80105e80 <alltraps>

8010652b <vector6>:
.globl vector6
vector6:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $6
8010652d:	6a 06                	push   $0x6
  jmp alltraps
8010652f:	e9 4c f9 ff ff       	jmp    80105e80 <alltraps>

80106534 <vector7>:
.globl vector7
vector7:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $7
80106536:	6a 07                	push   $0x7
  jmp alltraps
80106538:	e9 43 f9 ff ff       	jmp    80105e80 <alltraps>

8010653d <vector8>:
.globl vector8
vector8:
  pushl $8
8010653d:	6a 08                	push   $0x8
  jmp alltraps
8010653f:	e9 3c f9 ff ff       	jmp    80105e80 <alltraps>

80106544 <vector9>:
.globl vector9
vector9:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $9
80106546:	6a 09                	push   $0x9
  jmp alltraps
80106548:	e9 33 f9 ff ff       	jmp    80105e80 <alltraps>

8010654d <vector10>:
.globl vector10
vector10:
  pushl $10
8010654d:	6a 0a                	push   $0xa
  jmp alltraps
8010654f:	e9 2c f9 ff ff       	jmp    80105e80 <alltraps>

80106554 <vector11>:
.globl vector11
vector11:
  pushl $11
80106554:	6a 0b                	push   $0xb
  jmp alltraps
80106556:	e9 25 f9 ff ff       	jmp    80105e80 <alltraps>

8010655b <vector12>:
.globl vector12
vector12:
  pushl $12
8010655b:	6a 0c                	push   $0xc
  jmp alltraps
8010655d:	e9 1e f9 ff ff       	jmp    80105e80 <alltraps>

80106562 <vector13>:
.globl vector13
vector13:
  pushl $13
80106562:	6a 0d                	push   $0xd
  jmp alltraps
80106564:	e9 17 f9 ff ff       	jmp    80105e80 <alltraps>

80106569 <vector14>:
.globl vector14
vector14:
  pushl $14
80106569:	6a 0e                	push   $0xe
  jmp alltraps
8010656b:	e9 10 f9 ff ff       	jmp    80105e80 <alltraps>

80106570 <vector15>:
.globl vector15
vector15:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $15
80106572:	6a 0f                	push   $0xf
  jmp alltraps
80106574:	e9 07 f9 ff ff       	jmp    80105e80 <alltraps>

80106579 <vector16>:
.globl vector16
vector16:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $16
8010657b:	6a 10                	push   $0x10
  jmp alltraps
8010657d:	e9 fe f8 ff ff       	jmp    80105e80 <alltraps>

80106582 <vector17>:
.globl vector17
vector17:
  pushl $17
80106582:	6a 11                	push   $0x11
  jmp alltraps
80106584:	e9 f7 f8 ff ff       	jmp    80105e80 <alltraps>

80106589 <vector18>:
.globl vector18
vector18:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $18
8010658b:	6a 12                	push   $0x12
  jmp alltraps
8010658d:	e9 ee f8 ff ff       	jmp    80105e80 <alltraps>

80106592 <vector19>:
.globl vector19
vector19:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $19
80106594:	6a 13                	push   $0x13
  jmp alltraps
80106596:	e9 e5 f8 ff ff       	jmp    80105e80 <alltraps>

8010659b <vector20>:
.globl vector20
vector20:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $20
8010659d:	6a 14                	push   $0x14
  jmp alltraps
8010659f:	e9 dc f8 ff ff       	jmp    80105e80 <alltraps>

801065a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $21
801065a6:	6a 15                	push   $0x15
  jmp alltraps
801065a8:	e9 d3 f8 ff ff       	jmp    80105e80 <alltraps>

801065ad <vector22>:
.globl vector22
vector22:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $22
801065af:	6a 16                	push   $0x16
  jmp alltraps
801065b1:	e9 ca f8 ff ff       	jmp    80105e80 <alltraps>

801065b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $23
801065b8:	6a 17                	push   $0x17
  jmp alltraps
801065ba:	e9 c1 f8 ff ff       	jmp    80105e80 <alltraps>

801065bf <vector24>:
.globl vector24
vector24:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $24
801065c1:	6a 18                	push   $0x18
  jmp alltraps
801065c3:	e9 b8 f8 ff ff       	jmp    80105e80 <alltraps>

801065c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $25
801065ca:	6a 19                	push   $0x19
  jmp alltraps
801065cc:	e9 af f8 ff ff       	jmp    80105e80 <alltraps>

801065d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $26
801065d3:	6a 1a                	push   $0x1a
  jmp alltraps
801065d5:	e9 a6 f8 ff ff       	jmp    80105e80 <alltraps>

801065da <vector27>:
.globl vector27
vector27:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $27
801065dc:	6a 1b                	push   $0x1b
  jmp alltraps
801065de:	e9 9d f8 ff ff       	jmp    80105e80 <alltraps>

801065e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $28
801065e5:	6a 1c                	push   $0x1c
  jmp alltraps
801065e7:	e9 94 f8 ff ff       	jmp    80105e80 <alltraps>

801065ec <vector29>:
.globl vector29
vector29:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $29
801065ee:	6a 1d                	push   $0x1d
  jmp alltraps
801065f0:	e9 8b f8 ff ff       	jmp    80105e80 <alltraps>

801065f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $30
801065f7:	6a 1e                	push   $0x1e
  jmp alltraps
801065f9:	e9 82 f8 ff ff       	jmp    80105e80 <alltraps>

801065fe <vector31>:
.globl vector31
vector31:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $31
80106600:	6a 1f                	push   $0x1f
  jmp alltraps
80106602:	e9 79 f8 ff ff       	jmp    80105e80 <alltraps>

80106607 <vector32>:
.globl vector32
vector32:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $32
80106609:	6a 20                	push   $0x20
  jmp alltraps
8010660b:	e9 70 f8 ff ff       	jmp    80105e80 <alltraps>

80106610 <vector33>:
.globl vector33
vector33:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $33
80106612:	6a 21                	push   $0x21
  jmp alltraps
80106614:	e9 67 f8 ff ff       	jmp    80105e80 <alltraps>

80106619 <vector34>:
.globl vector34
vector34:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $34
8010661b:	6a 22                	push   $0x22
  jmp alltraps
8010661d:	e9 5e f8 ff ff       	jmp    80105e80 <alltraps>

80106622 <vector35>:
.globl vector35
vector35:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $35
80106624:	6a 23                	push   $0x23
  jmp alltraps
80106626:	e9 55 f8 ff ff       	jmp    80105e80 <alltraps>

8010662b <vector36>:
.globl vector36
vector36:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $36
8010662d:	6a 24                	push   $0x24
  jmp alltraps
8010662f:	e9 4c f8 ff ff       	jmp    80105e80 <alltraps>

80106634 <vector37>:
.globl vector37
vector37:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $37
80106636:	6a 25                	push   $0x25
  jmp alltraps
80106638:	e9 43 f8 ff ff       	jmp    80105e80 <alltraps>

8010663d <vector38>:
.globl vector38
vector38:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $38
8010663f:	6a 26                	push   $0x26
  jmp alltraps
80106641:	e9 3a f8 ff ff       	jmp    80105e80 <alltraps>

80106646 <vector39>:
.globl vector39
vector39:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $39
80106648:	6a 27                	push   $0x27
  jmp alltraps
8010664a:	e9 31 f8 ff ff       	jmp    80105e80 <alltraps>

8010664f <vector40>:
.globl vector40
vector40:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $40
80106651:	6a 28                	push   $0x28
  jmp alltraps
80106653:	e9 28 f8 ff ff       	jmp    80105e80 <alltraps>

80106658 <vector41>:
.globl vector41
vector41:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $41
8010665a:	6a 29                	push   $0x29
  jmp alltraps
8010665c:	e9 1f f8 ff ff       	jmp    80105e80 <alltraps>

80106661 <vector42>:
.globl vector42
vector42:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $42
80106663:	6a 2a                	push   $0x2a
  jmp alltraps
80106665:	e9 16 f8 ff ff       	jmp    80105e80 <alltraps>

8010666a <vector43>:
.globl vector43
vector43:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $43
8010666c:	6a 2b                	push   $0x2b
  jmp alltraps
8010666e:	e9 0d f8 ff ff       	jmp    80105e80 <alltraps>

80106673 <vector44>:
.globl vector44
vector44:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $44
80106675:	6a 2c                	push   $0x2c
  jmp alltraps
80106677:	e9 04 f8 ff ff       	jmp    80105e80 <alltraps>

8010667c <vector45>:
.globl vector45
vector45:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $45
8010667e:	6a 2d                	push   $0x2d
  jmp alltraps
80106680:	e9 fb f7 ff ff       	jmp    80105e80 <alltraps>

80106685 <vector46>:
.globl vector46
vector46:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $46
80106687:	6a 2e                	push   $0x2e
  jmp alltraps
80106689:	e9 f2 f7 ff ff       	jmp    80105e80 <alltraps>

8010668e <vector47>:
.globl vector47
vector47:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $47
80106690:	6a 2f                	push   $0x2f
  jmp alltraps
80106692:	e9 e9 f7 ff ff       	jmp    80105e80 <alltraps>

80106697 <vector48>:
.globl vector48
vector48:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $48
80106699:	6a 30                	push   $0x30
  jmp alltraps
8010669b:	e9 e0 f7 ff ff       	jmp    80105e80 <alltraps>

801066a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $49
801066a2:	6a 31                	push   $0x31
  jmp alltraps
801066a4:	e9 d7 f7 ff ff       	jmp    80105e80 <alltraps>

801066a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $50
801066ab:	6a 32                	push   $0x32
  jmp alltraps
801066ad:	e9 ce f7 ff ff       	jmp    80105e80 <alltraps>

801066b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $51
801066b4:	6a 33                	push   $0x33
  jmp alltraps
801066b6:	e9 c5 f7 ff ff       	jmp    80105e80 <alltraps>

801066bb <vector52>:
.globl vector52
vector52:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $52
801066bd:	6a 34                	push   $0x34
  jmp alltraps
801066bf:	e9 bc f7 ff ff       	jmp    80105e80 <alltraps>

801066c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $53
801066c6:	6a 35                	push   $0x35
  jmp alltraps
801066c8:	e9 b3 f7 ff ff       	jmp    80105e80 <alltraps>

801066cd <vector54>:
.globl vector54
vector54:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $54
801066cf:	6a 36                	push   $0x36
  jmp alltraps
801066d1:	e9 aa f7 ff ff       	jmp    80105e80 <alltraps>

801066d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $55
801066d8:	6a 37                	push   $0x37
  jmp alltraps
801066da:	e9 a1 f7 ff ff       	jmp    80105e80 <alltraps>

801066df <vector56>:
.globl vector56
vector56:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $56
801066e1:	6a 38                	push   $0x38
  jmp alltraps
801066e3:	e9 98 f7 ff ff       	jmp    80105e80 <alltraps>

801066e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $57
801066ea:	6a 39                	push   $0x39
  jmp alltraps
801066ec:	e9 8f f7 ff ff       	jmp    80105e80 <alltraps>

801066f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $58
801066f3:	6a 3a                	push   $0x3a
  jmp alltraps
801066f5:	e9 86 f7 ff ff       	jmp    80105e80 <alltraps>

801066fa <vector59>:
.globl vector59
vector59:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $59
801066fc:	6a 3b                	push   $0x3b
  jmp alltraps
801066fe:	e9 7d f7 ff ff       	jmp    80105e80 <alltraps>

80106703 <vector60>:
.globl vector60
vector60:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $60
80106705:	6a 3c                	push   $0x3c
  jmp alltraps
80106707:	e9 74 f7 ff ff       	jmp    80105e80 <alltraps>

8010670c <vector61>:
.globl vector61
vector61:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $61
8010670e:	6a 3d                	push   $0x3d
  jmp alltraps
80106710:	e9 6b f7 ff ff       	jmp    80105e80 <alltraps>

80106715 <vector62>:
.globl vector62
vector62:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $62
80106717:	6a 3e                	push   $0x3e
  jmp alltraps
80106719:	e9 62 f7 ff ff       	jmp    80105e80 <alltraps>

8010671e <vector63>:
.globl vector63
vector63:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $63
80106720:	6a 3f                	push   $0x3f
  jmp alltraps
80106722:	e9 59 f7 ff ff       	jmp    80105e80 <alltraps>

80106727 <vector64>:
.globl vector64
vector64:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $64
80106729:	6a 40                	push   $0x40
  jmp alltraps
8010672b:	e9 50 f7 ff ff       	jmp    80105e80 <alltraps>

80106730 <vector65>:
.globl vector65
vector65:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $65
80106732:	6a 41                	push   $0x41
  jmp alltraps
80106734:	e9 47 f7 ff ff       	jmp    80105e80 <alltraps>

80106739 <vector66>:
.globl vector66
vector66:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $66
8010673b:	6a 42                	push   $0x42
  jmp alltraps
8010673d:	e9 3e f7 ff ff       	jmp    80105e80 <alltraps>

80106742 <vector67>:
.globl vector67
vector67:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $67
80106744:	6a 43                	push   $0x43
  jmp alltraps
80106746:	e9 35 f7 ff ff       	jmp    80105e80 <alltraps>

8010674b <vector68>:
.globl vector68
vector68:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $68
8010674d:	6a 44                	push   $0x44
  jmp alltraps
8010674f:	e9 2c f7 ff ff       	jmp    80105e80 <alltraps>

80106754 <vector69>:
.globl vector69
vector69:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $69
80106756:	6a 45                	push   $0x45
  jmp alltraps
80106758:	e9 23 f7 ff ff       	jmp    80105e80 <alltraps>

8010675d <vector70>:
.globl vector70
vector70:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $70
8010675f:	6a 46                	push   $0x46
  jmp alltraps
80106761:	e9 1a f7 ff ff       	jmp    80105e80 <alltraps>

80106766 <vector71>:
.globl vector71
vector71:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $71
80106768:	6a 47                	push   $0x47
  jmp alltraps
8010676a:	e9 11 f7 ff ff       	jmp    80105e80 <alltraps>

8010676f <vector72>:
.globl vector72
vector72:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $72
80106771:	6a 48                	push   $0x48
  jmp alltraps
80106773:	e9 08 f7 ff ff       	jmp    80105e80 <alltraps>

80106778 <vector73>:
.globl vector73
vector73:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $73
8010677a:	6a 49                	push   $0x49
  jmp alltraps
8010677c:	e9 ff f6 ff ff       	jmp    80105e80 <alltraps>

80106781 <vector74>:
.globl vector74
vector74:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $74
80106783:	6a 4a                	push   $0x4a
  jmp alltraps
80106785:	e9 f6 f6 ff ff       	jmp    80105e80 <alltraps>

8010678a <vector75>:
.globl vector75
vector75:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $75
8010678c:	6a 4b                	push   $0x4b
  jmp alltraps
8010678e:	e9 ed f6 ff ff       	jmp    80105e80 <alltraps>

80106793 <vector76>:
.globl vector76
vector76:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $76
80106795:	6a 4c                	push   $0x4c
  jmp alltraps
80106797:	e9 e4 f6 ff ff       	jmp    80105e80 <alltraps>

8010679c <vector77>:
.globl vector77
vector77:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $77
8010679e:	6a 4d                	push   $0x4d
  jmp alltraps
801067a0:	e9 db f6 ff ff       	jmp    80105e80 <alltraps>

801067a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $78
801067a7:	6a 4e                	push   $0x4e
  jmp alltraps
801067a9:	e9 d2 f6 ff ff       	jmp    80105e80 <alltraps>

801067ae <vector79>:
.globl vector79
vector79:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $79
801067b0:	6a 4f                	push   $0x4f
  jmp alltraps
801067b2:	e9 c9 f6 ff ff       	jmp    80105e80 <alltraps>

801067b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $80
801067b9:	6a 50                	push   $0x50
  jmp alltraps
801067bb:	e9 c0 f6 ff ff       	jmp    80105e80 <alltraps>

801067c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $81
801067c2:	6a 51                	push   $0x51
  jmp alltraps
801067c4:	e9 b7 f6 ff ff       	jmp    80105e80 <alltraps>

801067c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $82
801067cb:	6a 52                	push   $0x52
  jmp alltraps
801067cd:	e9 ae f6 ff ff       	jmp    80105e80 <alltraps>

801067d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $83
801067d4:	6a 53                	push   $0x53
  jmp alltraps
801067d6:	e9 a5 f6 ff ff       	jmp    80105e80 <alltraps>

801067db <vector84>:
.globl vector84
vector84:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $84
801067dd:	6a 54                	push   $0x54
  jmp alltraps
801067df:	e9 9c f6 ff ff       	jmp    80105e80 <alltraps>

801067e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $85
801067e6:	6a 55                	push   $0x55
  jmp alltraps
801067e8:	e9 93 f6 ff ff       	jmp    80105e80 <alltraps>

801067ed <vector86>:
.globl vector86
vector86:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $86
801067ef:	6a 56                	push   $0x56
  jmp alltraps
801067f1:	e9 8a f6 ff ff       	jmp    80105e80 <alltraps>

801067f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $87
801067f8:	6a 57                	push   $0x57
  jmp alltraps
801067fa:	e9 81 f6 ff ff       	jmp    80105e80 <alltraps>

801067ff <vector88>:
.globl vector88
vector88:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $88
80106801:	6a 58                	push   $0x58
  jmp alltraps
80106803:	e9 78 f6 ff ff       	jmp    80105e80 <alltraps>

80106808 <vector89>:
.globl vector89
vector89:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $89
8010680a:	6a 59                	push   $0x59
  jmp alltraps
8010680c:	e9 6f f6 ff ff       	jmp    80105e80 <alltraps>

80106811 <vector90>:
.globl vector90
vector90:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $90
80106813:	6a 5a                	push   $0x5a
  jmp alltraps
80106815:	e9 66 f6 ff ff       	jmp    80105e80 <alltraps>

8010681a <vector91>:
.globl vector91
vector91:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $91
8010681c:	6a 5b                	push   $0x5b
  jmp alltraps
8010681e:	e9 5d f6 ff ff       	jmp    80105e80 <alltraps>

80106823 <vector92>:
.globl vector92
vector92:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $92
80106825:	6a 5c                	push   $0x5c
  jmp alltraps
80106827:	e9 54 f6 ff ff       	jmp    80105e80 <alltraps>

8010682c <vector93>:
.globl vector93
vector93:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $93
8010682e:	6a 5d                	push   $0x5d
  jmp alltraps
80106830:	e9 4b f6 ff ff       	jmp    80105e80 <alltraps>

80106835 <vector94>:
.globl vector94
vector94:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $94
80106837:	6a 5e                	push   $0x5e
  jmp alltraps
80106839:	e9 42 f6 ff ff       	jmp    80105e80 <alltraps>

8010683e <vector95>:
.globl vector95
vector95:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $95
80106840:	6a 5f                	push   $0x5f
  jmp alltraps
80106842:	e9 39 f6 ff ff       	jmp    80105e80 <alltraps>

80106847 <vector96>:
.globl vector96
vector96:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $96
80106849:	6a 60                	push   $0x60
  jmp alltraps
8010684b:	e9 30 f6 ff ff       	jmp    80105e80 <alltraps>

80106850 <vector97>:
.globl vector97
vector97:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $97
80106852:	6a 61                	push   $0x61
  jmp alltraps
80106854:	e9 27 f6 ff ff       	jmp    80105e80 <alltraps>

80106859 <vector98>:
.globl vector98
vector98:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $98
8010685b:	6a 62                	push   $0x62
  jmp alltraps
8010685d:	e9 1e f6 ff ff       	jmp    80105e80 <alltraps>

80106862 <vector99>:
.globl vector99
vector99:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $99
80106864:	6a 63                	push   $0x63
  jmp alltraps
80106866:	e9 15 f6 ff ff       	jmp    80105e80 <alltraps>

8010686b <vector100>:
.globl vector100
vector100:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $100
8010686d:	6a 64                	push   $0x64
  jmp alltraps
8010686f:	e9 0c f6 ff ff       	jmp    80105e80 <alltraps>

80106874 <vector101>:
.globl vector101
vector101:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $101
80106876:	6a 65                	push   $0x65
  jmp alltraps
80106878:	e9 03 f6 ff ff       	jmp    80105e80 <alltraps>

8010687d <vector102>:
.globl vector102
vector102:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $102
8010687f:	6a 66                	push   $0x66
  jmp alltraps
80106881:	e9 fa f5 ff ff       	jmp    80105e80 <alltraps>

80106886 <vector103>:
.globl vector103
vector103:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $103
80106888:	6a 67                	push   $0x67
  jmp alltraps
8010688a:	e9 f1 f5 ff ff       	jmp    80105e80 <alltraps>

8010688f <vector104>:
.globl vector104
vector104:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $104
80106891:	6a 68                	push   $0x68
  jmp alltraps
80106893:	e9 e8 f5 ff ff       	jmp    80105e80 <alltraps>

80106898 <vector105>:
.globl vector105
vector105:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $105
8010689a:	6a 69                	push   $0x69
  jmp alltraps
8010689c:	e9 df f5 ff ff       	jmp    80105e80 <alltraps>

801068a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $106
801068a3:	6a 6a                	push   $0x6a
  jmp alltraps
801068a5:	e9 d6 f5 ff ff       	jmp    80105e80 <alltraps>

801068aa <vector107>:
.globl vector107
vector107:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $107
801068ac:	6a 6b                	push   $0x6b
  jmp alltraps
801068ae:	e9 cd f5 ff ff       	jmp    80105e80 <alltraps>

801068b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $108
801068b5:	6a 6c                	push   $0x6c
  jmp alltraps
801068b7:	e9 c4 f5 ff ff       	jmp    80105e80 <alltraps>

801068bc <vector109>:
.globl vector109
vector109:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $109
801068be:	6a 6d                	push   $0x6d
  jmp alltraps
801068c0:	e9 bb f5 ff ff       	jmp    80105e80 <alltraps>

801068c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $110
801068c7:	6a 6e                	push   $0x6e
  jmp alltraps
801068c9:	e9 b2 f5 ff ff       	jmp    80105e80 <alltraps>

801068ce <vector111>:
.globl vector111
vector111:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $111
801068d0:	6a 6f                	push   $0x6f
  jmp alltraps
801068d2:	e9 a9 f5 ff ff       	jmp    80105e80 <alltraps>

801068d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $112
801068d9:	6a 70                	push   $0x70
  jmp alltraps
801068db:	e9 a0 f5 ff ff       	jmp    80105e80 <alltraps>

801068e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $113
801068e2:	6a 71                	push   $0x71
  jmp alltraps
801068e4:	e9 97 f5 ff ff       	jmp    80105e80 <alltraps>

801068e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $114
801068eb:	6a 72                	push   $0x72
  jmp alltraps
801068ed:	e9 8e f5 ff ff       	jmp    80105e80 <alltraps>

801068f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $115
801068f4:	6a 73                	push   $0x73
  jmp alltraps
801068f6:	e9 85 f5 ff ff       	jmp    80105e80 <alltraps>

801068fb <vector116>:
.globl vector116
vector116:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $116
801068fd:	6a 74                	push   $0x74
  jmp alltraps
801068ff:	e9 7c f5 ff ff       	jmp    80105e80 <alltraps>

80106904 <vector117>:
.globl vector117
vector117:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $117
80106906:	6a 75                	push   $0x75
  jmp alltraps
80106908:	e9 73 f5 ff ff       	jmp    80105e80 <alltraps>

8010690d <vector118>:
.globl vector118
vector118:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $118
8010690f:	6a 76                	push   $0x76
  jmp alltraps
80106911:	e9 6a f5 ff ff       	jmp    80105e80 <alltraps>

80106916 <vector119>:
.globl vector119
vector119:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $119
80106918:	6a 77                	push   $0x77
  jmp alltraps
8010691a:	e9 61 f5 ff ff       	jmp    80105e80 <alltraps>

8010691f <vector120>:
.globl vector120
vector120:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $120
80106921:	6a 78                	push   $0x78
  jmp alltraps
80106923:	e9 58 f5 ff ff       	jmp    80105e80 <alltraps>

80106928 <vector121>:
.globl vector121
vector121:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $121
8010692a:	6a 79                	push   $0x79
  jmp alltraps
8010692c:	e9 4f f5 ff ff       	jmp    80105e80 <alltraps>

80106931 <vector122>:
.globl vector122
vector122:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $122
80106933:	6a 7a                	push   $0x7a
  jmp alltraps
80106935:	e9 46 f5 ff ff       	jmp    80105e80 <alltraps>

8010693a <vector123>:
.globl vector123
vector123:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $123
8010693c:	6a 7b                	push   $0x7b
  jmp alltraps
8010693e:	e9 3d f5 ff ff       	jmp    80105e80 <alltraps>

80106943 <vector124>:
.globl vector124
vector124:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $124
80106945:	6a 7c                	push   $0x7c
  jmp alltraps
80106947:	e9 34 f5 ff ff       	jmp    80105e80 <alltraps>

8010694c <vector125>:
.globl vector125
vector125:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $125
8010694e:	6a 7d                	push   $0x7d
  jmp alltraps
80106950:	e9 2b f5 ff ff       	jmp    80105e80 <alltraps>

80106955 <vector126>:
.globl vector126
vector126:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $126
80106957:	6a 7e                	push   $0x7e
  jmp alltraps
80106959:	e9 22 f5 ff ff       	jmp    80105e80 <alltraps>

8010695e <vector127>:
.globl vector127
vector127:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $127
80106960:	6a 7f                	push   $0x7f
  jmp alltraps
80106962:	e9 19 f5 ff ff       	jmp    80105e80 <alltraps>

80106967 <vector128>:
.globl vector128
vector128:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $128
80106969:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010696e:	e9 0d f5 ff ff       	jmp    80105e80 <alltraps>

80106973 <vector129>:
.globl vector129
vector129:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $129
80106975:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010697a:	e9 01 f5 ff ff       	jmp    80105e80 <alltraps>

8010697f <vector130>:
.globl vector130
vector130:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $130
80106981:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106986:	e9 f5 f4 ff ff       	jmp    80105e80 <alltraps>

8010698b <vector131>:
.globl vector131
vector131:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $131
8010698d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106992:	e9 e9 f4 ff ff       	jmp    80105e80 <alltraps>

80106997 <vector132>:
.globl vector132
vector132:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $132
80106999:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010699e:	e9 dd f4 ff ff       	jmp    80105e80 <alltraps>

801069a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $133
801069a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801069aa:	e9 d1 f4 ff ff       	jmp    80105e80 <alltraps>

801069af <vector134>:
.globl vector134
vector134:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $134
801069b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801069b6:	e9 c5 f4 ff ff       	jmp    80105e80 <alltraps>

801069bb <vector135>:
.globl vector135
vector135:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $135
801069bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801069c2:	e9 b9 f4 ff ff       	jmp    80105e80 <alltraps>

801069c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $136
801069c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801069ce:	e9 ad f4 ff ff       	jmp    80105e80 <alltraps>

801069d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $137
801069d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801069da:	e9 a1 f4 ff ff       	jmp    80105e80 <alltraps>

801069df <vector138>:
.globl vector138
vector138:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $138
801069e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801069e6:	e9 95 f4 ff ff       	jmp    80105e80 <alltraps>

801069eb <vector139>:
.globl vector139
vector139:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $139
801069ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801069f2:	e9 89 f4 ff ff       	jmp    80105e80 <alltraps>

801069f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $140
801069f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801069fe:	e9 7d f4 ff ff       	jmp    80105e80 <alltraps>

80106a03 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $141
80106a05:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a0a:	e9 71 f4 ff ff       	jmp    80105e80 <alltraps>

80106a0f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $142
80106a11:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a16:	e9 65 f4 ff ff       	jmp    80105e80 <alltraps>

80106a1b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $143
80106a1d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a22:	e9 59 f4 ff ff       	jmp    80105e80 <alltraps>

80106a27 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $144
80106a29:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a2e:	e9 4d f4 ff ff       	jmp    80105e80 <alltraps>

80106a33 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $145
80106a35:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a3a:	e9 41 f4 ff ff       	jmp    80105e80 <alltraps>

80106a3f <vector146>:
.globl vector146
vector146:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $146
80106a41:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a46:	e9 35 f4 ff ff       	jmp    80105e80 <alltraps>

80106a4b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $147
80106a4d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a52:	e9 29 f4 ff ff       	jmp    80105e80 <alltraps>

80106a57 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $148
80106a59:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a5e:	e9 1d f4 ff ff       	jmp    80105e80 <alltraps>

80106a63 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $149
80106a65:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a6a:	e9 11 f4 ff ff       	jmp    80105e80 <alltraps>

80106a6f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $150
80106a71:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a76:	e9 05 f4 ff ff       	jmp    80105e80 <alltraps>

80106a7b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $151
80106a7d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a82:	e9 f9 f3 ff ff       	jmp    80105e80 <alltraps>

80106a87 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $152
80106a89:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a8e:	e9 ed f3 ff ff       	jmp    80105e80 <alltraps>

80106a93 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $153
80106a95:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a9a:	e9 e1 f3 ff ff       	jmp    80105e80 <alltraps>

80106a9f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $154
80106aa1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106aa6:	e9 d5 f3 ff ff       	jmp    80105e80 <alltraps>

80106aab <vector155>:
.globl vector155
vector155:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $155
80106aad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ab2:	e9 c9 f3 ff ff       	jmp    80105e80 <alltraps>

80106ab7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $156
80106ab9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106abe:	e9 bd f3 ff ff       	jmp    80105e80 <alltraps>

80106ac3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $157
80106ac5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106aca:	e9 b1 f3 ff ff       	jmp    80105e80 <alltraps>

80106acf <vector158>:
.globl vector158
vector158:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $158
80106ad1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ad6:	e9 a5 f3 ff ff       	jmp    80105e80 <alltraps>

80106adb <vector159>:
.globl vector159
vector159:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $159
80106add:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ae2:	e9 99 f3 ff ff       	jmp    80105e80 <alltraps>

80106ae7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $160
80106ae9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106aee:	e9 8d f3 ff ff       	jmp    80105e80 <alltraps>

80106af3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $161
80106af5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106afa:	e9 81 f3 ff ff       	jmp    80105e80 <alltraps>

80106aff <vector162>:
.globl vector162
vector162:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $162
80106b01:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b06:	e9 75 f3 ff ff       	jmp    80105e80 <alltraps>

80106b0b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $163
80106b0d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b12:	e9 69 f3 ff ff       	jmp    80105e80 <alltraps>

80106b17 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $164
80106b19:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b1e:	e9 5d f3 ff ff       	jmp    80105e80 <alltraps>

80106b23 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $165
80106b25:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b2a:	e9 51 f3 ff ff       	jmp    80105e80 <alltraps>

80106b2f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $166
80106b31:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b36:	e9 45 f3 ff ff       	jmp    80105e80 <alltraps>

80106b3b <vector167>:
.globl vector167
vector167:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $167
80106b3d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b42:	e9 39 f3 ff ff       	jmp    80105e80 <alltraps>

80106b47 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $168
80106b49:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b4e:	e9 2d f3 ff ff       	jmp    80105e80 <alltraps>

80106b53 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $169
80106b55:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b5a:	e9 21 f3 ff ff       	jmp    80105e80 <alltraps>

80106b5f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $170
80106b61:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b66:	e9 15 f3 ff ff       	jmp    80105e80 <alltraps>

80106b6b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $171
80106b6d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b72:	e9 09 f3 ff ff       	jmp    80105e80 <alltraps>

80106b77 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $172
80106b79:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b7e:	e9 fd f2 ff ff       	jmp    80105e80 <alltraps>

80106b83 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $173
80106b85:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b8a:	e9 f1 f2 ff ff       	jmp    80105e80 <alltraps>

80106b8f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $174
80106b91:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b96:	e9 e5 f2 ff ff       	jmp    80105e80 <alltraps>

80106b9b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $175
80106b9d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ba2:	e9 d9 f2 ff ff       	jmp    80105e80 <alltraps>

80106ba7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $176
80106ba9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106bae:	e9 cd f2 ff ff       	jmp    80105e80 <alltraps>

80106bb3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $177
80106bb5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106bba:	e9 c1 f2 ff ff       	jmp    80105e80 <alltraps>

80106bbf <vector178>:
.globl vector178
vector178:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $178
80106bc1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106bc6:	e9 b5 f2 ff ff       	jmp    80105e80 <alltraps>

80106bcb <vector179>:
.globl vector179
vector179:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $179
80106bcd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106bd2:	e9 a9 f2 ff ff       	jmp    80105e80 <alltraps>

80106bd7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $180
80106bd9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106bde:	e9 9d f2 ff ff       	jmp    80105e80 <alltraps>

80106be3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $181
80106be5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106bea:	e9 91 f2 ff ff       	jmp    80105e80 <alltraps>

80106bef <vector182>:
.globl vector182
vector182:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $182
80106bf1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106bf6:	e9 85 f2 ff ff       	jmp    80105e80 <alltraps>

80106bfb <vector183>:
.globl vector183
vector183:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $183
80106bfd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c02:	e9 79 f2 ff ff       	jmp    80105e80 <alltraps>

80106c07 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $184
80106c09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c0e:	e9 6d f2 ff ff       	jmp    80105e80 <alltraps>

80106c13 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $185
80106c15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c1a:	e9 61 f2 ff ff       	jmp    80105e80 <alltraps>

80106c1f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $186
80106c21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c26:	e9 55 f2 ff ff       	jmp    80105e80 <alltraps>

80106c2b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $187
80106c2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c32:	e9 49 f2 ff ff       	jmp    80105e80 <alltraps>

80106c37 <vector188>:
.globl vector188
vector188:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $188
80106c39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c3e:	e9 3d f2 ff ff       	jmp    80105e80 <alltraps>

80106c43 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $189
80106c45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c4a:	e9 31 f2 ff ff       	jmp    80105e80 <alltraps>

80106c4f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $190
80106c51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c56:	e9 25 f2 ff ff       	jmp    80105e80 <alltraps>

80106c5b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $191
80106c5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c62:	e9 19 f2 ff ff       	jmp    80105e80 <alltraps>

80106c67 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $192
80106c69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c6e:	e9 0d f2 ff ff       	jmp    80105e80 <alltraps>

80106c73 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $193
80106c75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c7a:	e9 01 f2 ff ff       	jmp    80105e80 <alltraps>

80106c7f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $194
80106c81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c86:	e9 f5 f1 ff ff       	jmp    80105e80 <alltraps>

80106c8b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $195
80106c8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c92:	e9 e9 f1 ff ff       	jmp    80105e80 <alltraps>

80106c97 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $196
80106c99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c9e:	e9 dd f1 ff ff       	jmp    80105e80 <alltraps>

80106ca3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $197
80106ca5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106caa:	e9 d1 f1 ff ff       	jmp    80105e80 <alltraps>

80106caf <vector198>:
.globl vector198
vector198:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $198
80106cb1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106cb6:	e9 c5 f1 ff ff       	jmp    80105e80 <alltraps>

80106cbb <vector199>:
.globl vector199
vector199:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $199
80106cbd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106cc2:	e9 b9 f1 ff ff       	jmp    80105e80 <alltraps>

80106cc7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $200
80106cc9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106cce:	e9 ad f1 ff ff       	jmp    80105e80 <alltraps>

80106cd3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $201
80106cd5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106cda:	e9 a1 f1 ff ff       	jmp    80105e80 <alltraps>

80106cdf <vector202>:
.globl vector202
vector202:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $202
80106ce1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ce6:	e9 95 f1 ff ff       	jmp    80105e80 <alltraps>

80106ceb <vector203>:
.globl vector203
vector203:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $203
80106ced:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106cf2:	e9 89 f1 ff ff       	jmp    80105e80 <alltraps>

80106cf7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $204
80106cf9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106cfe:	e9 7d f1 ff ff       	jmp    80105e80 <alltraps>

80106d03 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $205
80106d05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d0a:	e9 71 f1 ff ff       	jmp    80105e80 <alltraps>

80106d0f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $206
80106d11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d16:	e9 65 f1 ff ff       	jmp    80105e80 <alltraps>

80106d1b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $207
80106d1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d22:	e9 59 f1 ff ff       	jmp    80105e80 <alltraps>

80106d27 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $208
80106d29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d2e:	e9 4d f1 ff ff       	jmp    80105e80 <alltraps>

80106d33 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $209
80106d35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d3a:	e9 41 f1 ff ff       	jmp    80105e80 <alltraps>

80106d3f <vector210>:
.globl vector210
vector210:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $210
80106d41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d46:	e9 35 f1 ff ff       	jmp    80105e80 <alltraps>

80106d4b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $211
80106d4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d52:	e9 29 f1 ff ff       	jmp    80105e80 <alltraps>

80106d57 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $212
80106d59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d5e:	e9 1d f1 ff ff       	jmp    80105e80 <alltraps>

80106d63 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $213
80106d65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d6a:	e9 11 f1 ff ff       	jmp    80105e80 <alltraps>

80106d6f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $214
80106d71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d76:	e9 05 f1 ff ff       	jmp    80105e80 <alltraps>

80106d7b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $215
80106d7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d82:	e9 f9 f0 ff ff       	jmp    80105e80 <alltraps>

80106d87 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $216
80106d89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d8e:	e9 ed f0 ff ff       	jmp    80105e80 <alltraps>

80106d93 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $217
80106d95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d9a:	e9 e1 f0 ff ff       	jmp    80105e80 <alltraps>

80106d9f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $218
80106da1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106da6:	e9 d5 f0 ff ff       	jmp    80105e80 <alltraps>

80106dab <vector219>:
.globl vector219
vector219:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $219
80106dad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106db2:	e9 c9 f0 ff ff       	jmp    80105e80 <alltraps>

80106db7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $220
80106db9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106dbe:	e9 bd f0 ff ff       	jmp    80105e80 <alltraps>

80106dc3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $221
80106dc5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106dca:	e9 b1 f0 ff ff       	jmp    80105e80 <alltraps>

80106dcf <vector222>:
.globl vector222
vector222:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $222
80106dd1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106dd6:	e9 a5 f0 ff ff       	jmp    80105e80 <alltraps>

80106ddb <vector223>:
.globl vector223
vector223:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $223
80106ddd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106de2:	e9 99 f0 ff ff       	jmp    80105e80 <alltraps>

80106de7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $224
80106de9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106dee:	e9 8d f0 ff ff       	jmp    80105e80 <alltraps>

80106df3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $225
80106df5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106dfa:	e9 81 f0 ff ff       	jmp    80105e80 <alltraps>

80106dff <vector226>:
.globl vector226
vector226:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $226
80106e01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e06:	e9 75 f0 ff ff       	jmp    80105e80 <alltraps>

80106e0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $227
80106e0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e12:	e9 69 f0 ff ff       	jmp    80105e80 <alltraps>

80106e17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $228
80106e19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e1e:	e9 5d f0 ff ff       	jmp    80105e80 <alltraps>

80106e23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $229
80106e25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e2a:	e9 51 f0 ff ff       	jmp    80105e80 <alltraps>

80106e2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $230
80106e31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e36:	e9 45 f0 ff ff       	jmp    80105e80 <alltraps>

80106e3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $231
80106e3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e42:	e9 39 f0 ff ff       	jmp    80105e80 <alltraps>

80106e47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $232
80106e49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e4e:	e9 2d f0 ff ff       	jmp    80105e80 <alltraps>

80106e53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $233
80106e55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e5a:	e9 21 f0 ff ff       	jmp    80105e80 <alltraps>

80106e5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $234
80106e61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e66:	e9 15 f0 ff ff       	jmp    80105e80 <alltraps>

80106e6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $235
80106e6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e72:	e9 09 f0 ff ff       	jmp    80105e80 <alltraps>

80106e77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $236
80106e79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e7e:	e9 fd ef ff ff       	jmp    80105e80 <alltraps>

80106e83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $237
80106e85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e8a:	e9 f1 ef ff ff       	jmp    80105e80 <alltraps>

80106e8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $238
80106e91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e96:	e9 e5 ef ff ff       	jmp    80105e80 <alltraps>

80106e9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $239
80106e9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ea2:	e9 d9 ef ff ff       	jmp    80105e80 <alltraps>

80106ea7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $240
80106ea9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106eae:	e9 cd ef ff ff       	jmp    80105e80 <alltraps>

80106eb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $241
80106eb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106eba:	e9 c1 ef ff ff       	jmp    80105e80 <alltraps>

80106ebf <vector242>:
.globl vector242
vector242:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $242
80106ec1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ec6:	e9 b5 ef ff ff       	jmp    80105e80 <alltraps>

80106ecb <vector243>:
.globl vector243
vector243:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $243
80106ecd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ed2:	e9 a9 ef ff ff       	jmp    80105e80 <alltraps>

80106ed7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $244
80106ed9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ede:	e9 9d ef ff ff       	jmp    80105e80 <alltraps>

80106ee3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $245
80106ee5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106eea:	e9 91 ef ff ff       	jmp    80105e80 <alltraps>

80106eef <vector246>:
.globl vector246
vector246:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $246
80106ef1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ef6:	e9 85 ef ff ff       	jmp    80105e80 <alltraps>

80106efb <vector247>:
.globl vector247
vector247:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $247
80106efd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f02:	e9 79 ef ff ff       	jmp    80105e80 <alltraps>

80106f07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $248
80106f09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f0e:	e9 6d ef ff ff       	jmp    80105e80 <alltraps>

80106f13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $249
80106f15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f1a:	e9 61 ef ff ff       	jmp    80105e80 <alltraps>

80106f1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $250
80106f21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f26:	e9 55 ef ff ff       	jmp    80105e80 <alltraps>

80106f2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $251
80106f2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f32:	e9 49 ef ff ff       	jmp    80105e80 <alltraps>

80106f37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $252
80106f39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f3e:	e9 3d ef ff ff       	jmp    80105e80 <alltraps>

80106f43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $253
80106f45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f4a:	e9 31 ef ff ff       	jmp    80105e80 <alltraps>

80106f4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $254
80106f51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f56:	e9 25 ef ff ff       	jmp    80105e80 <alltraps>

80106f5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $255
80106f5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f62:	e9 19 ef ff ff       	jmp    80105e80 <alltraps>
80106f67:	66 90                	xchg   %ax,%ax
80106f69:	66 90                	xchg   %ax,%ax
80106f6b:	66 90                	xchg   %ax,%ax
80106f6d:	66 90                	xchg   %ax,%ax
80106f6f:	90                   	nop

80106f70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106f7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f82:	83 ec 1c             	sub    $0x1c,%esp
80106f85:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f88:	39 d3                	cmp    %edx,%ebx
80106f8a:	73 49                	jae    80106fd5 <deallocuvm.part.0+0x65>
80106f8c:	89 c7                	mov    %eax,%edi
80106f8e:	eb 0c                	jmp    80106f9c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f90:	83 c0 01             	add    $0x1,%eax
80106f93:	c1 e0 16             	shl    $0x16,%eax
80106f96:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f98:	39 da                	cmp    %ebx,%edx
80106f9a:	76 39                	jbe    80106fd5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106f9c:	89 d8                	mov    %ebx,%eax
80106f9e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106fa1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106fa4:	f6 c1 01             	test   $0x1,%cl
80106fa7:	74 e7                	je     80106f90 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106fa9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106fb1:	c1 ee 0a             	shr    $0xa,%esi
80106fb4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106fba:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106fc1:	85 f6                	test   %esi,%esi
80106fc3:	74 cb                	je     80106f90 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106fc5:	8b 06                	mov    (%esi),%eax
80106fc7:	a8 01                	test   $0x1,%al
80106fc9:	75 15                	jne    80106fe0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106fcb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fd1:	39 da                	cmp    %ebx,%edx
80106fd3:	77 c7                	ja     80106f9c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fdb:	5b                   	pop    %ebx
80106fdc:	5e                   	pop    %esi
80106fdd:	5f                   	pop    %edi
80106fde:	5d                   	pop    %ebp
80106fdf:	c3                   	ret    
      if(pa == 0)
80106fe0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fe5:	74 25                	je     8010700c <deallocuvm.part.0+0x9c>
      kfree(v);
80106fe7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fea:	05 00 00 00 80       	add    $0x80000000,%eax
80106fef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ff2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106ff8:	50                   	push   %eax
80106ff9:	e8 d2 b4 ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106ffe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107004:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107007:	83 c4 10             	add    $0x10,%esp
8010700a:	eb 8c                	jmp    80106f98 <deallocuvm.part.0+0x28>
        panic("kfree");
8010700c:	83 ec 0c             	sub    $0xc,%esp
8010700f:	68 c6 7c 10 80       	push   $0x80107cc6
80107014:	e8 67 93 ff ff       	call   80100380 <panic>
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107020 <seginit>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107026:	e8 85 c9 ff ff       	call   801039b0 <cpuid>
  pd[0] = size-1;
8010702b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107030:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107036:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010703a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107041:	ff 00 00 
80107044:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010704b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010704e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107055:	ff 00 00 
80107058:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010705f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107062:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107069:	ff 00 00 
8010706c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107073:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107076:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010707d:	ff 00 00 
80107080:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107087:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010708a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010708f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107093:	c1 e8 10             	shr    $0x10,%eax
80107096:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010709a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010709d:	0f 01 10             	lgdtl  (%eax)
}
801070a0:	c9                   	leave  
801070a1:	c3                   	ret    
801070a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070b0 <walkpgdir>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 0c             	sub    $0xc,%esp
801070b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
801070bc:	8b 55 08             	mov    0x8(%ebp),%edx
801070bf:	89 fe                	mov    %edi,%esi
801070c1:	c1 ee 16             	shr    $0x16,%esi
801070c4:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
801070c7:	8b 1e                	mov    (%esi),%ebx
801070c9:	f6 c3 01             	test   $0x1,%bl
801070cc:	74 22                	je     801070f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801070d4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
801070da:	89 f8                	mov    %edi,%eax
}
801070dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801070df:	c1 e8 0a             	shr    $0xa,%eax
801070e2:	25 fc 0f 00 00       	and    $0xffc,%eax
801070e7:	01 d8                	add    %ebx,%eax
}
801070e9:	5b                   	pop    %ebx
801070ea:	5e                   	pop    %esi
801070eb:	5f                   	pop    %edi
801070ec:	5d                   	pop    %ebp
801070ed:	c3                   	ret    
801070ee:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070f0:	8b 45 10             	mov    0x10(%ebp),%eax
801070f3:	85 c0                	test   %eax,%eax
801070f5:	74 31                	je     80107128 <walkpgdir+0x78>
801070f7:	e8 94 b5 ff ff       	call   80102690 <kalloc>
801070fc:	89 c3                	mov    %eax,%ebx
801070fe:	85 c0                	test   %eax,%eax
80107100:	74 26                	je     80107128 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80107102:	83 ec 04             	sub    $0x4,%esp
80107105:	68 00 10 00 00       	push   $0x1000
8010710a:	6a 00                	push   $0x0
8010710c:	50                   	push   %eax
8010710d:	e8 ae d5 ff ff       	call   801046c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107112:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107118:	83 c4 10             	add    $0x10,%esp
8010711b:	83 c8 07             	or     $0x7,%eax
8010711e:	89 06                	mov    %eax,(%esi)
80107120:	eb b8                	jmp    801070da <walkpgdir+0x2a>
80107122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
8010712b:	31 c0                	xor    %eax,%eax
}
8010712d:	5b                   	pop    %ebx
8010712e:	5e                   	pop    %esi
8010712f:	5f                   	pop    %edi
80107130:	5d                   	pop    %ebp
80107131:	c3                   	ret    
80107132:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107140 <mappages>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010714c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
8010714f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107151:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80107155:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
8010715a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107160:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107163:	8b 45 14             	mov    0x14(%ebp),%eax
80107166:	29 d8                	sub    %ebx,%eax
80107168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010716b:	eb 3a                	jmp    801071a7 <mappages+0x67>
8010716d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107170:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107177:	c1 ea 0a             	shr    $0xa,%edx
8010717a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107180:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107187:	85 c0                	test   %eax,%eax
80107189:	74 75                	je     80107200 <mappages+0xc0>
    if(*pte & PTE_P)
8010718b:	f6 00 01             	testb  $0x1,(%eax)
8010718e:	0f 85 86 00 00 00    	jne    8010721a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107194:	0b 75 18             	or     0x18(%ebp),%esi
80107197:	83 ce 01             	or     $0x1,%esi
8010719a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010719c:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
8010719f:	74 6f                	je     80107210 <mappages+0xd0>
    a += PGSIZE;
801071a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801071a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801071aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801071ad:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801071b0:	89 d8                	mov    %ebx,%eax
801071b2:	c1 e8 16             	shr    $0x16,%eax
801071b5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801071b8:	8b 07                	mov    (%edi),%eax
801071ba:	a8 01                	test   $0x1,%al
801071bc:	75 b2                	jne    80107170 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071be:	e8 cd b4 ff ff       	call   80102690 <kalloc>
801071c3:	85 c0                	test   %eax,%eax
801071c5:	74 39                	je     80107200 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801071c7:	83 ec 04             	sub    $0x4,%esp
801071ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071cd:	68 00 10 00 00       	push   $0x1000
801071d2:	6a 00                	push   $0x0
801071d4:	50                   	push   %eax
801071d5:	e8 e6 d4 ff ff       	call   801046c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
801071dd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071e0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801071e6:	83 c8 07             	or     $0x7,%eax
801071e9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801071eb:	89 d8                	mov    %ebx,%eax
801071ed:	c1 e8 0a             	shr    $0xa,%eax
801071f0:	25 fc 0f 00 00       	and    $0xffc,%eax
801071f5:	01 d0                	add    %edx,%eax
801071f7:	eb 92                	jmp    8010718b <mappages+0x4b>
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107200:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107208:	5b                   	pop    %ebx
80107209:	5e                   	pop    %esi
8010720a:	5f                   	pop    %edi
8010720b:	5d                   	pop    %ebp
8010720c:	c3                   	ret    
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
80107210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107213:	31 c0                	xor    %eax,%eax
}
80107215:	5b                   	pop    %ebx
80107216:	5e                   	pop    %esi
80107217:	5f                   	pop    %edi
80107218:	5d                   	pop    %ebp
80107219:	c3                   	ret    
      panic("remap");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 4c 84 10 80       	push   $0x8010844c
80107222:	e8 59 91 ff ff       	call   80100380 <panic>
80107227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722e:	66 90                	xchg   %ax,%ax

80107230 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107230:	a1 c4 a5 11 80       	mov    0x8011a5c4,%eax
80107235:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010723a:	0f 22 d8             	mov    %eax,%cr3
}
8010723d:	c3                   	ret    
8010723e:	66 90                	xchg   %ax,%ax

80107240 <switchuvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 1c             	sub    $0x1c,%esp
80107249:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010724c:	85 f6                	test   %esi,%esi
8010724e:	0f 84 cb 00 00 00    	je     8010731f <switchuvm+0xdf>
  if(p->kstack == 0)
80107254:	8b 46 08             	mov    0x8(%esi),%eax
80107257:	85 c0                	test   %eax,%eax
80107259:	0f 84 da 00 00 00    	je     80107339 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010725f:	8b 46 04             	mov    0x4(%esi),%eax
80107262:	85 c0                	test   %eax,%eax
80107264:	0f 84 c2 00 00 00    	je     8010732c <switchuvm+0xec>
  pushcli();
8010726a:	e8 41 d2 ff ff       	call   801044b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010726f:	e8 dc c6 ff ff       	call   80103950 <mycpu>
80107274:	89 c3                	mov    %eax,%ebx
80107276:	e8 d5 c6 ff ff       	call   80103950 <mycpu>
8010727b:	89 c7                	mov    %eax,%edi
8010727d:	e8 ce c6 ff ff       	call   80103950 <mycpu>
80107282:	83 c7 08             	add    $0x8,%edi
80107285:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107288:	e8 c3 c6 ff ff       	call   80103950 <mycpu>
8010728d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107290:	ba 67 00 00 00       	mov    $0x67,%edx
80107295:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010729c:	83 c0 08             	add    $0x8,%eax
8010729f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072a6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072ab:	83 c1 08             	add    $0x8,%ecx
801072ae:	c1 e8 18             	shr    $0x18,%eax
801072b1:	c1 e9 10             	shr    $0x10,%ecx
801072b4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072c5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072cc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072d1:	e8 7a c6 ff ff       	call   80103950 <mycpu>
801072d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072dd:	e8 6e c6 ff ff       	call   80103950 <mycpu>
801072e2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072e6:	8b 5e 08             	mov    0x8(%esi),%ebx
801072e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072ef:	e8 5c c6 ff ff       	call   80103950 <mycpu>
801072f4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072f7:	e8 54 c6 ff ff       	call   80103950 <mycpu>
801072fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107300:	b8 28 00 00 00       	mov    $0x28,%eax
80107305:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107308:	8b 46 04             	mov    0x4(%esi),%eax
8010730b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107310:	0f 22 d8             	mov    %eax,%cr3
}
80107313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107316:	5b                   	pop    %ebx
80107317:	5e                   	pop    %esi
80107318:	5f                   	pop    %edi
80107319:	5d                   	pop    %ebp
  popcli();
8010731a:	e9 e1 d1 ff ff       	jmp    80104500 <popcli>
    panic("switchuvm: no process");
8010731f:	83 ec 0c             	sub    $0xc,%esp
80107322:	68 52 84 10 80       	push   $0x80108452
80107327:	e8 54 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010732c:	83 ec 0c             	sub    $0xc,%esp
8010732f:	68 7d 84 10 80       	push   $0x8010847d
80107334:	e8 47 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107339:	83 ec 0c             	sub    $0xc,%esp
8010733c:	68 68 84 10 80       	push   $0x80108468
80107341:	e8 3a 90 ff ff       	call   80100380 <panic>
80107346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734d:	8d 76 00             	lea    0x0(%esi),%esi

80107350 <inituvm>:
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 1c             	sub    $0x1c,%esp
80107359:	8b 75 10             	mov    0x10(%ebp),%esi
8010735c:	8b 55 08             	mov    0x8(%ebp),%edx
8010735f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107362:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107368:	77 50                	ja     801073ba <inituvm+0x6a>
8010736a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010736d:	e8 1e b3 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80107372:	83 ec 04             	sub    $0x4,%esp
80107375:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010737a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010737c:	6a 00                	push   $0x0
8010737e:	50                   	push   %eax
8010737f:	e8 3c d3 ff ff       	call   801046c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107384:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107387:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010738d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80107394:	50                   	push   %eax
80107395:	68 00 10 00 00       	push   $0x1000
8010739a:	6a 00                	push   $0x0
8010739c:	52                   	push   %edx
8010739d:	e8 9e fd ff ff       	call   80107140 <mappages>
  memmove(mem, init, sz);
801073a2:	89 75 10             	mov    %esi,0x10(%ebp)
801073a5:	83 c4 20             	add    $0x20,%esp
801073a8:	89 7d 0c             	mov    %edi,0xc(%ebp)
801073ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801073ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073b1:	5b                   	pop    %ebx
801073b2:	5e                   	pop    %esi
801073b3:	5f                   	pop    %edi
801073b4:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073b5:	e9 a6 d3 ff ff       	jmp    80104760 <memmove>
    panic("inituvm: more than a page");
801073ba:	83 ec 0c             	sub    $0xc,%esp
801073bd:	68 91 84 10 80       	push   $0x80108491
801073c2:	e8 b9 8f ff ff       	call   80100380 <panic>
801073c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ce:	66 90                	xchg   %ax,%ax

801073d0 <loaduvm>:
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 1c             	sub    $0x1c,%esp
801073d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801073dc:	8b 5d 18             	mov    0x18(%ebp),%ebx
  if((uint) addr % PGSIZE != 0)
801073df:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073e4:	0f 85 03 01 00 00    	jne    801074ed <loaduvm+0x11d>
  for(i = 0; i < sz; i += PGSIZE){
801073ea:	01 d8                	add    %ebx,%eax
801073ec:	89 df                	mov    %ebx,%edi
801073ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(flags & PTE_W) {
801073f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
801073f4:	83 e0 02             	and    $0x2,%eax
801073f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801073fa:	85 db                	test   %ebx,%ebx
801073fc:	0f 84 b7 00 00 00    	je     801074b9 <loaduvm+0xe9>
80107402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pde = &pgdir[PDX(va)];
80107408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010740b:	8b 75 08             	mov    0x8(%ebp),%esi
8010740e:	29 f8                	sub    %edi,%eax
  pde = &pgdir[PDX(va)];
80107410:	89 c2                	mov    %eax,%edx
80107412:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107415:	8b 14 96             	mov    (%esi,%edx,4),%edx
80107418:	f6 c2 01             	test   $0x1,%dl
8010741b:	75 13                	jne    80107430 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010741d:	83 ec 0c             	sub    $0xc,%esp
80107420:	68 ab 84 10 80       	push   $0x801084ab
80107425:	e8 56 8f ff ff       	call   80100380 <panic>
8010742a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107430:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107433:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107439:	25 fc 0f 00 00       	and    $0xffc,%eax
8010743e:	8d b4 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%esi
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107445:	85 f6                	test   %esi,%esi
80107447:	74 d4                	je     8010741d <loaduvm+0x4d>
     cprintf("pte=%x\n", *pte);
80107449:	83 ec 08             	sub    $0x8,%esp
8010744c:	ff 36                	push   (%esi)
8010744e:	68 c9 84 10 80       	push   $0x801084c9
80107453:	e8 48 92 ff ff       	call   801006a0 <cprintf>
    if(*pte == 0x4244c8d)
80107458:	8b 06                	mov    (%esi),%eax
8010745a:	83 c4 10             	add    $0x10,%esp
8010745d:	3d 8d 4c 24 04       	cmp    $0x4244c8d,%eax
80107462:	74 64                	je     801074c8 <loaduvm+0xf8>
            *pte |= PTE_W;  // Set writable if the ELF flag allows writing
80107464:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107467:	89 c1                	mov    %eax,%ecx
80107469:	83 e0 fd             	and    $0xfffffffd,%eax
8010746c:	83 c9 02             	or     $0x2,%ecx
8010746f:	85 d2                	test   %edx,%edx
80107471:	0f 45 c1             	cmovne %ecx,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107474:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107477:	89 06                	mov    %eax,(%esi)
    pa = PTE_ADDR(*pte);
80107479:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010747e:	be 00 10 00 00       	mov    $0x1000,%esi
80107483:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
80107489:	0f 46 f7             	cmovbe %edi,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010748c:	01 d9                	add    %ebx,%ecx
8010748e:	05 00 00 00 80       	add    $0x80000000,%eax
80107493:	29 f9                	sub    %edi,%ecx
80107495:	56                   	push   %esi
80107496:	51                   	push   %ecx
80107497:	50                   	push   %eax
80107498:	ff 75 10             	push   0x10(%ebp)
8010749b:	e8 00 a6 ff ff       	call   80101aa0 <readi>
801074a0:	83 c4 10             	add    $0x10,%esp
801074a3:	39 f0                	cmp    %esi,%eax
801074a5:	75 39                	jne    801074e0 <loaduvm+0x110>
  for(i = 0; i < sz; i += PGSIZE){
801074a7:	81 ef 00 10 00 00    	sub    $0x1000,%edi
801074ad:	89 d8                	mov    %ebx,%eax
801074af:	29 f8                	sub    %edi,%eax
801074b1:	39 c3                	cmp    %eax,%ebx
801074b3:	0f 87 4f ff ff ff    	ja     80107408 <loaduvm+0x38>
}
801074b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074bc:	31 c0                	xor    %eax,%eax
}
801074be:	5b                   	pop    %ebx
801074bf:	5e                   	pop    %esi
801074c0:	5f                   	pop    %edi
801074c1:	5d                   	pop    %ebp
801074c2:	c3                   	ret    
801074c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074c7:	90                   	nop
      cprintf("GOTCHA!\n");
801074c8:	83 ec 0c             	sub    $0xc,%esp
801074cb:	68 d1 84 10 80       	push   $0x801084d1
801074d0:	e8 cb 91 ff ff       	call   801006a0 <cprintf>
            *pte |= PTE_W;  // Set writable if the ELF flag allows writing
801074d5:	8b 06                	mov    (%esi),%eax
801074d7:	83 c4 10             	add    $0x10,%esp
801074da:	eb 88                	jmp    80107464 <loaduvm+0x94>
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801074e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074e8:	5b                   	pop    %ebx
801074e9:	5e                   	pop    %esi
801074ea:	5f                   	pop    %edi
801074eb:	5d                   	pop    %ebp
801074ec:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801074ed:	83 ec 0c             	sub    $0xc,%esp
801074f0:	68 60 85 10 80       	push   $0x80108560
801074f5:	e8 86 8e ff ff       	call   80100380 <panic>
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107500 <allocuvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107509:	8b 7d 10             	mov    0x10(%ebp),%edi
8010750c:	85 ff                	test   %edi,%edi
8010750e:	0f 88 bc 00 00 00    	js     801075d0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107514:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107517:	0f 82 a3 00 00 00    	jb     801075c0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010751d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107520:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107526:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010752c:	39 75 10             	cmp    %esi,0x10(%ebp)
8010752f:	0f 86 8e 00 00 00    	jbe    801075c3 <allocuvm+0xc3>
80107535:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107538:	8b 7d 08             	mov    0x8(%ebp),%edi
8010753b:	eb 43                	jmp    80107580 <allocuvm+0x80>
8010753d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107540:	83 ec 04             	sub    $0x4,%esp
80107543:	68 00 10 00 00       	push   $0x1000
80107548:	6a 00                	push   $0x0
8010754a:	50                   	push   %eax
8010754b:	e8 70 d1 ff ff       	call   801046c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107550:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107556:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010755d:	50                   	push   %eax
8010755e:	68 00 10 00 00       	push   $0x1000
80107563:	56                   	push   %esi
80107564:	57                   	push   %edi
80107565:	e8 d6 fb ff ff       	call   80107140 <mappages>
8010756a:	83 c4 20             	add    $0x20,%esp
8010756d:	85 c0                	test   %eax,%eax
8010756f:	78 6f                	js     801075e0 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80107571:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107577:	39 75 10             	cmp    %esi,0x10(%ebp)
8010757a:	0f 86 a0 00 00 00    	jbe    80107620 <allocuvm+0x120>
    mem = kalloc();
80107580:	e8 0b b1 ff ff       	call   80102690 <kalloc>
80107585:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107587:	85 c0                	test   %eax,%eax
80107589:	75 b5                	jne    80107540 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010758b:	83 ec 0c             	sub    $0xc,%esp
8010758e:	68 da 84 10 80       	push   $0x801084da
80107593:	e8 08 91 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107598:	8b 45 0c             	mov    0xc(%ebp),%eax
8010759b:	83 c4 10             	add    $0x10,%esp
8010759e:	39 45 10             	cmp    %eax,0x10(%ebp)
801075a1:	74 2d                	je     801075d0 <allocuvm+0xd0>
801075a3:	8b 55 10             	mov    0x10(%ebp),%edx
801075a6:	89 c1                	mov    %eax,%ecx
801075a8:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801075ab:	31 ff                	xor    %edi,%edi
801075ad:	e8 be f9 ff ff       	call   80106f70 <deallocuvm.part.0>
}
801075b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b5:	89 f8                	mov    %edi,%eax
801075b7:	5b                   	pop    %ebx
801075b8:	5e                   	pop    %esi
801075b9:	5f                   	pop    %edi
801075ba:	5d                   	pop    %ebp
801075bb:	c3                   	ret    
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801075c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801075c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c6:	89 f8                	mov    %edi,%eax
801075c8:	5b                   	pop    %ebx
801075c9:	5e                   	pop    %esi
801075ca:	5f                   	pop    %edi
801075cb:	5d                   	pop    %ebp
801075cc:	c3                   	ret    
801075cd:	8d 76 00             	lea    0x0(%esi),%esi
801075d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801075d3:	31 ff                	xor    %edi,%edi
}
801075d5:	5b                   	pop    %ebx
801075d6:	89 f8                	mov    %edi,%eax
801075d8:	5e                   	pop    %esi
801075d9:	5f                   	pop    %edi
801075da:	5d                   	pop    %ebp
801075db:	c3                   	ret    
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801075e0:	83 ec 0c             	sub    $0xc,%esp
801075e3:	68 f2 84 10 80       	push   $0x801084f2
801075e8:	e8 b3 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801075ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801075f0:	83 c4 10             	add    $0x10,%esp
801075f3:	39 45 10             	cmp    %eax,0x10(%ebp)
801075f6:	74 0d                	je     80107605 <allocuvm+0x105>
801075f8:	89 c1                	mov    %eax,%ecx
801075fa:	8b 55 10             	mov    0x10(%ebp),%edx
801075fd:	8b 45 08             	mov    0x8(%ebp),%eax
80107600:	e8 6b f9 ff ff       	call   80106f70 <deallocuvm.part.0>
      kfree(mem);
80107605:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107608:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010760a:	53                   	push   %ebx
8010760b:	e8 c0 ae ff ff       	call   801024d0 <kfree>
      return 0;
80107610:	83 c4 10             	add    $0x10,%esp
}
80107613:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107616:	89 f8                	mov    %edi,%eax
80107618:	5b                   	pop    %ebx
80107619:	5e                   	pop    %esi
8010761a:	5f                   	pop    %edi
8010761b:	5d                   	pop    %ebp
8010761c:	c3                   	ret    
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
80107620:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107623:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107626:	5b                   	pop    %ebx
80107627:	5e                   	pop    %esi
80107628:	89 f8                	mov    %edi,%eax
8010762a:	5f                   	pop    %edi
8010762b:	5d                   	pop    %ebp
8010762c:	c3                   	ret    
8010762d:	8d 76 00             	lea    0x0(%esi),%esi

80107630 <deallocuvm>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	8b 55 0c             	mov    0xc(%ebp),%edx
80107636:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107639:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010763c:	39 d1                	cmp    %edx,%ecx
8010763e:	73 10                	jae    80107650 <deallocuvm+0x20>
}
80107640:	5d                   	pop    %ebp
80107641:	e9 2a f9 ff ff       	jmp    80106f70 <deallocuvm.part.0>
80107646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764d:	8d 76 00             	lea    0x0(%esi),%esi
80107650:	89 d0                	mov    %edx,%eax
80107652:	5d                   	pop    %ebp
80107653:	c3                   	ret    
80107654:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010765f:	90                   	nop

80107660 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 0c             	sub    $0xc,%esp
80107669:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010766c:	85 f6                	test   %esi,%esi
8010766e:	74 59                	je     801076c9 <freevm+0x69>
  if(newsz >= oldsz)
80107670:	31 c9                	xor    %ecx,%ecx
80107672:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107677:	89 f0                	mov    %esi,%eax
80107679:	89 f3                	mov    %esi,%ebx
8010767b:	e8 f0 f8 ff ff       	call   80106f70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107680:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107686:	eb 0f                	jmp    80107697 <freevm+0x37>
80107688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768f:	90                   	nop
80107690:	83 c3 04             	add    $0x4,%ebx
80107693:	39 df                	cmp    %ebx,%edi
80107695:	74 23                	je     801076ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107697:	8b 03                	mov    (%ebx),%eax
80107699:	a8 01                	test   $0x1,%al
8010769b:	74 f3                	je     80107690 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010769d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076a2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076ad:	50                   	push   %eax
801076ae:	e8 1d ae ff ff       	call   801024d0 <kfree>
801076b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076b6:	39 df                	cmp    %ebx,%edi
801076b8:	75 dd                	jne    80107697 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c0:	5b                   	pop    %ebx
801076c1:	5e                   	pop    %esi
801076c2:	5f                   	pop    %edi
801076c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076c4:	e9 07 ae ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
801076c9:	83 ec 0c             	sub    $0xc,%esp
801076cc:	68 0e 85 10 80       	push   $0x8010850e
801076d1:	e8 aa 8c ff ff       	call   80100380 <panic>
801076d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076dd:	8d 76 00             	lea    0x0(%esi),%esi

801076e0 <setupkvm>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	56                   	push   %esi
801076e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076e5:	e8 a6 af ff ff       	call   80102690 <kalloc>
801076ea:	89 c6                	mov    %eax,%esi
801076ec:	85 c0                	test   %eax,%eax
801076ee:	74 42                	je     80107732 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801076f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076f3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076f8:	68 00 10 00 00       	push   $0x1000
801076fd:	6a 00                	push   $0x0
801076ff:	50                   	push   %eax
80107700:	e8 bb cf ff ff       	call   801046c0 <memset>
80107705:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107708:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010770b:	8b 53 08             	mov    0x8(%ebx),%edx
8010770e:	83 ec 0c             	sub    $0xc,%esp
80107711:	ff 73 0c             	push   0xc(%ebx)
80107714:	29 c2                	sub    %eax,%edx
80107716:	50                   	push   %eax
80107717:	52                   	push   %edx
80107718:	ff 33                	push   (%ebx)
8010771a:	56                   	push   %esi
8010771b:	e8 20 fa ff ff       	call   80107140 <mappages>
80107720:	83 c4 20             	add    $0x20,%esp
80107723:	85 c0                	test   %eax,%eax
80107725:	78 19                	js     80107740 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107727:	83 c3 10             	add    $0x10,%ebx
8010772a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107730:	75 d6                	jne    80107708 <setupkvm+0x28>
}
80107732:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107735:	89 f0                	mov    %esi,%eax
80107737:	5b                   	pop    %ebx
80107738:	5e                   	pop    %esi
80107739:	5d                   	pop    %ebp
8010773a:	c3                   	ret    
8010773b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010773f:	90                   	nop
      freevm(pgdir);
80107740:	83 ec 0c             	sub    $0xc,%esp
80107743:	56                   	push   %esi
      return 0;
80107744:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107746:	e8 15 ff ff ff       	call   80107660 <freevm>
      return 0;
8010774b:	83 c4 10             	add    $0x10,%esp
}
8010774e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107751:	89 f0                	mov    %esi,%eax
80107753:	5b                   	pop    %ebx
80107754:	5e                   	pop    %esi
80107755:	5d                   	pop    %ebp
80107756:	c3                   	ret    
80107757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775e:	66 90                	xchg   %ax,%ax

80107760 <kvmalloc>:
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107766:	e8 75 ff ff ff       	call   801076e0 <setupkvm>
8010776b:	a3 c4 a5 11 80       	mov    %eax,0x8011a5c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107770:	05 00 00 00 80       	add    $0x80000000,%eax
80107775:	0f 22 d8             	mov    %eax,%cr3
}
80107778:	c9                   	leave  
80107779:	c3                   	ret    
8010777a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107780 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	83 ec 08             	sub    $0x8,%esp
80107786:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107789:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010778c:	89 c1                	mov    %eax,%ecx
8010778e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107791:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107794:	f6 c2 01             	test   $0x1,%dl
80107797:	75 17                	jne    801077b0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107799:	83 ec 0c             	sub    $0xc,%esp
8010779c:	68 1f 85 10 80       	push   $0x8010851f
801077a1:	e8 da 8b ff ff       	call   80100380 <panic>
801077a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ad:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801077b0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801077b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801077be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801077c5:	85 c0                	test   %eax,%eax
801077c7:	74 d0                	je     80107799 <clearpteu+0x19>
  *pte &= ~PTE_U;
801077c9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077cc:	c9                   	leave  
801077cd:	c3                   	ret    
801077ce:	66 90                	xchg   %ax,%ax

801077d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	57                   	push   %edi
801077d4:	56                   	push   %esi
801077d5:	53                   	push   %ebx
801077d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077d9:	e8 02 ff ff ff       	call   801076e0 <setupkvm>
801077de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077e1:	85 c0                	test   %eax,%eax
801077e3:	0f 84 c0 00 00 00    	je     801078a9 <copyuvm+0xd9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ec:	85 d2                	test   %edx,%edx
801077ee:	0f 84 b5 00 00 00    	je     801078a9 <copyuvm+0xd9>
801077f4:	31 f6                	xor    %esi,%esi
801077f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107800:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107803:	89 f0                	mov    %esi,%eax
80107805:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107808:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010780b:	a8 01                	test   $0x1,%al
8010780d:	75 11                	jne    80107820 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010780f:	83 ec 0c             	sub    $0xc,%esp
80107812:	68 29 85 10 80       	push   $0x80108529
80107817:	e8 64 8b ff ff       	call   80100380 <panic>
8010781c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107820:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107822:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107827:	c1 ea 0a             	shr    $0xa,%edx
8010782a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107830:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107837:	85 c0                	test   %eax,%eax
80107839:	74 d4                	je     8010780f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010783b:	8b 38                	mov    (%eax),%edi
8010783d:	f7 c7 01 00 00 00    	test   $0x1,%edi
80107843:	0f 84 9b 00 00 00    	je     801078e4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107849:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
8010784b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80107851:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107854:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
8010785a:	e8 31 ae ff ff       	call   80102690 <kalloc>
8010785f:	89 c7                	mov    %eax,%edi
80107861:	85 c0                	test   %eax,%eax
80107863:	74 5f                	je     801078c4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107865:	83 ec 04             	sub    $0x4,%esp
80107868:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010786e:	68 00 10 00 00       	push   $0x1000
80107873:	53                   	push   %ebx
80107874:	50                   	push   %eax
80107875:	e8 e6 ce ff ff       	call   80104760 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010787a:	58                   	pop    %eax
8010787b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107881:	ff 75 e4             	push   -0x1c(%ebp)
80107884:	50                   	push   %eax
80107885:	68 00 10 00 00       	push   $0x1000
8010788a:	56                   	push   %esi
8010788b:	ff 75 e0             	push   -0x20(%ebp)
8010788e:	e8 ad f8 ff ff       	call   80107140 <mappages>
80107893:	83 c4 20             	add    $0x20,%esp
80107896:	85 c0                	test   %eax,%eax
80107898:	78 1e                	js     801078b8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010789a:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078a0:	39 75 0c             	cmp    %esi,0xc(%ebp)
801078a3:	0f 87 57 ff ff ff    	ja     80107800 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801078a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078af:	5b                   	pop    %ebx
801078b0:	5e                   	pop    %esi
801078b1:	5f                   	pop    %edi
801078b2:	5d                   	pop    %ebp
801078b3:	c3                   	ret    
801078b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801078b8:	83 ec 0c             	sub    $0xc,%esp
801078bb:	57                   	push   %edi
801078bc:	e8 0f ac ff ff       	call   801024d0 <kfree>
      goto bad;
801078c1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801078c4:	83 ec 0c             	sub    $0xc,%esp
801078c7:	ff 75 e0             	push   -0x20(%ebp)
801078ca:	e8 91 fd ff ff       	call   80107660 <freevm>
  return 0;
801078cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078d6:	83 c4 10             	add    $0x10,%esp
}
801078d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078df:	5b                   	pop    %ebx
801078e0:	5e                   	pop    %esi
801078e1:	5f                   	pop    %edi
801078e2:	5d                   	pop    %ebp
801078e3:	c3                   	ret    
      panic("copyuvm: page not present");
801078e4:	83 ec 0c             	sub    $0xc,%esp
801078e7:	68 43 85 10 80       	push   $0x80108543
801078ec:	e8 8f 8a ff ff       	call   80100380 <panic>
801078f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ff:	90                   	nop

80107900 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107906:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107909:	89 c1                	mov    %eax,%ecx
8010790b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010790e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107911:	f6 c2 01             	test   $0x1,%dl
80107914:	0f 84 31 01 00 00    	je     80107a4b <uva2ka.cold>
  return &pgtab[PTX(va)];
8010791a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010791d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107923:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107924:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107929:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107930:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107937:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010793a:	05 00 00 00 80       	add    $0x80000000,%eax
8010793f:	83 fa 05             	cmp    $0x5,%edx
80107942:	ba 00 00 00 00       	mov    $0x0,%edx
80107947:	0f 45 c2             	cmovne %edx,%eax
}
8010794a:	c3                   	ret    
8010794b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010794f:	90                   	nop

80107950 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	57                   	push   %edi
80107954:	56                   	push   %esi
80107955:	53                   	push   %ebx
80107956:	83 ec 0c             	sub    $0xc,%esp
80107959:	8b 75 14             	mov    0x14(%ebp),%esi
8010795c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010795f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107962:	85 f6                	test   %esi,%esi
80107964:	75 51                	jne    801079b7 <copyout+0x67>
80107966:	e9 a5 00 00 00       	jmp    80107a10 <copyout+0xc0>
8010796b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010796f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107970:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107976:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010797c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107982:	74 75                	je     801079f9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107984:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107986:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107989:	29 c3                	sub    %eax,%ebx
8010798b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107991:	39 f3                	cmp    %esi,%ebx
80107993:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107996:	29 f8                	sub    %edi,%eax
80107998:	83 ec 04             	sub    $0x4,%esp
8010799b:	01 c1                	add    %eax,%ecx
8010799d:	53                   	push   %ebx
8010799e:	52                   	push   %edx
8010799f:	51                   	push   %ecx
801079a0:	e8 bb cd ff ff       	call   80104760 <memmove>
    len -= n;
    buf += n;
801079a5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801079a8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801079ae:	83 c4 10             	add    $0x10,%esp
    buf += n;
801079b1:	01 da                	add    %ebx,%edx
  while(len > 0){
801079b3:	29 de                	sub    %ebx,%esi
801079b5:	74 59                	je     80107a10 <copyout+0xc0>
  if(*pde & PTE_P){
801079b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801079ba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801079bc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801079be:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801079c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801079c7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801079ca:	f6 c1 01             	test   $0x1,%cl
801079cd:	0f 84 7f 00 00 00    	je     80107a52 <copyout.cold>
  return &pgtab[PTX(va)];
801079d3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079d5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801079db:	c1 eb 0c             	shr    $0xc,%ebx
801079de:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801079e4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801079eb:	89 d9                	mov    %ebx,%ecx
801079ed:	83 e1 05             	and    $0x5,%ecx
801079f0:	83 f9 05             	cmp    $0x5,%ecx
801079f3:	0f 84 77 ff ff ff    	je     80107970 <copyout+0x20>
  }
  return 0;
}
801079f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a01:	5b                   	pop    %ebx
80107a02:	5e                   	pop    %esi
80107a03:	5f                   	pop    %edi
80107a04:	5d                   	pop    %ebp
80107a05:	c3                   	ret    
80107a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a0d:	8d 76 00             	lea    0x0(%esi),%esi
80107a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a13:	31 c0                	xor    %eax,%eax
}
80107a15:	5b                   	pop    %ebx
80107a16:	5e                   	pop    %esi
80107a17:	5f                   	pop    %edi
80107a18:	5d                   	pop    %ebp
80107a19:	c3                   	ret    
80107a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a20 <alloc_page>:

// p5
// allocate a page from kernel & create a PTE
int alloc_page (struct proc *p, int * start_ptr)
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	83 ec 08             	sub    $0x8,%esp
  // allocate pages
    char *mem = kalloc();
80107a26:	e8 65 ac ff ff       	call   80102690 <kalloc>

    // create PTE mapping VPN -> PPN
    return mappages(p->pgdir, start_ptr, 4096, V2P(mem), PTE_W | PTE_U);
80107a2b:	83 ec 0c             	sub    $0xc,%esp
80107a2e:	05 00 00 00 80       	add    $0x80000000,%eax
80107a33:	6a 06                	push   $0x6
80107a35:	50                   	push   %eax
80107a36:	8b 45 08             	mov    0x8(%ebp),%eax
80107a39:	68 00 10 00 00       	push   $0x1000
80107a3e:	ff 75 0c             	push   0xc(%ebp)
80107a41:	ff 70 04             	push   0x4(%eax)
80107a44:	e8 f7 f6 ff ff       	call   80107140 <mappages>

}
80107a49:	c9                   	leave  
80107a4a:	c3                   	ret    

80107a4b <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107a4b:	a1 00 00 00 00       	mov    0x0,%eax
80107a50:	0f 0b                	ud2    

80107a52 <copyout.cold>:
80107a52:	a1 00 00 00 00       	mov    0x0,%eax
80107a57:	0f 0b                	ud2    
