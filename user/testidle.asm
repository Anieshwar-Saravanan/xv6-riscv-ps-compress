
user/_testidle:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    int pid = getidlepid();
   8:	382000ef          	jal	38a <getidlepid>
    if(pid == -1)
   c:	57fd                	li	a5,-1
   e:	00f50c63          	beq	a0,a5,26 <main+0x26>
  12:	85aa                	mv	a1,a0
        printf("No idle process found.\n");
    else
        printf("Idle process PID: %d\n", pid);
  14:	00001517          	auipc	a0,0x1
  18:	8b450513          	addi	a0,a0,-1868 # 8c8 <malloc+0x114>
  1c:	6e0000ef          	jal	6fc <printf>
    exit(0);
  20:	4501                	li	a0,0
  22:	2b0000ef          	jal	2d2 <exit>
        printf("No idle process found.\n");
  26:	00001517          	auipc	a0,0x1
  2a:	88a50513          	addi	a0,a0,-1910 # 8b0 <malloc+0xfc>
  2e:	6ce000ef          	jal	6fc <printf>
  32:	b7fd                	j	20 <main+0x20>

0000000000000034 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  34:	1141                	addi	sp,sp,-16
  36:	e406                	sd	ra,8(sp)
  38:	e022                	sd	s0,0(sp)
  3a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  3c:	fc5ff0ef          	jal	0 <main>
  exit(0);
  40:	4501                	li	a0,0
  42:	290000ef          	jal	2d2 <exit>

0000000000000046 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  46:	1141                	addi	sp,sp,-16
  48:	e406                	sd	ra,8(sp)
  4a:	e022                	sd	s0,0(sp)
  4c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4e:	87aa                	mv	a5,a0
  50:	0585                	addi	a1,a1,1
  52:	0785                	addi	a5,a5,1
  54:	fff5c703          	lbu	a4,-1(a1)
  58:	fee78fa3          	sb	a4,-1(a5)
  5c:	fb75                	bnez	a4,50 <strcpy+0xa>
    ;
  return os;
}
  5e:	60a2                	ld	ra,8(sp)
  60:	6402                	ld	s0,0(sp)
  62:	0141                	addi	sp,sp,16
  64:	8082                	ret

0000000000000066 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  6e:	00054783          	lbu	a5,0(a0)
  72:	cb91                	beqz	a5,86 <strcmp+0x20>
  74:	0005c703          	lbu	a4,0(a1)
  78:	00f71763          	bne	a4,a5,86 <strcmp+0x20>
    p++, q++;
  7c:	0505                	addi	a0,a0,1
  7e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  80:	00054783          	lbu	a5,0(a0)
  84:	fbe5                	bnez	a5,74 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  86:	0005c503          	lbu	a0,0(a1)
}
  8a:	40a7853b          	subw	a0,a5,a0
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strlen>:

