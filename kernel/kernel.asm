
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	af010113          	addi	sp,sp,-1296 # 80008af0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda5df>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e0078793          	addi	a5,a5,-512 # 80000e84 <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a6:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	711d                	addi	sp,sp,-96
    800000d6:	ec86                	sd	ra,88(sp)
    800000d8:	e8a2                	sd	s0,80(sp)
    800000da:	e0ca                	sd	s2,64(sp)
    800000dc:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    800000de:	04c05863          	blez	a2,8000012e <consolewrite+0x5a>
    800000e2:	e4a6                	sd	s1,72(sp)
    800000e4:	fc4e                	sd	s3,56(sp)
    800000e6:	f852                	sd	s4,48(sp)
    800000e8:	f456                	sd	s5,40(sp)
    800000ea:	f05a                	sd	s6,32(sp)
    800000ec:	ec5e                	sd	s7,24(sp)
    800000ee:	8a2a                	mv	s4,a0
    800000f0:	84ae                	mv	s1,a1
    800000f2:	89b2                	mv	s3,a2
    800000f4:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000f6:	faf40b93          	addi	s7,s0,-81
    800000fa:	4b05                	li	s6,1
    800000fc:	5afd                	li	s5,-1
    800000fe:	86da                	mv	a3,s6
    80000100:	8626                	mv	a2,s1
    80000102:	85d2                	mv	a1,s4
    80000104:	855e                	mv	a0,s7
    80000106:	144020ef          	jal	8000224a <either_copyin>
    8000010a:	03550463          	beq	a0,s5,80000132 <consolewrite+0x5e>
      break;
    uartputc(c);
    8000010e:	faf44503          	lbu	a0,-81(s0)
    80000112:	02d000ef          	jal	8000093e <uartputc>
  for(i = 0; i < n; i++){
    80000116:	2905                	addiw	s2,s2,1
    80000118:	0485                	addi	s1,s1,1
    8000011a:	ff2992e3          	bne	s3,s2,800000fe <consolewrite+0x2a>
    8000011e:	894e                	mv	s2,s3
    80000120:	64a6                	ld	s1,72(sp)
    80000122:	79e2                	ld	s3,56(sp)
    80000124:	7a42                	ld	s4,48(sp)
    80000126:	7aa2                	ld	s5,40(sp)
    80000128:	7b02                	ld	s6,32(sp)
    8000012a:	6be2                	ld	s7,24(sp)
    8000012c:	a809                	j	8000013e <consolewrite+0x6a>
    8000012e:	4901                	li	s2,0
    80000130:	a039                	j	8000013e <consolewrite+0x6a>
    80000132:	64a6                	ld	s1,72(sp)
    80000134:	79e2                	ld	s3,56(sp)
    80000136:	7a42                	ld	s4,48(sp)
    80000138:	7aa2                	ld	s5,40(sp)
    8000013a:	7b02                	ld	s6,32(sp)
    8000013c:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60e6                	ld	ra,88(sp)
    80000142:	6446                	ld	s0,80(sp)
    80000144:	6906                	ld	s2,64(sp)
    80000146:	6125                	addi	sp,sp,96
    80000148:	8082                	ret

000000008000014a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000014a:	711d                	addi	sp,sp,-96
    8000014c:	ec86                	sd	ra,88(sp)
    8000014e:	e8a2                	sd	s0,80(sp)
    80000150:	e4a6                	sd	s1,72(sp)
    80000152:	e0ca                	sd	s2,64(sp)
    80000154:	fc4e                	sd	s3,56(sp)
    80000156:	f852                	sd	s4,48(sp)
    80000158:	f456                	sd	s5,40(sp)
    8000015a:	f05a                	sd	s6,32(sp)
    8000015c:	1080                	addi	s0,sp,96
    8000015e:	8aaa                	mv	s5,a0
    80000160:	8a2e                	mv	s4,a1
    80000162:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000164:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80000166:	00011517          	auipc	a0,0x11
    8000016a:	98a50513          	addi	a0,a0,-1654 # 80010af0 <cons>
    8000016e:	291000ef          	jal	80000bfe <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000172:	00011497          	auipc	s1,0x11
    80000176:	97e48493          	addi	s1,s1,-1666 # 80010af0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000017a:	00011917          	auipc	s2,0x11
    8000017e:	a0e90913          	addi	s2,s2,-1522 # 80010b88 <cons+0x98>
  while(n > 0){
    80000182:	0b305b63          	blez	s3,80000238 <consoleread+0xee>
    while(cons.r == cons.w){
    80000186:	0984a783          	lw	a5,152(s1)
    8000018a:	09c4a703          	lw	a4,156(s1)
    8000018e:	0af71063          	bne	a4,a5,8000022e <consoleread+0xe4>
      if(killed(myproc())){
    80000192:	74a010ef          	jal	800018dc <myproc>
    80000196:	74d010ef          	jal	800020e2 <killed>
    8000019a:	e12d                	bnez	a0,800001fc <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000019c:	85a6                	mv	a1,s1
    8000019e:	854a                	mv	a0,s2
    800001a0:	50b010ef          	jal	80001eaa <sleep>
    while(cons.r == cons.w){
    800001a4:	0984a783          	lw	a5,152(s1)
    800001a8:	09c4a703          	lw	a4,156(s1)
    800001ac:	fef703e3          	beq	a4,a5,80000192 <consoleread+0x48>
    800001b0:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001b2:	00011717          	auipc	a4,0x11
    800001b6:	93e70713          	addi	a4,a4,-1730 # 80010af0 <cons>
    800001ba:	0017869b          	addiw	a3,a5,1
    800001be:	08d72c23          	sw	a3,152(a4)
    800001c2:	07f7f693          	andi	a3,a5,127
    800001c6:	9736                	add	a4,a4,a3
    800001c8:	01874703          	lbu	a4,24(a4)
    800001cc:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001d0:	4691                	li	a3,4
    800001d2:	04db8663          	beq	s7,a3,8000021e <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001d6:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001da:	4685                	li	a3,1
    800001dc:	faf40613          	addi	a2,s0,-81
    800001e0:	85d2                	mv	a1,s4
    800001e2:	8556                	mv	a0,s5
    800001e4:	01c020ef          	jal	80002200 <either_copyout>
    800001e8:	57fd                	li	a5,-1
    800001ea:	04f50663          	beq	a0,a5,80000236 <consoleread+0xec>
      break;

    dst++;
    800001ee:	0a05                	addi	s4,s4,1
    --n;
    800001f0:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001f2:	47a9                	li	a5,10
    800001f4:	04fb8b63          	beq	s7,a5,8000024a <consoleread+0x100>
    800001f8:	6be2                	ld	s7,24(sp)
    800001fa:	b761                	j	80000182 <consoleread+0x38>
        release(&cons.lock);
    800001fc:	00011517          	auipc	a0,0x11
    80000200:	8f450513          	addi	a0,a0,-1804 # 80010af0 <cons>
    80000204:	28f000ef          	jal	80000c92 <release>
        return -1;
    80000208:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000020a:	60e6                	ld	ra,88(sp)
    8000020c:	6446                	ld	s0,80(sp)
    8000020e:	64a6                	ld	s1,72(sp)
    80000210:	6906                	ld	s2,64(sp)
    80000212:	79e2                	ld	s3,56(sp)
    80000214:	7a42                	ld	s4,48(sp)
    80000216:	7aa2                	ld	s5,40(sp)
    80000218:	7b02                	ld	s6,32(sp)
    8000021a:	6125                	addi	sp,sp,96
    8000021c:	8082                	ret
      if(n < target){
    8000021e:	0169fa63          	bgeu	s3,s6,80000232 <consoleread+0xe8>
        cons.r--;
    80000222:	00011717          	auipc	a4,0x11
    80000226:	96f72323          	sw	a5,-1690(a4) # 80010b88 <cons+0x98>
    8000022a:	6be2                	ld	s7,24(sp)
    8000022c:	a031                	j	80000238 <consoleread+0xee>
    8000022e:	ec5e                	sd	s7,24(sp)
    80000230:	b749                	j	800001b2 <consoleread+0x68>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	a011                	j	80000238 <consoleread+0xee>
    80000236:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000238:	00011517          	auipc	a0,0x11
    8000023c:	8b850513          	addi	a0,a0,-1864 # 80010af0 <cons>
    80000240:	253000ef          	jal	80000c92 <release>
  return target - n;
    80000244:	413b053b          	subw	a0,s6,s3
    80000248:	b7c9                	j	8000020a <consoleread+0xc0>
    8000024a:	6be2                	ld	s7,24(sp)
    8000024c:	b7f5                	j	80000238 <consoleread+0xee>

000000008000024e <consputc>:
{
    8000024e:	1141                	addi	sp,sp,-16
    80000250:	e406                	sd	ra,8(sp)
    80000252:	e022                	sd	s0,0(sp)
    80000254:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000256:	10000793          	li	a5,256
    8000025a:	00f50863          	beq	a0,a5,8000026a <consputc+0x1c>
    uartputc_sync(c);
    8000025e:	5fe000ef          	jal	8000085c <uartputc_sync>
}
    80000262:	60a2                	ld	ra,8(sp)
    80000264:	6402                	ld	s0,0(sp)
    80000266:	0141                	addi	sp,sp,16
    80000268:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000026a:	4521                	li	a0,8
    8000026c:	5f0000ef          	jal	8000085c <uartputc_sync>
    80000270:	02000513          	li	a0,32
    80000274:	5e8000ef          	jal	8000085c <uartputc_sync>
    80000278:	4521                	li	a0,8
    8000027a:	5e2000ef          	jal	8000085c <uartputc_sync>
    8000027e:	b7d5                	j	80000262 <consputc+0x14>

0000000080000280 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000280:	7179                	addi	sp,sp,-48
    80000282:	f406                	sd	ra,40(sp)
    80000284:	f022                	sd	s0,32(sp)
    80000286:	ec26                	sd	s1,24(sp)
    80000288:	1800                	addi	s0,sp,48
    8000028a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000028c:	00011517          	auipc	a0,0x11
    80000290:	86450513          	addi	a0,a0,-1948 # 80010af0 <cons>
    80000294:	16b000ef          	jal	80000bfe <acquire>

  switch(c){
    80000298:	47d5                	li	a5,21
    8000029a:	08f48e63          	beq	s1,a5,80000336 <consoleintr+0xb6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x48>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48863          	beq	s1,a5,80000394 <consoleintr+0x114>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49963          	bne	s1,a5,800003bc <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    800002ae:	7e7010ef          	jal	80002294 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002b2:	00011517          	auipc	a0,0x11
    800002b6:	83e50513          	addi	a0,a0,-1986 # 80010af0 <cons>
    800002ba:	1d9000ef          	jal	80000c92 <release>
}
    800002be:	70a2                	ld	ra,40(sp)
    800002c0:	7402                	ld	s0,32(sp)
    800002c2:	64e2                	ld	s1,24(sp)
    800002c4:	6145                	addi	sp,sp,48
    800002c6:	8082                	ret
  switch(c){
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48463          	beq	s1,a5,80000394 <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d0:	00011717          	auipc	a4,0x11
    800002d4:	82070713          	addi	a4,a4,-2016 # 80010af0 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48b63          	beq	s1,a5,800003c2 <consoleintr+0x142>
      consputc(c);
    800002f0:	8526                	mv	a0,s1
    800002f2:	f5dff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002f6:	00010797          	auipc	a5,0x10
    800002fa:	7fa78793          	addi	a5,a5,2042 # 80010af0 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	863a                	mv	a2,a4
    80000308:	0ae7a023          	sw	a4,160(a5)
    8000030c:	07f6f693          	andi	a3,a3,127
    80000310:	97b6                	add	a5,a5,a3
    80000312:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000316:	47a9                	li	a5,10
    80000318:	0cf48963          	beq	s1,a5,800003ea <consoleintr+0x16a>
    8000031c:	4791                	li	a5,4
    8000031e:	0cf48663          	beq	s1,a5,800003ea <consoleintr+0x16a>
    80000322:	00011797          	auipc	a5,0x11
    80000326:	8667a783          	lw	a5,-1946(a5) # 80010b88 <cons+0x98>
    8000032a:	9f1d                	subw	a4,a4,a5
    8000032c:	08000793          	li	a5,128
    80000330:	f8f711e3          	bne	a4,a5,800002b2 <consoleintr+0x32>
    80000334:	a85d                	j	800003ea <consoleintr+0x16a>
    80000336:	e84a                	sd	s2,16(sp)
    80000338:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    8000033a:	00010717          	auipc	a4,0x10
    8000033e:	7b670713          	addi	a4,a4,1974 # 80010af0 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00010497          	auipc	s1,0x10
    8000034e:	7a648493          	addi	s1,s1,1958 # 80010af0 <cons>
    while(cons.e != cons.w &&
    80000352:	4929                	li	s2,10
      consputc(BACKSPACE);
    80000354:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80000358:	02f70863          	beq	a4,a5,80000388 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000035c:	37fd                	addiw	a5,a5,-1
    8000035e:	07f7f713          	andi	a4,a5,127
    80000362:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000364:	01874703          	lbu	a4,24(a4)
    80000368:	03270363          	beq	a4,s2,8000038e <consoleintr+0x10e>
      cons.e--;
    8000036c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000370:	854e                	mv	a0,s3
    80000372:	eddff0ef          	jal	8000024e <consputc>
    while(cons.e != cons.w &&
    80000376:	0a04a783          	lw	a5,160(s1)
    8000037a:	09c4a703          	lw	a4,156(s1)
    8000037e:	fcf71fe3          	bne	a4,a5,8000035c <consoleintr+0xdc>
    80000382:	6942                	ld	s2,16(sp)
    80000384:	69a2                	ld	s3,8(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x32>
    80000388:	6942                	ld	s2,16(sp)
    8000038a:	69a2                	ld	s3,8(sp)
    8000038c:	b71d                	j	800002b2 <consoleintr+0x32>
    8000038e:	6942                	ld	s2,16(sp)
    80000390:	69a2                	ld	s3,8(sp)
    80000392:	b705                	j	800002b2 <consoleintr+0x32>
    if(cons.e != cons.w){
    80000394:	00010717          	auipc	a4,0x10
    80000398:	75c70713          	addi	a4,a4,1884 # 80010af0 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
    800003a4:	f0f707e3          	beq	a4,a5,800002b2 <consoleintr+0x32>
      cons.e--;
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	00010717          	auipc	a4,0x10
    800003ae:	7ef72323          	sw	a5,2022(a4) # 80010b90 <cons+0xa0>
      consputc(BACKSPACE);
    800003b2:	10000513          	li	a0,256
    800003b6:	e99ff0ef          	jal	8000024e <consputc>
    800003ba:	bde5                	j	800002b2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003bc:	ee048be3          	beqz	s1,800002b2 <consoleintr+0x32>
    800003c0:	bf01                	j	800002d0 <consoleintr+0x50>
      consputc(c);
    800003c2:	4529                	li	a0,10
    800003c4:	e8bff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003c8:	00010797          	auipc	a5,0x10
    800003cc:	72878793          	addi	a5,a5,1832 # 80010af0 <cons>
    800003d0:	0a07a703          	lw	a4,160(a5)
    800003d4:	0017069b          	addiw	a3,a4,1
    800003d8:	8636                	mv	a2,a3
    800003da:	0ad7a023          	sw	a3,160(a5)
    800003de:	07f77713          	andi	a4,a4,127
    800003e2:	97ba                	add	a5,a5,a4
    800003e4:	4729                	li	a4,10
    800003e6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003ea:	00010797          	auipc	a5,0x10
    800003ee:	7ac7a123          	sw	a2,1954(a5) # 80010b8c <cons+0x9c>
        wakeup(&cons.r);
    800003f2:	00010517          	auipc	a0,0x10
    800003f6:	79650513          	addi	a0,a0,1942 # 80010b88 <cons+0x98>
    800003fa:	2fd010ef          	jal	80001ef6 <wakeup>
    800003fe:	bd55                	j	800002b2 <consoleintr+0x32>

0000000080000400 <consoleinit>:

void
consoleinit(void)
{
    80000400:	1141                	addi	sp,sp,-16
    80000402:	e406                	sd	ra,8(sp)
    80000404:	e022                	sd	s0,0(sp)
    80000406:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000408:	00008597          	auipc	a1,0x8
    8000040c:	bf858593          	addi	a1,a1,-1032 # 80008000 <etext>
    80000410:	00010517          	auipc	a0,0x10
    80000414:	6e050513          	addi	a0,a0,1760 # 80010af0 <cons>
    80000418:	762000ef          	jal	80000b7a <initlock>

  uartinit();
    8000041c:	3ea000ef          	jal	80000806 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000420:	00021797          	auipc	a5,0x21
    80000424:	86878793          	addi	a5,a5,-1944 # 80020c88 <devsw>
    80000428:	00000717          	auipc	a4,0x0
    8000042c:	d2270713          	addi	a4,a4,-734 # 8000014a <consoleread>
    80000430:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000432:	00000717          	auipc	a4,0x0
    80000436:	ca270713          	addi	a4,a4,-862 # 800000d4 <consolewrite>
    8000043a:	ef98                	sd	a4,24(a5)
}
    8000043c:	60a2                	ld	ra,8(sp)
    8000043e:	6402                	ld	s0,0(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret

0000000080000444 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000444:	7179                	addi	sp,sp,-48
    80000446:	f406                	sd	ra,40(sp)
    80000448:	f022                	sd	s0,32(sp)
    8000044a:	ec26                	sd	s1,24(sp)
    8000044c:	e84a                	sd	s2,16(sp)
    8000044e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000450:	c219                	beqz	a2,80000456 <printint+0x12>
    80000452:	06054a63          	bltz	a0,800004c6 <printint+0x82>
    x = -xx;
  else
    x = xx;
    80000456:	4e01                	li	t3,0

  i = 0;
    80000458:	fd040313          	addi	t1,s0,-48
    x = xx;
    8000045c:	869a                	mv	a3,t1
  i = 0;
    8000045e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000460:	00008817          	auipc	a6,0x8
    80000464:	4b080813          	addi	a6,a6,1200 # 80008910 <digits>
    80000468:	88be                	mv	a7,a5
    8000046a:	0017861b          	addiw	a2,a5,1
    8000046e:	87b2                	mv	a5,a2
    80000470:	02b57733          	remu	a4,a0,a1
    80000474:	9742                	add	a4,a4,a6
    80000476:	00074703          	lbu	a4,0(a4)
    8000047a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000047e:	872a                	mv	a4,a0
    80000480:	02b55533          	divu	a0,a0,a1
    80000484:	0685                	addi	a3,a3,1
    80000486:	feb771e3          	bgeu	a4,a1,80000468 <printint+0x24>

  if(sign)
    8000048a:	000e0c63          	beqz	t3,800004a2 <printint+0x5e>
    buf[i++] = '-';
    8000048e:	fe060793          	addi	a5,a2,-32
    80000492:	00878633          	add	a2,a5,s0
    80000496:	02d00793          	li	a5,45
    8000049a:	fef60823          	sb	a5,-16(a2)
    8000049e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800004a2:	fff7891b          	addiw	s2,a5,-1
    800004a6:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800004aa:	fff4c503          	lbu	a0,-1(s1)
    800004ae:	da1ff0ef          	jal	8000024e <consputc>
  while(--i >= 0)
    800004b2:	397d                	addiw	s2,s2,-1
    800004b4:	14fd                	addi	s1,s1,-1
    800004b6:	fe095ae3          	bgez	s2,800004aa <printint+0x66>
}
    800004ba:	70a2                	ld	ra,40(sp)
    800004bc:	7402                	ld	s0,32(sp)
    800004be:	64e2                	ld	s1,24(sp)
    800004c0:	6942                	ld	s2,16(sp)
    800004c2:	6145                	addi	sp,sp,48
    800004c4:	8082                	ret
    x = -xx;
    800004c6:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004ca:	4e05                	li	t3,1
    x = -xx;
    800004cc:	b771                	j	80000458 <printint+0x14>

00000000800004ce <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004ce:	7155                	addi	sp,sp,-208
    800004d0:	e506                	sd	ra,136(sp)
    800004d2:	e122                	sd	s0,128(sp)
    800004d4:	f0d2                	sd	s4,96(sp)
    800004d6:	0900                	addi	s0,sp,144
    800004d8:	8a2a                	mv	s4,a0
    800004da:	e40c                	sd	a1,8(s0)
    800004dc:	e810                	sd	a2,16(s0)
    800004de:	ec14                	sd	a3,24(s0)
    800004e0:	f018                	sd	a4,32(s0)
    800004e2:	f41c                	sd	a5,40(s0)
    800004e4:	03043823          	sd	a6,48(s0)
    800004e8:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004ec:	00010797          	auipc	a5,0x10
    800004f0:	6c47a783          	lw	a5,1732(a5) # 80010bb0 <pr+0x18>
    800004f4:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004f8:	e3a1                	bnez	a5,80000538 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004fa:	00840793          	addi	a5,s0,8
    800004fe:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000502:	00054503          	lbu	a0,0(a0)
    80000506:	26050663          	beqz	a0,80000772 <printf+0x2a4>
    8000050a:	fca6                	sd	s1,120(sp)
    8000050c:	f8ca                	sd	s2,112(sp)
    8000050e:	f4ce                	sd	s3,104(sp)
    80000510:	ecd6                	sd	s5,88(sp)
    80000512:	e8da                	sd	s6,80(sp)
    80000514:	e0e2                	sd	s8,64(sp)
    80000516:	fc66                	sd	s9,56(sp)
    80000518:	f86a                	sd	s10,48(sp)
    8000051a:	f46e                	sd	s11,40(sp)
    8000051c:	4981                	li	s3,0
    if(cx != '%'){
    8000051e:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000522:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000526:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000052a:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000052e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000532:	07000d93          	li	s11,112
    80000536:	a80d                	j	80000568 <printf+0x9a>
    acquire(&pr.lock);
    80000538:	00010517          	auipc	a0,0x10
    8000053c:	66050513          	addi	a0,a0,1632 # 80010b98 <pr>
    80000540:	6be000ef          	jal	80000bfe <acquire>
  va_start(ap, fmt);
    80000544:	00840793          	addi	a5,s0,8
    80000548:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054c:	000a4503          	lbu	a0,0(s4)
    80000550:	fd4d                	bnez	a0,8000050a <printf+0x3c>
    80000552:	ac3d                	j	80000790 <printf+0x2c2>
      consputc(cx);
    80000554:	cfbff0ef          	jal	8000024e <consputc>
      continue;
    80000558:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055a:	2485                	addiw	s1,s1,1
    8000055c:	89a6                	mv	s3,s1
    8000055e:	94d2                	add	s1,s1,s4
    80000560:	0004c503          	lbu	a0,0(s1)
    80000564:	1e050b63          	beqz	a0,8000075a <printf+0x28c>
    if(cx != '%'){
    80000568:	ff5516e3          	bne	a0,s5,80000554 <printf+0x86>
    i++;
    8000056c:	0019879b          	addiw	a5,s3,1
    80000570:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80000572:	00fa0733          	add	a4,s4,a5
    80000576:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000057a:	1e090063          	beqz	s2,8000075a <printf+0x28c>
    8000057e:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    80000582:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    80000584:	c701                	beqz	a4,8000058c <printf+0xbe>
    80000586:	97d2                	add	a5,a5,s4
    80000588:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    8000058c:	03690763          	beq	s2,s6,800005ba <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80000590:	05890163          	beq	s2,s8,800005d2 <printf+0x104>
    } else if(c0 == 'u'){
    80000594:	0d990b63          	beq	s2,s9,8000066a <printf+0x19c>
    } else if(c0 == 'x'){
    80000598:	13a90163          	beq	s2,s10,800006ba <printf+0x1ec>
    } else if(c0 == 'p'){
    8000059c:	13b90b63          	beq	s2,s11,800006d2 <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005a0:	07300793          	li	a5,115
    800005a4:	16f90a63          	beq	s2,a5,80000718 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005a8:	1b590463          	beq	s2,s5,80000750 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005ac:	8556                	mv	a0,s5
    800005ae:	ca1ff0ef          	jal	8000024e <consputc>
      consputc(c0);
    800005b2:	854a                	mv	a0,s2
    800005b4:	c9bff0ef          	jal	8000024e <consputc>
    800005b8:	b74d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005ba:	f8843783          	ld	a5,-120(s0)
    800005be:	00878713          	addi	a4,a5,8
    800005c2:	f8e43423          	sd	a4,-120(s0)
    800005c6:	4605                	li	a2,1
    800005c8:	45a9                	li	a1,10
    800005ca:	4388                	lw	a0,0(a5)
    800005cc:	e79ff0ef          	jal	80000444 <printint>
    800005d0:	b769                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005d2:	03670663          	beq	a4,s6,800005fe <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005d6:	05870263          	beq	a4,s8,8000061a <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    800005da:	0b970463          	beq	a4,s9,80000682 <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    800005de:	fda717e3          	bne	a4,s10,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800005e2:	f8843783          	ld	a5,-120(s0)
    800005e6:	00878713          	addi	a4,a5,8
    800005ea:	f8e43423          	sd	a4,-120(s0)
    800005ee:	4601                	li	a2,0
    800005f0:	45c1                	li	a1,16
    800005f2:	6388                	ld	a0,0(a5)
    800005f4:	e51ff0ef          	jal	80000444 <printint>
      i += 1;
    800005f8:	0029849b          	addiw	s1,s3,2
    800005fc:	bfb9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005fe:	f8843783          	ld	a5,-120(s0)
    80000602:	00878713          	addi	a4,a5,8
    80000606:	f8e43423          	sd	a4,-120(s0)
    8000060a:	4605                	li	a2,1
    8000060c:	45a9                	li	a1,10
    8000060e:	6388                	ld	a0,0(a5)
    80000610:	e35ff0ef          	jal	80000444 <printint>
      i += 1;
    80000614:	0029849b          	addiw	s1,s3,2
    80000618:	b789                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000061a:	06400793          	li	a5,100
    8000061e:	02f68863          	beq	a3,a5,8000064e <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000622:	07500793          	li	a5,117
    80000626:	06f68c63          	beq	a3,a5,8000069e <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000062a:	07800793          	li	a5,120
    8000062e:	f6f69fe3          	bne	a3,a5,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    80000632:	f8843783          	ld	a5,-120(s0)
    80000636:	00878713          	addi	a4,a5,8
    8000063a:	f8e43423          	sd	a4,-120(s0)
    8000063e:	4601                	li	a2,0
    80000640:	45c1                	li	a1,16
    80000642:	6388                	ld	a0,0(a5)
    80000644:	e01ff0ef          	jal	80000444 <printint>
      i += 2;
    80000648:	0039849b          	addiw	s1,s3,3
    8000064c:	b739                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    8000064e:	f8843783          	ld	a5,-120(s0)
    80000652:	00878713          	addi	a4,a5,8
    80000656:	f8e43423          	sd	a4,-120(s0)
    8000065a:	4605                	li	a2,1
    8000065c:	45a9                	li	a1,10
    8000065e:	6388                	ld	a0,0(a5)
    80000660:	de5ff0ef          	jal	80000444 <printint>
      i += 2;
    80000664:	0039849b          	addiw	s1,s3,3
    80000668:	bdcd                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000066a:	f8843783          	ld	a5,-120(s0)
    8000066e:	00878713          	addi	a4,a5,8
    80000672:	f8e43423          	sd	a4,-120(s0)
    80000676:	4601                	li	a2,0
    80000678:	45a9                	li	a1,10
    8000067a:	4388                	lw	a0,0(a5)
    8000067c:	dc9ff0ef          	jal	80000444 <printint>
    80000680:	bde9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4601                	li	a2,0
    80000690:	45a9                	li	a1,10
    80000692:	6388                	ld	a0,0(a5)
    80000694:	db1ff0ef          	jal	80000444 <printint>
      i += 1;
    80000698:	0029849b          	addiw	s1,s3,2
    8000069c:	bd7d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	4601                	li	a2,0
    800006ac:	45a9                	li	a1,10
    800006ae:	6388                	ld	a0,0(a5)
    800006b0:	d95ff0ef          	jal	80000444 <printint>
      i += 2;
    800006b4:	0039849b          	addiw	s1,s3,3
    800006b8:	b54d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006ba:	f8843783          	ld	a5,-120(s0)
    800006be:	00878713          	addi	a4,a5,8
    800006c2:	f8e43423          	sd	a4,-120(s0)
    800006c6:	4601                	li	a2,0
    800006c8:	45c1                	li	a1,16
    800006ca:	4388                	lw	a0,0(a5)
    800006cc:	d79ff0ef          	jal	80000444 <printint>
    800006d0:	b569                	j	8000055a <printf+0x8c>
    800006d2:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006d4:	f8843783          	ld	a5,-120(s0)
    800006d8:	00878713          	addi	a4,a5,8
    800006dc:	f8e43423          	sd	a4,-120(s0)
    800006e0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e4:	03000513          	li	a0,48
    800006e8:	b67ff0ef          	jal	8000024e <consputc>
  consputc('x');
    800006ec:	07800513          	li	a0,120
    800006f0:	b5fff0ef          	jal	8000024e <consputc>
    800006f4:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f6:	00008b97          	auipc	s7,0x8
    800006fa:	21ab8b93          	addi	s7,s7,538 # 80008910 <digits>
    800006fe:	03c9d793          	srli	a5,s3,0x3c
    80000702:	97de                	add	a5,a5,s7
    80000704:	0007c503          	lbu	a0,0(a5)
    80000708:	b47ff0ef          	jal	8000024e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070c:	0992                	slli	s3,s3,0x4
    8000070e:	397d                	addiw	s2,s2,-1
    80000710:	fe0917e3          	bnez	s2,800006fe <printf+0x230>
    80000714:	6ba6                	ld	s7,72(sp)
    80000716:	b591                	j	8000055a <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007b903          	ld	s2,0(a5)
    80000728:	00090d63          	beqz	s2,80000742 <printf+0x274>
      for(; *s; s++)
    8000072c:	00094503          	lbu	a0,0(s2)
    80000730:	e20505e3          	beqz	a0,8000055a <printf+0x8c>
        consputc(*s);
    80000734:	b1bff0ef          	jal	8000024e <consputc>
      for(; *s; s++)
    80000738:	0905                	addi	s2,s2,1
    8000073a:	00094503          	lbu	a0,0(s2)
    8000073e:	f97d                	bnez	a0,80000734 <printf+0x266>
    80000740:	bd29                	j	8000055a <printf+0x8c>
        s = "(null)";
    80000742:	00008917          	auipc	s2,0x8
    80000746:	8c690913          	addi	s2,s2,-1850 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printf+0x266>
      consputc('%');
    80000750:	02500513          	li	a0,37
    80000754:	afbff0ef          	jal	8000024e <consputc>
    80000758:	b509                	j	8000055a <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000075a:	f7843783          	ld	a5,-136(s0)
    8000075e:	e385                	bnez	a5,8000077e <printf+0x2b0>
    80000760:	74e6                	ld	s1,120(sp)
    80000762:	7946                	ld	s2,112(sp)
    80000764:	79a6                	ld	s3,104(sp)
    80000766:	6ae6                	ld	s5,88(sp)
    80000768:	6b46                	ld	s6,80(sp)
    8000076a:	6c06                	ld	s8,64(sp)
    8000076c:	7ce2                	ld	s9,56(sp)
    8000076e:	7d42                	ld	s10,48(sp)
    80000770:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000772:	4501                	li	a0,0
    80000774:	60aa                	ld	ra,136(sp)
    80000776:	640a                	ld	s0,128(sp)
    80000778:	7a06                	ld	s4,96(sp)
    8000077a:	6169                	addi	sp,sp,208
    8000077c:	8082                	ret
    8000077e:	74e6                	ld	s1,120(sp)
    80000780:	7946                	ld	s2,112(sp)
    80000782:	79a6                	ld	s3,104(sp)
    80000784:	6ae6                	ld	s5,88(sp)
    80000786:	6b46                	ld	s6,80(sp)
    80000788:	6c06                	ld	s8,64(sp)
    8000078a:	7ce2                	ld	s9,56(sp)
    8000078c:	7d42                	ld	s10,48(sp)
    8000078e:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000790:	00010517          	auipc	a0,0x10
    80000794:	40850513          	addi	a0,a0,1032 # 80010b98 <pr>
    80000798:	4fa000ef          	jal	80000c92 <release>
    8000079c:	bfd9                	j	80000772 <printf+0x2a4>

000000008000079e <panic>:

void
panic(char *s)
{
    8000079e:	1101                	addi	sp,sp,-32
    800007a0:	ec06                	sd	ra,24(sp)
    800007a2:	e822                	sd	s0,16(sp)
    800007a4:	e426                	sd	s1,8(sp)
    800007a6:	1000                	addi	s0,sp,32
    800007a8:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007aa:	00010797          	auipc	a5,0x10
    800007ae:	4007a323          	sw	zero,1030(a5) # 80010bb0 <pr+0x18>
  printf("panic: ");
    800007b2:	00008517          	auipc	a0,0x8
    800007b6:	86650513          	addi	a0,a0,-1946 # 80008018 <etext+0x18>
    800007ba:	d15ff0ef          	jal	800004ce <printf>
  printf("%s\n", s);
    800007be:	85a6                	mv	a1,s1
    800007c0:	00008517          	auipc	a0,0x8
    800007c4:	86050513          	addi	a0,a0,-1952 # 80008020 <etext+0x20>
    800007c8:	d07ff0ef          	jal	800004ce <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007cc:	4785                	li	a5,1
    800007ce:	00008717          	auipc	a4,0x8
    800007d2:	2cf72923          	sw	a5,722(a4) # 80008aa0 <panicked>
  for(;;)
    800007d6:	a001                	j	800007d6 <panic+0x38>

00000000800007d8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007d8:	1101                	addi	sp,sp,-32
    800007da:	ec06                	sd	ra,24(sp)
    800007dc:	e822                	sd	s0,16(sp)
    800007de:	e426                	sd	s1,8(sp)
    800007e0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007e2:	00010497          	auipc	s1,0x10
    800007e6:	3b648493          	addi	s1,s1,950 # 80010b98 <pr>
    800007ea:	00008597          	auipc	a1,0x8
    800007ee:	83e58593          	addi	a1,a1,-1986 # 80008028 <etext+0x28>
    800007f2:	8526                	mv	a0,s1
    800007f4:	386000ef          	jal	80000b7a <initlock>
  pr.locking = 1;
    800007f8:	4785                	li	a5,1
    800007fa:	cc9c                	sw	a5,24(s1)
}
    800007fc:	60e2                	ld	ra,24(sp)
    800007fe:	6442                	ld	s0,16(sp)
    80000800:	64a2                	ld	s1,8(sp)
    80000802:	6105                	addi	sp,sp,32
    80000804:	8082                	ret

0000000080000806 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000806:	1141                	addi	sp,sp,-16
    80000808:	e406                	sd	ra,8(sp)
    8000080a:	e022                	sd	s0,0(sp)
    8000080c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000080e:	100007b7          	lui	a5,0x10000
    80000812:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000816:	10000737          	lui	a4,0x10000
    8000081a:	f8000693          	li	a3,-128
    8000081e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000822:	468d                	li	a3,3
    80000824:	10000637          	lui	a2,0x10000
    80000828:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000082c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000830:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000834:	8732                	mv	a4,a2
    80000836:	461d                	li	a2,7
    80000838:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000083c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000840:	00007597          	auipc	a1,0x7
    80000844:	7f058593          	addi	a1,a1,2032 # 80008030 <etext+0x30>
    80000848:	00010517          	auipc	a0,0x10
    8000084c:	37050513          	addi	a0,a0,880 # 80010bb8 <uart_tx_lock>
    80000850:	32a000ef          	jal	80000b7a <initlock>
}
    80000854:	60a2                	ld	ra,8(sp)
    80000856:	6402                	ld	s0,0(sp)
    80000858:	0141                	addi	sp,sp,16
    8000085a:	8082                	ret

000000008000085c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000085c:	1101                	addi	sp,sp,-32
    8000085e:	ec06                	sd	ra,24(sp)
    80000860:	e822                	sd	s0,16(sp)
    80000862:	e426                	sd	s1,8(sp)
    80000864:	1000                	addi	s0,sp,32
    80000866:	84aa                	mv	s1,a0
  push_off();
    80000868:	356000ef          	jal	80000bbe <push_off>

  if(panicked){
    8000086c:	00008797          	auipc	a5,0x8
    80000870:	2347a783          	lw	a5,564(a5) # 80008aa0 <panicked>
    80000874:	e795                	bnez	a5,800008a0 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000876:	10000737          	lui	a4,0x10000
    8000087a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000087c:	00074783          	lbu	a5,0(a4)
    80000880:	0207f793          	andi	a5,a5,32
    80000884:	dfe5                	beqz	a5,8000087c <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000886:	0ff4f513          	zext.b	a0,s1
    8000088a:	100007b7          	lui	a5,0x10000
    8000088e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000892:	3b0000ef          	jal	80000c42 <pop_off>
}
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    for(;;)
    800008a0:	a001                	j	800008a0 <uartputc_sync+0x44>

00000000800008a2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a2:	00008797          	auipc	a5,0x8
    800008a6:	2067b783          	ld	a5,518(a5) # 80008aa8 <uart_tx_r>
    800008aa:	00008717          	auipc	a4,0x8
    800008ae:	20673703          	ld	a4,518(a4) # 80008ab0 <uart_tx_w>
    800008b2:	08f70163          	beq	a4,a5,80000934 <uartstart+0x92>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	e05a                	sd	s6,0(sp)
    800008c8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ca:	10000937          	lui	s2,0x10000
    800008ce:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d0:	00010a97          	auipc	s5,0x10
    800008d4:	2e8a8a93          	addi	s5,s5,744 # 80010bb8 <uart_tx_lock>
    uart_tx_r += 1;
    800008d8:	00008497          	auipc	s1,0x8
    800008dc:	1d048493          	addi	s1,s1,464 # 80008aa8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e0:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e4:	00008997          	auipc	s3,0x8
    800008e8:	1cc98993          	addi	s3,s3,460 # 80008ab0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ec:	00094703          	lbu	a4,0(s2)
    800008f0:	02077713          	andi	a4,a4,32
    800008f4:	c715                	beqz	a4,80000920 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f6:	01f7f713          	andi	a4,a5,31
    800008fa:	9756                	add	a4,a4,s5
    800008fc:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000900:	0785                	addi	a5,a5,1
    80000902:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000904:	8526                	mv	a0,s1
    80000906:	5f0010ef          	jal	80001ef6 <wakeup>
    WriteReg(THR, c);
    8000090a:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000090e:	609c                	ld	a5,0(s1)
    80000910:	0009b703          	ld	a4,0(s3)
    80000914:	fcf71ce3          	bne	a4,a5,800008ec <uartstart+0x4a>
      ReadReg(ISR);
    80000918:	100007b7          	lui	a5,0x10000
    8000091c:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80000920:	70e2                	ld	ra,56(sp)
    80000922:	7442                	ld	s0,48(sp)
    80000924:	74a2                	ld	s1,40(sp)
    80000926:	7902                	ld	s2,32(sp)
    80000928:	69e2                	ld	s3,24(sp)
    8000092a:	6a42                	ld	s4,16(sp)
    8000092c:	6aa2                	ld	s5,8(sp)
    8000092e:	6b02                	ld	s6,0(sp)
    80000930:	6121                	addi	sp,sp,64
    80000932:	8082                	ret
      ReadReg(ISR);
    80000934:	100007b7          	lui	a5,0x10000
    80000938:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    8000093c:	8082                	ret

000000008000093e <uartputc>:
{
    8000093e:	7179                	addi	sp,sp,-48
    80000940:	f406                	sd	ra,40(sp)
    80000942:	f022                	sd	s0,32(sp)
    80000944:	ec26                	sd	s1,24(sp)
    80000946:	e84a                	sd	s2,16(sp)
    80000948:	e44e                	sd	s3,8(sp)
    8000094a:	e052                	sd	s4,0(sp)
    8000094c:	1800                	addi	s0,sp,48
    8000094e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000950:	00010517          	auipc	a0,0x10
    80000954:	26850513          	addi	a0,a0,616 # 80010bb8 <uart_tx_lock>
    80000958:	2a6000ef          	jal	80000bfe <acquire>
  if(panicked){
    8000095c:	00008797          	auipc	a5,0x8
    80000960:	1447a783          	lw	a5,324(a5) # 80008aa0 <panicked>
    80000964:	efbd                	bnez	a5,800009e2 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000966:	00008717          	auipc	a4,0x8
    8000096a:	14a73703          	ld	a4,330(a4) # 80008ab0 <uart_tx_w>
    8000096e:	00008797          	auipc	a5,0x8
    80000972:	13a7b783          	ld	a5,314(a5) # 80008aa8 <uart_tx_r>
    80000976:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	00010997          	auipc	s3,0x10
    8000097e:	23e98993          	addi	s3,s3,574 # 80010bb8 <uart_tx_lock>
    80000982:	00008497          	auipc	s1,0x8
    80000986:	12648493          	addi	s1,s1,294 # 80008aa8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000098a:	00008917          	auipc	s2,0x8
    8000098e:	12690913          	addi	s2,s2,294 # 80008ab0 <uart_tx_w>
    80000992:	00e79d63          	bne	a5,a4,800009ac <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000996:	85ce                	mv	a1,s3
    80000998:	8526                	mv	a0,s1
    8000099a:	510010ef          	jal	80001eaa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099e:	00093703          	ld	a4,0(s2)
    800009a2:	609c                	ld	a5,0(s1)
    800009a4:	02078793          	addi	a5,a5,32
    800009a8:	fee787e3          	beq	a5,a4,80000996 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009ac:	00010497          	auipc	s1,0x10
    800009b0:	20c48493          	addi	s1,s1,524 # 80010bb8 <uart_tx_lock>
    800009b4:	01f77793          	andi	a5,a4,31
    800009b8:	97a6                	add	a5,a5,s1
    800009ba:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009be:	0705                	addi	a4,a4,1
    800009c0:	00008797          	auipc	a5,0x8
    800009c4:	0ee7b823          	sd	a4,240(a5) # 80008ab0 <uart_tx_w>
  uartstart();
    800009c8:	edbff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    800009cc:	8526                	mv	a0,s1
    800009ce:	2c4000ef          	jal	80000c92 <release>
}
    800009d2:	70a2                	ld	ra,40(sp)
    800009d4:	7402                	ld	s0,32(sp)
    800009d6:	64e2                	ld	s1,24(sp)
    800009d8:	6942                	ld	s2,16(sp)
    800009da:	69a2                	ld	s3,8(sp)
    800009dc:	6a02                	ld	s4,0(sp)
    800009de:	6145                	addi	sp,sp,48
    800009e0:	8082                	ret
    for(;;)
    800009e2:	a001                	j	800009e2 <uartputc+0xa4>

00000000800009e4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e4:	1141                	addi	sp,sp,-16
    800009e6:	e406                	sd	ra,8(sp)
    800009e8:	e022                	sd	s0,0(sp)
    800009ea:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009f4:	8b85                	andi	a5,a5,1
    800009f6:	cb89                	beqz	a5,80000a08 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009f8:	100007b7          	lui	a5,0x10000
    800009fc:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a00:	60a2                	ld	ra,8(sp)
    80000a02:	6402                	ld	s0,0(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return -1;
    80000a08:	557d                	li	a0,-1
    80000a0a:	bfdd                	j	80000a00 <uartgetc+0x1c>

0000000080000a0c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a16:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a18:	fcdff0ef          	jal	800009e4 <uartgetc>
    if(c == -1)
    80000a1c:	00950563          	beq	a0,s1,80000a26 <uartintr+0x1a>
      break;
    consoleintr(c);
    80000a20:	861ff0ef          	jal	80000280 <consoleintr>
  while(1){
    80000a24:	bfd5                	j	80000a18 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a26:	00010497          	auipc	s1,0x10
    80000a2a:	19248493          	addi	s1,s1,402 # 80010bb8 <uart_tx_lock>
    80000a2e:	8526                	mv	a0,s1
    80000a30:	1ce000ef          	jal	80000bfe <acquire>
  uartstart();
    80000a34:	e6fff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    80000a38:	8526                	mv	a0,s1
    80000a3a:	258000ef          	jal	80000c92 <release>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret

0000000080000a48 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a48:	1101                	addi	sp,sp,-32
    80000a4a:	ec06                	sd	ra,24(sp)
    80000a4c:	e822                	sd	s0,16(sp)
    80000a4e:	e426                	sd	s1,8(sp)
    80000a50:	e04a                	sd	s2,0(sp)
    80000a52:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a54:	03451793          	slli	a5,a0,0x34
    80000a58:	e7a9                	bnez	a5,80000aa2 <kfree+0x5a>
    80000a5a:	84aa                	mv	s1,a0
    80000a5c:	00023797          	auipc	a5,0x23
    80000a60:	7c478793          	addi	a5,a5,1988 # 80024220 <end>
    80000a64:	02f56f63          	bltu	a0,a5,80000aa2 <kfree+0x5a>
    80000a68:	47c5                	li	a5,17
    80000a6a:	07ee                	slli	a5,a5,0x1b
    80000a6c:	02f57b63          	bgeu	a0,a5,80000aa2 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a70:	6605                	lui	a2,0x1
    80000a72:	4585                	li	a1,1
    80000a74:	25a000ef          	jal	80000cce <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a78:	00010917          	auipc	s2,0x10
    80000a7c:	17890913          	addi	s2,s2,376 # 80010bf0 <kmem>
    80000a80:	854a                	mv	a0,s2
    80000a82:	17c000ef          	jal	80000bfe <acquire>
  r->next = kmem.freelist;
    80000a86:	01893783          	ld	a5,24(s2)
    80000a8a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a8c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a90:	854a                	mv	a0,s2
    80000a92:	200000ef          	jal	80000c92 <release>
}
    80000a96:	60e2                	ld	ra,24(sp)
    80000a98:	6442                	ld	s0,16(sp)
    80000a9a:	64a2                	ld	s1,8(sp)
    80000a9c:	6902                	ld	s2,0(sp)
    80000a9e:	6105                	addi	sp,sp,32
    80000aa0:	8082                	ret
    panic("kfree");
    80000aa2:	00007517          	auipc	a0,0x7
    80000aa6:	59650513          	addi	a0,a0,1430 # 80008038 <etext+0x38>
    80000aaa:	cf5ff0ef          	jal	8000079e <panic>

0000000080000aae <freerange>:
{
    80000aae:	7179                	addi	sp,sp,-48
    80000ab0:	f406                	sd	ra,40(sp)
    80000ab2:	f022                	sd	s0,32(sp)
    80000ab4:	ec26                	sd	s1,24(sp)
    80000ab6:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000abe:	00e504b3          	add	s1,a0,a4
    80000ac2:	777d                	lui	a4,0xfffff
    80000ac4:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac6:	94be                	add	s1,s1,a5
    80000ac8:	0295e263          	bltu	a1,s1,80000aec <freerange+0x3e>
    80000acc:	e84a                	sd	s2,16(sp)
    80000ace:	e44e                	sd	s3,8(sp)
    80000ad0:	e052                	sd	s4,0(sp)
    80000ad2:	892e                	mv	s2,a1
    kfree(p);
    80000ad4:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad6:	89be                	mv	s3,a5
    kfree(p);
    80000ad8:	01448533          	add	a0,s1,s4
    80000adc:	f6dff0ef          	jal	80000a48 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94ce                	add	s1,s1,s3
    80000ae2:	fe997be3          	bgeu	s2,s1,80000ad8 <freerange+0x2a>
    80000ae6:	6942                	ld	s2,16(sp)
    80000ae8:	69a2                	ld	s3,8(sp)
    80000aea:	6a02                	ld	s4,0(sp)
}
    80000aec:	70a2                	ld	ra,40(sp)
    80000aee:	7402                	ld	s0,32(sp)
    80000af0:	64e2                	ld	s1,24(sp)
    80000af2:	6145                	addi	sp,sp,48
    80000af4:	8082                	ret

0000000080000af6 <kinit>:
{
    80000af6:	1141                	addi	sp,sp,-16
    80000af8:	e406                	sd	ra,8(sp)
    80000afa:	e022                	sd	s0,0(sp)
    80000afc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000afe:	00007597          	auipc	a1,0x7
    80000b02:	54258593          	addi	a1,a1,1346 # 80008040 <etext+0x40>
    80000b06:	00010517          	auipc	a0,0x10
    80000b0a:	0ea50513          	addi	a0,a0,234 # 80010bf0 <kmem>
    80000b0e:	06c000ef          	jal	80000b7a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b12:	45c5                	li	a1,17
    80000b14:	05ee                	slli	a1,a1,0x1b
    80000b16:	00023517          	auipc	a0,0x23
    80000b1a:	70a50513          	addi	a0,a0,1802 # 80024220 <end>
    80000b1e:	f91ff0ef          	jal	80000aae <freerange>
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret

0000000080000b2a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b2a:	1101                	addi	sp,sp,-32
    80000b2c:	ec06                	sd	ra,24(sp)
    80000b2e:	e822                	sd	s0,16(sp)
    80000b30:	e426                	sd	s1,8(sp)
    80000b32:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b34:	00010497          	auipc	s1,0x10
    80000b38:	0bc48493          	addi	s1,s1,188 # 80010bf0 <kmem>
    80000b3c:	8526                	mv	a0,s1
    80000b3e:	0c0000ef          	jal	80000bfe <acquire>
  r = kmem.freelist;
    80000b42:	6c84                	ld	s1,24(s1)
  if(r)
    80000b44:	c485                	beqz	s1,80000b6c <kalloc+0x42>
    kmem.freelist = r->next;
    80000b46:	609c                	ld	a5,0(s1)
    80000b48:	00010517          	auipc	a0,0x10
    80000b4c:	0a850513          	addi	a0,a0,168 # 80010bf0 <kmem>
    80000b50:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b52:	140000ef          	jal	80000c92 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b56:	6605                	lui	a2,0x1
    80000b58:	4595                	li	a1,5
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	172000ef          	jal	80000cce <memset>
  return (void*)r;
}
    80000b60:	8526                	mv	a0,s1
    80000b62:	60e2                	ld	ra,24(sp)
    80000b64:	6442                	ld	s0,16(sp)
    80000b66:	64a2                	ld	s1,8(sp)
    80000b68:	6105                	addi	sp,sp,32
    80000b6a:	8082                	ret
  release(&kmem.lock);
    80000b6c:	00010517          	auipc	a0,0x10
    80000b70:	08450513          	addi	a0,a0,132 # 80010bf0 <kmem>
    80000b74:	11e000ef          	jal	80000c92 <release>
  if(r)
    80000b78:	b7e5                	j	80000b60 <kalloc+0x36>

0000000080000b7a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b7a:	1141                	addi	sp,sp,-16
    80000b7c:	e406                	sd	ra,8(sp)
    80000b7e:	e022                	sd	s0,0(sp)
    80000b80:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b82:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b84:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b88:	00053823          	sd	zero,16(a0)
}
    80000b8c:	60a2                	ld	ra,8(sp)
    80000b8e:	6402                	ld	s0,0(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret

0000000080000b94 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	411c                	lw	a5,0(a0)
    80000b96:	e399                	bnez	a5,80000b9c <holding+0x8>
    80000b98:	4501                	li	a0,0
  return r;
}
    80000b9a:	8082                	ret
{
    80000b9c:	1101                	addi	sp,sp,-32
    80000b9e:	ec06                	sd	ra,24(sp)
    80000ba0:	e822                	sd	s0,16(sp)
    80000ba2:	e426                	sd	s1,8(sp)
    80000ba4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba6:	6904                	ld	s1,16(a0)
    80000ba8:	515000ef          	jal	800018bc <mycpu>
    80000bac:	40a48533          	sub	a0,s1,a0
    80000bb0:	00153513          	seqz	a0,a0
}
    80000bb4:	60e2                	ld	ra,24(sp)
    80000bb6:	6442                	ld	s0,16(sp)
    80000bb8:	64a2                	ld	s1,8(sp)
    80000bba:	6105                	addi	sp,sp,32
    80000bbc:	8082                	ret

0000000080000bbe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bbe:	1101                	addi	sp,sp,-32
    80000bc0:	ec06                	sd	ra,24(sp)
    80000bc2:	e822                	sd	s0,16(sp)
    80000bc4:	e426                	sd	s1,8(sp)
    80000bc6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc8:	100024f3          	csrr	s1,sstatus
    80000bcc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bd6:	4e7000ef          	jal	800018bc <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	cb99                	beqz	a5,80000bf2 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bde:	4df000ef          	jal	800018bc <mycpu>
    80000be2:	5d3c                	lw	a5,120(a0)
    80000be4:	2785                	addiw	a5,a5,1
    80000be6:	dd3c                	sw	a5,120(a0)
}
    80000be8:	60e2                	ld	ra,24(sp)
    80000bea:	6442                	ld	s0,16(sp)
    80000bec:	64a2                	ld	s1,8(sp)
    80000bee:	6105                	addi	sp,sp,32
    80000bf0:	8082                	ret
    mycpu()->intena = old;
    80000bf2:	4cb000ef          	jal	800018bc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bf6:	8085                	srli	s1,s1,0x1
    80000bf8:	8885                	andi	s1,s1,1
    80000bfa:	dd64                	sw	s1,124(a0)
    80000bfc:	b7cd                	j	80000bde <push_off+0x20>

0000000080000bfe <acquire>:
{
    80000bfe:	1101                	addi	sp,sp,-32
    80000c00:	ec06                	sd	ra,24(sp)
    80000c02:	e822                	sd	s0,16(sp)
    80000c04:	e426                	sd	s1,8(sp)
    80000c06:	1000                	addi	s0,sp,32
    80000c08:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0a:	fb5ff0ef          	jal	80000bbe <push_off>
  if(holding(lk))
    80000c0e:	8526                	mv	a0,s1
    80000c10:	f85ff0ef          	jal	80000b94 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c14:	4705                	li	a4,1
  if(holding(lk))
    80000c16:	e105                	bnez	a0,80000c36 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c18:	87ba                	mv	a5,a4
    80000c1a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c1e:	2781                	sext.w	a5,a5
    80000c20:	ffe5                	bnez	a5,80000c18 <acquire+0x1a>
  __sync_synchronize();
    80000c22:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c26:	497000ef          	jal	800018bc <mycpu>
    80000c2a:	e888                	sd	a0,16(s1)
}
    80000c2c:	60e2                	ld	ra,24(sp)
    80000c2e:	6442                	ld	s0,16(sp)
    80000c30:	64a2                	ld	s1,8(sp)
    80000c32:	6105                	addi	sp,sp,32
    80000c34:	8082                	ret
    panic("acquire");
    80000c36:	00007517          	auipc	a0,0x7
    80000c3a:	41250513          	addi	a0,a0,1042 # 80008048 <etext+0x48>
    80000c3e:	b61ff0ef          	jal	8000079e <panic>

0000000080000c42 <pop_off>:

void
pop_off(void)
{
    80000c42:	1141                	addi	sp,sp,-16
    80000c44:	e406                	sd	ra,8(sp)
    80000c46:	e022                	sd	s0,0(sp)
    80000c48:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c4a:	473000ef          	jal	800018bc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c52:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c54:	e39d                	bnez	a5,80000c7a <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c56:	5d3c                	lw	a5,120(a0)
    80000c58:	02f05763          	blez	a5,80000c86 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c5c:	37fd                	addiw	a5,a5,-1
    80000c5e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c60:	eb89                	bnez	a5,80000c72 <pop_off+0x30>
    80000c62:	5d7c                	lw	a5,124(a0)
    80000c64:	c799                	beqz	a5,80000c72 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c6a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c6e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c72:	60a2                	ld	ra,8(sp)
    80000c74:	6402                	ld	s0,0(sp)
    80000c76:	0141                	addi	sp,sp,16
    80000c78:	8082                	ret
    panic("pop_off - interruptible");
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	3d650513          	addi	a0,a0,982 # 80008050 <etext+0x50>
    80000c82:	b1dff0ef          	jal	8000079e <panic>
    panic("pop_off");
    80000c86:	00007517          	auipc	a0,0x7
    80000c8a:	3e250513          	addi	a0,a0,994 # 80008068 <etext+0x68>
    80000c8e:	b11ff0ef          	jal	8000079e <panic>

0000000080000c92 <release>:
{
    80000c92:	1101                	addi	sp,sp,-32
    80000c94:	ec06                	sd	ra,24(sp)
    80000c96:	e822                	sd	s0,16(sp)
    80000c98:	e426                	sd	s1,8(sp)
    80000c9a:	1000                	addi	s0,sp,32
    80000c9c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c9e:	ef7ff0ef          	jal	80000b94 <holding>
    80000ca2:	c105                	beqz	a0,80000cc2 <release+0x30>
  lk->cpu = 0;
    80000ca4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca8:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cac:	0310000f          	fence	rw,w
    80000cb0:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cb4:	f8fff0ef          	jal	80000c42 <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3ae50513          	addi	a0,a0,942 # 80008070 <etext+0x70>
    80000cca:	ad5ff0ef          	jal	8000079e <panic>

0000000080000cce <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e406                	sd	ra,8(sp)
    80000cd2:	e022                	sd	s0,0(sp)
    80000cd4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd6:	ca19                	beqz	a2,80000cec <memset+0x1e>
    80000cd8:	87aa                	mv	a5,a0
    80000cda:	1602                	slli	a2,a2,0x20
    80000cdc:	9201                	srli	a2,a2,0x20
    80000cde:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce6:	0785                	addi	a5,a5,1
    80000ce8:	fee79de3          	bne	a5,a4,80000ce2 <memset+0x14>
  }
  return dst;
}
    80000cec:	60a2                	ld	ra,8(sp)
    80000cee:	6402                	ld	s0,0(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e406                	sd	ra,8(sp)
    80000cf8:	e022                	sd	s0,0(sp)
    80000cfa:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfc:	ca0d                	beqz	a2,80000d2e <memcmp+0x3a>
    80000cfe:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d02:	1682                	slli	a3,a3,0x20
    80000d04:	9281                	srli	a3,a3,0x20
    80000d06:	0685                	addi	a3,a3,1
    80000d08:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d0a:	00054783          	lbu	a5,0(a0)
    80000d0e:	0005c703          	lbu	a4,0(a1)
    80000d12:	00e79863          	bne	a5,a4,80000d22 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000d16:	0505                	addi	a0,a0,1
    80000d18:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d1a:	fed518e3          	bne	a0,a3,80000d0a <memcmp+0x16>
  }

  return 0;
    80000d1e:	4501                	li	a0,0
    80000d20:	a019                	j	80000d26 <memcmp+0x32>
      return *s1 - *s2;
    80000d22:	40e7853b          	subw	a0,a5,a4
}
    80000d26:	60a2                	ld	ra,8(sp)
    80000d28:	6402                	ld	s0,0(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	bfdd                	j	80000d26 <memcmp+0x32>

0000000080000d32 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e406                	sd	ra,8(sp)
    80000d36:	e022                	sd	s0,0(sp)
    80000d38:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d3a:	c205                	beqz	a2,80000d5a <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d3c:	02a5e363          	bltu	a1,a0,80000d62 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d40:	1602                	slli	a2,a2,0x20
    80000d42:	9201                	srli	a2,a2,0x20
    80000d44:	00c587b3          	add	a5,a1,a2
{
    80000d48:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d4a:	0585                	addi	a1,a1,1
    80000d4c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdade1>
    80000d4e:	fff5c683          	lbu	a3,-1(a1)
    80000d52:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d56:	feb79ae3          	bne	a5,a1,80000d4a <memmove+0x18>

  return dst;
}
    80000d5a:	60a2                	ld	ra,8(sp)
    80000d5c:	6402                	ld	s0,0(sp)
    80000d5e:	0141                	addi	sp,sp,16
    80000d60:	8082                	ret
  if(s < d && s + n > d){
    80000d62:	02061693          	slli	a3,a2,0x20
    80000d66:	9281                	srli	a3,a3,0x20
    80000d68:	00d58733          	add	a4,a1,a3
    80000d6c:	fce57ae3          	bgeu	a0,a4,80000d40 <memmove+0xe>
    d += n;
    80000d70:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d72:	fff6079b          	addiw	a5,a2,-1
    80000d76:	1782                	slli	a5,a5,0x20
    80000d78:	9381                	srli	a5,a5,0x20
    80000d7a:	fff7c793          	not	a5,a5
    80000d7e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d80:	177d                	addi	a4,a4,-1
    80000d82:	16fd                	addi	a3,a3,-1
    80000d84:	00074603          	lbu	a2,0(a4)
    80000d88:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d8c:	fee79ae3          	bne	a5,a4,80000d80 <memmove+0x4e>
    80000d90:	b7e9                	j	80000d5a <memmove+0x28>

0000000080000d92 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d92:	1141                	addi	sp,sp,-16
    80000d94:	e406                	sd	ra,8(sp)
    80000d96:	e022                	sd	s0,0(sp)
    80000d98:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d9a:	f99ff0ef          	jal	80000d32 <memmove>
}
    80000d9e:	60a2                	ld	ra,8(sp)
    80000da0:	6402                	ld	s0,0(sp)
    80000da2:	0141                	addi	sp,sp,16
    80000da4:	8082                	ret

0000000080000da6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da6:	1141                	addi	sp,sp,-16
    80000da8:	e406                	sd	ra,8(sp)
    80000daa:	e022                	sd	s0,0(sp)
    80000dac:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dae:	ce11                	beqz	a2,80000dca <strncmp+0x24>
    80000db0:	00054783          	lbu	a5,0(a0)
    80000db4:	cf89                	beqz	a5,80000dce <strncmp+0x28>
    80000db6:	0005c703          	lbu	a4,0(a1)
    80000dba:	00f71a63          	bne	a4,a5,80000dce <strncmp+0x28>
    n--, p++, q++;
    80000dbe:	367d                	addiw	a2,a2,-1
    80000dc0:	0505                	addi	a0,a0,1
    80000dc2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dc4:	f675                	bnez	a2,80000db0 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dc6:	4501                	li	a0,0
    80000dc8:	a801                	j	80000dd8 <strncmp+0x32>
    80000dca:	4501                	li	a0,0
    80000dcc:	a031                	j	80000dd8 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000dce:	00054503          	lbu	a0,0(a0)
    80000dd2:	0005c783          	lbu	a5,0(a1)
    80000dd6:	9d1d                	subw	a0,a0,a5
}
    80000dd8:	60a2                	ld	ra,8(sp)
    80000dda:	6402                	ld	s0,0(sp)
    80000ddc:	0141                	addi	sp,sp,16
    80000dde:	8082                	ret

0000000080000de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e406                	sd	ra,8(sp)
    80000de4:	e022                	sd	s0,0(sp)
    80000de6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de8:	87aa                	mv	a5,a0
    80000dea:	86b2                	mv	a3,a2
    80000dec:	367d                	addiw	a2,a2,-1
    80000dee:	02d05563          	blez	a3,80000e18 <strncpy+0x38>
    80000df2:	0785                	addi	a5,a5,1
    80000df4:	0005c703          	lbu	a4,0(a1)
    80000df8:	fee78fa3          	sb	a4,-1(a5)
    80000dfc:	0585                	addi	a1,a1,1
    80000dfe:	f775                	bnez	a4,80000dea <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e00:	873e                	mv	a4,a5
    80000e02:	00c05b63          	blez	a2,80000e18 <strncpy+0x38>
    80000e06:	9fb5                	addw	a5,a5,a3
    80000e08:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e0a:	0705                	addi	a4,a4,1
    80000e0c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e10:	40e786bb          	subw	a3,a5,a4
    80000e14:	fed04be3          	bgtz	a3,80000e0a <strncpy+0x2a>
  return os;
}
    80000e18:	60a2                	ld	ra,8(sp)
    80000e1a:	6402                	ld	s0,0(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret

0000000080000e20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e20:	1141                	addi	sp,sp,-16
    80000e22:	e406                	sd	ra,8(sp)
    80000e24:	e022                	sd	s0,0(sp)
    80000e26:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e28:	02c05363          	blez	a2,80000e4e <safestrcpy+0x2e>
    80000e2c:	fff6069b          	addiw	a3,a2,-1
    80000e30:	1682                	slli	a3,a3,0x20
    80000e32:	9281                	srli	a3,a3,0x20
    80000e34:	96ae                	add	a3,a3,a1
    80000e36:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e38:	00d58963          	beq	a1,a3,80000e4a <safestrcpy+0x2a>
    80000e3c:	0585                	addi	a1,a1,1
    80000e3e:	0785                	addi	a5,a5,1
    80000e40:	fff5c703          	lbu	a4,-1(a1)
    80000e44:	fee78fa3          	sb	a4,-1(a5)
    80000e48:	fb65                	bnez	a4,80000e38 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e4a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4e:	60a2                	ld	ra,8(sp)
    80000e50:	6402                	ld	s0,0(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret

0000000080000e56 <strlen>:

int
strlen(const char *s)
{
    80000e56:	1141                	addi	sp,sp,-16
    80000e58:	e406                	sd	ra,8(sp)
    80000e5a:	e022                	sd	s0,0(sp)
    80000e5c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e5e:	00054783          	lbu	a5,0(a0)
    80000e62:	cf99                	beqz	a5,80000e80 <strlen+0x2a>
    80000e64:	0505                	addi	a0,a0,1
    80000e66:	87aa                	mv	a5,a0
    80000e68:	86be                	mv	a3,a5
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff7c703          	lbu	a4,-1(a5)
    80000e70:	ff65                	bnez	a4,80000e68 <strlen+0x12>
    80000e72:	40a6853b          	subw	a0,a3,a0
    80000e76:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e78:	60a2                	ld	ra,8(sp)
    80000e7a:	6402                	ld	s0,0(sp)
    80000e7c:	0141                	addi	sp,sp,16
    80000e7e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e80:	4501                	li	a0,0
    80000e82:	bfdd                	j	80000e78 <strlen+0x22>

0000000080000e84 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e406                	sd	ra,8(sp)
    80000e88:	e022                	sd	s0,0(sp)
    80000e8a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e8c:	21d000ef          	jal	800018a8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e90:	00008717          	auipc	a4,0x8
    80000e94:	c2870713          	addi	a4,a4,-984 # 80008ab8 <started>
  if(cpuid() == 0){
    80000e98:	c51d                	beqz	a0,80000ec6 <main+0x42>
    while(started == 0)
    80000e9a:	431c                	lw	a5,0(a4)
    80000e9c:	2781                	sext.w	a5,a5
    80000e9e:	dff5                	beqz	a5,80000e9a <main+0x16>
      ;
    __sync_synchronize();
    80000ea0:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ea4:	205000ef          	jal	800018a8 <cpuid>
    80000ea8:	85aa                	mv	a1,a0
    80000eaa:	00007517          	auipc	a0,0x7
    80000eae:	1ee50513          	addi	a0,a0,494 # 80008098 <etext+0x98>
    80000eb2:	e1cff0ef          	jal	800004ce <printf>
    kvminithart();    // turn on paging
    80000eb6:	080000ef          	jal	80000f36 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eba:	572010ef          	jal	8000242c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ebe:	26b040ef          	jal	80005928 <plicinithart>
  }

  scheduler();        
    80000ec2:	64f000ef          	jal	80001d10 <scheduler>
    consoleinit();
    80000ec6:	d3aff0ef          	jal	80000400 <consoleinit>
    printfinit();
    80000eca:	90fff0ef          	jal	800007d8 <printfinit>
    printf("\n");
    80000ece:	00007517          	auipc	a0,0x7
    80000ed2:	1aa50513          	addi	a0,a0,426 # 80008078 <etext+0x78>
    80000ed6:	df8ff0ef          	jal	800004ce <printf>
    printf("xv6 kernel is booting\n");
    80000eda:	00007517          	auipc	a0,0x7
    80000ede:	1a650513          	addi	a0,a0,422 # 80008080 <etext+0x80>
    80000ee2:	decff0ef          	jal	800004ce <printf>
    printf("\n");
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	19250513          	addi	a0,a0,402 # 80008078 <etext+0x78>
    80000eee:	de0ff0ef          	jal	800004ce <printf>
    kinit();         // physical page allocator
    80000ef2:	c05ff0ef          	jal	80000af6 <kinit>
    kvminit();       // create kernel page table
    80000ef6:	2ce000ef          	jal	800011c4 <kvminit>
    kvminithart();   // turn on paging
    80000efa:	03c000ef          	jal	80000f36 <kvminithart>
    procinit();      // process table
    80000efe:	0fb000ef          	jal	800017f8 <procinit>
    trapinit();      // trap vectors
    80000f02:	506010ef          	jal	80002408 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f06:	526010ef          	jal	8000242c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f0a:	205040ef          	jal	8000590e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f0e:	21b040ef          	jal	80005928 <plicinithart>
    binit();         // buffer cache
    80000f12:	5ff010ef          	jal	80002d10 <binit>
    iinit();         // inode table
    80000f16:	3ca020ef          	jal	800032e0 <iinit>
    fileinit();      // file table
    80000f1a:	51a030ef          	jal	80004434 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f1e:	2fb040ef          	jal	80005a18 <virtio_disk_init>
    userinit();      // first user process
    80000f22:	423000ef          	jal	80001b44 <userinit>
    __sync_synchronize();
    80000f26:	0330000f          	fence	rw,rw
    started = 1;
    80000f2a:	4785                	li	a5,1
    80000f2c:	00008717          	auipc	a4,0x8
    80000f30:	b8f72623          	sw	a5,-1140(a4) # 80008ab8 <started>
    80000f34:	b779                	j	80000ec2 <main+0x3e>

0000000080000f36 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f36:	1141                	addi	sp,sp,-16
    80000f38:	e406                	sd	ra,8(sp)
    80000f3a:	e022                	sd	s0,0(sp)
    80000f3c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f3e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f42:	00008797          	auipc	a5,0x8
    80000f46:	b7e7b783          	ld	a5,-1154(a5) # 80008ac0 <kernel_pagetable>
    80000f4a:	83b1                	srli	a5,a5,0xc
    80000f4c:	577d                	li	a4,-1
    80000f4e:	177e                	slli	a4,a4,0x3f
    80000f50:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f52:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f56:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f5a:	60a2                	ld	ra,8(sp)
    80000f5c:	6402                	ld	s0,0(sp)
    80000f5e:	0141                	addi	sp,sp,16
    80000f60:	8082                	ret

0000000080000f62 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f62:	7139                	addi	sp,sp,-64
    80000f64:	fc06                	sd	ra,56(sp)
    80000f66:	f822                	sd	s0,48(sp)
    80000f68:	f426                	sd	s1,40(sp)
    80000f6a:	f04a                	sd	s2,32(sp)
    80000f6c:	ec4e                	sd	s3,24(sp)
    80000f6e:	e852                	sd	s4,16(sp)
    80000f70:	e456                	sd	s5,8(sp)
    80000f72:	e05a                	sd	s6,0(sp)
    80000f74:	0080                	addi	s0,sp,64
    80000f76:	84aa                	mv	s1,a0
    80000f78:	89ae                	mv	s3,a1
    80000f7a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f7c:	57fd                	li	a5,-1
    80000f7e:	83e9                	srli	a5,a5,0x1a
    80000f80:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f82:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f84:	04b7e263          	bltu	a5,a1,80000fc8 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f88:	0149d933          	srl	s2,s3,s4
    80000f8c:	1ff97913          	andi	s2,s2,511
    80000f90:	090e                	slli	s2,s2,0x3
    80000f92:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f94:	00093483          	ld	s1,0(s2)
    80000f98:	0014f793          	andi	a5,s1,1
    80000f9c:	cf85                	beqz	a5,80000fd4 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f9e:	80a9                	srli	s1,s1,0xa
    80000fa0:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fa2:	3a5d                	addiw	s4,s4,-9
    80000fa4:	ff6a12e3          	bne	s4,s6,80000f88 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fa8:	00c9d513          	srli	a0,s3,0xc
    80000fac:	1ff57513          	andi	a0,a0,511
    80000fb0:	050e                	slli	a0,a0,0x3
    80000fb2:	9526                	add	a0,a0,s1
}
    80000fb4:	70e2                	ld	ra,56(sp)
    80000fb6:	7442                	ld	s0,48(sp)
    80000fb8:	74a2                	ld	s1,40(sp)
    80000fba:	7902                	ld	s2,32(sp)
    80000fbc:	69e2                	ld	s3,24(sp)
    80000fbe:	6a42                	ld	s4,16(sp)
    80000fc0:	6aa2                	ld	s5,8(sp)
    80000fc2:	6b02                	ld	s6,0(sp)
    80000fc4:	6121                	addi	sp,sp,64
    80000fc6:	8082                	ret
    panic("walk");
    80000fc8:	00007517          	auipc	a0,0x7
    80000fcc:	0e850513          	addi	a0,a0,232 # 800080b0 <etext+0xb0>
    80000fd0:	fceff0ef          	jal	8000079e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fd4:	020a8263          	beqz	s5,80000ff8 <walk+0x96>
    80000fd8:	b53ff0ef          	jal	80000b2a <kalloc>
    80000fdc:	84aa                	mv	s1,a0
    80000fde:	d979                	beqz	a0,80000fb4 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fe0:	6605                	lui	a2,0x1
    80000fe2:	4581                	li	a1,0
    80000fe4:	cebff0ef          	jal	80000cce <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fe8:	00c4d793          	srli	a5,s1,0xc
    80000fec:	07aa                	slli	a5,a5,0xa
    80000fee:	0017e793          	ori	a5,a5,1
    80000ff2:	00f93023          	sd	a5,0(s2)
    80000ff6:	b775                	j	80000fa2 <walk+0x40>
        return 0;
    80000ff8:	4501                	li	a0,0
    80000ffa:	bf6d                	j	80000fb4 <walk+0x52>

0000000080000ffc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000ffc:	57fd                	li	a5,-1
    80000ffe:	83e9                	srli	a5,a5,0x1a
    80001000:	00b7f463          	bgeu	a5,a1,80001008 <walkaddr+0xc>
    return 0;
    80001004:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001006:	8082                	ret
{
    80001008:	1141                	addi	sp,sp,-16
    8000100a:	e406                	sd	ra,8(sp)
    8000100c:	e022                	sd	s0,0(sp)
    8000100e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001010:	4601                	li	a2,0
    80001012:	f51ff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    80001016:	c105                	beqz	a0,80001036 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001018:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000101a:	0117f693          	andi	a3,a5,17
    8000101e:	4745                	li	a4,17
    return 0;
    80001020:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001022:	00e68663          	beq	a3,a4,8000102e <walkaddr+0x32>
}
    80001026:	60a2                	ld	ra,8(sp)
    80001028:	6402                	ld	s0,0(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret
  pa = PTE2PA(*pte);
    8000102e:	83a9                	srli	a5,a5,0xa
    80001030:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001034:	bfcd                	j	80001026 <walkaddr+0x2a>
    return 0;
    80001036:	4501                	li	a0,0
    80001038:	b7fd                	j	80001026 <walkaddr+0x2a>

000000008000103a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000103a:	715d                	addi	sp,sp,-80
    8000103c:	e486                	sd	ra,72(sp)
    8000103e:	e0a2                	sd	s0,64(sp)
    80001040:	fc26                	sd	s1,56(sp)
    80001042:	f84a                	sd	s2,48(sp)
    80001044:	f44e                	sd	s3,40(sp)
    80001046:	f052                	sd	s4,32(sp)
    80001048:	ec56                	sd	s5,24(sp)
    8000104a:	e85a                	sd	s6,16(sp)
    8000104c:	e45e                	sd	s7,8(sp)
    8000104e:	e062                	sd	s8,0(sp)
    80001050:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001052:	03459793          	slli	a5,a1,0x34
    80001056:	e7b1                	bnez	a5,800010a2 <mappages+0x68>
    80001058:	8aaa                	mv	s5,a0
    8000105a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000105c:	03461793          	slli	a5,a2,0x34
    80001060:	e7b9                	bnez	a5,800010ae <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    80001062:	ce21                	beqz	a2,800010ba <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001064:	77fd                	lui	a5,0xfffff
    80001066:	963e                	add	a2,a2,a5
    80001068:	00b609b3          	add	s3,a2,a1
  a = va;
    8000106c:	892e                	mv	s2,a1
    8000106e:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001072:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001074:	6c05                	lui	s8,0x1
    80001076:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	865e                	mv	a2,s7
    8000107c:	85ca                	mv	a1,s2
    8000107e:	8556                	mv	a0,s5
    80001080:	ee3ff0ef          	jal	80000f62 <walk>
    80001084:	c539                	beqz	a0,800010d2 <mappages+0x98>
    if(*pte & PTE_V)
    80001086:	611c                	ld	a5,0(a0)
    80001088:	8b85                	andi	a5,a5,1
    8000108a:	ef95                	bnez	a5,800010c6 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000108c:	80b1                	srli	s1,s1,0xc
    8000108e:	04aa                	slli	s1,s1,0xa
    80001090:	0164e4b3          	or	s1,s1,s6
    80001094:	0014e493          	ori	s1,s1,1
    80001098:	e104                	sd	s1,0(a0)
    if(a == last)
    8000109a:	05390963          	beq	s2,s3,800010ec <mappages+0xb2>
    a += PGSIZE;
    8000109e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a0:	bfd9                	j	80001076 <mappages+0x3c>
    panic("mappages: va not aligned");
    800010a2:	00007517          	auipc	a0,0x7
    800010a6:	01650513          	addi	a0,a0,22 # 800080b8 <etext+0xb8>
    800010aa:	ef4ff0ef          	jal	8000079e <panic>
    panic("mappages: size not aligned");
    800010ae:	00007517          	auipc	a0,0x7
    800010b2:	02a50513          	addi	a0,a0,42 # 800080d8 <etext+0xd8>
    800010b6:	ee8ff0ef          	jal	8000079e <panic>
    panic("mappages: size");
    800010ba:	00007517          	auipc	a0,0x7
    800010be:	03e50513          	addi	a0,a0,62 # 800080f8 <etext+0xf8>
    800010c2:	edcff0ef          	jal	8000079e <panic>
      panic("mappages: remap");
    800010c6:	00007517          	auipc	a0,0x7
    800010ca:	04250513          	addi	a0,a0,66 # 80008108 <etext+0x108>
    800010ce:	ed0ff0ef          	jal	8000079e <panic>
      return -1;
    800010d2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010d4:	60a6                	ld	ra,72(sp)
    800010d6:	6406                	ld	s0,64(sp)
    800010d8:	74e2                	ld	s1,56(sp)
    800010da:	7942                	ld	s2,48(sp)
    800010dc:	79a2                	ld	s3,40(sp)
    800010de:	7a02                	ld	s4,32(sp)
    800010e0:	6ae2                	ld	s5,24(sp)
    800010e2:	6b42                	ld	s6,16(sp)
    800010e4:	6ba2                	ld	s7,8(sp)
    800010e6:	6c02                	ld	s8,0(sp)
    800010e8:	6161                	addi	sp,sp,80
    800010ea:	8082                	ret
  return 0;
    800010ec:	4501                	li	a0,0
    800010ee:	b7dd                	j	800010d4 <mappages+0x9a>

00000000800010f0 <kvmmap>:
{
    800010f0:	1141                	addi	sp,sp,-16
    800010f2:	e406                	sd	ra,8(sp)
    800010f4:	e022                	sd	s0,0(sp)
    800010f6:	0800                	addi	s0,sp,16
    800010f8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010fa:	86b2                	mv	a3,a2
    800010fc:	863e                	mv	a2,a5
    800010fe:	f3dff0ef          	jal	8000103a <mappages>
    80001102:	e509                	bnez	a0,8000110c <kvmmap+0x1c>
}
    80001104:	60a2                	ld	ra,8(sp)
    80001106:	6402                	ld	s0,0(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret
    panic("kvmmap");
    8000110c:	00007517          	auipc	a0,0x7
    80001110:	00c50513          	addi	a0,a0,12 # 80008118 <etext+0x118>
    80001114:	e8aff0ef          	jal	8000079e <panic>

0000000080001118 <kvmmake>:
{
    80001118:	1101                	addi	sp,sp,-32
    8000111a:	ec06                	sd	ra,24(sp)
    8000111c:	e822                	sd	s0,16(sp)
    8000111e:	e426                	sd	s1,8(sp)
    80001120:	e04a                	sd	s2,0(sp)
    80001122:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001124:	a07ff0ef          	jal	80000b2a <kalloc>
    80001128:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000112a:	6605                	lui	a2,0x1
    8000112c:	4581                	li	a1,0
    8000112e:	ba1ff0ef          	jal	80000cce <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001132:	4719                	li	a4,6
    80001134:	6685                	lui	a3,0x1
    80001136:	10000637          	lui	a2,0x10000
    8000113a:	85b2                	mv	a1,a2
    8000113c:	8526                	mv	a0,s1
    8000113e:	fb3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001142:	4719                	li	a4,6
    80001144:	6685                	lui	a3,0x1
    80001146:	10001637          	lui	a2,0x10001
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	fa3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001152:	4719                	li	a4,6
    80001154:	040006b7          	lui	a3,0x4000
    80001158:	0c000637          	lui	a2,0xc000
    8000115c:	85b2                	mv	a1,a2
    8000115e:	8526                	mv	a0,s1
    80001160:	f91ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001164:	00007917          	auipc	s2,0x7
    80001168:	e9c90913          	addi	s2,s2,-356 # 80008000 <etext>
    8000116c:	4729                	li	a4,10
    8000116e:	80007697          	auipc	a3,0x80007
    80001172:	e9268693          	addi	a3,a3,-366 # 8000 <_entry-0x7fff8000>
    80001176:	4605                	li	a2,1
    80001178:	067e                	slli	a2,a2,0x1f
    8000117a:	85b2                	mv	a1,a2
    8000117c:	8526                	mv	a0,s1
    8000117e:	f73ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001182:	4719                	li	a4,6
    80001184:	46c5                	li	a3,17
    80001186:	06ee                	slli	a3,a3,0x1b
    80001188:	412686b3          	sub	a3,a3,s2
    8000118c:	864a                	mv	a2,s2
    8000118e:	85ca                	mv	a1,s2
    80001190:	8526                	mv	a0,s1
    80001192:	f5fff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001196:	4729                	li	a4,10
    80001198:	6685                	lui	a3,0x1
    8000119a:	00006617          	auipc	a2,0x6
    8000119e:	e6660613          	addi	a2,a2,-410 # 80007000 <_trampoline>
    800011a2:	040005b7          	lui	a1,0x4000
    800011a6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a8:	05b2                	slli	a1,a1,0xc
    800011aa:	8526                	mv	a0,s1
    800011ac:	f45ff0ef          	jal	800010f0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011b0:	8526                	mv	a0,s1
    800011b2:	5a8000ef          	jal	8000175a <proc_mapstacks>
}
    800011b6:	8526                	mv	a0,s1
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6902                	ld	s2,0(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <kvminit>:
{
    800011c4:	1141                	addi	sp,sp,-16
    800011c6:	e406                	sd	ra,8(sp)
    800011c8:	e022                	sd	s0,0(sp)
    800011ca:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011cc:	f4dff0ef          	jal	80001118 <kvmmake>
    800011d0:	00008797          	auipc	a5,0x8
    800011d4:	8ea7b823          	sd	a0,-1808(a5) # 80008ac0 <kernel_pagetable>
}
    800011d8:	60a2                	ld	ra,8(sp)
    800011da:	6402                	ld	s0,0(sp)
    800011dc:	0141                	addi	sp,sp,16
    800011de:	8082                	ret

00000000800011e0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e0:	715d                	addi	sp,sp,-80
    800011e2:	e486                	sd	ra,72(sp)
    800011e4:	e0a2                	sd	s0,64(sp)
    800011e6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011e8:	03459793          	slli	a5,a1,0x34
    800011ec:	e39d                	bnez	a5,80001212 <uvmunmap+0x32>
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    800011fa:	8a2a                	mv	s4,a0
    800011fc:	892e                	mv	s2,a1
    800011fe:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001200:	0632                	slli	a2,a2,0xc
    80001202:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001206:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001208:	6b05                	lui	s6,0x1
    8000120a:	0735ff63          	bgeu	a1,s3,80001288 <uvmunmap+0xa8>
    8000120e:	fc26                	sd	s1,56(sp)
    80001210:	a0a9                	j	8000125a <uvmunmap+0x7a>
    80001212:	fc26                	sd	s1,56(sp)
    80001214:	f84a                	sd	s2,48(sp)
    80001216:	f44e                	sd	s3,40(sp)
    80001218:	f052                	sd	s4,32(sp)
    8000121a:	ec56                	sd	s5,24(sp)
    8000121c:	e85a                	sd	s6,16(sp)
    8000121e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001220:	00007517          	auipc	a0,0x7
    80001224:	f0050513          	addi	a0,a0,-256 # 80008120 <etext+0x120>
    80001228:	d76ff0ef          	jal	8000079e <panic>
      panic("uvmunmap: walk");
    8000122c:	00007517          	auipc	a0,0x7
    80001230:	f0c50513          	addi	a0,a0,-244 # 80008138 <etext+0x138>
    80001234:	d6aff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not mapped");
    80001238:	00007517          	auipc	a0,0x7
    8000123c:	f1050513          	addi	a0,a0,-240 # 80008148 <etext+0x148>
    80001240:	d5eff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not a leaf");
    80001244:	00007517          	auipc	a0,0x7
    80001248:	f1c50513          	addi	a0,a0,-228 # 80008160 <etext+0x160>
    8000124c:	d52ff0ef          	jal	8000079e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001250:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001254:	995a                	add	s2,s2,s6
    80001256:	03397863          	bgeu	s2,s3,80001286 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000125a:	4601                	li	a2,0
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8552                	mv	a0,s4
    80001260:	d03ff0ef          	jal	80000f62 <walk>
    80001264:	84aa                	mv	s1,a0
    80001266:	d179                	beqz	a0,8000122c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001268:	6108                	ld	a0,0(a0)
    8000126a:	00157793          	andi	a5,a0,1
    8000126e:	d7e9                	beqz	a5,80001238 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001270:	3ff57793          	andi	a5,a0,1023
    80001274:	fd7788e3          	beq	a5,s7,80001244 <uvmunmap+0x64>
    if(do_free){
    80001278:	fc0a8ce3          	beqz	s5,80001250 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000127c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000127e:	0532                	slli	a0,a0,0xc
    80001280:	fc8ff0ef          	jal	80000a48 <kfree>
    80001284:	b7f1                	j	80001250 <uvmunmap+0x70>
    80001286:	74e2                	ld	s1,56(sp)
    80001288:	7942                	ld	s2,48(sp)
    8000128a:	79a2                	ld	s3,40(sp)
    8000128c:	7a02                	ld	s4,32(sp)
    8000128e:	6ae2                	ld	s5,24(sp)
    80001290:	6b42                	ld	s6,16(sp)
    80001292:	6ba2                	ld	s7,8(sp)
  }
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	6161                	addi	sp,sp,80
    8000129a:	8082                	ret

000000008000129c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000129c:	1101                	addi	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012a6:	885ff0ef          	jal	80000b2a <kalloc>
    800012aa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012ac:	c509                	beqz	a0,800012b6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012ae:	6605                	lui	a2,0x1
    800012b0:	4581                	li	a1,0
    800012b2:	a1dff0ef          	jal	80000cce <memset>
  return pagetable;
}
    800012b6:	8526                	mv	a0,s1
    800012b8:	60e2                	ld	ra,24(sp)
    800012ba:	6442                	ld	s0,16(sp)
    800012bc:	64a2                	ld	s1,8(sp)
    800012be:	6105                	addi	sp,sp,32
    800012c0:	8082                	ret

00000000800012c2 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012c2:	7179                	addi	sp,sp,-48
    800012c4:	f406                	sd	ra,40(sp)
    800012c6:	f022                	sd	s0,32(sp)
    800012c8:	ec26                	sd	s1,24(sp)
    800012ca:	e84a                	sd	s2,16(sp)
    800012cc:	e44e                	sd	s3,8(sp)
    800012ce:	e052                	sd	s4,0(sp)
    800012d0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012d2:	6785                	lui	a5,0x1
    800012d4:	04f67063          	bgeu	a2,a5,80001314 <uvmfirst+0x52>
    800012d8:	8a2a                	mv	s4,a0
    800012da:	89ae                	mv	s3,a1
    800012dc:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012de:	84dff0ef          	jal	80000b2a <kalloc>
    800012e2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012e4:	6605                	lui	a2,0x1
    800012e6:	4581                	li	a1,0
    800012e8:	9e7ff0ef          	jal	80000cce <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012ec:	4779                	li	a4,30
    800012ee:	86ca                	mv	a3,s2
    800012f0:	6605                	lui	a2,0x1
    800012f2:	4581                	li	a1,0
    800012f4:	8552                	mv	a0,s4
    800012f6:	d45ff0ef          	jal	8000103a <mappages>
  memmove(mem, src, sz);
    800012fa:	8626                	mv	a2,s1
    800012fc:	85ce                	mv	a1,s3
    800012fe:	854a                	mv	a0,s2
    80001300:	a33ff0ef          	jal	80000d32 <memmove>
}
    80001304:	70a2                	ld	ra,40(sp)
    80001306:	7402                	ld	s0,32(sp)
    80001308:	64e2                	ld	s1,24(sp)
    8000130a:	6942                	ld	s2,16(sp)
    8000130c:	69a2                	ld	s3,8(sp)
    8000130e:	6a02                	ld	s4,0(sp)
    80001310:	6145                	addi	sp,sp,48
    80001312:	8082                	ret
    panic("uvmfirst: more than a page");
    80001314:	00007517          	auipc	a0,0x7
    80001318:	e6450513          	addi	a0,a0,-412 # 80008178 <etext+0x178>
    8000131c:	c82ff0ef          	jal	8000079e <panic>

0000000080001320 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001320:	1101                	addi	sp,sp,-32
    80001322:	ec06                	sd	ra,24(sp)
    80001324:	e822                	sd	s0,16(sp)
    80001326:	e426                	sd	s1,8(sp)
    80001328:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000132a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000132c:	00b67d63          	bgeu	a2,a1,80001346 <uvmdealloc+0x26>
    80001330:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001332:	6785                	lui	a5,0x1
    80001334:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001336:	00f60733          	add	a4,a2,a5
    8000133a:	76fd                	lui	a3,0xfffff
    8000133c:	8f75                	and	a4,a4,a3
    8000133e:	97ae                	add	a5,a5,a1
    80001340:	8ff5                	and	a5,a5,a3
    80001342:	00f76863          	bltu	a4,a5,80001352 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001346:	8526                	mv	a0,s1
    80001348:	60e2                	ld	ra,24(sp)
    8000134a:	6442                	ld	s0,16(sp)
    8000134c:	64a2                	ld	s1,8(sp)
    8000134e:	6105                	addi	sp,sp,32
    80001350:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001352:	8f99                	sub	a5,a5,a4
    80001354:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001356:	4685                	li	a3,1
    80001358:	0007861b          	sext.w	a2,a5
    8000135c:	85ba                	mv	a1,a4
    8000135e:	e83ff0ef          	jal	800011e0 <uvmunmap>
    80001362:	b7d5                	j	80001346 <uvmdealloc+0x26>

0000000080001364 <uvmalloc>:
  if(newsz < oldsz)
    80001364:	0ab66363          	bltu	a2,a1,8000140a <uvmalloc+0xa6>
{
    80001368:	715d                	addi	sp,sp,-80
    8000136a:	e486                	sd	ra,72(sp)
    8000136c:	e0a2                	sd	s0,64(sp)
    8000136e:	f052                	sd	s4,32(sp)
    80001370:	ec56                	sd	s5,24(sp)
    80001372:	e85a                	sd	s6,16(sp)
    80001374:	0880                	addi	s0,sp,80
    80001376:	8b2a                	mv	s6,a0
    80001378:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000137a:	6785                	lui	a5,0x1
    8000137c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000137e:	95be                	add	a1,a1,a5
    80001380:	77fd                	lui	a5,0xfffff
    80001382:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001386:	08ca7463          	bgeu	s4,a2,8000140e <uvmalloc+0xaa>
    8000138a:	fc26                	sd	s1,56(sp)
    8000138c:	f84a                	sd	s2,48(sp)
    8000138e:	f44e                	sd	s3,40(sp)
    80001390:	e45e                	sd	s7,8(sp)
    80001392:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80001394:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001396:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000139a:	f90ff0ef          	jal	80000b2a <kalloc>
    8000139e:	84aa                	mv	s1,a0
    if(mem == 0){
    800013a0:	c515                	beqz	a0,800013cc <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800013a2:	864e                	mv	a2,s3
    800013a4:	4581                	li	a1,0
    800013a6:	929ff0ef          	jal	80000cce <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013aa:	875e                	mv	a4,s7
    800013ac:	86a6                	mv	a3,s1
    800013ae:	864e                	mv	a2,s3
    800013b0:	85ca                	mv	a1,s2
    800013b2:	855a                	mv	a0,s6
    800013b4:	c87ff0ef          	jal	8000103a <mappages>
    800013b8:	e91d                	bnez	a0,800013ee <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013ba:	994e                	add	s2,s2,s3
    800013bc:	fd596fe3          	bltu	s2,s5,8000139a <uvmalloc+0x36>
  return newsz;
    800013c0:	8556                	mv	a0,s5
    800013c2:	74e2                	ld	s1,56(sp)
    800013c4:	7942                	ld	s2,48(sp)
    800013c6:	79a2                	ld	s3,40(sp)
    800013c8:	6ba2                	ld	s7,8(sp)
    800013ca:	a819                	j	800013e0 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    800013cc:	8652                	mv	a2,s4
    800013ce:	85ca                	mv	a1,s2
    800013d0:	855a                	mv	a0,s6
    800013d2:	f4fff0ef          	jal	80001320 <uvmdealloc>
      return 0;
    800013d6:	4501                	li	a0,0
    800013d8:	74e2                	ld	s1,56(sp)
    800013da:	7942                	ld	s2,48(sp)
    800013dc:	79a2                	ld	s3,40(sp)
    800013de:	6ba2                	ld	s7,8(sp)
}
    800013e0:	60a6                	ld	ra,72(sp)
    800013e2:	6406                	ld	s0,64(sp)
    800013e4:	7a02                	ld	s4,32(sp)
    800013e6:	6ae2                	ld	s5,24(sp)
    800013e8:	6b42                	ld	s6,16(sp)
    800013ea:	6161                	addi	sp,sp,80
    800013ec:	8082                	ret
      kfree(mem);
    800013ee:	8526                	mv	a0,s1
    800013f0:	e58ff0ef          	jal	80000a48 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013f4:	8652                	mv	a2,s4
    800013f6:	85ca                	mv	a1,s2
    800013f8:	855a                	mv	a0,s6
    800013fa:	f27ff0ef          	jal	80001320 <uvmdealloc>
      return 0;
    800013fe:	4501                	li	a0,0
    80001400:	74e2                	ld	s1,56(sp)
    80001402:	7942                	ld	s2,48(sp)
    80001404:	79a2                	ld	s3,40(sp)
    80001406:	6ba2                	ld	s7,8(sp)
    80001408:	bfe1                	j	800013e0 <uvmalloc+0x7c>
    return oldsz;
    8000140a:	852e                	mv	a0,a1
}
    8000140c:	8082                	ret
  return newsz;
    8000140e:	8532                	mv	a0,a2
    80001410:	bfc1                	j	800013e0 <uvmalloc+0x7c>

0000000080001412 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001412:	7179                	addi	sp,sp,-48
    80001414:	f406                	sd	ra,40(sp)
    80001416:	f022                	sd	s0,32(sp)
    80001418:	ec26                	sd	s1,24(sp)
    8000141a:	e84a                	sd	s2,16(sp)
    8000141c:	e44e                	sd	s3,8(sp)
    8000141e:	e052                	sd	s4,0(sp)
    80001420:	1800                	addi	s0,sp,48
    80001422:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001424:	84aa                	mv	s1,a0
    80001426:	6905                	lui	s2,0x1
    80001428:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000142a:	4985                	li	s3,1
    8000142c:	a819                	j	80001442 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000142e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001430:	00c79513          	slli	a0,a5,0xc
    80001434:	fdfff0ef          	jal	80001412 <freewalk>
      pagetable[i] = 0;
    80001438:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000143c:	04a1                	addi	s1,s1,8
    8000143e:	01248f63          	beq	s1,s2,8000145c <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001442:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001444:	00f7f713          	andi	a4,a5,15
    80001448:	ff3703e3          	beq	a4,s3,8000142e <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000144c:	8b85                	andi	a5,a5,1
    8000144e:	d7fd                	beqz	a5,8000143c <freewalk+0x2a>
      panic("freewalk: leaf");
    80001450:	00007517          	auipc	a0,0x7
    80001454:	d4850513          	addi	a0,a0,-696 # 80008198 <etext+0x198>
    80001458:	b46ff0ef          	jal	8000079e <panic>
    }
  }
  kfree((void*)pagetable);
    8000145c:	8552                	mv	a0,s4
    8000145e:	deaff0ef          	jal	80000a48 <kfree>
}
    80001462:	70a2                	ld	ra,40(sp)
    80001464:	7402                	ld	s0,32(sp)
    80001466:	64e2                	ld	s1,24(sp)
    80001468:	6942                	ld	s2,16(sp)
    8000146a:	69a2                	ld	s3,8(sp)
    8000146c:	6a02                	ld	s4,0(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret

0000000080001472 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001472:	1101                	addi	sp,sp,-32
    80001474:	ec06                	sd	ra,24(sp)
    80001476:	e822                	sd	s0,16(sp)
    80001478:	e426                	sd	s1,8(sp)
    8000147a:	1000                	addi	s0,sp,32
    8000147c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000147e:	e989                	bnez	a1,80001490 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001480:	8526                	mv	a0,s1
    80001482:	f91ff0ef          	jal	80001412 <freewalk>
}
    80001486:	60e2                	ld	ra,24(sp)
    80001488:	6442                	ld	s0,16(sp)
    8000148a:	64a2                	ld	s1,8(sp)
    8000148c:	6105                	addi	sp,sp,32
    8000148e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001490:	6785                	lui	a5,0x1
    80001492:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001494:	95be                	add	a1,a1,a5
    80001496:	4685                	li	a3,1
    80001498:	00c5d613          	srli	a2,a1,0xc
    8000149c:	4581                	li	a1,0
    8000149e:	d43ff0ef          	jal	800011e0 <uvmunmap>
    800014a2:	bff9                	j	80001480 <uvmfree+0xe>

00000000800014a4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014a4:	ca4d                	beqz	a2,80001556 <uvmcopy+0xb2>
{
    800014a6:	715d                	addi	sp,sp,-80
    800014a8:	e486                	sd	ra,72(sp)
    800014aa:	e0a2                	sd	s0,64(sp)
    800014ac:	fc26                	sd	s1,56(sp)
    800014ae:	f84a                	sd	s2,48(sp)
    800014b0:	f44e                	sd	s3,40(sp)
    800014b2:	f052                	sd	s4,32(sp)
    800014b4:	ec56                	sd	s5,24(sp)
    800014b6:	e85a                	sd	s6,16(sp)
    800014b8:	e45e                	sd	s7,8(sp)
    800014ba:	e062                	sd	s8,0(sp)
    800014bc:	0880                	addi	s0,sp,80
    800014be:	8baa                	mv	s7,a0
    800014c0:	8b2e                	mv	s6,a1
    800014c2:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014c4:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014c6:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    800014c8:	4601                	li	a2,0
    800014ca:	85ce                	mv	a1,s3
    800014cc:	855e                	mv	a0,s7
    800014ce:	a95ff0ef          	jal	80000f62 <walk>
    800014d2:	cd1d                	beqz	a0,80001510 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    800014d4:	6118                	ld	a4,0(a0)
    800014d6:	00177793          	andi	a5,a4,1
    800014da:	c3a9                	beqz	a5,8000151c <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    800014dc:	00a75593          	srli	a1,a4,0xa
    800014e0:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014e4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014e8:	e42ff0ef          	jal	80000b2a <kalloc>
    800014ec:	892a                	mv	s2,a0
    800014ee:	c121                	beqz	a0,8000152e <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    800014f0:	8652                	mv	a2,s4
    800014f2:	85e2                	mv	a1,s8
    800014f4:	83fff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014f8:	8726                	mv	a4,s1
    800014fa:	86ca                	mv	a3,s2
    800014fc:	8652                	mv	a2,s4
    800014fe:	85ce                	mv	a1,s3
    80001500:	855a                	mv	a0,s6
    80001502:	b39ff0ef          	jal	8000103a <mappages>
    80001506:	e10d                	bnez	a0,80001528 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80001508:	99d2                	add	s3,s3,s4
    8000150a:	fb59efe3          	bltu	s3,s5,800014c8 <uvmcopy+0x24>
    8000150e:	a805                	j	8000153e <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80001510:	00007517          	auipc	a0,0x7
    80001514:	c9850513          	addi	a0,a0,-872 # 800081a8 <etext+0x1a8>
    80001518:	a86ff0ef          	jal	8000079e <panic>
      panic("uvmcopy: page not present");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	cac50513          	addi	a0,a0,-852 # 800081c8 <etext+0x1c8>
    80001524:	a7aff0ef          	jal	8000079e <panic>
      kfree(mem);
    80001528:	854a                	mv	a0,s2
    8000152a:	d1eff0ef          	jal	80000a48 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000152e:	4685                	li	a3,1
    80001530:	00c9d613          	srli	a2,s3,0xc
    80001534:	4581                	li	a1,0
    80001536:	855a                	mv	a0,s6
    80001538:	ca9ff0ef          	jal	800011e0 <uvmunmap>
  return -1;
    8000153c:	557d                	li	a0,-1
}
    8000153e:	60a6                	ld	ra,72(sp)
    80001540:	6406                	ld	s0,64(sp)
    80001542:	74e2                	ld	s1,56(sp)
    80001544:	7942                	ld	s2,48(sp)
    80001546:	79a2                	ld	s3,40(sp)
    80001548:	7a02                	ld	s4,32(sp)
    8000154a:	6ae2                	ld	s5,24(sp)
    8000154c:	6b42                	ld	s6,16(sp)
    8000154e:	6ba2                	ld	s7,8(sp)
    80001550:	6c02                	ld	s8,0(sp)
    80001552:	6161                	addi	sp,sp,80
    80001554:	8082                	ret
  return 0;
    80001556:	4501                	li	a0,0
}
    80001558:	8082                	ret

000000008000155a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000155a:	1141                	addi	sp,sp,-16
    8000155c:	e406                	sd	ra,8(sp)
    8000155e:	e022                	sd	s0,0(sp)
    80001560:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001562:	4601                	li	a2,0
    80001564:	9ffff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    80001568:	c901                	beqz	a0,80001578 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000156a:	611c                	ld	a5,0(a0)
    8000156c:	9bbd                	andi	a5,a5,-17
    8000156e:	e11c                	sd	a5,0(a0)
}
    80001570:	60a2                	ld	ra,8(sp)
    80001572:	6402                	ld	s0,0(sp)
    80001574:	0141                	addi	sp,sp,16
    80001576:	8082                	ret
    panic("uvmclear");
    80001578:	00007517          	auipc	a0,0x7
    8000157c:	c7050513          	addi	a0,a0,-912 # 800081e8 <etext+0x1e8>
    80001580:	a1eff0ef          	jal	8000079e <panic>

0000000080001584 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001584:	c2d9                	beqz	a3,8000160a <copyout+0x86>
{
    80001586:	711d                	addi	sp,sp,-96
    80001588:	ec86                	sd	ra,88(sp)
    8000158a:	e8a2                	sd	s0,80(sp)
    8000158c:	e4a6                	sd	s1,72(sp)
    8000158e:	e0ca                	sd	s2,64(sp)
    80001590:	fc4e                	sd	s3,56(sp)
    80001592:	f852                	sd	s4,48(sp)
    80001594:	f456                	sd	s5,40(sp)
    80001596:	f05a                	sd	s6,32(sp)
    80001598:	ec5e                	sd	s7,24(sp)
    8000159a:	e862                	sd	s8,16(sp)
    8000159c:	e466                	sd	s9,8(sp)
    8000159e:	e06a                	sd	s10,0(sp)
    800015a0:	1080                	addi	s0,sp,96
    800015a2:	8c2a                	mv	s8,a0
    800015a4:	892e                	mv	s2,a1
    800015a6:	8ab2                	mv	s5,a2
    800015a8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800015aa:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    800015ac:	5bfd                	li	s7,-1
    800015ae:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015b2:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    800015b4:	6b05                	lui	s6,0x1
    800015b6:	a015                	j	800015da <copyout+0x56>
    pa0 = PTE2PA(*pte);
    800015b8:	83a9                	srli	a5,a5,0xa
    800015ba:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015bc:	41390533          	sub	a0,s2,s3
    800015c0:	0004861b          	sext.w	a2,s1
    800015c4:	85d6                	mv	a1,s5
    800015c6:	953e                	add	a0,a0,a5
    800015c8:	f6aff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015cc:	409a0a33          	sub	s4,s4,s1
    src += n;
    800015d0:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    800015d2:	01698933          	add	s2,s3,s6
  while(len > 0){
    800015d6:	020a0863          	beqz	s4,80001606 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    800015da:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    800015de:	033be863          	bltu	s7,s3,8000160e <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    800015e2:	4601                	li	a2,0
    800015e4:	85ce                	mv	a1,s3
    800015e6:	8562                	mv	a0,s8
    800015e8:	97bff0ef          	jal	80000f62 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ec:	c121                	beqz	a0,8000162c <copyout+0xa8>
    800015ee:	611c                	ld	a5,0(a0)
    800015f0:	0157f713          	andi	a4,a5,21
    800015f4:	03a71e63          	bne	a4,s10,80001630 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    800015f8:	412984b3          	sub	s1,s3,s2
    800015fc:	94da                	add	s1,s1,s6
    if(n > len)
    800015fe:	fa9a7de3          	bgeu	s4,s1,800015b8 <copyout+0x34>
    80001602:	84d2                	mv	s1,s4
    80001604:	bf55                	j	800015b8 <copyout+0x34>
  }
  return 0;
    80001606:	4501                	li	a0,0
    80001608:	a021                	j	80001610 <copyout+0x8c>
    8000160a:	4501                	li	a0,0
}
    8000160c:	8082                	ret
      return -1;
    8000160e:	557d                	li	a0,-1
}
    80001610:	60e6                	ld	ra,88(sp)
    80001612:	6446                	ld	s0,80(sp)
    80001614:	64a6                	ld	s1,72(sp)
    80001616:	6906                	ld	s2,64(sp)
    80001618:	79e2                	ld	s3,56(sp)
    8000161a:	7a42                	ld	s4,48(sp)
    8000161c:	7aa2                	ld	s5,40(sp)
    8000161e:	7b02                	ld	s6,32(sp)
    80001620:	6be2                	ld	s7,24(sp)
    80001622:	6c42                	ld	s8,16(sp)
    80001624:	6ca2                	ld	s9,8(sp)
    80001626:	6d02                	ld	s10,0(sp)
    80001628:	6125                	addi	sp,sp,96
    8000162a:	8082                	ret
      return -1;
    8000162c:	557d                	li	a0,-1
    8000162e:	b7cd                	j	80001610 <copyout+0x8c>
    80001630:	557d                	li	a0,-1
    80001632:	bff9                	j	80001610 <copyout+0x8c>

0000000080001634 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001634:	c6a5                	beqz	a3,8000169c <copyin+0x68>
{
    80001636:	715d                	addi	sp,sp,-80
    80001638:	e486                	sd	ra,72(sp)
    8000163a:	e0a2                	sd	s0,64(sp)
    8000163c:	fc26                	sd	s1,56(sp)
    8000163e:	f84a                	sd	s2,48(sp)
    80001640:	f44e                	sd	s3,40(sp)
    80001642:	f052                	sd	s4,32(sp)
    80001644:	ec56                	sd	s5,24(sp)
    80001646:	e85a                	sd	s6,16(sp)
    80001648:	e45e                	sd	s7,8(sp)
    8000164a:	e062                	sd	s8,0(sp)
    8000164c:	0880                	addi	s0,sp,80
    8000164e:	8b2a                	mv	s6,a0
    80001650:	8a2e                	mv	s4,a1
    80001652:	8c32                	mv	s8,a2
    80001654:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001656:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001658:	6a85                	lui	s5,0x1
    8000165a:	a00d                	j	8000167c <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000165c:	018505b3          	add	a1,a0,s8
    80001660:	0004861b          	sext.w	a2,s1
    80001664:	412585b3          	sub	a1,a1,s2
    80001668:	8552                	mv	a0,s4
    8000166a:	ec8ff0ef          	jal	80000d32 <memmove>

    len -= n;
    8000166e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001672:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001674:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001678:	02098063          	beqz	s3,80001698 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    8000167c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001680:	85ca                	mv	a1,s2
    80001682:	855a                	mv	a0,s6
    80001684:	979ff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0)
    80001688:	cd01                	beqz	a0,800016a0 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000168a:	418904b3          	sub	s1,s2,s8
    8000168e:	94d6                	add	s1,s1,s5
    if(n > len)
    80001690:	fc99f6e3          	bgeu	s3,s1,8000165c <copyin+0x28>
    80001694:	84ce                	mv	s1,s3
    80001696:	b7d9                	j	8000165c <copyin+0x28>
  }
  return 0;
    80001698:	4501                	li	a0,0
    8000169a:	a021                	j	800016a2 <copyin+0x6e>
    8000169c:	4501                	li	a0,0
}
    8000169e:	8082                	ret
      return -1;
    800016a0:	557d                	li	a0,-1
}
    800016a2:	60a6                	ld	ra,72(sp)
    800016a4:	6406                	ld	s0,64(sp)
    800016a6:	74e2                	ld	s1,56(sp)
    800016a8:	7942                	ld	s2,48(sp)
    800016aa:	79a2                	ld	s3,40(sp)
    800016ac:	7a02                	ld	s4,32(sp)
    800016ae:	6ae2                	ld	s5,24(sp)
    800016b0:	6b42                	ld	s6,16(sp)
    800016b2:	6ba2                	ld	s7,8(sp)
    800016b4:	6c02                	ld	s8,0(sp)
    800016b6:	6161                	addi	sp,sp,80
    800016b8:	8082                	ret

00000000800016ba <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800016ba:	715d                	addi	sp,sp,-80
    800016bc:	e486                	sd	ra,72(sp)
    800016be:	e0a2                	sd	s0,64(sp)
    800016c0:	fc26                	sd	s1,56(sp)
    800016c2:	f84a                	sd	s2,48(sp)
    800016c4:	f44e                	sd	s3,40(sp)
    800016c6:	f052                	sd	s4,32(sp)
    800016c8:	ec56                	sd	s5,24(sp)
    800016ca:	e85a                	sd	s6,16(sp)
    800016cc:	e45e                	sd	s7,8(sp)
    800016ce:	0880                	addi	s0,sp,80
    800016d0:	8aaa                	mv	s5,a0
    800016d2:	89ae                	mv	s3,a1
    800016d4:	8bb2                	mv	s7,a2
    800016d6:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    800016d8:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016da:	6a05                	lui	s4,0x1
    800016dc:	a02d                	j	80001706 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016de:	00078023          	sb	zero,0(a5)
    800016e2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016e4:	0017c793          	xori	a5,a5,1
    800016e8:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016ec:	60a6                	ld	ra,72(sp)
    800016ee:	6406                	ld	s0,64(sp)
    800016f0:	74e2                	ld	s1,56(sp)
    800016f2:	7942                	ld	s2,48(sp)
    800016f4:	79a2                	ld	s3,40(sp)
    800016f6:	7a02                	ld	s4,32(sp)
    800016f8:	6ae2                	ld	s5,24(sp)
    800016fa:	6b42                	ld	s6,16(sp)
    800016fc:	6ba2                	ld	s7,8(sp)
    800016fe:	6161                	addi	sp,sp,80
    80001700:	8082                	ret
    srcva = va0 + PGSIZE;
    80001702:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001706:	c4b1                	beqz	s1,80001752 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80001708:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000170c:	85ca                	mv	a1,s2
    8000170e:	8556                	mv	a0,s5
    80001710:	8edff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0)
    80001714:	c129                	beqz	a0,80001756 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80001716:	41790633          	sub	a2,s2,s7
    8000171a:	9652                	add	a2,a2,s4
    if(n > max)
    8000171c:	00c4f363          	bgeu	s1,a2,80001722 <copyinstr+0x68>
    80001720:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001722:	412b8bb3          	sub	s7,s7,s2
    80001726:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001728:	de69                	beqz	a2,80001702 <copyinstr+0x48>
    8000172a:	87ce                	mv	a5,s3
      if(*p == '\0'){
    8000172c:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001730:	964e                	add	a2,a2,s3
    80001732:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001734:	00f68733          	add	a4,a3,a5
    80001738:	00074703          	lbu	a4,0(a4)
    8000173c:	d34d                	beqz	a4,800016de <copyinstr+0x24>
        *dst = *p;
    8000173e:	00e78023          	sb	a4,0(a5)
      dst++;
    80001742:	0785                	addi	a5,a5,1
    while(n > 0){
    80001744:	fec797e3          	bne	a5,a2,80001732 <copyinstr+0x78>
    80001748:	14fd                	addi	s1,s1,-1
    8000174a:	94ce                	add	s1,s1,s3
      --max;
    8000174c:	8c8d                	sub	s1,s1,a1
    8000174e:	89be                	mv	s3,a5
    80001750:	bf4d                	j	80001702 <copyinstr+0x48>
    80001752:	4781                	li	a5,0
    80001754:	bf41                	j	800016e4 <copyinstr+0x2a>
      return -1;
    80001756:	557d                	li	a0,-1
    80001758:	bf51                	j	800016ec <copyinstr+0x32>

000000008000175a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	e062                	sd	s8,0(sp)
    80001770:	0880                	addi	s0,sp,80
    80001772:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001774:	00010497          	auipc	s1,0x10
    80001778:	8cc48493          	addi	s1,s1,-1844 # 80011040 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000177c:	8c26                	mv	s8,s1
    8000177e:	a4fa57b7          	lui	a5,0xa4fa5
    80001782:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f80d85>
    80001786:	4fa50937          	lui	s2,0x4fa50
    8000178a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    8000178e:	1902                	slli	s2,s2,0x20
    80001790:	993e                	add	s2,s2,a5
    80001792:	040009b7          	lui	s3,0x4000
    80001796:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001798:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000179a:	4b99                	li	s7,6
    8000179c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179e:	00015a97          	auipc	s5,0x15
    800017a2:	2a2a8a93          	addi	s5,s5,674 # 80016a40 <tickslock>
    char *pa = kalloc();
    800017a6:	b84ff0ef          	jal	80000b2a <kalloc>
    800017aa:	862a                	mv	a2,a0
    if(pa == 0)
    800017ac:	c121                	beqz	a0,800017ec <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    800017ae:	418485b3          	sub	a1,s1,s8
    800017b2:	858d                	srai	a1,a1,0x3
    800017b4:	032585b3          	mul	a1,a1,s2
    800017b8:	2585                	addiw	a1,a1,1
    800017ba:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017be:	875e                	mv	a4,s7
    800017c0:	86da                	mv	a3,s6
    800017c2:	40b985b3          	sub	a1,s3,a1
    800017c6:	8552                	mv	a0,s4
    800017c8:	929ff0ef          	jal	800010f0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017cc:	16848493          	addi	s1,s1,360
    800017d0:	fd549be3          	bne	s1,s5,800017a6 <proc_mapstacks+0x4c>
  }
}
    800017d4:	60a6                	ld	ra,72(sp)
    800017d6:	6406                	ld	s0,64(sp)
    800017d8:	74e2                	ld	s1,56(sp)
    800017da:	7942                	ld	s2,48(sp)
    800017dc:	79a2                	ld	s3,40(sp)
    800017de:	7a02                	ld	s4,32(sp)
    800017e0:	6ae2                	ld	s5,24(sp)
    800017e2:	6b42                	ld	s6,16(sp)
    800017e4:	6ba2                	ld	s7,8(sp)
    800017e6:	6c02                	ld	s8,0(sp)
    800017e8:	6161                	addi	sp,sp,80
    800017ea:	8082                	ret
      panic("kalloc");
    800017ec:	00007517          	auipc	a0,0x7
    800017f0:	a0c50513          	addi	a0,a0,-1524 # 800081f8 <etext+0x1f8>
    800017f4:	fabfe0ef          	jal	8000079e <panic>

00000000800017f8 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017f8:	7139                	addi	sp,sp,-64
    800017fa:	fc06                	sd	ra,56(sp)
    800017fc:	f822                	sd	s0,48(sp)
    800017fe:	f426                	sd	s1,40(sp)
    80001800:	f04a                	sd	s2,32(sp)
    80001802:	ec4e                	sd	s3,24(sp)
    80001804:	e852                	sd	s4,16(sp)
    80001806:	e456                	sd	s5,8(sp)
    80001808:	e05a                	sd	s6,0(sp)
    8000180a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000180c:	00007597          	auipc	a1,0x7
    80001810:	9f458593          	addi	a1,a1,-1548 # 80008200 <etext+0x200>
    80001814:	0000f517          	auipc	a0,0xf
    80001818:	3fc50513          	addi	a0,a0,1020 # 80010c10 <pid_lock>
    8000181c:	b5eff0ef          	jal	80000b7a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001820:	00007597          	auipc	a1,0x7
    80001824:	9e858593          	addi	a1,a1,-1560 # 80008208 <etext+0x208>
    80001828:	0000f517          	auipc	a0,0xf
    8000182c:	40050513          	addi	a0,a0,1024 # 80010c28 <wait_lock>
    80001830:	b4aff0ef          	jal	80000b7a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001834:	00010497          	auipc	s1,0x10
    80001838:	80c48493          	addi	s1,s1,-2036 # 80011040 <proc>
      initlock(&p->lock, "proc");
    8000183c:	00007b17          	auipc	s6,0x7
    80001840:	9dcb0b13          	addi	s6,s6,-1572 # 80008218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001844:	8aa6                	mv	s5,s1
    80001846:	a4fa57b7          	lui	a5,0xa4fa5
    8000184a:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f80d85>
    8000184e:	4fa50937          	lui	s2,0x4fa50
    80001852:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80001856:	1902                	slli	s2,s2,0x20
    80001858:	993e                	add	s2,s2,a5
    8000185a:	040009b7          	lui	s3,0x4000
    8000185e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001860:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001862:	00015a17          	auipc	s4,0x15
    80001866:	1dea0a13          	addi	s4,s4,478 # 80016a40 <tickslock>
      initlock(&p->lock, "proc");
    8000186a:	85da                	mv	a1,s6
    8000186c:	8526                	mv	a0,s1
    8000186e:	b0cff0ef          	jal	80000b7a <initlock>
      p->state = UNUSED;
    80001872:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001876:	415487b3          	sub	a5,s1,s5
    8000187a:	878d                	srai	a5,a5,0x3
    8000187c:	032787b3          	mul	a5,a5,s2
    80001880:	2785                	addiw	a5,a5,1
    80001882:	00d7979b          	slliw	a5,a5,0xd
    80001886:	40f987b3          	sub	a5,s3,a5
    8000188a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188c:	16848493          	addi	s1,s1,360
    80001890:	fd449de3          	bne	s1,s4,8000186a <procinit+0x72>
  }
}
    80001894:	70e2                	ld	ra,56(sp)
    80001896:	7442                	ld	s0,48(sp)
    80001898:	74a2                	ld	s1,40(sp)
    8000189a:	7902                	ld	s2,32(sp)
    8000189c:	69e2                	ld	s3,24(sp)
    8000189e:	6a42                	ld	s4,16(sp)
    800018a0:	6aa2                	ld	s5,8(sp)
    800018a2:	6b02                	ld	s6,0(sp)
    800018a4:	6121                	addi	sp,sp,64
    800018a6:	8082                	ret

00000000800018a8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018a8:	1141                	addi	sp,sp,-16
    800018aa:	e406                	sd	ra,8(sp)
    800018ac:	e022                	sd	s0,0(sp)
    800018ae:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018b0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b2:	2501                	sext.w	a0,a0
    800018b4:	60a2                	ld	ra,8(sp)
    800018b6:	6402                	ld	s0,0(sp)
    800018b8:	0141                	addi	sp,sp,16
    800018ba:	8082                	ret

00000000800018bc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018bc:	1141                	addi	sp,sp,-16
    800018be:	e406                	sd	ra,8(sp)
    800018c0:	e022                	sd	s0,0(sp)
    800018c2:	0800                	addi	s0,sp,16
    800018c4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018c6:	2781                	sext.w	a5,a5
    800018c8:	079e                	slli	a5,a5,0x7
  return c;
}
    800018ca:	0000f517          	auipc	a0,0xf
    800018ce:	37650513          	addi	a0,a0,886 # 80010c40 <cpus>
    800018d2:	953e                	add	a0,a0,a5
    800018d4:	60a2                	ld	ra,8(sp)
    800018d6:	6402                	ld	s0,0(sp)
    800018d8:	0141                	addi	sp,sp,16
    800018da:	8082                	ret

00000000800018dc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018dc:	1101                	addi	sp,sp,-32
    800018de:	ec06                	sd	ra,24(sp)
    800018e0:	e822                	sd	s0,16(sp)
    800018e2:	e426                	sd	s1,8(sp)
    800018e4:	1000                	addi	s0,sp,32
  push_off();
    800018e6:	ad8ff0ef          	jal	80000bbe <push_off>
    800018ea:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
    800018f0:	0000f717          	auipc	a4,0xf
    800018f4:	32070713          	addi	a4,a4,800 # 80010c10 <pid_lock>
    800018f8:	97ba                	add	a5,a5,a4
    800018fa:	7b84                	ld	s1,48(a5)
  pop_off();
    800018fc:	b46ff0ef          	jal	80000c42 <pop_off>
  return p;
}
    80001900:	8526                	mv	a0,s1
    80001902:	60e2                	ld	ra,24(sp)
    80001904:	6442                	ld	s0,16(sp)
    80001906:	64a2                	ld	s1,8(sp)
    80001908:	6105                	addi	sp,sp,32
    8000190a:	8082                	ret

000000008000190c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000190c:	1141                	addi	sp,sp,-16
    8000190e:	e406                	sd	ra,8(sp)
    80001910:	e022                	sd	s0,0(sp)
    80001912:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001914:	fc9ff0ef          	jal	800018dc <myproc>
    80001918:	b7aff0ef          	jal	80000c92 <release>

  if (first) {
    8000191c:	00007797          	auipc	a5,0x7
    80001920:	1347a783          	lw	a5,308(a5) # 80008a50 <first.1>
    80001924:	e799                	bnez	a5,80001932 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001926:	323000ef          	jal	80002448 <usertrapret>
}
    8000192a:	60a2                	ld	ra,8(sp)
    8000192c:	6402                	ld	s0,0(sp)
    8000192e:	0141                	addi	sp,sp,16
    80001930:	8082                	ret
    fsinit(ROOTDEV);
    80001932:	4505                	li	a0,1
    80001934:	141010ef          	jal	80003274 <fsinit>
    first = 0;
    80001938:	00007797          	auipc	a5,0x7
    8000193c:	1007ac23          	sw	zero,280(a5) # 80008a50 <first.1>
    __sync_synchronize();
    80001940:	0330000f          	fence	rw,rw
    80001944:	b7cd                	j	80001926 <forkret+0x1a>

0000000080001946 <allocpid>:
{
    80001946:	1101                	addi	sp,sp,-32
    80001948:	ec06                	sd	ra,24(sp)
    8000194a:	e822                	sd	s0,16(sp)
    8000194c:	e426                	sd	s1,8(sp)
    8000194e:	e04a                	sd	s2,0(sp)
    80001950:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001952:	0000f917          	auipc	s2,0xf
    80001956:	2be90913          	addi	s2,s2,702 # 80010c10 <pid_lock>
    8000195a:	854a                	mv	a0,s2
    8000195c:	aa2ff0ef          	jal	80000bfe <acquire>
  pid = nextpid;
    80001960:	00007797          	auipc	a5,0x7
    80001964:	0f478793          	addi	a5,a5,244 # 80008a54 <nextpid>
    80001968:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000196a:	0014871b          	addiw	a4,s1,1
    8000196e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001970:	854a                	mv	a0,s2
    80001972:	b20ff0ef          	jal	80000c92 <release>
}
    80001976:	8526                	mv	a0,s1
    80001978:	60e2                	ld	ra,24(sp)
    8000197a:	6442                	ld	s0,16(sp)
    8000197c:	64a2                	ld	s1,8(sp)
    8000197e:	6902                	ld	s2,0(sp)
    80001980:	6105                	addi	sp,sp,32
    80001982:	8082                	ret

0000000080001984 <proc_pagetable>:
{
    80001984:	1101                	addi	sp,sp,-32
    80001986:	ec06                	sd	ra,24(sp)
    80001988:	e822                	sd	s0,16(sp)
    8000198a:	e426                	sd	s1,8(sp)
    8000198c:	e04a                	sd	s2,0(sp)
    8000198e:	1000                	addi	s0,sp,32
    80001990:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001992:	90bff0ef          	jal	8000129c <uvmcreate>
    80001996:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001998:	cd05                	beqz	a0,800019d0 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000199a:	4729                	li	a4,10
    8000199c:	00005697          	auipc	a3,0x5
    800019a0:	66468693          	addi	a3,a3,1636 # 80007000 <_trampoline>
    800019a4:	6605                	lui	a2,0x1
    800019a6:	040005b7          	lui	a1,0x4000
    800019aa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019ac:	05b2                	slli	a1,a1,0xc
    800019ae:	e8cff0ef          	jal	8000103a <mappages>
    800019b2:	02054663          	bltz	a0,800019de <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019b6:	4719                	li	a4,6
    800019b8:	05893683          	ld	a3,88(s2)
    800019bc:	6605                	lui	a2,0x1
    800019be:	020005b7          	lui	a1,0x2000
    800019c2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019c4:	05b6                	slli	a1,a1,0xd
    800019c6:	8526                	mv	a0,s1
    800019c8:	e72ff0ef          	jal	8000103a <mappages>
    800019cc:	00054f63          	bltz	a0,800019ea <proc_pagetable+0x66>
}
    800019d0:	8526                	mv	a0,s1
    800019d2:	60e2                	ld	ra,24(sp)
    800019d4:	6442                	ld	s0,16(sp)
    800019d6:	64a2                	ld	s1,8(sp)
    800019d8:	6902                	ld	s2,0(sp)
    800019da:	6105                	addi	sp,sp,32
    800019dc:	8082                	ret
    uvmfree(pagetable, 0);
    800019de:	4581                	li	a1,0
    800019e0:	8526                	mv	a0,s1
    800019e2:	a91ff0ef          	jal	80001472 <uvmfree>
    return 0;
    800019e6:	4481                	li	s1,0
    800019e8:	b7e5                	j	800019d0 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019ea:	4681                	li	a3,0
    800019ec:	4605                	li	a2,1
    800019ee:	040005b7          	lui	a1,0x4000
    800019f2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019f4:	05b2                	slli	a1,a1,0xc
    800019f6:	8526                	mv	a0,s1
    800019f8:	fe8ff0ef          	jal	800011e0 <uvmunmap>
    uvmfree(pagetable, 0);
    800019fc:	4581                	li	a1,0
    800019fe:	8526                	mv	a0,s1
    80001a00:	a73ff0ef          	jal	80001472 <uvmfree>
    return 0;
    80001a04:	4481                	li	s1,0
    80001a06:	b7e9                	j	800019d0 <proc_pagetable+0x4c>

0000000080001a08 <proc_freepagetable>:
{
    80001a08:	1101                	addi	sp,sp,-32
    80001a0a:	ec06                	sd	ra,24(sp)
    80001a0c:	e822                	sd	s0,16(sp)
    80001a0e:	e426                	sd	s1,8(sp)
    80001a10:	e04a                	sd	s2,0(sp)
    80001a12:	1000                	addi	s0,sp,32
    80001a14:	84aa                	mv	s1,a0
    80001a16:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a18:	4681                	li	a3,0
    80001a1a:	4605                	li	a2,1
    80001a1c:	040005b7          	lui	a1,0x4000
    80001a20:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a22:	05b2                	slli	a1,a1,0xc
    80001a24:	fbcff0ef          	jal	800011e0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a28:	4681                	li	a3,0
    80001a2a:	4605                	li	a2,1
    80001a2c:	020005b7          	lui	a1,0x2000
    80001a30:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a32:	05b6                	slli	a1,a1,0xd
    80001a34:	8526                	mv	a0,s1
    80001a36:	faaff0ef          	jal	800011e0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a3a:	85ca                	mv	a1,s2
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	a35ff0ef          	jal	80001472 <uvmfree>
}
    80001a42:	60e2                	ld	ra,24(sp)
    80001a44:	6442                	ld	s0,16(sp)
    80001a46:	64a2                	ld	s1,8(sp)
    80001a48:	6902                	ld	s2,0(sp)
    80001a4a:	6105                	addi	sp,sp,32
    80001a4c:	8082                	ret

0000000080001a4e <freeproc>:
{
    80001a4e:	1101                	addi	sp,sp,-32
    80001a50:	ec06                	sd	ra,24(sp)
    80001a52:	e822                	sd	s0,16(sp)
    80001a54:	e426                	sd	s1,8(sp)
    80001a56:	1000                	addi	s0,sp,32
    80001a58:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a5a:	6d28                	ld	a0,88(a0)
    80001a5c:	c119                	beqz	a0,80001a62 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a5e:	febfe0ef          	jal	80000a48 <kfree>
  p->trapframe = 0;
    80001a62:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a66:	68a8                	ld	a0,80(s1)
    80001a68:	c501                	beqz	a0,80001a70 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a6a:	64ac                	ld	a1,72(s1)
    80001a6c:	f9dff0ef          	jal	80001a08 <proc_freepagetable>
  p->pagetable = 0;
    80001a70:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a74:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a78:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a7c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a80:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a84:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a88:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a8c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a90:	0004ac23          	sw	zero,24(s1)
}
    80001a94:	60e2                	ld	ra,24(sp)
    80001a96:	6442                	ld	s0,16(sp)
    80001a98:	64a2                	ld	s1,8(sp)
    80001a9a:	6105                	addi	sp,sp,32
    80001a9c:	8082                	ret

0000000080001a9e <allocproc>:
{
    80001a9e:	1101                	addi	sp,sp,-32
    80001aa0:	ec06                	sd	ra,24(sp)
    80001aa2:	e822                	sd	s0,16(sp)
    80001aa4:	e426                	sd	s1,8(sp)
    80001aa6:	e04a                	sd	s2,0(sp)
    80001aa8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aaa:	0000f497          	auipc	s1,0xf
    80001aae:	59648493          	addi	s1,s1,1430 # 80011040 <proc>
    80001ab2:	00015917          	auipc	s2,0x15
    80001ab6:	f8e90913          	addi	s2,s2,-114 # 80016a40 <tickslock>
    acquire(&p->lock);
    80001aba:	8526                	mv	a0,s1
    80001abc:	942ff0ef          	jal	80000bfe <acquire>
    if(p->state == UNUSED) {
    80001ac0:	4c9c                	lw	a5,24(s1)
    80001ac2:	cb91                	beqz	a5,80001ad6 <allocproc+0x38>
      release(&p->lock);
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	9ccff0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aca:	16848493          	addi	s1,s1,360
    80001ace:	ff2496e3          	bne	s1,s2,80001aba <allocproc+0x1c>
  return 0;
    80001ad2:	4481                	li	s1,0
    80001ad4:	a089                	j	80001b16 <allocproc+0x78>
  p->pid = allocpid();
    80001ad6:	e71ff0ef          	jal	80001946 <allocpid>
    80001ada:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001adc:	4785                	li	a5,1
    80001ade:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ae0:	84aff0ef          	jal	80000b2a <kalloc>
    80001ae4:	892a                	mv	s2,a0
    80001ae6:	eca8                	sd	a0,88(s1)
    80001ae8:	cd15                	beqz	a0,80001b24 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001aea:	8526                	mv	a0,s1
    80001aec:	e99ff0ef          	jal	80001984 <proc_pagetable>
    80001af0:	892a                	mv	s2,a0
    80001af2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001af4:	c121                	beqz	a0,80001b34 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001af6:	07000613          	li	a2,112
    80001afa:	4581                	li	a1,0
    80001afc:	06048513          	addi	a0,s1,96
    80001b00:	9ceff0ef          	jal	80000cce <memset>
  p->context.ra = (uint64)forkret;
    80001b04:	00000797          	auipc	a5,0x0
    80001b08:	e0878793          	addi	a5,a5,-504 # 8000190c <forkret>
    80001b0c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b0e:	60bc                	ld	a5,64(s1)
    80001b10:	6705                	lui	a4,0x1
    80001b12:	97ba                	add	a5,a5,a4
    80001b14:	f4bc                	sd	a5,104(s1)
}
    80001b16:	8526                	mv	a0,s1
    80001b18:	60e2                	ld	ra,24(sp)
    80001b1a:	6442                	ld	s0,16(sp)
    80001b1c:	64a2                	ld	s1,8(sp)
    80001b1e:	6902                	ld	s2,0(sp)
    80001b20:	6105                	addi	sp,sp,32
    80001b22:	8082                	ret
    freeproc(p);
    80001b24:	8526                	mv	a0,s1
    80001b26:	f29ff0ef          	jal	80001a4e <freeproc>
    release(&p->lock);
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	966ff0ef          	jal	80000c92 <release>
    return 0;
    80001b30:	84ca                	mv	s1,s2
    80001b32:	b7d5                	j	80001b16 <allocproc+0x78>
    freeproc(p);
    80001b34:	8526                	mv	a0,s1
    80001b36:	f19ff0ef          	jal	80001a4e <freeproc>
    release(&p->lock);
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	956ff0ef          	jal	80000c92 <release>
    return 0;
    80001b40:	84ca                	mv	s1,s2
    80001b42:	bfd1                	j	80001b16 <allocproc+0x78>

0000000080001b44 <userinit>:
{
    80001b44:	1101                	addi	sp,sp,-32
    80001b46:	ec06                	sd	ra,24(sp)
    80001b48:	e822                	sd	s0,16(sp)
    80001b4a:	e426                	sd	s1,8(sp)
    80001b4c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b4e:	f51ff0ef          	jal	80001a9e <allocproc>
    80001b52:	84aa                	mv	s1,a0
  initproc = p;
    80001b54:	00007797          	auipc	a5,0x7
    80001b58:	f6a7ba23          	sd	a0,-140(a5) # 80008ac8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b5c:	03400613          	li	a2,52
    80001b60:	00007597          	auipc	a1,0x7
    80001b64:	f0058593          	addi	a1,a1,-256 # 80008a60 <initcode>
    80001b68:	6928                	ld	a0,80(a0)
    80001b6a:	f58ff0ef          	jal	800012c2 <uvmfirst>
  p->sz = PGSIZE;
    80001b6e:	6785                	lui	a5,0x1
    80001b70:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b72:	6cb8                	ld	a4,88(s1)
    80001b74:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b78:	6cb8                	ld	a4,88(s1)
    80001b7a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b7c:	4641                	li	a2,16
    80001b7e:	00006597          	auipc	a1,0x6
    80001b82:	6a258593          	addi	a1,a1,1698 # 80008220 <etext+0x220>
    80001b86:	15848513          	addi	a0,s1,344
    80001b8a:	a96ff0ef          	jal	80000e20 <safestrcpy>
  p->cwd = namei("/");
    80001b8e:	00006517          	auipc	a0,0x6
    80001b92:	6a250513          	addi	a0,a0,1698 # 80008230 <etext+0x230>
    80001b96:	384020ef          	jal	80003f1a <namei>
    80001b9a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b9e:	478d                	li	a5,3
    80001ba0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	8eeff0ef          	jal	80000c92 <release>
}
    80001ba8:	60e2                	ld	ra,24(sp)
    80001baa:	6442                	ld	s0,16(sp)
    80001bac:	64a2                	ld	s1,8(sp)
    80001bae:	6105                	addi	sp,sp,32
    80001bb0:	8082                	ret

0000000080001bb2 <growproc>:
{
    80001bb2:	1101                	addi	sp,sp,-32
    80001bb4:	ec06                	sd	ra,24(sp)
    80001bb6:	e822                	sd	s0,16(sp)
    80001bb8:	e426                	sd	s1,8(sp)
    80001bba:	e04a                	sd	s2,0(sp)
    80001bbc:	1000                	addi	s0,sp,32
    80001bbe:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bc0:	d1dff0ef          	jal	800018dc <myproc>
    80001bc4:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bc6:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bc8:	01204c63          	bgtz	s2,80001be0 <growproc+0x2e>
  } else if(n < 0){
    80001bcc:	02094463          	bltz	s2,80001bf4 <growproc+0x42>
  p->sz = sz;
    80001bd0:	e4ac                	sd	a1,72(s1)
  return 0;
    80001bd2:	4501                	li	a0,0
}
    80001bd4:	60e2                	ld	ra,24(sp)
    80001bd6:	6442                	ld	s0,16(sp)
    80001bd8:	64a2                	ld	s1,8(sp)
    80001bda:	6902                	ld	s2,0(sp)
    80001bdc:	6105                	addi	sp,sp,32
    80001bde:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001be0:	4691                	li	a3,4
    80001be2:	00b90633          	add	a2,s2,a1
    80001be6:	6928                	ld	a0,80(a0)
    80001be8:	f7cff0ef          	jal	80001364 <uvmalloc>
    80001bec:	85aa                	mv	a1,a0
    80001bee:	f16d                	bnez	a0,80001bd0 <growproc+0x1e>
      return -1;
    80001bf0:	557d                	li	a0,-1
    80001bf2:	b7cd                	j	80001bd4 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001bf4:	00b90633          	add	a2,s2,a1
    80001bf8:	6928                	ld	a0,80(a0)
    80001bfa:	f26ff0ef          	jal	80001320 <uvmdealloc>
    80001bfe:	85aa                	mv	a1,a0
    80001c00:	bfc1                	j	80001bd0 <growproc+0x1e>

0000000080001c02 <fork>:
{
    80001c02:	7139                	addi	sp,sp,-64
    80001c04:	fc06                	sd	ra,56(sp)
    80001c06:	f822                	sd	s0,48(sp)
    80001c08:	f04a                	sd	s2,32(sp)
    80001c0a:	e456                	sd	s5,8(sp)
    80001c0c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c0e:	ccfff0ef          	jal	800018dc <myproc>
    80001c12:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c14:	e8bff0ef          	jal	80001a9e <allocproc>
    80001c18:	0e050a63          	beqz	a0,80001d0c <fork+0x10a>
    80001c1c:	e852                	sd	s4,16(sp)
    80001c1e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c20:	048ab603          	ld	a2,72(s5)
    80001c24:	692c                	ld	a1,80(a0)
    80001c26:	050ab503          	ld	a0,80(s5)
    80001c2a:	87bff0ef          	jal	800014a4 <uvmcopy>
    80001c2e:	04054a63          	bltz	a0,80001c82 <fork+0x80>
    80001c32:	f426                	sd	s1,40(sp)
    80001c34:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c36:	048ab783          	ld	a5,72(s5)
    80001c3a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c3e:	058ab683          	ld	a3,88(s5)
    80001c42:	87b6                	mv	a5,a3
    80001c44:	058a3703          	ld	a4,88(s4)
    80001c48:	12068693          	addi	a3,a3,288
    80001c4c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c50:	6788                	ld	a0,8(a5)
    80001c52:	6b8c                	ld	a1,16(a5)
    80001c54:	6f90                	ld	a2,24(a5)
    80001c56:	01073023          	sd	a6,0(a4)
    80001c5a:	e708                	sd	a0,8(a4)
    80001c5c:	eb0c                	sd	a1,16(a4)
    80001c5e:	ef10                	sd	a2,24(a4)
    80001c60:	02078793          	addi	a5,a5,32
    80001c64:	02070713          	addi	a4,a4,32
    80001c68:	fed792e3          	bne	a5,a3,80001c4c <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c6c:	058a3783          	ld	a5,88(s4)
    80001c70:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c74:	0d0a8493          	addi	s1,s5,208
    80001c78:	0d0a0913          	addi	s2,s4,208
    80001c7c:	150a8993          	addi	s3,s5,336
    80001c80:	a831                	j	80001c9c <fork+0x9a>
    freeproc(np);
    80001c82:	8552                	mv	a0,s4
    80001c84:	dcbff0ef          	jal	80001a4e <freeproc>
    release(&np->lock);
    80001c88:	8552                	mv	a0,s4
    80001c8a:	808ff0ef          	jal	80000c92 <release>
    return -1;
    80001c8e:	597d                	li	s2,-1
    80001c90:	6a42                	ld	s4,16(sp)
    80001c92:	a0b5                	j	80001cfe <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001c94:	04a1                	addi	s1,s1,8
    80001c96:	0921                	addi	s2,s2,8
    80001c98:	01348963          	beq	s1,s3,80001caa <fork+0xa8>
    if(p->ofile[i])
    80001c9c:	6088                	ld	a0,0(s1)
    80001c9e:	d97d                	beqz	a0,80001c94 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ca0:	017020ef          	jal	800044b6 <filedup>
    80001ca4:	00a93023          	sd	a0,0(s2)
    80001ca8:	b7f5                	j	80001c94 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001caa:	150ab503          	ld	a0,336(s5)
    80001cae:	7c4010ef          	jal	80003472 <idup>
    80001cb2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cb6:	4641                	li	a2,16
    80001cb8:	158a8593          	addi	a1,s5,344
    80001cbc:	158a0513          	addi	a0,s4,344
    80001cc0:	960ff0ef          	jal	80000e20 <safestrcpy>
  pid = np->pid;
    80001cc4:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001cc8:	8552                	mv	a0,s4
    80001cca:	fc9fe0ef          	jal	80000c92 <release>
  acquire(&wait_lock);
    80001cce:	0000f497          	auipc	s1,0xf
    80001cd2:	f5a48493          	addi	s1,s1,-166 # 80010c28 <wait_lock>
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	f27fe0ef          	jal	80000bfe <acquire>
  np->parent = p;
    80001cdc:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001ce0:	8526                	mv	a0,s1
    80001ce2:	fb1fe0ef          	jal	80000c92 <release>
  acquire(&np->lock);
    80001ce6:	8552                	mv	a0,s4
    80001ce8:	f17fe0ef          	jal	80000bfe <acquire>
  np->state = RUNNABLE;
    80001cec:	478d                	li	a5,3
    80001cee:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001cf2:	8552                	mv	a0,s4
    80001cf4:	f9ffe0ef          	jal	80000c92 <release>
  return pid;
    80001cf8:	74a2                	ld	s1,40(sp)
    80001cfa:	69e2                	ld	s3,24(sp)
    80001cfc:	6a42                	ld	s4,16(sp)
}
    80001cfe:	854a                	mv	a0,s2
    80001d00:	70e2                	ld	ra,56(sp)
    80001d02:	7442                	ld	s0,48(sp)
    80001d04:	7902                	ld	s2,32(sp)
    80001d06:	6aa2                	ld	s5,8(sp)
    80001d08:	6121                	addi	sp,sp,64
    80001d0a:	8082                	ret
    return -1;
    80001d0c:	597d                	li	s2,-1
    80001d0e:	bfc5                	j	80001cfe <fork+0xfc>

0000000080001d10 <scheduler>:
{
    80001d10:	715d                	addi	sp,sp,-80
    80001d12:	e486                	sd	ra,72(sp)
    80001d14:	e0a2                	sd	s0,64(sp)
    80001d16:	fc26                	sd	s1,56(sp)
    80001d18:	f84a                	sd	s2,48(sp)
    80001d1a:	f44e                	sd	s3,40(sp)
    80001d1c:	f052                	sd	s4,32(sp)
    80001d1e:	ec56                	sd	s5,24(sp)
    80001d20:	e85a                	sd	s6,16(sp)
    80001d22:	e45e                	sd	s7,8(sp)
    80001d24:	e062                	sd	s8,0(sp)
    80001d26:	0880                	addi	s0,sp,80
    80001d28:	8792                	mv	a5,tp
  int id = r_tp();
    80001d2a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d2c:	00779b13          	slli	s6,a5,0x7
    80001d30:	0000f717          	auipc	a4,0xf
    80001d34:	ee070713          	addi	a4,a4,-288 # 80010c10 <pid_lock>
    80001d38:	975a                	add	a4,a4,s6
    80001d3a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d3e:	0000f717          	auipc	a4,0xf
    80001d42:	f0a70713          	addi	a4,a4,-246 # 80010c48 <cpus+0x8>
    80001d46:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001d48:	4c11                	li	s8,4
        c->proc = p;
    80001d4a:	079e                	slli	a5,a5,0x7
    80001d4c:	0000fa17          	auipc	s4,0xf
    80001d50:	ec4a0a13          	addi	s4,s4,-316 # 80010c10 <pid_lock>
    80001d54:	9a3e                	add	s4,s4,a5
        found = 1;
    80001d56:	4b85                	li	s7,1
    80001d58:	a0a9                	j	80001da2 <scheduler+0x92>
      release(&p->lock);
    80001d5a:	8526                	mv	a0,s1
    80001d5c:	f37fe0ef          	jal	80000c92 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d60:	16848493          	addi	s1,s1,360
    80001d64:	03248563          	beq	s1,s2,80001d8e <scheduler+0x7e>
      acquire(&p->lock);
    80001d68:	8526                	mv	a0,s1
    80001d6a:	e95fe0ef          	jal	80000bfe <acquire>
      if(p->state == RUNNABLE) {
    80001d6e:	4c9c                	lw	a5,24(s1)
    80001d70:	ff3795e3          	bne	a5,s3,80001d5a <scheduler+0x4a>
        p->state = RUNNING;
    80001d74:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001d78:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001d7c:	06048593          	addi	a1,s1,96
    80001d80:	855a                	mv	a0,s6
    80001d82:	61c000ef          	jal	8000239e <swtch>
        c->proc = 0;
    80001d86:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001d8a:	8ade                	mv	s5,s7
    80001d8c:	b7f9                	j	80001d5a <scheduler+0x4a>
    if(found == 0) {
    80001d8e:	000a9a63          	bnez	s5,80001da2 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d96:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d9a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d9e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001da6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001daa:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001dae:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001db0:	0000f497          	auipc	s1,0xf
    80001db4:	29048493          	addi	s1,s1,656 # 80011040 <proc>
      if(p->state == RUNNABLE) {
    80001db8:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dba:	00015917          	auipc	s2,0x15
    80001dbe:	c8690913          	addi	s2,s2,-890 # 80016a40 <tickslock>
    80001dc2:	b75d                	j	80001d68 <scheduler+0x58>

0000000080001dc4 <sched>:
{
    80001dc4:	7179                	addi	sp,sp,-48
    80001dc6:	f406                	sd	ra,40(sp)
    80001dc8:	f022                	sd	s0,32(sp)
    80001dca:	ec26                	sd	s1,24(sp)
    80001dcc:	e84a                	sd	s2,16(sp)
    80001dce:	e44e                	sd	s3,8(sp)
    80001dd0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001dd2:	b0bff0ef          	jal	800018dc <myproc>
    80001dd6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001dd8:	dbdfe0ef          	jal	80000b94 <holding>
    80001ddc:	c92d                	beqz	a0,80001e4e <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dde:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001de0:	2781                	sext.w	a5,a5
    80001de2:	079e                	slli	a5,a5,0x7
    80001de4:	0000f717          	auipc	a4,0xf
    80001de8:	e2c70713          	addi	a4,a4,-468 # 80010c10 <pid_lock>
    80001dec:	97ba                	add	a5,a5,a4
    80001dee:	0a87a703          	lw	a4,168(a5)
    80001df2:	4785                	li	a5,1
    80001df4:	06f71363          	bne	a4,a5,80001e5a <sched+0x96>
  if(p->state == RUNNING)
    80001df8:	4c98                	lw	a4,24(s1)
    80001dfa:	4791                	li	a5,4
    80001dfc:	06f70563          	beq	a4,a5,80001e66 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e00:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e04:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e06:	e7b5                	bnez	a5,80001e72 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e08:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e0a:	0000f917          	auipc	s2,0xf
    80001e0e:	e0690913          	addi	s2,s2,-506 # 80010c10 <pid_lock>
    80001e12:	2781                	sext.w	a5,a5
    80001e14:	079e                	slli	a5,a5,0x7
    80001e16:	97ca                	add	a5,a5,s2
    80001e18:	0ac7a983          	lw	s3,172(a5)
    80001e1c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e1e:	2781                	sext.w	a5,a5
    80001e20:	079e                	slli	a5,a5,0x7
    80001e22:	0000f597          	auipc	a1,0xf
    80001e26:	e2658593          	addi	a1,a1,-474 # 80010c48 <cpus+0x8>
    80001e2a:	95be                	add	a1,a1,a5
    80001e2c:	06048513          	addi	a0,s1,96
    80001e30:	56e000ef          	jal	8000239e <swtch>
    80001e34:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e36:	2781                	sext.w	a5,a5
    80001e38:	079e                	slli	a5,a5,0x7
    80001e3a:	993e                	add	s2,s2,a5
    80001e3c:	0b392623          	sw	s3,172(s2)
}
    80001e40:	70a2                	ld	ra,40(sp)
    80001e42:	7402                	ld	s0,32(sp)
    80001e44:	64e2                	ld	s1,24(sp)
    80001e46:	6942                	ld	s2,16(sp)
    80001e48:	69a2                	ld	s3,8(sp)
    80001e4a:	6145                	addi	sp,sp,48
    80001e4c:	8082                	ret
    panic("sched p->lock");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	3ea50513          	addi	a0,a0,1002 # 80008238 <etext+0x238>
    80001e56:	949fe0ef          	jal	8000079e <panic>
    panic("sched locks");
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	3ee50513          	addi	a0,a0,1006 # 80008248 <etext+0x248>
    80001e62:	93dfe0ef          	jal	8000079e <panic>
    panic("sched running");
    80001e66:	00006517          	auipc	a0,0x6
    80001e6a:	3f250513          	addi	a0,a0,1010 # 80008258 <etext+0x258>
    80001e6e:	931fe0ef          	jal	8000079e <panic>
    panic("sched interruptible");
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	3f650513          	addi	a0,a0,1014 # 80008268 <etext+0x268>
    80001e7a:	925fe0ef          	jal	8000079e <panic>

0000000080001e7e <yield>:
{
    80001e7e:	1101                	addi	sp,sp,-32
    80001e80:	ec06                	sd	ra,24(sp)
    80001e82:	e822                	sd	s0,16(sp)
    80001e84:	e426                	sd	s1,8(sp)
    80001e86:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001e88:	a55ff0ef          	jal	800018dc <myproc>
    80001e8c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e8e:	d71fe0ef          	jal	80000bfe <acquire>
  p->state = RUNNABLE;
    80001e92:	478d                	li	a5,3
    80001e94:	cc9c                	sw	a5,24(s1)
  sched();
    80001e96:	f2fff0ef          	jal	80001dc4 <sched>
  release(&p->lock);
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	df7fe0ef          	jal	80000c92 <release>
}
    80001ea0:	60e2                	ld	ra,24(sp)
    80001ea2:	6442                	ld	s0,16(sp)
    80001ea4:	64a2                	ld	s1,8(sp)
    80001ea6:	6105                	addi	sp,sp,32
    80001ea8:	8082                	ret

0000000080001eaa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001eaa:	7179                	addi	sp,sp,-48
    80001eac:	f406                	sd	ra,40(sp)
    80001eae:	f022                	sd	s0,32(sp)
    80001eb0:	ec26                	sd	s1,24(sp)
    80001eb2:	e84a                	sd	s2,16(sp)
    80001eb4:	e44e                	sd	s3,8(sp)
    80001eb6:	1800                	addi	s0,sp,48
    80001eb8:	89aa                	mv	s3,a0
    80001eba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ebc:	a21ff0ef          	jal	800018dc <myproc>
    80001ec0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001ec2:	d3dfe0ef          	jal	80000bfe <acquire>
  release(lk);
    80001ec6:	854a                	mv	a0,s2
    80001ec8:	dcbfe0ef          	jal	80000c92 <release>

  // Go to sleep.
  p->chan = chan;
    80001ecc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ed0:	4789                	li	a5,2
    80001ed2:	cc9c                	sw	a5,24(s1)

  sched();
    80001ed4:	ef1ff0ef          	jal	80001dc4 <sched>

  // Tidy up.
  p->chan = 0;
    80001ed8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001edc:	8526                	mv	a0,s1
    80001ede:	db5fe0ef          	jal	80000c92 <release>
  acquire(lk);
    80001ee2:	854a                	mv	a0,s2
    80001ee4:	d1bfe0ef          	jal	80000bfe <acquire>
}
    80001ee8:	70a2                	ld	ra,40(sp)
    80001eea:	7402                	ld	s0,32(sp)
    80001eec:	64e2                	ld	s1,24(sp)
    80001eee:	6942                	ld	s2,16(sp)
    80001ef0:	69a2                	ld	s3,8(sp)
    80001ef2:	6145                	addi	sp,sp,48
    80001ef4:	8082                	ret

0000000080001ef6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001ef6:	7139                	addi	sp,sp,-64
    80001ef8:	fc06                	sd	ra,56(sp)
    80001efa:	f822                	sd	s0,48(sp)
    80001efc:	f426                	sd	s1,40(sp)
    80001efe:	f04a                	sd	s2,32(sp)
    80001f00:	ec4e                	sd	s3,24(sp)
    80001f02:	e852                	sd	s4,16(sp)
    80001f04:	e456                	sd	s5,8(sp)
    80001f06:	0080                	addi	s0,sp,64
    80001f08:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f0a:	0000f497          	auipc	s1,0xf
    80001f0e:	13648493          	addi	s1,s1,310 # 80011040 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f12:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f14:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f16:	00015917          	auipc	s2,0x15
    80001f1a:	b2a90913          	addi	s2,s2,-1238 # 80016a40 <tickslock>
    80001f1e:	a801                	j	80001f2e <wakeup+0x38>
      }
      release(&p->lock);
    80001f20:	8526                	mv	a0,s1
    80001f22:	d71fe0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f26:	16848493          	addi	s1,s1,360
    80001f2a:	03248263          	beq	s1,s2,80001f4e <wakeup+0x58>
    if(p != myproc()){
    80001f2e:	9afff0ef          	jal	800018dc <myproc>
    80001f32:	fea48ae3          	beq	s1,a0,80001f26 <wakeup+0x30>
      acquire(&p->lock);
    80001f36:	8526                	mv	a0,s1
    80001f38:	cc7fe0ef          	jal	80000bfe <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f3c:	4c9c                	lw	a5,24(s1)
    80001f3e:	ff3791e3          	bne	a5,s3,80001f20 <wakeup+0x2a>
    80001f42:	709c                	ld	a5,32(s1)
    80001f44:	fd479ee3          	bne	a5,s4,80001f20 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f48:	0154ac23          	sw	s5,24(s1)
    80001f4c:	bfd1                	j	80001f20 <wakeup+0x2a>
    }
  }
}
    80001f4e:	70e2                	ld	ra,56(sp)
    80001f50:	7442                	ld	s0,48(sp)
    80001f52:	74a2                	ld	s1,40(sp)
    80001f54:	7902                	ld	s2,32(sp)
    80001f56:	69e2                	ld	s3,24(sp)
    80001f58:	6a42                	ld	s4,16(sp)
    80001f5a:	6aa2                	ld	s5,8(sp)
    80001f5c:	6121                	addi	sp,sp,64
    80001f5e:	8082                	ret

0000000080001f60 <reparent>:
{
    80001f60:	7179                	addi	sp,sp,-48
    80001f62:	f406                	sd	ra,40(sp)
    80001f64:	f022                	sd	s0,32(sp)
    80001f66:	ec26                	sd	s1,24(sp)
    80001f68:	e84a                	sd	s2,16(sp)
    80001f6a:	e44e                	sd	s3,8(sp)
    80001f6c:	e052                	sd	s4,0(sp)
    80001f6e:	1800                	addi	s0,sp,48
    80001f70:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f72:	0000f497          	auipc	s1,0xf
    80001f76:	0ce48493          	addi	s1,s1,206 # 80011040 <proc>
      pp->parent = initproc;
    80001f7a:	00007a17          	auipc	s4,0x7
    80001f7e:	b4ea0a13          	addi	s4,s4,-1202 # 80008ac8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f82:	00015997          	auipc	s3,0x15
    80001f86:	abe98993          	addi	s3,s3,-1346 # 80016a40 <tickslock>
    80001f8a:	a029                	j	80001f94 <reparent+0x34>
    80001f8c:	16848493          	addi	s1,s1,360
    80001f90:	01348b63          	beq	s1,s3,80001fa6 <reparent+0x46>
    if(pp->parent == p){
    80001f94:	7c9c                	ld	a5,56(s1)
    80001f96:	ff279be3          	bne	a5,s2,80001f8c <reparent+0x2c>
      pp->parent = initproc;
    80001f9a:	000a3503          	ld	a0,0(s4)
    80001f9e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fa0:	f57ff0ef          	jal	80001ef6 <wakeup>
    80001fa4:	b7e5                	j	80001f8c <reparent+0x2c>
}
    80001fa6:	70a2                	ld	ra,40(sp)
    80001fa8:	7402                	ld	s0,32(sp)
    80001faa:	64e2                	ld	s1,24(sp)
    80001fac:	6942                	ld	s2,16(sp)
    80001fae:	69a2                	ld	s3,8(sp)
    80001fb0:	6a02                	ld	s4,0(sp)
    80001fb2:	6145                	addi	sp,sp,48
    80001fb4:	8082                	ret

0000000080001fb6 <exit>:
{
    80001fb6:	7179                	addi	sp,sp,-48
    80001fb8:	f406                	sd	ra,40(sp)
    80001fba:	f022                	sd	s0,32(sp)
    80001fbc:	ec26                	sd	s1,24(sp)
    80001fbe:	e84a                	sd	s2,16(sp)
    80001fc0:	e44e                	sd	s3,8(sp)
    80001fc2:	e052                	sd	s4,0(sp)
    80001fc4:	1800                	addi	s0,sp,48
    80001fc6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001fc8:	915ff0ef          	jal	800018dc <myproc>
    80001fcc:	89aa                	mv	s3,a0
  if(p == initproc)
    80001fce:	00007797          	auipc	a5,0x7
    80001fd2:	afa7b783          	ld	a5,-1286(a5) # 80008ac8 <initproc>
    80001fd6:	0d050493          	addi	s1,a0,208
    80001fda:	15050913          	addi	s2,a0,336
    80001fde:	00a79b63          	bne	a5,a0,80001ff4 <exit+0x3e>
    panic("init exiting");
    80001fe2:	00006517          	auipc	a0,0x6
    80001fe6:	29e50513          	addi	a0,a0,670 # 80008280 <etext+0x280>
    80001fea:	fb4fe0ef          	jal	8000079e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001fee:	04a1                	addi	s1,s1,8
    80001ff0:	01248963          	beq	s1,s2,80002002 <exit+0x4c>
    if(p->ofile[fd]){
    80001ff4:	6088                	ld	a0,0(s1)
    80001ff6:	dd65                	beqz	a0,80001fee <exit+0x38>
      fileclose(f);
    80001ff8:	504020ef          	jal	800044fc <fileclose>
      p->ofile[fd] = 0;
    80001ffc:	0004b023          	sd	zero,0(s1)
    80002000:	b7fd                	j	80001fee <exit+0x38>
  begin_op();
    80002002:	0da020ef          	jal	800040dc <begin_op>
  iput(p->cwd);
    80002006:	1509b503          	ld	a0,336(s3)
    8000200a:	620010ef          	jal	8000362a <iput>
  end_op();
    8000200e:	138020ef          	jal	80004146 <end_op>
  p->cwd = 0;
    80002012:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002016:	0000f497          	auipc	s1,0xf
    8000201a:	c1248493          	addi	s1,s1,-1006 # 80010c28 <wait_lock>
    8000201e:	8526                	mv	a0,s1
    80002020:	bdffe0ef          	jal	80000bfe <acquire>
  reparent(p);
    80002024:	854e                	mv	a0,s3
    80002026:	f3bff0ef          	jal	80001f60 <reparent>
  wakeup(p->parent);
    8000202a:	0389b503          	ld	a0,56(s3)
    8000202e:	ec9ff0ef          	jal	80001ef6 <wakeup>
  acquire(&p->lock);
    80002032:	854e                	mv	a0,s3
    80002034:	bcbfe0ef          	jal	80000bfe <acquire>
  p->xstate = status;
    80002038:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000203c:	4795                	li	a5,5
    8000203e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002042:	8526                	mv	a0,s1
    80002044:	c4ffe0ef          	jal	80000c92 <release>
  sched();
    80002048:	d7dff0ef          	jal	80001dc4 <sched>
  panic("zombie exit");
    8000204c:	00006517          	auipc	a0,0x6
    80002050:	24450513          	addi	a0,a0,580 # 80008290 <etext+0x290>
    80002054:	f4afe0ef          	jal	8000079e <panic>

0000000080002058 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002058:	7179                	addi	sp,sp,-48
    8000205a:	f406                	sd	ra,40(sp)
    8000205c:	f022                	sd	s0,32(sp)
    8000205e:	ec26                	sd	s1,24(sp)
    80002060:	e84a                	sd	s2,16(sp)
    80002062:	e44e                	sd	s3,8(sp)
    80002064:	1800                	addi	s0,sp,48
    80002066:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002068:	0000f497          	auipc	s1,0xf
    8000206c:	fd848493          	addi	s1,s1,-40 # 80011040 <proc>
    80002070:	00015997          	auipc	s3,0x15
    80002074:	9d098993          	addi	s3,s3,-1584 # 80016a40 <tickslock>
    acquire(&p->lock);
    80002078:	8526                	mv	a0,s1
    8000207a:	b85fe0ef          	jal	80000bfe <acquire>
    if(p->pid == pid){
    8000207e:	589c                	lw	a5,48(s1)
    80002080:	01278b63          	beq	a5,s2,80002096 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002084:	8526                	mv	a0,s1
    80002086:	c0dfe0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000208a:	16848493          	addi	s1,s1,360
    8000208e:	ff3495e3          	bne	s1,s3,80002078 <kill+0x20>
  }
  return -1;
    80002092:	557d                	li	a0,-1
    80002094:	a819                	j	800020aa <kill+0x52>
      p->killed = 1;
    80002096:	4785                	li	a5,1
    80002098:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000209a:	4c98                	lw	a4,24(s1)
    8000209c:	4789                	li	a5,2
    8000209e:	00f70d63          	beq	a4,a5,800020b8 <kill+0x60>
      release(&p->lock);
    800020a2:	8526                	mv	a0,s1
    800020a4:	beffe0ef          	jal	80000c92 <release>
      return 0;
    800020a8:	4501                	li	a0,0
}
    800020aa:	70a2                	ld	ra,40(sp)
    800020ac:	7402                	ld	s0,32(sp)
    800020ae:	64e2                	ld	s1,24(sp)
    800020b0:	6942                	ld	s2,16(sp)
    800020b2:	69a2                	ld	s3,8(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret
        p->state = RUNNABLE;
    800020b8:	478d                	li	a5,3
    800020ba:	cc9c                	sw	a5,24(s1)
    800020bc:	b7dd                	j	800020a2 <kill+0x4a>

00000000800020be <setkilled>:

void
setkilled(struct proc *p)
{
    800020be:	1101                	addi	sp,sp,-32
    800020c0:	ec06                	sd	ra,24(sp)
    800020c2:	e822                	sd	s0,16(sp)
    800020c4:	e426                	sd	s1,8(sp)
    800020c6:	1000                	addi	s0,sp,32
    800020c8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020ca:	b35fe0ef          	jal	80000bfe <acquire>
  p->killed = 1;
    800020ce:	4785                	li	a5,1
    800020d0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800020d2:	8526                	mv	a0,s1
    800020d4:	bbffe0ef          	jal	80000c92 <release>
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <killed>:

int
killed(struct proc *p)
{
    800020e2:	1101                	addi	sp,sp,-32
    800020e4:	ec06                	sd	ra,24(sp)
    800020e6:	e822                	sd	s0,16(sp)
    800020e8:	e426                	sd	s1,8(sp)
    800020ea:	e04a                	sd	s2,0(sp)
    800020ec:	1000                	addi	s0,sp,32
    800020ee:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800020f0:	b0ffe0ef          	jal	80000bfe <acquire>
  k = p->killed;
    800020f4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800020f8:	8526                	mv	a0,s1
    800020fa:	b99fe0ef          	jal	80000c92 <release>
  return k;
}
    800020fe:	854a                	mv	a0,s2
    80002100:	60e2                	ld	ra,24(sp)
    80002102:	6442                	ld	s0,16(sp)
    80002104:	64a2                	ld	s1,8(sp)
    80002106:	6902                	ld	s2,0(sp)
    80002108:	6105                	addi	sp,sp,32
    8000210a:	8082                	ret

000000008000210c <wait>:
{
    8000210c:	715d                	addi	sp,sp,-80
    8000210e:	e486                	sd	ra,72(sp)
    80002110:	e0a2                	sd	s0,64(sp)
    80002112:	fc26                	sd	s1,56(sp)
    80002114:	f84a                	sd	s2,48(sp)
    80002116:	f44e                	sd	s3,40(sp)
    80002118:	f052                	sd	s4,32(sp)
    8000211a:	ec56                	sd	s5,24(sp)
    8000211c:	e85a                	sd	s6,16(sp)
    8000211e:	e45e                	sd	s7,8(sp)
    80002120:	0880                	addi	s0,sp,80
    80002122:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002124:	fb8ff0ef          	jal	800018dc <myproc>
    80002128:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000212a:	0000f517          	auipc	a0,0xf
    8000212e:	afe50513          	addi	a0,a0,-1282 # 80010c28 <wait_lock>
    80002132:	acdfe0ef          	jal	80000bfe <acquire>
        if(pp->state == ZOMBIE){
    80002136:	4a15                	li	s4,5
        havekids = 1;
    80002138:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000213a:	00015997          	auipc	s3,0x15
    8000213e:	90698993          	addi	s3,s3,-1786 # 80016a40 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002142:	0000fb97          	auipc	s7,0xf
    80002146:	ae6b8b93          	addi	s7,s7,-1306 # 80010c28 <wait_lock>
    8000214a:	a869                	j	800021e4 <wait+0xd8>
          pid = pp->pid;
    8000214c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002150:	000b0c63          	beqz	s6,80002168 <wait+0x5c>
    80002154:	4691                	li	a3,4
    80002156:	02c48613          	addi	a2,s1,44
    8000215a:	85da                	mv	a1,s6
    8000215c:	05093503          	ld	a0,80(s2)
    80002160:	c24ff0ef          	jal	80001584 <copyout>
    80002164:	02054a63          	bltz	a0,80002198 <wait+0x8c>
          freeproc(pp);
    80002168:	8526                	mv	a0,s1
    8000216a:	8e5ff0ef          	jal	80001a4e <freeproc>
          release(&pp->lock);
    8000216e:	8526                	mv	a0,s1
    80002170:	b23fe0ef          	jal	80000c92 <release>
          release(&wait_lock);
    80002174:	0000f517          	auipc	a0,0xf
    80002178:	ab450513          	addi	a0,a0,-1356 # 80010c28 <wait_lock>
    8000217c:	b17fe0ef          	jal	80000c92 <release>
}
    80002180:	854e                	mv	a0,s3
    80002182:	60a6                	ld	ra,72(sp)
    80002184:	6406                	ld	s0,64(sp)
    80002186:	74e2                	ld	s1,56(sp)
    80002188:	7942                	ld	s2,48(sp)
    8000218a:	79a2                	ld	s3,40(sp)
    8000218c:	7a02                	ld	s4,32(sp)
    8000218e:	6ae2                	ld	s5,24(sp)
    80002190:	6b42                	ld	s6,16(sp)
    80002192:	6ba2                	ld	s7,8(sp)
    80002194:	6161                	addi	sp,sp,80
    80002196:	8082                	ret
            release(&pp->lock);
    80002198:	8526                	mv	a0,s1
    8000219a:	af9fe0ef          	jal	80000c92 <release>
            release(&wait_lock);
    8000219e:	0000f517          	auipc	a0,0xf
    800021a2:	a8a50513          	addi	a0,a0,-1398 # 80010c28 <wait_lock>
    800021a6:	aedfe0ef          	jal	80000c92 <release>
            return -1;
    800021aa:	59fd                	li	s3,-1
    800021ac:	bfd1                	j	80002180 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021ae:	16848493          	addi	s1,s1,360
    800021b2:	03348063          	beq	s1,s3,800021d2 <wait+0xc6>
      if(pp->parent == p){
    800021b6:	7c9c                	ld	a5,56(s1)
    800021b8:	ff279be3          	bne	a5,s2,800021ae <wait+0xa2>
        acquire(&pp->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	a41fe0ef          	jal	80000bfe <acquire>
        if(pp->state == ZOMBIE){
    800021c2:	4c9c                	lw	a5,24(s1)
    800021c4:	f94784e3          	beq	a5,s4,8000214c <wait+0x40>
        release(&pp->lock);
    800021c8:	8526                	mv	a0,s1
    800021ca:	ac9fe0ef          	jal	80000c92 <release>
        havekids = 1;
    800021ce:	8756                	mv	a4,s5
    800021d0:	bff9                	j	800021ae <wait+0xa2>
    if(!havekids || killed(p)){
    800021d2:	cf19                	beqz	a4,800021f0 <wait+0xe4>
    800021d4:	854a                	mv	a0,s2
    800021d6:	f0dff0ef          	jal	800020e2 <killed>
    800021da:	e919                	bnez	a0,800021f0 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021dc:	85de                	mv	a1,s7
    800021de:	854a                	mv	a0,s2
    800021e0:	ccbff0ef          	jal	80001eaa <sleep>
    havekids = 0;
    800021e4:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021e6:	0000f497          	auipc	s1,0xf
    800021ea:	e5a48493          	addi	s1,s1,-422 # 80011040 <proc>
    800021ee:	b7e1                	j	800021b6 <wait+0xaa>
      release(&wait_lock);
    800021f0:	0000f517          	auipc	a0,0xf
    800021f4:	a3850513          	addi	a0,a0,-1480 # 80010c28 <wait_lock>
    800021f8:	a9bfe0ef          	jal	80000c92 <release>
      return -1;
    800021fc:	59fd                	li	s3,-1
    800021fe:	b749                	j	80002180 <wait+0x74>

0000000080002200 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002200:	7179                	addi	sp,sp,-48
    80002202:	f406                	sd	ra,40(sp)
    80002204:	f022                	sd	s0,32(sp)
    80002206:	ec26                	sd	s1,24(sp)
    80002208:	e84a                	sd	s2,16(sp)
    8000220a:	e44e                	sd	s3,8(sp)
    8000220c:	e052                	sd	s4,0(sp)
    8000220e:	1800                	addi	s0,sp,48
    80002210:	84aa                	mv	s1,a0
    80002212:	892e                	mv	s2,a1
    80002214:	89b2                	mv	s3,a2
    80002216:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002218:	ec4ff0ef          	jal	800018dc <myproc>
  if(user_dst){
    8000221c:	cc99                	beqz	s1,8000223a <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000221e:	86d2                	mv	a3,s4
    80002220:	864e                	mv	a2,s3
    80002222:	85ca                	mv	a1,s2
    80002224:	6928                	ld	a0,80(a0)
    80002226:	b5eff0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000222a:	70a2                	ld	ra,40(sp)
    8000222c:	7402                	ld	s0,32(sp)
    8000222e:	64e2                	ld	s1,24(sp)
    80002230:	6942                	ld	s2,16(sp)
    80002232:	69a2                	ld	s3,8(sp)
    80002234:	6a02                	ld	s4,0(sp)
    80002236:	6145                	addi	sp,sp,48
    80002238:	8082                	ret
    memmove((char *)dst, src, len);
    8000223a:	000a061b          	sext.w	a2,s4
    8000223e:	85ce                	mv	a1,s3
    80002240:	854a                	mv	a0,s2
    80002242:	af1fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002246:	8526                	mv	a0,s1
    80002248:	b7cd                	j	8000222a <either_copyout+0x2a>

000000008000224a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000224a:	7179                	addi	sp,sp,-48
    8000224c:	f406                	sd	ra,40(sp)
    8000224e:	f022                	sd	s0,32(sp)
    80002250:	ec26                	sd	s1,24(sp)
    80002252:	e84a                	sd	s2,16(sp)
    80002254:	e44e                	sd	s3,8(sp)
    80002256:	e052                	sd	s4,0(sp)
    80002258:	1800                	addi	s0,sp,48
    8000225a:	892a                	mv	s2,a0
    8000225c:	84ae                	mv	s1,a1
    8000225e:	89b2                	mv	s3,a2
    80002260:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002262:	e7aff0ef          	jal	800018dc <myproc>
  if(user_src){
    80002266:	cc99                	beqz	s1,80002284 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002268:	86d2                	mv	a3,s4
    8000226a:	864e                	mv	a2,s3
    8000226c:	85ca                	mv	a1,s2
    8000226e:	6928                	ld	a0,80(a0)
    80002270:	bc4ff0ef          	jal	80001634 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002274:	70a2                	ld	ra,40(sp)
    80002276:	7402                	ld	s0,32(sp)
    80002278:	64e2                	ld	s1,24(sp)
    8000227a:	6942                	ld	s2,16(sp)
    8000227c:	69a2                	ld	s3,8(sp)
    8000227e:	6a02                	ld	s4,0(sp)
    80002280:	6145                	addi	sp,sp,48
    80002282:	8082                	ret
    memmove(dst, (char*)src, len);
    80002284:	000a061b          	sext.w	a2,s4
    80002288:	85ce                	mv	a1,s3
    8000228a:	854a                	mv	a0,s2
    8000228c:	aa7fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002290:	8526                	mv	a0,s1
    80002292:	b7cd                	j	80002274 <either_copyin+0x2a>

0000000080002294 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002294:	715d                	addi	sp,sp,-80
    80002296:	e486                	sd	ra,72(sp)
    80002298:	e0a2                	sd	s0,64(sp)
    8000229a:	fc26                	sd	s1,56(sp)
    8000229c:	f84a                	sd	s2,48(sp)
    8000229e:	f44e                	sd	s3,40(sp)
    800022a0:	f052                	sd	s4,32(sp)
    800022a2:	ec56                	sd	s5,24(sp)
    800022a4:	e85a                	sd	s6,16(sp)
    800022a6:	e45e                	sd	s7,8(sp)
    800022a8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800022aa:	00006517          	auipc	a0,0x6
    800022ae:	dce50513          	addi	a0,a0,-562 # 80008078 <etext+0x78>
    800022b2:	a1cfe0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022b6:	0000f497          	auipc	s1,0xf
    800022ba:	ee248493          	addi	s1,s1,-286 # 80011198 <proc+0x158>
    800022be:	00015917          	auipc	s2,0x15
    800022c2:	8da90913          	addi	s2,s2,-1830 # 80016b98 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022c6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022c8:	00006997          	auipc	s3,0x6
    800022cc:	fd898993          	addi	s3,s3,-40 # 800082a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    800022d0:	00006a97          	auipc	s5,0x6
    800022d4:	fd8a8a93          	addi	s5,s5,-40 # 800082a8 <etext+0x2a8>
    printf("\n");
    800022d8:	00006a17          	auipc	s4,0x6
    800022dc:	da0a0a13          	addi	s4,s4,-608 # 80008078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022e0:	00006b97          	auipc	s7,0x6
    800022e4:	648b8b93          	addi	s7,s7,1608 # 80008928 <states.0>
    800022e8:	a829                	j	80002302 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800022ea:	ed86a583          	lw	a1,-296(a3)
    800022ee:	8556                	mv	a0,s5
    800022f0:	9defe0ef          	jal	800004ce <printf>
    printf("\n");
    800022f4:	8552                	mv	a0,s4
    800022f6:	9d8fe0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800022fa:	16848493          	addi	s1,s1,360
    800022fe:	03248263          	beq	s1,s2,80002322 <procdump+0x8e>
    if(p->state == UNUSED)
    80002302:	86a6                	mv	a3,s1
    80002304:	ec04a783          	lw	a5,-320(s1)
    80002308:	dbed                	beqz	a5,800022fa <procdump+0x66>
      state = "???";
    8000230a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000230c:	fcfb6fe3          	bltu	s6,a5,800022ea <procdump+0x56>
    80002310:	02079713          	slli	a4,a5,0x20
    80002314:	01d75793          	srli	a5,a4,0x1d
    80002318:	97de                	add	a5,a5,s7
    8000231a:	6390                	ld	a2,0(a5)
    8000231c:	f679                	bnez	a2,800022ea <procdump+0x56>
      state = "???";
    8000231e:	864e                	mv	a2,s3
    80002320:	b7e9                	j	800022ea <procdump+0x56>
  }
}
    80002322:	60a6                	ld	ra,72(sp)
    80002324:	6406                	ld	s0,64(sp)
    80002326:	74e2                	ld	s1,56(sp)
    80002328:	7942                	ld	s2,48(sp)
    8000232a:	79a2                	ld	s3,40(sp)
    8000232c:	7a02                	ld	s4,32(sp)
    8000232e:	6ae2                	ld	s5,24(sp)
    80002330:	6b42                	ld	s6,16(sp)
    80002332:	6ba2                	ld	s7,8(sp)
    80002334:	6161                	addi	sp,sp,80
    80002336:	8082                	ret

0000000080002338 <getprocsinfo>:
int
getprocsinfo(int pid, struct procinfo *info)
{
  struct proc *p;

  if (info == 0)
    80002338:	c1ad                	beqz	a1,8000239a <getprocsinfo+0x62>
    8000233a:	882e                	mv	a6,a1
    return -1;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000233c:	0000f597          	auipc	a1,0xf
    80002340:	d0458593          	addi	a1,a1,-764 # 80011040 <proc>
    80002344:	00014697          	auipc	a3,0x14
    80002348:	6fc68693          	addi	a3,a3,1788 # 80016a40 <tickslock>

    // if(p->state == UNUSED)
    //   continue;

    if(p->pid == pid) {
    8000234c:	5998                	lw	a4,48(a1)
    8000234e:	00a70863          	beq	a4,a0,8000235e <getprocsinfo+0x26>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002352:	16858593          	addi	a1,a1,360
    80002356:	fed59be3          	bne	a1,a3,8000234c <getprocsinfo+0x14>
      safestrcpy(info->name, p->name, sizeof(p->name));
      return 0;
    }
  }

  return -1;
    8000235a:	557d                	li	a0,-1
    8000235c:	8082                	ret
{
    8000235e:	1141                	addi	sp,sp,-16
    80002360:	e406                	sd	ra,8(sp)
    80002362:	e022                	sd	s0,0(sp)
    80002364:	0800                	addi	s0,sp,16
      info->pid = p->pid;
    80002366:	00e82023          	sw	a4,0(a6)
      info->ppid = p->parent ? p->parent->pid : 0;
    8000236a:	7d94                	ld	a3,56(a1)
    8000236c:	4701                	li	a4,0
    8000236e:	c291                	beqz	a3,80002372 <getprocsinfo+0x3a>
    80002370:	5a98                	lw	a4,48(a3)
    80002372:	00e82223          	sw	a4,4(a6)
      info->state = p->state;
    80002376:	4d98                	lw	a4,24(a1)
    80002378:	00e82423          	sw	a4,8(a6)
      info->sz = p->sz;
    8000237c:	65b8                	ld	a4,72(a1)
    8000237e:	00e83823          	sd	a4,16(a6)
      safestrcpy(info->name, p->name, sizeof(p->name));
    80002382:	4641                	li	a2,16
    80002384:	15858593          	addi	a1,a1,344
    80002388:	01880513          	addi	a0,a6,24
    8000238c:	a95fe0ef          	jal	80000e20 <safestrcpy>
      return 0;
    80002390:	4501                	li	a0,0
    80002392:	60a2                	ld	ra,8(sp)
    80002394:	6402                	ld	s0,0(sp)
    80002396:	0141                	addi	sp,sp,16
    80002398:	8082                	ret
    return -1;
    8000239a:	557d                	li	a0,-1
    8000239c:	8082                	ret

000000008000239e <swtch>:
    8000239e:	00153023          	sd	ra,0(a0)
    800023a2:	00253423          	sd	sp,8(a0)
    800023a6:	e900                	sd	s0,16(a0)
    800023a8:	ed04                	sd	s1,24(a0)
    800023aa:	03253023          	sd	s2,32(a0)
    800023ae:	03353423          	sd	s3,40(a0)
    800023b2:	03453823          	sd	s4,48(a0)
    800023b6:	03553c23          	sd	s5,56(a0)
    800023ba:	05653023          	sd	s6,64(a0)
    800023be:	05753423          	sd	s7,72(a0)
    800023c2:	05853823          	sd	s8,80(a0)
    800023c6:	05953c23          	sd	s9,88(a0)
    800023ca:	07a53023          	sd	s10,96(a0)
    800023ce:	07b53423          	sd	s11,104(a0)
    800023d2:	0005b083          	ld	ra,0(a1)
    800023d6:	0085b103          	ld	sp,8(a1)
    800023da:	6980                	ld	s0,16(a1)
    800023dc:	6d84                	ld	s1,24(a1)
    800023de:	0205b903          	ld	s2,32(a1)
    800023e2:	0285b983          	ld	s3,40(a1)
    800023e6:	0305ba03          	ld	s4,48(a1)
    800023ea:	0385ba83          	ld	s5,56(a1)
    800023ee:	0405bb03          	ld	s6,64(a1)
    800023f2:	0485bb83          	ld	s7,72(a1)
    800023f6:	0505bc03          	ld	s8,80(a1)
    800023fa:	0585bc83          	ld	s9,88(a1)
    800023fe:	0605bd03          	ld	s10,96(a1)
    80002402:	0685bd83          	ld	s11,104(a1)
    80002406:	8082                	ret

0000000080002408 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002408:	1141                	addi	sp,sp,-16
    8000240a:	e406                	sd	ra,8(sp)
    8000240c:	e022                	sd	s0,0(sp)
    8000240e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002410:	00006597          	auipc	a1,0x6
    80002414:	ed858593          	addi	a1,a1,-296 # 800082e8 <etext+0x2e8>
    80002418:	00014517          	auipc	a0,0x14
    8000241c:	62850513          	addi	a0,a0,1576 # 80016a40 <tickslock>
    80002420:	f5afe0ef          	jal	80000b7a <initlock>
}
    80002424:	60a2                	ld	ra,8(sp)
    80002426:	6402                	ld	s0,0(sp)
    80002428:	0141                	addi	sp,sp,16
    8000242a:	8082                	ret

000000008000242c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000242c:	1141                	addi	sp,sp,-16
    8000242e:	e406                	sd	ra,8(sp)
    80002430:	e022                	sd	s0,0(sp)
    80002432:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002434:	00003797          	auipc	a5,0x3
    80002438:	47c78793          	addi	a5,a5,1148 # 800058b0 <kernelvec>
    8000243c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002440:	60a2                	ld	ra,8(sp)
    80002442:	6402                	ld	s0,0(sp)
    80002444:	0141                	addi	sp,sp,16
    80002446:	8082                	ret

0000000080002448 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002448:	1141                	addi	sp,sp,-16
    8000244a:	e406                	sd	ra,8(sp)
    8000244c:	e022                	sd	s0,0(sp)
    8000244e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002450:	c8cff0ef          	jal	800018dc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002454:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002458:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000245a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000245e:	00005697          	auipc	a3,0x5
    80002462:	ba268693          	addi	a3,a3,-1118 # 80007000 <_trampoline>
    80002466:	00005717          	auipc	a4,0x5
    8000246a:	b9a70713          	addi	a4,a4,-1126 # 80007000 <_trampoline>
    8000246e:	8f15                	sub	a4,a4,a3
    80002470:	040007b7          	lui	a5,0x4000
    80002474:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002476:	07b2                	slli	a5,a5,0xc
    80002478:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000247a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000247e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002480:	18002673          	csrr	a2,satp
    80002484:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002486:	6d30                	ld	a2,88(a0)
    80002488:	6138                	ld	a4,64(a0)
    8000248a:	6585                	lui	a1,0x1
    8000248c:	972e                	add	a4,a4,a1
    8000248e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002490:	6d38                	ld	a4,88(a0)
    80002492:	00000617          	auipc	a2,0x0
    80002496:	11060613          	addi	a2,a2,272 # 800025a2 <usertrap>
    8000249a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000249c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000249e:	8612                	mv	a2,tp
    800024a0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024a2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024a6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024aa:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024ae:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024b2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024b4:	6f18                	ld	a4,24(a4)
    800024b6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800024ba:	6928                	ld	a0,80(a0)
    800024bc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800024be:	00005717          	auipc	a4,0x5
    800024c2:	bde70713          	addi	a4,a4,-1058 # 8000709c <userret>
    800024c6:	8f15                	sub	a4,a4,a3
    800024c8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800024ca:	577d                	li	a4,-1
    800024cc:	177e                	slli	a4,a4,0x3f
    800024ce:	8d59                	or	a0,a0,a4
    800024d0:	9782                	jalr	a5
}
    800024d2:	60a2                	ld	ra,8(sp)
    800024d4:	6402                	ld	s0,0(sp)
    800024d6:	0141                	addi	sp,sp,16
    800024d8:	8082                	ret

00000000800024da <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024da:	1101                	addi	sp,sp,-32
    800024dc:	ec06                	sd	ra,24(sp)
    800024de:	e822                	sd	s0,16(sp)
    800024e0:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800024e2:	bc6ff0ef          	jal	800018a8 <cpuid>
    800024e6:	cd11                	beqz	a0,80002502 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024e8:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024ec:	000f4737          	lui	a4,0xf4
    800024f0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024f4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024f6:	14d79073          	csrw	stimecmp,a5
}
    800024fa:	60e2                	ld	ra,24(sp)
    800024fc:	6442                	ld	s0,16(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret
    80002502:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002504:	00014497          	auipc	s1,0x14
    80002508:	53c48493          	addi	s1,s1,1340 # 80016a40 <tickslock>
    8000250c:	8526                	mv	a0,s1
    8000250e:	ef0fe0ef          	jal	80000bfe <acquire>
    ticks++;
    80002512:	00006517          	auipc	a0,0x6
    80002516:	5be50513          	addi	a0,a0,1470 # 80008ad0 <ticks>
    8000251a:	411c                	lw	a5,0(a0)
    8000251c:	2785                	addiw	a5,a5,1
    8000251e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002520:	9d7ff0ef          	jal	80001ef6 <wakeup>
    release(&tickslock);
    80002524:	8526                	mv	a0,s1
    80002526:	f6cfe0ef          	jal	80000c92 <release>
    8000252a:	64a2                	ld	s1,8(sp)
    8000252c:	bf75                	j	800024e8 <clockintr+0xe>

000000008000252e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000252e:	1101                	addi	sp,sp,-32
    80002530:	ec06                	sd	ra,24(sp)
    80002532:	e822                	sd	s0,16(sp)
    80002534:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002536:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000253a:	57fd                	li	a5,-1
    8000253c:	17fe                	slli	a5,a5,0x3f
    8000253e:	07a5                	addi	a5,a5,9
    80002540:	00f70c63          	beq	a4,a5,80002558 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002544:	57fd                	li	a5,-1
    80002546:	17fe                	slli	a5,a5,0x3f
    80002548:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000254a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000254c:	04f70763          	beq	a4,a5,8000259a <devintr+0x6c>
  }
}
    80002550:	60e2                	ld	ra,24(sp)
    80002552:	6442                	ld	s0,16(sp)
    80002554:	6105                	addi	sp,sp,32
    80002556:	8082                	ret
    80002558:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000255a:	402030ef          	jal	8000595c <plic_claim>
    8000255e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002560:	47a9                	li	a5,10
    80002562:	00f50963          	beq	a0,a5,80002574 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002566:	4785                	li	a5,1
    80002568:	00f50963          	beq	a0,a5,8000257a <devintr+0x4c>
    return 1;
    8000256c:	4505                	li	a0,1
    } else if(irq){
    8000256e:	e889                	bnez	s1,80002580 <devintr+0x52>
    80002570:	64a2                	ld	s1,8(sp)
    80002572:	bff9                	j	80002550 <devintr+0x22>
      uartintr();
    80002574:	c98fe0ef          	jal	80000a0c <uartintr>
    if(irq)
    80002578:	a819                	j	8000258e <devintr+0x60>
      virtio_disk_intr();
    8000257a:	073030ef          	jal	80005dec <virtio_disk_intr>
    if(irq)
    8000257e:	a801                	j	8000258e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002580:	85a6                	mv	a1,s1
    80002582:	00006517          	auipc	a0,0x6
    80002586:	d6e50513          	addi	a0,a0,-658 # 800082f0 <etext+0x2f0>
    8000258a:	f45fd0ef          	jal	800004ce <printf>
      plic_complete(irq);
    8000258e:	8526                	mv	a0,s1
    80002590:	3ec030ef          	jal	8000597c <plic_complete>
    return 1;
    80002594:	4505                	li	a0,1
    80002596:	64a2                	ld	s1,8(sp)
    80002598:	bf65                	j	80002550 <devintr+0x22>
    clockintr();
    8000259a:	f41ff0ef          	jal	800024da <clockintr>
    return 2;
    8000259e:	4509                	li	a0,2
    800025a0:	bf45                	j	80002550 <devintr+0x22>

00000000800025a2 <usertrap>:
{
    800025a2:	1101                	addi	sp,sp,-32
    800025a4:	ec06                	sd	ra,24(sp)
    800025a6:	e822                	sd	s0,16(sp)
    800025a8:	e426                	sd	s1,8(sp)
    800025aa:	e04a                	sd	s2,0(sp)
    800025ac:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025ae:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025b2:	1007f793          	andi	a5,a5,256
    800025b6:	ef85                	bnez	a5,800025ee <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025b8:	00003797          	auipc	a5,0x3
    800025bc:	2f878793          	addi	a5,a5,760 # 800058b0 <kernelvec>
    800025c0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025c4:	b18ff0ef          	jal	800018dc <myproc>
    800025c8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025ca:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025cc:	14102773          	csrr	a4,sepc
    800025d0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025d2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025d6:	47a1                	li	a5,8
    800025d8:	02f70163          	beq	a4,a5,800025fa <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800025dc:	f53ff0ef          	jal	8000252e <devintr>
    800025e0:	892a                	mv	s2,a0
    800025e2:	c135                	beqz	a0,80002646 <usertrap+0xa4>
  if(killed(p))
    800025e4:	8526                	mv	a0,s1
    800025e6:	afdff0ef          	jal	800020e2 <killed>
    800025ea:	cd1d                	beqz	a0,80002628 <usertrap+0x86>
    800025ec:	a81d                	j	80002622 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800025ee:	00006517          	auipc	a0,0x6
    800025f2:	d2250513          	addi	a0,a0,-734 # 80008310 <etext+0x310>
    800025f6:	9a8fe0ef          	jal	8000079e <panic>
    if(killed(p))
    800025fa:	ae9ff0ef          	jal	800020e2 <killed>
    800025fe:	e121                	bnez	a0,8000263e <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002600:	6cb8                	ld	a4,88(s1)
    80002602:	6f1c                	ld	a5,24(a4)
    80002604:	0791                	addi	a5,a5,4
    80002606:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002608:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000260c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002610:	10079073          	csrw	sstatus,a5
    syscall();
    80002614:	240000ef          	jal	80002854 <syscall>
  if(killed(p))
    80002618:	8526                	mv	a0,s1
    8000261a:	ac9ff0ef          	jal	800020e2 <killed>
    8000261e:	c901                	beqz	a0,8000262e <usertrap+0x8c>
    80002620:	4901                	li	s2,0
    exit(-1);
    80002622:	557d                	li	a0,-1
    80002624:	993ff0ef          	jal	80001fb6 <exit>
  if(which_dev == 2)
    80002628:	4789                	li	a5,2
    8000262a:	04f90563          	beq	s2,a5,80002674 <usertrap+0xd2>
  usertrapret();
    8000262e:	e1bff0ef          	jal	80002448 <usertrapret>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6902                	ld	s2,0(sp)
    8000263a:	6105                	addi	sp,sp,32
    8000263c:	8082                	ret
      exit(-1);
    8000263e:	557d                	li	a0,-1
    80002640:	977ff0ef          	jal	80001fb6 <exit>
    80002644:	bf75                	j	80002600 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002646:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000264a:	5890                	lw	a2,48(s1)
    8000264c:	00006517          	auipc	a0,0x6
    80002650:	ce450513          	addi	a0,a0,-796 # 80008330 <etext+0x330>
    80002654:	e7bfd0ef          	jal	800004ce <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002658:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000265c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002660:	00006517          	auipc	a0,0x6
    80002664:	d0050513          	addi	a0,a0,-768 # 80008360 <etext+0x360>
    80002668:	e67fd0ef          	jal	800004ce <printf>
    setkilled(p);
    8000266c:	8526                	mv	a0,s1
    8000266e:	a51ff0ef          	jal	800020be <setkilled>
    80002672:	b75d                	j	80002618 <usertrap+0x76>
    yield();
    80002674:	80bff0ef          	jal	80001e7e <yield>
    80002678:	bf5d                	j	8000262e <usertrap+0x8c>

000000008000267a <kerneltrap>:
{
    8000267a:	7179                	addi	sp,sp,-48
    8000267c:	f406                	sd	ra,40(sp)
    8000267e:	f022                	sd	s0,32(sp)
    80002680:	ec26                	sd	s1,24(sp)
    80002682:	e84a                	sd	s2,16(sp)
    80002684:	e44e                	sd	s3,8(sp)
    80002686:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002688:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000268c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002690:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002694:	1004f793          	andi	a5,s1,256
    80002698:	c795                	beqz	a5,800026c4 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000269a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000269e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026a0:	eb85                	bnez	a5,800026d0 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800026a2:	e8dff0ef          	jal	8000252e <devintr>
    800026a6:	c91d                	beqz	a0,800026dc <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800026a8:	4789                	li	a5,2
    800026aa:	04f50a63          	beq	a0,a5,800026fe <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026ae:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026b2:	10049073          	csrw	sstatus,s1
}
    800026b6:	70a2                	ld	ra,40(sp)
    800026b8:	7402                	ld	s0,32(sp)
    800026ba:	64e2                	ld	s1,24(sp)
    800026bc:	6942                	ld	s2,16(sp)
    800026be:	69a2                	ld	s3,8(sp)
    800026c0:	6145                	addi	sp,sp,48
    800026c2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800026c4:	00006517          	auipc	a0,0x6
    800026c8:	cc450513          	addi	a0,a0,-828 # 80008388 <etext+0x388>
    800026cc:	8d2fe0ef          	jal	8000079e <panic>
    panic("kerneltrap: interrupts enabled");
    800026d0:	00006517          	auipc	a0,0x6
    800026d4:	ce050513          	addi	a0,a0,-800 # 800083b0 <etext+0x3b0>
    800026d8:	8c6fe0ef          	jal	8000079e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026dc:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026e0:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800026e4:	85ce                	mv	a1,s3
    800026e6:	00006517          	auipc	a0,0x6
    800026ea:	cea50513          	addi	a0,a0,-790 # 800083d0 <etext+0x3d0>
    800026ee:	de1fd0ef          	jal	800004ce <printf>
    panic("kerneltrap");
    800026f2:	00006517          	auipc	a0,0x6
    800026f6:	d0650513          	addi	a0,a0,-762 # 800083f8 <etext+0x3f8>
    800026fa:	8a4fe0ef          	jal	8000079e <panic>
  if(which_dev == 2 && myproc() != 0)
    800026fe:	9deff0ef          	jal	800018dc <myproc>
    80002702:	d555                	beqz	a0,800026ae <kerneltrap+0x34>
    yield();
    80002704:	f7aff0ef          	jal	80001e7e <yield>
    80002708:	b75d                	j	800026ae <kerneltrap+0x34>

000000008000270a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000270a:	1101                	addi	sp,sp,-32
    8000270c:	ec06                	sd	ra,24(sp)
    8000270e:	e822                	sd	s0,16(sp)
    80002710:	e426                	sd	s1,8(sp)
    80002712:	1000                	addi	s0,sp,32
    80002714:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002716:	9c6ff0ef          	jal	800018dc <myproc>
  switch (n) {
    8000271a:	4795                	li	a5,5
    8000271c:	0497e163          	bltu	a5,s1,8000275e <argraw+0x54>
    80002720:	048a                	slli	s1,s1,0x2
    80002722:	00006717          	auipc	a4,0x6
    80002726:	23670713          	addi	a4,a4,566 # 80008958 <states.0+0x30>
    8000272a:	94ba                	add	s1,s1,a4
    8000272c:	409c                	lw	a5,0(s1)
    8000272e:	97ba                	add	a5,a5,a4
    80002730:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002732:	6d3c                	ld	a5,88(a0)
    80002734:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002736:	60e2                	ld	ra,24(sp)
    80002738:	6442                	ld	s0,16(sp)
    8000273a:	64a2                	ld	s1,8(sp)
    8000273c:	6105                	addi	sp,sp,32
    8000273e:	8082                	ret
    return p->trapframe->a1;
    80002740:	6d3c                	ld	a5,88(a0)
    80002742:	7fa8                	ld	a0,120(a5)
    80002744:	bfcd                	j	80002736 <argraw+0x2c>
    return p->trapframe->a2;
    80002746:	6d3c                	ld	a5,88(a0)
    80002748:	63c8                	ld	a0,128(a5)
    8000274a:	b7f5                	j	80002736 <argraw+0x2c>
    return p->trapframe->a3;
    8000274c:	6d3c                	ld	a5,88(a0)
    8000274e:	67c8                	ld	a0,136(a5)
    80002750:	b7dd                	j	80002736 <argraw+0x2c>
    return p->trapframe->a4;
    80002752:	6d3c                	ld	a5,88(a0)
    80002754:	6bc8                	ld	a0,144(a5)
    80002756:	b7c5                	j	80002736 <argraw+0x2c>
    return p->trapframe->a5;
    80002758:	6d3c                	ld	a5,88(a0)
    8000275a:	6fc8                	ld	a0,152(a5)
    8000275c:	bfe9                	j	80002736 <argraw+0x2c>
  panic("argraw");
    8000275e:	00006517          	auipc	a0,0x6
    80002762:	caa50513          	addi	a0,a0,-854 # 80008408 <etext+0x408>
    80002766:	838fe0ef          	jal	8000079e <panic>

000000008000276a <fetchaddr>:
{
    8000276a:	1101                	addi	sp,sp,-32
    8000276c:	ec06                	sd	ra,24(sp)
    8000276e:	e822                	sd	s0,16(sp)
    80002770:	e426                	sd	s1,8(sp)
    80002772:	e04a                	sd	s2,0(sp)
    80002774:	1000                	addi	s0,sp,32
    80002776:	84aa                	mv	s1,a0
    80002778:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000277a:	962ff0ef          	jal	800018dc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000277e:	653c                	ld	a5,72(a0)
    80002780:	02f4f663          	bgeu	s1,a5,800027ac <fetchaddr+0x42>
    80002784:	00848713          	addi	a4,s1,8
    80002788:	02e7e463          	bltu	a5,a4,800027b0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000278c:	46a1                	li	a3,8
    8000278e:	8626                	mv	a2,s1
    80002790:	85ca                	mv	a1,s2
    80002792:	6928                	ld	a0,80(a0)
    80002794:	ea1fe0ef          	jal	80001634 <copyin>
    80002798:	00a03533          	snez	a0,a0
    8000279c:	40a0053b          	negw	a0,a0
}
    800027a0:	60e2                	ld	ra,24(sp)
    800027a2:	6442                	ld	s0,16(sp)
    800027a4:	64a2                	ld	s1,8(sp)
    800027a6:	6902                	ld	s2,0(sp)
    800027a8:	6105                	addi	sp,sp,32
    800027aa:	8082                	ret
    return -1;
    800027ac:	557d                	li	a0,-1
    800027ae:	bfcd                	j	800027a0 <fetchaddr+0x36>
    800027b0:	557d                	li	a0,-1
    800027b2:	b7fd                	j	800027a0 <fetchaddr+0x36>

00000000800027b4 <fetchstr>:
{
    800027b4:	7179                	addi	sp,sp,-48
    800027b6:	f406                	sd	ra,40(sp)
    800027b8:	f022                	sd	s0,32(sp)
    800027ba:	ec26                	sd	s1,24(sp)
    800027bc:	e84a                	sd	s2,16(sp)
    800027be:	e44e                	sd	s3,8(sp)
    800027c0:	1800                	addi	s0,sp,48
    800027c2:	892a                	mv	s2,a0
    800027c4:	84ae                	mv	s1,a1
    800027c6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800027c8:	914ff0ef          	jal	800018dc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800027cc:	86ce                	mv	a3,s3
    800027ce:	864a                	mv	a2,s2
    800027d0:	85a6                	mv	a1,s1
    800027d2:	6928                	ld	a0,80(a0)
    800027d4:	ee7fe0ef          	jal	800016ba <copyinstr>
    800027d8:	00054c63          	bltz	a0,800027f0 <fetchstr+0x3c>
  return strlen(buf);
    800027dc:	8526                	mv	a0,s1
    800027de:	e78fe0ef          	jal	80000e56 <strlen>
}
    800027e2:	70a2                	ld	ra,40(sp)
    800027e4:	7402                	ld	s0,32(sp)
    800027e6:	64e2                	ld	s1,24(sp)
    800027e8:	6942                	ld	s2,16(sp)
    800027ea:	69a2                	ld	s3,8(sp)
    800027ec:	6145                	addi	sp,sp,48
    800027ee:	8082                	ret
    return -1;
    800027f0:	557d                	li	a0,-1
    800027f2:	bfc5                	j	800027e2 <fetchstr+0x2e>

00000000800027f4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027f4:	1101                	addi	sp,sp,-32
    800027f6:	ec06                	sd	ra,24(sp)
    800027f8:	e822                	sd	s0,16(sp)
    800027fa:	e426                	sd	s1,8(sp)
    800027fc:	1000                	addi	s0,sp,32
    800027fe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002800:	f0bff0ef          	jal	8000270a <argraw>
    80002804:	c088                	sw	a0,0(s1)
}
    80002806:	60e2                	ld	ra,24(sp)
    80002808:	6442                	ld	s0,16(sp)
    8000280a:	64a2                	ld	s1,8(sp)
    8000280c:	6105                	addi	sp,sp,32
    8000280e:	8082                	ret

0000000080002810 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002810:	1101                	addi	sp,sp,-32
    80002812:	ec06                	sd	ra,24(sp)
    80002814:	e822                	sd	s0,16(sp)
    80002816:	e426                	sd	s1,8(sp)
    80002818:	1000                	addi	s0,sp,32
    8000281a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000281c:	eefff0ef          	jal	8000270a <argraw>
    80002820:	e088                	sd	a0,0(s1)
}
    80002822:	60e2                	ld	ra,24(sp)
    80002824:	6442                	ld	s0,16(sp)
    80002826:	64a2                	ld	s1,8(sp)
    80002828:	6105                	addi	sp,sp,32
    8000282a:	8082                	ret

000000008000282c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000282c:	1101                	addi	sp,sp,-32
    8000282e:	ec06                	sd	ra,24(sp)
    80002830:	e822                	sd	s0,16(sp)
    80002832:	e426                	sd	s1,8(sp)
    80002834:	e04a                	sd	s2,0(sp)
    80002836:	1000                	addi	s0,sp,32
    80002838:	84ae                	mv	s1,a1
    8000283a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000283c:	ecfff0ef          	jal	8000270a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002840:	864a                	mv	a2,s2
    80002842:	85a6                	mv	a1,s1
    80002844:	f71ff0ef          	jal	800027b4 <fetchstr>
}
    80002848:	60e2                	ld	ra,24(sp)
    8000284a:	6442                	ld	s0,16(sp)
    8000284c:	64a2                	ld	s1,8(sp)
    8000284e:	6902                	ld	s2,0(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret

0000000080002854 <syscall>:
[SYS_getactiveprocesses]    sys_getactiveprocesses,
};

void
syscall(void)
{
    80002854:	1101                	addi	sp,sp,-32
    80002856:	ec06                	sd	ra,24(sp)
    80002858:	e822                	sd	s0,16(sp)
    8000285a:	e426                	sd	s1,8(sp)
    8000285c:	e04a                	sd	s2,0(sp)
    8000285e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002860:	87cff0ef          	jal	800018dc <myproc>
    80002864:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002866:	05853903          	ld	s2,88(a0)
    8000286a:	0a893783          	ld	a5,168(s2)
    8000286e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002872:	37fd                	addiw	a5,a5,-1
    80002874:	4765                	li	a4,25
    80002876:	00f76f63          	bltu	a4,a5,80002894 <syscall+0x40>
    8000287a:	00369713          	slli	a4,a3,0x3
    8000287e:	00006797          	auipc	a5,0x6
    80002882:	0f278793          	addi	a5,a5,242 # 80008970 <syscalls>
    80002886:	97ba                	add	a5,a5,a4
    80002888:	639c                	ld	a5,0(a5)
    8000288a:	c789                	beqz	a5,80002894 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000288c:	9782                	jalr	a5
    8000288e:	06a93823          	sd	a0,112(s2)
    80002892:	a829                	j	800028ac <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002894:	15848613          	addi	a2,s1,344
    80002898:	588c                	lw	a1,48(s1)
    8000289a:	00006517          	auipc	a0,0x6
    8000289e:	b7650513          	addi	a0,a0,-1162 # 80008410 <etext+0x410>
    800028a2:	c2dfd0ef          	jal	800004ce <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800028a6:	6cbc                	ld	a5,88(s1)
    800028a8:	577d                	li	a4,-1
    800028aa:	fbb8                	sd	a4,112(a5)
  }
}
    800028ac:	60e2                	ld	ra,24(sp)
    800028ae:	6442                	ld	s0,16(sp)
    800028b0:	64a2                	ld	s1,8(sp)
    800028b2:	6902                	ld	s2,0(sp)
    800028b4:	6105                	addi	sp,sp,32
    800028b6:	8082                	ret

00000000800028b8 <sys_exit>:

extern struct proc proc[];

uint64
sys_exit(void)
{
    800028b8:	1101                	addi	sp,sp,-32
    800028ba:	ec06                	sd	ra,24(sp)
    800028bc:	e822                	sd	s0,16(sp)
    800028be:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800028c0:	fec40593          	addi	a1,s0,-20
    800028c4:	4501                	li	a0,0
    800028c6:	f2fff0ef          	jal	800027f4 <argint>
  exit(n);
    800028ca:	fec42503          	lw	a0,-20(s0)
    800028ce:	ee8ff0ef          	jal	80001fb6 <exit>
  return 0;  // not reached
}
    800028d2:	4501                	li	a0,0
    800028d4:	60e2                	ld	ra,24(sp)
    800028d6:	6442                	ld	s0,16(sp)
    800028d8:	6105                	addi	sp,sp,32
    800028da:	8082                	ret

00000000800028dc <sys_getpid>:

uint64
sys_getpid(void)
{
    800028dc:	1141                	addi	sp,sp,-16
    800028de:	e406                	sd	ra,8(sp)
    800028e0:	e022                	sd	s0,0(sp)
    800028e2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800028e4:	ff9fe0ef          	jal	800018dc <myproc>
}
    800028e8:	5908                	lw	a0,48(a0)
    800028ea:	60a2                	ld	ra,8(sp)
    800028ec:	6402                	ld	s0,0(sp)
    800028ee:	0141                	addi	sp,sp,16
    800028f0:	8082                	ret

00000000800028f2 <sys_fork>:

uint64
sys_fork(void)
{
    800028f2:	1141                	addi	sp,sp,-16
    800028f4:	e406                	sd	ra,8(sp)
    800028f6:	e022                	sd	s0,0(sp)
    800028f8:	0800                	addi	s0,sp,16
  return fork();
    800028fa:	b08ff0ef          	jal	80001c02 <fork>
}
    800028fe:	60a2                	ld	ra,8(sp)
    80002900:	6402                	ld	s0,0(sp)
    80002902:	0141                	addi	sp,sp,16
    80002904:	8082                	ret

0000000080002906 <sys_wait>:

uint64
sys_wait(void)
{
    80002906:	1101                	addi	sp,sp,-32
    80002908:	ec06                	sd	ra,24(sp)
    8000290a:	e822                	sd	s0,16(sp)
    8000290c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000290e:	fe840593          	addi	a1,s0,-24
    80002912:	4501                	li	a0,0
    80002914:	efdff0ef          	jal	80002810 <argaddr>
  return wait(p);
    80002918:	fe843503          	ld	a0,-24(s0)
    8000291c:	ff0ff0ef          	jal	8000210c <wait>
}
    80002920:	60e2                	ld	ra,24(sp)
    80002922:	6442                	ld	s0,16(sp)
    80002924:	6105                	addi	sp,sp,32
    80002926:	8082                	ret

0000000080002928 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002928:	7179                	addi	sp,sp,-48
    8000292a:	f406                	sd	ra,40(sp)
    8000292c:	f022                	sd	s0,32(sp)
    8000292e:	ec26                	sd	s1,24(sp)
    80002930:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002932:	fdc40593          	addi	a1,s0,-36
    80002936:	4501                	li	a0,0
    80002938:	ebdff0ef          	jal	800027f4 <argint>
  addr = myproc()->sz;
    8000293c:	fa1fe0ef          	jal	800018dc <myproc>
    80002940:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002942:	fdc42503          	lw	a0,-36(s0)
    80002946:	a6cff0ef          	jal	80001bb2 <growproc>
    8000294a:	00054863          	bltz	a0,8000295a <sys_sbrk+0x32>
    return -1;
  return addr;
}
    8000294e:	8526                	mv	a0,s1
    80002950:	70a2                	ld	ra,40(sp)
    80002952:	7402                	ld	s0,32(sp)
    80002954:	64e2                	ld	s1,24(sp)
    80002956:	6145                	addi	sp,sp,48
    80002958:	8082                	ret
    return -1;
    8000295a:	54fd                	li	s1,-1
    8000295c:	bfcd                	j	8000294e <sys_sbrk+0x26>

000000008000295e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000295e:	7139                	addi	sp,sp,-64
    80002960:	fc06                	sd	ra,56(sp)
    80002962:	f822                	sd	s0,48(sp)
    80002964:	f04a                	sd	s2,32(sp)
    80002966:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002968:	fcc40593          	addi	a1,s0,-52
    8000296c:	4501                	li	a0,0
    8000296e:	e87ff0ef          	jal	800027f4 <argint>
  if(n < 0)
    80002972:	fcc42783          	lw	a5,-52(s0)
    80002976:	0607c763          	bltz	a5,800029e4 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000297a:	00014517          	auipc	a0,0x14
    8000297e:	0c650513          	addi	a0,a0,198 # 80016a40 <tickslock>
    80002982:	a7cfe0ef          	jal	80000bfe <acquire>
  ticks0 = ticks;
    80002986:	00006917          	auipc	s2,0x6
    8000298a:	14a92903          	lw	s2,330(s2) # 80008ad0 <ticks>
  while(ticks - ticks0 < n){
    8000298e:	fcc42783          	lw	a5,-52(s0)
    80002992:	cf8d                	beqz	a5,800029cc <sys_sleep+0x6e>
    80002994:	f426                	sd	s1,40(sp)
    80002996:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002998:	00014997          	auipc	s3,0x14
    8000299c:	0a898993          	addi	s3,s3,168 # 80016a40 <tickslock>
    800029a0:	00006497          	auipc	s1,0x6
    800029a4:	13048493          	addi	s1,s1,304 # 80008ad0 <ticks>
    if(killed(myproc())){
    800029a8:	f35fe0ef          	jal	800018dc <myproc>
    800029ac:	f36ff0ef          	jal	800020e2 <killed>
    800029b0:	ed0d                	bnez	a0,800029ea <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800029b2:	85ce                	mv	a1,s3
    800029b4:	8526                	mv	a0,s1
    800029b6:	cf4ff0ef          	jal	80001eaa <sleep>
  while(ticks - ticks0 < n){
    800029ba:	409c                	lw	a5,0(s1)
    800029bc:	412787bb          	subw	a5,a5,s2
    800029c0:	fcc42703          	lw	a4,-52(s0)
    800029c4:	fee7e2e3          	bltu	a5,a4,800029a8 <sys_sleep+0x4a>
    800029c8:	74a2                	ld	s1,40(sp)
    800029ca:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800029cc:	00014517          	auipc	a0,0x14
    800029d0:	07450513          	addi	a0,a0,116 # 80016a40 <tickslock>
    800029d4:	abefe0ef          	jal	80000c92 <release>
  return 0;
    800029d8:	4501                	li	a0,0
}
    800029da:	70e2                	ld	ra,56(sp)
    800029dc:	7442                	ld	s0,48(sp)
    800029de:	7902                	ld	s2,32(sp)
    800029e0:	6121                	addi	sp,sp,64
    800029e2:	8082                	ret
    n = 0;
    800029e4:	fc042623          	sw	zero,-52(s0)
    800029e8:	bf49                	j	8000297a <sys_sleep+0x1c>
      release(&tickslock);
    800029ea:	00014517          	auipc	a0,0x14
    800029ee:	05650513          	addi	a0,a0,86 # 80016a40 <tickslock>
    800029f2:	aa0fe0ef          	jal	80000c92 <release>
      return -1;
    800029f6:	557d                	li	a0,-1
    800029f8:	74a2                	ld	s1,40(sp)
    800029fa:	69e2                	ld	s3,24(sp)
    800029fc:	bff9                	j	800029da <sys_sleep+0x7c>

00000000800029fe <sys_kill>:

uint64
sys_kill(void)
{
    800029fe:	1101                	addi	sp,sp,-32
    80002a00:	ec06                	sd	ra,24(sp)
    80002a02:	e822                	sd	s0,16(sp)
    80002a04:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a06:	fec40593          	addi	a1,s0,-20
    80002a0a:	4501                	li	a0,0
    80002a0c:	de9ff0ef          	jal	800027f4 <argint>
  return kill(pid);
    80002a10:	fec42503          	lw	a0,-20(s0)
    80002a14:	e44ff0ef          	jal	80002058 <kill>
}
    80002a18:	60e2                	ld	ra,24(sp)
    80002a1a:	6442                	ld	s0,16(sp)
    80002a1c:	6105                	addi	sp,sp,32
    80002a1e:	8082                	ret

0000000080002a20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a20:	1101                	addi	sp,sp,-32
    80002a22:	ec06                	sd	ra,24(sp)
    80002a24:	e822                	sd	s0,16(sp)
    80002a26:	e426                	sd	s1,8(sp)
    80002a28:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a2a:	00014517          	auipc	a0,0x14
    80002a2e:	01650513          	addi	a0,a0,22 # 80016a40 <tickslock>
    80002a32:	9ccfe0ef          	jal	80000bfe <acquire>
  xticks = ticks;
    80002a36:	00006497          	auipc	s1,0x6
    80002a3a:	09a4a483          	lw	s1,154(s1) # 80008ad0 <ticks>
  release(&tickslock);
    80002a3e:	00014517          	auipc	a0,0x14
    80002a42:	00250513          	addi	a0,a0,2 # 80016a40 <tickslock>
    80002a46:	a4cfe0ef          	jal	80000c92 <release>
  return xticks;
}
    80002a4a:	02049513          	slli	a0,s1,0x20
    80002a4e:	9101                	srli	a0,a0,0x20
    80002a50:	60e2                	ld	ra,24(sp)
    80002a52:	6442                	ld	s0,16(sp)
    80002a54:	64a2                	ld	s1,8(sp)
    80002a56:	6105                	addi	sp,sp,32
    80002a58:	8082                	ret

0000000080002a5a <sys_getmemusage>:

uint64
sys_getmemusage(void)
{
    80002a5a:	1101                	addi	sp,sp,-32
    80002a5c:	ec06                	sd	ra,24(sp)
    80002a5e:	e822                	sd	s0,16(sp)
    80002a60:	1000                	addi	s0,sp,32
    int pid;
    struct proc *p = 0;

    argint(0, &pid);  // get the pid argument from user space
    80002a62:	fec40593          	addi	a1,s0,-20
    80002a66:	4501                	li	a0,0
    80002a68:	d8dff0ef          	jal	800027f4 <argint>

    for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
        if (pp->pid == pid) {
    80002a6c:	fec42683          	lw	a3,-20(s0)
    for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    80002a70:	0000e797          	auipc	a5,0xe
    80002a74:	5d078793          	addi	a5,a5,1488 # 80011040 <proc>
    80002a78:	00014617          	auipc	a2,0x14
    80002a7c:	fc860613          	addi	a2,a2,-56 # 80016a40 <tickslock>
        if (pp->pid == pid) {
    80002a80:	5b98                	lw	a4,48(a5)
    80002a82:	00d70863          	beq	a4,a3,80002a92 <sys_getmemusage+0x38>
    for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    80002a86:	16878793          	addi	a5,a5,360
    80002a8a:	fec79be3          	bne	a5,a2,80002a80 <sys_getmemusage+0x26>
    }

    if (p) {
        return (uint64)p->sz;
    } else {
        return -1;
    80002a8e:	557d                	li	a0,-1
    80002a90:	a011                	j	80002a94 <sys_getmemusage+0x3a>
        return (uint64)p->sz;
    80002a92:	67a8                	ld	a0,72(a5)
    }
}
    80002a94:	60e2                	ld	ra,24(sp)
    80002a96:	6442                	ld	s0,16(sp)
    80002a98:	6105                	addi	sp,sp,32
    80002a9a:	8082                	ret

0000000080002a9c <sys_ps>:

uint64
sys_ps(void)
{
    80002a9c:	7175                	addi	sp,sp,-144
    80002a9e:	e506                	sd	ra,136(sp)
    80002aa0:	e122                	sd	s0,128(sp)
    80002aa2:	fca6                	sd	s1,120(sp)
    80002aa4:	f8ca                	sd	s2,112(sp)
    80002aa6:	f4ce                	sd	s3,104(sp)
    80002aa8:	f0d2                	sd	s4,96(sp)
    80002aaa:	ecd6                	sd	s5,88(sp)
    80002aac:	e8da                	sd	s6,80(sp)
    80002aae:	e4de                	sd	s7,72(sp)
    80002ab0:	0900                	addi	s0,sp,144
    struct procinfo *u_procinfo;
    int max;

    // args from user space
    argaddr(0, (uint64 *)&u_procinfo);
    80002ab2:	fa840593          	addi	a1,s0,-88
    80002ab6:	4501                	li	a0,0
    80002ab8:	d59ff0ef          	jal	80002810 <argaddr>
    argint(1, &max);
    80002abc:	fa440593          	addi	a1,s0,-92
    80002ac0:	4505                	li	a0,1
    80002ac2:	d33ff0ef          	jal	800027f4 <argint>

    int count = 0;

    for (struct proc *p = proc; p < &proc[NPROC] && count < max; p++) {
    80002ac6:	0000e497          	auipc	s1,0xe
    80002aca:	6d248493          	addi	s1,s1,1746 # 80011198 <proc+0x158>
    80002ace:	00014997          	auipc	s3,0x14
    80002ad2:	0ca98993          	addi	s3,s3,202 # 80016b98 <bcache+0x140>
    int count = 0;
    80002ad6:	4901                	li	s2,0
        if (p->state != UNUSED) {
            struct procinfo pi;
            pi.pid = p->pid;
            pi.state = p->state;
            pi.sz = p->sz;
            safestrcpy(pi.name, p->name, sizeof(pi.name));
    80002ad8:	f7840b93          	addi	s7,s0,-136
    80002adc:	f9040b13          	addi	s6,s0,-112
    80002ae0:	4ac1                	li	s5,16

            if (copyout(myproc()->pagetable, (uint64)(u_procinfo + count), (char *)&pi, sizeof(pi)) < 0)
    80002ae2:	02800a13          	li	s4,40
    80002ae6:	a031                	j	80002af2 <sys_ps+0x56>
                return -1;

            count++;
    80002ae8:	2905                	addiw	s2,s2,1
    for (struct proc *p = proc; p < &proc[NPROC] && count < max; p++) {
    80002aea:	16848493          	addi	s1,s1,360
    80002aee:	05348a63          	beq	s1,s3,80002b42 <sys_ps+0xa6>
    80002af2:	fa442783          	lw	a5,-92(s0)
    80002af6:	04f95663          	bge	s2,a5,80002b42 <sys_ps+0xa6>
        if (p->state != UNUSED) {
    80002afa:	ec04a783          	lw	a5,-320(s1)
    80002afe:	d7f5                	beqz	a5,80002aea <sys_ps+0x4e>
            pi.pid = p->pid;
    80002b00:	ed84a703          	lw	a4,-296(s1)
    80002b04:	f6e42c23          	sw	a4,-136(s0)
            pi.state = p->state;
    80002b08:	f8f42023          	sw	a5,-128(s0)
            pi.sz = p->sz;
    80002b0c:	ef04b783          	ld	a5,-272(s1)
    80002b10:	f8f43423          	sd	a5,-120(s0)
            safestrcpy(pi.name, p->name, sizeof(pi.name));
    80002b14:	8656                	mv	a2,s5
    80002b16:	85a6                	mv	a1,s1
    80002b18:	855a                	mv	a0,s6
    80002b1a:	b06fe0ef          	jal	80000e20 <safestrcpy>
            if (copyout(myproc()->pagetable, (uint64)(u_procinfo + count), (char *)&pi, sizeof(pi)) < 0)
    80002b1e:	dbffe0ef          	jal	800018dc <myproc>
    80002b22:	00291793          	slli	a5,s2,0x2
    80002b26:	97ca                	add	a5,a5,s2
    80002b28:	078e                	slli	a5,a5,0x3
    80002b2a:	86d2                	mv	a3,s4
    80002b2c:	865e                	mv	a2,s7
    80002b2e:	fa843583          	ld	a1,-88(s0)
    80002b32:	95be                	add	a1,a1,a5
    80002b34:	6928                	ld	a0,80(a0)
    80002b36:	a4ffe0ef          	jal	80001584 <copyout>
    80002b3a:	fa0557e3          	bgez	a0,80002ae8 <sys_ps+0x4c>
                return -1;
    80002b3e:	557d                	li	a0,-1
    80002b40:	a011                	j	80002b44 <sys_ps+0xa8>
        }
    }

    return count; // number of procs copied
    80002b42:	854a                	mv	a0,s2
}
    80002b44:	60aa                	ld	ra,136(sp)
    80002b46:	640a                	ld	s0,128(sp)
    80002b48:	74e6                	ld	s1,120(sp)
    80002b4a:	7946                	ld	s2,112(sp)
    80002b4c:	79a6                	ld	s3,104(sp)
    80002b4e:	7a06                	ld	s4,96(sp)
    80002b50:	6ae6                	ld	s5,88(sp)
    80002b52:	6b46                	ld	s6,80(sp)
    80002b54:	6ba6                	ld	s7,72(sp)
    80002b56:	6149                	addi	sp,sp,144
    80002b58:	8082                	ret

0000000080002b5a <sys_pinfo>:

uint64
sys_pinfo(void)
{
    80002b5a:	7159                	addi	sp,sp,-112
    80002b5c:	f486                	sd	ra,104(sp)
    80002b5e:	f0a2                	sd	s0,96(sp)
    80002b60:	eca6                	sd	s1,88(sp)
    80002b62:	e8ca                	sd	s2,80(sp)
    80002b64:	e4ce                	sd	s3,72(sp)
    80002b66:	1880                	addi	s0,sp,112
  int pid;
  uint64 uaddr;
  struct procinfo pi;
  struct proc *p;
  struct proc *curproc = myproc();
    80002b68:	d75fe0ef          	jal	800018dc <myproc>
    80002b6c:	89aa                	mv	s3,a0

  argint(0, &pid);
    80002b6e:	fcc40593          	addi	a1,s0,-52
    80002b72:	4501                	li	a0,0
    80002b74:	c81ff0ef          	jal	800027f4 <argint>
  argaddr(1, &uaddr);
    80002b78:	fc040593          	addi	a1,s0,-64
    80002b7c:	4505                	li	a0,1
    80002b7e:	c93ff0ef          	jal	80002810 <argaddr>
  printf("sys_pinfo: asked for pid %d\n", pid);
    80002b82:	fcc42583          	lw	a1,-52(s0)
    80002b86:	00006517          	auipc	a0,0x6
    80002b8a:	8aa50513          	addi	a0,a0,-1878 # 80008430 <etext+0x430>
    80002b8e:	941fd0ef          	jal	800004ce <printf>


  for (p = proc; p < &proc[NPROC]; p++) {
    80002b92:	0000e497          	auipc	s1,0xe
    80002b96:	4ae48493          	addi	s1,s1,1198 # 80011040 <proc>
    80002b9a:	00014917          	auipc	s2,0x14
    80002b9e:	ea690913          	addi	s2,s2,-346 # 80016a40 <tickslock>
    acquire(&p->lock);
    80002ba2:	8526                	mv	a0,s1
    80002ba4:	85afe0ef          	jal	80000bfe <acquire>
    if (p->pid == pid) {
    80002ba8:	589c                	lw	a5,48(s1)
    80002baa:	fcc42703          	lw	a4,-52(s0)
    80002bae:	00f70b63          	beq	a4,a5,80002bc4 <sys_pinfo+0x6a>

      if (copyout(curproc->pagetable, uaddr, (char*)&pi, sizeof(pi)) < 0)
        return -1;
      return 0;
    }
    release(&p->lock);
    80002bb2:	8526                	mv	a0,s1
    80002bb4:	8defe0ef          	jal	80000c92 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002bb8:	16848493          	addi	s1,s1,360
    80002bbc:	ff2493e3          	bne	s1,s2,80002ba2 <sys_pinfo+0x48>
  }

  return -1;
    80002bc0:	557d                	li	a0,-1
    80002bc2:	a085                	j	80002c22 <sys_pinfo+0xc8>
      pi.pid = p->pid;
    80002bc4:	f8f42c23          	sw	a5,-104(s0)
      pi.ppid = p->parent ? p->parent->pid : -1;
    80002bc8:	7c98                	ld	a4,56(s1)
    80002bca:	57fd                	li	a5,-1
    80002bcc:	c311                	beqz	a4,80002bd0 <sys_pinfo+0x76>
    80002bce:	5b1c                	lw	a5,48(a4)
    80002bd0:	f8f42e23          	sw	a5,-100(s0)
      pi.state = p->state;
    80002bd4:	4c9c                	lw	a5,24(s1)
    80002bd6:	faf42023          	sw	a5,-96(s0)
      pi.sz = p->sz;
    80002bda:	64bc                	ld	a5,72(s1)
    80002bdc:	faf43423          	sd	a5,-88(s0)
      safestrcpy(pi.name, p->name, sizeof(pi.name));
    80002be0:	fb040913          	addi	s2,s0,-80
    80002be4:	4641                	li	a2,16
    80002be6:	15848593          	addi	a1,s1,344
    80002bea:	854a                	mv	a0,s2
    80002bec:	a34fe0ef          	jal	80000e20 <safestrcpy>
      release(&p->lock);
    80002bf0:	8526                	mv	a0,s1
    80002bf2:	8a0fe0ef          	jal	80000c92 <release>
      printf("sys_pinfo: filling pi -> pid %d, ppid %d, name %s\n", pi.pid, pi.ppid, pi.name);
    80002bf6:	86ca                	mv	a3,s2
    80002bf8:	f9c42603          	lw	a2,-100(s0)
    80002bfc:	f9842583          	lw	a1,-104(s0)
    80002c00:	00006517          	auipc	a0,0x6
    80002c04:	85050513          	addi	a0,a0,-1968 # 80008450 <etext+0x450>
    80002c08:	8c7fd0ef          	jal	800004ce <printf>
      if (copyout(curproc->pagetable, uaddr, (char*)&pi, sizeof(pi)) < 0)
    80002c0c:	02800693          	li	a3,40
    80002c10:	f9840613          	addi	a2,s0,-104
    80002c14:	fc043583          	ld	a1,-64(s0)
    80002c18:	0509b503          	ld	a0,80(s3)
    80002c1c:	969fe0ef          	jal	80001584 <copyout>
    80002c20:	957d                	srai	a0,a0,0x3f
}
    80002c22:	70a6                	ld	ra,104(sp)
    80002c24:	7406                	ld	s0,96(sp)
    80002c26:	64e6                	ld	s1,88(sp)
    80002c28:	6946                	ld	s2,80(sp)
    80002c2a:	69a6                	ld	s3,72(sp)
    80002c2c:	6165                	addi	sp,sp,112
    80002c2e:	8082                	ret

0000000080002c30 <sys_getidlepid>:


uint64
sys_getidlepid(void)
{
    80002c30:	7179                	addi	sp,sp,-48
    80002c32:	f406                	sd	ra,40(sp)
    80002c34:	f022                	sd	s0,32(sp)
    80002c36:	ec26                	sd	s1,24(sp)
    80002c38:	e84a                	sd	s2,16(sp)
    80002c3a:	e44e                	sd	s3,8(sp)
    80002c3c:	1800                	addi	s0,sp,48
    struct proc *p;
    int idle_pid = -1;

    for(p = proc; p < &proc[NPROC]; p++) {
    80002c3e:	0000e497          	auipc	s1,0xe
    80002c42:	40248493          	addi	s1,s1,1026 # 80011040 <proc>
        acquire(&p->lock);
        if(p->state == SLEEPING) {
    80002c46:	4909                	li	s2,2
    for(p = proc; p < &proc[NPROC]; p++) {
    80002c48:	00014997          	auipc	s3,0x14
    80002c4c:	df898993          	addi	s3,s3,-520 # 80016a40 <tickslock>
        acquire(&p->lock);
    80002c50:	8526                	mv	a0,s1
    80002c52:	fadfd0ef          	jal	80000bfe <acquire>
        if(p->state == SLEEPING) {
    80002c56:	4c9c                	lw	a5,24(s1)
    80002c58:	01278b63          	beq	a5,s2,80002c6e <sys_getidlepid+0x3e>
            idle_pid = p->pid;
            release(&p->lock);
            break;
        }
        release(&p->lock);
    80002c5c:	8526                	mv	a0,s1
    80002c5e:	834fe0ef          	jal	80000c92 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002c62:	16848493          	addi	s1,s1,360
    80002c66:	ff3495e3          	bne	s1,s3,80002c50 <sys_getidlepid+0x20>
    int idle_pid = -1;
    80002c6a:	597d                	li	s2,-1
    80002c6c:	a031                	j	80002c78 <sys_getidlepid+0x48>
            idle_pid = p->pid;
    80002c6e:	0304a903          	lw	s2,48(s1)
            release(&p->lock);
    80002c72:	8526                	mv	a0,s1
    80002c74:	81efe0ef          	jal	80000c92 <release>
    }
    return idle_pid;
}
    80002c78:	854a                	mv	a0,s2
    80002c7a:	70a2                	ld	ra,40(sp)
    80002c7c:	7402                	ld	s0,32(sp)
    80002c7e:	64e2                	ld	s1,24(sp)
    80002c80:	6942                	ld	s2,16(sp)
    80002c82:	69a2                	ld	s3,8(sp)
    80002c84:	6145                	addi	sp,sp,48
    80002c86:	8082                	ret

0000000080002c88 <sys_getactiveprocesses>:

int sys_getactiveprocesses(void) {
    80002c88:	7169                	addi	sp,sp,-304
    80002c8a:	f606                	sd	ra,296(sp)
    80002c8c:	f222                	sd	s0,288(sp)
    80002c8e:	ee26                	sd	s1,280(sp)
    80002c90:	1a00                	addi	s0,sp,304
  uint64 pids_addr;  // user pointer (uint64 for user space address)
  int max_count;

argint(0, &max_count);
    80002c92:	fd440593          	addi	a1,s0,-44
    80002c96:	4501                	li	a0,0
    80002c98:	b5dff0ef          	jal	800027f4 <argint>
argaddr(1, &pids_addr);
    80002c9c:	fd840593          	addi	a1,s0,-40
    80002ca0:	4505                	li	a0,1
    80002ca2:	b6fff0ef          	jal	80002810 <argaddr>
  int temp_pids[NPROC];  // kernel buffer to store PIDs

  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++) {
      if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
          if (count < max_count) {
    80002ca6:	fd442583          	lw	a1,-44(s0)
  for (p = proc; p < &proc[NPROC]; p++) {
    80002caa:	0000e797          	auipc	a5,0xe
    80002cae:	39678793          	addi	a5,a5,918 # 80011040 <proc>
  int count = 0;
    80002cb2:	4481                	li	s1,0
      if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
    80002cb4:	4609                	li	a2,2
              temp_pids[count++] = p->pid;
    80002cb6:	ed040813          	addi	a6,s0,-304
  for (p = proc; p < &proc[NPROC]; p++) {
    80002cba:	00014697          	auipc	a3,0x14
    80002cbe:	d8668693          	addi	a3,a3,-634 # 80016a40 <tickslock>
    80002cc2:	a029                	j	80002ccc <sys_getactiveprocesses+0x44>
    80002cc4:	16878793          	addi	a5,a5,360
    80002cc8:	00d78f63          	beq	a5,a3,80002ce6 <sys_getactiveprocesses+0x5e>
      if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
    80002ccc:	4f98                	lw	a4,24(a5)
    80002cce:	3779                	addiw	a4,a4,-2
    80002cd0:	fee66ae3          	bltu	a2,a4,80002cc4 <sys_getactiveprocesses+0x3c>
          if (count < max_count) {
    80002cd4:	feb4d8e3          	bge	s1,a1,80002cc4 <sys_getactiveprocesses+0x3c>
              temp_pids[count++] = p->pid;
    80002cd8:	00249713          	slli	a4,s1,0x2
    80002cdc:	9742                	add	a4,a4,a6
    80002cde:	5b88                	lw	a0,48(a5)
    80002ce0:	c308                	sw	a0,0(a4)
    80002ce2:	2485                	addiw	s1,s1,1
    80002ce4:	b7c5                	j	80002cc4 <sys_getactiveprocesses+0x3c>
          }
      }
  }

  // Copy kernel buffer to user space
  if (copyout(myproc()->pagetable, pids_addr, (char *)temp_pids, count * sizeof(int)) < 0)
    80002ce6:	bf7fe0ef          	jal	800018dc <myproc>
    80002cea:	00249693          	slli	a3,s1,0x2
    80002cee:	ed040613          	addi	a2,s0,-304
    80002cf2:	fd843583          	ld	a1,-40(s0)
    80002cf6:	6928                	ld	a0,80(a0)
    80002cf8:	88dfe0ef          	jal	80001584 <copyout>
    80002cfc:	00054863          	bltz	a0,80002d0c <sys_getactiveprocesses+0x84>
      return -1;

  return count;
    80002d00:	8526                	mv	a0,s1
    80002d02:	70b2                	ld	ra,296(sp)
    80002d04:	7412                	ld	s0,288(sp)
    80002d06:	64f2                	ld	s1,280(sp)
    80002d08:	6155                	addi	sp,sp,304
    80002d0a:	8082                	ret
      return -1;
    80002d0c:	54fd                	li	s1,-1
    80002d0e:	bfcd                	j	80002d00 <sys_getactiveprocesses+0x78>

0000000080002d10 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d10:	7179                	addi	sp,sp,-48
    80002d12:	f406                	sd	ra,40(sp)
    80002d14:	f022                	sd	s0,32(sp)
    80002d16:	ec26                	sd	s1,24(sp)
    80002d18:	e84a                	sd	s2,16(sp)
    80002d1a:	e44e                	sd	s3,8(sp)
    80002d1c:	e052                	sd	s4,0(sp)
    80002d1e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d20:	00005597          	auipc	a1,0x5
    80002d24:	76858593          	addi	a1,a1,1896 # 80008488 <etext+0x488>
    80002d28:	00014517          	auipc	a0,0x14
    80002d2c:	d3050513          	addi	a0,a0,-720 # 80016a58 <bcache>
    80002d30:	e4bfd0ef          	jal	80000b7a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d34:	0001c797          	auipc	a5,0x1c
    80002d38:	d2478793          	addi	a5,a5,-732 # 8001ea58 <bcache+0x8000>
    80002d3c:	0001c717          	auipc	a4,0x1c
    80002d40:	f8470713          	addi	a4,a4,-124 # 8001ecc0 <bcache+0x8268>
    80002d44:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d48:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d4c:	00014497          	auipc	s1,0x14
    80002d50:	d2448493          	addi	s1,s1,-732 # 80016a70 <bcache+0x18>
    b->next = bcache.head.next;
    80002d54:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d56:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d58:	00005a17          	auipc	s4,0x5
    80002d5c:	738a0a13          	addi	s4,s4,1848 # 80008490 <etext+0x490>
    b->next = bcache.head.next;
    80002d60:	2b893783          	ld	a5,696(s2)
    80002d64:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002d66:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002d6a:	85d2                	mv	a1,s4
    80002d6c:	01048513          	addi	a0,s1,16
    80002d70:	5c6010ef          	jal	80004336 <initsleeplock>
    bcache.head.next->prev = b;
    80002d74:	2b893783          	ld	a5,696(s2)
    80002d78:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002d7a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d7e:	45848493          	addi	s1,s1,1112
    80002d82:	fd349fe3          	bne	s1,s3,80002d60 <binit+0x50>
  }
}
    80002d86:	70a2                	ld	ra,40(sp)
    80002d88:	7402                	ld	s0,32(sp)
    80002d8a:	64e2                	ld	s1,24(sp)
    80002d8c:	6942                	ld	s2,16(sp)
    80002d8e:	69a2                	ld	s3,8(sp)
    80002d90:	6a02                	ld	s4,0(sp)
    80002d92:	6145                	addi	sp,sp,48
    80002d94:	8082                	ret

0000000080002d96 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002d96:	7179                	addi	sp,sp,-48
    80002d98:	f406                	sd	ra,40(sp)
    80002d9a:	f022                	sd	s0,32(sp)
    80002d9c:	ec26                	sd	s1,24(sp)
    80002d9e:	e84a                	sd	s2,16(sp)
    80002da0:	e44e                	sd	s3,8(sp)
    80002da2:	1800                	addi	s0,sp,48
    80002da4:	892a                	mv	s2,a0
    80002da6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002da8:	00014517          	auipc	a0,0x14
    80002dac:	cb050513          	addi	a0,a0,-848 # 80016a58 <bcache>
    80002db0:	e4ffd0ef          	jal	80000bfe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002db4:	0001c497          	auipc	s1,0x1c
    80002db8:	f5c4b483          	ld	s1,-164(s1) # 8001ed10 <bcache+0x82b8>
    80002dbc:	0001c797          	auipc	a5,0x1c
    80002dc0:	f0478793          	addi	a5,a5,-252 # 8001ecc0 <bcache+0x8268>
    80002dc4:	02f48b63          	beq	s1,a5,80002dfa <bread+0x64>
    80002dc8:	873e                	mv	a4,a5
    80002dca:	a021                	j	80002dd2 <bread+0x3c>
    80002dcc:	68a4                	ld	s1,80(s1)
    80002dce:	02e48663          	beq	s1,a4,80002dfa <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002dd2:	449c                	lw	a5,8(s1)
    80002dd4:	ff279ce3          	bne	a5,s2,80002dcc <bread+0x36>
    80002dd8:	44dc                	lw	a5,12(s1)
    80002dda:	ff3799e3          	bne	a5,s3,80002dcc <bread+0x36>
      b->refcnt++;
    80002dde:	40bc                	lw	a5,64(s1)
    80002de0:	2785                	addiw	a5,a5,1
    80002de2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002de4:	00014517          	auipc	a0,0x14
    80002de8:	c7450513          	addi	a0,a0,-908 # 80016a58 <bcache>
    80002dec:	ea7fd0ef          	jal	80000c92 <release>
      acquiresleep(&b->lock);
    80002df0:	01048513          	addi	a0,s1,16
    80002df4:	578010ef          	jal	8000436c <acquiresleep>
      return b;
    80002df8:	a889                	j	80002e4a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002dfa:	0001c497          	auipc	s1,0x1c
    80002dfe:	f0e4b483          	ld	s1,-242(s1) # 8001ed08 <bcache+0x82b0>
    80002e02:	0001c797          	auipc	a5,0x1c
    80002e06:	ebe78793          	addi	a5,a5,-322 # 8001ecc0 <bcache+0x8268>
    80002e0a:	00f48863          	beq	s1,a5,80002e1a <bread+0x84>
    80002e0e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e10:	40bc                	lw	a5,64(s1)
    80002e12:	cb91                	beqz	a5,80002e26 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e14:	64a4                	ld	s1,72(s1)
    80002e16:	fee49de3          	bne	s1,a4,80002e10 <bread+0x7a>
  panic("bget: no buffers");
    80002e1a:	00005517          	auipc	a0,0x5
    80002e1e:	67e50513          	addi	a0,a0,1662 # 80008498 <etext+0x498>
    80002e22:	97dfd0ef          	jal	8000079e <panic>
      b->dev = dev;
    80002e26:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e2a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e2e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e32:	4785                	li	a5,1
    80002e34:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e36:	00014517          	auipc	a0,0x14
    80002e3a:	c2250513          	addi	a0,a0,-990 # 80016a58 <bcache>
    80002e3e:	e55fd0ef          	jal	80000c92 <release>
      acquiresleep(&b->lock);
    80002e42:	01048513          	addi	a0,s1,16
    80002e46:	526010ef          	jal	8000436c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002e4a:	409c                	lw	a5,0(s1)
    80002e4c:	cb89                	beqz	a5,80002e5e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002e4e:	8526                	mv	a0,s1
    80002e50:	70a2                	ld	ra,40(sp)
    80002e52:	7402                	ld	s0,32(sp)
    80002e54:	64e2                	ld	s1,24(sp)
    80002e56:	6942                	ld	s2,16(sp)
    80002e58:	69a2                	ld	s3,8(sp)
    80002e5a:	6145                	addi	sp,sp,48
    80002e5c:	8082                	ret
    virtio_disk_rw(b, 0);
    80002e5e:	4581                	li	a1,0
    80002e60:	8526                	mv	a0,s1
    80002e62:	57f020ef          	jal	80005be0 <virtio_disk_rw>
    b->valid = 1;
    80002e66:	4785                	li	a5,1
    80002e68:	c09c                	sw	a5,0(s1)
  return b;
    80002e6a:	b7d5                	j	80002e4e <bread+0xb8>

0000000080002e6c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	1000                	addi	s0,sp,32
    80002e76:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e78:	0541                	addi	a0,a0,16
    80002e7a:	570010ef          	jal	800043ea <holdingsleep>
    80002e7e:	c911                	beqz	a0,80002e92 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002e80:	4585                	li	a1,1
    80002e82:	8526                	mv	a0,s1
    80002e84:	55d020ef          	jal	80005be0 <virtio_disk_rw>
}
    80002e88:	60e2                	ld	ra,24(sp)
    80002e8a:	6442                	ld	s0,16(sp)
    80002e8c:	64a2                	ld	s1,8(sp)
    80002e8e:	6105                	addi	sp,sp,32
    80002e90:	8082                	ret
    panic("bwrite");
    80002e92:	00005517          	auipc	a0,0x5
    80002e96:	61e50513          	addi	a0,a0,1566 # 800084b0 <etext+0x4b0>
    80002e9a:	905fd0ef          	jal	8000079e <panic>

0000000080002e9e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002e9e:	1101                	addi	sp,sp,-32
    80002ea0:	ec06                	sd	ra,24(sp)
    80002ea2:	e822                	sd	s0,16(sp)
    80002ea4:	e426                	sd	s1,8(sp)
    80002ea6:	e04a                	sd	s2,0(sp)
    80002ea8:	1000                	addi	s0,sp,32
    80002eaa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002eac:	01050913          	addi	s2,a0,16
    80002eb0:	854a                	mv	a0,s2
    80002eb2:	538010ef          	jal	800043ea <holdingsleep>
    80002eb6:	c125                	beqz	a0,80002f16 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002eb8:	854a                	mv	a0,s2
    80002eba:	4f8010ef          	jal	800043b2 <releasesleep>

  acquire(&bcache.lock);
    80002ebe:	00014517          	auipc	a0,0x14
    80002ec2:	b9a50513          	addi	a0,a0,-1126 # 80016a58 <bcache>
    80002ec6:	d39fd0ef          	jal	80000bfe <acquire>
  b->refcnt--;
    80002eca:	40bc                	lw	a5,64(s1)
    80002ecc:	37fd                	addiw	a5,a5,-1
    80002ece:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002ed0:	e79d                	bnez	a5,80002efe <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002ed2:	68b8                	ld	a4,80(s1)
    80002ed4:	64bc                	ld	a5,72(s1)
    80002ed6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002ed8:	68b8                	ld	a4,80(s1)
    80002eda:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002edc:	0001c797          	auipc	a5,0x1c
    80002ee0:	b7c78793          	addi	a5,a5,-1156 # 8001ea58 <bcache+0x8000>
    80002ee4:	2b87b703          	ld	a4,696(a5)
    80002ee8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002eea:	0001c717          	auipc	a4,0x1c
    80002eee:	dd670713          	addi	a4,a4,-554 # 8001ecc0 <bcache+0x8268>
    80002ef2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002ef4:	2b87b703          	ld	a4,696(a5)
    80002ef8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002efa:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002efe:	00014517          	auipc	a0,0x14
    80002f02:	b5a50513          	addi	a0,a0,-1190 # 80016a58 <bcache>
    80002f06:	d8dfd0ef          	jal	80000c92 <release>
}
    80002f0a:	60e2                	ld	ra,24(sp)
    80002f0c:	6442                	ld	s0,16(sp)
    80002f0e:	64a2                	ld	s1,8(sp)
    80002f10:	6902                	ld	s2,0(sp)
    80002f12:	6105                	addi	sp,sp,32
    80002f14:	8082                	ret
    panic("brelse");
    80002f16:	00005517          	auipc	a0,0x5
    80002f1a:	5a250513          	addi	a0,a0,1442 # 800084b8 <etext+0x4b8>
    80002f1e:	881fd0ef          	jal	8000079e <panic>

0000000080002f22 <bpin>:

void
bpin(struct buf *b) {
    80002f22:	1101                	addi	sp,sp,-32
    80002f24:	ec06                	sd	ra,24(sp)
    80002f26:	e822                	sd	s0,16(sp)
    80002f28:	e426                	sd	s1,8(sp)
    80002f2a:	1000                	addi	s0,sp,32
    80002f2c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f2e:	00014517          	auipc	a0,0x14
    80002f32:	b2a50513          	addi	a0,a0,-1238 # 80016a58 <bcache>
    80002f36:	cc9fd0ef          	jal	80000bfe <acquire>
  b->refcnt++;
    80002f3a:	40bc                	lw	a5,64(s1)
    80002f3c:	2785                	addiw	a5,a5,1
    80002f3e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f40:	00014517          	auipc	a0,0x14
    80002f44:	b1850513          	addi	a0,a0,-1256 # 80016a58 <bcache>
    80002f48:	d4bfd0ef          	jal	80000c92 <release>
}
    80002f4c:	60e2                	ld	ra,24(sp)
    80002f4e:	6442                	ld	s0,16(sp)
    80002f50:	64a2                	ld	s1,8(sp)
    80002f52:	6105                	addi	sp,sp,32
    80002f54:	8082                	ret

0000000080002f56 <bunpin>:

void
bunpin(struct buf *b) {
    80002f56:	1101                	addi	sp,sp,-32
    80002f58:	ec06                	sd	ra,24(sp)
    80002f5a:	e822                	sd	s0,16(sp)
    80002f5c:	e426                	sd	s1,8(sp)
    80002f5e:	1000                	addi	s0,sp,32
    80002f60:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f62:	00014517          	auipc	a0,0x14
    80002f66:	af650513          	addi	a0,a0,-1290 # 80016a58 <bcache>
    80002f6a:	c95fd0ef          	jal	80000bfe <acquire>
  b->refcnt--;
    80002f6e:	40bc                	lw	a5,64(s1)
    80002f70:	37fd                	addiw	a5,a5,-1
    80002f72:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f74:	00014517          	auipc	a0,0x14
    80002f78:	ae450513          	addi	a0,a0,-1308 # 80016a58 <bcache>
    80002f7c:	d17fd0ef          	jal	80000c92 <release>
}
    80002f80:	60e2                	ld	ra,24(sp)
    80002f82:	6442                	ld	s0,16(sp)
    80002f84:	64a2                	ld	s1,8(sp)
    80002f86:	6105                	addi	sp,sp,32
    80002f88:	8082                	ret

0000000080002f8a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002f8a:	1101                	addi	sp,sp,-32
    80002f8c:	ec06                	sd	ra,24(sp)
    80002f8e:	e822                	sd	s0,16(sp)
    80002f90:	e426                	sd	s1,8(sp)
    80002f92:	e04a                	sd	s2,0(sp)
    80002f94:	1000                	addi	s0,sp,32
    80002f96:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002f98:	00d5d79b          	srliw	a5,a1,0xd
    80002f9c:	0001c597          	auipc	a1,0x1c
    80002fa0:	1985a583          	lw	a1,408(a1) # 8001f134 <sb+0x1c>
    80002fa4:	9dbd                	addw	a1,a1,a5
    80002fa6:	df1ff0ef          	jal	80002d96 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002faa:	0074f713          	andi	a4,s1,7
    80002fae:	4785                	li	a5,1
    80002fb0:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002fb4:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002fb6:	90d9                	srli	s1,s1,0x36
    80002fb8:	00950733          	add	a4,a0,s1
    80002fbc:	05874703          	lbu	a4,88(a4)
    80002fc0:	00e7f6b3          	and	a3,a5,a4
    80002fc4:	c29d                	beqz	a3,80002fea <bfree+0x60>
    80002fc6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002fc8:	94aa                	add	s1,s1,a0
    80002fca:	fff7c793          	not	a5,a5
    80002fce:	8f7d                	and	a4,a4,a5
    80002fd0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002fd4:	292010ef          	jal	80004266 <log_write>
  brelse(bp);
    80002fd8:	854a                	mv	a0,s2
    80002fda:	ec5ff0ef          	jal	80002e9e <brelse>
}
    80002fde:	60e2                	ld	ra,24(sp)
    80002fe0:	6442                	ld	s0,16(sp)
    80002fe2:	64a2                	ld	s1,8(sp)
    80002fe4:	6902                	ld	s2,0(sp)
    80002fe6:	6105                	addi	sp,sp,32
    80002fe8:	8082                	ret
    panic("freeing free block");
    80002fea:	00005517          	auipc	a0,0x5
    80002fee:	4d650513          	addi	a0,a0,1238 # 800084c0 <etext+0x4c0>
    80002ff2:	facfd0ef          	jal	8000079e <panic>

0000000080002ff6 <balloc>:
{
    80002ff6:	715d                	addi	sp,sp,-80
    80002ff8:	e486                	sd	ra,72(sp)
    80002ffa:	e0a2                	sd	s0,64(sp)
    80002ffc:	fc26                	sd	s1,56(sp)
    80002ffe:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003000:	0001c797          	auipc	a5,0x1c
    80003004:	11c7a783          	lw	a5,284(a5) # 8001f11c <sb+0x4>
    80003008:	0e078863          	beqz	a5,800030f8 <balloc+0x102>
    8000300c:	f84a                	sd	s2,48(sp)
    8000300e:	f44e                	sd	s3,40(sp)
    80003010:	f052                	sd	s4,32(sp)
    80003012:	ec56                	sd	s5,24(sp)
    80003014:	e85a                	sd	s6,16(sp)
    80003016:	e45e                	sd	s7,8(sp)
    80003018:	e062                	sd	s8,0(sp)
    8000301a:	8baa                	mv	s7,a0
    8000301c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000301e:	0001cb17          	auipc	s6,0x1c
    80003022:	0fab0b13          	addi	s6,s6,250 # 8001f118 <sb>
      m = 1 << (bi % 8);
    80003026:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003028:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000302a:	6c09                	lui	s8,0x2
    8000302c:	a09d                	j	80003092 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000302e:	97ca                	add	a5,a5,s2
    80003030:	8e55                	or	a2,a2,a3
    80003032:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003036:	854a                	mv	a0,s2
    80003038:	22e010ef          	jal	80004266 <log_write>
        brelse(bp);
    8000303c:	854a                	mv	a0,s2
    8000303e:	e61ff0ef          	jal	80002e9e <brelse>
  bp = bread(dev, bno);
    80003042:	85a6                	mv	a1,s1
    80003044:	855e                	mv	a0,s7
    80003046:	d51ff0ef          	jal	80002d96 <bread>
    8000304a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000304c:	40000613          	li	a2,1024
    80003050:	4581                	li	a1,0
    80003052:	05850513          	addi	a0,a0,88
    80003056:	c79fd0ef          	jal	80000cce <memset>
  log_write(bp);
    8000305a:	854a                	mv	a0,s2
    8000305c:	20a010ef          	jal	80004266 <log_write>
  brelse(bp);
    80003060:	854a                	mv	a0,s2
    80003062:	e3dff0ef          	jal	80002e9e <brelse>
}
    80003066:	7942                	ld	s2,48(sp)
    80003068:	79a2                	ld	s3,40(sp)
    8000306a:	7a02                	ld	s4,32(sp)
    8000306c:	6ae2                	ld	s5,24(sp)
    8000306e:	6b42                	ld	s6,16(sp)
    80003070:	6ba2                	ld	s7,8(sp)
    80003072:	6c02                	ld	s8,0(sp)
}
    80003074:	8526                	mv	a0,s1
    80003076:	60a6                	ld	ra,72(sp)
    80003078:	6406                	ld	s0,64(sp)
    8000307a:	74e2                	ld	s1,56(sp)
    8000307c:	6161                	addi	sp,sp,80
    8000307e:	8082                	ret
    brelse(bp);
    80003080:	854a                	mv	a0,s2
    80003082:	e1dff0ef          	jal	80002e9e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003086:	015c0abb          	addw	s5,s8,s5
    8000308a:	004b2783          	lw	a5,4(s6)
    8000308e:	04fafe63          	bgeu	s5,a5,800030ea <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80003092:	41fad79b          	sraiw	a5,s5,0x1f
    80003096:	0137d79b          	srliw	a5,a5,0x13
    8000309a:	015787bb          	addw	a5,a5,s5
    8000309e:	40d7d79b          	sraiw	a5,a5,0xd
    800030a2:	01cb2583          	lw	a1,28(s6)
    800030a6:	9dbd                	addw	a1,a1,a5
    800030a8:	855e                	mv	a0,s7
    800030aa:	cedff0ef          	jal	80002d96 <bread>
    800030ae:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030b0:	004b2503          	lw	a0,4(s6)
    800030b4:	84d6                	mv	s1,s5
    800030b6:	4701                	li	a4,0
    800030b8:	fca4f4e3          	bgeu	s1,a0,80003080 <balloc+0x8a>
      m = 1 << (bi % 8);
    800030bc:	00777693          	andi	a3,a4,7
    800030c0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800030c4:	41f7579b          	sraiw	a5,a4,0x1f
    800030c8:	01d7d79b          	srliw	a5,a5,0x1d
    800030cc:	9fb9                	addw	a5,a5,a4
    800030ce:	4037d79b          	sraiw	a5,a5,0x3
    800030d2:	00f90633          	add	a2,s2,a5
    800030d6:	05864603          	lbu	a2,88(a2)
    800030da:	00c6f5b3          	and	a1,a3,a2
    800030de:	d9a1                	beqz	a1,8000302e <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e0:	2705                	addiw	a4,a4,1
    800030e2:	2485                	addiw	s1,s1,1
    800030e4:	fd471ae3          	bne	a4,s4,800030b8 <balloc+0xc2>
    800030e8:	bf61                	j	80003080 <balloc+0x8a>
    800030ea:	7942                	ld	s2,48(sp)
    800030ec:	79a2                	ld	s3,40(sp)
    800030ee:	7a02                	ld	s4,32(sp)
    800030f0:	6ae2                	ld	s5,24(sp)
    800030f2:	6b42                	ld	s6,16(sp)
    800030f4:	6ba2                	ld	s7,8(sp)
    800030f6:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800030f8:	00005517          	auipc	a0,0x5
    800030fc:	3e050513          	addi	a0,a0,992 # 800084d8 <etext+0x4d8>
    80003100:	bcefd0ef          	jal	800004ce <printf>
  return 0;
    80003104:	4481                	li	s1,0
    80003106:	b7bd                	j	80003074 <balloc+0x7e>

0000000080003108 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003108:	7179                	addi	sp,sp,-48
    8000310a:	f406                	sd	ra,40(sp)
    8000310c:	f022                	sd	s0,32(sp)
    8000310e:	ec26                	sd	s1,24(sp)
    80003110:	e84a                	sd	s2,16(sp)
    80003112:	e44e                	sd	s3,8(sp)
    80003114:	1800                	addi	s0,sp,48
    80003116:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003118:	47ad                	li	a5,11
    8000311a:	02b7e363          	bltu	a5,a1,80003140 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000311e:	02059793          	slli	a5,a1,0x20
    80003122:	01e7d593          	srli	a1,a5,0x1e
    80003126:	00b504b3          	add	s1,a0,a1
    8000312a:	0504a903          	lw	s2,80(s1)
    8000312e:	06091363          	bnez	s2,80003194 <bmap+0x8c>
      addr = balloc(ip->dev);
    80003132:	4108                	lw	a0,0(a0)
    80003134:	ec3ff0ef          	jal	80002ff6 <balloc>
    80003138:	892a                	mv	s2,a0
      if(addr == 0)
    8000313a:	cd29                	beqz	a0,80003194 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    8000313c:	c8a8                	sw	a0,80(s1)
    8000313e:	a899                	j	80003194 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003140:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80003144:	0ff00793          	li	a5,255
    80003148:	0697e963          	bltu	a5,s1,800031ba <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000314c:	08052903          	lw	s2,128(a0)
    80003150:	00091b63          	bnez	s2,80003166 <bmap+0x5e>
      addr = balloc(ip->dev);
    80003154:	4108                	lw	a0,0(a0)
    80003156:	ea1ff0ef          	jal	80002ff6 <balloc>
    8000315a:	892a                	mv	s2,a0
      if(addr == 0)
    8000315c:	cd05                	beqz	a0,80003194 <bmap+0x8c>
    8000315e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003160:	08a9a023          	sw	a0,128(s3)
    80003164:	a011                	j	80003168 <bmap+0x60>
    80003166:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003168:	85ca                	mv	a1,s2
    8000316a:	0009a503          	lw	a0,0(s3)
    8000316e:	c29ff0ef          	jal	80002d96 <bread>
    80003172:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003174:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003178:	02049713          	slli	a4,s1,0x20
    8000317c:	01e75593          	srli	a1,a4,0x1e
    80003180:	00b784b3          	add	s1,a5,a1
    80003184:	0004a903          	lw	s2,0(s1)
    80003188:	00090e63          	beqz	s2,800031a4 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000318c:	8552                	mv	a0,s4
    8000318e:	d11ff0ef          	jal	80002e9e <brelse>
    return addr;
    80003192:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003194:	854a                	mv	a0,s2
    80003196:	70a2                	ld	ra,40(sp)
    80003198:	7402                	ld	s0,32(sp)
    8000319a:	64e2                	ld	s1,24(sp)
    8000319c:	6942                	ld	s2,16(sp)
    8000319e:	69a2                	ld	s3,8(sp)
    800031a0:	6145                	addi	sp,sp,48
    800031a2:	8082                	ret
      addr = balloc(ip->dev);
    800031a4:	0009a503          	lw	a0,0(s3)
    800031a8:	e4fff0ef          	jal	80002ff6 <balloc>
    800031ac:	892a                	mv	s2,a0
      if(addr){
    800031ae:	dd79                	beqz	a0,8000318c <bmap+0x84>
        a[bn] = addr;
    800031b0:	c088                	sw	a0,0(s1)
        log_write(bp);
    800031b2:	8552                	mv	a0,s4
    800031b4:	0b2010ef          	jal	80004266 <log_write>
    800031b8:	bfd1                	j	8000318c <bmap+0x84>
    800031ba:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800031bc:	00005517          	auipc	a0,0x5
    800031c0:	33450513          	addi	a0,a0,820 # 800084f0 <etext+0x4f0>
    800031c4:	ddafd0ef          	jal	8000079e <panic>

00000000800031c8 <iget>:
{
    800031c8:	7179                	addi	sp,sp,-48
    800031ca:	f406                	sd	ra,40(sp)
    800031cc:	f022                	sd	s0,32(sp)
    800031ce:	ec26                	sd	s1,24(sp)
    800031d0:	e84a                	sd	s2,16(sp)
    800031d2:	e44e                	sd	s3,8(sp)
    800031d4:	e052                	sd	s4,0(sp)
    800031d6:	1800                	addi	s0,sp,48
    800031d8:	89aa                	mv	s3,a0
    800031da:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800031dc:	0001c517          	auipc	a0,0x1c
    800031e0:	f5c50513          	addi	a0,a0,-164 # 8001f138 <itable>
    800031e4:	a1bfd0ef          	jal	80000bfe <acquire>
  empty = 0;
    800031e8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800031ea:	0001c497          	auipc	s1,0x1c
    800031ee:	f6648493          	addi	s1,s1,-154 # 8001f150 <itable+0x18>
    800031f2:	0001e697          	auipc	a3,0x1e
    800031f6:	9ee68693          	addi	a3,a3,-1554 # 80020be0 <log>
    800031fa:	a039                	j	80003208 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800031fc:	02090963          	beqz	s2,8000322e <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003200:	08848493          	addi	s1,s1,136
    80003204:	02d48863          	beq	s1,a3,80003234 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003208:	449c                	lw	a5,8(s1)
    8000320a:	fef059e3          	blez	a5,800031fc <iget+0x34>
    8000320e:	4098                	lw	a4,0(s1)
    80003210:	ff3716e3          	bne	a4,s3,800031fc <iget+0x34>
    80003214:	40d8                	lw	a4,4(s1)
    80003216:	ff4713e3          	bne	a4,s4,800031fc <iget+0x34>
      ip->ref++;
    8000321a:	2785                	addiw	a5,a5,1
    8000321c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000321e:	0001c517          	auipc	a0,0x1c
    80003222:	f1a50513          	addi	a0,a0,-230 # 8001f138 <itable>
    80003226:	a6dfd0ef          	jal	80000c92 <release>
      return ip;
    8000322a:	8926                	mv	s2,s1
    8000322c:	a02d                	j	80003256 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000322e:	fbe9                	bnez	a5,80003200 <iget+0x38>
      empty = ip;
    80003230:	8926                	mv	s2,s1
    80003232:	b7f9                	j	80003200 <iget+0x38>
  if(empty == 0)
    80003234:	02090a63          	beqz	s2,80003268 <iget+0xa0>
  ip->dev = dev;
    80003238:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000323c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003240:	4785                	li	a5,1
    80003242:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003246:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000324a:	0001c517          	auipc	a0,0x1c
    8000324e:	eee50513          	addi	a0,a0,-274 # 8001f138 <itable>
    80003252:	a41fd0ef          	jal	80000c92 <release>
}
    80003256:	854a                	mv	a0,s2
    80003258:	70a2                	ld	ra,40(sp)
    8000325a:	7402                	ld	s0,32(sp)
    8000325c:	64e2                	ld	s1,24(sp)
    8000325e:	6942                	ld	s2,16(sp)
    80003260:	69a2                	ld	s3,8(sp)
    80003262:	6a02                	ld	s4,0(sp)
    80003264:	6145                	addi	sp,sp,48
    80003266:	8082                	ret
    panic("iget: no inodes");
    80003268:	00005517          	auipc	a0,0x5
    8000326c:	2a050513          	addi	a0,a0,672 # 80008508 <etext+0x508>
    80003270:	d2efd0ef          	jal	8000079e <panic>

0000000080003274 <fsinit>:
fsinit(int dev) {
    80003274:	7179                	addi	sp,sp,-48
    80003276:	f406                	sd	ra,40(sp)
    80003278:	f022                	sd	s0,32(sp)
    8000327a:	ec26                	sd	s1,24(sp)
    8000327c:	e84a                	sd	s2,16(sp)
    8000327e:	e44e                	sd	s3,8(sp)
    80003280:	1800                	addi	s0,sp,48
    80003282:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003284:	4585                	li	a1,1
    80003286:	b11ff0ef          	jal	80002d96 <bread>
    8000328a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000328c:	0001c997          	auipc	s3,0x1c
    80003290:	e8c98993          	addi	s3,s3,-372 # 8001f118 <sb>
    80003294:	02000613          	li	a2,32
    80003298:	05850593          	addi	a1,a0,88
    8000329c:	854e                	mv	a0,s3
    8000329e:	a95fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    800032a2:	8526                	mv	a0,s1
    800032a4:	bfbff0ef          	jal	80002e9e <brelse>
  if(sb.magic != FSMAGIC)
    800032a8:	0009a703          	lw	a4,0(s3)
    800032ac:	102037b7          	lui	a5,0x10203
    800032b0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800032b4:	02f71063          	bne	a4,a5,800032d4 <fsinit+0x60>
  initlog(dev, &sb);
    800032b8:	0001c597          	auipc	a1,0x1c
    800032bc:	e6058593          	addi	a1,a1,-416 # 8001f118 <sb>
    800032c0:	854a                	mv	a0,s2
    800032c2:	597000ef          	jal	80004058 <initlog>
}
    800032c6:	70a2                	ld	ra,40(sp)
    800032c8:	7402                	ld	s0,32(sp)
    800032ca:	64e2                	ld	s1,24(sp)
    800032cc:	6942                	ld	s2,16(sp)
    800032ce:	69a2                	ld	s3,8(sp)
    800032d0:	6145                	addi	sp,sp,48
    800032d2:	8082                	ret
    panic("invalid file system");
    800032d4:	00005517          	auipc	a0,0x5
    800032d8:	24450513          	addi	a0,a0,580 # 80008518 <etext+0x518>
    800032dc:	cc2fd0ef          	jal	8000079e <panic>

00000000800032e0 <iinit>:
{
    800032e0:	7179                	addi	sp,sp,-48
    800032e2:	f406                	sd	ra,40(sp)
    800032e4:	f022                	sd	s0,32(sp)
    800032e6:	ec26                	sd	s1,24(sp)
    800032e8:	e84a                	sd	s2,16(sp)
    800032ea:	e44e                	sd	s3,8(sp)
    800032ec:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800032ee:	00005597          	auipc	a1,0x5
    800032f2:	24258593          	addi	a1,a1,578 # 80008530 <etext+0x530>
    800032f6:	0001c517          	auipc	a0,0x1c
    800032fa:	e4250513          	addi	a0,a0,-446 # 8001f138 <itable>
    800032fe:	87dfd0ef          	jal	80000b7a <initlock>
  for(i = 0; i < NINODE; i++) {
    80003302:	0001c497          	auipc	s1,0x1c
    80003306:	e5e48493          	addi	s1,s1,-418 # 8001f160 <itable+0x28>
    8000330a:	0001e997          	auipc	s3,0x1e
    8000330e:	8e698993          	addi	s3,s3,-1818 # 80020bf0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003312:	00005917          	auipc	s2,0x5
    80003316:	22690913          	addi	s2,s2,550 # 80008538 <etext+0x538>
    8000331a:	85ca                	mv	a1,s2
    8000331c:	8526                	mv	a0,s1
    8000331e:	018010ef          	jal	80004336 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003322:	08848493          	addi	s1,s1,136
    80003326:	ff349ae3          	bne	s1,s3,8000331a <iinit+0x3a>
}
    8000332a:	70a2                	ld	ra,40(sp)
    8000332c:	7402                	ld	s0,32(sp)
    8000332e:	64e2                	ld	s1,24(sp)
    80003330:	6942                	ld	s2,16(sp)
    80003332:	69a2                	ld	s3,8(sp)
    80003334:	6145                	addi	sp,sp,48
    80003336:	8082                	ret

0000000080003338 <ialloc>:
{
    80003338:	7139                	addi	sp,sp,-64
    8000333a:	fc06                	sd	ra,56(sp)
    8000333c:	f822                	sd	s0,48(sp)
    8000333e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003340:	0001c717          	auipc	a4,0x1c
    80003344:	de472703          	lw	a4,-540(a4) # 8001f124 <sb+0xc>
    80003348:	4785                	li	a5,1
    8000334a:	06e7f063          	bgeu	a5,a4,800033aa <ialloc+0x72>
    8000334e:	f426                	sd	s1,40(sp)
    80003350:	f04a                	sd	s2,32(sp)
    80003352:	ec4e                	sd	s3,24(sp)
    80003354:	e852                	sd	s4,16(sp)
    80003356:	e456                	sd	s5,8(sp)
    80003358:	e05a                	sd	s6,0(sp)
    8000335a:	8aaa                	mv	s5,a0
    8000335c:	8b2e                	mv	s6,a1
    8000335e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003360:	0001ca17          	auipc	s4,0x1c
    80003364:	db8a0a13          	addi	s4,s4,-584 # 8001f118 <sb>
    80003368:	00495593          	srli	a1,s2,0x4
    8000336c:	018a2783          	lw	a5,24(s4)
    80003370:	9dbd                	addw	a1,a1,a5
    80003372:	8556                	mv	a0,s5
    80003374:	a23ff0ef          	jal	80002d96 <bread>
    80003378:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000337a:	05850993          	addi	s3,a0,88
    8000337e:	00f97793          	andi	a5,s2,15
    80003382:	079a                	slli	a5,a5,0x6
    80003384:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003386:	00099783          	lh	a5,0(s3)
    8000338a:	cb9d                	beqz	a5,800033c0 <ialloc+0x88>
    brelse(bp);
    8000338c:	b13ff0ef          	jal	80002e9e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003390:	0905                	addi	s2,s2,1
    80003392:	00ca2703          	lw	a4,12(s4)
    80003396:	0009079b          	sext.w	a5,s2
    8000339a:	fce7e7e3          	bltu	a5,a4,80003368 <ialloc+0x30>
    8000339e:	74a2                	ld	s1,40(sp)
    800033a0:	7902                	ld	s2,32(sp)
    800033a2:	69e2                	ld	s3,24(sp)
    800033a4:	6a42                	ld	s4,16(sp)
    800033a6:	6aa2                	ld	s5,8(sp)
    800033a8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800033aa:	00005517          	auipc	a0,0x5
    800033ae:	19650513          	addi	a0,a0,406 # 80008540 <etext+0x540>
    800033b2:	91cfd0ef          	jal	800004ce <printf>
  return 0;
    800033b6:	4501                	li	a0,0
}
    800033b8:	70e2                	ld	ra,56(sp)
    800033ba:	7442                	ld	s0,48(sp)
    800033bc:	6121                	addi	sp,sp,64
    800033be:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800033c0:	04000613          	li	a2,64
    800033c4:	4581                	li	a1,0
    800033c6:	854e                	mv	a0,s3
    800033c8:	907fd0ef          	jal	80000cce <memset>
      dip->type = type;
    800033cc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800033d0:	8526                	mv	a0,s1
    800033d2:	695000ef          	jal	80004266 <log_write>
      brelse(bp);
    800033d6:	8526                	mv	a0,s1
    800033d8:	ac7ff0ef          	jal	80002e9e <brelse>
      return iget(dev, inum);
    800033dc:	0009059b          	sext.w	a1,s2
    800033e0:	8556                	mv	a0,s5
    800033e2:	de7ff0ef          	jal	800031c8 <iget>
    800033e6:	74a2                	ld	s1,40(sp)
    800033e8:	7902                	ld	s2,32(sp)
    800033ea:	69e2                	ld	s3,24(sp)
    800033ec:	6a42                	ld	s4,16(sp)
    800033ee:	6aa2                	ld	s5,8(sp)
    800033f0:	6b02                	ld	s6,0(sp)
    800033f2:	b7d9                	j	800033b8 <ialloc+0x80>

00000000800033f4 <iupdate>:
{
    800033f4:	1101                	addi	sp,sp,-32
    800033f6:	ec06                	sd	ra,24(sp)
    800033f8:	e822                	sd	s0,16(sp)
    800033fa:	e426                	sd	s1,8(sp)
    800033fc:	e04a                	sd	s2,0(sp)
    800033fe:	1000                	addi	s0,sp,32
    80003400:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003402:	415c                	lw	a5,4(a0)
    80003404:	0047d79b          	srliw	a5,a5,0x4
    80003408:	0001c597          	auipc	a1,0x1c
    8000340c:	d285a583          	lw	a1,-728(a1) # 8001f130 <sb+0x18>
    80003410:	9dbd                	addw	a1,a1,a5
    80003412:	4108                	lw	a0,0(a0)
    80003414:	983ff0ef          	jal	80002d96 <bread>
    80003418:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000341a:	05850793          	addi	a5,a0,88
    8000341e:	40d8                	lw	a4,4(s1)
    80003420:	8b3d                	andi	a4,a4,15
    80003422:	071a                	slli	a4,a4,0x6
    80003424:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003426:	04449703          	lh	a4,68(s1)
    8000342a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000342e:	04649703          	lh	a4,70(s1)
    80003432:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003436:	04849703          	lh	a4,72(s1)
    8000343a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000343e:	04a49703          	lh	a4,74(s1)
    80003442:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003446:	44f8                	lw	a4,76(s1)
    80003448:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000344a:	03400613          	li	a2,52
    8000344e:	05048593          	addi	a1,s1,80
    80003452:	00c78513          	addi	a0,a5,12
    80003456:	8ddfd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    8000345a:	854a                	mv	a0,s2
    8000345c:	60b000ef          	jal	80004266 <log_write>
  brelse(bp);
    80003460:	854a                	mv	a0,s2
    80003462:	a3dff0ef          	jal	80002e9e <brelse>
}
    80003466:	60e2                	ld	ra,24(sp)
    80003468:	6442                	ld	s0,16(sp)
    8000346a:	64a2                	ld	s1,8(sp)
    8000346c:	6902                	ld	s2,0(sp)
    8000346e:	6105                	addi	sp,sp,32
    80003470:	8082                	ret

0000000080003472 <idup>:
{
    80003472:	1101                	addi	sp,sp,-32
    80003474:	ec06                	sd	ra,24(sp)
    80003476:	e822                	sd	s0,16(sp)
    80003478:	e426                	sd	s1,8(sp)
    8000347a:	1000                	addi	s0,sp,32
    8000347c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000347e:	0001c517          	auipc	a0,0x1c
    80003482:	cba50513          	addi	a0,a0,-838 # 8001f138 <itable>
    80003486:	f78fd0ef          	jal	80000bfe <acquire>
  ip->ref++;
    8000348a:	449c                	lw	a5,8(s1)
    8000348c:	2785                	addiw	a5,a5,1
    8000348e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003490:	0001c517          	auipc	a0,0x1c
    80003494:	ca850513          	addi	a0,a0,-856 # 8001f138 <itable>
    80003498:	ffafd0ef          	jal	80000c92 <release>
}
    8000349c:	8526                	mv	a0,s1
    8000349e:	60e2                	ld	ra,24(sp)
    800034a0:	6442                	ld	s0,16(sp)
    800034a2:	64a2                	ld	s1,8(sp)
    800034a4:	6105                	addi	sp,sp,32
    800034a6:	8082                	ret

00000000800034a8 <ilock>:
{
    800034a8:	1101                	addi	sp,sp,-32
    800034aa:	ec06                	sd	ra,24(sp)
    800034ac:	e822                	sd	s0,16(sp)
    800034ae:	e426                	sd	s1,8(sp)
    800034b0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800034b2:	cd19                	beqz	a0,800034d0 <ilock+0x28>
    800034b4:	84aa                	mv	s1,a0
    800034b6:	451c                	lw	a5,8(a0)
    800034b8:	00f05c63          	blez	a5,800034d0 <ilock+0x28>
  acquiresleep(&ip->lock);
    800034bc:	0541                	addi	a0,a0,16
    800034be:	6af000ef          	jal	8000436c <acquiresleep>
  if(ip->valid == 0){
    800034c2:	40bc                	lw	a5,64(s1)
    800034c4:	cf89                	beqz	a5,800034de <ilock+0x36>
}
    800034c6:	60e2                	ld	ra,24(sp)
    800034c8:	6442                	ld	s0,16(sp)
    800034ca:	64a2                	ld	s1,8(sp)
    800034cc:	6105                	addi	sp,sp,32
    800034ce:	8082                	ret
    800034d0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800034d2:	00005517          	auipc	a0,0x5
    800034d6:	08650513          	addi	a0,a0,134 # 80008558 <etext+0x558>
    800034da:	ac4fd0ef          	jal	8000079e <panic>
    800034de:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034e0:	40dc                	lw	a5,4(s1)
    800034e2:	0047d79b          	srliw	a5,a5,0x4
    800034e6:	0001c597          	auipc	a1,0x1c
    800034ea:	c4a5a583          	lw	a1,-950(a1) # 8001f130 <sb+0x18>
    800034ee:	9dbd                	addw	a1,a1,a5
    800034f0:	4088                	lw	a0,0(s1)
    800034f2:	8a5ff0ef          	jal	80002d96 <bread>
    800034f6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800034f8:	05850593          	addi	a1,a0,88
    800034fc:	40dc                	lw	a5,4(s1)
    800034fe:	8bbd                	andi	a5,a5,15
    80003500:	079a                	slli	a5,a5,0x6
    80003502:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003504:	00059783          	lh	a5,0(a1)
    80003508:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000350c:	00259783          	lh	a5,2(a1)
    80003510:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003514:	00459783          	lh	a5,4(a1)
    80003518:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000351c:	00659783          	lh	a5,6(a1)
    80003520:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003524:	459c                	lw	a5,8(a1)
    80003526:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003528:	03400613          	li	a2,52
    8000352c:	05b1                	addi	a1,a1,12
    8000352e:	05048513          	addi	a0,s1,80
    80003532:	801fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    80003536:	854a                	mv	a0,s2
    80003538:	967ff0ef          	jal	80002e9e <brelse>
    ip->valid = 1;
    8000353c:	4785                	li	a5,1
    8000353e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003540:	04449783          	lh	a5,68(s1)
    80003544:	c399                	beqz	a5,8000354a <ilock+0xa2>
    80003546:	6902                	ld	s2,0(sp)
    80003548:	bfbd                	j	800034c6 <ilock+0x1e>
      panic("ilock: no type");
    8000354a:	00005517          	auipc	a0,0x5
    8000354e:	01650513          	addi	a0,a0,22 # 80008560 <etext+0x560>
    80003552:	a4cfd0ef          	jal	8000079e <panic>

0000000080003556 <iunlock>:
{
    80003556:	1101                	addi	sp,sp,-32
    80003558:	ec06                	sd	ra,24(sp)
    8000355a:	e822                	sd	s0,16(sp)
    8000355c:	e426                	sd	s1,8(sp)
    8000355e:	e04a                	sd	s2,0(sp)
    80003560:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003562:	c505                	beqz	a0,8000358a <iunlock+0x34>
    80003564:	84aa                	mv	s1,a0
    80003566:	01050913          	addi	s2,a0,16
    8000356a:	854a                	mv	a0,s2
    8000356c:	67f000ef          	jal	800043ea <holdingsleep>
    80003570:	cd09                	beqz	a0,8000358a <iunlock+0x34>
    80003572:	449c                	lw	a5,8(s1)
    80003574:	00f05b63          	blez	a5,8000358a <iunlock+0x34>
  releasesleep(&ip->lock);
    80003578:	854a                	mv	a0,s2
    8000357a:	639000ef          	jal	800043b2 <releasesleep>
}
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	64a2                	ld	s1,8(sp)
    80003584:	6902                	ld	s2,0(sp)
    80003586:	6105                	addi	sp,sp,32
    80003588:	8082                	ret
    panic("iunlock");
    8000358a:	00005517          	auipc	a0,0x5
    8000358e:	fe650513          	addi	a0,a0,-26 # 80008570 <etext+0x570>
    80003592:	a0cfd0ef          	jal	8000079e <panic>

0000000080003596 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003596:	7179                	addi	sp,sp,-48
    80003598:	f406                	sd	ra,40(sp)
    8000359a:	f022                	sd	s0,32(sp)
    8000359c:	ec26                	sd	s1,24(sp)
    8000359e:	e84a                	sd	s2,16(sp)
    800035a0:	e44e                	sd	s3,8(sp)
    800035a2:	1800                	addi	s0,sp,48
    800035a4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800035a6:	05050493          	addi	s1,a0,80
    800035aa:	08050913          	addi	s2,a0,128
    800035ae:	a021                	j	800035b6 <itrunc+0x20>
    800035b0:	0491                	addi	s1,s1,4
    800035b2:	01248b63          	beq	s1,s2,800035c8 <itrunc+0x32>
    if(ip->addrs[i]){
    800035b6:	408c                	lw	a1,0(s1)
    800035b8:	dde5                	beqz	a1,800035b0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800035ba:	0009a503          	lw	a0,0(s3)
    800035be:	9cdff0ef          	jal	80002f8a <bfree>
      ip->addrs[i] = 0;
    800035c2:	0004a023          	sw	zero,0(s1)
    800035c6:	b7ed                	j	800035b0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800035c8:	0809a583          	lw	a1,128(s3)
    800035cc:	ed89                	bnez	a1,800035e6 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800035ce:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800035d2:	854e                	mv	a0,s3
    800035d4:	e21ff0ef          	jal	800033f4 <iupdate>
}
    800035d8:	70a2                	ld	ra,40(sp)
    800035da:	7402                	ld	s0,32(sp)
    800035dc:	64e2                	ld	s1,24(sp)
    800035de:	6942                	ld	s2,16(sp)
    800035e0:	69a2                	ld	s3,8(sp)
    800035e2:	6145                	addi	sp,sp,48
    800035e4:	8082                	ret
    800035e6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800035e8:	0009a503          	lw	a0,0(s3)
    800035ec:	faaff0ef          	jal	80002d96 <bread>
    800035f0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800035f2:	05850493          	addi	s1,a0,88
    800035f6:	45850913          	addi	s2,a0,1112
    800035fa:	a021                	j	80003602 <itrunc+0x6c>
    800035fc:	0491                	addi	s1,s1,4
    800035fe:	01248963          	beq	s1,s2,80003610 <itrunc+0x7a>
      if(a[j])
    80003602:	408c                	lw	a1,0(s1)
    80003604:	dde5                	beqz	a1,800035fc <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003606:	0009a503          	lw	a0,0(s3)
    8000360a:	981ff0ef          	jal	80002f8a <bfree>
    8000360e:	b7fd                	j	800035fc <itrunc+0x66>
    brelse(bp);
    80003610:	8552                	mv	a0,s4
    80003612:	88dff0ef          	jal	80002e9e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003616:	0809a583          	lw	a1,128(s3)
    8000361a:	0009a503          	lw	a0,0(s3)
    8000361e:	96dff0ef          	jal	80002f8a <bfree>
    ip->addrs[NDIRECT] = 0;
    80003622:	0809a023          	sw	zero,128(s3)
    80003626:	6a02                	ld	s4,0(sp)
    80003628:	b75d                	j	800035ce <itrunc+0x38>

000000008000362a <iput>:
{
    8000362a:	1101                	addi	sp,sp,-32
    8000362c:	ec06                	sd	ra,24(sp)
    8000362e:	e822                	sd	s0,16(sp)
    80003630:	e426                	sd	s1,8(sp)
    80003632:	1000                	addi	s0,sp,32
    80003634:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003636:	0001c517          	auipc	a0,0x1c
    8000363a:	b0250513          	addi	a0,a0,-1278 # 8001f138 <itable>
    8000363e:	dc0fd0ef          	jal	80000bfe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003642:	4498                	lw	a4,8(s1)
    80003644:	4785                	li	a5,1
    80003646:	02f70063          	beq	a4,a5,80003666 <iput+0x3c>
  ip->ref--;
    8000364a:	449c                	lw	a5,8(s1)
    8000364c:	37fd                	addiw	a5,a5,-1
    8000364e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003650:	0001c517          	auipc	a0,0x1c
    80003654:	ae850513          	addi	a0,a0,-1304 # 8001f138 <itable>
    80003658:	e3afd0ef          	jal	80000c92 <release>
}
    8000365c:	60e2                	ld	ra,24(sp)
    8000365e:	6442                	ld	s0,16(sp)
    80003660:	64a2                	ld	s1,8(sp)
    80003662:	6105                	addi	sp,sp,32
    80003664:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003666:	40bc                	lw	a5,64(s1)
    80003668:	d3ed                	beqz	a5,8000364a <iput+0x20>
    8000366a:	04a49783          	lh	a5,74(s1)
    8000366e:	fff1                	bnez	a5,8000364a <iput+0x20>
    80003670:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003672:	01048913          	addi	s2,s1,16
    80003676:	854a                	mv	a0,s2
    80003678:	4f5000ef          	jal	8000436c <acquiresleep>
    release(&itable.lock);
    8000367c:	0001c517          	auipc	a0,0x1c
    80003680:	abc50513          	addi	a0,a0,-1348 # 8001f138 <itable>
    80003684:	e0efd0ef          	jal	80000c92 <release>
    itrunc(ip);
    80003688:	8526                	mv	a0,s1
    8000368a:	f0dff0ef          	jal	80003596 <itrunc>
    ip->type = 0;
    8000368e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003692:	8526                	mv	a0,s1
    80003694:	d61ff0ef          	jal	800033f4 <iupdate>
    ip->valid = 0;
    80003698:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000369c:	854a                	mv	a0,s2
    8000369e:	515000ef          	jal	800043b2 <releasesleep>
    acquire(&itable.lock);
    800036a2:	0001c517          	auipc	a0,0x1c
    800036a6:	a9650513          	addi	a0,a0,-1386 # 8001f138 <itable>
    800036aa:	d54fd0ef          	jal	80000bfe <acquire>
    800036ae:	6902                	ld	s2,0(sp)
    800036b0:	bf69                	j	8000364a <iput+0x20>

00000000800036b2 <iunlockput>:
{
    800036b2:	1101                	addi	sp,sp,-32
    800036b4:	ec06                	sd	ra,24(sp)
    800036b6:	e822                	sd	s0,16(sp)
    800036b8:	e426                	sd	s1,8(sp)
    800036ba:	1000                	addi	s0,sp,32
    800036bc:	84aa                	mv	s1,a0
  iunlock(ip);
    800036be:	e99ff0ef          	jal	80003556 <iunlock>
  iput(ip);
    800036c2:	8526                	mv	a0,s1
    800036c4:	f67ff0ef          	jal	8000362a <iput>
}
    800036c8:	60e2                	ld	ra,24(sp)
    800036ca:	6442                	ld	s0,16(sp)
    800036cc:	64a2                	ld	s1,8(sp)
    800036ce:	6105                	addi	sp,sp,32
    800036d0:	8082                	ret

00000000800036d2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800036d2:	1141                	addi	sp,sp,-16
    800036d4:	e406                	sd	ra,8(sp)
    800036d6:	e022                	sd	s0,0(sp)
    800036d8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800036da:	411c                	lw	a5,0(a0)
    800036dc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800036de:	415c                	lw	a5,4(a0)
    800036e0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800036e2:	04451783          	lh	a5,68(a0)
    800036e6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800036ea:	04a51783          	lh	a5,74(a0)
    800036ee:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800036f2:	04c56783          	lwu	a5,76(a0)
    800036f6:	e99c                	sd	a5,16(a1)
}
    800036f8:	60a2                	ld	ra,8(sp)
    800036fa:	6402                	ld	s0,0(sp)
    800036fc:	0141                	addi	sp,sp,16
    800036fe:	8082                	ret

0000000080003700 <readi>:

// Read data from inode.
// Caller must hold ip->lock.
// If user_dst==1, then dst is a user virtual address;
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80003700:	7175                	addi	sp,sp,-144
    80003702:	e506                	sd	ra,136(sp)
    80003704:	e122                	sd	s0,128(sp)
    80003706:	f4ce                	sd	s3,104(sp)
    80003708:	0900                	addi	s0,sp,144
    8000370a:	f6b43c23          	sd	a1,-136(s0)
    struct buf *bp;
    static char *cached_decomp_buf = 0;  // Static buffer to cache decompressed data
    static int cached_inum = 0;          // Cache the inode number
    static int cached_length = 0;        // Cache the original length

    if (off > ip->size || off + n < off)
    8000370e:	457c                	lw	a5,76(a0)
        return 0;
    80003710:	4981                	li	s3,0
    if (off > ip->size || off + n < off)
    80003712:	2cd7e563          	bltu	a5,a3,800039dc <readi+0x2dc>
    80003716:	fca6                	sd	s1,120(sp)
    80003718:	e8da                	sd	s6,80(sp)
    8000371a:	e4de                	sd	s7,72(sp)
    8000371c:	e0e2                	sd	s8,64(sp)
    8000371e:	8baa                	mv	s7,a0
    80003720:	8b32                	mv	s6,a2
    80003722:	84b6                	mv	s1,a3
    80003724:	8c3a                	mv	s8,a4
    80003726:	9f35                	addw	a4,a4,a3
        return 0;
    80003728:	4981                	li	s3,0
    if (off > ip->size || off + n < off)
    8000372a:	2ad76563          	bltu	a4,a3,800039d4 <readi+0x2d4>
    8000372e:	f8ca                	sd	s2,112(sp)
    if (off + n > ip->size)
    80003730:	00e7f463          	bgeu	a5,a4,80003738 <readi+0x38>
        n = ip->size - off;
    80003734:	40d78c3b          	subw	s8,a5,a3

    // Check for compression
    if (ip->type == T_FILE) {
    80003738:	044b9703          	lh	a4,68(s7)
    8000373c:	4789                	li	a5,2
    8000373e:	00f70e63          	beq	a4,a5,8000375a <readi+0x5a>
    80003742:	ecd6                	sd	s5,88(sp)
    80003744:	f86a                	sd	s10,48(sp)
    80003746:	f46e                	sd	s11,40(sp)
            return n;
        }
    }

    // Regular uncompressed read
    for(tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003748:	4a81                	li	s5,0
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
        m = min(n - tot, BSIZE - off % BSIZE);
    8000374a:	40000d93          	li	s11,1024
        if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000374e:	5d7d                	li	s10,-1
    for(tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003750:	1e0c0563          	beqz	s8,8000393a <readi+0x23a>
    80003754:	f0d2                	sd	s4,96(sp)
    80003756:	fc66                	sd	s9,56(sp)
    80003758:	ac29                	j	80003972 <readi+0x272>
        bp = bread(ip->dev, bmap(ip, 0));
    8000375a:	000ba903          	lw	s2,0(s7)
    8000375e:	4581                	li	a1,0
    80003760:	855e                	mv	a0,s7
    80003762:	9a7ff0ef          	jal	80003108 <bmap>
    80003766:	85aa                	mv	a1,a0
    80003768:	854a                	mv	a0,s2
    8000376a:	e2cff0ef          	jal	80002d96 <bread>
    8000376e:	892a                	mv	s2,a0
        memmove(&ch, bp->data, sizeof(ch));
    80003770:	4641                	li	a2,16
    80003772:	05850593          	addi	a1,a0,88
    80003776:	f8040513          	addi	a0,s0,-128
    8000377a:	db8fd0ef          	jal	80000d32 <memmove>
        brelse(bp);
    8000377e:	854a                	mv	a0,s2
    80003780:	f1eff0ef          	jal	80002e9e <brelse>
        if (ch.compressed == 1) {
    80003784:	f8442703          	lw	a4,-124(s0)
    80003788:	4785                	li	a5,1
    8000378a:	faf71ce3          	bne	a4,a5,80003742 <readi+0x42>
            printf("readi: found compressed file, original length %d\n", ch.length);
    8000378e:	f8842583          	lw	a1,-120(s0)
    80003792:	00005517          	auipc	a0,0x5
    80003796:	de650513          	addi	a0,a0,-538 # 80008578 <etext+0x578>
    8000379a:	d35fc0ef          	jal	800004ce <printf>
            if (cached_decomp_buf == 0 || cached_inum != ip->inum) {
    8000379e:	00005517          	auipc	a0,0x5
    800037a2:	34253503          	ld	a0,834(a0) # 80008ae0 <cached_decomp_buf.2>
    800037a6:	c921                	beqz	a0,800037f6 <readi+0xf6>
    800037a8:	004ba703          	lw	a4,4(s7)
    800037ac:	00005797          	auipc	a5,0x5
    800037b0:	3307a783          	lw	a5,816(a5) # 80008adc <cached_inum.1>
    800037b4:	10f70963          	beq	a4,a5,800038c6 <readi+0x1c6>
    800037b8:	fc66                	sd	s9,56(sp)
                    kfree(cached_decomp_buf);
    800037ba:	a8efd0ef          	jal	80000a48 <kfree>
                    cached_decomp_buf = 0;
    800037be:	00005797          	auipc	a5,0x5
    800037c2:	3207b123          	sd	zero,802(a5) # 80008ae0 <cached_decomp_buf.2>
                char *comp_buf = kalloc();
    800037c6:	b64fd0ef          	jal	80000b2a <kalloc>
    800037ca:	8caa                	mv	s9,a0
                cached_decomp_buf = kalloc();
    800037cc:	b5efd0ef          	jal	80000b2a <kalloc>
    800037d0:	00005797          	auipc	a5,0x5
    800037d4:	30a7b823          	sd	a0,784(a5) # 80008ae0 <cached_decomp_buf.2>
                if (!comp_buf || !cached_decomp_buf) {
    800037d8:	020c8463          	beqz	s9,80003800 <readi+0x100>
    800037dc:	cd19                	beqz	a0,800037fa <readi+0xfa>
    800037de:	f86a                	sd	s10,48(sp)
    800037e0:	f46e                	sd	s11,40(sp)
                int comp_size = ip->size - sizeof(ch);
    800037e2:	04cbad03          	lw	s10,76(s7)
    800037e6:	3d41                	addiw	s10,s10,-16
    800037e8:	8dea                	mv	s11,s10
                while (tot < comp_size) {
    800037ea:	080d0f63          	beqz	s10,80003888 <readi+0x188>
    800037ee:	f0d2                	sd	s4,96(sp)
    800037f0:	ecd6                	sd	s5,88(sp)
                tot = 0;
    800037f2:	4981                	li	s3,0
    800037f4:	a881                	j	80003844 <readi+0x144>
    800037f6:	fc66                	sd	s9,56(sp)
    800037f8:	b7f9                	j	800037c6 <readi+0xc6>
                    if (comp_buf) kfree(comp_buf);
    800037fa:	8566                	mv	a0,s9
    800037fc:	a4cfd0ef          	jal	80000a48 <kfree>
                    if (cached_decomp_buf) cached_decomp_buf = 0;
    80003800:	00005797          	auipc	a5,0x5
    80003804:	2e07b783          	ld	a5,736(a5) # 80008ae0 <cached_decomp_buf.2>
                    return -1;
    80003808:	59fd                	li	s3,-1
                    if (cached_decomp_buf) cached_decomp_buf = 0;
    8000380a:	1c078f63          	beqz	a5,800039e8 <readi+0x2e8>
    8000380e:	00005797          	auipc	a5,0x5
    80003812:	2c07b923          	sd	zero,722(a5) # 80008ae0 <cached_decomp_buf.2>
    80003816:	74e6                	ld	s1,120(sp)
    80003818:	7946                	ld	s2,112(sp)
    8000381a:	6b46                	ld	s6,80(sp)
    8000381c:	6ba6                	ld	s7,72(sp)
    8000381e:	6c06                	ld	s8,64(sp)
    80003820:	7ce2                	ld	s9,56(sp)
    80003822:	aa6d                	j	800039dc <readi+0x2dc>
                    m = min(comp_size - tot, BSIZE - ((tot + sizeof(ch)) % BSIZE));
    80003824:	2901                	sext.w	s2,s2
                    memmove(comp_buf + tot, bp->data + ((tot + sizeof(ch)) % BSIZE), m);
    80003826:	058a0793          	addi	a5,s4,88
    8000382a:	864a                	mv	a2,s2
    8000382c:	95be                	add	a1,a1,a5
    8000382e:	015c8533          	add	a0,s9,s5
    80003832:	d00fd0ef          	jal	80000d32 <memmove>
                    brelse(bp);
    80003836:	8552                	mv	a0,s4
    80003838:	e66ff0ef          	jal	80002e9e <brelse>
                    tot += m;
    8000383c:	013909bb          	addw	s3,s2,s3
                while (tot < comp_size) {
    80003840:	05b9f263          	bgeu	s3,s11,80003884 <readi+0x184>
                    bp = bread(ip->dev, bmap(ip, (tot + sizeof(ch)) / BSIZE));
    80003844:	000baa03          	lw	s4,0(s7)
    80003848:	02099a93          	slli	s5,s3,0x20
    8000384c:	020ada93          	srli	s5,s5,0x20
    80003850:	010a8913          	addi	s2,s5,16
    80003854:	00a95593          	srli	a1,s2,0xa
    80003858:	855e                	mv	a0,s7
    8000385a:	8afff0ef          	jal	80003108 <bmap>
    8000385e:	85aa                	mv	a1,a0
    80003860:	8552                	mv	a0,s4
    80003862:	d34ff0ef          	jal	80002d96 <bread>
    80003866:	8a2a                	mv	s4,a0
                    m = min(comp_size - tot, BSIZE - ((tot + sizeof(ch)) % BSIZE));
    80003868:	3ff97593          	andi	a1,s2,1023
    8000386c:	413d07bb          	subw	a5,s10,s3
    80003870:	1782                	slli	a5,a5,0x20
    80003872:	9381                	srli	a5,a5,0x20
    80003874:	40000713          	li	a4,1024
    80003878:	40b70933          	sub	s2,a4,a1
    8000387c:	fb27f4e3          	bgeu	a5,s2,80003824 <readi+0x124>
    80003880:	893e                	mv	s2,a5
    80003882:	b74d                	j	80003824 <readi+0x124>
    80003884:	7a06                	ld	s4,96(sp)
    80003886:	6ae6                	ld	s5,88(sp)
                int decomp_size = decompress_huffman(comp_buf, comp_size, cached_decomp_buf, ch.length);
    80003888:	f8842683          	lw	a3,-120(s0)
    8000388c:	00005617          	auipc	a2,0x5
    80003890:	25463603          	ld	a2,596(a2) # 80008ae0 <cached_decomp_buf.2>
    80003894:	85ea                	mv	a1,s10
    80003896:	8566                	mv	a0,s9
    80003898:	363020ef          	jal	800063fa <decompress_huffman>
    8000389c:	892a                	mv	s2,a0
                kfree(comp_buf);
    8000389e:	8566                	mv	a0,s9
    800038a0:	9a8fd0ef          	jal	80000a48 <kfree>
                if (decomp_size < 0) {
    800038a4:	06094863          	bltz	s2,80003914 <readi+0x214>
                cached_inum = ip->inum;
    800038a8:	004ba783          	lw	a5,4(s7)
    800038ac:	00005717          	auipc	a4,0x5
    800038b0:	22f72823          	sw	a5,560(a4) # 80008adc <cached_inum.1>
                cached_length = ch.length;
    800038b4:	f8842783          	lw	a5,-120(s0)
    800038b8:	00005717          	auipc	a4,0x5
    800038bc:	22f72023          	sw	a5,544(a4) # 80008ad8 <cached_length.0>
    800038c0:	7ce2                	ld	s9,56(sp)
    800038c2:	7d42                	ld	s10,48(sp)
    800038c4:	7da2                	ld	s11,40(sp)
            if (off >= cached_length) {
    800038c6:	00005797          	auipc	a5,0x5
    800038ca:	2127a783          	lw	a5,530(a5) # 80008ad8 <cached_length.0>
                return 0;
    800038ce:	4981                	li	s3,0
            if (off >= cached_length) {
    800038d0:	12f4f363          	bgeu	s1,a5,800039f6 <readi+0x2f6>
            if (off + n > cached_length) {
    800038d4:	009c073b          	addw	a4,s8,s1
    800038d8:	00e7f463          	bgeu	a5,a4,800038e0 <readi+0x1e0>
                n = cached_length - off;
    800038dc:	40978c3b          	subw	s8,a5,s1
            if (either_copyout(user_dst, dst, cached_decomp_buf + off, n) == -1) {
    800038e0:	1482                	slli	s1,s1,0x20
    800038e2:	9081                	srli	s1,s1,0x20
    800038e4:	020c1693          	slli	a3,s8,0x20
    800038e8:	9281                	srli	a3,a3,0x20
    800038ea:	00005617          	auipc	a2,0x5
    800038ee:	1f663603          	ld	a2,502(a2) # 80008ae0 <cached_decomp_buf.2>
    800038f2:	9626                	add	a2,a2,s1
    800038f4:	85da                	mv	a1,s6
    800038f6:	f7843503          	ld	a0,-136(s0)
    800038fa:	907fe0ef          	jal	80002200 <either_copyout>
    800038fe:	89aa                	mv	s3,a0
    80003900:	57fd                	li	a5,-1
    80003902:	10f50063          	beq	a0,a5,80003a02 <readi+0x302>
            return n;
    80003906:	89e2                	mv	s3,s8
    80003908:	74e6                	ld	s1,120(sp)
    8000390a:	7946                	ld	s2,112(sp)
    8000390c:	6b46                	ld	s6,80(sp)
    8000390e:	6ba6                	ld	s7,72(sp)
    80003910:	6c06                	ld	s8,64(sp)
    80003912:	a0e9                	j	800039dc <readi+0x2dc>
                    kfree(cached_decomp_buf);
    80003914:	00005497          	auipc	s1,0x5
    80003918:	1cc48493          	addi	s1,s1,460 # 80008ae0 <cached_decomp_buf.2>
    8000391c:	6088                	ld	a0,0(s1)
    8000391e:	92afd0ef          	jal	80000a48 <kfree>
                    cached_decomp_buf = 0;
    80003922:	0004b023          	sd	zero,0(s1)
                    return -1;
    80003926:	59fd                	li	s3,-1
    80003928:	74e6                	ld	s1,120(sp)
    8000392a:	7946                	ld	s2,112(sp)
    8000392c:	6b46                	ld	s6,80(sp)
    8000392e:	6ba6                	ld	s7,72(sp)
    80003930:	6c06                	ld	s8,64(sp)
    80003932:	7ce2                	ld	s9,56(sp)
    80003934:	7d42                	ld	s10,48(sp)
    80003936:	7da2                	ld	s11,40(sp)
    80003938:	a055                	j	800039dc <readi+0x2dc>
    for(tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000393a:	8ae2                	mv	s5,s8
    8000393c:	a051                	j	800039c0 <readi+0x2c0>
        if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000393e:	020a1c93          	slli	s9,s4,0x20
    80003942:	020cdc93          	srli	s9,s9,0x20
    80003946:	05890613          	addi	a2,s2,88
    8000394a:	86e6                	mv	a3,s9
    8000394c:	963e                	add	a2,a2,a5
    8000394e:	85da                	mv	a1,s6
    80003950:	f7843503          	ld	a0,-136(s0)
    80003954:	8adfe0ef          	jal	80002200 <either_copyout>
    80003958:	89aa                	mv	s3,a0
    8000395a:	05a50363          	beq	a0,s10,800039a0 <readi+0x2a0>
            brelse(bp);
            return -1;
        }
        brelse(bp);
    8000395e:	854a                	mv	a0,s2
    80003960:	d3eff0ef          	jal	80002e9e <brelse>
    for(tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003964:	015a0abb          	addw	s5,s4,s5
    80003968:	009a04bb          	addw	s1,s4,s1
    8000396c:	9b66                	add	s6,s6,s9
    8000396e:	058af763          	bgeu	s5,s8,800039bc <readi+0x2bc>
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80003972:	000ba903          	lw	s2,0(s7)
    80003976:	00a4d59b          	srliw	a1,s1,0xa
    8000397a:	855e                	mv	a0,s7
    8000397c:	f8cff0ef          	jal	80003108 <bmap>
    80003980:	85aa                	mv	a1,a0
    80003982:	854a                	mv	a0,s2
    80003984:	c12ff0ef          	jal	80002d96 <bread>
    80003988:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    8000398a:	3ff4f793          	andi	a5,s1,1023
    8000398e:	40fd873b          	subw	a4,s11,a5
    80003992:	415c06bb          	subw	a3,s8,s5
    80003996:	8a3a                	mv	s4,a4
    80003998:	fae6f3e3          	bgeu	a3,a4,8000393e <readi+0x23e>
    8000399c:	8a36                	mv	s4,a3
    8000399e:	b745                	j	8000393e <readi+0x23e>
            brelse(bp);
    800039a0:	854a                	mv	a0,s2
    800039a2:	cfcff0ef          	jal	80002e9e <brelse>
            return -1;
    800039a6:	74e6                	ld	s1,120(sp)
    800039a8:	7946                	ld	s2,112(sp)
    800039aa:	7a06                	ld	s4,96(sp)
    800039ac:	6ae6                	ld	s5,88(sp)
    800039ae:	6b46                	ld	s6,80(sp)
    800039b0:	6ba6                	ld	s7,72(sp)
    800039b2:	6c06                	ld	s8,64(sp)
    800039b4:	7ce2                	ld	s9,56(sp)
    800039b6:	7d42                	ld	s10,48(sp)
    800039b8:	7da2                	ld	s11,40(sp)
    800039ba:	a00d                	j	800039dc <readi+0x2dc>
    800039bc:	7a06                	ld	s4,96(sp)
    800039be:	7ce2                	ld	s9,56(sp)
    }
    
    return tot;
    800039c0:	89d6                	mv	s3,s5
    800039c2:	74e6                	ld	s1,120(sp)
    800039c4:	7946                	ld	s2,112(sp)
    800039c6:	6ae6                	ld	s5,88(sp)
    800039c8:	6b46                	ld	s6,80(sp)
    800039ca:	6ba6                	ld	s7,72(sp)
    800039cc:	6c06                	ld	s8,64(sp)
    800039ce:	7d42                	ld	s10,48(sp)
    800039d0:	7da2                	ld	s11,40(sp)
    800039d2:	a029                	j	800039dc <readi+0x2dc>
    800039d4:	74e6                	ld	s1,120(sp)
    800039d6:	6b46                	ld	s6,80(sp)
    800039d8:	6ba6                	ld	s7,72(sp)
    800039da:	6c06                	ld	s8,64(sp)
}
    800039dc:	854e                	mv	a0,s3
    800039de:	60aa                	ld	ra,136(sp)
    800039e0:	640a                	ld	s0,128(sp)
    800039e2:	79a6                	ld	s3,104(sp)
    800039e4:	6149                	addi	sp,sp,144
    800039e6:	8082                	ret
    800039e8:	74e6                	ld	s1,120(sp)
    800039ea:	7946                	ld	s2,112(sp)
    800039ec:	6b46                	ld	s6,80(sp)
    800039ee:	6ba6                	ld	s7,72(sp)
    800039f0:	6c06                	ld	s8,64(sp)
    800039f2:	7ce2                	ld	s9,56(sp)
    800039f4:	b7e5                	j	800039dc <readi+0x2dc>
    800039f6:	74e6                	ld	s1,120(sp)
    800039f8:	7946                	ld	s2,112(sp)
    800039fa:	6b46                	ld	s6,80(sp)
    800039fc:	6ba6                	ld	s7,72(sp)
    800039fe:	6c06                	ld	s8,64(sp)
    80003a00:	bff1                	j	800039dc <readi+0x2dc>
    80003a02:	74e6                	ld	s1,120(sp)
    80003a04:	7946                	ld	s2,112(sp)
    80003a06:	6b46                	ld	s6,80(sp)
    80003a08:	6ba6                	ld	s7,72(sp)
    80003a0a:	6c06                	ld	s8,64(sp)
    80003a0c:	bfc1                	j	800039dc <readi+0x2dc>

0000000080003a0e <writei>:
// If user_src==1, then src is a user virtual address;
// otherwise, src is a kernel address.
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80003a0e:	7119                	addi	sp,sp,-128
    80003a10:	fc86                	sd	ra,120(sp)
    80003a12:	f8a2                	sd	s0,112(sp)
    80003a14:	e8d2                	sd	s4,80(sp)
    80003a16:	0100                	addi	s0,sp,128
    uint tot, m;
    struct buf *bp;

    if(off > ip->size || off + n < off)
    80003a18:	457c                	lw	a5,76(a0)
    80003a1a:	22d7e763          	bltu	a5,a3,80003c48 <writei+0x23a>
    80003a1e:	f0ca                	sd	s2,96(sp)
    80003a20:	e4d6                	sd	s5,72(sp)
    80003a22:	fc5e                	sd	s7,56(sp)
    80003a24:	f862                	sd	s8,48(sp)
    80003a26:	f466                	sd	s9,40(sp)
    80003a28:	8baa                	mv	s7,a0
    80003a2a:	8cae                	mv	s9,a1
    80003a2c:	8ab2                	mv	s5,a2
    80003a2e:	8936                	mv	s2,a3
    80003a30:	8c3a                	mv	s8,a4
    80003a32:	00e687bb          	addw	a5,a3,a4
    80003a36:	20d7eb63          	bltu	a5,a3,80003c4c <writei+0x23e>
        return -1;
    if(off + n > MAXFILE * BSIZE)
    80003a3a:	00043737          	lui	a4,0x43
    80003a3e:	20f76e63          	bltu	a4,a5,80003c5a <writei+0x24c>
    80003a42:	f4a6                	sd	s1,104(sp)
        return -1;

    // Only try compression for regular files and writing from start
    if(ip->type == T_FILE && off == 0) {
    80003a44:	04451703          	lh	a4,68(a0)
    80003a48:	4789                	li	a5,2
    80003a4a:	00f70d63          	beq	a4,a5,80003a64 <writei+0x56>
        }
        kfree(temp_buf);
    }

    // Regular uncompressed write for non-regular files or non-start writes
    for(tot = 0; tot < n; tot += m, off += m, src += m) {
    80003a4e:	1e0c0b63          	beqz	s8,80003c44 <writei+0x236>
    80003a52:	ecce                	sd	s3,88(sp)
    80003a54:	e0da                	sd	s6,64(sp)
    80003a56:	f06a                	sd	s10,32(sp)
    80003a58:	ec6e                	sd	s11,24(sp)
    80003a5a:	4a01                	li	s4,0
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
        m = min(n - tot, BSIZE - off % BSIZE);
    80003a5c:	40000d93          	li	s11,1024
        if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003a60:	5d7d                	li	s10,-1
    80003a62:	aa8d                	j	80003bd4 <writei+0x1c6>
    if(ip->type == T_FILE && off == 0) {
    80003a64:	f6ed                	bnez	a3,80003a4e <writei+0x40>
        char *temp_buf = kalloc();
    80003a66:	8c4fd0ef          	jal	80000b2a <kalloc>
    80003a6a:	84aa                	mv	s1,a0
        if(!temp_buf)
    80003a6c:	1e050e63          	beqz	a0,80003c68 <writei+0x25a>
        if(either_copyin(temp_buf, user_src, src, n) == -1) {
    80003a70:	020c1693          	slli	a3,s8,0x20
    80003a74:	9281                	srli	a3,a3,0x20
    80003a76:	8656                	mv	a2,s5
    80003a78:	85e6                	mv	a1,s9
    80003a7a:	fd0fe0ef          	jal	8000224a <either_copyin>
    80003a7e:	8a2a                	mv	s4,a0
    80003a80:	57fd                	li	a5,-1
    80003a82:	06f50563          	beq	a0,a5,80003aec <writei+0xde>
        if(n > sizeof(struct compression_header)) {
    80003a86:	47c1                	li	a5,16
    80003a88:	0587fe63          	bgeu	a5,s8,80003ae4 <writei+0xd6>
    80003a8c:	ecce                	sd	s3,88(sp)
            char *comp_buf = kalloc();
    80003a8e:	89cfd0ef          	jal	80000b2a <kalloc>
    80003a92:	89aa                	mv	s3,a0
            if(comp_buf) {
    80003a94:	10050363          	beqz	a0,80003b9a <writei+0x18c>
    80003a98:	e0da                	sd	s6,64(sp)
                printf("Attempting compression of %d bytes...\n", n);
    80003a9a:	85e2                	mv	a1,s8
    80003a9c:	00005517          	auipc	a0,0x5
    80003aa0:	b1450513          	addi	a0,a0,-1260 # 800085b0 <etext+0x5b0>
    80003aa4:	a2bfc0ef          	jal	800004ce <printf>
                int comp_size = compress_huffman(temp_buf, n, comp_buf, PGSIZE);
    80003aa8:	8a62                	mv	s4,s8
    80003aaa:	6685                	lui	a3,0x1
    80003aac:	864e                	mv	a2,s3
    80003aae:	85e2                	mv	a1,s8
    80003ab0:	8526                	mv	a0,s1
    80003ab2:	752020ef          	jal	80006204 <compress_huffman>
    80003ab6:	8b2a                	mv	s6,a0
                printf("Compression result: %d bytes\n", comp_size);
    80003ab8:	85aa                	mv	a1,a0
    80003aba:	00005517          	auipc	a0,0x5
    80003abe:	b1e50513          	addi	a0,a0,-1250 # 800085d8 <etext+0x5d8>
    80003ac2:	a0dfc0ef          	jal	800004ce <printf>
                if(comp_size > 0 && comp_size < n) {
    80003ac6:	01605463          	blez	s6,80003ace <writei+0xc0>
    80003aca:	038b6b63          	bltu	s6,s8,80003b00 <writei+0xf2>
                    printf("Compression not beneficial, using original data\n");
    80003ace:	00005517          	auipc	a0,0x5
    80003ad2:	b5250513          	addi	a0,a0,-1198 # 80008620 <etext+0x620>
    80003ad6:	9f9fc0ef          	jal	800004ce <printf>
                kfree(comp_buf);
    80003ada:	854e                	mv	a0,s3
    80003adc:	f6dfc0ef          	jal	80000a48 <kfree>
    80003ae0:	69e6                	ld	s3,88(sp)
    80003ae2:	6b06                	ld	s6,64(sp)
        kfree(temp_buf);
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	f63fc0ef          	jal	80000a48 <kfree>
    80003aea:	b795                	j	80003a4e <writei+0x40>
            kfree(temp_buf);
    80003aec:	8526                	mv	a0,s1
    80003aee:	f5bfc0ef          	jal	80000a48 <kfree>
            return -1;
    80003af2:	74a6                	ld	s1,104(sp)
    80003af4:	7906                	ld	s2,96(sp)
    80003af6:	6aa6                	ld	s5,72(sp)
    80003af8:	7be2                	ld	s7,56(sp)
    80003afa:	7c42                	ld	s8,48(sp)
    80003afc:	7ca2                	ld	s9,40(sp)
    80003afe:	aa05                	j	80003c2e <writei+0x220>
    80003b00:	f06a                	sd	s10,32(sp)
                    printf("Using compressed data (saved %d bytes)\n", n - comp_size);
    80003b02:	416c05bb          	subw	a1,s8,s6
    80003b06:	00005517          	auipc	a0,0x5
    80003b0a:	af250513          	addi	a0,a0,-1294 # 800085f8 <etext+0x5f8>
    80003b0e:	9c1fc0ef          	jal	800004ce <printf>
                    ch.magic = COMPRESSION_MAGIC;
    80003b12:	436f77b7          	lui	a5,0x436f7
    80003b16:	d7078793          	addi	a5,a5,-656 # 436f6d70 <_entry-0x3c909290>
    80003b1a:	f8f42023          	sw	a5,-128(s0)
                    ch.compressed = 1;
    80003b1e:	4785                	li	a5,1
    80003b20:	f8f42223          	sw	a5,-124(s0)
                    ch.length = n;
    80003b24:	f9842423          	sw	s8,-120(s0)
                    ch.tree_size = comp_size;
    80003b28:	f9642623          	sw	s6,-116(s0)
                    bp = bread(ip->dev, bmap(ip, 0));
    80003b2c:	000bad03          	lw	s10,0(s7)
    80003b30:	4581                	li	a1,0
    80003b32:	855e                	mv	a0,s7
    80003b34:	dd4ff0ef          	jal	80003108 <bmap>
    80003b38:	85aa                	mv	a1,a0
    80003b3a:	856a                	mv	a0,s10
    80003b3c:	a5aff0ef          	jal	80002d96 <bread>
    80003b40:	8d2a                	mv	s10,a0
                    if(bp) {
    80003b42:	e119                	bnez	a0,80003b48 <writei+0x13a>
    80003b44:	7d02                	ld	s10,32(sp)
    80003b46:	bf51                	j	80003ada <writei+0xcc>
                        memmove(bp->data, &ch, sizeof(ch));
    80003b48:	4641                	li	a2,16
    80003b4a:	f8040593          	addi	a1,s0,-128
    80003b4e:	05850513          	addi	a0,a0,88
    80003b52:	9e0fd0ef          	jal	80000d32 <memmove>
                        memmove(bp->data + sizeof(ch), comp_buf, comp_size);
    80003b56:	865a                	mv	a2,s6
    80003b58:	85ce                	mv	a1,s3
    80003b5a:	068d0513          	addi	a0,s10,104
    80003b5e:	9d4fd0ef          	jal	80000d32 <memmove>
                        log_write(bp);
    80003b62:	856a                	mv	a0,s10
    80003b64:	702000ef          	jal	80004266 <log_write>
                        brelse(bp);
    80003b68:	856a                	mv	a0,s10
    80003b6a:	b34ff0ef          	jal	80002e9e <brelse>
                        ip->size = comp_size + sizeof(ch);
    80003b6e:	2b41                	addiw	s6,s6,16
    80003b70:	056ba623          	sw	s6,76(s7)
                        iupdate(ip);
    80003b74:	855e                	mv	a0,s7
    80003b76:	87fff0ef          	jal	800033f4 <iupdate>
                        kfree(temp_buf);
    80003b7a:	8526                	mv	a0,s1
    80003b7c:	ecdfc0ef          	jal	80000a48 <kfree>
                        kfree(comp_buf);
    80003b80:	854e                	mv	a0,s3
    80003b82:	ec7fc0ef          	jal	80000a48 <kfree>
                        return n;  // Return original size
    80003b86:	74a6                	ld	s1,104(sp)
    80003b88:	7906                	ld	s2,96(sp)
    80003b8a:	69e6                	ld	s3,88(sp)
    80003b8c:	6aa6                	ld	s5,72(sp)
    80003b8e:	6b06                	ld	s6,64(sp)
    80003b90:	7be2                	ld	s7,56(sp)
    80003b92:	7c42                	ld	s8,48(sp)
    80003b94:	7ca2                	ld	s9,40(sp)
    80003b96:	7d02                	ld	s10,32(sp)
    80003b98:	a859                	j	80003c2e <writei+0x220>
    80003b9a:	69e6                	ld	s3,88(sp)
    80003b9c:	b7a1                	j	80003ae4 <writei+0xd6>
        if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b9e:	02099b13          	slli	s6,s3,0x20
    80003ba2:	020b5b13          	srli	s6,s6,0x20
    80003ba6:	05848513          	addi	a0,s1,88
    80003baa:	86da                	mv	a3,s6
    80003bac:	8656                	mv	a2,s5
    80003bae:	85e6                	mv	a1,s9
    80003bb0:	953e                	add	a0,a0,a5
    80003bb2:	e98fe0ef          	jal	8000224a <either_copyin>
    80003bb6:	05a50663          	beq	a0,s10,80003c02 <writei+0x1f4>
            brelse(bp);
            break;
        }
        log_write(bp);
    80003bba:	8526                	mv	a0,s1
    80003bbc:	6aa000ef          	jal	80004266 <log_write>
        brelse(bp);
    80003bc0:	8526                	mv	a0,s1
    80003bc2:	adcff0ef          	jal	80002e9e <brelse>
    for(tot = 0; tot < n; tot += m, off += m, src += m) {
    80003bc6:	01498a3b          	addw	s4,s3,s4
    80003bca:	0129893b          	addw	s2,s3,s2
    80003bce:	9ada                	add	s5,s5,s6
    80003bd0:	078a7563          	bgeu	s4,s8,80003c3a <writei+0x22c>
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80003bd4:	000ba483          	lw	s1,0(s7)
    80003bd8:	00a9559b          	srliw	a1,s2,0xa
    80003bdc:	855e                	mv	a0,s7
    80003bde:	d2aff0ef          	jal	80003108 <bmap>
    80003be2:	85aa                	mv	a1,a0
    80003be4:	8526                	mv	a0,s1
    80003be6:	9b0ff0ef          	jal	80002d96 <bread>
    80003bea:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003bec:	3ff97793          	andi	a5,s2,1023
    80003bf0:	40fd873b          	subw	a4,s11,a5
    80003bf4:	414c06bb          	subw	a3,s8,s4
    80003bf8:	89ba                	mv	s3,a4
    80003bfa:	fae6f2e3          	bgeu	a3,a4,80003b9e <writei+0x190>
    80003bfe:	89b6                	mv	s3,a3
    80003c00:	bf79                	j	80003b9e <writei+0x190>
            brelse(bp);
    80003c02:	8526                	mv	a0,s1
    80003c04:	a9aff0ef          	jal	80002e9e <brelse>
            break;
    80003c08:	69e6                	ld	s3,88(sp)
    80003c0a:	6b06                	ld	s6,64(sp)
    80003c0c:	7d02                	ld	s10,32(sp)
    80003c0e:	6de2                	ld	s11,24(sp)
    }

    if(off > ip->size)
    80003c10:	04cba783          	lw	a5,76(s7)
    80003c14:	0127f463          	bgeu	a5,s2,80003c1c <writei+0x20e>
        ip->size = off;
    80003c18:	052ba623          	sw	s2,76(s7)

    iupdate(ip);
    80003c1c:	855e                	mv	a0,s7
    80003c1e:	fd6ff0ef          	jal	800033f4 <iupdate>
    return tot;
    80003c22:	74a6                	ld	s1,104(sp)
    80003c24:	7906                	ld	s2,96(sp)
    80003c26:	6aa6                	ld	s5,72(sp)
    80003c28:	7be2                	ld	s7,56(sp)
    80003c2a:	7c42                	ld	s8,48(sp)
    80003c2c:	7ca2                	ld	s9,40(sp)
}
    80003c2e:	8552                	mv	a0,s4
    80003c30:	70e6                	ld	ra,120(sp)
    80003c32:	7446                	ld	s0,112(sp)
    80003c34:	6a46                	ld	s4,80(sp)
    80003c36:	6109                	addi	sp,sp,128
    80003c38:	8082                	ret
    80003c3a:	69e6                	ld	s3,88(sp)
    80003c3c:	6b06                	ld	s6,64(sp)
    80003c3e:	7d02                	ld	s10,32(sp)
    80003c40:	6de2                	ld	s11,24(sp)
    80003c42:	b7f9                	j	80003c10 <writei+0x202>
    for(tot = 0; tot < n; tot += m, off += m, src += m) {
    80003c44:	8a62                	mv	s4,s8
    80003c46:	b7e9                	j	80003c10 <writei+0x202>
        return -1;
    80003c48:	5a7d                	li	s4,-1
    80003c4a:	b7d5                	j	80003c2e <writei+0x220>
    80003c4c:	5a7d                	li	s4,-1
    80003c4e:	7906                	ld	s2,96(sp)
    80003c50:	6aa6                	ld	s5,72(sp)
    80003c52:	7be2                	ld	s7,56(sp)
    80003c54:	7c42                	ld	s8,48(sp)
    80003c56:	7ca2                	ld	s9,40(sp)
    80003c58:	bfd9                	j	80003c2e <writei+0x220>
        return -1;
    80003c5a:	5a7d                	li	s4,-1
    80003c5c:	7906                	ld	s2,96(sp)
    80003c5e:	6aa6                	ld	s5,72(sp)
    80003c60:	7be2                	ld	s7,56(sp)
    80003c62:	7c42                	ld	s8,48(sp)
    80003c64:	7ca2                	ld	s9,40(sp)
    80003c66:	b7e1                	j	80003c2e <writei+0x220>
            return -1;
    80003c68:	5a7d                	li	s4,-1
    80003c6a:	74a6                	ld	s1,104(sp)
    80003c6c:	7906                	ld	s2,96(sp)
    80003c6e:	6aa6                	ld	s5,72(sp)
    80003c70:	7be2                	ld	s7,56(sp)
    80003c72:	7c42                	ld	s8,48(sp)
    80003c74:	7ca2                	ld	s9,40(sp)
    80003c76:	bf65                	j	80003c2e <writei+0x220>

0000000080003c78 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c78:	1141                	addi	sp,sp,-16
    80003c7a:	e406                	sd	ra,8(sp)
    80003c7c:	e022                	sd	s0,0(sp)
    80003c7e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c80:	4639                	li	a2,14
    80003c82:	924fd0ef          	jal	80000da6 <strncmp>
}
    80003c86:	60a2                	ld	ra,8(sp)
    80003c88:	6402                	ld	s0,0(sp)
    80003c8a:	0141                	addi	sp,sp,16
    80003c8c:	8082                	ret

0000000080003c8e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c8e:	711d                	addi	sp,sp,-96
    80003c90:	ec86                	sd	ra,88(sp)
    80003c92:	e8a2                	sd	s0,80(sp)
    80003c94:	e4a6                	sd	s1,72(sp)
    80003c96:	e0ca                	sd	s2,64(sp)
    80003c98:	fc4e                	sd	s3,56(sp)
    80003c9a:	f852                	sd	s4,48(sp)
    80003c9c:	f456                	sd	s5,40(sp)
    80003c9e:	f05a                	sd	s6,32(sp)
    80003ca0:	ec5e                	sd	s7,24(sp)
    80003ca2:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ca4:	04451703          	lh	a4,68(a0)
    80003ca8:	4785                	li	a5,1
    80003caa:	00f71f63          	bne	a4,a5,80003cc8 <dirlookup+0x3a>
    80003cae:	892a                	mv	s2,a0
    80003cb0:	8aae                	mv	s5,a1
    80003cb2:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cb4:	457c                	lw	a5,76(a0)
    80003cb6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cb8:	fa040a13          	addi	s4,s0,-96
    80003cbc:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003cbe:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cc2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cc4:	e39d                	bnez	a5,80003cea <dirlookup+0x5c>
    80003cc6:	a8b9                	j	80003d24 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003cc8:	00005517          	auipc	a0,0x5
    80003ccc:	99050513          	addi	a0,a0,-1648 # 80008658 <etext+0x658>
    80003cd0:	acffc0ef          	jal	8000079e <panic>
      panic("dirlookup read");
    80003cd4:	00005517          	auipc	a0,0x5
    80003cd8:	99c50513          	addi	a0,a0,-1636 # 80008670 <etext+0x670>
    80003cdc:	ac3fc0ef          	jal	8000079e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ce0:	24c1                	addiw	s1,s1,16
    80003ce2:	04c92783          	lw	a5,76(s2)
    80003ce6:	02f4fe63          	bgeu	s1,a5,80003d22 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cea:	874e                	mv	a4,s3
    80003cec:	86a6                	mv	a3,s1
    80003cee:	8652                	mv	a2,s4
    80003cf0:	4581                	li	a1,0
    80003cf2:	854a                	mv	a0,s2
    80003cf4:	a0dff0ef          	jal	80003700 <readi>
    80003cf8:	fd351ee3          	bne	a0,s3,80003cd4 <dirlookup+0x46>
    if(de.inum == 0)
    80003cfc:	fa045783          	lhu	a5,-96(s0)
    80003d00:	d3e5                	beqz	a5,80003ce0 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003d02:	85da                	mv	a1,s6
    80003d04:	8556                	mv	a0,s5
    80003d06:	f73ff0ef          	jal	80003c78 <namecmp>
    80003d0a:	f979                	bnez	a0,80003ce0 <dirlookup+0x52>
      if(poff)
    80003d0c:	000b8463          	beqz	s7,80003d14 <dirlookup+0x86>
        *poff = off;
    80003d10:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003d14:	fa045583          	lhu	a1,-96(s0)
    80003d18:	00092503          	lw	a0,0(s2)
    80003d1c:	cacff0ef          	jal	800031c8 <iget>
    80003d20:	a011                	j	80003d24 <dirlookup+0x96>
  return 0;
    80003d22:	4501                	li	a0,0
}
    80003d24:	60e6                	ld	ra,88(sp)
    80003d26:	6446                	ld	s0,80(sp)
    80003d28:	64a6                	ld	s1,72(sp)
    80003d2a:	6906                	ld	s2,64(sp)
    80003d2c:	79e2                	ld	s3,56(sp)
    80003d2e:	7a42                	ld	s4,48(sp)
    80003d30:	7aa2                	ld	s5,40(sp)
    80003d32:	7b02                	ld	s6,32(sp)
    80003d34:	6be2                	ld	s7,24(sp)
    80003d36:	6125                	addi	sp,sp,96
    80003d38:	8082                	ret

0000000080003d3a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d3a:	711d                	addi	sp,sp,-96
    80003d3c:	ec86                	sd	ra,88(sp)
    80003d3e:	e8a2                	sd	s0,80(sp)
    80003d40:	e4a6                	sd	s1,72(sp)
    80003d42:	e0ca                	sd	s2,64(sp)
    80003d44:	fc4e                	sd	s3,56(sp)
    80003d46:	f852                	sd	s4,48(sp)
    80003d48:	f456                	sd	s5,40(sp)
    80003d4a:	f05a                	sd	s6,32(sp)
    80003d4c:	ec5e                	sd	s7,24(sp)
    80003d4e:	e862                	sd	s8,16(sp)
    80003d50:	e466                	sd	s9,8(sp)
    80003d52:	e06a                	sd	s10,0(sp)
    80003d54:	1080                	addi	s0,sp,96
    80003d56:	84aa                	mv	s1,a0
    80003d58:	8b2e                	mv	s6,a1
    80003d5a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d5c:	00054703          	lbu	a4,0(a0)
    80003d60:	02f00793          	li	a5,47
    80003d64:	00f70f63          	beq	a4,a5,80003d82 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d68:	b75fd0ef          	jal	800018dc <myproc>
    80003d6c:	15053503          	ld	a0,336(a0)
    80003d70:	f02ff0ef          	jal	80003472 <idup>
    80003d74:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d76:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d7a:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003d7c:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d7e:	4b85                	li	s7,1
    80003d80:	a879                	j	80003e1e <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003d82:	4585                	li	a1,1
    80003d84:	852e                	mv	a0,a1
    80003d86:	c42ff0ef          	jal	800031c8 <iget>
    80003d8a:	8a2a                	mv	s4,a0
    80003d8c:	b7ed                	j	80003d76 <namex+0x3c>
      iunlockput(ip);
    80003d8e:	8552                	mv	a0,s4
    80003d90:	923ff0ef          	jal	800036b2 <iunlockput>
      return 0;
    80003d94:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d96:	8552                	mv	a0,s4
    80003d98:	60e6                	ld	ra,88(sp)
    80003d9a:	6446                	ld	s0,80(sp)
    80003d9c:	64a6                	ld	s1,72(sp)
    80003d9e:	6906                	ld	s2,64(sp)
    80003da0:	79e2                	ld	s3,56(sp)
    80003da2:	7a42                	ld	s4,48(sp)
    80003da4:	7aa2                	ld	s5,40(sp)
    80003da6:	7b02                	ld	s6,32(sp)
    80003da8:	6be2                	ld	s7,24(sp)
    80003daa:	6c42                	ld	s8,16(sp)
    80003dac:	6ca2                	ld	s9,8(sp)
    80003dae:	6d02                	ld	s10,0(sp)
    80003db0:	6125                	addi	sp,sp,96
    80003db2:	8082                	ret
      iunlock(ip);
    80003db4:	8552                	mv	a0,s4
    80003db6:	fa0ff0ef          	jal	80003556 <iunlock>
      return ip;
    80003dba:	bff1                	j	80003d96 <namex+0x5c>
      iunlockput(ip);
    80003dbc:	8552                	mv	a0,s4
    80003dbe:	8f5ff0ef          	jal	800036b2 <iunlockput>
      return 0;
    80003dc2:	8a4e                	mv	s4,s3
    80003dc4:	bfc9                	j	80003d96 <namex+0x5c>
  len = path - s;
    80003dc6:	40998633          	sub	a2,s3,s1
    80003dca:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003dce:	09ac5063          	bge	s8,s10,80003e4e <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003dd2:	8666                	mv	a2,s9
    80003dd4:	85a6                	mv	a1,s1
    80003dd6:	8556                	mv	a0,s5
    80003dd8:	f5bfc0ef          	jal	80000d32 <memmove>
    80003ddc:	84ce                	mv	s1,s3
  while(*path == '/')
    80003dde:	0004c783          	lbu	a5,0(s1)
    80003de2:	01279763          	bne	a5,s2,80003df0 <namex+0xb6>
    path++;
    80003de6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003de8:	0004c783          	lbu	a5,0(s1)
    80003dec:	ff278de3          	beq	a5,s2,80003de6 <namex+0xac>
    ilock(ip);
    80003df0:	8552                	mv	a0,s4
    80003df2:	eb6ff0ef          	jal	800034a8 <ilock>
    if(ip->type != T_DIR){
    80003df6:	044a1783          	lh	a5,68(s4)
    80003dfa:	f9779ae3          	bne	a5,s7,80003d8e <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003dfe:	000b0563          	beqz	s6,80003e08 <namex+0xce>
    80003e02:	0004c783          	lbu	a5,0(s1)
    80003e06:	d7dd                	beqz	a5,80003db4 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e08:	4601                	li	a2,0
    80003e0a:	85d6                	mv	a1,s5
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	e81ff0ef          	jal	80003c8e <dirlookup>
    80003e12:	89aa                	mv	s3,a0
    80003e14:	d545                	beqz	a0,80003dbc <namex+0x82>
    iunlockput(ip);
    80003e16:	8552                	mv	a0,s4
    80003e18:	89bff0ef          	jal	800036b2 <iunlockput>
    ip = next;
    80003e1c:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e1e:	0004c783          	lbu	a5,0(s1)
    80003e22:	01279763          	bne	a5,s2,80003e30 <namex+0xf6>
    path++;
    80003e26:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e28:	0004c783          	lbu	a5,0(s1)
    80003e2c:	ff278de3          	beq	a5,s2,80003e26 <namex+0xec>
  if(*path == 0)
    80003e30:	cb8d                	beqz	a5,80003e62 <namex+0x128>
  while(*path != '/' && *path != 0)
    80003e32:	0004c783          	lbu	a5,0(s1)
    80003e36:	89a6                	mv	s3,s1
  len = path - s;
    80003e38:	4d01                	li	s10,0
    80003e3a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e3c:	01278963          	beq	a5,s2,80003e4e <namex+0x114>
    80003e40:	d3d9                	beqz	a5,80003dc6 <namex+0x8c>
    path++;
    80003e42:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e44:	0009c783          	lbu	a5,0(s3)
    80003e48:	ff279ce3          	bne	a5,s2,80003e40 <namex+0x106>
    80003e4c:	bfad                	j	80003dc6 <namex+0x8c>
    memmove(name, s, len);
    80003e4e:	2601                	sext.w	a2,a2
    80003e50:	85a6                	mv	a1,s1
    80003e52:	8556                	mv	a0,s5
    80003e54:	edffc0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003e58:	9d56                	add	s10,s10,s5
    80003e5a:	000d0023          	sb	zero,0(s10)
    80003e5e:	84ce                	mv	s1,s3
    80003e60:	bfbd                	j	80003dde <namex+0xa4>
  if(nameiparent){
    80003e62:	f20b0ae3          	beqz	s6,80003d96 <namex+0x5c>
    iput(ip);
    80003e66:	8552                	mv	a0,s4
    80003e68:	fc2ff0ef          	jal	8000362a <iput>
    return 0;
    80003e6c:	4a01                	li	s4,0
    80003e6e:	b725                	j	80003d96 <namex+0x5c>

0000000080003e70 <dirlink>:
{
    80003e70:	715d                	addi	sp,sp,-80
    80003e72:	e486                	sd	ra,72(sp)
    80003e74:	e0a2                	sd	s0,64(sp)
    80003e76:	f84a                	sd	s2,48(sp)
    80003e78:	ec56                	sd	s5,24(sp)
    80003e7a:	e85a                	sd	s6,16(sp)
    80003e7c:	0880                	addi	s0,sp,80
    80003e7e:	892a                	mv	s2,a0
    80003e80:	8aae                	mv	s5,a1
    80003e82:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e84:	4601                	li	a2,0
    80003e86:	e09ff0ef          	jal	80003c8e <dirlookup>
    80003e8a:	ed1d                	bnez	a0,80003ec8 <dirlink+0x58>
    80003e8c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e8e:	04c92483          	lw	s1,76(s2)
    80003e92:	c4b9                	beqz	s1,80003ee0 <dirlink+0x70>
    80003e94:	f44e                	sd	s3,40(sp)
    80003e96:	f052                	sd	s4,32(sp)
    80003e98:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e9a:	fb040a13          	addi	s4,s0,-80
    80003e9e:	49c1                	li	s3,16
    80003ea0:	874e                	mv	a4,s3
    80003ea2:	86a6                	mv	a3,s1
    80003ea4:	8652                	mv	a2,s4
    80003ea6:	4581                	li	a1,0
    80003ea8:	854a                	mv	a0,s2
    80003eaa:	857ff0ef          	jal	80003700 <readi>
    80003eae:	03351163          	bne	a0,s3,80003ed0 <dirlink+0x60>
    if(de.inum == 0)
    80003eb2:	fb045783          	lhu	a5,-80(s0)
    80003eb6:	c39d                	beqz	a5,80003edc <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003eb8:	24c1                	addiw	s1,s1,16
    80003eba:	04c92783          	lw	a5,76(s2)
    80003ebe:	fef4e1e3          	bltu	s1,a5,80003ea0 <dirlink+0x30>
    80003ec2:	79a2                	ld	s3,40(sp)
    80003ec4:	7a02                	ld	s4,32(sp)
    80003ec6:	a829                	j	80003ee0 <dirlink+0x70>
    iput(ip);
    80003ec8:	f62ff0ef          	jal	8000362a <iput>
    return -1;
    80003ecc:	557d                	li	a0,-1
    80003ece:	a83d                	j	80003f0c <dirlink+0x9c>
      panic("dirlink read");
    80003ed0:	00004517          	auipc	a0,0x4
    80003ed4:	7b050513          	addi	a0,a0,1968 # 80008680 <etext+0x680>
    80003ed8:	8c7fc0ef          	jal	8000079e <panic>
    80003edc:	79a2                	ld	s3,40(sp)
    80003ede:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003ee0:	4639                	li	a2,14
    80003ee2:	85d6                	mv	a1,s5
    80003ee4:	fb240513          	addi	a0,s0,-78
    80003ee8:	ef9fc0ef          	jal	80000de0 <strncpy>
  de.inum = inum;
    80003eec:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ef0:	4741                	li	a4,16
    80003ef2:	86a6                	mv	a3,s1
    80003ef4:	fb040613          	addi	a2,s0,-80
    80003ef8:	4581                	li	a1,0
    80003efa:	854a                	mv	a0,s2
    80003efc:	b13ff0ef          	jal	80003a0e <writei>
    80003f00:	1541                	addi	a0,a0,-16
    80003f02:	00a03533          	snez	a0,a0
    80003f06:	40a0053b          	negw	a0,a0
    80003f0a:	74e2                	ld	s1,56(sp)
}
    80003f0c:	60a6                	ld	ra,72(sp)
    80003f0e:	6406                	ld	s0,64(sp)
    80003f10:	7942                	ld	s2,48(sp)
    80003f12:	6ae2                	ld	s5,24(sp)
    80003f14:	6b42                	ld	s6,16(sp)
    80003f16:	6161                	addi	sp,sp,80
    80003f18:	8082                	ret

0000000080003f1a <namei>:

struct inode*
namei(char *path)
{
    80003f1a:	1101                	addi	sp,sp,-32
    80003f1c:	ec06                	sd	ra,24(sp)
    80003f1e:	e822                	sd	s0,16(sp)
    80003f20:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f22:	fe040613          	addi	a2,s0,-32
    80003f26:	4581                	li	a1,0
    80003f28:	e13ff0ef          	jal	80003d3a <namex>
}
    80003f2c:	60e2                	ld	ra,24(sp)
    80003f2e:	6442                	ld	s0,16(sp)
    80003f30:	6105                	addi	sp,sp,32
    80003f32:	8082                	ret

0000000080003f34 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f34:	1141                	addi	sp,sp,-16
    80003f36:	e406                	sd	ra,8(sp)
    80003f38:	e022                	sd	s0,0(sp)
    80003f3a:	0800                	addi	s0,sp,16
    80003f3c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f3e:	4585                	li	a1,1
    80003f40:	dfbff0ef          	jal	80003d3a <namex>
}
    80003f44:	60a2                	ld	ra,8(sp)
    80003f46:	6402                	ld	s0,0(sp)
    80003f48:	0141                	addi	sp,sp,16
    80003f4a:	8082                	ret

0000000080003f4c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f4c:	1101                	addi	sp,sp,-32
    80003f4e:	ec06                	sd	ra,24(sp)
    80003f50:	e822                	sd	s0,16(sp)
    80003f52:	e426                	sd	s1,8(sp)
    80003f54:	e04a                	sd	s2,0(sp)
    80003f56:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f58:	0001d917          	auipc	s2,0x1d
    80003f5c:	c8890913          	addi	s2,s2,-888 # 80020be0 <log>
    80003f60:	01892583          	lw	a1,24(s2)
    80003f64:	02892503          	lw	a0,40(s2)
    80003f68:	e2ffe0ef          	jal	80002d96 <bread>
    80003f6c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f6e:	02c92603          	lw	a2,44(s2)
    80003f72:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f74:	00c05f63          	blez	a2,80003f92 <write_head+0x46>
    80003f78:	0001d717          	auipc	a4,0x1d
    80003f7c:	c9870713          	addi	a4,a4,-872 # 80020c10 <log+0x30>
    80003f80:	87aa                	mv	a5,a0
    80003f82:	060a                	slli	a2,a2,0x2
    80003f84:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f86:	4314                	lw	a3,0(a4)
    80003f88:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f8a:	0711                	addi	a4,a4,4
    80003f8c:	0791                	addi	a5,a5,4
    80003f8e:	fec79ce3          	bne	a5,a2,80003f86 <write_head+0x3a>
  }
  bwrite(buf);
    80003f92:	8526                	mv	a0,s1
    80003f94:	ed9fe0ef          	jal	80002e6c <bwrite>
  brelse(buf);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	f05fe0ef          	jal	80002e9e <brelse>
}
    80003f9e:	60e2                	ld	ra,24(sp)
    80003fa0:	6442                	ld	s0,16(sp)
    80003fa2:	64a2                	ld	s1,8(sp)
    80003fa4:	6902                	ld	s2,0(sp)
    80003fa6:	6105                	addi	sp,sp,32
    80003fa8:	8082                	ret

0000000080003faa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003faa:	0001d797          	auipc	a5,0x1d
    80003fae:	c627a783          	lw	a5,-926(a5) # 80020c0c <log+0x2c>
    80003fb2:	0af05263          	blez	a5,80004056 <install_trans+0xac>
{
    80003fb6:	715d                	addi	sp,sp,-80
    80003fb8:	e486                	sd	ra,72(sp)
    80003fba:	e0a2                	sd	s0,64(sp)
    80003fbc:	fc26                	sd	s1,56(sp)
    80003fbe:	f84a                	sd	s2,48(sp)
    80003fc0:	f44e                	sd	s3,40(sp)
    80003fc2:	f052                	sd	s4,32(sp)
    80003fc4:	ec56                	sd	s5,24(sp)
    80003fc6:	e85a                	sd	s6,16(sp)
    80003fc8:	e45e                	sd	s7,8(sp)
    80003fca:	0880                	addi	s0,sp,80
    80003fcc:	8b2a                	mv	s6,a0
    80003fce:	0001da97          	auipc	s5,0x1d
    80003fd2:	c42a8a93          	addi	s5,s5,-958 # 80020c10 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fd6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fd8:	0001d997          	auipc	s3,0x1d
    80003fdc:	c0898993          	addi	s3,s3,-1016 # 80020be0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fe0:	40000b93          	li	s7,1024
    80003fe4:	a829                	j	80003ffe <install_trans+0x54>
    brelse(lbuf);
    80003fe6:	854a                	mv	a0,s2
    80003fe8:	eb7fe0ef          	jal	80002e9e <brelse>
    brelse(dbuf);
    80003fec:	8526                	mv	a0,s1
    80003fee:	eb1fe0ef          	jal	80002e9e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ff2:	2a05                	addiw	s4,s4,1
    80003ff4:	0a91                	addi	s5,s5,4
    80003ff6:	02c9a783          	lw	a5,44(s3)
    80003ffa:	04fa5363          	bge	s4,a5,80004040 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003ffe:	0189a583          	lw	a1,24(s3)
    80004002:	014585bb          	addw	a1,a1,s4
    80004006:	2585                	addiw	a1,a1,1
    80004008:	0289a503          	lw	a0,40(s3)
    8000400c:	d8bfe0ef          	jal	80002d96 <bread>
    80004010:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004012:	000aa583          	lw	a1,0(s5)
    80004016:	0289a503          	lw	a0,40(s3)
    8000401a:	d7dfe0ef          	jal	80002d96 <bread>
    8000401e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004020:	865e                	mv	a2,s7
    80004022:	05890593          	addi	a1,s2,88
    80004026:	05850513          	addi	a0,a0,88
    8000402a:	d09fc0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000402e:	8526                	mv	a0,s1
    80004030:	e3dfe0ef          	jal	80002e6c <bwrite>
    if(recovering == 0)
    80004034:	fa0b19e3          	bnez	s6,80003fe6 <install_trans+0x3c>
      bunpin(dbuf);
    80004038:	8526                	mv	a0,s1
    8000403a:	f1dfe0ef          	jal	80002f56 <bunpin>
    8000403e:	b765                	j	80003fe6 <install_trans+0x3c>
}
    80004040:	60a6                	ld	ra,72(sp)
    80004042:	6406                	ld	s0,64(sp)
    80004044:	74e2                	ld	s1,56(sp)
    80004046:	7942                	ld	s2,48(sp)
    80004048:	79a2                	ld	s3,40(sp)
    8000404a:	7a02                	ld	s4,32(sp)
    8000404c:	6ae2                	ld	s5,24(sp)
    8000404e:	6b42                	ld	s6,16(sp)
    80004050:	6ba2                	ld	s7,8(sp)
    80004052:	6161                	addi	sp,sp,80
    80004054:	8082                	ret
    80004056:	8082                	ret

0000000080004058 <initlog>:
{
    80004058:	7179                	addi	sp,sp,-48
    8000405a:	f406                	sd	ra,40(sp)
    8000405c:	f022                	sd	s0,32(sp)
    8000405e:	ec26                	sd	s1,24(sp)
    80004060:	e84a                	sd	s2,16(sp)
    80004062:	e44e                	sd	s3,8(sp)
    80004064:	1800                	addi	s0,sp,48
    80004066:	892a                	mv	s2,a0
    80004068:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000406a:	0001d497          	auipc	s1,0x1d
    8000406e:	b7648493          	addi	s1,s1,-1162 # 80020be0 <log>
    80004072:	00004597          	auipc	a1,0x4
    80004076:	61e58593          	addi	a1,a1,1566 # 80008690 <etext+0x690>
    8000407a:	8526                	mv	a0,s1
    8000407c:	afffc0ef          	jal	80000b7a <initlock>
  log.start = sb->logstart;
    80004080:	0149a583          	lw	a1,20(s3)
    80004084:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004086:	0109a783          	lw	a5,16(s3)
    8000408a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000408c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004090:	854a                	mv	a0,s2
    80004092:	d05fe0ef          	jal	80002d96 <bread>
  log.lh.n = lh->n;
    80004096:	4d30                	lw	a2,88(a0)
    80004098:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000409a:	00c05f63          	blez	a2,800040b8 <initlog+0x60>
    8000409e:	87aa                	mv	a5,a0
    800040a0:	0001d717          	auipc	a4,0x1d
    800040a4:	b7070713          	addi	a4,a4,-1168 # 80020c10 <log+0x30>
    800040a8:	060a                	slli	a2,a2,0x2
    800040aa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800040ac:	4ff4                	lw	a3,92(a5)
    800040ae:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040b0:	0791                	addi	a5,a5,4
    800040b2:	0711                	addi	a4,a4,4
    800040b4:	fec79ce3          	bne	a5,a2,800040ac <initlog+0x54>
  brelse(buf);
    800040b8:	de7fe0ef          	jal	80002e9e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040bc:	4505                	li	a0,1
    800040be:	eedff0ef          	jal	80003faa <install_trans>
  log.lh.n = 0;
    800040c2:	0001d797          	auipc	a5,0x1d
    800040c6:	b407a523          	sw	zero,-1206(a5) # 80020c0c <log+0x2c>
  write_head(); // clear the log
    800040ca:	e83ff0ef          	jal	80003f4c <write_head>
}
    800040ce:	70a2                	ld	ra,40(sp)
    800040d0:	7402                	ld	s0,32(sp)
    800040d2:	64e2                	ld	s1,24(sp)
    800040d4:	6942                	ld	s2,16(sp)
    800040d6:	69a2                	ld	s3,8(sp)
    800040d8:	6145                	addi	sp,sp,48
    800040da:	8082                	ret

00000000800040dc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040dc:	1101                	addi	sp,sp,-32
    800040de:	ec06                	sd	ra,24(sp)
    800040e0:	e822                	sd	s0,16(sp)
    800040e2:	e426                	sd	s1,8(sp)
    800040e4:	e04a                	sd	s2,0(sp)
    800040e6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040e8:	0001d517          	auipc	a0,0x1d
    800040ec:	af850513          	addi	a0,a0,-1288 # 80020be0 <log>
    800040f0:	b0ffc0ef          	jal	80000bfe <acquire>
  while(1){
    if(log.committing){
    800040f4:	0001d497          	auipc	s1,0x1d
    800040f8:	aec48493          	addi	s1,s1,-1300 # 80020be0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040fc:	4979                	li	s2,30
    800040fe:	a029                	j	80004108 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80004100:	85a6                	mv	a1,s1
    80004102:	8526                	mv	a0,s1
    80004104:	da7fd0ef          	jal	80001eaa <sleep>
    if(log.committing){
    80004108:	50dc                	lw	a5,36(s1)
    8000410a:	fbfd                	bnez	a5,80004100 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000410c:	5098                	lw	a4,32(s1)
    8000410e:	2705                	addiw	a4,a4,1
    80004110:	0027179b          	slliw	a5,a4,0x2
    80004114:	9fb9                	addw	a5,a5,a4
    80004116:	0017979b          	slliw	a5,a5,0x1
    8000411a:	54d4                	lw	a3,44(s1)
    8000411c:	9fb5                	addw	a5,a5,a3
    8000411e:	00f95763          	bge	s2,a5,8000412c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004122:	85a6                	mv	a1,s1
    80004124:	8526                	mv	a0,s1
    80004126:	d85fd0ef          	jal	80001eaa <sleep>
    8000412a:	bff9                	j	80004108 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000412c:	0001d517          	auipc	a0,0x1d
    80004130:	ab450513          	addi	a0,a0,-1356 # 80020be0 <log>
    80004134:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004136:	b5dfc0ef          	jal	80000c92 <release>
      break;
    }
  }
}
    8000413a:	60e2                	ld	ra,24(sp)
    8000413c:	6442                	ld	s0,16(sp)
    8000413e:	64a2                	ld	s1,8(sp)
    80004140:	6902                	ld	s2,0(sp)
    80004142:	6105                	addi	sp,sp,32
    80004144:	8082                	ret

0000000080004146 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004146:	7139                	addi	sp,sp,-64
    80004148:	fc06                	sd	ra,56(sp)
    8000414a:	f822                	sd	s0,48(sp)
    8000414c:	f426                	sd	s1,40(sp)
    8000414e:	f04a                	sd	s2,32(sp)
    80004150:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004152:	0001d497          	auipc	s1,0x1d
    80004156:	a8e48493          	addi	s1,s1,-1394 # 80020be0 <log>
    8000415a:	8526                	mv	a0,s1
    8000415c:	aa3fc0ef          	jal	80000bfe <acquire>
  log.outstanding -= 1;
    80004160:	509c                	lw	a5,32(s1)
    80004162:	37fd                	addiw	a5,a5,-1
    80004164:	893e                	mv	s2,a5
    80004166:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004168:	50dc                	lw	a5,36(s1)
    8000416a:	ef9d                	bnez	a5,800041a8 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    8000416c:	04091863          	bnez	s2,800041bc <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80004170:	0001d497          	auipc	s1,0x1d
    80004174:	a7048493          	addi	s1,s1,-1424 # 80020be0 <log>
    80004178:	4785                	li	a5,1
    8000417a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000417c:	8526                	mv	a0,s1
    8000417e:	b15fc0ef          	jal	80000c92 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004182:	54dc                	lw	a5,44(s1)
    80004184:	04f04c63          	bgtz	a5,800041dc <end_op+0x96>
    acquire(&log.lock);
    80004188:	0001d497          	auipc	s1,0x1d
    8000418c:	a5848493          	addi	s1,s1,-1448 # 80020be0 <log>
    80004190:	8526                	mv	a0,s1
    80004192:	a6dfc0ef          	jal	80000bfe <acquire>
    log.committing = 0;
    80004196:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000419a:	8526                	mv	a0,s1
    8000419c:	d5bfd0ef          	jal	80001ef6 <wakeup>
    release(&log.lock);
    800041a0:	8526                	mv	a0,s1
    800041a2:	af1fc0ef          	jal	80000c92 <release>
}
    800041a6:	a02d                	j	800041d0 <end_op+0x8a>
    800041a8:	ec4e                	sd	s3,24(sp)
    800041aa:	e852                	sd	s4,16(sp)
    800041ac:	e456                	sd	s5,8(sp)
    800041ae:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800041b0:	00004517          	auipc	a0,0x4
    800041b4:	4e850513          	addi	a0,a0,1256 # 80008698 <etext+0x698>
    800041b8:	de6fc0ef          	jal	8000079e <panic>
    wakeup(&log);
    800041bc:	0001d497          	auipc	s1,0x1d
    800041c0:	a2448493          	addi	s1,s1,-1500 # 80020be0 <log>
    800041c4:	8526                	mv	a0,s1
    800041c6:	d31fd0ef          	jal	80001ef6 <wakeup>
  release(&log.lock);
    800041ca:	8526                	mv	a0,s1
    800041cc:	ac7fc0ef          	jal	80000c92 <release>
}
    800041d0:	70e2                	ld	ra,56(sp)
    800041d2:	7442                	ld	s0,48(sp)
    800041d4:	74a2                	ld	s1,40(sp)
    800041d6:	7902                	ld	s2,32(sp)
    800041d8:	6121                	addi	sp,sp,64
    800041da:	8082                	ret
    800041dc:	ec4e                	sd	s3,24(sp)
    800041de:	e852                	sd	s4,16(sp)
    800041e0:	e456                	sd	s5,8(sp)
    800041e2:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800041e4:	0001da97          	auipc	s5,0x1d
    800041e8:	a2ca8a93          	addi	s5,s5,-1492 # 80020c10 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041ec:	0001da17          	auipc	s4,0x1d
    800041f0:	9f4a0a13          	addi	s4,s4,-1548 # 80020be0 <log>
    memmove(to->data, from->data, BSIZE);
    800041f4:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041f8:	018a2583          	lw	a1,24(s4)
    800041fc:	012585bb          	addw	a1,a1,s2
    80004200:	2585                	addiw	a1,a1,1
    80004202:	028a2503          	lw	a0,40(s4)
    80004206:	b91fe0ef          	jal	80002d96 <bread>
    8000420a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000420c:	000aa583          	lw	a1,0(s5)
    80004210:	028a2503          	lw	a0,40(s4)
    80004214:	b83fe0ef          	jal	80002d96 <bread>
    80004218:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000421a:	865a                	mv	a2,s6
    8000421c:	05850593          	addi	a1,a0,88
    80004220:	05848513          	addi	a0,s1,88
    80004224:	b0ffc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80004228:	8526                	mv	a0,s1
    8000422a:	c43fe0ef          	jal	80002e6c <bwrite>
    brelse(from);
    8000422e:	854e                	mv	a0,s3
    80004230:	c6ffe0ef          	jal	80002e9e <brelse>
    brelse(to);
    80004234:	8526                	mv	a0,s1
    80004236:	c69fe0ef          	jal	80002e9e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000423a:	2905                	addiw	s2,s2,1
    8000423c:	0a91                	addi	s5,s5,4
    8000423e:	02ca2783          	lw	a5,44(s4)
    80004242:	faf94be3          	blt	s2,a5,800041f8 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004246:	d07ff0ef          	jal	80003f4c <write_head>
    install_trans(0); // Now install writes to home locations
    8000424a:	4501                	li	a0,0
    8000424c:	d5fff0ef          	jal	80003faa <install_trans>
    log.lh.n = 0;
    80004250:	0001d797          	auipc	a5,0x1d
    80004254:	9a07ae23          	sw	zero,-1604(a5) # 80020c0c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004258:	cf5ff0ef          	jal	80003f4c <write_head>
    8000425c:	69e2                	ld	s3,24(sp)
    8000425e:	6a42                	ld	s4,16(sp)
    80004260:	6aa2                	ld	s5,8(sp)
    80004262:	6b02                	ld	s6,0(sp)
    80004264:	b715                	j	80004188 <end_op+0x42>

0000000080004266 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004266:	1101                	addi	sp,sp,-32
    80004268:	ec06                	sd	ra,24(sp)
    8000426a:	e822                	sd	s0,16(sp)
    8000426c:	e426                	sd	s1,8(sp)
    8000426e:	e04a                	sd	s2,0(sp)
    80004270:	1000                	addi	s0,sp,32
    80004272:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004274:	0001d917          	auipc	s2,0x1d
    80004278:	96c90913          	addi	s2,s2,-1684 # 80020be0 <log>
    8000427c:	854a                	mv	a0,s2
    8000427e:	981fc0ef          	jal	80000bfe <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004282:	02c92603          	lw	a2,44(s2)
    80004286:	47f5                	li	a5,29
    80004288:	06c7c363          	blt	a5,a2,800042ee <log_write+0x88>
    8000428c:	0001d797          	auipc	a5,0x1d
    80004290:	9707a783          	lw	a5,-1680(a5) # 80020bfc <log+0x1c>
    80004294:	37fd                	addiw	a5,a5,-1
    80004296:	04f65c63          	bge	a2,a5,800042ee <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000429a:	0001d797          	auipc	a5,0x1d
    8000429e:	9667a783          	lw	a5,-1690(a5) # 80020c00 <log+0x20>
    800042a2:	04f05c63          	blez	a5,800042fa <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800042a6:	4781                	li	a5,0
    800042a8:	04c05f63          	blez	a2,80004306 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042ac:	44cc                	lw	a1,12(s1)
    800042ae:	0001d717          	auipc	a4,0x1d
    800042b2:	96270713          	addi	a4,a4,-1694 # 80020c10 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800042b6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042b8:	4314                	lw	a3,0(a4)
    800042ba:	04b68663          	beq	a3,a1,80004306 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800042be:	2785                	addiw	a5,a5,1
    800042c0:	0711                	addi	a4,a4,4
    800042c2:	fef61be3          	bne	a2,a5,800042b8 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800042c6:	0621                	addi	a2,a2,8
    800042c8:	060a                	slli	a2,a2,0x2
    800042ca:	0001d797          	auipc	a5,0x1d
    800042ce:	91678793          	addi	a5,a5,-1770 # 80020be0 <log>
    800042d2:	97b2                	add	a5,a5,a2
    800042d4:	44d8                	lw	a4,12(s1)
    800042d6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042d8:	8526                	mv	a0,s1
    800042da:	c49fe0ef          	jal	80002f22 <bpin>
    log.lh.n++;
    800042de:	0001d717          	auipc	a4,0x1d
    800042e2:	90270713          	addi	a4,a4,-1790 # 80020be0 <log>
    800042e6:	575c                	lw	a5,44(a4)
    800042e8:	2785                	addiw	a5,a5,1
    800042ea:	d75c                	sw	a5,44(a4)
    800042ec:	a80d                	j	8000431e <log_write+0xb8>
    panic("too big a transaction");
    800042ee:	00004517          	auipc	a0,0x4
    800042f2:	3ba50513          	addi	a0,a0,954 # 800086a8 <etext+0x6a8>
    800042f6:	ca8fc0ef          	jal	8000079e <panic>
    panic("log_write outside of trans");
    800042fa:	00004517          	auipc	a0,0x4
    800042fe:	3c650513          	addi	a0,a0,966 # 800086c0 <etext+0x6c0>
    80004302:	c9cfc0ef          	jal	8000079e <panic>
  log.lh.block[i] = b->blockno;
    80004306:	00878693          	addi	a3,a5,8
    8000430a:	068a                	slli	a3,a3,0x2
    8000430c:	0001d717          	auipc	a4,0x1d
    80004310:	8d470713          	addi	a4,a4,-1836 # 80020be0 <log>
    80004314:	9736                	add	a4,a4,a3
    80004316:	44d4                	lw	a3,12(s1)
    80004318:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000431a:	faf60fe3          	beq	a2,a5,800042d8 <log_write+0x72>
  }
  release(&log.lock);
    8000431e:	0001d517          	auipc	a0,0x1d
    80004322:	8c250513          	addi	a0,a0,-1854 # 80020be0 <log>
    80004326:	96dfc0ef          	jal	80000c92 <release>
}
    8000432a:	60e2                	ld	ra,24(sp)
    8000432c:	6442                	ld	s0,16(sp)
    8000432e:	64a2                	ld	s1,8(sp)
    80004330:	6902                	ld	s2,0(sp)
    80004332:	6105                	addi	sp,sp,32
    80004334:	8082                	ret

0000000080004336 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004336:	1101                	addi	sp,sp,-32
    80004338:	ec06                	sd	ra,24(sp)
    8000433a:	e822                	sd	s0,16(sp)
    8000433c:	e426                	sd	s1,8(sp)
    8000433e:	e04a                	sd	s2,0(sp)
    80004340:	1000                	addi	s0,sp,32
    80004342:	84aa                	mv	s1,a0
    80004344:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004346:	00004597          	auipc	a1,0x4
    8000434a:	39a58593          	addi	a1,a1,922 # 800086e0 <etext+0x6e0>
    8000434e:	0521                	addi	a0,a0,8
    80004350:	82bfc0ef          	jal	80000b7a <initlock>
  lk->name = name;
    80004354:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004358:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000435c:	0204a423          	sw	zero,40(s1)
}
    80004360:	60e2                	ld	ra,24(sp)
    80004362:	6442                	ld	s0,16(sp)
    80004364:	64a2                	ld	s1,8(sp)
    80004366:	6902                	ld	s2,0(sp)
    80004368:	6105                	addi	sp,sp,32
    8000436a:	8082                	ret

000000008000436c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000436c:	1101                	addi	sp,sp,-32
    8000436e:	ec06                	sd	ra,24(sp)
    80004370:	e822                	sd	s0,16(sp)
    80004372:	e426                	sd	s1,8(sp)
    80004374:	e04a                	sd	s2,0(sp)
    80004376:	1000                	addi	s0,sp,32
    80004378:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000437a:	00850913          	addi	s2,a0,8
    8000437e:	854a                	mv	a0,s2
    80004380:	87ffc0ef          	jal	80000bfe <acquire>
  while (lk->locked) {
    80004384:	409c                	lw	a5,0(s1)
    80004386:	c799                	beqz	a5,80004394 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004388:	85ca                	mv	a1,s2
    8000438a:	8526                	mv	a0,s1
    8000438c:	b1ffd0ef          	jal	80001eaa <sleep>
  while (lk->locked) {
    80004390:	409c                	lw	a5,0(s1)
    80004392:	fbfd                	bnez	a5,80004388 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004394:	4785                	li	a5,1
    80004396:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004398:	d44fd0ef          	jal	800018dc <myproc>
    8000439c:	591c                	lw	a5,48(a0)
    8000439e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800043a0:	854a                	mv	a0,s2
    800043a2:	8f1fc0ef          	jal	80000c92 <release>
}
    800043a6:	60e2                	ld	ra,24(sp)
    800043a8:	6442                	ld	s0,16(sp)
    800043aa:	64a2                	ld	s1,8(sp)
    800043ac:	6902                	ld	s2,0(sp)
    800043ae:	6105                	addi	sp,sp,32
    800043b0:	8082                	ret

00000000800043b2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043b2:	1101                	addi	sp,sp,-32
    800043b4:	ec06                	sd	ra,24(sp)
    800043b6:	e822                	sd	s0,16(sp)
    800043b8:	e426                	sd	s1,8(sp)
    800043ba:	e04a                	sd	s2,0(sp)
    800043bc:	1000                	addi	s0,sp,32
    800043be:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043c0:	00850913          	addi	s2,a0,8
    800043c4:	854a                	mv	a0,s2
    800043c6:	839fc0ef          	jal	80000bfe <acquire>
  lk->locked = 0;
    800043ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043ce:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043d2:	8526                	mv	a0,s1
    800043d4:	b23fd0ef          	jal	80001ef6 <wakeup>
  release(&lk->lk);
    800043d8:	854a                	mv	a0,s2
    800043da:	8b9fc0ef          	jal	80000c92 <release>
}
    800043de:	60e2                	ld	ra,24(sp)
    800043e0:	6442                	ld	s0,16(sp)
    800043e2:	64a2                	ld	s1,8(sp)
    800043e4:	6902                	ld	s2,0(sp)
    800043e6:	6105                	addi	sp,sp,32
    800043e8:	8082                	ret

00000000800043ea <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043ea:	7179                	addi	sp,sp,-48
    800043ec:	f406                	sd	ra,40(sp)
    800043ee:	f022                	sd	s0,32(sp)
    800043f0:	ec26                	sd	s1,24(sp)
    800043f2:	e84a                	sd	s2,16(sp)
    800043f4:	1800                	addi	s0,sp,48
    800043f6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800043f8:	00850913          	addi	s2,a0,8
    800043fc:	854a                	mv	a0,s2
    800043fe:	801fc0ef          	jal	80000bfe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004402:	409c                	lw	a5,0(s1)
    80004404:	ef81                	bnez	a5,8000441c <holdingsleep+0x32>
    80004406:	4481                	li	s1,0
  release(&lk->lk);
    80004408:	854a                	mv	a0,s2
    8000440a:	889fc0ef          	jal	80000c92 <release>
  return r;
}
    8000440e:	8526                	mv	a0,s1
    80004410:	70a2                	ld	ra,40(sp)
    80004412:	7402                	ld	s0,32(sp)
    80004414:	64e2                	ld	s1,24(sp)
    80004416:	6942                	ld	s2,16(sp)
    80004418:	6145                	addi	sp,sp,48
    8000441a:	8082                	ret
    8000441c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000441e:	0284a983          	lw	s3,40(s1)
    80004422:	cbafd0ef          	jal	800018dc <myproc>
    80004426:	5904                	lw	s1,48(a0)
    80004428:	413484b3          	sub	s1,s1,s3
    8000442c:	0014b493          	seqz	s1,s1
    80004430:	69a2                	ld	s3,8(sp)
    80004432:	bfd9                	j	80004408 <holdingsleep+0x1e>

0000000080004434 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004434:	1141                	addi	sp,sp,-16
    80004436:	e406                	sd	ra,8(sp)
    80004438:	e022                	sd	s0,0(sp)
    8000443a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000443c:	00004597          	auipc	a1,0x4
    80004440:	2b458593          	addi	a1,a1,692 # 800086f0 <etext+0x6f0>
    80004444:	0001d517          	auipc	a0,0x1d
    80004448:	8e450513          	addi	a0,a0,-1820 # 80020d28 <ftable>
    8000444c:	f2efc0ef          	jal	80000b7a <initlock>
}
    80004450:	60a2                	ld	ra,8(sp)
    80004452:	6402                	ld	s0,0(sp)
    80004454:	0141                	addi	sp,sp,16
    80004456:	8082                	ret

0000000080004458 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004458:	1101                	addi	sp,sp,-32
    8000445a:	ec06                	sd	ra,24(sp)
    8000445c:	e822                	sd	s0,16(sp)
    8000445e:	e426                	sd	s1,8(sp)
    80004460:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004462:	0001d517          	auipc	a0,0x1d
    80004466:	8c650513          	addi	a0,a0,-1850 # 80020d28 <ftable>
    8000446a:	f94fc0ef          	jal	80000bfe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000446e:	0001d497          	auipc	s1,0x1d
    80004472:	8d248493          	addi	s1,s1,-1838 # 80020d40 <ftable+0x18>
    80004476:	0001e717          	auipc	a4,0x1e
    8000447a:	86a70713          	addi	a4,a4,-1942 # 80021ce0 <disk>
    if(f->ref == 0){
    8000447e:	40dc                	lw	a5,4(s1)
    80004480:	cf89                	beqz	a5,8000449a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004482:	02848493          	addi	s1,s1,40
    80004486:	fee49ce3          	bne	s1,a4,8000447e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000448a:	0001d517          	auipc	a0,0x1d
    8000448e:	89e50513          	addi	a0,a0,-1890 # 80020d28 <ftable>
    80004492:	801fc0ef          	jal	80000c92 <release>
  return 0;
    80004496:	4481                	li	s1,0
    80004498:	a809                	j	800044aa <filealloc+0x52>
      f->ref = 1;
    8000449a:	4785                	li	a5,1
    8000449c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000449e:	0001d517          	auipc	a0,0x1d
    800044a2:	88a50513          	addi	a0,a0,-1910 # 80020d28 <ftable>
    800044a6:	fecfc0ef          	jal	80000c92 <release>
}
    800044aa:	8526                	mv	a0,s1
    800044ac:	60e2                	ld	ra,24(sp)
    800044ae:	6442                	ld	s0,16(sp)
    800044b0:	64a2                	ld	s1,8(sp)
    800044b2:	6105                	addi	sp,sp,32
    800044b4:	8082                	ret

00000000800044b6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800044b6:	1101                	addi	sp,sp,-32
    800044b8:	ec06                	sd	ra,24(sp)
    800044ba:	e822                	sd	s0,16(sp)
    800044bc:	e426                	sd	s1,8(sp)
    800044be:	1000                	addi	s0,sp,32
    800044c0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800044c2:	0001d517          	auipc	a0,0x1d
    800044c6:	86650513          	addi	a0,a0,-1946 # 80020d28 <ftable>
    800044ca:	f34fc0ef          	jal	80000bfe <acquire>
  if(f->ref < 1)
    800044ce:	40dc                	lw	a5,4(s1)
    800044d0:	02f05063          	blez	a5,800044f0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800044d4:	2785                	addiw	a5,a5,1
    800044d6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800044d8:	0001d517          	auipc	a0,0x1d
    800044dc:	85050513          	addi	a0,a0,-1968 # 80020d28 <ftable>
    800044e0:	fb2fc0ef          	jal	80000c92 <release>
  return f;
}
    800044e4:	8526                	mv	a0,s1
    800044e6:	60e2                	ld	ra,24(sp)
    800044e8:	6442                	ld	s0,16(sp)
    800044ea:	64a2                	ld	s1,8(sp)
    800044ec:	6105                	addi	sp,sp,32
    800044ee:	8082                	ret
    panic("filedup");
    800044f0:	00004517          	auipc	a0,0x4
    800044f4:	20850513          	addi	a0,a0,520 # 800086f8 <etext+0x6f8>
    800044f8:	aa6fc0ef          	jal	8000079e <panic>

00000000800044fc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044fc:	7139                	addi	sp,sp,-64
    800044fe:	fc06                	sd	ra,56(sp)
    80004500:	f822                	sd	s0,48(sp)
    80004502:	f426                	sd	s1,40(sp)
    80004504:	0080                	addi	s0,sp,64
    80004506:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004508:	0001d517          	auipc	a0,0x1d
    8000450c:	82050513          	addi	a0,a0,-2016 # 80020d28 <ftable>
    80004510:	eeefc0ef          	jal	80000bfe <acquire>
  if(f->ref < 1)
    80004514:	40dc                	lw	a5,4(s1)
    80004516:	04f05863          	blez	a5,80004566 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    8000451a:	37fd                	addiw	a5,a5,-1
    8000451c:	c0dc                	sw	a5,4(s1)
    8000451e:	04f04e63          	bgtz	a5,8000457a <fileclose+0x7e>
    80004522:	f04a                	sd	s2,32(sp)
    80004524:	ec4e                	sd	s3,24(sp)
    80004526:	e852                	sd	s4,16(sp)
    80004528:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000452a:	0004a903          	lw	s2,0(s1)
    8000452e:	0094ca83          	lbu	s5,9(s1)
    80004532:	0104ba03          	ld	s4,16(s1)
    80004536:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000453a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000453e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004542:	0001c517          	auipc	a0,0x1c
    80004546:	7e650513          	addi	a0,a0,2022 # 80020d28 <ftable>
    8000454a:	f48fc0ef          	jal	80000c92 <release>

  if(ff.type == FD_PIPE){
    8000454e:	4785                	li	a5,1
    80004550:	04f90063          	beq	s2,a5,80004590 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004554:	3979                	addiw	s2,s2,-2
    80004556:	4785                	li	a5,1
    80004558:	0527f563          	bgeu	a5,s2,800045a2 <fileclose+0xa6>
    8000455c:	7902                	ld	s2,32(sp)
    8000455e:	69e2                	ld	s3,24(sp)
    80004560:	6a42                	ld	s4,16(sp)
    80004562:	6aa2                	ld	s5,8(sp)
    80004564:	a00d                	j	80004586 <fileclose+0x8a>
    80004566:	f04a                	sd	s2,32(sp)
    80004568:	ec4e                	sd	s3,24(sp)
    8000456a:	e852                	sd	s4,16(sp)
    8000456c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000456e:	00004517          	auipc	a0,0x4
    80004572:	19250513          	addi	a0,a0,402 # 80008700 <etext+0x700>
    80004576:	a28fc0ef          	jal	8000079e <panic>
    release(&ftable.lock);
    8000457a:	0001c517          	auipc	a0,0x1c
    8000457e:	7ae50513          	addi	a0,a0,1966 # 80020d28 <ftable>
    80004582:	f10fc0ef          	jal	80000c92 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004586:	70e2                	ld	ra,56(sp)
    80004588:	7442                	ld	s0,48(sp)
    8000458a:	74a2                	ld	s1,40(sp)
    8000458c:	6121                	addi	sp,sp,64
    8000458e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004590:	85d6                	mv	a1,s5
    80004592:	8552                	mv	a0,s4
    80004594:	340000ef          	jal	800048d4 <pipeclose>
    80004598:	7902                	ld	s2,32(sp)
    8000459a:	69e2                	ld	s3,24(sp)
    8000459c:	6a42                	ld	s4,16(sp)
    8000459e:	6aa2                	ld	s5,8(sp)
    800045a0:	b7dd                	j	80004586 <fileclose+0x8a>
    begin_op();
    800045a2:	b3bff0ef          	jal	800040dc <begin_op>
    iput(ff.ip);
    800045a6:	854e                	mv	a0,s3
    800045a8:	882ff0ef          	jal	8000362a <iput>
    end_op();
    800045ac:	b9bff0ef          	jal	80004146 <end_op>
    800045b0:	7902                	ld	s2,32(sp)
    800045b2:	69e2                	ld	s3,24(sp)
    800045b4:	6a42                	ld	s4,16(sp)
    800045b6:	6aa2                	ld	s5,8(sp)
    800045b8:	b7f9                	j	80004586 <fileclose+0x8a>

00000000800045ba <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800045ba:	715d                	addi	sp,sp,-80
    800045bc:	e486                	sd	ra,72(sp)
    800045be:	e0a2                	sd	s0,64(sp)
    800045c0:	fc26                	sd	s1,56(sp)
    800045c2:	f44e                	sd	s3,40(sp)
    800045c4:	0880                	addi	s0,sp,80
    800045c6:	84aa                	mv	s1,a0
    800045c8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800045ca:	b12fd0ef          	jal	800018dc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800045ce:	409c                	lw	a5,0(s1)
    800045d0:	37f9                	addiw	a5,a5,-2
    800045d2:	4705                	li	a4,1
    800045d4:	04f76263          	bltu	a4,a5,80004618 <filestat+0x5e>
    800045d8:	f84a                	sd	s2,48(sp)
    800045da:	f052                	sd	s4,32(sp)
    800045dc:	892a                	mv	s2,a0
    ilock(f->ip);
    800045de:	6c88                	ld	a0,24(s1)
    800045e0:	ec9fe0ef          	jal	800034a8 <ilock>
    stati(f->ip, &st);
    800045e4:	fb840a13          	addi	s4,s0,-72
    800045e8:	85d2                	mv	a1,s4
    800045ea:	6c88                	ld	a0,24(s1)
    800045ec:	8e6ff0ef          	jal	800036d2 <stati>
    iunlock(f->ip);
    800045f0:	6c88                	ld	a0,24(s1)
    800045f2:	f65fe0ef          	jal	80003556 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045f6:	46e1                	li	a3,24
    800045f8:	8652                	mv	a2,s4
    800045fa:	85ce                	mv	a1,s3
    800045fc:	05093503          	ld	a0,80(s2)
    80004600:	f85fc0ef          	jal	80001584 <copyout>
    80004604:	41f5551b          	sraiw	a0,a0,0x1f
    80004608:	7942                	ld	s2,48(sp)
    8000460a:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000460c:	60a6                	ld	ra,72(sp)
    8000460e:	6406                	ld	s0,64(sp)
    80004610:	74e2                	ld	s1,56(sp)
    80004612:	79a2                	ld	s3,40(sp)
    80004614:	6161                	addi	sp,sp,80
    80004616:	8082                	ret
  return -1;
    80004618:	557d                	li	a0,-1
    8000461a:	bfcd                	j	8000460c <filestat+0x52>

000000008000461c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000461c:	7179                	addi	sp,sp,-48
    8000461e:	f406                	sd	ra,40(sp)
    80004620:	f022                	sd	s0,32(sp)
    80004622:	e84a                	sd	s2,16(sp)
    80004624:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004626:	00854783          	lbu	a5,8(a0)
    8000462a:	cfd1                	beqz	a5,800046c6 <fileread+0xaa>
    8000462c:	ec26                	sd	s1,24(sp)
    8000462e:	e44e                	sd	s3,8(sp)
    80004630:	84aa                	mv	s1,a0
    80004632:	89ae                	mv	s3,a1
    80004634:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004636:	411c                	lw	a5,0(a0)
    80004638:	4705                	li	a4,1
    8000463a:	04e78363          	beq	a5,a4,80004680 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000463e:	470d                	li	a4,3
    80004640:	04e78763          	beq	a5,a4,8000468e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004644:	4709                	li	a4,2
    80004646:	06e79a63          	bne	a5,a4,800046ba <fileread+0x9e>
    ilock(f->ip);
    8000464a:	6d08                	ld	a0,24(a0)
    8000464c:	e5dfe0ef          	jal	800034a8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004650:	874a                	mv	a4,s2
    80004652:	5094                	lw	a3,32(s1)
    80004654:	864e                	mv	a2,s3
    80004656:	4585                	li	a1,1
    80004658:	6c88                	ld	a0,24(s1)
    8000465a:	8a6ff0ef          	jal	80003700 <readi>
    8000465e:	892a                	mv	s2,a0
    80004660:	00a05563          	blez	a0,8000466a <fileread+0x4e>
      f->off += r;
    80004664:	509c                	lw	a5,32(s1)
    80004666:	9fa9                	addw	a5,a5,a0
    80004668:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000466a:	6c88                	ld	a0,24(s1)
    8000466c:	eebfe0ef          	jal	80003556 <iunlock>
    80004670:	64e2                	ld	s1,24(sp)
    80004672:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004674:	854a                	mv	a0,s2
    80004676:	70a2                	ld	ra,40(sp)
    80004678:	7402                	ld	s0,32(sp)
    8000467a:	6942                	ld	s2,16(sp)
    8000467c:	6145                	addi	sp,sp,48
    8000467e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004680:	6908                	ld	a0,16(a0)
    80004682:	3a2000ef          	jal	80004a24 <piperead>
    80004686:	892a                	mv	s2,a0
    80004688:	64e2                	ld	s1,24(sp)
    8000468a:	69a2                	ld	s3,8(sp)
    8000468c:	b7e5                	j	80004674 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000468e:	02451783          	lh	a5,36(a0)
    80004692:	03079693          	slli	a3,a5,0x30
    80004696:	92c1                	srli	a3,a3,0x30
    80004698:	4725                	li	a4,9
    8000469a:	02d76863          	bltu	a4,a3,800046ca <fileread+0xae>
    8000469e:	0792                	slli	a5,a5,0x4
    800046a0:	0001c717          	auipc	a4,0x1c
    800046a4:	5e870713          	addi	a4,a4,1512 # 80020c88 <devsw>
    800046a8:	97ba                	add	a5,a5,a4
    800046aa:	639c                	ld	a5,0(a5)
    800046ac:	c39d                	beqz	a5,800046d2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800046ae:	4505                	li	a0,1
    800046b0:	9782                	jalr	a5
    800046b2:	892a                	mv	s2,a0
    800046b4:	64e2                	ld	s1,24(sp)
    800046b6:	69a2                	ld	s3,8(sp)
    800046b8:	bf75                	j	80004674 <fileread+0x58>
    panic("fileread");
    800046ba:	00004517          	auipc	a0,0x4
    800046be:	05650513          	addi	a0,a0,86 # 80008710 <etext+0x710>
    800046c2:	8dcfc0ef          	jal	8000079e <panic>
    return -1;
    800046c6:	597d                	li	s2,-1
    800046c8:	b775                	j	80004674 <fileread+0x58>
      return -1;
    800046ca:	597d                	li	s2,-1
    800046cc:	64e2                	ld	s1,24(sp)
    800046ce:	69a2                	ld	s3,8(sp)
    800046d0:	b755                	j	80004674 <fileread+0x58>
    800046d2:	597d                	li	s2,-1
    800046d4:	64e2                	ld	s1,24(sp)
    800046d6:	69a2                	ld	s3,8(sp)
    800046d8:	bf71                	j	80004674 <fileread+0x58>

00000000800046da <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800046da:	00954783          	lbu	a5,9(a0)
    800046de:	10078e63          	beqz	a5,800047fa <filewrite+0x120>
{
    800046e2:	711d                	addi	sp,sp,-96
    800046e4:	ec86                	sd	ra,88(sp)
    800046e6:	e8a2                	sd	s0,80(sp)
    800046e8:	e0ca                	sd	s2,64(sp)
    800046ea:	f456                	sd	s5,40(sp)
    800046ec:	f05a                	sd	s6,32(sp)
    800046ee:	1080                	addi	s0,sp,96
    800046f0:	892a                	mv	s2,a0
    800046f2:	8b2e                	mv	s6,a1
    800046f4:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800046f6:	411c                	lw	a5,0(a0)
    800046f8:	4705                	li	a4,1
    800046fa:	02e78963          	beq	a5,a4,8000472c <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046fe:	470d                	li	a4,3
    80004700:	02e78a63          	beq	a5,a4,80004734 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004704:	4709                	li	a4,2
    80004706:	0ce79e63          	bne	a5,a4,800047e2 <filewrite+0x108>
    8000470a:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000470c:	0ac05963          	blez	a2,800047be <filewrite+0xe4>
    80004710:	e4a6                	sd	s1,72(sp)
    80004712:	fc4e                	sd	s3,56(sp)
    80004714:	ec5e                	sd	s7,24(sp)
    80004716:	e862                	sd	s8,16(sp)
    80004718:	e466                	sd	s9,8(sp)
    int i = 0;
    8000471a:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000471c:	6b85                	lui	s7,0x1
    8000471e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004722:	6c85                	lui	s9,0x1
    80004724:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004728:	4c05                	li	s8,1
    8000472a:	a8ad                	j	800047a4 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    8000472c:	6908                	ld	a0,16(a0)
    8000472e:	1fe000ef          	jal	8000492c <pipewrite>
    80004732:	a04d                	j	800047d4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004734:	02451783          	lh	a5,36(a0)
    80004738:	03079693          	slli	a3,a5,0x30
    8000473c:	92c1                	srli	a3,a3,0x30
    8000473e:	4725                	li	a4,9
    80004740:	0ad76f63          	bltu	a4,a3,800047fe <filewrite+0x124>
    80004744:	0792                	slli	a5,a5,0x4
    80004746:	0001c717          	auipc	a4,0x1c
    8000474a:	54270713          	addi	a4,a4,1346 # 80020c88 <devsw>
    8000474e:	97ba                	add	a5,a5,a4
    80004750:	679c                	ld	a5,8(a5)
    80004752:	cbc5                	beqz	a5,80004802 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004754:	4505                	li	a0,1
    80004756:	9782                	jalr	a5
    80004758:	a8b5                	j	800047d4 <filewrite+0xfa>
      if(n1 > max)
    8000475a:	2981                	sext.w	s3,s3
      begin_op();
    8000475c:	981ff0ef          	jal	800040dc <begin_op>
      ilock(f->ip);
    80004760:	01893503          	ld	a0,24(s2)
    80004764:	d45fe0ef          	jal	800034a8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004768:	874e                	mv	a4,s3
    8000476a:	02092683          	lw	a3,32(s2)
    8000476e:	016a0633          	add	a2,s4,s6
    80004772:	85e2                	mv	a1,s8
    80004774:	01893503          	ld	a0,24(s2)
    80004778:	a96ff0ef          	jal	80003a0e <writei>
    8000477c:	84aa                	mv	s1,a0
    8000477e:	00a05763          	blez	a0,8000478c <filewrite+0xb2>
        f->off += r;
    80004782:	02092783          	lw	a5,32(s2)
    80004786:	9fa9                	addw	a5,a5,a0
    80004788:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000478c:	01893503          	ld	a0,24(s2)
    80004790:	dc7fe0ef          	jal	80003556 <iunlock>
      end_op();
    80004794:	9b3ff0ef          	jal	80004146 <end_op>

      if(r != n1){
    80004798:	02999563          	bne	s3,s1,800047c2 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000479c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800047a0:	015a5963          	bge	s4,s5,800047b2 <filewrite+0xd8>
      int n1 = n - i;
    800047a4:	414a87bb          	subw	a5,s5,s4
    800047a8:	89be                	mv	s3,a5
      if(n1 > max)
    800047aa:	fafbd8e3          	bge	s7,a5,8000475a <filewrite+0x80>
    800047ae:	89e6                	mv	s3,s9
    800047b0:	b76d                	j	8000475a <filewrite+0x80>
    800047b2:	64a6                	ld	s1,72(sp)
    800047b4:	79e2                	ld	s3,56(sp)
    800047b6:	6be2                	ld	s7,24(sp)
    800047b8:	6c42                	ld	s8,16(sp)
    800047ba:	6ca2                	ld	s9,8(sp)
    800047bc:	a801                	j	800047cc <filewrite+0xf2>
    int i = 0;
    800047be:	4a01                	li	s4,0
    800047c0:	a031                	j	800047cc <filewrite+0xf2>
    800047c2:	64a6                	ld	s1,72(sp)
    800047c4:	79e2                	ld	s3,56(sp)
    800047c6:	6be2                	ld	s7,24(sp)
    800047c8:	6c42                	ld	s8,16(sp)
    800047ca:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800047cc:	034a9d63          	bne	s5,s4,80004806 <filewrite+0x12c>
    800047d0:	8556                	mv	a0,s5
    800047d2:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047d4:	60e6                	ld	ra,88(sp)
    800047d6:	6446                	ld	s0,80(sp)
    800047d8:	6906                	ld	s2,64(sp)
    800047da:	7aa2                	ld	s5,40(sp)
    800047dc:	7b02                	ld	s6,32(sp)
    800047de:	6125                	addi	sp,sp,96
    800047e0:	8082                	ret
    800047e2:	e4a6                	sd	s1,72(sp)
    800047e4:	fc4e                	sd	s3,56(sp)
    800047e6:	f852                	sd	s4,48(sp)
    800047e8:	ec5e                	sd	s7,24(sp)
    800047ea:	e862                	sd	s8,16(sp)
    800047ec:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800047ee:	00004517          	auipc	a0,0x4
    800047f2:	f3250513          	addi	a0,a0,-206 # 80008720 <etext+0x720>
    800047f6:	fa9fb0ef          	jal	8000079e <panic>
    return -1;
    800047fa:	557d                	li	a0,-1
}
    800047fc:	8082                	ret
      return -1;
    800047fe:	557d                	li	a0,-1
    80004800:	bfd1                	j	800047d4 <filewrite+0xfa>
    80004802:	557d                	li	a0,-1
    80004804:	bfc1                	j	800047d4 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80004806:	557d                	li	a0,-1
    80004808:	7a42                	ld	s4,48(sp)
    8000480a:	b7e9                	j	800047d4 <filewrite+0xfa>

000000008000480c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000480c:	7179                	addi	sp,sp,-48
    8000480e:	f406                	sd	ra,40(sp)
    80004810:	f022                	sd	s0,32(sp)
    80004812:	ec26                	sd	s1,24(sp)
    80004814:	e052                	sd	s4,0(sp)
    80004816:	1800                	addi	s0,sp,48
    80004818:	84aa                	mv	s1,a0
    8000481a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000481c:	0005b023          	sd	zero,0(a1)
    80004820:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004824:	c35ff0ef          	jal	80004458 <filealloc>
    80004828:	e088                	sd	a0,0(s1)
    8000482a:	c549                	beqz	a0,800048b4 <pipealloc+0xa8>
    8000482c:	c2dff0ef          	jal	80004458 <filealloc>
    80004830:	00aa3023          	sd	a0,0(s4)
    80004834:	cd25                	beqz	a0,800048ac <pipealloc+0xa0>
    80004836:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004838:	af2fc0ef          	jal	80000b2a <kalloc>
    8000483c:	892a                	mv	s2,a0
    8000483e:	c12d                	beqz	a0,800048a0 <pipealloc+0x94>
    80004840:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004842:	4985                	li	s3,1
    80004844:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004848:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000484c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004850:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004854:	00004597          	auipc	a1,0x4
    80004858:	edc58593          	addi	a1,a1,-292 # 80008730 <etext+0x730>
    8000485c:	b1efc0ef          	jal	80000b7a <initlock>
  (*f0)->type = FD_PIPE;
    80004860:	609c                	ld	a5,0(s1)
    80004862:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004866:	609c                	ld	a5,0(s1)
    80004868:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000486c:	609c                	ld	a5,0(s1)
    8000486e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004872:	609c                	ld	a5,0(s1)
    80004874:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004878:	000a3783          	ld	a5,0(s4)
    8000487c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004880:	000a3783          	ld	a5,0(s4)
    80004884:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004888:	000a3783          	ld	a5,0(s4)
    8000488c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004890:	000a3783          	ld	a5,0(s4)
    80004894:	0127b823          	sd	s2,16(a5)
  return 0;
    80004898:	4501                	li	a0,0
    8000489a:	6942                	ld	s2,16(sp)
    8000489c:	69a2                	ld	s3,8(sp)
    8000489e:	a01d                	j	800048c4 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800048a0:	6088                	ld	a0,0(s1)
    800048a2:	c119                	beqz	a0,800048a8 <pipealloc+0x9c>
    800048a4:	6942                	ld	s2,16(sp)
    800048a6:	a029                	j	800048b0 <pipealloc+0xa4>
    800048a8:	6942                	ld	s2,16(sp)
    800048aa:	a029                	j	800048b4 <pipealloc+0xa8>
    800048ac:	6088                	ld	a0,0(s1)
    800048ae:	c10d                	beqz	a0,800048d0 <pipealloc+0xc4>
    fileclose(*f0);
    800048b0:	c4dff0ef          	jal	800044fc <fileclose>
  if(*f1)
    800048b4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800048b8:	557d                	li	a0,-1
  if(*f1)
    800048ba:	c789                	beqz	a5,800048c4 <pipealloc+0xb8>
    fileclose(*f1);
    800048bc:	853e                	mv	a0,a5
    800048be:	c3fff0ef          	jal	800044fc <fileclose>
  return -1;
    800048c2:	557d                	li	a0,-1
}
    800048c4:	70a2                	ld	ra,40(sp)
    800048c6:	7402                	ld	s0,32(sp)
    800048c8:	64e2                	ld	s1,24(sp)
    800048ca:	6a02                	ld	s4,0(sp)
    800048cc:	6145                	addi	sp,sp,48
    800048ce:	8082                	ret
  return -1;
    800048d0:	557d                	li	a0,-1
    800048d2:	bfcd                	j	800048c4 <pipealloc+0xb8>

00000000800048d4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048d4:	1101                	addi	sp,sp,-32
    800048d6:	ec06                	sd	ra,24(sp)
    800048d8:	e822                	sd	s0,16(sp)
    800048da:	e426                	sd	s1,8(sp)
    800048dc:	e04a                	sd	s2,0(sp)
    800048de:	1000                	addi	s0,sp,32
    800048e0:	84aa                	mv	s1,a0
    800048e2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048e4:	b1afc0ef          	jal	80000bfe <acquire>
  if(writable){
    800048e8:	02090763          	beqz	s2,80004916 <pipeclose+0x42>
    pi->writeopen = 0;
    800048ec:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048f0:	21848513          	addi	a0,s1,536
    800048f4:	e02fd0ef          	jal	80001ef6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048f8:	2204b783          	ld	a5,544(s1)
    800048fc:	e785                	bnez	a5,80004924 <pipeclose+0x50>
    release(&pi->lock);
    800048fe:	8526                	mv	a0,s1
    80004900:	b92fc0ef          	jal	80000c92 <release>
    kfree((char*)pi);
    80004904:	8526                	mv	a0,s1
    80004906:	942fc0ef          	jal	80000a48 <kfree>
  } else
    release(&pi->lock);
}
    8000490a:	60e2                	ld	ra,24(sp)
    8000490c:	6442                	ld	s0,16(sp)
    8000490e:	64a2                	ld	s1,8(sp)
    80004910:	6902                	ld	s2,0(sp)
    80004912:	6105                	addi	sp,sp,32
    80004914:	8082                	ret
    pi->readopen = 0;
    80004916:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000491a:	21c48513          	addi	a0,s1,540
    8000491e:	dd8fd0ef          	jal	80001ef6 <wakeup>
    80004922:	bfd9                	j	800048f8 <pipeclose+0x24>
    release(&pi->lock);
    80004924:	8526                	mv	a0,s1
    80004926:	b6cfc0ef          	jal	80000c92 <release>
}
    8000492a:	b7c5                	j	8000490a <pipeclose+0x36>

000000008000492c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000492c:	7159                	addi	sp,sp,-112
    8000492e:	f486                	sd	ra,104(sp)
    80004930:	f0a2                	sd	s0,96(sp)
    80004932:	eca6                	sd	s1,88(sp)
    80004934:	e8ca                	sd	s2,80(sp)
    80004936:	e4ce                	sd	s3,72(sp)
    80004938:	e0d2                	sd	s4,64(sp)
    8000493a:	fc56                	sd	s5,56(sp)
    8000493c:	1880                	addi	s0,sp,112
    8000493e:	84aa                	mv	s1,a0
    80004940:	8aae                	mv	s5,a1
    80004942:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004944:	f99fc0ef          	jal	800018dc <myproc>
    80004948:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000494a:	8526                	mv	a0,s1
    8000494c:	ab2fc0ef          	jal	80000bfe <acquire>
  while(i < n){
    80004950:	0d405263          	blez	s4,80004a14 <pipewrite+0xe8>
    80004954:	f85a                	sd	s6,48(sp)
    80004956:	f45e                	sd	s7,40(sp)
    80004958:	f062                	sd	s8,32(sp)
    8000495a:	ec66                	sd	s9,24(sp)
    8000495c:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000495e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004960:	f9f40c13          	addi	s8,s0,-97
    80004964:	4b85                	li	s7,1
    80004966:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004968:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000496c:	21c48c93          	addi	s9,s1,540
    80004970:	a82d                	j	800049aa <pipewrite+0x7e>
      release(&pi->lock);
    80004972:	8526                	mv	a0,s1
    80004974:	b1efc0ef          	jal	80000c92 <release>
      return -1;
    80004978:	597d                	li	s2,-1
    8000497a:	7b42                	ld	s6,48(sp)
    8000497c:	7ba2                	ld	s7,40(sp)
    8000497e:	7c02                	ld	s8,32(sp)
    80004980:	6ce2                	ld	s9,24(sp)
    80004982:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004984:	854a                	mv	a0,s2
    80004986:	70a6                	ld	ra,104(sp)
    80004988:	7406                	ld	s0,96(sp)
    8000498a:	64e6                	ld	s1,88(sp)
    8000498c:	6946                	ld	s2,80(sp)
    8000498e:	69a6                	ld	s3,72(sp)
    80004990:	6a06                	ld	s4,64(sp)
    80004992:	7ae2                	ld	s5,56(sp)
    80004994:	6165                	addi	sp,sp,112
    80004996:	8082                	ret
      wakeup(&pi->nread);
    80004998:	856a                	mv	a0,s10
    8000499a:	d5cfd0ef          	jal	80001ef6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000499e:	85a6                	mv	a1,s1
    800049a0:	8566                	mv	a0,s9
    800049a2:	d08fd0ef          	jal	80001eaa <sleep>
  while(i < n){
    800049a6:	05495a63          	bge	s2,s4,800049fa <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800049aa:	2204a783          	lw	a5,544(s1)
    800049ae:	d3f1                	beqz	a5,80004972 <pipewrite+0x46>
    800049b0:	854e                	mv	a0,s3
    800049b2:	f30fd0ef          	jal	800020e2 <killed>
    800049b6:	fd55                	bnez	a0,80004972 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800049b8:	2184a783          	lw	a5,536(s1)
    800049bc:	21c4a703          	lw	a4,540(s1)
    800049c0:	2007879b          	addiw	a5,a5,512
    800049c4:	fcf70ae3          	beq	a4,a5,80004998 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049c8:	86de                	mv	a3,s7
    800049ca:	01590633          	add	a2,s2,s5
    800049ce:	85e2                	mv	a1,s8
    800049d0:	0509b503          	ld	a0,80(s3)
    800049d4:	c61fc0ef          	jal	80001634 <copyin>
    800049d8:	05650063          	beq	a0,s6,80004a18 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049dc:	21c4a783          	lw	a5,540(s1)
    800049e0:	0017871b          	addiw	a4,a5,1
    800049e4:	20e4ae23          	sw	a4,540(s1)
    800049e8:	1ff7f793          	andi	a5,a5,511
    800049ec:	97a6                	add	a5,a5,s1
    800049ee:	f9f44703          	lbu	a4,-97(s0)
    800049f2:	00e78c23          	sb	a4,24(a5)
      i++;
    800049f6:	2905                	addiw	s2,s2,1
    800049f8:	b77d                	j	800049a6 <pipewrite+0x7a>
    800049fa:	7b42                	ld	s6,48(sp)
    800049fc:	7ba2                	ld	s7,40(sp)
    800049fe:	7c02                	ld	s8,32(sp)
    80004a00:	6ce2                	ld	s9,24(sp)
    80004a02:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004a04:	21848513          	addi	a0,s1,536
    80004a08:	ceefd0ef          	jal	80001ef6 <wakeup>
  release(&pi->lock);
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	a84fc0ef          	jal	80000c92 <release>
  return i;
    80004a12:	bf8d                	j	80004984 <pipewrite+0x58>
  int i = 0;
    80004a14:	4901                	li	s2,0
    80004a16:	b7fd                	j	80004a04 <pipewrite+0xd8>
    80004a18:	7b42                	ld	s6,48(sp)
    80004a1a:	7ba2                	ld	s7,40(sp)
    80004a1c:	7c02                	ld	s8,32(sp)
    80004a1e:	6ce2                	ld	s9,24(sp)
    80004a20:	6d42                	ld	s10,16(sp)
    80004a22:	b7cd                	j	80004a04 <pipewrite+0xd8>

0000000080004a24 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a24:	711d                	addi	sp,sp,-96
    80004a26:	ec86                	sd	ra,88(sp)
    80004a28:	e8a2                	sd	s0,80(sp)
    80004a2a:	e4a6                	sd	s1,72(sp)
    80004a2c:	e0ca                	sd	s2,64(sp)
    80004a2e:	fc4e                	sd	s3,56(sp)
    80004a30:	f852                	sd	s4,48(sp)
    80004a32:	f456                	sd	s5,40(sp)
    80004a34:	1080                	addi	s0,sp,96
    80004a36:	84aa                	mv	s1,a0
    80004a38:	892e                	mv	s2,a1
    80004a3a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a3c:	ea1fc0ef          	jal	800018dc <myproc>
    80004a40:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a42:	8526                	mv	a0,s1
    80004a44:	9bafc0ef          	jal	80000bfe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a48:	2184a703          	lw	a4,536(s1)
    80004a4c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a50:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a54:	02f71763          	bne	a4,a5,80004a82 <piperead+0x5e>
    80004a58:	2244a783          	lw	a5,548(s1)
    80004a5c:	cf85                	beqz	a5,80004a94 <piperead+0x70>
    if(killed(pr)){
    80004a5e:	8552                	mv	a0,s4
    80004a60:	e82fd0ef          	jal	800020e2 <killed>
    80004a64:	e11d                	bnez	a0,80004a8a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a66:	85a6                	mv	a1,s1
    80004a68:	854e                	mv	a0,s3
    80004a6a:	c40fd0ef          	jal	80001eaa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a6e:	2184a703          	lw	a4,536(s1)
    80004a72:	21c4a783          	lw	a5,540(s1)
    80004a76:	fef701e3          	beq	a4,a5,80004a58 <piperead+0x34>
    80004a7a:	f05a                	sd	s6,32(sp)
    80004a7c:	ec5e                	sd	s7,24(sp)
    80004a7e:	e862                	sd	s8,16(sp)
    80004a80:	a829                	j	80004a9a <piperead+0x76>
    80004a82:	f05a                	sd	s6,32(sp)
    80004a84:	ec5e                	sd	s7,24(sp)
    80004a86:	e862                	sd	s8,16(sp)
    80004a88:	a809                	j	80004a9a <piperead+0x76>
      release(&pi->lock);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	a06fc0ef          	jal	80000c92 <release>
      return -1;
    80004a90:	59fd                	li	s3,-1
    80004a92:	a0a5                	j	80004afa <piperead+0xd6>
    80004a94:	f05a                	sd	s6,32(sp)
    80004a96:	ec5e                	sd	s7,24(sp)
    80004a98:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a9a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a9c:	faf40c13          	addi	s8,s0,-81
    80004aa0:	4b85                	li	s7,1
    80004aa2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004aa4:	05505163          	blez	s5,80004ae6 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80004aa8:	2184a783          	lw	a5,536(s1)
    80004aac:	21c4a703          	lw	a4,540(s1)
    80004ab0:	02f70b63          	beq	a4,a5,80004ae6 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ab4:	0017871b          	addiw	a4,a5,1
    80004ab8:	20e4ac23          	sw	a4,536(s1)
    80004abc:	1ff7f793          	andi	a5,a5,511
    80004ac0:	97a6                	add	a5,a5,s1
    80004ac2:	0187c783          	lbu	a5,24(a5)
    80004ac6:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004aca:	86de                	mv	a3,s7
    80004acc:	8662                	mv	a2,s8
    80004ace:	85ca                	mv	a1,s2
    80004ad0:	050a3503          	ld	a0,80(s4)
    80004ad4:	ab1fc0ef          	jal	80001584 <copyout>
    80004ad8:	01650763          	beq	a0,s6,80004ae6 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004adc:	2985                	addiw	s3,s3,1
    80004ade:	0905                	addi	s2,s2,1
    80004ae0:	fd3a94e3          	bne	s5,s3,80004aa8 <piperead+0x84>
    80004ae4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ae6:	21c48513          	addi	a0,s1,540
    80004aea:	c0cfd0ef          	jal	80001ef6 <wakeup>
  release(&pi->lock);
    80004aee:	8526                	mv	a0,s1
    80004af0:	9a2fc0ef          	jal	80000c92 <release>
    80004af4:	7b02                	ld	s6,32(sp)
    80004af6:	6be2                	ld	s7,24(sp)
    80004af8:	6c42                	ld	s8,16(sp)
  return i;
}
    80004afa:	854e                	mv	a0,s3
    80004afc:	60e6                	ld	ra,88(sp)
    80004afe:	6446                	ld	s0,80(sp)
    80004b00:	64a6                	ld	s1,72(sp)
    80004b02:	6906                	ld	s2,64(sp)
    80004b04:	79e2                	ld	s3,56(sp)
    80004b06:	7a42                	ld	s4,48(sp)
    80004b08:	7aa2                	ld	s5,40(sp)
    80004b0a:	6125                	addi	sp,sp,96
    80004b0c:	8082                	ret

0000000080004b0e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004b0e:	1141                	addi	sp,sp,-16
    80004b10:	e406                	sd	ra,8(sp)
    80004b12:	e022                	sd	s0,0(sp)
    80004b14:	0800                	addi	s0,sp,16
    80004b16:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004b18:	0035151b          	slliw	a0,a0,0x3
    80004b1c:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004b1e:	8b89                	andi	a5,a5,2
    80004b20:	c399                	beqz	a5,80004b26 <flags2perm+0x18>
      perm |= PTE_W;
    80004b22:	00456513          	ori	a0,a0,4
    return perm;
}
    80004b26:	60a2                	ld	ra,8(sp)
    80004b28:	6402                	ld	s0,0(sp)
    80004b2a:	0141                	addi	sp,sp,16
    80004b2c:	8082                	ret

0000000080004b2e <exec>:

int
exec(char *path, char **argv)
{
    80004b2e:	de010113          	addi	sp,sp,-544
    80004b32:	20113c23          	sd	ra,536(sp)
    80004b36:	20813823          	sd	s0,528(sp)
    80004b3a:	20913423          	sd	s1,520(sp)
    80004b3e:	21213023          	sd	s2,512(sp)
    80004b42:	1400                	addi	s0,sp,544
    80004b44:	892a                	mv	s2,a0
    80004b46:	dea43823          	sd	a0,-528(s0)
    80004b4a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b4e:	d8ffc0ef          	jal	800018dc <myproc>
    80004b52:	84aa                	mv	s1,a0

  begin_op();
    80004b54:	d88ff0ef          	jal	800040dc <begin_op>

  if((ip = namei(path)) == 0){
    80004b58:	854a                	mv	a0,s2
    80004b5a:	bc0ff0ef          	jal	80003f1a <namei>
    80004b5e:	cd21                	beqz	a0,80004bb6 <exec+0x88>
    80004b60:	fbd2                	sd	s4,496(sp)
    80004b62:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b64:	945fe0ef          	jal	800034a8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b68:	04000713          	li	a4,64
    80004b6c:	4681                	li	a3,0
    80004b6e:	e5040613          	addi	a2,s0,-432
    80004b72:	4581                	li	a1,0
    80004b74:	8552                	mv	a0,s4
    80004b76:	b8bfe0ef          	jal	80003700 <readi>
    80004b7a:	04000793          	li	a5,64
    80004b7e:	00f51a63          	bne	a0,a5,80004b92 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004b82:	e5042703          	lw	a4,-432(s0)
    80004b86:	464c47b7          	lui	a5,0x464c4
    80004b8a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b8e:	02f70863          	beq	a4,a5,80004bbe <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b92:	8552                	mv	a0,s4
    80004b94:	b1ffe0ef          	jal	800036b2 <iunlockput>
    end_op();
    80004b98:	daeff0ef          	jal	80004146 <end_op>
  }
  return -1;
    80004b9c:	557d                	li	a0,-1
    80004b9e:	7a5e                	ld	s4,496(sp)
}
    80004ba0:	21813083          	ld	ra,536(sp)
    80004ba4:	21013403          	ld	s0,528(sp)
    80004ba8:	20813483          	ld	s1,520(sp)
    80004bac:	20013903          	ld	s2,512(sp)
    80004bb0:	22010113          	addi	sp,sp,544
    80004bb4:	8082                	ret
    end_op();
    80004bb6:	d90ff0ef          	jal	80004146 <end_op>
    return -1;
    80004bba:	557d                	li	a0,-1
    80004bbc:	b7d5                	j	80004ba0 <exec+0x72>
    80004bbe:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	dc3fc0ef          	jal	80001984 <proc_pagetable>
    80004bc6:	8b2a                	mv	s6,a0
    80004bc8:	26050d63          	beqz	a0,80004e42 <exec+0x314>
    80004bcc:	ffce                	sd	s3,504(sp)
    80004bce:	f7d6                	sd	s5,488(sp)
    80004bd0:	efde                	sd	s7,472(sp)
    80004bd2:	ebe2                	sd	s8,464(sp)
    80004bd4:	e7e6                	sd	s9,456(sp)
    80004bd6:	e3ea                	sd	s10,448(sp)
    80004bd8:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bda:	e7042683          	lw	a3,-400(s0)
    80004bde:	e8845783          	lhu	a5,-376(s0)
    80004be2:	0e078763          	beqz	a5,80004cd0 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004be6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004be8:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004bea:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80004bee:	6c85                	lui	s9,0x1
    80004bf0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004bf4:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004bf8:	6a85                	lui	s5,0x1
    80004bfa:	a085                	j	80004c5a <exec+0x12c>
      panic("loadseg: address should exist");
    80004bfc:	00004517          	auipc	a0,0x4
    80004c00:	b3c50513          	addi	a0,a0,-1220 # 80008738 <etext+0x738>
    80004c04:	b9bfb0ef          	jal	8000079e <panic>
    if(sz - i < PGSIZE)
    80004c08:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c0a:	874a                	mv	a4,s2
    80004c0c:	009c06bb          	addw	a3,s8,s1
    80004c10:	4581                	li	a1,0
    80004c12:	8552                	mv	a0,s4
    80004c14:	aedfe0ef          	jal	80003700 <readi>
    80004c18:	22a91963          	bne	s2,a0,80004e4a <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80004c1c:	009a84bb          	addw	s1,s5,s1
    80004c20:	0334f263          	bgeu	s1,s3,80004c44 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004c24:	02049593          	slli	a1,s1,0x20
    80004c28:	9181                	srli	a1,a1,0x20
    80004c2a:	95de                	add	a1,a1,s7
    80004c2c:	855a                	mv	a0,s6
    80004c2e:	bcefc0ef          	jal	80000ffc <walkaddr>
    80004c32:	862a                	mv	a2,a0
    if(pa == 0)
    80004c34:	d561                	beqz	a0,80004bfc <exec+0xce>
    if(sz - i < PGSIZE)
    80004c36:	409987bb          	subw	a5,s3,s1
    80004c3a:	893e                	mv	s2,a5
    80004c3c:	fcfcf6e3          	bgeu	s9,a5,80004c08 <exec+0xda>
    80004c40:	8956                	mv	s2,s5
    80004c42:	b7d9                	j	80004c08 <exec+0xda>
    sz = sz1;
    80004c44:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c48:	2d05                	addiw	s10,s10,1
    80004c4a:	e0843783          	ld	a5,-504(s0)
    80004c4e:	0387869b          	addiw	a3,a5,56
    80004c52:	e8845783          	lhu	a5,-376(s0)
    80004c56:	06fd5e63          	bge	s10,a5,80004cd2 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c5a:	e0d43423          	sd	a3,-504(s0)
    80004c5e:	876e                	mv	a4,s11
    80004c60:	e1840613          	addi	a2,s0,-488
    80004c64:	4581                	li	a1,0
    80004c66:	8552                	mv	a0,s4
    80004c68:	a99fe0ef          	jal	80003700 <readi>
    80004c6c:	1db51d63          	bne	a0,s11,80004e46 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80004c70:	e1842783          	lw	a5,-488(s0)
    80004c74:	4705                	li	a4,1
    80004c76:	fce799e3          	bne	a5,a4,80004c48 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80004c7a:	e4043483          	ld	s1,-448(s0)
    80004c7e:	e3843783          	ld	a5,-456(s0)
    80004c82:	1ef4e263          	bltu	s1,a5,80004e66 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004c86:	e2843783          	ld	a5,-472(s0)
    80004c8a:	94be                	add	s1,s1,a5
    80004c8c:	1ef4e063          	bltu	s1,a5,80004e6c <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80004c90:	de843703          	ld	a4,-536(s0)
    80004c94:	8ff9                	and	a5,a5,a4
    80004c96:	1c079e63          	bnez	a5,80004e72 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004c9a:	e1c42503          	lw	a0,-484(s0)
    80004c9e:	e71ff0ef          	jal	80004b0e <flags2perm>
    80004ca2:	86aa                	mv	a3,a0
    80004ca4:	8626                	mv	a2,s1
    80004ca6:	85ca                	mv	a1,s2
    80004ca8:	855a                	mv	a0,s6
    80004caa:	ebafc0ef          	jal	80001364 <uvmalloc>
    80004cae:	dea43c23          	sd	a0,-520(s0)
    80004cb2:	1c050363          	beqz	a0,80004e78 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004cb6:	e2843b83          	ld	s7,-472(s0)
    80004cba:	e2042c03          	lw	s8,-480(s0)
    80004cbe:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004cc2:	00098463          	beqz	s3,80004cca <exec+0x19c>
    80004cc6:	4481                	li	s1,0
    80004cc8:	bfb1                	j	80004c24 <exec+0xf6>
    sz = sz1;
    80004cca:	df843903          	ld	s2,-520(s0)
    80004cce:	bfad                	j	80004c48 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004cd0:	4901                	li	s2,0
  iunlockput(ip);
    80004cd2:	8552                	mv	a0,s4
    80004cd4:	9dffe0ef          	jal	800036b2 <iunlockput>
  end_op();
    80004cd8:	c6eff0ef          	jal	80004146 <end_op>
  p = myproc();
    80004cdc:	c01fc0ef          	jal	800018dc <myproc>
    80004ce0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004ce2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004ce6:	6985                	lui	s3,0x1
    80004ce8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004cea:	99ca                	add	s3,s3,s2
    80004cec:	77fd                	lui	a5,0xfffff
    80004cee:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004cf2:	4691                	li	a3,4
    80004cf4:	6609                	lui	a2,0x2
    80004cf6:	964e                	add	a2,a2,s3
    80004cf8:	85ce                	mv	a1,s3
    80004cfa:	855a                	mv	a0,s6
    80004cfc:	e68fc0ef          	jal	80001364 <uvmalloc>
    80004d00:	8a2a                	mv	s4,a0
    80004d02:	e105                	bnez	a0,80004d22 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80004d04:	85ce                	mv	a1,s3
    80004d06:	855a                	mv	a0,s6
    80004d08:	d01fc0ef          	jal	80001a08 <proc_freepagetable>
  return -1;
    80004d0c:	557d                	li	a0,-1
    80004d0e:	79fe                	ld	s3,504(sp)
    80004d10:	7a5e                	ld	s4,496(sp)
    80004d12:	7abe                	ld	s5,488(sp)
    80004d14:	7b1e                	ld	s6,480(sp)
    80004d16:	6bfe                	ld	s7,472(sp)
    80004d18:	6c5e                	ld	s8,464(sp)
    80004d1a:	6cbe                	ld	s9,456(sp)
    80004d1c:	6d1e                	ld	s10,448(sp)
    80004d1e:	7dfa                	ld	s11,440(sp)
    80004d20:	b541                	j	80004ba0 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004d22:	75f9                	lui	a1,0xffffe
    80004d24:	95aa                	add	a1,a1,a0
    80004d26:	855a                	mv	a0,s6
    80004d28:	833fc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004d2c:	7bfd                	lui	s7,0xfffff
    80004d2e:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80004d30:	e0043783          	ld	a5,-512(s0)
    80004d34:	6388                	ld	a0,0(a5)
  sp = sz;
    80004d36:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004d38:	4481                	li	s1,0
    ustack[argc] = sp;
    80004d3a:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004d3e:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004d42:	cd21                	beqz	a0,80004d9a <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80004d44:	912fc0ef          	jal	80000e56 <strlen>
    80004d48:	0015079b          	addiw	a5,a0,1
    80004d4c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004d50:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004d54:	13796563          	bltu	s2,s7,80004e7e <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004d58:	e0043d83          	ld	s11,-512(s0)
    80004d5c:	000db983          	ld	s3,0(s11)
    80004d60:	854e                	mv	a0,s3
    80004d62:	8f4fc0ef          	jal	80000e56 <strlen>
    80004d66:	0015069b          	addiw	a3,a0,1
    80004d6a:	864e                	mv	a2,s3
    80004d6c:	85ca                	mv	a1,s2
    80004d6e:	855a                	mv	a0,s6
    80004d70:	815fc0ef          	jal	80001584 <copyout>
    80004d74:	10054763          	bltz	a0,80004e82 <exec+0x354>
    ustack[argc] = sp;
    80004d78:	00349793          	slli	a5,s1,0x3
    80004d7c:	97e6                	add	a5,a5,s9
    80004d7e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdade0>
  for(argc = 0; argv[argc]; argc++) {
    80004d82:	0485                	addi	s1,s1,1
    80004d84:	008d8793          	addi	a5,s11,8
    80004d88:	e0f43023          	sd	a5,-512(s0)
    80004d8c:	008db503          	ld	a0,8(s11)
    80004d90:	c509                	beqz	a0,80004d9a <exec+0x26c>
    if(argc >= MAXARG)
    80004d92:	fb8499e3          	bne	s1,s8,80004d44 <exec+0x216>
  sz = sz1;
    80004d96:	89d2                	mv	s3,s4
    80004d98:	b7b5                	j	80004d04 <exec+0x1d6>
  ustack[argc] = 0;
    80004d9a:	00349793          	slli	a5,s1,0x3
    80004d9e:	f9078793          	addi	a5,a5,-112
    80004da2:	97a2                	add	a5,a5,s0
    80004da4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004da8:	00148693          	addi	a3,s1,1
    80004dac:	068e                	slli	a3,a3,0x3
    80004dae:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004db2:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004db6:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004db8:	f57966e3          	bltu	s2,s7,80004d04 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004dbc:	e9040613          	addi	a2,s0,-368
    80004dc0:	85ca                	mv	a1,s2
    80004dc2:	855a                	mv	a0,s6
    80004dc4:	fc0fc0ef          	jal	80001584 <copyout>
    80004dc8:	f2054ee3          	bltz	a0,80004d04 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80004dcc:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004dd0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004dd4:	df043783          	ld	a5,-528(s0)
    80004dd8:	0007c703          	lbu	a4,0(a5)
    80004ddc:	cf11                	beqz	a4,80004df8 <exec+0x2ca>
    80004dde:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004de0:	02f00693          	li	a3,47
    80004de4:	a029                	j	80004dee <exec+0x2c0>
  for(last=s=path; *s; s++)
    80004de6:	0785                	addi	a5,a5,1
    80004de8:	fff7c703          	lbu	a4,-1(a5)
    80004dec:	c711                	beqz	a4,80004df8 <exec+0x2ca>
    if(*s == '/')
    80004dee:	fed71ce3          	bne	a4,a3,80004de6 <exec+0x2b8>
      last = s+1;
    80004df2:	def43823          	sd	a5,-528(s0)
    80004df6:	bfc5                	j	80004de6 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80004df8:	4641                	li	a2,16
    80004dfa:	df043583          	ld	a1,-528(s0)
    80004dfe:	158a8513          	addi	a0,s5,344
    80004e02:	81efc0ef          	jal	80000e20 <safestrcpy>
  oldpagetable = p->pagetable;
    80004e06:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004e0a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004e0e:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004e12:	058ab783          	ld	a5,88(s5)
    80004e16:	e6843703          	ld	a4,-408(s0)
    80004e1a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004e1c:	058ab783          	ld	a5,88(s5)
    80004e20:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004e24:	85ea                	mv	a1,s10
    80004e26:	be3fc0ef          	jal	80001a08 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e2a:	0004851b          	sext.w	a0,s1
    80004e2e:	79fe                	ld	s3,504(sp)
    80004e30:	7a5e                	ld	s4,496(sp)
    80004e32:	7abe                	ld	s5,488(sp)
    80004e34:	7b1e                	ld	s6,480(sp)
    80004e36:	6bfe                	ld	s7,472(sp)
    80004e38:	6c5e                	ld	s8,464(sp)
    80004e3a:	6cbe                	ld	s9,456(sp)
    80004e3c:	6d1e                	ld	s10,448(sp)
    80004e3e:	7dfa                	ld	s11,440(sp)
    80004e40:	b385                	j	80004ba0 <exec+0x72>
    80004e42:	7b1e                	ld	s6,480(sp)
    80004e44:	b3b9                	j	80004b92 <exec+0x64>
    80004e46:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004e4a:	df843583          	ld	a1,-520(s0)
    80004e4e:	855a                	mv	a0,s6
    80004e50:	bb9fc0ef          	jal	80001a08 <proc_freepagetable>
  if(ip){
    80004e54:	79fe                	ld	s3,504(sp)
    80004e56:	7abe                	ld	s5,488(sp)
    80004e58:	7b1e                	ld	s6,480(sp)
    80004e5a:	6bfe                	ld	s7,472(sp)
    80004e5c:	6c5e                	ld	s8,464(sp)
    80004e5e:	6cbe                	ld	s9,456(sp)
    80004e60:	6d1e                	ld	s10,448(sp)
    80004e62:	7dfa                	ld	s11,440(sp)
    80004e64:	b33d                	j	80004b92 <exec+0x64>
    80004e66:	df243c23          	sd	s2,-520(s0)
    80004e6a:	b7c5                	j	80004e4a <exec+0x31c>
    80004e6c:	df243c23          	sd	s2,-520(s0)
    80004e70:	bfe9                	j	80004e4a <exec+0x31c>
    80004e72:	df243c23          	sd	s2,-520(s0)
    80004e76:	bfd1                	j	80004e4a <exec+0x31c>
    80004e78:	df243c23          	sd	s2,-520(s0)
    80004e7c:	b7f9                	j	80004e4a <exec+0x31c>
  sz = sz1;
    80004e7e:	89d2                	mv	s3,s4
    80004e80:	b551                	j	80004d04 <exec+0x1d6>
    80004e82:	89d2                	mv	s3,s4
    80004e84:	b541                	j	80004d04 <exec+0x1d6>

0000000080004e86 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e86:	7179                	addi	sp,sp,-48
    80004e88:	f406                	sd	ra,40(sp)
    80004e8a:	f022                	sd	s0,32(sp)
    80004e8c:	ec26                	sd	s1,24(sp)
    80004e8e:	e84a                	sd	s2,16(sp)
    80004e90:	1800                	addi	s0,sp,48
    80004e92:	892e                	mv	s2,a1
    80004e94:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004e96:	fdc40593          	addi	a1,s0,-36
    80004e9a:	95bfd0ef          	jal	800027f4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004e9e:	fdc42703          	lw	a4,-36(s0)
    80004ea2:	47bd                	li	a5,15
    80004ea4:	02e7e963          	bltu	a5,a4,80004ed6 <argfd+0x50>
    80004ea8:	a35fc0ef          	jal	800018dc <myproc>
    80004eac:	fdc42703          	lw	a4,-36(s0)
    80004eb0:	01a70793          	addi	a5,a4,26
    80004eb4:	078e                	slli	a5,a5,0x3
    80004eb6:	953e                	add	a0,a0,a5
    80004eb8:	611c                	ld	a5,0(a0)
    80004eba:	c385                	beqz	a5,80004eda <argfd+0x54>
    return -1;
  if(pfd)
    80004ebc:	00090463          	beqz	s2,80004ec4 <argfd+0x3e>
    *pfd = fd;
    80004ec0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004ec4:	4501                	li	a0,0
  if(pf)
    80004ec6:	c091                	beqz	s1,80004eca <argfd+0x44>
    *pf = f;
    80004ec8:	e09c                	sd	a5,0(s1)
}
    80004eca:	70a2                	ld	ra,40(sp)
    80004ecc:	7402                	ld	s0,32(sp)
    80004ece:	64e2                	ld	s1,24(sp)
    80004ed0:	6942                	ld	s2,16(sp)
    80004ed2:	6145                	addi	sp,sp,48
    80004ed4:	8082                	ret
    return -1;
    80004ed6:	557d                	li	a0,-1
    80004ed8:	bfcd                	j	80004eca <argfd+0x44>
    80004eda:	557d                	li	a0,-1
    80004edc:	b7fd                	j	80004eca <argfd+0x44>

0000000080004ede <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ede:	1101                	addi	sp,sp,-32
    80004ee0:	ec06                	sd	ra,24(sp)
    80004ee2:	e822                	sd	s0,16(sp)
    80004ee4:	e426                	sd	s1,8(sp)
    80004ee6:	1000                	addi	s0,sp,32
    80004ee8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004eea:	9f3fc0ef          	jal	800018dc <myproc>
    80004eee:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ef0:	0d050793          	addi	a5,a0,208
    80004ef4:	4501                	li	a0,0
    80004ef6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004ef8:	6398                	ld	a4,0(a5)
    80004efa:	cb19                	beqz	a4,80004f10 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004efc:	2505                	addiw	a0,a0,1
    80004efe:	07a1                	addi	a5,a5,8
    80004f00:	fed51ce3          	bne	a0,a3,80004ef8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f04:	557d                	li	a0,-1
}
    80004f06:	60e2                	ld	ra,24(sp)
    80004f08:	6442                	ld	s0,16(sp)
    80004f0a:	64a2                	ld	s1,8(sp)
    80004f0c:	6105                	addi	sp,sp,32
    80004f0e:	8082                	ret
      p->ofile[fd] = f;
    80004f10:	01a50793          	addi	a5,a0,26
    80004f14:	078e                	slli	a5,a5,0x3
    80004f16:	963e                	add	a2,a2,a5
    80004f18:	e204                	sd	s1,0(a2)
      return fd;
    80004f1a:	b7f5                	j	80004f06 <fdalloc+0x28>

0000000080004f1c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f1c:	715d                	addi	sp,sp,-80
    80004f1e:	e486                	sd	ra,72(sp)
    80004f20:	e0a2                	sd	s0,64(sp)
    80004f22:	fc26                	sd	s1,56(sp)
    80004f24:	f84a                	sd	s2,48(sp)
    80004f26:	f44e                	sd	s3,40(sp)
    80004f28:	ec56                	sd	s5,24(sp)
    80004f2a:	e85a                	sd	s6,16(sp)
    80004f2c:	0880                	addi	s0,sp,80
    80004f2e:	8b2e                	mv	s6,a1
    80004f30:	89b2                	mv	s3,a2
    80004f32:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f34:	fb040593          	addi	a1,s0,-80
    80004f38:	ffdfe0ef          	jal	80003f34 <nameiparent>
    80004f3c:	84aa                	mv	s1,a0
    80004f3e:	10050a63          	beqz	a0,80005052 <create+0x136>
    return 0;

  ilock(dp);
    80004f42:	d66fe0ef          	jal	800034a8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f46:	4601                	li	a2,0
    80004f48:	fb040593          	addi	a1,s0,-80
    80004f4c:	8526                	mv	a0,s1
    80004f4e:	d41fe0ef          	jal	80003c8e <dirlookup>
    80004f52:	8aaa                	mv	s5,a0
    80004f54:	c129                	beqz	a0,80004f96 <create+0x7a>
    iunlockput(dp);
    80004f56:	8526                	mv	a0,s1
    80004f58:	f5afe0ef          	jal	800036b2 <iunlockput>
    ilock(ip);
    80004f5c:	8556                	mv	a0,s5
    80004f5e:	d4afe0ef          	jal	800034a8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f62:	4789                	li	a5,2
    80004f64:	02fb1463          	bne	s6,a5,80004f8c <create+0x70>
    80004f68:	044ad783          	lhu	a5,68(s5)
    80004f6c:	37f9                	addiw	a5,a5,-2
    80004f6e:	17c2                	slli	a5,a5,0x30
    80004f70:	93c1                	srli	a5,a5,0x30
    80004f72:	4705                	li	a4,1
    80004f74:	00f76c63          	bltu	a4,a5,80004f8c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004f78:	8556                	mv	a0,s5
    80004f7a:	60a6                	ld	ra,72(sp)
    80004f7c:	6406                	ld	s0,64(sp)
    80004f7e:	74e2                	ld	s1,56(sp)
    80004f80:	7942                	ld	s2,48(sp)
    80004f82:	79a2                	ld	s3,40(sp)
    80004f84:	6ae2                	ld	s5,24(sp)
    80004f86:	6b42                	ld	s6,16(sp)
    80004f88:	6161                	addi	sp,sp,80
    80004f8a:	8082                	ret
    iunlockput(ip);
    80004f8c:	8556                	mv	a0,s5
    80004f8e:	f24fe0ef          	jal	800036b2 <iunlockput>
    return 0;
    80004f92:	4a81                	li	s5,0
    80004f94:	b7d5                	j	80004f78 <create+0x5c>
    80004f96:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004f98:	85da                	mv	a1,s6
    80004f9a:	4088                	lw	a0,0(s1)
    80004f9c:	b9cfe0ef          	jal	80003338 <ialloc>
    80004fa0:	8a2a                	mv	s4,a0
    80004fa2:	cd15                	beqz	a0,80004fde <create+0xc2>
  ilock(ip);
    80004fa4:	d04fe0ef          	jal	800034a8 <ilock>
  ip->major = major;
    80004fa8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004fac:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004fb0:	4905                	li	s2,1
    80004fb2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004fb6:	8552                	mv	a0,s4
    80004fb8:	c3cfe0ef          	jal	800033f4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004fbc:	032b0763          	beq	s6,s2,80004fea <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004fc0:	004a2603          	lw	a2,4(s4)
    80004fc4:	fb040593          	addi	a1,s0,-80
    80004fc8:	8526                	mv	a0,s1
    80004fca:	ea7fe0ef          	jal	80003e70 <dirlink>
    80004fce:	06054563          	bltz	a0,80005038 <create+0x11c>
  iunlockput(dp);
    80004fd2:	8526                	mv	a0,s1
    80004fd4:	edefe0ef          	jal	800036b2 <iunlockput>
  return ip;
    80004fd8:	8ad2                	mv	s5,s4
    80004fda:	7a02                	ld	s4,32(sp)
    80004fdc:	bf71                	j	80004f78 <create+0x5c>
    iunlockput(dp);
    80004fde:	8526                	mv	a0,s1
    80004fe0:	ed2fe0ef          	jal	800036b2 <iunlockput>
    return 0;
    80004fe4:	8ad2                	mv	s5,s4
    80004fe6:	7a02                	ld	s4,32(sp)
    80004fe8:	bf41                	j	80004f78 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004fea:	004a2603          	lw	a2,4(s4)
    80004fee:	00003597          	auipc	a1,0x3
    80004ff2:	76a58593          	addi	a1,a1,1898 # 80008758 <etext+0x758>
    80004ff6:	8552                	mv	a0,s4
    80004ff8:	e79fe0ef          	jal	80003e70 <dirlink>
    80004ffc:	02054e63          	bltz	a0,80005038 <create+0x11c>
    80005000:	40d0                	lw	a2,4(s1)
    80005002:	00003597          	auipc	a1,0x3
    80005006:	75e58593          	addi	a1,a1,1886 # 80008760 <etext+0x760>
    8000500a:	8552                	mv	a0,s4
    8000500c:	e65fe0ef          	jal	80003e70 <dirlink>
    80005010:	02054463          	bltz	a0,80005038 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005014:	004a2603          	lw	a2,4(s4)
    80005018:	fb040593          	addi	a1,s0,-80
    8000501c:	8526                	mv	a0,s1
    8000501e:	e53fe0ef          	jal	80003e70 <dirlink>
    80005022:	00054b63          	bltz	a0,80005038 <create+0x11c>
    dp->nlink++;  // for ".."
    80005026:	04a4d783          	lhu	a5,74(s1)
    8000502a:	2785                	addiw	a5,a5,1
    8000502c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005030:	8526                	mv	a0,s1
    80005032:	bc2fe0ef          	jal	800033f4 <iupdate>
    80005036:	bf71                	j	80004fd2 <create+0xb6>
  ip->nlink = 0;
    80005038:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000503c:	8552                	mv	a0,s4
    8000503e:	bb6fe0ef          	jal	800033f4 <iupdate>
  iunlockput(ip);
    80005042:	8552                	mv	a0,s4
    80005044:	e6efe0ef          	jal	800036b2 <iunlockput>
  iunlockput(dp);
    80005048:	8526                	mv	a0,s1
    8000504a:	e68fe0ef          	jal	800036b2 <iunlockput>
  return 0;
    8000504e:	7a02                	ld	s4,32(sp)
    80005050:	b725                	j	80004f78 <create+0x5c>
    return 0;
    80005052:	8aaa                	mv	s5,a0
    80005054:	b715                	j	80004f78 <create+0x5c>

0000000080005056 <sys_dup>:
{
    80005056:	7179                	addi	sp,sp,-48
    80005058:	f406                	sd	ra,40(sp)
    8000505a:	f022                	sd	s0,32(sp)
    8000505c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000505e:	fd840613          	addi	a2,s0,-40
    80005062:	4581                	li	a1,0
    80005064:	4501                	li	a0,0
    80005066:	e21ff0ef          	jal	80004e86 <argfd>
    return -1;
    8000506a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000506c:	02054363          	bltz	a0,80005092 <sys_dup+0x3c>
    80005070:	ec26                	sd	s1,24(sp)
    80005072:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005074:	fd843903          	ld	s2,-40(s0)
    80005078:	854a                	mv	a0,s2
    8000507a:	e65ff0ef          	jal	80004ede <fdalloc>
    8000507e:	84aa                	mv	s1,a0
    return -1;
    80005080:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005082:	00054d63          	bltz	a0,8000509c <sys_dup+0x46>
  filedup(f);
    80005086:	854a                	mv	a0,s2
    80005088:	c2eff0ef          	jal	800044b6 <filedup>
  return fd;
    8000508c:	87a6                	mv	a5,s1
    8000508e:	64e2                	ld	s1,24(sp)
    80005090:	6942                	ld	s2,16(sp)
}
    80005092:	853e                	mv	a0,a5
    80005094:	70a2                	ld	ra,40(sp)
    80005096:	7402                	ld	s0,32(sp)
    80005098:	6145                	addi	sp,sp,48
    8000509a:	8082                	ret
    8000509c:	64e2                	ld	s1,24(sp)
    8000509e:	6942                	ld	s2,16(sp)
    800050a0:	bfcd                	j	80005092 <sys_dup+0x3c>

00000000800050a2 <sys_read>:
{
    800050a2:	7179                	addi	sp,sp,-48
    800050a4:	f406                	sd	ra,40(sp)
    800050a6:	f022                	sd	s0,32(sp)
    800050a8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800050aa:	fd840593          	addi	a1,s0,-40
    800050ae:	4505                	li	a0,1
    800050b0:	f60fd0ef          	jal	80002810 <argaddr>
  argint(2, &n);
    800050b4:	fe440593          	addi	a1,s0,-28
    800050b8:	4509                	li	a0,2
    800050ba:	f3afd0ef          	jal	800027f4 <argint>
  if(argfd(0, 0, &f) < 0)
    800050be:	fe840613          	addi	a2,s0,-24
    800050c2:	4581                	li	a1,0
    800050c4:	4501                	li	a0,0
    800050c6:	dc1ff0ef          	jal	80004e86 <argfd>
    800050ca:	87aa                	mv	a5,a0
    return -1;
    800050cc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800050ce:	0007ca63          	bltz	a5,800050e2 <sys_read+0x40>
  return fileread(f, p, n);
    800050d2:	fe442603          	lw	a2,-28(s0)
    800050d6:	fd843583          	ld	a1,-40(s0)
    800050da:	fe843503          	ld	a0,-24(s0)
    800050de:	d3eff0ef          	jal	8000461c <fileread>
}
    800050e2:	70a2                	ld	ra,40(sp)
    800050e4:	7402                	ld	s0,32(sp)
    800050e6:	6145                	addi	sp,sp,48
    800050e8:	8082                	ret

00000000800050ea <sys_write>:
{
    800050ea:	7179                	addi	sp,sp,-48
    800050ec:	f406                	sd	ra,40(sp)
    800050ee:	f022                	sd	s0,32(sp)
    800050f0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800050f2:	fd840593          	addi	a1,s0,-40
    800050f6:	4505                	li	a0,1
    800050f8:	f18fd0ef          	jal	80002810 <argaddr>
  argint(2, &n);
    800050fc:	fe440593          	addi	a1,s0,-28
    80005100:	4509                	li	a0,2
    80005102:	ef2fd0ef          	jal	800027f4 <argint>
  if(argfd(0, 0, &f) < 0)
    80005106:	fe840613          	addi	a2,s0,-24
    8000510a:	4581                	li	a1,0
    8000510c:	4501                	li	a0,0
    8000510e:	d79ff0ef          	jal	80004e86 <argfd>
    80005112:	87aa                	mv	a5,a0
    return -1;
    80005114:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005116:	0007ca63          	bltz	a5,8000512a <sys_write+0x40>
  return filewrite(f, p, n);
    8000511a:	fe442603          	lw	a2,-28(s0)
    8000511e:	fd843583          	ld	a1,-40(s0)
    80005122:	fe843503          	ld	a0,-24(s0)
    80005126:	db4ff0ef          	jal	800046da <filewrite>
}
    8000512a:	70a2                	ld	ra,40(sp)
    8000512c:	7402                	ld	s0,32(sp)
    8000512e:	6145                	addi	sp,sp,48
    80005130:	8082                	ret

0000000080005132 <sys_close>:
{
    80005132:	1101                	addi	sp,sp,-32
    80005134:	ec06                	sd	ra,24(sp)
    80005136:	e822                	sd	s0,16(sp)
    80005138:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000513a:	fe040613          	addi	a2,s0,-32
    8000513e:	fec40593          	addi	a1,s0,-20
    80005142:	4501                	li	a0,0
    80005144:	d43ff0ef          	jal	80004e86 <argfd>
    return -1;
    80005148:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000514a:	02054063          	bltz	a0,8000516a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000514e:	f8efc0ef          	jal	800018dc <myproc>
    80005152:	fec42783          	lw	a5,-20(s0)
    80005156:	07e9                	addi	a5,a5,26
    80005158:	078e                	slli	a5,a5,0x3
    8000515a:	953e                	add	a0,a0,a5
    8000515c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005160:	fe043503          	ld	a0,-32(s0)
    80005164:	b98ff0ef          	jal	800044fc <fileclose>
  return 0;
    80005168:	4781                	li	a5,0
}
    8000516a:	853e                	mv	a0,a5
    8000516c:	60e2                	ld	ra,24(sp)
    8000516e:	6442                	ld	s0,16(sp)
    80005170:	6105                	addi	sp,sp,32
    80005172:	8082                	ret

0000000080005174 <sys_fstat>:
{
    80005174:	1101                	addi	sp,sp,-32
    80005176:	ec06                	sd	ra,24(sp)
    80005178:	e822                	sd	s0,16(sp)
    8000517a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000517c:	fe040593          	addi	a1,s0,-32
    80005180:	4505                	li	a0,1
    80005182:	e8efd0ef          	jal	80002810 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005186:	fe840613          	addi	a2,s0,-24
    8000518a:	4581                	li	a1,0
    8000518c:	4501                	li	a0,0
    8000518e:	cf9ff0ef          	jal	80004e86 <argfd>
    80005192:	87aa                	mv	a5,a0
    return -1;
    80005194:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005196:	0007c863          	bltz	a5,800051a6 <sys_fstat+0x32>
  return filestat(f, st);
    8000519a:	fe043583          	ld	a1,-32(s0)
    8000519e:	fe843503          	ld	a0,-24(s0)
    800051a2:	c18ff0ef          	jal	800045ba <filestat>
}
    800051a6:	60e2                	ld	ra,24(sp)
    800051a8:	6442                	ld	s0,16(sp)
    800051aa:	6105                	addi	sp,sp,32
    800051ac:	8082                	ret

00000000800051ae <sys_link>:
{
    800051ae:	7169                	addi	sp,sp,-304
    800051b0:	f606                	sd	ra,296(sp)
    800051b2:	f222                	sd	s0,288(sp)
    800051b4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800051b6:	08000613          	li	a2,128
    800051ba:	ed040593          	addi	a1,s0,-304
    800051be:	4501                	li	a0,0
    800051c0:	e6cfd0ef          	jal	8000282c <argstr>
    return -1;
    800051c4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800051c6:	0c054e63          	bltz	a0,800052a2 <sys_link+0xf4>
    800051ca:	08000613          	li	a2,128
    800051ce:	f5040593          	addi	a1,s0,-176
    800051d2:	4505                	li	a0,1
    800051d4:	e58fd0ef          	jal	8000282c <argstr>
    return -1;
    800051d8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800051da:	0c054463          	bltz	a0,800052a2 <sys_link+0xf4>
    800051de:	ee26                	sd	s1,280(sp)
  begin_op();
    800051e0:	efdfe0ef          	jal	800040dc <begin_op>
  if((ip = namei(old)) == 0){
    800051e4:	ed040513          	addi	a0,s0,-304
    800051e8:	d33fe0ef          	jal	80003f1a <namei>
    800051ec:	84aa                	mv	s1,a0
    800051ee:	c53d                	beqz	a0,8000525c <sys_link+0xae>
  ilock(ip);
    800051f0:	ab8fe0ef          	jal	800034a8 <ilock>
  if(ip->type == T_DIR){
    800051f4:	04449703          	lh	a4,68(s1)
    800051f8:	4785                	li	a5,1
    800051fa:	06f70663          	beq	a4,a5,80005266 <sys_link+0xb8>
    800051fe:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005200:	04a4d783          	lhu	a5,74(s1)
    80005204:	2785                	addiw	a5,a5,1
    80005206:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000520a:	8526                	mv	a0,s1
    8000520c:	9e8fe0ef          	jal	800033f4 <iupdate>
  iunlock(ip);
    80005210:	8526                	mv	a0,s1
    80005212:	b44fe0ef          	jal	80003556 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005216:	fd040593          	addi	a1,s0,-48
    8000521a:	f5040513          	addi	a0,s0,-176
    8000521e:	d17fe0ef          	jal	80003f34 <nameiparent>
    80005222:	892a                	mv	s2,a0
    80005224:	cd21                	beqz	a0,8000527c <sys_link+0xce>
  ilock(dp);
    80005226:	a82fe0ef          	jal	800034a8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000522a:	00092703          	lw	a4,0(s2)
    8000522e:	409c                	lw	a5,0(s1)
    80005230:	04f71363          	bne	a4,a5,80005276 <sys_link+0xc8>
    80005234:	40d0                	lw	a2,4(s1)
    80005236:	fd040593          	addi	a1,s0,-48
    8000523a:	854a                	mv	a0,s2
    8000523c:	c35fe0ef          	jal	80003e70 <dirlink>
    80005240:	02054b63          	bltz	a0,80005276 <sys_link+0xc8>
  iunlockput(dp);
    80005244:	854a                	mv	a0,s2
    80005246:	c6cfe0ef          	jal	800036b2 <iunlockput>
  iput(ip);
    8000524a:	8526                	mv	a0,s1
    8000524c:	bdefe0ef          	jal	8000362a <iput>
  end_op();
    80005250:	ef7fe0ef          	jal	80004146 <end_op>
  return 0;
    80005254:	4781                	li	a5,0
    80005256:	64f2                	ld	s1,280(sp)
    80005258:	6952                	ld	s2,272(sp)
    8000525a:	a0a1                	j	800052a2 <sys_link+0xf4>
    end_op();
    8000525c:	eebfe0ef          	jal	80004146 <end_op>
    return -1;
    80005260:	57fd                	li	a5,-1
    80005262:	64f2                	ld	s1,280(sp)
    80005264:	a83d                	j	800052a2 <sys_link+0xf4>
    iunlockput(ip);
    80005266:	8526                	mv	a0,s1
    80005268:	c4afe0ef          	jal	800036b2 <iunlockput>
    end_op();
    8000526c:	edbfe0ef          	jal	80004146 <end_op>
    return -1;
    80005270:	57fd                	li	a5,-1
    80005272:	64f2                	ld	s1,280(sp)
    80005274:	a03d                	j	800052a2 <sys_link+0xf4>
    iunlockput(dp);
    80005276:	854a                	mv	a0,s2
    80005278:	c3afe0ef          	jal	800036b2 <iunlockput>
  ilock(ip);
    8000527c:	8526                	mv	a0,s1
    8000527e:	a2afe0ef          	jal	800034a8 <ilock>
  ip->nlink--;
    80005282:	04a4d783          	lhu	a5,74(s1)
    80005286:	37fd                	addiw	a5,a5,-1
    80005288:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000528c:	8526                	mv	a0,s1
    8000528e:	966fe0ef          	jal	800033f4 <iupdate>
  iunlockput(ip);
    80005292:	8526                	mv	a0,s1
    80005294:	c1efe0ef          	jal	800036b2 <iunlockput>
  end_op();
    80005298:	eaffe0ef          	jal	80004146 <end_op>
  return -1;
    8000529c:	57fd                	li	a5,-1
    8000529e:	64f2                	ld	s1,280(sp)
    800052a0:	6952                	ld	s2,272(sp)
}
    800052a2:	853e                	mv	a0,a5
    800052a4:	70b2                	ld	ra,296(sp)
    800052a6:	7412                	ld	s0,288(sp)
    800052a8:	6155                	addi	sp,sp,304
    800052aa:	8082                	ret

00000000800052ac <sys_unlink>:
{
    800052ac:	7111                	addi	sp,sp,-256
    800052ae:	fd86                	sd	ra,248(sp)
    800052b0:	f9a2                	sd	s0,240(sp)
    800052b2:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800052b4:	08000613          	li	a2,128
    800052b8:	f2040593          	addi	a1,s0,-224
    800052bc:	4501                	li	a0,0
    800052be:	d6efd0ef          	jal	8000282c <argstr>
    800052c2:	16054663          	bltz	a0,8000542e <sys_unlink+0x182>
    800052c6:	f5a6                	sd	s1,232(sp)
  begin_op();
    800052c8:	e15fe0ef          	jal	800040dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800052cc:	fa040593          	addi	a1,s0,-96
    800052d0:	f2040513          	addi	a0,s0,-224
    800052d4:	c61fe0ef          	jal	80003f34 <nameiparent>
    800052d8:	84aa                	mv	s1,a0
    800052da:	c955                	beqz	a0,8000538e <sys_unlink+0xe2>
  ilock(dp);
    800052dc:	9ccfe0ef          	jal	800034a8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800052e0:	00003597          	auipc	a1,0x3
    800052e4:	47858593          	addi	a1,a1,1144 # 80008758 <etext+0x758>
    800052e8:	fa040513          	addi	a0,s0,-96
    800052ec:	98dfe0ef          	jal	80003c78 <namecmp>
    800052f0:	12050463          	beqz	a0,80005418 <sys_unlink+0x16c>
    800052f4:	00003597          	auipc	a1,0x3
    800052f8:	46c58593          	addi	a1,a1,1132 # 80008760 <etext+0x760>
    800052fc:	fa040513          	addi	a0,s0,-96
    80005300:	979fe0ef          	jal	80003c78 <namecmp>
    80005304:	10050a63          	beqz	a0,80005418 <sys_unlink+0x16c>
    80005308:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000530a:	f1c40613          	addi	a2,s0,-228
    8000530e:	fa040593          	addi	a1,s0,-96
    80005312:	8526                	mv	a0,s1
    80005314:	97bfe0ef          	jal	80003c8e <dirlookup>
    80005318:	892a                	mv	s2,a0
    8000531a:	0e050e63          	beqz	a0,80005416 <sys_unlink+0x16a>
    8000531e:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005320:	988fe0ef          	jal	800034a8 <ilock>
  if(ip->nlink < 1)
    80005324:	04a91783          	lh	a5,74(s2)
    80005328:	06f05863          	blez	a5,80005398 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000532c:	04491703          	lh	a4,68(s2)
    80005330:	4785                	li	a5,1
    80005332:	06f70b63          	beq	a4,a5,800053a8 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80005336:	fb040993          	addi	s3,s0,-80
    8000533a:	4641                	li	a2,16
    8000533c:	4581                	li	a1,0
    8000533e:	854e                	mv	a0,s3
    80005340:	98ffb0ef          	jal	80000cce <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005344:	4741                	li	a4,16
    80005346:	f1c42683          	lw	a3,-228(s0)
    8000534a:	864e                	mv	a2,s3
    8000534c:	4581                	li	a1,0
    8000534e:	8526                	mv	a0,s1
    80005350:	ebefe0ef          	jal	80003a0e <writei>
    80005354:	47c1                	li	a5,16
    80005356:	08f51f63          	bne	a0,a5,800053f4 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000535a:	04491703          	lh	a4,68(s2)
    8000535e:	4785                	li	a5,1
    80005360:	0af70263          	beq	a4,a5,80005404 <sys_unlink+0x158>
  iunlockput(dp);
    80005364:	8526                	mv	a0,s1
    80005366:	b4cfe0ef          	jal	800036b2 <iunlockput>
  ip->nlink--;
    8000536a:	04a95783          	lhu	a5,74(s2)
    8000536e:	37fd                	addiw	a5,a5,-1
    80005370:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005374:	854a                	mv	a0,s2
    80005376:	87efe0ef          	jal	800033f4 <iupdate>
  iunlockput(ip);
    8000537a:	854a                	mv	a0,s2
    8000537c:	b36fe0ef          	jal	800036b2 <iunlockput>
  end_op();
    80005380:	dc7fe0ef          	jal	80004146 <end_op>
  return 0;
    80005384:	4501                	li	a0,0
    80005386:	74ae                	ld	s1,232(sp)
    80005388:	790e                	ld	s2,224(sp)
    8000538a:	69ee                	ld	s3,216(sp)
    8000538c:	a869                	j	80005426 <sys_unlink+0x17a>
    end_op();
    8000538e:	db9fe0ef          	jal	80004146 <end_op>
    return -1;
    80005392:	557d                	li	a0,-1
    80005394:	74ae                	ld	s1,232(sp)
    80005396:	a841                	j	80005426 <sys_unlink+0x17a>
    80005398:	e9d2                	sd	s4,208(sp)
    8000539a:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000539c:	00003517          	auipc	a0,0x3
    800053a0:	3cc50513          	addi	a0,a0,972 # 80008768 <etext+0x768>
    800053a4:	bfafb0ef          	jal	8000079e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800053a8:	04c92703          	lw	a4,76(s2)
    800053ac:	02000793          	li	a5,32
    800053b0:	f8e7f3e3          	bgeu	a5,a4,80005336 <sys_unlink+0x8a>
    800053b4:	e9d2                	sd	s4,208(sp)
    800053b6:	e5d6                	sd	s5,200(sp)
    800053b8:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800053ba:	f0840a93          	addi	s5,s0,-248
    800053be:	4a41                	li	s4,16
    800053c0:	8752                	mv	a4,s4
    800053c2:	86ce                	mv	a3,s3
    800053c4:	8656                	mv	a2,s5
    800053c6:	4581                	li	a1,0
    800053c8:	854a                	mv	a0,s2
    800053ca:	b36fe0ef          	jal	80003700 <readi>
    800053ce:	01451d63          	bne	a0,s4,800053e8 <sys_unlink+0x13c>
    if(de.inum != 0)
    800053d2:	f0845783          	lhu	a5,-248(s0)
    800053d6:	efb1                	bnez	a5,80005432 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800053d8:	29c1                	addiw	s3,s3,16
    800053da:	04c92783          	lw	a5,76(s2)
    800053de:	fef9e1e3          	bltu	s3,a5,800053c0 <sys_unlink+0x114>
    800053e2:	6a4e                	ld	s4,208(sp)
    800053e4:	6aae                	ld	s5,200(sp)
    800053e6:	bf81                	j	80005336 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	39850513          	addi	a0,a0,920 # 80008780 <etext+0x780>
    800053f0:	baefb0ef          	jal	8000079e <panic>
    800053f4:	e9d2                	sd	s4,208(sp)
    800053f6:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800053f8:	00003517          	auipc	a0,0x3
    800053fc:	3a050513          	addi	a0,a0,928 # 80008798 <etext+0x798>
    80005400:	b9efb0ef          	jal	8000079e <panic>
    dp->nlink--;
    80005404:	04a4d783          	lhu	a5,74(s1)
    80005408:	37fd                	addiw	a5,a5,-1
    8000540a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000540e:	8526                	mv	a0,s1
    80005410:	fe5fd0ef          	jal	800033f4 <iupdate>
    80005414:	bf81                	j	80005364 <sys_unlink+0xb8>
    80005416:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005418:	8526                	mv	a0,s1
    8000541a:	a98fe0ef          	jal	800036b2 <iunlockput>
  end_op();
    8000541e:	d29fe0ef          	jal	80004146 <end_op>
  return -1;
    80005422:	557d                	li	a0,-1
    80005424:	74ae                	ld	s1,232(sp)
}
    80005426:	70ee                	ld	ra,248(sp)
    80005428:	744e                	ld	s0,240(sp)
    8000542a:	6111                	addi	sp,sp,256
    8000542c:	8082                	ret
    return -1;
    8000542e:	557d                	li	a0,-1
    80005430:	bfdd                	j	80005426 <sys_unlink+0x17a>
    iunlockput(ip);
    80005432:	854a                	mv	a0,s2
    80005434:	a7efe0ef          	jal	800036b2 <iunlockput>
    goto bad;
    80005438:	790e                	ld	s2,224(sp)
    8000543a:	69ee                	ld	s3,216(sp)
    8000543c:	6a4e                	ld	s4,208(sp)
    8000543e:	6aae                	ld	s5,200(sp)
    80005440:	bfe1                	j	80005418 <sys_unlink+0x16c>

0000000080005442 <sys_open>:

uint64
sys_open(void)
{
    80005442:	7131                	addi	sp,sp,-192
    80005444:	fd06                	sd	ra,184(sp)
    80005446:	f922                	sd	s0,176(sp)
    80005448:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000544a:	f4c40593          	addi	a1,s0,-180
    8000544e:	4505                	li	a0,1
    80005450:	ba4fd0ef          	jal	800027f4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005454:	08000613          	li	a2,128
    80005458:	f5040593          	addi	a1,s0,-176
    8000545c:	4501                	li	a0,0
    8000545e:	bcefd0ef          	jal	8000282c <argstr>
    80005462:	87aa                	mv	a5,a0
    return -1;
    80005464:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005466:	0a07c363          	bltz	a5,8000550c <sys_open+0xca>
    8000546a:	f526                	sd	s1,168(sp)

  begin_op();
    8000546c:	c71fe0ef          	jal	800040dc <begin_op>

  if(omode & O_CREATE){
    80005470:	f4c42783          	lw	a5,-180(s0)
    80005474:	2007f793          	andi	a5,a5,512
    80005478:	c3dd                	beqz	a5,8000551e <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000547a:	4681                	li	a3,0
    8000547c:	4601                	li	a2,0
    8000547e:	4589                	li	a1,2
    80005480:	f5040513          	addi	a0,s0,-176
    80005484:	a99ff0ef          	jal	80004f1c <create>
    80005488:	84aa                	mv	s1,a0
    if(ip == 0){
    8000548a:	c549                	beqz	a0,80005514 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000548c:	04449703          	lh	a4,68(s1)
    80005490:	478d                	li	a5,3
    80005492:	00f71763          	bne	a4,a5,800054a0 <sys_open+0x5e>
    80005496:	0464d703          	lhu	a4,70(s1)
    8000549a:	47a5                	li	a5,9
    8000549c:	0ae7ee63          	bltu	a5,a4,80005558 <sys_open+0x116>
    800054a0:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800054a2:	fb7fe0ef          	jal	80004458 <filealloc>
    800054a6:	892a                	mv	s2,a0
    800054a8:	c561                	beqz	a0,80005570 <sys_open+0x12e>
    800054aa:	ed4e                	sd	s3,152(sp)
    800054ac:	a33ff0ef          	jal	80004ede <fdalloc>
    800054b0:	89aa                	mv	s3,a0
    800054b2:	0a054b63          	bltz	a0,80005568 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800054b6:	04449703          	lh	a4,68(s1)
    800054ba:	478d                	li	a5,3
    800054bc:	0cf70363          	beq	a4,a5,80005582 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800054c0:	4789                	li	a5,2
    800054c2:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800054c6:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800054ca:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800054ce:	f4c42783          	lw	a5,-180(s0)
    800054d2:	0017f713          	andi	a4,a5,1
    800054d6:	00174713          	xori	a4,a4,1
    800054da:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800054de:	0037f713          	andi	a4,a5,3
    800054e2:	00e03733          	snez	a4,a4
    800054e6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800054ea:	4007f793          	andi	a5,a5,1024
    800054ee:	c791                	beqz	a5,800054fa <sys_open+0xb8>
    800054f0:	04449703          	lh	a4,68(s1)
    800054f4:	4789                	li	a5,2
    800054f6:	08f70d63          	beq	a4,a5,80005590 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800054fa:	8526                	mv	a0,s1
    800054fc:	85afe0ef          	jal	80003556 <iunlock>
  end_op();
    80005500:	c47fe0ef          	jal	80004146 <end_op>

  return fd;
    80005504:	854e                	mv	a0,s3
    80005506:	74aa                	ld	s1,168(sp)
    80005508:	790a                	ld	s2,160(sp)
    8000550a:	69ea                	ld	s3,152(sp)
}
    8000550c:	70ea                	ld	ra,184(sp)
    8000550e:	744a                	ld	s0,176(sp)
    80005510:	6129                	addi	sp,sp,192
    80005512:	8082                	ret
      end_op();
    80005514:	c33fe0ef          	jal	80004146 <end_op>
      return -1;
    80005518:	557d                	li	a0,-1
    8000551a:	74aa                	ld	s1,168(sp)
    8000551c:	bfc5                	j	8000550c <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000551e:	f5040513          	addi	a0,s0,-176
    80005522:	9f9fe0ef          	jal	80003f1a <namei>
    80005526:	84aa                	mv	s1,a0
    80005528:	c11d                	beqz	a0,8000554e <sys_open+0x10c>
    ilock(ip);
    8000552a:	f7ffd0ef          	jal	800034a8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000552e:	04449703          	lh	a4,68(s1)
    80005532:	4785                	li	a5,1
    80005534:	f4f71ce3          	bne	a4,a5,8000548c <sys_open+0x4a>
    80005538:	f4c42783          	lw	a5,-180(s0)
    8000553c:	d3b5                	beqz	a5,800054a0 <sys_open+0x5e>
      iunlockput(ip);
    8000553e:	8526                	mv	a0,s1
    80005540:	972fe0ef          	jal	800036b2 <iunlockput>
      end_op();
    80005544:	c03fe0ef          	jal	80004146 <end_op>
      return -1;
    80005548:	557d                	li	a0,-1
    8000554a:	74aa                	ld	s1,168(sp)
    8000554c:	b7c1                	j	8000550c <sys_open+0xca>
      end_op();
    8000554e:	bf9fe0ef          	jal	80004146 <end_op>
      return -1;
    80005552:	557d                	li	a0,-1
    80005554:	74aa                	ld	s1,168(sp)
    80005556:	bf5d                	j	8000550c <sys_open+0xca>
    iunlockput(ip);
    80005558:	8526                	mv	a0,s1
    8000555a:	958fe0ef          	jal	800036b2 <iunlockput>
    end_op();
    8000555e:	be9fe0ef          	jal	80004146 <end_op>
    return -1;
    80005562:	557d                	li	a0,-1
    80005564:	74aa                	ld	s1,168(sp)
    80005566:	b75d                	j	8000550c <sys_open+0xca>
      fileclose(f);
    80005568:	854a                	mv	a0,s2
    8000556a:	f93fe0ef          	jal	800044fc <fileclose>
    8000556e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005570:	8526                	mv	a0,s1
    80005572:	940fe0ef          	jal	800036b2 <iunlockput>
    end_op();
    80005576:	bd1fe0ef          	jal	80004146 <end_op>
    return -1;
    8000557a:	557d                	li	a0,-1
    8000557c:	74aa                	ld	s1,168(sp)
    8000557e:	790a                	ld	s2,160(sp)
    80005580:	b771                	j	8000550c <sys_open+0xca>
    f->type = FD_DEVICE;
    80005582:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005586:	04649783          	lh	a5,70(s1)
    8000558a:	02f91223          	sh	a5,36(s2)
    8000558e:	bf35                	j	800054ca <sys_open+0x88>
    itrunc(ip);
    80005590:	8526                	mv	a0,s1
    80005592:	804fe0ef          	jal	80003596 <itrunc>
    80005596:	b795                	j	800054fa <sys_open+0xb8>

0000000080005598 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005598:	7175                	addi	sp,sp,-144
    8000559a:	e506                	sd	ra,136(sp)
    8000559c:	e122                	sd	s0,128(sp)
    8000559e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800055a0:	b3dfe0ef          	jal	800040dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800055a4:	08000613          	li	a2,128
    800055a8:	f7040593          	addi	a1,s0,-144
    800055ac:	4501                	li	a0,0
    800055ae:	a7efd0ef          	jal	8000282c <argstr>
    800055b2:	02054363          	bltz	a0,800055d8 <sys_mkdir+0x40>
    800055b6:	4681                	li	a3,0
    800055b8:	4601                	li	a2,0
    800055ba:	4585                	li	a1,1
    800055bc:	f7040513          	addi	a0,s0,-144
    800055c0:	95dff0ef          	jal	80004f1c <create>
    800055c4:	c911                	beqz	a0,800055d8 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800055c6:	8ecfe0ef          	jal	800036b2 <iunlockput>
  end_op();
    800055ca:	b7dfe0ef          	jal	80004146 <end_op>
  return 0;
    800055ce:	4501                	li	a0,0
}
    800055d0:	60aa                	ld	ra,136(sp)
    800055d2:	640a                	ld	s0,128(sp)
    800055d4:	6149                	addi	sp,sp,144
    800055d6:	8082                	ret
    end_op();
    800055d8:	b6ffe0ef          	jal	80004146 <end_op>
    return -1;
    800055dc:	557d                	li	a0,-1
    800055de:	bfcd                	j	800055d0 <sys_mkdir+0x38>

00000000800055e0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800055e0:	7135                	addi	sp,sp,-160
    800055e2:	ed06                	sd	ra,152(sp)
    800055e4:	e922                	sd	s0,144(sp)
    800055e6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800055e8:	af5fe0ef          	jal	800040dc <begin_op>
  argint(1, &major);
    800055ec:	f6c40593          	addi	a1,s0,-148
    800055f0:	4505                	li	a0,1
    800055f2:	a02fd0ef          	jal	800027f4 <argint>
  argint(2, &minor);
    800055f6:	f6840593          	addi	a1,s0,-152
    800055fa:	4509                	li	a0,2
    800055fc:	9f8fd0ef          	jal	800027f4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005600:	08000613          	li	a2,128
    80005604:	f7040593          	addi	a1,s0,-144
    80005608:	4501                	li	a0,0
    8000560a:	a22fd0ef          	jal	8000282c <argstr>
    8000560e:	02054563          	bltz	a0,80005638 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005612:	f6841683          	lh	a3,-152(s0)
    80005616:	f6c41603          	lh	a2,-148(s0)
    8000561a:	458d                	li	a1,3
    8000561c:	f7040513          	addi	a0,s0,-144
    80005620:	8fdff0ef          	jal	80004f1c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005624:	c911                	beqz	a0,80005638 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005626:	88cfe0ef          	jal	800036b2 <iunlockput>
  end_op();
    8000562a:	b1dfe0ef          	jal	80004146 <end_op>
  return 0;
    8000562e:	4501                	li	a0,0
}
    80005630:	60ea                	ld	ra,152(sp)
    80005632:	644a                	ld	s0,144(sp)
    80005634:	610d                	addi	sp,sp,160
    80005636:	8082                	ret
    end_op();
    80005638:	b0ffe0ef          	jal	80004146 <end_op>
    return -1;
    8000563c:	557d                	li	a0,-1
    8000563e:	bfcd                	j	80005630 <sys_mknod+0x50>

0000000080005640 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005640:	7135                	addi	sp,sp,-160
    80005642:	ed06                	sd	ra,152(sp)
    80005644:	e922                	sd	s0,144(sp)
    80005646:	e14a                	sd	s2,128(sp)
    80005648:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000564a:	a92fc0ef          	jal	800018dc <myproc>
    8000564e:	892a                	mv	s2,a0
  
  begin_op();
    80005650:	a8dfe0ef          	jal	800040dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005654:	08000613          	li	a2,128
    80005658:	f6040593          	addi	a1,s0,-160
    8000565c:	4501                	li	a0,0
    8000565e:	9cefd0ef          	jal	8000282c <argstr>
    80005662:	04054363          	bltz	a0,800056a8 <sys_chdir+0x68>
    80005666:	e526                	sd	s1,136(sp)
    80005668:	f6040513          	addi	a0,s0,-160
    8000566c:	8affe0ef          	jal	80003f1a <namei>
    80005670:	84aa                	mv	s1,a0
    80005672:	c915                	beqz	a0,800056a6 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005674:	e35fd0ef          	jal	800034a8 <ilock>
  if(ip->type != T_DIR){
    80005678:	04449703          	lh	a4,68(s1)
    8000567c:	4785                	li	a5,1
    8000567e:	02f71963          	bne	a4,a5,800056b0 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005682:	8526                	mv	a0,s1
    80005684:	ed3fd0ef          	jal	80003556 <iunlock>
  iput(p->cwd);
    80005688:	15093503          	ld	a0,336(s2)
    8000568c:	f9ffd0ef          	jal	8000362a <iput>
  end_op();
    80005690:	ab7fe0ef          	jal	80004146 <end_op>
  p->cwd = ip;
    80005694:	14993823          	sd	s1,336(s2)
  return 0;
    80005698:	4501                	li	a0,0
    8000569a:	64aa                	ld	s1,136(sp)
}
    8000569c:	60ea                	ld	ra,152(sp)
    8000569e:	644a                	ld	s0,144(sp)
    800056a0:	690a                	ld	s2,128(sp)
    800056a2:	610d                	addi	sp,sp,160
    800056a4:	8082                	ret
    800056a6:	64aa                	ld	s1,136(sp)
    end_op();
    800056a8:	a9ffe0ef          	jal	80004146 <end_op>
    return -1;
    800056ac:	557d                	li	a0,-1
    800056ae:	b7fd                	j	8000569c <sys_chdir+0x5c>
    iunlockput(ip);
    800056b0:	8526                	mv	a0,s1
    800056b2:	800fe0ef          	jal	800036b2 <iunlockput>
    end_op();
    800056b6:	a91fe0ef          	jal	80004146 <end_op>
    return -1;
    800056ba:	557d                	li	a0,-1
    800056bc:	64aa                	ld	s1,136(sp)
    800056be:	bff9                	j	8000569c <sys_chdir+0x5c>

00000000800056c0 <sys_exec>:

uint64
sys_exec(void)
{
    800056c0:	7105                	addi	sp,sp,-480
    800056c2:	ef86                	sd	ra,472(sp)
    800056c4:	eba2                	sd	s0,464(sp)
    800056c6:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800056c8:	e2840593          	addi	a1,s0,-472
    800056cc:	4505                	li	a0,1
    800056ce:	942fd0ef          	jal	80002810 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800056d2:	08000613          	li	a2,128
    800056d6:	f3040593          	addi	a1,s0,-208
    800056da:	4501                	li	a0,0
    800056dc:	950fd0ef          	jal	8000282c <argstr>
    800056e0:	87aa                	mv	a5,a0
    return -1;
    800056e2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800056e4:	0e07c063          	bltz	a5,800057c4 <sys_exec+0x104>
    800056e8:	e7a6                	sd	s1,456(sp)
    800056ea:	e3ca                	sd	s2,448(sp)
    800056ec:	ff4e                	sd	s3,440(sp)
    800056ee:	fb52                	sd	s4,432(sp)
    800056f0:	f756                	sd	s5,424(sp)
    800056f2:	f35a                	sd	s6,416(sp)
    800056f4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800056f6:	e3040a13          	addi	s4,s0,-464
    800056fa:	10000613          	li	a2,256
    800056fe:	4581                	li	a1,0
    80005700:	8552                	mv	a0,s4
    80005702:	dccfb0ef          	jal	80000cce <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005706:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005708:	89d2                	mv	s3,s4
    8000570a:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000570c:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005710:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005712:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005716:	00391513          	slli	a0,s2,0x3
    8000571a:	85d6                	mv	a1,s5
    8000571c:	e2843783          	ld	a5,-472(s0)
    80005720:	953e                	add	a0,a0,a5
    80005722:	848fd0ef          	jal	8000276a <fetchaddr>
    80005726:	02054663          	bltz	a0,80005752 <sys_exec+0x92>
    if(uarg == 0){
    8000572a:	e2043783          	ld	a5,-480(s0)
    8000572e:	c7a1                	beqz	a5,80005776 <sys_exec+0xb6>
    argv[i] = kalloc();
    80005730:	bfafb0ef          	jal	80000b2a <kalloc>
    80005734:	85aa                	mv	a1,a0
    80005736:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000573a:	cd01                	beqz	a0,80005752 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000573c:	865a                	mv	a2,s6
    8000573e:	e2043503          	ld	a0,-480(s0)
    80005742:	872fd0ef          	jal	800027b4 <fetchstr>
    80005746:	00054663          	bltz	a0,80005752 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000574a:	0905                	addi	s2,s2,1
    8000574c:	09a1                	addi	s3,s3,8
    8000574e:	fd7914e3          	bne	s2,s7,80005716 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005752:	100a0a13          	addi	s4,s4,256
    80005756:	6088                	ld	a0,0(s1)
    80005758:	cd31                	beqz	a0,800057b4 <sys_exec+0xf4>
    kfree(argv[i]);
    8000575a:	aeefb0ef          	jal	80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000575e:	04a1                	addi	s1,s1,8
    80005760:	ff449be3          	bne	s1,s4,80005756 <sys_exec+0x96>
  return -1;
    80005764:	557d                	li	a0,-1
    80005766:	64be                	ld	s1,456(sp)
    80005768:	691e                	ld	s2,448(sp)
    8000576a:	79fa                	ld	s3,440(sp)
    8000576c:	7a5a                	ld	s4,432(sp)
    8000576e:	7aba                	ld	s5,424(sp)
    80005770:	7b1a                	ld	s6,416(sp)
    80005772:	6bfa                	ld	s7,408(sp)
    80005774:	a881                	j	800057c4 <sys_exec+0x104>
      argv[i] = 0;
    80005776:	0009079b          	sext.w	a5,s2
    8000577a:	e3040593          	addi	a1,s0,-464
    8000577e:	078e                	slli	a5,a5,0x3
    80005780:	97ae                	add	a5,a5,a1
    80005782:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80005786:	f3040513          	addi	a0,s0,-208
    8000578a:	ba4ff0ef          	jal	80004b2e <exec>
    8000578e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005790:	100a0a13          	addi	s4,s4,256
    80005794:	6088                	ld	a0,0(s1)
    80005796:	c511                	beqz	a0,800057a2 <sys_exec+0xe2>
    kfree(argv[i]);
    80005798:	ab0fb0ef          	jal	80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000579c:	04a1                	addi	s1,s1,8
    8000579e:	ff449be3          	bne	s1,s4,80005794 <sys_exec+0xd4>
  return ret;
    800057a2:	854a                	mv	a0,s2
    800057a4:	64be                	ld	s1,456(sp)
    800057a6:	691e                	ld	s2,448(sp)
    800057a8:	79fa                	ld	s3,440(sp)
    800057aa:	7a5a                	ld	s4,432(sp)
    800057ac:	7aba                	ld	s5,424(sp)
    800057ae:	7b1a                	ld	s6,416(sp)
    800057b0:	6bfa                	ld	s7,408(sp)
    800057b2:	a809                	j	800057c4 <sys_exec+0x104>
  return -1;
    800057b4:	557d                	li	a0,-1
    800057b6:	64be                	ld	s1,456(sp)
    800057b8:	691e                	ld	s2,448(sp)
    800057ba:	79fa                	ld	s3,440(sp)
    800057bc:	7a5a                	ld	s4,432(sp)
    800057be:	7aba                	ld	s5,424(sp)
    800057c0:	7b1a                	ld	s6,416(sp)
    800057c2:	6bfa                	ld	s7,408(sp)
}
    800057c4:	60fe                	ld	ra,472(sp)
    800057c6:	645e                	ld	s0,464(sp)
    800057c8:	613d                	addi	sp,sp,480
    800057ca:	8082                	ret

00000000800057cc <sys_pipe>:

uint64
sys_pipe(void)
{
    800057cc:	7139                	addi	sp,sp,-64
    800057ce:	fc06                	sd	ra,56(sp)
    800057d0:	f822                	sd	s0,48(sp)
    800057d2:	f426                	sd	s1,40(sp)
    800057d4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800057d6:	906fc0ef          	jal	800018dc <myproc>
    800057da:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800057dc:	fd840593          	addi	a1,s0,-40
    800057e0:	4501                	li	a0,0
    800057e2:	82efd0ef          	jal	80002810 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800057e6:	fc840593          	addi	a1,s0,-56
    800057ea:	fd040513          	addi	a0,s0,-48
    800057ee:	81eff0ef          	jal	8000480c <pipealloc>
    return -1;
    800057f2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800057f4:	0a054463          	bltz	a0,8000589c <sys_pipe+0xd0>
  fd0 = -1;
    800057f8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800057fc:	fd043503          	ld	a0,-48(s0)
    80005800:	edeff0ef          	jal	80004ede <fdalloc>
    80005804:	fca42223          	sw	a0,-60(s0)
    80005808:	08054163          	bltz	a0,8000588a <sys_pipe+0xbe>
    8000580c:	fc843503          	ld	a0,-56(s0)
    80005810:	eceff0ef          	jal	80004ede <fdalloc>
    80005814:	fca42023          	sw	a0,-64(s0)
    80005818:	06054063          	bltz	a0,80005878 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000581c:	4691                	li	a3,4
    8000581e:	fc440613          	addi	a2,s0,-60
    80005822:	fd843583          	ld	a1,-40(s0)
    80005826:	68a8                	ld	a0,80(s1)
    80005828:	d5dfb0ef          	jal	80001584 <copyout>
    8000582c:	00054e63          	bltz	a0,80005848 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005830:	4691                	li	a3,4
    80005832:	fc040613          	addi	a2,s0,-64
    80005836:	fd843583          	ld	a1,-40(s0)
    8000583a:	95b6                	add	a1,a1,a3
    8000583c:	68a8                	ld	a0,80(s1)
    8000583e:	d47fb0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005842:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005844:	04055c63          	bgez	a0,8000589c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005848:	fc442783          	lw	a5,-60(s0)
    8000584c:	07e9                	addi	a5,a5,26
    8000584e:	078e                	slli	a5,a5,0x3
    80005850:	97a6                	add	a5,a5,s1
    80005852:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005856:	fc042783          	lw	a5,-64(s0)
    8000585a:	07e9                	addi	a5,a5,26
    8000585c:	078e                	slli	a5,a5,0x3
    8000585e:	94be                	add	s1,s1,a5
    80005860:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005864:	fd043503          	ld	a0,-48(s0)
    80005868:	c95fe0ef          	jal	800044fc <fileclose>
    fileclose(wf);
    8000586c:	fc843503          	ld	a0,-56(s0)
    80005870:	c8dfe0ef          	jal	800044fc <fileclose>
    return -1;
    80005874:	57fd                	li	a5,-1
    80005876:	a01d                	j	8000589c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005878:	fc442783          	lw	a5,-60(s0)
    8000587c:	0007c763          	bltz	a5,8000588a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005880:	07e9                	addi	a5,a5,26
    80005882:	078e                	slli	a5,a5,0x3
    80005884:	97a6                	add	a5,a5,s1
    80005886:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000588a:	fd043503          	ld	a0,-48(s0)
    8000588e:	c6ffe0ef          	jal	800044fc <fileclose>
    fileclose(wf);
    80005892:	fc843503          	ld	a0,-56(s0)
    80005896:	c67fe0ef          	jal	800044fc <fileclose>
    return -1;
    8000589a:	57fd                	li	a5,-1
}
    8000589c:	853e                	mv	a0,a5
    8000589e:	70e2                	ld	ra,56(sp)
    800058a0:	7442                	ld	s0,48(sp)
    800058a2:	74a2                	ld	s1,40(sp)
    800058a4:	6121                	addi	sp,sp,64
    800058a6:	8082                	ret
	...

00000000800058b0 <kernelvec>:
    800058b0:	7111                	addi	sp,sp,-256
    800058b2:	e006                	sd	ra,0(sp)
    800058b4:	e40a                	sd	sp,8(sp)
    800058b6:	e80e                	sd	gp,16(sp)
    800058b8:	ec12                	sd	tp,24(sp)
    800058ba:	f016                	sd	t0,32(sp)
    800058bc:	f41a                	sd	t1,40(sp)
    800058be:	f81e                	sd	t2,48(sp)
    800058c0:	e4aa                	sd	a0,72(sp)
    800058c2:	e8ae                	sd	a1,80(sp)
    800058c4:	ecb2                	sd	a2,88(sp)
    800058c6:	f0b6                	sd	a3,96(sp)
    800058c8:	f4ba                	sd	a4,104(sp)
    800058ca:	f8be                	sd	a5,112(sp)
    800058cc:	fcc2                	sd	a6,120(sp)
    800058ce:	e146                	sd	a7,128(sp)
    800058d0:	edf2                	sd	t3,216(sp)
    800058d2:	f1f6                	sd	t4,224(sp)
    800058d4:	f5fa                	sd	t5,232(sp)
    800058d6:	f9fe                	sd	t6,240(sp)
    800058d8:	da3fc0ef          	jal	8000267a <kerneltrap>
    800058dc:	6082                	ld	ra,0(sp)
    800058de:	6122                	ld	sp,8(sp)
    800058e0:	61c2                	ld	gp,16(sp)
    800058e2:	7282                	ld	t0,32(sp)
    800058e4:	7322                	ld	t1,40(sp)
    800058e6:	73c2                	ld	t2,48(sp)
    800058e8:	6526                	ld	a0,72(sp)
    800058ea:	65c6                	ld	a1,80(sp)
    800058ec:	6666                	ld	a2,88(sp)
    800058ee:	7686                	ld	a3,96(sp)
    800058f0:	7726                	ld	a4,104(sp)
    800058f2:	77c6                	ld	a5,112(sp)
    800058f4:	7866                	ld	a6,120(sp)
    800058f6:	688a                	ld	a7,128(sp)
    800058f8:	6e6e                	ld	t3,216(sp)
    800058fa:	7e8e                	ld	t4,224(sp)
    800058fc:	7f2e                	ld	t5,232(sp)
    800058fe:	7fce                	ld	t6,240(sp)
    80005900:	6111                	addi	sp,sp,256
    80005902:	10200073          	sret
	...

000000008000590e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000590e:	1141                	addi	sp,sp,-16
    80005910:	e406                	sd	ra,8(sp)
    80005912:	e022                	sd	s0,0(sp)
    80005914:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005916:	0c000737          	lui	a4,0xc000
    8000591a:	4785                	li	a5,1
    8000591c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000591e:	c35c                	sw	a5,4(a4)
}
    80005920:	60a2                	ld	ra,8(sp)
    80005922:	6402                	ld	s0,0(sp)
    80005924:	0141                	addi	sp,sp,16
    80005926:	8082                	ret

0000000080005928 <plicinithart>:

void
plicinithart(void)
{
    80005928:	1141                	addi	sp,sp,-16
    8000592a:	e406                	sd	ra,8(sp)
    8000592c:	e022                	sd	s0,0(sp)
    8000592e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005930:	f79fb0ef          	jal	800018a8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005934:	0085171b          	slliw	a4,a0,0x8
    80005938:	0c0027b7          	lui	a5,0xc002
    8000593c:	97ba                	add	a5,a5,a4
    8000593e:	40200713          	li	a4,1026
    80005942:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005946:	00d5151b          	slliw	a0,a0,0xd
    8000594a:	0c2017b7          	lui	a5,0xc201
    8000594e:	97aa                	add	a5,a5,a0
    80005950:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005954:	60a2                	ld	ra,8(sp)
    80005956:	6402                	ld	s0,0(sp)
    80005958:	0141                	addi	sp,sp,16
    8000595a:	8082                	ret

000000008000595c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000595c:	1141                	addi	sp,sp,-16
    8000595e:	e406                	sd	ra,8(sp)
    80005960:	e022                	sd	s0,0(sp)
    80005962:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005964:	f45fb0ef          	jal	800018a8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005968:	00d5151b          	slliw	a0,a0,0xd
    8000596c:	0c2017b7          	lui	a5,0xc201
    80005970:	97aa                	add	a5,a5,a0
  return irq;
}
    80005972:	43c8                	lw	a0,4(a5)
    80005974:	60a2                	ld	ra,8(sp)
    80005976:	6402                	ld	s0,0(sp)
    80005978:	0141                	addi	sp,sp,16
    8000597a:	8082                	ret

000000008000597c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000597c:	1101                	addi	sp,sp,-32
    8000597e:	ec06                	sd	ra,24(sp)
    80005980:	e822                	sd	s0,16(sp)
    80005982:	e426                	sd	s1,8(sp)
    80005984:	1000                	addi	s0,sp,32
    80005986:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005988:	f21fb0ef          	jal	800018a8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000598c:	00d5179b          	slliw	a5,a0,0xd
    80005990:	0c201737          	lui	a4,0xc201
    80005994:	97ba                	add	a5,a5,a4
    80005996:	c3c4                	sw	s1,4(a5)
}
    80005998:	60e2                	ld	ra,24(sp)
    8000599a:	6442                	ld	s0,16(sp)
    8000599c:	64a2                	ld	s1,8(sp)
    8000599e:	6105                	addi	sp,sp,32
    800059a0:	8082                	ret

00000000800059a2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800059a2:	1141                	addi	sp,sp,-16
    800059a4:	e406                	sd	ra,8(sp)
    800059a6:	e022                	sd	s0,0(sp)
    800059a8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800059aa:	479d                	li	a5,7
    800059ac:	04a7ca63          	blt	a5,a0,80005a00 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800059b0:	0001c797          	auipc	a5,0x1c
    800059b4:	33078793          	addi	a5,a5,816 # 80021ce0 <disk>
    800059b8:	97aa                	add	a5,a5,a0
    800059ba:	0187c783          	lbu	a5,24(a5)
    800059be:	e7b9                	bnez	a5,80005a0c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800059c0:	00451693          	slli	a3,a0,0x4
    800059c4:	0001c797          	auipc	a5,0x1c
    800059c8:	31c78793          	addi	a5,a5,796 # 80021ce0 <disk>
    800059cc:	6398                	ld	a4,0(a5)
    800059ce:	9736                	add	a4,a4,a3
    800059d0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800059d4:	6398                	ld	a4,0(a5)
    800059d6:	9736                	add	a4,a4,a3
    800059d8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800059dc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800059e0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800059e4:	97aa                	add	a5,a5,a0
    800059e6:	4705                	li	a4,1
    800059e8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800059ec:	0001c517          	auipc	a0,0x1c
    800059f0:	30c50513          	addi	a0,a0,780 # 80021cf8 <disk+0x18>
    800059f4:	d02fc0ef          	jal	80001ef6 <wakeup>
}
    800059f8:	60a2                	ld	ra,8(sp)
    800059fa:	6402                	ld	s0,0(sp)
    800059fc:	0141                	addi	sp,sp,16
    800059fe:	8082                	ret
    panic("free_desc 1");
    80005a00:	00003517          	auipc	a0,0x3
    80005a04:	da850513          	addi	a0,a0,-600 # 800087a8 <etext+0x7a8>
    80005a08:	d97fa0ef          	jal	8000079e <panic>
    panic("free_desc 2");
    80005a0c:	00003517          	auipc	a0,0x3
    80005a10:	dac50513          	addi	a0,a0,-596 # 800087b8 <etext+0x7b8>
    80005a14:	d8bfa0ef          	jal	8000079e <panic>

0000000080005a18 <virtio_disk_init>:
{
    80005a18:	1101                	addi	sp,sp,-32
    80005a1a:	ec06                	sd	ra,24(sp)
    80005a1c:	e822                	sd	s0,16(sp)
    80005a1e:	e426                	sd	s1,8(sp)
    80005a20:	e04a                	sd	s2,0(sp)
    80005a22:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005a24:	00003597          	auipc	a1,0x3
    80005a28:	da458593          	addi	a1,a1,-604 # 800087c8 <etext+0x7c8>
    80005a2c:	0001c517          	auipc	a0,0x1c
    80005a30:	3dc50513          	addi	a0,a0,988 # 80021e08 <disk+0x128>
    80005a34:	946fb0ef          	jal	80000b7a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005a38:	100017b7          	lui	a5,0x10001
    80005a3c:	4398                	lw	a4,0(a5)
    80005a3e:	2701                	sext.w	a4,a4
    80005a40:	747277b7          	lui	a5,0x74727
    80005a44:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005a48:	14f71863          	bne	a4,a5,80005b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005a4c:	100017b7          	lui	a5,0x10001
    80005a50:	43dc                	lw	a5,4(a5)
    80005a52:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005a54:	4709                	li	a4,2
    80005a56:	14e79163          	bne	a5,a4,80005b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005a5a:	100017b7          	lui	a5,0x10001
    80005a5e:	479c                	lw	a5,8(a5)
    80005a60:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005a62:	12e79b63          	bne	a5,a4,80005b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005a66:	100017b7          	lui	a5,0x10001
    80005a6a:	47d8                	lw	a4,12(a5)
    80005a6c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005a6e:	554d47b7          	lui	a5,0x554d4
    80005a72:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005a76:	12f71163          	bne	a4,a5,80005b98 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a7a:	100017b7          	lui	a5,0x10001
    80005a7e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a82:	4705                	li	a4,1
    80005a84:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a86:	470d                	li	a4,3
    80005a88:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005a8a:	10001737          	lui	a4,0x10001
    80005a8e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005a90:	c7ffe6b7          	lui	a3,0xc7ffe
    80005a94:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fda53f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005a98:	8f75                	and	a4,a4,a3
    80005a9a:	100016b7          	lui	a3,0x10001
    80005a9e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005aa0:	472d                	li	a4,11
    80005aa2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005aa4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005aa8:	439c                	lw	a5,0(a5)
    80005aaa:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005aae:	8ba1                	andi	a5,a5,8
    80005ab0:	0e078a63          	beqz	a5,80005ba4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005ab4:	100017b7          	lui	a5,0x10001
    80005ab8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005abc:	43fc                	lw	a5,68(a5)
    80005abe:	2781                	sext.w	a5,a5
    80005ac0:	0e079863          	bnez	a5,80005bb0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005ac4:	100017b7          	lui	a5,0x10001
    80005ac8:	5bdc                	lw	a5,52(a5)
    80005aca:	2781                	sext.w	a5,a5
  if(max == 0)
    80005acc:	0e078863          	beqz	a5,80005bbc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005ad0:	471d                	li	a4,7
    80005ad2:	0ef77b63          	bgeu	a4,a5,80005bc8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005ad6:	854fb0ef          	jal	80000b2a <kalloc>
    80005ada:	0001c497          	auipc	s1,0x1c
    80005ade:	20648493          	addi	s1,s1,518 # 80021ce0 <disk>
    80005ae2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005ae4:	846fb0ef          	jal	80000b2a <kalloc>
    80005ae8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005aea:	840fb0ef          	jal	80000b2a <kalloc>
    80005aee:	87aa                	mv	a5,a0
    80005af0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005af2:	6088                	ld	a0,0(s1)
    80005af4:	0e050063          	beqz	a0,80005bd4 <virtio_disk_init+0x1bc>
    80005af8:	0001c717          	auipc	a4,0x1c
    80005afc:	1f073703          	ld	a4,496(a4) # 80021ce8 <disk+0x8>
    80005b00:	cb71                	beqz	a4,80005bd4 <virtio_disk_init+0x1bc>
    80005b02:	cbe9                	beqz	a5,80005bd4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005b04:	6605                	lui	a2,0x1
    80005b06:	4581                	li	a1,0
    80005b08:	9c6fb0ef          	jal	80000cce <memset>
  memset(disk.avail, 0, PGSIZE);
    80005b0c:	0001c497          	auipc	s1,0x1c
    80005b10:	1d448493          	addi	s1,s1,468 # 80021ce0 <disk>
    80005b14:	6605                	lui	a2,0x1
    80005b16:	4581                	li	a1,0
    80005b18:	6488                	ld	a0,8(s1)
    80005b1a:	9b4fb0ef          	jal	80000cce <memset>
  memset(disk.used, 0, PGSIZE);
    80005b1e:	6605                	lui	a2,0x1
    80005b20:	4581                	li	a1,0
    80005b22:	6888                	ld	a0,16(s1)
    80005b24:	9aafb0ef          	jal	80000cce <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005b28:	100017b7          	lui	a5,0x10001
    80005b2c:	4721                	li	a4,8
    80005b2e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005b30:	4098                	lw	a4,0(s1)
    80005b32:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005b36:	40d8                	lw	a4,4(s1)
    80005b38:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005b3c:	649c                	ld	a5,8(s1)
    80005b3e:	0007869b          	sext.w	a3,a5
    80005b42:	10001737          	lui	a4,0x10001
    80005b46:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005b4a:	9781                	srai	a5,a5,0x20
    80005b4c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005b50:	689c                	ld	a5,16(s1)
    80005b52:	0007869b          	sext.w	a3,a5
    80005b56:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005b5a:	9781                	srai	a5,a5,0x20
    80005b5c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005b60:	4785                	li	a5,1
    80005b62:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005b64:	00f48c23          	sb	a5,24(s1)
    80005b68:	00f48ca3          	sb	a5,25(s1)
    80005b6c:	00f48d23          	sb	a5,26(s1)
    80005b70:	00f48da3          	sb	a5,27(s1)
    80005b74:	00f48e23          	sb	a5,28(s1)
    80005b78:	00f48ea3          	sb	a5,29(s1)
    80005b7c:	00f48f23          	sb	a5,30(s1)
    80005b80:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005b84:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b88:	07272823          	sw	s2,112(a4)
}
    80005b8c:	60e2                	ld	ra,24(sp)
    80005b8e:	6442                	ld	s0,16(sp)
    80005b90:	64a2                	ld	s1,8(sp)
    80005b92:	6902                	ld	s2,0(sp)
    80005b94:	6105                	addi	sp,sp,32
    80005b96:	8082                	ret
    panic("could not find virtio disk");
    80005b98:	00003517          	auipc	a0,0x3
    80005b9c:	c4050513          	addi	a0,a0,-960 # 800087d8 <etext+0x7d8>
    80005ba0:	bfffa0ef          	jal	8000079e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005ba4:	00003517          	auipc	a0,0x3
    80005ba8:	c5450513          	addi	a0,a0,-940 # 800087f8 <etext+0x7f8>
    80005bac:	bf3fa0ef          	jal	8000079e <panic>
    panic("virtio disk should not be ready");
    80005bb0:	00003517          	auipc	a0,0x3
    80005bb4:	c6850513          	addi	a0,a0,-920 # 80008818 <etext+0x818>
    80005bb8:	be7fa0ef          	jal	8000079e <panic>
    panic("virtio disk has no queue 0");
    80005bbc:	00003517          	auipc	a0,0x3
    80005bc0:	c7c50513          	addi	a0,a0,-900 # 80008838 <etext+0x838>
    80005bc4:	bdbfa0ef          	jal	8000079e <panic>
    panic("virtio disk max queue too short");
    80005bc8:	00003517          	auipc	a0,0x3
    80005bcc:	c9050513          	addi	a0,a0,-880 # 80008858 <etext+0x858>
    80005bd0:	bcffa0ef          	jal	8000079e <panic>
    panic("virtio disk kalloc");
    80005bd4:	00003517          	auipc	a0,0x3
    80005bd8:	ca450513          	addi	a0,a0,-860 # 80008878 <etext+0x878>
    80005bdc:	bc3fa0ef          	jal	8000079e <panic>

0000000080005be0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005be0:	711d                	addi	sp,sp,-96
    80005be2:	ec86                	sd	ra,88(sp)
    80005be4:	e8a2                	sd	s0,80(sp)
    80005be6:	e4a6                	sd	s1,72(sp)
    80005be8:	e0ca                	sd	s2,64(sp)
    80005bea:	fc4e                	sd	s3,56(sp)
    80005bec:	f852                	sd	s4,48(sp)
    80005bee:	f456                	sd	s5,40(sp)
    80005bf0:	f05a                	sd	s6,32(sp)
    80005bf2:	ec5e                	sd	s7,24(sp)
    80005bf4:	e862                	sd	s8,16(sp)
    80005bf6:	1080                	addi	s0,sp,96
    80005bf8:	89aa                	mv	s3,a0
    80005bfa:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005bfc:	00c52b83          	lw	s7,12(a0)
    80005c00:	001b9b9b          	slliw	s7,s7,0x1
    80005c04:	1b82                	slli	s7,s7,0x20
    80005c06:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005c0a:	0001c517          	auipc	a0,0x1c
    80005c0e:	1fe50513          	addi	a0,a0,510 # 80021e08 <disk+0x128>
    80005c12:	fedfa0ef          	jal	80000bfe <acquire>
  for(int i = 0; i < NUM; i++){
    80005c16:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005c18:	0001ca97          	auipc	s5,0x1c
    80005c1c:	0c8a8a93          	addi	s5,s5,200 # 80021ce0 <disk>
  for(int i = 0; i < 3; i++){
    80005c20:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005c22:	5c7d                	li	s8,-1
    80005c24:	a095                	j	80005c88 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005c26:	00fa8733          	add	a4,s5,a5
    80005c2a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005c2e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005c30:	0207c563          	bltz	a5,80005c5a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005c34:	2905                	addiw	s2,s2,1
    80005c36:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005c38:	05490c63          	beq	s2,s4,80005c90 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80005c3c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005c3e:	0001c717          	auipc	a4,0x1c
    80005c42:	0a270713          	addi	a4,a4,162 # 80021ce0 <disk>
    80005c46:	4781                	li	a5,0
    if(disk.free[i]){
    80005c48:	01874683          	lbu	a3,24(a4)
    80005c4c:	fee9                	bnez	a3,80005c26 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80005c4e:	2785                	addiw	a5,a5,1
    80005c50:	0705                	addi	a4,a4,1
    80005c52:	fe979be3          	bne	a5,s1,80005c48 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005c56:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80005c5a:	01205d63          	blez	s2,80005c74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005c5e:	fa042503          	lw	a0,-96(s0)
    80005c62:	d41ff0ef          	jal	800059a2 <free_desc>
      for(int j = 0; j < i; j++)
    80005c66:	4785                	li	a5,1
    80005c68:	0127d663          	bge	a5,s2,80005c74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005c6c:	fa442503          	lw	a0,-92(s0)
    80005c70:	d33ff0ef          	jal	800059a2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005c74:	0001c597          	auipc	a1,0x1c
    80005c78:	19458593          	addi	a1,a1,404 # 80021e08 <disk+0x128>
    80005c7c:	0001c517          	auipc	a0,0x1c
    80005c80:	07c50513          	addi	a0,a0,124 # 80021cf8 <disk+0x18>
    80005c84:	a26fc0ef          	jal	80001eaa <sleep>
  for(int i = 0; i < 3; i++){
    80005c88:	fa040613          	addi	a2,s0,-96
    80005c8c:	4901                	li	s2,0
    80005c8e:	b77d                	j	80005c3c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c90:	fa042503          	lw	a0,-96(s0)
    80005c94:	00451693          	slli	a3,a0,0x4

  if(write)
    80005c98:	0001c797          	auipc	a5,0x1c
    80005c9c:	04878793          	addi	a5,a5,72 # 80021ce0 <disk>
    80005ca0:	00a50713          	addi	a4,a0,10
    80005ca4:	0712                	slli	a4,a4,0x4
    80005ca6:	973e                	add	a4,a4,a5
    80005ca8:	01603633          	snez	a2,s6
    80005cac:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005cae:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005cb2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005cb6:	6398                	ld	a4,0(a5)
    80005cb8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005cba:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005cbe:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005cc0:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005cc2:	6390                	ld	a2,0(a5)
    80005cc4:	00d605b3          	add	a1,a2,a3
    80005cc8:	4741                	li	a4,16
    80005cca:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005ccc:	4805                	li	a6,1
    80005cce:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005cd2:	fa442703          	lw	a4,-92(s0)
    80005cd6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005cda:	0712                	slli	a4,a4,0x4
    80005cdc:	963a                	add	a2,a2,a4
    80005cde:	05898593          	addi	a1,s3,88
    80005ce2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005ce4:	0007b883          	ld	a7,0(a5)
    80005ce8:	9746                	add	a4,a4,a7
    80005cea:	40000613          	li	a2,1024
    80005cee:	c710                	sw	a2,8(a4)
  if(write)
    80005cf0:	001b3613          	seqz	a2,s6
    80005cf4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005cf8:	01066633          	or	a2,a2,a6
    80005cfc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005d00:	fa842583          	lw	a1,-88(s0)
    80005d04:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005d08:	00250613          	addi	a2,a0,2
    80005d0c:	0612                	slli	a2,a2,0x4
    80005d0e:	963e                	add	a2,a2,a5
    80005d10:	577d                	li	a4,-1
    80005d12:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005d16:	0592                	slli	a1,a1,0x4
    80005d18:	98ae                	add	a7,a7,a1
    80005d1a:	03068713          	addi	a4,a3,48
    80005d1e:	973e                	add	a4,a4,a5
    80005d20:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005d24:	6398                	ld	a4,0(a5)
    80005d26:	972e                	add	a4,a4,a1
    80005d28:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005d2c:	4689                	li	a3,2
    80005d2e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005d32:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005d36:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80005d3a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005d3e:	6794                	ld	a3,8(a5)
    80005d40:	0026d703          	lhu	a4,2(a3)
    80005d44:	8b1d                	andi	a4,a4,7
    80005d46:	0706                	slli	a4,a4,0x1
    80005d48:	96ba                	add	a3,a3,a4
    80005d4a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005d4e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005d52:	6798                	ld	a4,8(a5)
    80005d54:	00275783          	lhu	a5,2(a4)
    80005d58:	2785                	addiw	a5,a5,1
    80005d5a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005d5e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005d62:	100017b7          	lui	a5,0x10001
    80005d66:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005d6a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005d6e:	0001c917          	auipc	s2,0x1c
    80005d72:	09a90913          	addi	s2,s2,154 # 80021e08 <disk+0x128>
  while(b->disk == 1) {
    80005d76:	84c2                	mv	s1,a6
    80005d78:	01079a63          	bne	a5,a6,80005d8c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80005d7c:	85ca                	mv	a1,s2
    80005d7e:	854e                	mv	a0,s3
    80005d80:	92afc0ef          	jal	80001eaa <sleep>
  while(b->disk == 1) {
    80005d84:	0049a783          	lw	a5,4(s3)
    80005d88:	fe978ae3          	beq	a5,s1,80005d7c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80005d8c:	fa042903          	lw	s2,-96(s0)
    80005d90:	00290713          	addi	a4,s2,2
    80005d94:	0712                	slli	a4,a4,0x4
    80005d96:	0001c797          	auipc	a5,0x1c
    80005d9a:	f4a78793          	addi	a5,a5,-182 # 80021ce0 <disk>
    80005d9e:	97ba                	add	a5,a5,a4
    80005da0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005da4:	0001c997          	auipc	s3,0x1c
    80005da8:	f3c98993          	addi	s3,s3,-196 # 80021ce0 <disk>
    80005dac:	00491713          	slli	a4,s2,0x4
    80005db0:	0009b783          	ld	a5,0(s3)
    80005db4:	97ba                	add	a5,a5,a4
    80005db6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005dba:	854a                	mv	a0,s2
    80005dbc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005dc0:	be3ff0ef          	jal	800059a2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005dc4:	8885                	andi	s1,s1,1
    80005dc6:	f0fd                	bnez	s1,80005dac <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005dc8:	0001c517          	auipc	a0,0x1c
    80005dcc:	04050513          	addi	a0,a0,64 # 80021e08 <disk+0x128>
    80005dd0:	ec3fa0ef          	jal	80000c92 <release>
}
    80005dd4:	60e6                	ld	ra,88(sp)
    80005dd6:	6446                	ld	s0,80(sp)
    80005dd8:	64a6                	ld	s1,72(sp)
    80005dda:	6906                	ld	s2,64(sp)
    80005ddc:	79e2                	ld	s3,56(sp)
    80005dde:	7a42                	ld	s4,48(sp)
    80005de0:	7aa2                	ld	s5,40(sp)
    80005de2:	7b02                	ld	s6,32(sp)
    80005de4:	6be2                	ld	s7,24(sp)
    80005de6:	6c42                	ld	s8,16(sp)
    80005de8:	6125                	addi	sp,sp,96
    80005dea:	8082                	ret

0000000080005dec <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005dec:	1101                	addi	sp,sp,-32
    80005dee:	ec06                	sd	ra,24(sp)
    80005df0:	e822                	sd	s0,16(sp)
    80005df2:	e426                	sd	s1,8(sp)
    80005df4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005df6:	0001c497          	auipc	s1,0x1c
    80005dfa:	eea48493          	addi	s1,s1,-278 # 80021ce0 <disk>
    80005dfe:	0001c517          	auipc	a0,0x1c
    80005e02:	00a50513          	addi	a0,a0,10 # 80021e08 <disk+0x128>
    80005e06:	df9fa0ef          	jal	80000bfe <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005e0a:	100017b7          	lui	a5,0x10001
    80005e0e:	53bc                	lw	a5,96(a5)
    80005e10:	8b8d                	andi	a5,a5,3
    80005e12:	10001737          	lui	a4,0x10001
    80005e16:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005e18:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005e1c:	689c                	ld	a5,16(s1)
    80005e1e:	0204d703          	lhu	a4,32(s1)
    80005e22:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005e26:	04f70663          	beq	a4,a5,80005e72 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005e2a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005e2e:	6898                	ld	a4,16(s1)
    80005e30:	0204d783          	lhu	a5,32(s1)
    80005e34:	8b9d                	andi	a5,a5,7
    80005e36:	078e                	slli	a5,a5,0x3
    80005e38:	97ba                	add	a5,a5,a4
    80005e3a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005e3c:	00278713          	addi	a4,a5,2
    80005e40:	0712                	slli	a4,a4,0x4
    80005e42:	9726                	add	a4,a4,s1
    80005e44:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005e48:	e321                	bnez	a4,80005e88 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005e4a:	0789                	addi	a5,a5,2
    80005e4c:	0792                	slli	a5,a5,0x4
    80005e4e:	97a6                	add	a5,a5,s1
    80005e50:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005e52:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005e56:	8a0fc0ef          	jal	80001ef6 <wakeup>

    disk.used_idx += 1;
    80005e5a:	0204d783          	lhu	a5,32(s1)
    80005e5e:	2785                	addiw	a5,a5,1
    80005e60:	17c2                	slli	a5,a5,0x30
    80005e62:	93c1                	srli	a5,a5,0x30
    80005e64:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005e68:	6898                	ld	a4,16(s1)
    80005e6a:	00275703          	lhu	a4,2(a4)
    80005e6e:	faf71ee3          	bne	a4,a5,80005e2a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005e72:	0001c517          	auipc	a0,0x1c
    80005e76:	f9650513          	addi	a0,a0,-106 # 80021e08 <disk+0x128>
    80005e7a:	e19fa0ef          	jal	80000c92 <release>
}
    80005e7e:	60e2                	ld	ra,24(sp)
    80005e80:	6442                	ld	s0,16(sp)
    80005e82:	64a2                	ld	s1,8(sp)
    80005e84:	6105                	addi	sp,sp,32
    80005e86:	8082                	ret
      panic("virtio_disk_intr status");
    80005e88:	00003517          	auipc	a0,0x3
    80005e8c:	a0850513          	addi	a0,a0,-1528 # 80008890 <etext+0x890>
    80005e90:	90ffa0ef          	jal	8000079e <panic>

0000000080005e94 <min_heapify>:
    int temp = *a;
    *a = *b;
    *b = temp;
}

void min_heapify(int i) {
    80005e94:	87aa                	mv	a5,a0
    int smallest = i;
    int left = 2 * i + 1;
    80005e96:	0015171b          	slliw	a4,a0,0x1
    80005e9a:	0017059b          	addiw	a1,a4,1
    int right = 2 * i + 2;
    80005e9e:	2709                	addiw	a4,a4,2
    80005ea0:	853a                	mv	a0,a4

    if (left < heap_size && tree[heap[left]].freq < tree[heap[smallest]].freq)
    80005ea2:	00003697          	auipc	a3,0x3
    80005ea6:	c4a6a683          	lw	a3,-950(a3) # 80008aec <heap_size>
    80005eaa:	06d5d363          	bge	a1,a3,80005f10 <min_heapify+0x7c>
    80005eae:	0001c817          	auipc	a6,0x1c
    80005eb2:	37280813          	addi	a6,a6,882 # 80022220 <tree>
    80005eb6:	0001c897          	auipc	a7,0x1c
    80005eba:	f6a88893          	addi	a7,a7,-150 # 80021e20 <heap>
    80005ebe:	00259613          	slli	a2,a1,0x2
    80005ec2:	9646                	add	a2,a2,a7
    80005ec4:	4210                	lw	a2,0(a2)
    80005ec6:	0612                	slli	a2,a2,0x4
    80005ec8:	9642                	add	a2,a2,a6
    80005eca:	00279313          	slli	t1,a5,0x2
    80005ece:	989a                	add	a7,a7,t1
    80005ed0:	0008a883          	lw	a7,0(a7)
    80005ed4:	0892                	slli	a7,a7,0x4
    80005ed6:	9846                	add	a6,a6,a7
    80005ed8:	00462883          	lw	a7,4(a2)
    80005edc:	00482603          	lw	a2,4(a6)
    80005ee0:	02c8d863          	bge	a7,a2,80005f10 <min_heapify+0x7c>
        smallest = left;
    if (right < heap_size && tree[heap[right]].freq < tree[heap[smallest]].freq)
    80005ee4:	02d75463          	bge	a4,a3,80005f0c <min_heapify+0x78>
    80005ee8:	0001c697          	auipc	a3,0x1c
    80005eec:	33868693          	addi	a3,a3,824 # 80022220 <tree>
    80005ef0:	0001c617          	auipc	a2,0x1c
    80005ef4:	f3060613          	addi	a2,a2,-208 # 80021e20 <heap>
    80005ef8:	070a                	slli	a4,a4,0x2
    80005efa:	9732                	add	a4,a4,a2
    80005efc:	4318                	lw	a4,0(a4)
    80005efe:	0712                	slli	a4,a4,0x4
    80005f00:	9736                	add	a4,a4,a3
    80005f02:	4350                	lw	a2,4(a4)
    80005f04:	03164f63          	blt	a2,a7,80005f42 <min_heapify+0xae>
    80005f08:	852e                	mv	a0,a1
    80005f0a:	a825                	j	80005f42 <min_heapify+0xae>
    80005f0c:	852e                	mv	a0,a1
    80005f0e:	a815                	j	80005f42 <min_heapify+0xae>
    80005f10:	06d55363          	bge	a0,a3,80005f76 <min_heapify+0xe2>
    80005f14:	0001c697          	auipc	a3,0x1c
    80005f18:	30c68693          	addi	a3,a3,780 # 80022220 <tree>
    80005f1c:	0001c617          	auipc	a2,0x1c
    80005f20:	f0460613          	addi	a2,a2,-252 # 80021e20 <heap>
    80005f24:	070a                	slli	a4,a4,0x2
    80005f26:	9732                	add	a4,a4,a2
    80005f28:	4318                	lw	a4,0(a4)
    80005f2a:	0712                	slli	a4,a4,0x4
    80005f2c:	9736                	add	a4,a4,a3
    80005f2e:	00279593          	slli	a1,a5,0x2
    80005f32:	962e                	add	a2,a2,a1
    80005f34:	4210                	lw	a2,0(a2)
    80005f36:	0612                	slli	a2,a2,0x4
    80005f38:	96b2                	add	a3,a3,a2
    80005f3a:	4350                	lw	a2,4(a4)
    80005f3c:	42d8                	lw	a4,4(a3)
    80005f3e:	02e65b63          	bge	a2,a4,80005f74 <min_heapify+0xe0>
        smallest = right;

    if (smallest != i) {
    80005f42:	02f50a63          	beq	a0,a5,80005f76 <min_heapify+0xe2>
void min_heapify(int i) {
    80005f46:	1141                	addi	sp,sp,-16
    80005f48:	e406                	sd	ra,8(sp)
    80005f4a:	e022                	sd	s0,0(sp)
    80005f4c:	0800                	addi	s0,sp,16
    int temp = *a;
    80005f4e:	0001c717          	auipc	a4,0x1c
    80005f52:	ed270713          	addi	a4,a4,-302 # 80021e20 <heap>
    80005f56:	078a                	slli	a5,a5,0x2
    80005f58:	97ba                	add	a5,a5,a4
    80005f5a:	4394                	lw	a3,0(a5)
    *a = *b;
    80005f5c:	00251613          	slli	a2,a0,0x2
    80005f60:	9732                	add	a4,a4,a2
    80005f62:	4310                	lw	a2,0(a4)
    80005f64:	c390                	sw	a2,0(a5)
    *b = temp;
    80005f66:	c314                	sw	a3,0(a4)
        swap(&heap[i], &heap[smallest]);
        min_heapify(smallest);
    80005f68:	f2dff0ef          	jal	80005e94 <min_heapify>
    }
}
    80005f6c:	60a2                	ld	ra,8(sp)
    80005f6e:	6402                	ld	s0,0(sp)
    80005f70:	0141                	addi	sp,sp,16
    80005f72:	8082                	ret
    80005f74:	8082                	ret
    80005f76:	8082                	ret

0000000080005f78 <insert_heap>:

void insert_heap(int node_idx) {
    80005f78:	1141                	addi	sp,sp,-16
    80005f7a:	e406                	sd	ra,8(sp)
    80005f7c:	e022                	sd	s0,0(sp)
    80005f7e:	0800                	addi	s0,sp,16
    if (heap_size >= MAX_HEAP_SIZE)
    80005f80:	00003717          	auipc	a4,0x3
    80005f84:	b6c72703          	lw	a4,-1172(a4) # 80008aec <heap_size>
    80005f88:	0ff00793          	li	a5,255
    80005f8c:	08e7c263          	blt	a5,a4,80006010 <insert_heap+0x98>
        return;

    heap[heap_size] = node_idx;
    80005f90:	00271693          	slli	a3,a4,0x2
    80005f94:	0001c797          	auipc	a5,0x1c
    80005f98:	e8c78793          	addi	a5,a5,-372 # 80021e20 <heap>
    80005f9c:	97b6                	add	a5,a5,a3
    80005f9e:	c388                	sw	a0,0(a5)
    int i = heap_size++;
    80005fa0:	0017079b          	addiw	a5,a4,1
    80005fa4:	00003697          	auipc	a3,0x3
    80005fa8:	b4f6a423          	sw	a5,-1208(a3) # 80008aec <heap_size>
    
    while (i > 0 && tree[heap[(i - 1) / 2]].freq > tree[heap[i]].freq) {
    80005fac:	0001c697          	auipc	a3,0x1c
    80005fb0:	e7468693          	addi	a3,a3,-396 # 80021e20 <heap>
    80005fb4:	0001c317          	auipc	t1,0x1c
    80005fb8:	26c30313          	addi	t1,t1,620 # 80022220 <tree>
    80005fbc:	4e09                	li	t3,2
    80005fbe:	04e05963          	blez	a4,80006010 <insert_heap+0x98>
    80005fc2:	853a                	mv	a0,a4
    80005fc4:	377d                	addiw	a4,a4,-1
    80005fc6:	01f7579b          	srliw	a5,a4,0x1f
    80005fca:	9fb9                	addw	a5,a5,a4
    80005fcc:	4017d79b          	sraiw	a5,a5,0x1
    80005fd0:	873e                	mv	a4,a5
    80005fd2:	00279613          	slli	a2,a5,0x2
    80005fd6:	9636                	add	a2,a2,a3
    80005fd8:	00062883          	lw	a7,0(a2)
    80005fdc:	00251613          	slli	a2,a0,0x2
    80005fe0:	9636                	add	a2,a2,a3
    80005fe2:	00062803          	lw	a6,0(a2)
    80005fe6:	00489593          	slli	a1,a7,0x4
    80005fea:	959a                	add	a1,a1,t1
    80005fec:	00481613          	slli	a2,a6,0x4
    80005ff0:	961a                	add	a2,a2,t1
    80005ff2:	41cc                	lw	a1,4(a1)
    80005ff4:	4250                	lw	a2,4(a2)
    80005ff6:	00b65d63          	bge	a2,a1,80006010 <insert_heap+0x98>
    *a = *b;
    80005ffa:	00251613          	slli	a2,a0,0x2
    80005ffe:	9636                	add	a2,a2,a3
    80006000:	01162023          	sw	a7,0(a2)
    *b = temp;
    80006004:	078a                	slli	a5,a5,0x2
    80006006:	97b6                	add	a5,a5,a3
    80006008:	0107a023          	sw	a6,0(a5)
    while (i > 0 && tree[heap[(i - 1) / 2]].freq > tree[heap[i]].freq) {
    8000600c:	faae4be3          	blt	t3,a0,80005fc2 <insert_heap+0x4a>
        swap(&heap[i], &heap[(i - 1) / 2]);
        i = (i - 1) / 2;
    }
}
    80006010:	60a2                	ld	ra,8(sp)
    80006012:	6402                	ld	s0,0(sp)
    80006014:	0141                	addi	sp,sp,16
    80006016:	8082                	ret

0000000080006018 <extract_min>:

int extract_min() {
    80006018:	1101                	addi	sp,sp,-32
    8000601a:	ec06                	sd	ra,24(sp)
    8000601c:	e822                	sd	s0,16(sp)
    8000601e:	e426                	sd	s1,8(sp)
    80006020:	1000                	addi	s0,sp,32
    if (heap_size <= 0)
    80006022:	00003797          	auipc	a5,0x3
    80006026:	aca7a783          	lw	a5,-1334(a5) # 80008aec <heap_size>
    8000602a:	02f05963          	blez	a5,8000605c <extract_min+0x44>
        return -1;

    int min = heap[0];
    8000602e:	0001c717          	auipc	a4,0x1c
    80006032:	df270713          	addi	a4,a4,-526 # 80021e20 <heap>
    80006036:	4304                	lw	s1,0(a4)
    heap[0] = heap[--heap_size];
    80006038:	37fd                	addiw	a5,a5,-1
    8000603a:	00003697          	auipc	a3,0x3
    8000603e:	aaf6a923          	sw	a5,-1358(a3) # 80008aec <heap_size>
    80006042:	078a                	slli	a5,a5,0x2
    80006044:	97ba                	add	a5,a5,a4
    80006046:	439c                	lw	a5,0(a5)
    80006048:	c31c                	sw	a5,0(a4)
    min_heapify(0);
    8000604a:	4501                	li	a0,0
    8000604c:	e49ff0ef          	jal	80005e94 <min_heapify>
    return min;
}
    80006050:	8526                	mv	a0,s1
    80006052:	60e2                	ld	ra,24(sp)
    80006054:	6442                	ld	s0,16(sp)
    80006056:	64a2                	ld	s1,8(sp)
    80006058:	6105                	addi	sp,sp,32
    8000605a:	8082                	ret
        return -1;
    8000605c:	54fd                	li	s1,-1
    8000605e:	bfcd                	j	80006050 <extract_min+0x38>

0000000080006060 <build_tree>:

// Build Huffman tree
void build_tree(char *input, int inlen) {
    80006060:	bc010113          	addi	sp,sp,-1088
    80006064:	42113c23          	sd	ra,1080(sp)
    80006068:	42813823          	sd	s0,1072(sp)
    8000606c:	42913423          	sd	s1,1064(sp)
    80006070:	43213023          	sd	s2,1056(sp)
    80006074:	41313c23          	sd	s3,1048(sp)
    80006078:	41413823          	sd	s4,1040(sp)
    8000607c:	41513423          	sd	s5,1032(sp)
    80006080:	41613023          	sd	s6,1024(sp)
    80006084:	44010413          	addi	s0,sp,1088
    80006088:	84aa                	mv	s1,a0
    8000608a:	892e                	mv	s2,a1
    int freq[256] = {0};
    8000608c:	40000613          	li	a2,1024
    80006090:	4581                	li	a1,0
    80006092:	bc040513          	addi	a0,s0,-1088
    80006096:	c39fa0ef          	jal	80000cce <memset>
    tree_size = 0;
    8000609a:	00003797          	auipc	a5,0x3
    8000609e:	a407a723          	sw	zero,-1458(a5) # 80008ae8 <tree_size>
    heap_size = 0;
    800060a2:	00003797          	auipc	a5,0x3
    800060a6:	a407a523          	sw	zero,-1462(a5) # 80008aec <heap_size>

    // Count frequencies
    for (int i = 0; i < inlen; i++)
    800060aa:	03205163          	blez	s2,800060cc <build_tree+0x6c>
    800060ae:	8726                	mv	a4,s1
    800060b0:	01248633          	add	a2,s1,s2
        freq[(unsigned char)input[i]]++;
    800060b4:	bc040593          	addi	a1,s0,-1088
    800060b8:	00074783          	lbu	a5,0(a4)
    800060bc:	078a                	slli	a5,a5,0x2
    800060be:	97ae                	add	a5,a5,a1
    800060c0:	4394                	lw	a3,0(a5)
    800060c2:	2685                	addiw	a3,a3,1
    800060c4:	c394                	sw	a3,0(a5)
    for (int i = 0; i < inlen; i++)
    800060c6:	0705                	addi	a4,a4,1
    800060c8:	fec718e3          	bne	a4,a2,800060b8 <build_tree+0x58>

    // Create leaf nodes
    for (int i = 0; i < 256; i++) {
    800060cc:	bc040913          	addi	s2,s0,-1088
    800060d0:	4481                	li	s1,0
        if (freq[i] > 0) {
            tree[tree_size].c = i;
    800060d2:	00003a97          	auipc	s5,0x3
    800060d6:	a16a8a93          	addi	s5,s5,-1514 # 80008ae8 <tree_size>
    800060da:	0001cb17          	auipc	s6,0x1c
    800060de:	146b0b13          	addi	s6,s6,326 # 80022220 <tree>
            tree[tree_size].freq = freq[i];
            tree[tree_size].left = -1;
    800060e2:	5a7d                	li	s4,-1
    for (int i = 0; i < 256; i++) {
    800060e4:	10000993          	li	s3,256
    800060e8:	a029                	j	800060f2 <build_tree+0x92>
    800060ea:	2485                	addiw	s1,s1,1
    800060ec:	0911                	addi	s2,s2,4
    800060ee:	03348963          	beq	s1,s3,80006120 <build_tree+0xc0>
        if (freq[i] > 0) {
    800060f2:	00092703          	lw	a4,0(s2)
    800060f6:	fee05ae3          	blez	a4,800060ea <build_tree+0x8a>
            tree[tree_size].c = i;
    800060fa:	000aa503          	lw	a0,0(s5)
    800060fe:	00451793          	slli	a5,a0,0x4
    80006102:	97da                	add	a5,a5,s6
    80006104:	00978023          	sb	s1,0(a5)
            tree[tree_size].freq = freq[i];
    80006108:	c3d8                	sw	a4,4(a5)
            tree[tree_size].left = -1;
    8000610a:	0147a423          	sw	s4,8(a5)
            tree[tree_size].right = -1;
    8000610e:	0147a623          	sw	s4,12(a5)
            insert_heap(tree_size++);
    80006112:	0015079b          	addiw	a5,a0,1
    80006116:	00faa023          	sw	a5,0(s5)
    8000611a:	e5fff0ef          	jal	80005f78 <insert_heap>
    8000611e:	b7f1                	j	800060ea <build_tree+0x8a>
        }
    }

    // Build tree
    while (heap_size > 1) {
    80006120:	00003717          	auipc	a4,0x3
    80006124:	9cc72703          	lw	a4,-1588(a4) # 80008aec <heap_size>
    80006128:	4785                	li	a5,1
    8000612a:	06e7d063          	bge	a5,a4,8000618a <build_tree+0x12a>
        int left = extract_min();
        int right = extract_min();

        tree[tree_size].freq = tree[left].freq + tree[right].freq;
    8000612e:	00003997          	auipc	s3,0x3
    80006132:	9ba98993          	addi	s3,s3,-1606 # 80008ae8 <tree_size>
    80006136:	0001c917          	auipc	s2,0x1c
    8000613a:	0ea90913          	addi	s2,s2,234 # 80022220 <tree>
    while (heap_size > 1) {
    8000613e:	00003a97          	auipc	s5,0x3
    80006142:	9aea8a93          	addi	s5,s5,-1618 # 80008aec <heap_size>
    80006146:	8a3e                	mv	s4,a5
        int left = extract_min();
    80006148:	ed1ff0ef          	jal	80006018 <extract_min>
    8000614c:	84aa                	mv	s1,a0
        int right = extract_min();
    8000614e:	ecbff0ef          	jal	80006018 <extract_min>
    80006152:	872a                	mv	a4,a0
        tree[tree_size].freq = tree[left].freq + tree[right].freq;
    80006154:	0009a503          	lw	a0,0(s3)
    80006158:	00451793          	slli	a5,a0,0x4
    8000615c:	97ca                	add	a5,a5,s2
    8000615e:	00449613          	slli	a2,s1,0x4
    80006162:	964a                	add	a2,a2,s2
    80006164:	00471693          	slli	a3,a4,0x4
    80006168:	96ca                	add	a3,a3,s2
    8000616a:	4250                	lw	a2,4(a2)
    8000616c:	42d4                	lw	a3,4(a3)
    8000616e:	9eb1                	addw	a3,a3,a2
    80006170:	c3d4                	sw	a3,4(a5)
        tree[tree_size].left = left;
    80006172:	c784                	sw	s1,8(a5)
        tree[tree_size].right = right;
    80006174:	c7d8                	sw	a4,12(a5)
        insert_heap(tree_size++);
    80006176:	0015079b          	addiw	a5,a0,1
    8000617a:	00f9a023          	sw	a5,0(s3)
    8000617e:	dfbff0ef          	jal	80005f78 <insert_heap>
    while (heap_size > 1) {
    80006182:	000aa783          	lw	a5,0(s5)
    80006186:	fcfa41e3          	blt	s4,a5,80006148 <build_tree+0xe8>
    }
}
    8000618a:	43813083          	ld	ra,1080(sp)
    8000618e:	43013403          	ld	s0,1072(sp)
    80006192:	42813483          	ld	s1,1064(sp)
    80006196:	42013903          	ld	s2,1056(sp)
    8000619a:	41813983          	ld	s3,1048(sp)
    8000619e:	41013a03          	ld	s4,1040(sp)
    800061a2:	40813a83          	ld	s5,1032(sp)
    800061a6:	40013b03          	ld	s6,1024(sp)
    800061aa:	44010113          	addi	sp,sp,1088
    800061ae:	8082                	ret

00000000800061b0 <write_bit>:

// Write bit to output buffer
void write_bit(char *output, int *byte_pos, int *bit_pos, int bit) {
    800061b0:	1141                	addi	sp,sp,-16
    800061b2:	e406                	sd	ra,8(sp)
    800061b4:	e022                	sd	s0,0(sp)
    800061b6:	0800                	addi	s0,sp,16
    if (*bit_pos == 0)
    800061b8:	421c                	lw	a5,0(a2)
    800061ba:	e789                	bnez	a5,800061c4 <write_bit+0x14>
        output[*byte_pos] = 0;
    800061bc:	419c                	lw	a5,0(a1)
    800061be:	97aa                	add	a5,a5,a0
    800061c0:	00078023          	sb	zero,0(a5)

    output[*byte_pos] |= (bit << (7 - *bit_pos));
    800061c4:	419c                	lw	a5,0(a1)
    800061c6:	953e                	add	a0,a0,a5
    800061c8:	4218                	lw	a4,0(a2)
    800061ca:	479d                	li	a5,7
    800061cc:	9f99                	subw	a5,a5,a4
    800061ce:	00f696bb          	sllw	a3,a3,a5
    800061d2:	00054783          	lbu	a5,0(a0)
    800061d6:	8edd                	or	a3,a3,a5
    800061d8:	00d50023          	sb	a3,0(a0)
    *bit_pos = (*bit_pos + 1) % 8;
    800061dc:	421c                	lw	a5,0(a2)
    800061de:	2785                	addiw	a5,a5,1
    800061e0:	41f7d69b          	sraiw	a3,a5,0x1f
    800061e4:	01d6d69b          	srliw	a3,a3,0x1d
    800061e8:	00f6873b          	addw	a4,a3,a5
    800061ec:	8b1d                	andi	a4,a4,7
    800061ee:	9f15                	subw	a4,a4,a3
    800061f0:	c218                	sw	a4,0(a2)
    if (*bit_pos == 0)
    800061f2:	8b9d                	andi	a5,a5,7
    800061f4:	e781                	bnez	a5,800061fc <write_bit+0x4c>
        (*byte_pos)++;
    800061f6:	419c                	lw	a5,0(a1)
    800061f8:	2785                	addiw	a5,a5,1
    800061fa:	c19c                	sw	a5,0(a1)
}
    800061fc:	60a2                	ld	ra,8(sp)
    800061fe:	6402                	ld	s0,0(sp)
    80006200:	0141                	addi	sp,sp,16
    80006202:	8082                	ret

0000000080006204 <compress_huffman>:

// Compress using Huffman coding
int compress_huffman(char *input, int inlen, char *output, int maxlen) {
    80006204:	7135                	addi	sp,sp,-160
    80006206:	ed06                	sd	ra,152(sp)
    80006208:	e922                	sd	s0,144(sp)
    8000620a:	e526                	sd	s1,136(sp)
    8000620c:	f8d2                	sd	s4,112(sp)
    8000620e:	f4d6                	sd	s5,104(sp)
    80006210:	fc6e                	sd	s11,56(sp)
    80006212:	1100                	addi	s0,sp,160
    80006214:	84aa                	mv	s1,a0
    80006216:	8dae                	mv	s11,a1
    80006218:	8a32                	mv	s4,a2
    8000621a:	8ab6                	mv	s5,a3
    // Add debug prints
    printf("Building Huffman tree for %d bytes...\n", inlen);
    8000621c:	00002517          	auipc	a0,0x2
    80006220:	68c50513          	addi	a0,a0,1676 # 800088a8 <etext+0x8a8>
    80006224:	aaafa0ef          	jal	800004ce <printf>
    
    if (!input || !output || inlen <= 0 || maxlen <= 0)
    80006228:	14048d63          	beqz	s1,80006382 <compress_huffman+0x17e>
    8000622c:	140a0d63          	beqz	s4,80006386 <compress_huffman+0x182>
    80006230:	15b05d63          	blez	s11,8000638a <compress_huffman+0x186>
    80006234:	15505d63          	blez	s5,8000638e <compress_huffman+0x18a>
        return -1;

    // Build Huffman tree
    build_tree(input, inlen);
    80006238:	85ee                	mv	a1,s11
    8000623a:	8526                	mv	a0,s1
    8000623c:	e25ff0ef          	jal	80006060 <build_tree>
    
    // Write tree size and tree to output
    if (sizeof(int) + sizeof(struct huffman_node) * tree_size >= maxlen)
    80006240:	00003617          	auipc	a2,0x3
    80006244:	8a862603          	lw	a2,-1880(a2) # 80008ae8 <tree_size>
    80006248:	00461793          	slli	a5,a2,0x4
    8000624c:	0791                	addi	a5,a5,4
    8000624e:	1557f263          	bgeu	a5,s5,80006392 <compress_huffman+0x18e>
    80006252:	e14a                	sd	s2,128(sp)
    80006254:	fcce                	sd	s3,120(sp)
    80006256:	f0da                	sd	s6,96(sp)
    80006258:	ecde                	sd	s7,88(sp)
    8000625a:	e8e2                	sd	s8,80(sp)
    8000625c:	e4e6                	sd	s9,72(sp)
    8000625e:	e0ea                	sd	s10,64(sp)
        return -1;
    
    // Write tree size first
    *(int*)output = tree_size;
    80006260:	00ca2023          	sw	a2,0(s4)
    memmove(output + sizeof(int), tree, sizeof(struct huffman_node) * tree_size);
    80006264:	0046161b          	slliw	a2,a2,0x4
    80006268:	0001c597          	auipc	a1,0x1c
    8000626c:	fb858593          	addi	a1,a1,-72 # 80022220 <tree>
    80006270:	004a0513          	addi	a0,s4,4
    80006274:	abffa0ef          	jal	80000d32 <memmove>
    
    // Compress data
    int byte_pos = sizeof(int) + sizeof(struct huffman_node) * tree_size;
    80006278:	00003717          	auipc	a4,0x3
    8000627c:	87072703          	lw	a4,-1936(a4) # 80008ae8 <tree_size>
    80006280:	0047179b          	slliw	a5,a4,0x4
    80006284:	2791                	addiw	a5,a5,4
    80006286:	f8f42623          	sw	a5,-116(s0)
    int bit_pos = 0;
    8000628a:	f8042423          	sw	zero,-120(s0)
    
    for (int i = 0; i < inlen; i++) {
    8000628e:	f6943c23          	sd	s1,-136(s0)
    80006292:	01b487b3          	add	a5,s1,s11
    80006296:	f6f43423          	sd	a5,-152(s0)
        unsigned char c = input[i];
        int curr_node = tree_size - 1;  // Start from root
    8000629a:	fff7079b          	addiw	a5,a4,-1
    8000629e:	f6f43823          	sd	a5,-144(s0)
        
        // Find character in tree and write path
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    800062a2:	0001c917          	auipc	s2,0x1c
    800062a6:	f7e90913          	addi	s2,s2,-130 # 80022220 <tree>
                
            if (c < tree[tree[curr_node].left].c) {
                write_bit(output, &byte_pos, &bit_pos, 0);
                curr_node = tree[curr_node].left;
            } else {
                write_bit(output, &byte_pos, &bit_pos, 1);
    800062aa:	f8840c13          	addi	s8,s0,-120
    800062ae:	f8c40b93          	addi	s7,s0,-116
        unsigned char c = input[i];
    800062b2:	f7843783          	ld	a5,-136(s0)
    800062b6:	0007cb03          	lbu	s6,0(a5)
        int curr_node = tree_size - 1;  // Start from root
    800062ba:	f7043483          	ld	s1,-144(s0)
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    800062be:	59fd                	li	s3,-1
                write_bit(output, &byte_pos, &bit_pos, 1);
    800062c0:	4d05                	li	s10,1
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    800062c2:	a811                	j	800062d6 <compress_huffman+0xd2>
                write_bit(output, &byte_pos, &bit_pos, 1);
    800062c4:	86ea                	mv	a3,s10
    800062c6:	8662                	mv	a2,s8
    800062c8:	85de                	mv	a1,s7
    800062ca:	8552                	mv	a0,s4
    800062cc:	ee5ff0ef          	jal	800061b0 <write_bit>
                curr_node = tree[curr_node].right;
    800062d0:	0492                	slli	s1,s1,0x4
    800062d2:	94ca                	add	s1,s1,s2
    800062d4:	44c4                	lw	s1,12(s1)
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    800062d6:	00449793          	slli	a5,s1,0x4
    800062da:	97ca                	add	a5,a5,s2
    800062dc:	479c                	lw	a5,8(a5)
    800062de:	03378663          	beq	a5,s3,8000630a <compress_huffman+0x106>
            if (byte_pos >= maxlen)
    800062e2:	f8c42703          	lw	a4,-116(s0)
    800062e6:	0b575863          	bge	a4,s5,80006396 <compress_huffman+0x192>
            if (c < tree[tree[curr_node].left].c) {
    800062ea:	0792                	slli	a5,a5,0x4
    800062ec:	97ca                	add	a5,a5,s2
    800062ee:	0007c783          	lbu	a5,0(a5)
    800062f2:	fcfb79e3          	bgeu	s6,a5,800062c4 <compress_huffman+0xc0>
                write_bit(output, &byte_pos, &bit_pos, 0);
    800062f6:	4681                	li	a3,0
    800062f8:	8662                	mv	a2,s8
    800062fa:	85de                	mv	a1,s7
    800062fc:	8552                	mv	a0,s4
    800062fe:	eb3ff0ef          	jal	800061b0 <write_bit>
                curr_node = tree[curr_node].left;
    80006302:	0492                	slli	s1,s1,0x4
    80006304:	94ca                	add	s1,s1,s2
    80006306:	4484                	lw	s1,8(s1)
    80006308:	b7f9                	j	800062d6 <compress_huffman+0xd2>
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    8000630a:	00449713          	slli	a4,s1,0x4
    8000630e:	974a                	add	a4,a4,s2
    80006310:	00c72c83          	lw	s9,12(a4)
    80006314:	fd3c97e3          	bne	s9,s3,800062e2 <compress_huffman+0xde>
    for (int i = 0; i < inlen; i++) {
    80006318:	f7843783          	ld	a5,-136(s0)
    8000631c:	0785                	addi	a5,a5,1
    8000631e:	f6f43c23          	sd	a5,-136(s0)
    80006322:	f6843703          	ld	a4,-152(s0)
    80006326:	f8e796e3          	bne	a5,a4,800062b2 <compress_huffman+0xae>
            }
        }
    }
    
    // Pad last byte if necessary
    if (bit_pos > 0)
    8000632a:	f8842783          	lw	a5,-120(s0)
    8000632e:	00f05763          	blez	a5,8000633c <compress_huffman+0x138>
        byte_pos++;
    80006332:	f8c42783          	lw	a5,-116(s0)
    80006336:	2785                	addiw	a5,a5,1
    80006338:	f8f42623          	sw	a5,-116(s0)
        
    // Add size checks
    if(byte_pos >= inlen) {
    8000633c:	f8c42483          	lw	s1,-116(s0)
    80006340:	03b4d163          	bge	s1,s11,80006362 <compress_huffman+0x15e>
        printf("Compression ineffective (got %d bytes)\n", byte_pos);
        return -1;
    }
    
    printf("Compressed to %d bytes\n", byte_pos);
    80006344:	85a6                	mv	a1,s1
    80006346:	00002517          	auipc	a0,0x2
    8000634a:	5b250513          	addi	a0,a0,1458 # 800088f8 <etext+0x8f8>
    8000634e:	980fa0ef          	jal	800004ce <printf>
    return byte_pos;
    80006352:	690a                	ld	s2,128(sp)
    80006354:	79e6                	ld	s3,120(sp)
    80006356:	7b06                	ld	s6,96(sp)
    80006358:	6be6                	ld	s7,88(sp)
    8000635a:	6c46                	ld	s8,80(sp)
    8000635c:	6ca6                	ld	s9,72(sp)
    8000635e:	6d06                	ld	s10,64(sp)
    80006360:	a099                	j	800063a6 <compress_huffman+0x1a2>
        printf("Compression ineffective (got %d bytes)\n", byte_pos);
    80006362:	85a6                	mv	a1,s1
    80006364:	00002517          	auipc	a0,0x2
    80006368:	56c50513          	addi	a0,a0,1388 # 800088d0 <etext+0x8d0>
    8000636c:	962fa0ef          	jal	800004ce <printf>
        return -1;
    80006370:	84e6                	mv	s1,s9
    80006372:	690a                	ld	s2,128(sp)
    80006374:	79e6                	ld	s3,120(sp)
    80006376:	7b06                	ld	s6,96(sp)
    80006378:	6be6                	ld	s7,88(sp)
    8000637a:	6c46                	ld	s8,80(sp)
    8000637c:	6ca6                	ld	s9,72(sp)
    8000637e:	6d06                	ld	s10,64(sp)
    80006380:	a01d                	j	800063a6 <compress_huffman+0x1a2>
        return -1;
    80006382:	54fd                	li	s1,-1
    80006384:	a00d                	j	800063a6 <compress_huffman+0x1a2>
    80006386:	54fd                	li	s1,-1
    80006388:	a839                	j	800063a6 <compress_huffman+0x1a2>
    8000638a:	54fd                	li	s1,-1
    8000638c:	a829                	j	800063a6 <compress_huffman+0x1a2>
    8000638e:	54fd                	li	s1,-1
    80006390:	a819                	j	800063a6 <compress_huffman+0x1a2>
        return -1;
    80006392:	54fd                	li	s1,-1
    80006394:	a809                	j	800063a6 <compress_huffman+0x1a2>
                return -1;
    80006396:	54fd                	li	s1,-1
    80006398:	690a                	ld	s2,128(sp)
    8000639a:	79e6                	ld	s3,120(sp)
    8000639c:	7b06                	ld	s6,96(sp)
    8000639e:	6be6                	ld	s7,88(sp)
    800063a0:	6c46                	ld	s8,80(sp)
    800063a2:	6ca6                	ld	s9,72(sp)
    800063a4:	6d06                	ld	s10,64(sp)
}
    800063a6:	8526                	mv	a0,s1
    800063a8:	60ea                	ld	ra,152(sp)
    800063aa:	644a                	ld	s0,144(sp)
    800063ac:	64aa                	ld	s1,136(sp)
    800063ae:	7a46                	ld	s4,112(sp)
    800063b0:	7aa6                	ld	s5,104(sp)
    800063b2:	7de2                	ld	s11,56(sp)
    800063b4:	610d                	addi	sp,sp,160
    800063b6:	8082                	ret

00000000800063b8 <read_bit>:

// Read bit from input buffer
int read_bit(char *input, int *byte_pos, int *bit_pos) {
    800063b8:	1141                	addi	sp,sp,-16
    800063ba:	e406                	sd	ra,8(sp)
    800063bc:	e022                	sd	s0,0(sp)
    800063be:	0800                	addi	s0,sp,16
    int bit = (input[*byte_pos] >> (7 - *bit_pos)) & 1;
    800063c0:	421c                	lw	a5,0(a2)
    800063c2:	4198                	lw	a4,0(a1)
    800063c4:	953a                	add	a0,a0,a4
    800063c6:	00054503          	lbu	a0,0(a0)
    800063ca:	471d                	li	a4,7
    800063cc:	9f1d                	subw	a4,a4,a5
    800063ce:	40e5553b          	sraw	a0,a0,a4
    800063d2:	8905                	andi	a0,a0,1
    *bit_pos = (*bit_pos + 1) % 8;
    800063d4:	2785                	addiw	a5,a5,1
    800063d6:	41f7d69b          	sraiw	a3,a5,0x1f
    800063da:	01d6d69b          	srliw	a3,a3,0x1d
    800063de:	00f6873b          	addw	a4,a3,a5
    800063e2:	8b1d                	andi	a4,a4,7
    800063e4:	9f15                	subw	a4,a4,a3
    800063e6:	c218                	sw	a4,0(a2)
    if (*bit_pos == 0)
    800063e8:	8b9d                	andi	a5,a5,7
    800063ea:	e781                	bnez	a5,800063f2 <read_bit+0x3a>
        (*byte_pos)++;
    800063ec:	419c                	lw	a5,0(a1)
    800063ee:	2785                	addiw	a5,a5,1
    800063f0:	c19c                	sw	a5,0(a1)
    return bit;
}
    800063f2:	60a2                	ld	ra,8(sp)
    800063f4:	6402                	ld	s0,0(sp)
    800063f6:	0141                	addi	sp,sp,16
    800063f8:	8082                	ret

00000000800063fa <decompress_huffman>:

// Decompress using Huffman coding
int decompress_huffman(char *input, int inlen, char *output, int maxlen) {
    800063fa:	7175                	addi	sp,sp,-144
    800063fc:	e506                	sd	ra,136(sp)
    800063fe:	e122                	sd	s0,128(sp)
    80006400:	fc66                	sd	s9,56(sp)
    80006402:	0900                	addi	s0,sp,144
    80006404:	f6c43c23          	sd	a2,-136(s0)
    if (!input || !output || inlen <= 0 || maxlen <= 0)
    80006408:	14050263          	beqz	a0,8000654c <decompress_huffman+0x152>
    8000640c:	ecd6                	sd	s5,88(sp)
    8000640e:	e8da                	sd	s6,80(sp)
    80006410:	f46e                	sd	s11,40(sp)
    80006412:	8b2a                	mv	s6,a0
    80006414:	8aae                	mv	s5,a1
    80006416:	8db6                	mv	s11,a3
    80006418:	12060c63          	beqz	a2,80006550 <decompress_huffman+0x156>
    8000641c:	12b05f63          	blez	a1,8000655a <decompress_huffman+0x160>
    80006420:	14d05263          	blez	a3,80006564 <decompress_huffman+0x16a>
        return -1;

    // Read tree size from input
    tree_size = *(int*)input;
    80006424:	4110                	lw	a2,0(a0)
    80006426:	00002797          	auipc	a5,0x2
    8000642a:	6cc7a123          	sw	a2,1730(a5) # 80008ae8 <tree_size>
    if (tree_size <= 0 || tree_size > MAX_TREE_NODES)
    8000642e:	fff6071b          	addiw	a4,a2,-1
    80006432:	1ff00793          	li	a5,511
    80006436:	12e7ec63          	bltu	a5,a4,8000656e <decompress_huffman+0x174>
        return -1;
        
    // Read tree from input
    if (sizeof(int) + sizeof(struct huffman_node) * tree_size > inlen)
    8000643a:	00461793          	slli	a5,a2,0x4
    8000643e:	0791                	addi	a5,a5,4
    80006440:	12f5ec63          	bltu	a1,a5,80006578 <decompress_huffman+0x17e>
    80006444:	f86a                	sd	s10,48(sp)
        return -1;
        
    memmove(tree, input + sizeof(int), sizeof(struct huffman_node) * tree_size);
    80006446:	0046161b          	slliw	a2,a2,0x4
    8000644a:	00450593          	addi	a1,a0,4
    8000644e:	0001c517          	auipc	a0,0x1c
    80006452:	dd250513          	addi	a0,a0,-558 # 80022220 <tree>
    80006456:	8ddfa0ef          	jal	80000d32 <memmove>
    
    // Decompress data
    int in_pos = sizeof(int) + sizeof(struct huffman_node) * tree_size;
    8000645a:	00002d17          	auipc	s10,0x2
    8000645e:	68ed2d03          	lw	s10,1678(s10) # 80008ae8 <tree_size>
    80006462:	004d179b          	slliw	a5,s10,0x4
    80006466:	2791                	addiw	a5,a5,4
    80006468:	f8f42623          	sw	a5,-116(s0)
    int out_pos = 0;
    int bit_pos = 0;
    8000646c:	f8042423          	sw	zero,-120(s0)
    
    while (in_pos < inlen && out_pos < maxlen) {
    80006470:	1157d963          	bge	a5,s5,80006582 <decompress_huffman+0x188>
    80006474:	fca6                	sd	s1,120(sp)
    80006476:	f8ca                	sd	s2,112(sp)
    80006478:	f4ce                	sd	s3,104(sp)
    8000647a:	f0d2                	sd	s4,96(sp)
    8000647c:	e4de                	sd	s7,72(sp)
    8000647e:	e0e2                	sd	s8,64(sp)
    int out_pos = 0;
    80006480:	4c81                	li	s9,0
        int curr_node = tree_size - 1;  // Start from root
    80006482:	3d7d                	addiw	s10,s10,-1
        
        // Traverse tree until leaf
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    80006484:	0001c997          	auipc	s3,0x1c
    80006488:	d9c98993          	addi	s3,s3,-612 # 80022220 <tree>
            if (in_pos >= inlen)
                break;
                
            int bit = read_bit(input, &in_pos, &bit_pos);
    8000648c:	f8840c13          	addi	s8,s0,-120
    80006490:	f8c40b93          	addi	s7,s0,-116
    80006494:	a8ad                	j	8000650e <decompress_huffman+0x114>
    int out_pos = 0;
    80006496:	84ca                	mv	s1,s2
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    80006498:	00449793          	slli	a5,s1,0x4
    8000649c:	97ce                	add	a5,a5,s3
    8000649e:	0087a903          	lw	s2,8(a5)
    800064a2:	03490163          	beq	s2,s4,800064c4 <decompress_huffman+0xca>
            if (in_pos >= inlen)
    800064a6:	f8c42783          	lw	a5,-116(s0)
    800064aa:	0f57dd63          	bge	a5,s5,800065a4 <decompress_huffman+0x1aa>
            int bit = read_bit(input, &in_pos, &bit_pos);
    800064ae:	8662                	mv	a2,s8
    800064b0:	85de                	mv	a1,s7
    800064b2:	855a                	mv	a0,s6
    800064b4:	f05ff0ef          	jal	800063b8 <read_bit>
            curr_node = bit ? tree[curr_node].right : tree[curr_node].left;
    800064b8:	dd79                	beqz	a0,80006496 <decompress_huffman+0x9c>
    800064ba:	0492                	slli	s1,s1,0x4
    800064bc:	94ce                	add	s1,s1,s3
    800064be:	00c4a903          	lw	s2,12(s1)
    800064c2:	bfd1                	j	80006496 <decompress_huffman+0x9c>
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    800064c4:	00449793          	slli	a5,s1,0x4
    800064c8:	97ce                	add	a5,a5,s3
    800064ca:	47dc                	lw	a5,12(a5)
    800064cc:	05478463          	beq	a5,s4,80006514 <decompress_huffman+0x11a>
            if (in_pos >= inlen)
    800064d0:	f8c42783          	lw	a5,-116(s0)
    800064d4:	fd57cde3          	blt	a5,s5,800064ae <decompress_huffman+0xb4>
        }
        
        if (tree[curr_node].left == -1 && tree[curr_node].right == -1)
    800064d8:	57fd                	li	a5,-1
    800064da:	0ef91b63          	bne	s2,a5,800065d0 <decompress_huffman+0x1d6>
    800064de:	00449793          	slli	a5,s1,0x4
    800064e2:	97ce                	add	a5,a5,s3
    800064e4:	47d8                	lw	a4,12(a5)
    800064e6:	57fd                	li	a5,-1
    800064e8:	0af71363          	bne	a4,a5,8000658e <decompress_huffman+0x194>
            output[out_pos++] = tree[curr_node].c;
    800064ec:	00449793          	slli	a5,s1,0x4
    800064f0:	97ce                	add	a5,a5,s3
    800064f2:	0007c703          	lbu	a4,0(a5)
    800064f6:	f7843783          	ld	a5,-136(s0)
    800064fa:	97e6                	add	a5,a5,s9
    800064fc:	00e78023          	sb	a4,0(a5)
    80006500:	2c85                	addiw	s9,s9,1
    while (in_pos < inlen && out_pos < maxlen) {
    80006502:	f8c42783          	lw	a5,-116(s0)
    80006506:	0b57da63          	bge	a5,s5,800065ba <decompress_huffman+0x1c0>
    8000650a:	03bcd163          	bge	s9,s11,8000652c <decompress_huffman+0x132>
        int curr_node = tree_size - 1;  // Start from root
    8000650e:	84ea                	mv	s1,s10
        while (tree[curr_node].left != -1 || tree[curr_node].right != -1) {
    80006510:	5a7d                	li	s4,-1
    80006512:	b759                	j	80006498 <decompress_huffman+0x9e>
        if (tree[curr_node].left == -1 && tree[curr_node].right == -1)
    80006514:	00449713          	slli	a4,s1,0x4
    80006518:	0001c797          	auipc	a5,0x1c
    8000651c:	d0878793          	addi	a5,a5,-760 # 80022220 <tree>
    80006520:	97ba                	add	a5,a5,a4
    80006522:	47d8                	lw	a4,12(a5)
    80006524:	57fd                	li	a5,-1
    80006526:	fcf71ee3          	bne	a4,a5,80006502 <decompress_huffman+0x108>
    8000652a:	b7c9                	j	800064ec <decompress_huffman+0xf2>
    8000652c:	74e6                	ld	s1,120(sp)
    8000652e:	7946                	ld	s2,112(sp)
    80006530:	79a6                	ld	s3,104(sp)
    80006532:	7a06                	ld	s4,96(sp)
    80006534:	6ae6                	ld	s5,88(sp)
    80006536:	6b46                	ld	s6,80(sp)
    80006538:	6ba6                	ld	s7,72(sp)
    8000653a:	6c06                	ld	s8,64(sp)
    8000653c:	7d42                	ld	s10,48(sp)
    8000653e:	7da2                	ld	s11,40(sp)
    }
    
    return out_pos;
}
    80006540:	8566                	mv	a0,s9
    80006542:	60aa                	ld	ra,136(sp)
    80006544:	640a                	ld	s0,128(sp)
    80006546:	7ce2                	ld	s9,56(sp)
    80006548:	6149                	addi	sp,sp,144
    8000654a:	8082                	ret
        return -1;
    8000654c:	5cfd                	li	s9,-1
    8000654e:	bfcd                	j	80006540 <decompress_huffman+0x146>
    80006550:	5cfd                	li	s9,-1
    80006552:	6ae6                	ld	s5,88(sp)
    80006554:	6b46                	ld	s6,80(sp)
    80006556:	7da2                	ld	s11,40(sp)
    80006558:	b7e5                	j	80006540 <decompress_huffman+0x146>
    8000655a:	5cfd                	li	s9,-1
    8000655c:	6ae6                	ld	s5,88(sp)
    8000655e:	6b46                	ld	s6,80(sp)
    80006560:	7da2                	ld	s11,40(sp)
    80006562:	bff9                	j	80006540 <decompress_huffman+0x146>
    80006564:	5cfd                	li	s9,-1
    80006566:	6ae6                	ld	s5,88(sp)
    80006568:	6b46                	ld	s6,80(sp)
    8000656a:	7da2                	ld	s11,40(sp)
    8000656c:	bfd1                	j	80006540 <decompress_huffman+0x146>
        return -1;
    8000656e:	5cfd                	li	s9,-1
    80006570:	6ae6                	ld	s5,88(sp)
    80006572:	6b46                	ld	s6,80(sp)
    80006574:	7da2                	ld	s11,40(sp)
    80006576:	b7e9                	j	80006540 <decompress_huffman+0x146>
        return -1;
    80006578:	5cfd                	li	s9,-1
    8000657a:	6ae6                	ld	s5,88(sp)
    8000657c:	6b46                	ld	s6,80(sp)
    8000657e:	7da2                	ld	s11,40(sp)
    80006580:	b7c1                	j	80006540 <decompress_huffman+0x146>
    return out_pos;
    80006582:	4c81                	li	s9,0
    80006584:	6ae6                	ld	s5,88(sp)
    80006586:	6b46                	ld	s6,80(sp)
    80006588:	7d42                	ld	s10,48(sp)
    8000658a:	7da2                	ld	s11,40(sp)
    8000658c:	bf55                	j	80006540 <decompress_huffman+0x146>
    8000658e:	74e6                	ld	s1,120(sp)
    80006590:	7946                	ld	s2,112(sp)
    80006592:	79a6                	ld	s3,104(sp)
    80006594:	7a06                	ld	s4,96(sp)
    80006596:	6ae6                	ld	s5,88(sp)
    80006598:	6b46                	ld	s6,80(sp)
    8000659a:	6ba6                	ld	s7,72(sp)
    8000659c:	6c06                	ld	s8,64(sp)
    8000659e:	7d42                	ld	s10,48(sp)
    800065a0:	7da2                	ld	s11,40(sp)
    800065a2:	bf79                	j	80006540 <decompress_huffman+0x146>
    800065a4:	74e6                	ld	s1,120(sp)
    800065a6:	7946                	ld	s2,112(sp)
    800065a8:	79a6                	ld	s3,104(sp)
    800065aa:	7a06                	ld	s4,96(sp)
    800065ac:	6ae6                	ld	s5,88(sp)
    800065ae:	6b46                	ld	s6,80(sp)
    800065b0:	6ba6                	ld	s7,72(sp)
    800065b2:	6c06                	ld	s8,64(sp)
    800065b4:	7d42                	ld	s10,48(sp)
    800065b6:	7da2                	ld	s11,40(sp)
    800065b8:	b761                	j	80006540 <decompress_huffman+0x146>
    800065ba:	74e6                	ld	s1,120(sp)
    800065bc:	7946                	ld	s2,112(sp)
    800065be:	79a6                	ld	s3,104(sp)
    800065c0:	7a06                	ld	s4,96(sp)
    800065c2:	6ae6                	ld	s5,88(sp)
    800065c4:	6b46                	ld	s6,80(sp)
    800065c6:	6ba6                	ld	s7,72(sp)
    800065c8:	6c06                	ld	s8,64(sp)
    800065ca:	7d42                	ld	s10,48(sp)
    800065cc:	7da2                	ld	s11,40(sp)
    800065ce:	bf8d                	j	80006540 <decompress_huffman+0x146>
    800065d0:	74e6                	ld	s1,120(sp)
    800065d2:	7946                	ld	s2,112(sp)
    800065d4:	79a6                	ld	s3,104(sp)
    800065d6:	7a06                	ld	s4,96(sp)
    800065d8:	6ae6                	ld	s5,88(sp)
    800065da:	6b46                	ld	s6,80(sp)
    800065dc:	6ba6                	ld	s7,72(sp)
    800065de:	6c06                	ld	s8,64(sp)
    800065e0:	7d42                	ld	s10,48(sp)
    800065e2:	7da2                	ld	s11,40(sp)
    800065e4:	bfb1                	j	80006540 <decompress_huffman+0x146>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
