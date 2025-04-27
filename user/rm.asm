
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	32c000ef          	jal	354 <unlink>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2cc000ef          	jal	304 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8a058593          	addi	a1,a1,-1888 # 8e0 <malloc+0xfa>
  48:	4509                	li	a0,2
  4a:	6ba000ef          	jal	704 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2b4000ef          	jal	304 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	8a258593          	addi	a1,a1,-1886 # 8f8 <malloc+0x112>
  5e:	4509                	li	a0,2
  60:	6a4000ef          	jal	704 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	290000ef          	jal	304 <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	87aa                	mv	a5,a0
  82:	0585                	addi	a1,a1,1
  84:	0785                	addi	a5,a5,1
  86:	fff5c703          	lbu	a4,-1(a1)
  8a:	fee78fa3          	sb	a4,-1(a5)
  8e:	fb75                	bnez	a4,82 <strcpy+0xa>
    ;
  return os;
}
  90:	60a2                	ld	ra,8(sp)
  92:	6402                	ld	s0,0(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x20>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x20>
    p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf99                	beqz	a5,f2 <strlen+0x2a>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x12>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfdd                	j	ea <strlen+0x22>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fe:	ca19                	beqz	a2,114 <memset+0x1e>
 100:	87aa                	mv	a5,a0
 102:	1602                	slli	a2,a2,0x20
 104:	9201                	srli	a2,a2,0x20
 106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x14>
  }
  return dst;
}
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char*
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  for(; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf81                	beqz	a5,140 <strchr+0x24>
    if(*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1c>
  for(; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xe>
      return (char*)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfdd                	j	138 <strchr+0x1c>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	7159                	addi	sp,sp,-112
 146:	f486                	sd	ra,104(sp)
 148:	f0a2                	sd	s0,96(sp)
 14a:	eca6                	sd	s1,88(sp)
 14c:	e8ca                	sd	s2,80(sp)
 14e:	e4ce                	sd	s3,72(sp)
 150:	e0d2                	sd	s4,64(sp)
 152:	fc56                	sd	s5,56(sp)
 154:	f85a                	sd	s6,48(sp)
 156:	f45e                	sd	s7,40(sp)
 158:	f062                	sd	s8,32(sp)
 15a:	ec66                	sd	s9,24(sp)
 15c:	e86a                	sd	s10,16(sp)
 15e:	1880                	addi	s0,sp,112
 160:	8caa                	mv	s9,a0
 162:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
    cc = read(0, &c, 1);
 168:	f9f40b13          	addi	s6,s0,-97
 16c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16e:	4ba9                	li	s7,10
 170:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 172:	8d26                	mv	s10,s1
 174:	0014899b          	addiw	s3,s1,1
 178:	84ce                	mv	s1,s3
 17a:	0349d563          	bge	s3,s4,1a4 <gets+0x60>
    cc = read(0, &c, 1);
 17e:	8656                	mv	a2,s5
 180:	85da                	mv	a1,s6
 182:	4501                	li	a0,0
 184:	198000ef          	jal	31c <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x60>
    buf[i++] = c;
 18c:	f9f44783          	lbu	a5,-97(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01778763          	beq	a5,s7,1a2 <gets+0x5e>
 198:	0905                	addi	s2,s2,1
 19a:	fd879ce3          	bne	a5,s8,172 <gets+0x2e>
    buf[i++] = c;
 19e:	8d4e                	mv	s10,s3
 1a0:	a011                	j	1a4 <gets+0x60>
 1a2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1a4:	9d66                	add	s10,s10,s9
 1a6:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1aa:	8566                	mv	a0,s9
 1ac:	70a6                	ld	ra,104(sp)
 1ae:	7406                	ld	s0,96(sp)
 1b0:	64e6                	ld	s1,88(sp)
 1b2:	6946                	ld	s2,80(sp)
 1b4:	69a6                	ld	s3,72(sp)
 1b6:	6a06                	ld	s4,64(sp)
 1b8:	7ae2                	ld	s5,56(sp)
 1ba:	7b42                	ld	s6,48(sp)
 1bc:	7ba2                	ld	s7,40(sp)
 1be:	7c02                	ld	s8,32(sp)
 1c0:	6ce2                	ld	s9,24(sp)
 1c2:	6d42                	ld	s10,16(sp)
 1c4:	6165                	addi	sp,sp,112
 1c6:	8082                	ret

00000000000001c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	e04a                	sd	s2,0(sp)
 1d0:	1000                	addi	s0,sp,32
 1d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d4:	4581                	li	a1,0
 1d6:	16e000ef          	jal	344 <open>
  if(fd < 0)
 1da:	02054263          	bltz	a0,1fe <stat+0x36>
 1de:	e426                	sd	s1,8(sp)
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	178000ef          	jal	35c <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	140000ef          	jal	32c <close>
  return r;
 1f0:	64a2                	ld	s1,8(sp)
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfcd                	j	1f2 <stat+0x2a>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66963          	bltu	a2,a5,24a <atoi+0x48>
 21c:	872a                	mv	a4,a0
  n = 0;
 21e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1e>
  return n;
}
 242:	60a2                	ld	ra,8(sp)
 244:	6402                	ld	s0,0(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfdd                	j	242 <atoi+0x40>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 256:	02b57563          	bgeu	a0,a1,280 <memmove+0x32>
    while(n-- > 0)
 25a:	00c05f63          	blez	a2,278 <memmove+0x2a>
 25e:	1602                	slli	a2,a2,0x20
 260:	9201                	srli	a2,a2,0x20
 262:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 266:	872a                	mv	a4,a0
      *dst++ = *src++;
 268:	0585                	addi	a1,a1,1
 26a:	0705                	addi	a4,a4,1
 26c:	fff5c683          	lbu	a3,-1(a1)
 270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec059e3          	blez	a2,278 <memmove+0x2a>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fef71ae3          	bne	a4,a5,298 <memmove+0x4a>
 2a8:	bfc1                	j	278 <memmove+0x2a>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b2:	ca0d                	beqz	a2,2e4 <memcmp+0x3a>
 2b4:	fff6069b          	addiw	a3,a2,-1
 2b8:	1682                	slli	a3,a3,0x20
 2ba:	9281                	srli	a3,a3,0x20
 2bc:	0685                	addi	a3,a3,1
 2be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2cc:	0505                	addi	a0,a0,1
    p2++;
 2ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x16>
  }
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x32>
      return *p1 - *p2;
 2d8:	40e7853b          	subw	a0,a5,a4
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  return 0;
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <memcmp+0x32>

00000000000002e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f0:	f5fff0ef          	jal	24e <memmove>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <ps>:
.global ps
ps:
 li a7, SYS_ps
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 3bc:	48e5                	li	a7,25
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 3c4:	48e9                	li	a7,26
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	addi	a1,s0,-17
 3de:	f47ff0ef          	jal	324 <write>
}
 3e2:	60e2                	ld	ra,24(sp)
 3e4:	6442                	ld	s0,16(sp)
 3e6:	6105                	addi	sp,sp,32
 3e8:	8082                	ret

00000000000003ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ea:	7139                	addi	sp,sp,-64
 3ec:	fc06                	sd	ra,56(sp)
 3ee:	f822                	sd	s0,48(sp)
 3f0:	f426                	sd	s1,40(sp)
 3f2:	f04a                	sd	s2,32(sp)
 3f4:	ec4e                	sd	s3,24(sp)
 3f6:	0080                	addi	s0,sp,64
 3f8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fa:	c299                	beqz	a3,400 <printint+0x16>
 3fc:	0605ce63          	bltz	a1,478 <printint+0x8e>
  neg = 0;
 400:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 402:	fc040313          	addi	t1,s0,-64
  neg = 0;
 406:	869a                	mv	a3,t1
  i = 0;
 408:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 40a:	00000817          	auipc	a6,0x0
 40e:	51680813          	addi	a6,a6,1302 # 920 <digits>
 412:	88be                	mv	a7,a5
 414:	0017851b          	addiw	a0,a5,1
 418:	87aa                	mv	a5,a0
 41a:	02c5f73b          	remuw	a4,a1,a2
 41e:	1702                	slli	a4,a4,0x20
 420:	9301                	srli	a4,a4,0x20
 422:	9742                	add	a4,a4,a6
 424:	00074703          	lbu	a4,0(a4)
 428:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 42c:	872e                	mv	a4,a1
 42e:	02c5d5bb          	divuw	a1,a1,a2
 432:	0685                	addi	a3,a3,1
 434:	fcc77fe3          	bgeu	a4,a2,412 <printint+0x28>
  if(neg)
 438:	000e0c63          	beqz	t3,450 <printint+0x66>
    buf[i++] = '-';
 43c:	fd050793          	addi	a5,a0,-48
 440:	00878533          	add	a0,a5,s0
 444:	02d00793          	li	a5,45
 448:	fef50823          	sb	a5,-16(a0)
 44c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 450:	fff7899b          	addiw	s3,a5,-1
 454:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 458:	fff4c583          	lbu	a1,-1(s1)
 45c:	854a                	mv	a0,s2
 45e:	f6fff0ef          	jal	3cc <putc>
  while(--i >= 0)
 462:	39fd                	addiw	s3,s3,-1
 464:	14fd                	addi	s1,s1,-1
 466:	fe09d9e3          	bgez	s3,458 <printint+0x6e>
}
 46a:	70e2                	ld	ra,56(sp)
 46c:	7442                	ld	s0,48(sp)
 46e:	74a2                	ld	s1,40(sp)
 470:	7902                	ld	s2,32(sp)
 472:	69e2                	ld	s3,24(sp)
 474:	6121                	addi	sp,sp,64
 476:	8082                	ret
    x = -xx;
 478:	40b005bb          	negw	a1,a1
    neg = 1;
 47c:	4e05                	li	t3,1
    x = -xx;
 47e:	b751                	j	402 <printint+0x18>

0000000000000480 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 480:	711d                	addi	sp,sp,-96
 482:	ec86                	sd	ra,88(sp)
 484:	e8a2                	sd	s0,80(sp)
 486:	e4a6                	sd	s1,72(sp)
 488:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48a:	0005c483          	lbu	s1,0(a1)
 48e:	26048663          	beqz	s1,6fa <vprintf+0x27a>
 492:	e0ca                	sd	s2,64(sp)
 494:	fc4e                	sd	s3,56(sp)
 496:	f852                	sd	s4,48(sp)
 498:	f456                	sd	s5,40(sp)
 49a:	f05a                	sd	s6,32(sp)
 49c:	ec5e                	sd	s7,24(sp)
 49e:	e862                	sd	s8,16(sp)
 4a0:	e466                	sd	s9,8(sp)
 4a2:	8b2a                	mv	s6,a0
 4a4:	8a2e                	mv	s4,a1
 4a6:	8bb2                	mv	s7,a2
  state = 0;
 4a8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4aa:	4901                	li	s2,0
 4ac:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b6:	06c00c93          	li	s9,108
 4ba:	a00d                	j	4dc <vprintf+0x5c>
        putc(fd, c0);
 4bc:	85a6                	mv	a1,s1
 4be:	855a                	mv	a0,s6
 4c0:	f0dff0ef          	jal	3cc <putc>
 4c4:	a019                	j	4ca <vprintf+0x4a>
    } else if(state == '%'){
 4c6:	03598363          	beq	s3,s5,4ec <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4ca:	0019079b          	addiw	a5,s2,1
 4ce:	893e                	mv	s2,a5
 4d0:	873e                	mv	a4,a5
 4d2:	97d2                	add	a5,a5,s4
 4d4:	0007c483          	lbu	s1,0(a5)
 4d8:	20048963          	beqz	s1,6ea <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4dc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4e0:	fe0993e3          	bnez	s3,4c6 <vprintf+0x46>
      if(c0 == '%'){
 4e4:	fd579ce3          	bne	a5,s5,4bc <vprintf+0x3c>
        state = '%';
 4e8:	89be                	mv	s3,a5
 4ea:	b7c5                	j	4ca <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ec:	00ea06b3          	add	a3,s4,a4
 4f0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f6:	c681                	beqz	a3,4fe <vprintf+0x7e>
 4f8:	9752                	add	a4,a4,s4
 4fa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4fe:	03878e63          	beq	a5,s8,53a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	05978863          	beq	a5,s9,552 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 506:	07500713          	li	a4,117
 50a:	0ee78263          	beq	a5,a4,5ee <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50e:	07800713          	li	a4,120
 512:	12e78463          	beq	a5,a4,63a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 516:	07000713          	li	a4,112
 51a:	14e78963          	beq	a5,a4,66c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 51e:	07300713          	li	a4,115
 522:	18e78863          	beq	a5,a4,6b2 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 526:	02500713          	li	a4,37
 52a:	04e79463          	bne	a5,a4,572 <vprintf+0xf2>
        putc(fd, '%');
 52e:	85ba                	mv	a1,a4
 530:	855a                	mv	a0,s6
 532:	e9bff0ef          	jal	3cc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 536:	4981                	li	s3,0
 538:	bf49                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 53a:	008b8493          	addi	s1,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	ea3ff0ef          	jal	3ea <printint>
 54c:	8ba6                	mv	s7,s1
      state = 0;
 54e:	4981                	li	s3,0
 550:	bfad                	j	4ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 552:	06400793          	li	a5,100
 556:	02f68963          	beq	a3,a5,588 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55a:	06c00793          	li	a5,108
 55e:	04f68263          	beq	a3,a5,5a2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 562:	07500793          	li	a5,117
 566:	0af68063          	beq	a3,a5,606 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 56a:	07800793          	li	a5,120
 56e:	0ef68263          	beq	a3,a5,652 <vprintf+0x1d2>
        putc(fd, '%');
 572:	02500593          	li	a1,37
 576:	855a                	mv	a0,s6
 578:	e55ff0ef          	jal	3cc <putc>
        putc(fd, c0);
 57c:	85a6                	mv	a1,s1
 57e:	855a                	mv	a0,s6
 580:	e4dff0ef          	jal	3cc <putc>
      state = 0;
 584:	4981                	li	s3,0
 586:	b791                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	008b8493          	addi	s1,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e55ff0ef          	jal	3ea <printint>
        i += 1;
 59a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
        i += 1;
 5a0:	b72d                	j	4ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a2:	06400793          	li	a5,100
 5a6:	02f60763          	beq	a2,a5,5d4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5aa:	07500793          	li	a5,117
 5ae:	06f60963          	beq	a2,a5,620 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b2:	07800793          	li	a5,120
 5b6:	faf61ee3          	bne	a2,a5,572 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e23ff0ef          	jal	3ea <printint>
        i += 2;
 5cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
        i += 2;
 5d2:	bde5                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	e09ff0ef          	jal	3ea <printint>
        i += 2;
 5e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
        i += 2;
 5ec:	bdf9                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	defff0ef          	jal	3ea <printint>
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
 604:	b5d9                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	dd7ff0ef          	jal	3ea <printint>
        i += 1;
 618:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
        i += 1;
 61e:	b575                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	dbdff0ef          	jal	3ea <printint>
        i += 2;
 632:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	bd49                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	da3ff0ef          	jal	3ea <printint>
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	bdad                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	008b8493          	addi	s1,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000ba583          	lw	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d8bff0ef          	jal	3ea <printint>
        i += 1;
 664:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
        i += 1;
 66a:	b585                	j	4ca <vprintf+0x4a>
 66c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66e:	008b8d13          	addi	s10,s7,8
 672:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 676:	03000593          	li	a1,48
 67a:	855a                	mv	a0,s6
 67c:	d51ff0ef          	jal	3cc <putc>
  putc(fd, 'x');
 680:	07800593          	li	a1,120
 684:	855a                	mv	a0,s6
 686:	d47ff0ef          	jal	3cc <putc>
 68a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68c:	00000b97          	auipc	s7,0x0
 690:	294b8b93          	addi	s7,s7,660 # 920 <digits>
 694:	03c9d793          	srli	a5,s3,0x3c
 698:	97de                	add	a5,a5,s7
 69a:	0007c583          	lbu	a1,0(a5)
 69e:	855a                	mv	a0,s6
 6a0:	d2dff0ef          	jal	3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a4:	0992                	slli	s3,s3,0x4
 6a6:	34fd                	addiw	s1,s1,-1
 6a8:	f4f5                	bnez	s1,694 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6aa:	8bea                	mv	s7,s10
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	6d02                	ld	s10,0(sp)
 6b0:	bd29                	j	4ca <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	008b8993          	addi	s3,s7,8
 6b6:	000bb483          	ld	s1,0(s7)
 6ba:	cc91                	beqz	s1,6d6 <vprintf+0x256>
        for(; *s; s++)
 6bc:	0004c583          	lbu	a1,0(s1)
 6c0:	c195                	beqz	a1,6e4 <vprintf+0x264>
          putc(fd, *s);
 6c2:	855a                	mv	a0,s6
 6c4:	d09ff0ef          	jal	3cc <putc>
        for(; *s; s++)
 6c8:	0485                	addi	s1,s1,1
 6ca:	0004c583          	lbu	a1,0(s1)
 6ce:	f9f5                	bnez	a1,6c2 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bbdd                	j	4ca <vprintf+0x4a>
          s = "(null)";
 6d6:	00000497          	auipc	s1,0x0
 6da:	24248493          	addi	s1,s1,578 # 918 <malloc+0x132>
        for(; *s; s++)
 6de:	02800593          	li	a1,40
 6e2:	b7c5                	j	6c2 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b3cd                	j	4ca <vprintf+0x4a>
 6ea:	6906                	ld	s2,64(sp)
 6ec:	79e2                	ld	s3,56(sp)
 6ee:	7a42                	ld	s4,48(sp)
 6f0:	7aa2                	ld	s5,40(sp)
 6f2:	7b02                	ld	s6,32(sp)
 6f4:	6be2                	ld	s7,24(sp)
 6f6:	6c42                	ld	s8,16(sp)
 6f8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6fa:	60e6                	ld	ra,88(sp)
 6fc:	6446                	ld	s0,80(sp)
 6fe:	64a6                	ld	s1,72(sp)
 700:	6125                	addi	sp,sp,96
 702:	8082                	ret

0000000000000704 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 704:	715d                	addi	sp,sp,-80
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	addi	s0,sp,32
 70c:	e010                	sd	a2,0(s0)
 70e:	e414                	sd	a3,8(s0)
 710:	e818                	sd	a4,16(s0)
 712:	ec1c                	sd	a5,24(s0)
 714:	03043023          	sd	a6,32(s0)
 718:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	8622                	mv	a2,s0
 71e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 722:	d5fff0ef          	jal	480 <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6161                	addi	sp,sp,80
 72c:	8082                	ret

000000000000072e <printf>:

void
printf(const char *fmt, ...)
{
 72e:	711d                	addi	sp,sp,-96
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	1000                	addi	s0,sp,32
 736:	e40c                	sd	a1,8(s0)
 738:	e810                	sd	a2,16(s0)
 73a:	ec14                	sd	a3,24(s0)
 73c:	f018                	sd	a4,32(s0)
 73e:	f41c                	sd	a5,40(s0)
 740:	03043823          	sd	a6,48(s0)
 744:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	00840613          	addi	a2,s0,8
 74c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 750:	85aa                	mv	a1,a0
 752:	4505                	li	a0,1
 754:	d2dff0ef          	jal	480 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6125                	addi	sp,sp,96
 75e:	8082                	ret

0000000000000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	1141                	addi	sp,sp,-16
 762:	e406                	sd	ra,8(sp)
 764:	e022                	sd	s0,0(sp)
 766:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 768:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	00001797          	auipc	a5,0x1
 770:	8947b783          	ld	a5,-1900(a5) # 1000 <freep>
 774:	a02d                	j	79e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 776:	4618                	lw	a4,8(a2)
 778:	9f2d                	addw	a4,a4,a1
 77a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77e:	6398                	ld	a4,0(a5)
 780:	6310                	ld	a2,0(a4)
 782:	a83d                	j	7c0 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 784:	ff852703          	lw	a4,-8(a0)
 788:	9f31                	addw	a4,a4,a2
 78a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78c:	ff053683          	ld	a3,-16(a0)
 790:	a091                	j	7d4 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	6398                	ld	a4,0(a5)
 794:	00e7e463          	bltu	a5,a4,79c <free+0x3c>
 798:	00e6ea63          	bltu	a3,a4,7ac <free+0x4c>
{
 79c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	fed7fae3          	bgeu	a5,a3,792 <free+0x32>
 7a2:	6398                	ld	a4,0(a5)
 7a4:	00e6e463          	bltu	a3,a4,7ac <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	fee7eae3          	bltu	a5,a4,79c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7ac:	ff852583          	lw	a1,-8(a0)
 7b0:	6390                	ld	a2,0(a5)
 7b2:	02059813          	slli	a6,a1,0x20
 7b6:	01c85713          	srli	a4,a6,0x1c
 7ba:	9736                	add	a4,a4,a3
 7bc:	fae60de3          	beq	a2,a4,776 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c4:	4790                	lw	a2,8(a5)
 7c6:	02061593          	slli	a1,a2,0x20
 7ca:	01c5d713          	srli	a4,a1,0x1c
 7ce:	973e                	add	a4,a4,a5
 7d0:	fae68ae3          	beq	a3,a4,784 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d6:	00001717          	auipc	a4,0x1
 7da:	82f73523          	sd	a5,-2006(a4) # 1000 <freep>
}
 7de:	60a2                	ld	ra,8(sp)
 7e0:	6402                	ld	s0,0(sp)
 7e2:	0141                	addi	sp,sp,16
 7e4:	8082                	ret

00000000000007e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e6:	7139                	addi	sp,sp,-64
 7e8:	fc06                	sd	ra,56(sp)
 7ea:	f822                	sd	s0,48(sp)
 7ec:	f04a                	sd	s2,32(sp)
 7ee:	ec4e                	sd	s3,24(sp)
 7f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	02051993          	slli	s3,a0,0x20
 7f6:	0209d993          	srli	s3,s3,0x20
 7fa:	09bd                	addi	s3,s3,15
 7fc:	0049d993          	srli	s3,s3,0x4
 800:	2985                	addiw	s3,s3,1
 802:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 804:	00000517          	auipc	a0,0x0
 808:	7fc53503          	ld	a0,2044(a0) # 1000 <freep>
 80c:	c905                	beqz	a0,83c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	09377663          	bgeu	a4,s3,89e <malloc+0xb8>
 816:	f426                	sd	s1,40(sp)
 818:	e852                	sd	s4,16(sp)
 81a:	e456                	sd	s5,8(sp)
 81c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81e:	8a4e                	mv	s4,s3
 820:	6705                	lui	a4,0x1
 822:	00e9f363          	bgeu	s3,a4,828 <malloc+0x42>
 826:	6a05                	lui	s4,0x1
 828:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 830:	00000497          	auipc	s1,0x0
 834:	7d048493          	addi	s1,s1,2000 # 1000 <freep>
  if(p == (char*)-1)
 838:	5afd                	li	s5,-1
 83a:	a83d                	j	878 <malloc+0x92>
 83c:	f426                	sd	s1,40(sp)
 83e:	e852                	sd	s4,16(sp)
 840:	e456                	sd	s5,8(sp)
 842:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 844:	00000797          	auipc	a5,0x0
 848:	7cc78793          	addi	a5,a5,1996 # 1010 <base>
 84c:	00000717          	auipc	a4,0x0
 850:	7af73a23          	sd	a5,1972(a4) # 1000 <freep>
 854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85a:	b7d1                	j	81e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 85c:	6398                	ld	a4,0(a5)
 85e:	e118                	sd	a4,0(a0)
 860:	a899                	j	8b6 <malloc+0xd0>
  hp->s.size = nu;
 862:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 866:	0541                	addi	a0,a0,16
 868:	ef9ff0ef          	jal	760 <free>
  return freep;
 86c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 86e:	c125                	beqz	a0,8ce <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 872:	4798                	lw	a4,8(a5)
 874:	03277163          	bgeu	a4,s2,896 <malloc+0xb0>
    if(p == freep)
 878:	6098                	ld	a4,0(s1)
 87a:	853e                	mv	a0,a5
 87c:	fef71ae3          	bne	a4,a5,870 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 880:	8552                	mv	a0,s4
 882:	b0bff0ef          	jal	38c <sbrk>
  if(p == (char*)-1)
 886:	fd551ee3          	bne	a0,s5,862 <malloc+0x7c>
        return 0;
 88a:	4501                	li	a0,0
 88c:	74a2                	ld	s1,40(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	a03d                	j	8c2 <malloc+0xdc>
 896:	74a2                	ld	s1,40(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89e:	fae90fe3          	beq	s2,a4,85c <malloc+0x76>
        p->s.size -= nunits;
 8a2:	4137073b          	subw	a4,a4,s3
 8a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a8:	02071693          	slli	a3,a4,0x20
 8ac:	01c6d713          	srli	a4,a3,0x1c
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74a73523          	sd	a0,1866(a4) # 1000 <freep>
      return (void*)(p + 1);
 8be:	01078513          	addi	a0,a5,16
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	7902                	ld	s2,32(sp)
 8c8:	69e2                	ld	s3,24(sp)
 8ca:	6121                	addi	sp,sp,64
 8cc:	8082                	ret
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	b7f5                	j	8c2 <malloc+0xdc>