uint
strlen(const char *s)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cf99                	beqz	a5,c0 <strlen+0x2a>
  a4:	0505                	addi	a0,a0,1
  a6:	87aa                	mv	a5,a0
  a8:	86be                	mv	a3,a5
  aa:	0785                	addi	a5,a5,1
  ac:	fff7c703          	lbu	a4,-1(a5)
  b0:	ff65                	bnez	a4,a8 <strlen+0x12>
  b2:	40a6853b          	subw	a0,a3,a0
  b6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  b8:	60a2                	ld	ra,8(sp)
  ba:	6402                	ld	s0,0(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret
  for(n = 0; s[n]; n++)
  c0:	4501                	li	a0,0
  c2:	bfdd                	j	b8 <strlen+0x22>

00000000000000c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  cc:	ca19                	beqz	a2,e2 <memset+0x1e>
  ce:	87aa                	mv	a5,a0
  d0:	1602                	slli	a2,a2,0x20
  d2:	9201                	srli	a2,a2,0x20
  d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  dc:	0785                	addi	a5,a5,1
  de:	fee79de3          	bne	a5,a4,d8 <memset+0x14>
  }
  return dst;
}
  e2:	60a2                	ld	ra,8(sp)
  e4:	6402                	ld	s0,0(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret

00000000000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f2:	00054783          	lbu	a5,0(a0)
  f6:	cf81                	beqz	a5,10e <strchr+0x24>
    if(*s == c)
  f8:	00f58763          	beq	a1,a5,106 <strchr+0x1c>
  for(; *s; s++)
  fc:	0505                	addi	a0,a0,1
  fe:	00054783          	lbu	a5,0(a0)
 102:	fbfd                	bnez	a5,f8 <strchr+0xe>
      return (char*)s;
  return 0;
 104:	4501                	li	a0,0
}
 106:	60a2                	ld	ra,8(sp)
 108:	6402                	ld	s0,0(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret
  return 0;
 10e:	4501                	li	a0,0
 110:	bfdd                	j	106 <strchr+0x1c>

0000000000000112 <gets>:

char*
gets(char *buf, int max)
{
 112:	7159                	addi	sp,sp,-112
 114:	f486                	sd	ra,104(sp)
 116:	f0a2                	sd	s0,96(sp)
 118:	eca6                	sd	s1,88(sp)
 11a:	e8ca                	sd	s2,80(sp)
 11c:	e4ce                	sd	s3,72(sp)
 11e:	e0d2                	sd	s4,64(sp)
 120:	fc56                	sd	s5,56(sp)
 122:	f85a                	sd	s6,48(sp)
 124:	f45e                	sd	s7,40(sp)
 126:	f062                	sd	s8,32(sp)
 128:	ec66                	sd	s9,24(sp)
 12a:	e86a                	sd	s10,16(sp)
 12c:	1880                	addi	s0,sp,112
 12e:	8caa                	mv	s9,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
 136:	f9f40b13          	addi	s6,s0,-97
 13a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4ba9                	li	s7,10
 13e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 140:	8d26                	mv	s10,s1
 142:	0014899b          	addiw	s3,s1,1
 146:	84ce                	mv	s1,s3
 148:	0349d563          	bge	s3,s4,172 <gets+0x60>
    cc = read(0, &c, 1);
 14c:	8656                	mv	a2,s5
 14e:	85da                	mv	a1,s6
 150:	4501                	li	a0,0
 152:	198000ef          	jal	2ea <read>
    if(cc < 1)
 156:	00a05e63          	blez	a0,172 <gets+0x60>
    buf[i++] = c;
 15a:	f9f44783          	lbu	a5,-97(s0)
 15e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 162:	01778763          	beq	a5,s7,170 <gets+0x5e>
 166:	0905                	addi	s2,s2,1
 168:	fd879ce3          	bne	a5,s8,140 <gets+0x2e>
    buf[i++] = c;
 16c:	8d4e                	mv	s10,s3
 16e:	a011                	j	172 <gets+0x60>
 170:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 172:	9d66                	add	s10,s10,s9
 174:	000d0023          	sb	zero,0(s10)
  return buf;
}
 178:	8566                	mv	a0,s9
 17a:	70a6                	ld	ra,104(sp)
 17c:	7406                	ld	s0,96(sp)
 17e:	64e6                	ld	s1,88(sp)
 180:	6946                	ld	s2,80(sp)
 182:	69a6                	ld	s3,72(sp)
 184:	6a06                	ld	s4,64(sp)
 186:	7ae2                	ld	s5,56(sp)
 188:	7b42                	ld	s6,48(sp)
 18a:	7ba2                	ld	s7,40(sp)
 18c:	7c02                	ld	s8,32(sp)
 18e:	6ce2                	ld	s9,24(sp)
 190:	6d42                	ld	s10,16(sp)
 192:	6165                	addi	sp,sp,112
 194:	8082                	ret

0000000000000196 <stat>:

int
stat(const char *n, struct stat *st)
{
 196:	1101                	addi	sp,sp,-32
 198:	ec06                	sd	ra,24(sp)
 19a:	e822                	sd	s0,16(sp)
 19c:	e04a                	sd	s2,0(sp)
 19e:	1000                	addi	s0,sp,32
 1a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	4581                	li	a1,0
 1a4:	16e000ef          	jal	312 <open>
  if(fd < 0)
 1a8:	02054263          	bltz	a0,1cc <stat+0x36>
 1ac:	e426                	sd	s1,8(sp)
 1ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b0:	85ca                	mv	a1,s2
 1b2:	178000ef          	jal	32a <fstat>
 1b6:	892a                	mv	s2,a0
  close(fd);
 1b8:	8526                	mv	a0,s1
 1ba:	140000ef          	jal	2fa <close>
  return r;
 1be:	64a2                	ld	s1,8(sp)
}
 1c0:	854a                	mv	a0,s2
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	6902                	ld	s2,0(sp)
 1c8:	6105                	addi	sp,sp,32
 1ca:	8082                	ret
    return -1;
 1cc:	597d                	li	s2,-1
 1ce:	bfcd                	j	1c0 <stat+0x2a>

00000000000001d0 <atoi>:

int
atoi(const char *s)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e406                	sd	ra,8(sp)
 1d4:	e022                	sd	s0,0(sp)
 1d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d8:	00054683          	lbu	a3,0(a0)
 1dc:	fd06879b          	addiw	a5,a3,-48
 1e0:	0ff7f793          	zext.b	a5,a5
 1e4:	4625                	li	a2,9
 1e6:	02f66963          	bltu	a2,a5,218 <atoi+0x48>
 1ea:	872a                	mv	a4,a0
  n = 0;
 1ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ee:	0705                	addi	a4,a4,1
 1f0:	0025179b          	slliw	a5,a0,0x2
 1f4:	9fa9                	addw	a5,a5,a0
 1f6:	0017979b          	slliw	a5,a5,0x1
 1fa:	9fb5                	addw	a5,a5,a3
 1fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 200:	00074683          	lbu	a3,0(a4)
 204:	fd06879b          	addiw	a5,a3,-48
 208:	0ff7f793          	zext.b	a5,a5
 20c:	fef671e3          	bgeu	a2,a5,1ee <atoi+0x1e>
  return n;
}
 210:	60a2                	ld	ra,8(sp)
 212:	6402                	ld	s0,0(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  n = 0;
 218:	4501                	li	a0,0
 21a:	bfdd                	j	210 <atoi+0x40>

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 224:	02b57563          	bgeu	a0,a1,24e <memmove+0x32>
    while(n-- > 0)
 228:	00c05f63          	blez	a2,246 <memmove+0x2a>
 22c:	1602                	slli	a2,a2,0x20
 22e:	9201                	srli	a2,a2,0x20
 230:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 234:	872a                	mv	a4,a0
      *dst++ = *src++;
 236:	0585                	addi	a1,a1,1
 238:	0705                	addi	a4,a4,1
 23a:	fff5c683          	lbu	a3,-1(a1)
 23e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 242:	fee79ae3          	bne	a5,a4,236 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
    dst += n;
 24e:	00c50733          	add	a4,a0,a2
    src += n;
 252:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 254:	fec059e3          	blez	a2,246 <memmove+0x2a>
 258:	fff6079b          	addiw	a5,a2,-1
 25c:	1782                	slli	a5,a5,0x20
 25e:	9381                	srli	a5,a5,0x20
 260:	fff7c793          	not	a5,a5
 264:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 266:	15fd                	addi	a1,a1,-1
 268:	177d                	addi	a4,a4,-1
 26a:	0005c683          	lbu	a3,0(a1)
 26e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 272:	fef71ae3          	bne	a4,a5,266 <memmove+0x4a>
 276:	bfc1                	j	246 <memmove+0x2a>

0000000000000278 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 280:	ca0d                	beqz	a2,2b2 <memcmp+0x3a>
 282:	fff6069b          	addiw	a3,a2,-1
 286:	1682                	slli	a3,a3,0x20
 288:	9281                	srli	a3,a3,0x20
 28a:	0685                	addi	a3,a3,1
 28c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28e:	00054783          	lbu	a5,0(a0)
 292:	0005c703          	lbu	a4,0(a1)
 296:	00e79863          	bne	a5,a4,2a6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 29a:	0505                	addi	a0,a0,1
    p2++;
 29c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29e:	fed518e3          	bne	a0,a3,28e <memcmp+0x16>
  }
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	a019                	j	2aa <memcmp+0x32>
      return *p1 - *p2;
 2a6:	40e7853b          	subw	a0,a5,a4
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  return 0;
 2b2:	4501                	li	a0,0
 2b4:	bfdd                	j	2aa <memcmp+0x32>

00000000000002b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2be:	f5fff0ef          	jal	21c <memmove>
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret

00000000000002ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ca:	4885                	li	a7,1
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d2:	4889                	li	a7,2
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <wait>:
.global wait
wait:
 li a7, SYS_wait
 2da:	488d                	li	a7,3
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e2:	4891                	li	a7,4
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <read>:
.global read
read:
 li a7, SYS_read
 2ea:	4895                	li	a7,5
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <write>:
.global write
write:
 li a7, SYS_write
 2f2:	48c1                	li	a7,16
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <close>:
.global close
close:
 li a7, SYS_close
 2fa:	48d5                	li	a7,21
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <kill>:
.global kill
kill:
 li a7, SYS_kill
 302:	4899                	li	a7,6
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exec>:
.global exec
exec:
 li a7, SYS_exec
 30a:	489d                	li	a7,7
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <open>:
.global open
open:
 li a7, SYS_open
 312:	48bd                	li	a7,15
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31a:	48c5                	li	a7,17
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 322:	48c9                	li	a7,18
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32a:	48a1                	li	a7,8
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <link>:
.global link
link:
 li a7, SYS_link
 332:	48cd                	li	a7,19
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33a:	48d1                	li	a7,20
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 342:	48a5                	li	a7,9
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <dup>:
.global dup
dup:
 li a7, SYS_dup
 34a:	48a9                	li	a7,10
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 352:	48ad                	li	a7,11
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 35a:	48b1                	li	a7,12
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 362:	48b5                	li	a7,13
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36a:	48b9                	li	a7,14
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 372:	48d9                	li	a7,22
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <ps>:
.global ps
ps:
 li a7, SYS_ps
 37a:	48dd                	li	a7,23
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 382:	48e1                	li	a7,24
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 38a:	48e5                	li	a7,25
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 392:	48e9                	li	a7,26
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39a:	1101                	addi	sp,sp,-32
 39c:	ec06                	sd	ra,24(sp)
 39e:	e822                	sd	s0,16(sp)
 3a0:	1000                	addi	s0,sp,32
 3a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	fef40593          	addi	a1,s0,-17
 3ac:	f47ff0ef          	jal	2f2 <write>
}
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	6105                	addi	sp,sp,32
 3b6:	8082                	ret

00000000000003b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b8:	7139                	addi	sp,sp,-64
 3ba:	fc06                	sd	ra,56(sp)
 3bc:	f822                	sd	s0,48(sp)
 3be:	f426                	sd	s1,40(sp)
 3c0:	f04a                	sd	s2,32(sp)
 3c2:	ec4e                	sd	s3,24(sp)
 3c4:	0080                	addi	s0,sp,64
 3c6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c8:	c299                	beqz	a3,3ce <printint+0x16>
 3ca:	0605ce63          	bltz	a1,446 <printint+0x8e>
  neg = 0;
 3ce:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3d0:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3d4:	869a                	mv	a3,t1
  i = 0;
 3d6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3d8:	00000817          	auipc	a6,0x0
 3dc:	51080813          	addi	a6,a6,1296 # 8e8 <digits>
 3e0:	88be                	mv	a7,a5
 3e2:	0017851b          	addiw	a0,a5,1
 3e6:	87aa                	mv	a5,a0
 3e8:	02c5f73b          	remuw	a4,a1,a2
 3ec:	1702                	slli	a4,a4,0x20
 3ee:	9301                	srli	a4,a4,0x20
 3f0:	9742                	add	a4,a4,a6
 3f2:	00074703          	lbu	a4,0(a4)
 3f6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3fa:	872e                	mv	a4,a1
 3fc:	02c5d5bb          	divuw	a1,a1,a2
 400:	0685                	addi	a3,a3,1
 402:	fcc77fe3          	bgeu	a4,a2,3e0 <printint+0x28>
  if(neg)
 406:	000e0c63          	beqz	t3,41e <printint+0x66>
    buf[i++] = '-';
 40a:	fd050793          	addi	a5,a0,-48
 40e:	00878533          	add	a0,a5,s0
 412:	02d00793          	li	a5,45
 416:	fef50823          	sb	a5,-16(a0)
 41a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 41e:	fff7899b          	addiw	s3,a5,-1
 422:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 426:	fff4c583          	lbu	a1,-1(s1)
 42a:	854a                	mv	a0,s2
 42c:	f6fff0ef          	jal	39a <putc>
  while(--i >= 0)
 430:	39fd                	addiw	s3,s3,-1
 432:	14fd                	addi	s1,s1,-1
 434:	fe09d9e3          	bgez	s3,426 <printint+0x6e>
}
 438:	70e2                	ld	ra,56(sp)
 43a:	7442                	ld	s0,48(sp)
 43c:	74a2                	ld	s1,40(sp)
 43e:	7902                	ld	s2,32(sp)
 440:	69e2                	ld	s3,24(sp)
 442:	6121                	addi	sp,sp,64
 444:	8082                	ret
    x = -xx;
 446:	40b005bb          	negw	a1,a1
    neg = 1;
 44a:	4e05                	li	t3,1
    x = -xx;
 44c:	b751                	j	3d0 <printint+0x18>

000000000000044e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44e:	711d                	addi	sp,sp,-96
 450:	ec86                	sd	ra,88(sp)
 452:	e8a2                	sd	s0,80(sp)
 454:	e4a6                	sd	s1,72(sp)
 456:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 458:	0005c483          	lbu	s1,0(a1)
 45c:	26048663          	beqz	s1,6c8 <vprintf+0x27a>
 460:	e0ca                	sd	s2,64(sp)
 462:	fc4e                	sd	s3,56(sp)
 464:	f852                	sd	s4,48(sp)
 466:	f456                	sd	s5,40(sp)
 468:	f05a                	sd	s6,32(sp)
 46a:	ec5e                	sd	s7,24(sp)
 46c:	e862                	sd	s8,16(sp)
 46e:	e466                	sd	s9,8(sp)
 470:	8b2a                	mv	s6,a0
 472:	8a2e                	mv	s4,a1
 474:	8bb2                	mv	s7,a2
  state = 0;
 476:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 478:	4901                	li	s2,0
 47a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 47c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 480:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 484:	06c00c93          	li	s9,108
 488:	a00d                	j	4aa <vprintf+0x5c>
        putc(fd, c0);
 48a:	85a6                	mv	a1,s1
 48c:	855a                	mv	a0,s6
 48e:	f0dff0ef          	jal	39a <putc>
 492:	a019                	j	498 <vprintf+0x4a>
    } else if(state == '%'){
 494:	03598363          	beq	s3,s5,4ba <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 498:	0019079b          	addiw	a5,s2,1
 49c:	893e                	mv	s2,a5
 49e:	873e                	mv	a4,a5
 4a0:	97d2                	add	a5,a5,s4
 4a2:	0007c483          	lbu	s1,0(a5)
 4a6:	20048963          	beqz	s1,6b8 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4aa:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ae:	fe0993e3          	bnez	s3,494 <vprintf+0x46>
      if(c0 == '%'){
 4b2:	fd579ce3          	bne	a5,s5,48a <vprintf+0x3c>
        state = '%';
 4b6:	89be                	mv	s3,a5
 4b8:	b7c5                	j	498 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ba:	00ea06b3          	add	a3,s4,a4
 4be:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4c4:	c681                	beqz	a3,4cc <vprintf+0x7e>
 4c6:	9752                	add	a4,a4,s4
 4c8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4cc:	03878e63          	beq	a5,s8,508 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4d0:	05978863          	beq	a5,s9,520 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4d4:	07500713          	li	a4,117
 4d8:	0ee78263          	beq	a5,a4,5bc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4dc:	07800713          	li	a4,120
 4e0:	12e78463          	beq	a5,a4,608 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4e4:	07000713          	li	a4,112
 4e8:	14e78963          	beq	a5,a4,63a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4ec:	07300713          	li	a4,115
 4f0:	18e78863          	beq	a5,a4,680 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4f4:	02500713          	li	a4,37
 4f8:	04e79463          	bne	a5,a4,540 <vprintf+0xf2>
        putc(fd, '%');
 4fc:	85ba                	mv	a1,a4
 4fe:	855a                	mv	a0,s6
 500:	e9bff0ef          	jal	39a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 504:	4981                	li	s3,0
 506:	bf49                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 508:	008b8493          	addi	s1,s7,8
 50c:	4685                	li	a3,1
 50e:	4629                	li	a2,10
 510:	000ba583          	lw	a1,0(s7)
 514:	855a                	mv	a0,s6
 516:	ea3ff0ef          	jal	3b8 <printint>
 51a:	8ba6                	mv	s7,s1
      state = 0;
 51c:	4981                	li	s3,0
 51e:	bfad                	j	498 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 520:	06400793          	li	a5,100
 524:	02f68963          	beq	a3,a5,556 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 528:	06c00793          	li	a5,108
 52c:	04f68263          	beq	a3,a5,570 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 530:	07500793          	li	a5,117
 534:	0af68063          	beq	a3,a5,5d4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 538:	07800793          	li	a5,120
 53c:	0ef68263          	beq	a3,a5,620 <vprintf+0x1d2>
        putc(fd, '%');
 540:	02500593          	li	a1,37
 544:	855a                	mv	a0,s6
 546:	e55ff0ef          	jal	39a <putc>
        putc(fd, c0);
 54a:	85a6                	mv	a1,s1
 54c:	855a                	mv	a0,s6
 54e:	e4dff0ef          	jal	39a <putc>
      state = 0;
 552:	4981                	li	s3,0
 554:	b791                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	008b8493          	addi	s1,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e55ff0ef          	jal	3b8 <printint>
        i += 1;
 568:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	8ba6                	mv	s7,s1
      state = 0;
 56c:	4981                	li	s3,0
        i += 1;
 56e:	b72d                	j	498 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 570:	06400793          	li	a5,100
 574:	02f60763          	beq	a2,a5,5a2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 578:	07500793          	li	a5,117
 57c:	06f60963          	beq	a2,a5,5ee <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 580:	07800793          	li	a5,120
 584:	faf61ee3          	bne	a2,a5,540 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 588:	008b8493          	addi	s1,s7,8
 58c:	4681                	li	a3,0
 58e:	4641                	li	a2,16
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e23ff0ef          	jal	3b8 <printint>
        i += 2;
 59a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
        i += 2;
 5a0:	bde5                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	e09ff0ef          	jal	3b8 <printint>
        i += 2;
 5b4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
        i += 2;
 5ba:	bdf9                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	defff0ef          	jal	3b8 <printint>
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b5d9                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	dd7ff0ef          	jal	3b8 <printint>
        i += 1;
 5e6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
        i += 1;
 5ec:	b575                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	dbdff0ef          	jal	3b8 <printint>
        i += 2;
 600:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
        i += 2;
 606:	bd49                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	da3ff0ef          	jal	3b8 <printint>
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bdad                	j	498 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	d8bff0ef          	jal	3b8 <printint>
        i += 1;
 632:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
        i += 1;
 638:	b585                	j	498 <vprintf+0x4a>
 63a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 63c:	008b8d13          	addi	s10,s7,8
 640:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 644:	03000593          	li	a1,48
 648:	855a                	mv	a0,s6
 64a:	d51ff0ef          	jal	39a <putc>
  putc(fd, 'x');
 64e:	07800593          	li	a1,120
 652:	855a                	mv	a0,s6
 654:	d47ff0ef          	jal	39a <putc>
 658:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65a:	00000b97          	auipc	s7,0x0
 65e:	28eb8b93          	addi	s7,s7,654 # 8e8 <digits>
 662:	03c9d793          	srli	a5,s3,0x3c
 666:	97de                	add	a5,a5,s7
 668:	0007c583          	lbu	a1,0(a5)
 66c:	855a                	mv	a0,s6
 66e:	d2dff0ef          	jal	39a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 672:	0992                	slli	s3,s3,0x4
 674:	34fd                	addiw	s1,s1,-1
 676:	f4f5                	bnez	s1,662 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 678:	8bea                	mv	s7,s10
      state = 0;
 67a:	4981                	li	s3,0
 67c:	6d02                	ld	s10,0(sp)
 67e:	bd29                	j	498 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 680:	008b8993          	addi	s3,s7,8
 684:	000bb483          	ld	s1,0(s7)
 688:	cc91                	beqz	s1,6a4 <vprintf+0x256>
        for(; *s; s++)
 68a:	0004c583          	lbu	a1,0(s1)
 68e:	c195                	beqz	a1,6b2 <vprintf+0x264>
          putc(fd, *s);
 690:	855a                	mv	a0,s6
 692:	d09ff0ef          	jal	39a <putc>
        for(; *s; s++)
 696:	0485                	addi	s1,s1,1
 698:	0004c583          	lbu	a1,0(s1)
 69c:	f9f5                	bnez	a1,690 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bbdd                	j	498 <vprintf+0x4a>
          s = "(null)";
 6a4:	00000497          	auipc	s1,0x0
 6a8:	23c48493          	addi	s1,s1,572 # 8e0 <malloc+0x12c>
        for(; *s; s++)
 6ac:	02800593          	li	a1,40
 6b0:	b7c5                	j	690 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	8bce                	mv	s7,s3
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b3cd                	j	498 <vprintf+0x4a>
 6b8:	6906                	ld	s2,64(sp)
 6ba:	79e2                	ld	s3,56(sp)
 6bc:	7a42                	ld	s4,48(sp)
 6be:	7aa2                	ld	s5,40(sp)
 6c0:	7b02                	ld	s6,32(sp)
 6c2:	6be2                	ld	s7,24(sp)
 6c4:	6c42                	ld	s8,16(sp)
 6c6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6c8:	60e6                	ld	ra,88(sp)
 6ca:	6446                	ld	s0,80(sp)
 6cc:	64a6                	ld	s1,72(sp)
 6ce:	6125                	addi	sp,sp,96
 6d0:	8082                	ret

00000000000006d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d2:	715d                	addi	sp,sp,-80
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	e010                	sd	a2,0(s0)
 6dc:	e414                	sd	a3,8(s0)
 6de:	e818                	sd	a4,16(s0)
 6e0:	ec1c                	sd	a5,24(s0)
 6e2:	03043023          	sd	a6,32(s0)
 6e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ea:	8622                	mv	a2,s0
 6ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f0:	d5fff0ef          	jal	44e <vprintf>
}
 6f4:	60e2                	ld	ra,24(sp)
 6f6:	6442                	ld	s0,16(sp)
 6f8:	6161                	addi	sp,sp,80
 6fa:	8082                	ret

00000000000006fc <printf>:

void
printf(const char *fmt, ...)
{
 6fc:	711d                	addi	sp,sp,-96
 6fe:	ec06                	sd	ra,24(sp)
 700:	e822                	sd	s0,16(sp)
 702:	1000                	addi	s0,sp,32
 704:	e40c                	sd	a1,8(s0)
 706:	e810                	sd	a2,16(s0)
 708:	ec14                	sd	a3,24(s0)
 70a:	f018                	sd	a4,32(s0)
 70c:	f41c                	sd	a5,40(s0)
 70e:	03043823          	sd	a6,48(s0)
 712:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 716:	00840613          	addi	a2,s0,8
 71a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71e:	85aa                	mv	a1,a0
 720:	4505                	li	a0,1
 722:	d2dff0ef          	jal	44e <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6125                	addi	sp,sp,96
 72c:	8082                	ret

000000000000072e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72e:	1141                	addi	sp,sp,-16
 730:	e406                	sd	ra,8(sp)
 732:	e022                	sd	s0,0(sp)
 734:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 736:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	00001797          	auipc	a5,0x1
 73e:	8c67b783          	ld	a5,-1850(a5) # 1000 <freep>
 742:	a02d                	j	76c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 744:	4618                	lw	a4,8(a2)
 746:	9f2d                	addw	a4,a4,a1
 748:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	6398                	ld	a4,0(a5)
 74e:	6310                	ld	a2,0(a4)
 750:	a83d                	j	78e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 752:	ff852703          	lw	a4,-8(a0)
 756:	9f31                	addw	a4,a4,a2
 758:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75a:	ff053683          	ld	a3,-16(a0)
 75e:	a091                	j	7a2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	6398                	ld	a4,0(a5)
 762:	00e7e463          	bltu	a5,a4,76a <free+0x3c>
 766:	00e6ea63          	bltu	a3,a4,77a <free+0x4c>
{
 76a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	fed7fae3          	bgeu	a5,a3,760 <free+0x32>
 770:	6398                	ld	a4,0(a5)
 772:	00e6e463          	bltu	a3,a4,77a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	fee7eae3          	bltu	a5,a4,76a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 77a:	ff852583          	lw	a1,-8(a0)
 77e:	6390                	ld	a2,0(a5)
 780:	02059813          	slli	a6,a1,0x20
 784:	01c85713          	srli	a4,a6,0x1c
 788:	9736                	add	a4,a4,a3
 78a:	fae60de3          	beq	a2,a4,744 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 78e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 792:	4790                	lw	a2,8(a5)
 794:	02061593          	slli	a1,a2,0x20
 798:	01c5d713          	srli	a4,a1,0x1c
 79c:	973e                	add	a4,a4,a5
 79e:	fae68ae3          	beq	a3,a4,752 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7a2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a4:	00001717          	auipc	a4,0x1
 7a8:	84f73e23          	sd	a5,-1956(a4) # 1000 <freep>
}
 7ac:	60a2                	ld	ra,8(sp)
 7ae:	6402                	ld	s0,0(sp)
 7b0:	0141                	addi	sp,sp,16
 7b2:	8082                	ret

00000000000007b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b4:	7139                	addi	sp,sp,-64
 7b6:	fc06                	sd	ra,56(sp)
 7b8:	f822                	sd	s0,48(sp)
 7ba:	f04a                	sd	s2,32(sp)
 7bc:	ec4e                	sd	s3,24(sp)
 7be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c0:	02051993          	slli	s3,a0,0x20
 7c4:	0209d993          	srli	s3,s3,0x20
 7c8:	09bd                	addi	s3,s3,15
 7ca:	0049d993          	srli	s3,s3,0x4
 7ce:	2985                	addiw	s3,s3,1
 7d0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7d2:	00001517          	auipc	a0,0x1
 7d6:	82e53503          	ld	a0,-2002(a0) # 1000 <freep>
 7da:	c905                	beqz	a0,80a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7de:	4798                	lw	a4,8(a5)
 7e0:	09377663          	bgeu	a4,s3,86c <malloc+0xb8>
 7e4:	f426                	sd	s1,40(sp)
 7e6:	e852                	sd	s4,16(sp)
 7e8:	e456                	sd	s5,8(sp)
 7ea:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ec:	8a4e                	mv	s4,s3
 7ee:	6705                	lui	a4,0x1
 7f0:	00e9f363          	bgeu	s3,a4,7f6 <malloc+0x42>
 7f4:	6a05                	lui	s4,0x1
 7f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fe:	00001497          	auipc	s1,0x1
 802:	80248493          	addi	s1,s1,-2046 # 1000 <freep>
  if(p == (char*)-1)
 806:	5afd                	li	s5,-1
 808:	a83d                	j	846 <malloc+0x92>
 80a:	f426                	sd	s1,40(sp)
 80c:	e852                	sd	s4,16(sp)
 80e:	e456                	sd	s5,8(sp)
 810:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 812:	00000797          	auipc	a5,0x0
 816:	7fe78793          	addi	a5,a5,2046 # 1010 <base>
 81a:	00000717          	auipc	a4,0x0
 81e:	7ef73323          	sd	a5,2022(a4) # 1000 <freep>
 822:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 824:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 828:	b7d1                	j	7ec <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 82a:	6398                	ld	a4,0(a5)
 82c:	e118                	sd	a4,0(a0)
 82e:	a899                	j	884 <malloc+0xd0>
  hp->s.size = nu;
 830:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 834:	0541                	addi	a0,a0,16
 836:	ef9ff0ef          	jal	72e <free>
  return freep;
 83a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 83c:	c125                	beqz	a0,89c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	03277163          	bgeu	a4,s2,864 <malloc+0xb0>
    if(p == freep)
 846:	6098                	ld	a4,0(s1)
 848:	853e                	mv	a0,a5
 84a:	fef71ae3          	bne	a4,a5,83e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 84e:	8552                	mv	a0,s4
 850:	b0bff0ef          	jal	35a <sbrk>
  if(p == (char*)-1)
 854:	fd551ee3          	bne	a0,s5,830 <malloc+0x7c>
        return 0;
 858:	4501                	li	a0,0
 85a:	74a2                	ld	s1,40(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
 862:	a03d                	j	890 <malloc+0xdc>
 864:	74a2                	ld	s1,40(sp)
 866:	6a42                	ld	s4,16(sp)
 868:	6aa2                	ld	s5,8(sp)
 86a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 86c:	fae90fe3          	beq	s2,a4,82a <malloc+0x76>
        p->s.size -= nunits;
 870:	4137073b          	subw	a4,a4,s3
 874:	c798                	sw	a4,8(a5)
        p += p->s.size;
 876:	02071693          	slli	a3,a4,0x20
 87a:	01c6d713          	srli	a4,a3,0x1c
 87e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 880:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 884:	00000717          	auipc	a4,0x0
 888:	76a73e23          	sd	a0,1916(a4) # 1000 <freep>
      return (void*)(p + 1);
 88c:	01078513          	addi	a0,a5,16
  }
}
 890:	70e2                	ld	ra,56(sp)
 892:	7442                	ld	s0,48(sp)
 894:	7902                	ld	s2,32(sp)
 896:	69e2                	ld	s3,24(sp)
 898:	6121                	addi	sp,sp,64
 89a:	8082                	ret
 89c:	74a2                	ld	s1,40(sp)
 89e:	6a42                	ld	s4,16(sp)
 8a0:	6aa2                	ld	s5,8(sp)
 8a2:	6b02                	ld	s6,0(sp)
 8a4:	b7f5                	j	890 <malloc+0xdc>
