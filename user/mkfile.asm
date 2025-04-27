
user/_mkfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    if(argc != 3) {
   8:	478d                	li	a5,3
   a:	00f50e63          	beq	a0,a5,26 <main+0x26>
   e:	ec26                	sd	s1,24(sp)
  10:	e84a                	sd	s2,16(sp)
  12:	e44e                	sd	s3,8(sp)
        printf("Usage: mkfile <filename> <content>\n");
  14:	00001517          	auipc	a0,0x1
  18:	8fc50513          	addi	a0,a0,-1796 # 910 <malloc+0xf8>
  1c:	744000ef          	jal	760 <printf>
        exit(1);
  20:	4505                	li	a0,1
  22:	314000ef          	jal	336 <exit>
  26:	ec26                	sd	s1,24(sp)
  28:	e84a                	sd	s2,16(sp)
  2a:	84ae                	mv	s1,a1
    }

    int fd = open(argv[1], O_CREATE | O_WRONLY);
  2c:	20100593          	li	a1,513
  30:	6488                	ld	a0,8(s1)
  32:	344000ef          	jal	376 <open>
  36:	892a                	mv	s2,a0
    if(fd < 0) {
  38:	02054f63          	bltz	a0,76 <main+0x76>
  3c:	e44e                	sd	s3,8(sp)
        printf("Failed to create file %s\n", argv[1]);
        exit(1);
    }

    if(write(fd, argv[2], strlen(argv[2])) != strlen(argv[2])) {
  3e:	0104b983          	ld	s3,16(s1)
  42:	854e                	mv	a0,s3
  44:	0b6000ef          	jal	fa <strlen>
  48:	862a                	mv	a2,a0
  4a:	85ce                	mv	a1,s3
  4c:	854a                	mv	a0,s2
  4e:	308000ef          	jal	356 <write>
  52:	89aa                	mv	s3,a0
  54:	6888                	ld	a0,16(s1)
  56:	0a4000ef          	jal	fa <strlen>
  5a:	02a98963          	beq	s3,a0,8c <main+0x8c>
        printf("Failed to write to file\n");
  5e:	00001517          	auipc	a0,0x1
  62:	8fa50513          	addi	a0,a0,-1798 # 958 <malloc+0x140>
  66:	6fa000ef          	jal	760 <printf>
        close(fd);
  6a:	854a                	mv	a0,s2
  6c:	2f2000ef          	jal	35e <close>
        exit(1);
  70:	4505                	li	a0,1
  72:	2c4000ef          	jal	336 <exit>
  76:	e44e                	sd	s3,8(sp)
        printf("Failed to create file %s\n", argv[1]);
  78:	648c                	ld	a1,8(s1)
  7a:	00001517          	auipc	a0,0x1
  7e:	8be50513          	addi	a0,a0,-1858 # 938 <malloc+0x120>
  82:	6de000ef          	jal	760 <printf>
        exit(1);
  86:	4505                	li	a0,1
  88:	2ae000ef          	jal	336 <exit>
    }

    close(fd);
  8c:	854a                	mv	a0,s2
  8e:	2d0000ef          	jal	35e <close>
    exit(0);
  92:	4501                	li	a0,0
  94:	2a2000ef          	jal	336 <exit>

0000000000000098 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  98:	1141                	addi	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  a0:	f61ff0ef          	jal	0 <main>
  exit(0);
  a4:	4501                	li	a0,0
  a6:	290000ef          	jal	336 <exit>

00000000000000aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0xa>
    ;
  return os;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x20>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x20>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cf99                	beqz	a5,124 <strlen+0x2a>
 108:	0505                	addi	a0,a0,1
 10a:	87aa                	mv	a5,a0
 10c:	86be                	mv	a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	ff65                	bnez	a4,10c <strlen+0x12>
 116:	40a6853b          	subw	a0,a3,a0
 11a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strlen+0x22>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 130:	ca19                	beqz	a2,146 <memset+0x1e>
 132:	87aa                	mv	a5,a0
 134:	1602                	slli	a2,a2,0x20
 136:	9201                	srli	a2,a2,0x20
 138:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 140:	0785                	addi	a5,a5,1
 142:	fee79de3          	bne	a5,a4,13c <memset+0x14>
  }
  return dst;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strchr>:

char*
strchr(const char *s, char c)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  for(; *s; s++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf81                	beqz	a5,172 <strchr+0x24>
    if(*s == c)
 15c:	00f58763          	beq	a1,a5,16a <strchr+0x1c>
  for(; *s; s++)
 160:	0505                	addi	a0,a0,1
 162:	00054783          	lbu	a5,0(a0)
 166:	fbfd                	bnez	a5,15c <strchr+0xe>
      return (char*)s;
  return 0;
 168:	4501                	li	a0,0
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  return 0;
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strchr+0x1c>

0000000000000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	7159                	addi	sp,sp,-112
 178:	f486                	sd	ra,104(sp)
 17a:	f0a2                	sd	s0,96(sp)
 17c:	eca6                	sd	s1,88(sp)
 17e:	e8ca                	sd	s2,80(sp)
 180:	e4ce                	sd	s3,72(sp)
 182:	e0d2                	sd	s4,64(sp)
 184:	fc56                	sd	s5,56(sp)
 186:	f85a                	sd	s6,48(sp)
 188:	f45e                	sd	s7,40(sp)
 18a:	f062                	sd	s8,32(sp)
 18c:	ec66                	sd	s9,24(sp)
 18e:	e86a                	sd	s10,16(sp)
 190:	1880                	addi	s0,sp,112
 192:	8caa                	mv	s9,a0
 194:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	892a                	mv	s2,a0
 198:	4481                	li	s1,0
    cc = read(0, &c, 1);
 19a:	f9f40b13          	addi	s6,s0,-97
 19e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a0:	4ba9                	li	s7,10
 1a2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1a4:	8d26                	mv	s10,s1
 1a6:	0014899b          	addiw	s3,s1,1
 1aa:	84ce                	mv	s1,s3
 1ac:	0349d563          	bge	s3,s4,1d6 <gets+0x60>
    cc = read(0, &c, 1);
 1b0:	8656                	mv	a2,s5
 1b2:	85da                	mv	a1,s6
 1b4:	4501                	li	a0,0
 1b6:	198000ef          	jal	34e <read>
    if(cc < 1)
 1ba:	00a05e63          	blez	a0,1d6 <gets+0x60>
    buf[i++] = c;
 1be:	f9f44783          	lbu	a5,-97(s0)
 1c2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c6:	01778763          	beq	a5,s7,1d4 <gets+0x5e>
 1ca:	0905                	addi	s2,s2,1
 1cc:	fd879ce3          	bne	a5,s8,1a4 <gets+0x2e>
    buf[i++] = c;
 1d0:	8d4e                	mv	s10,s3
 1d2:	a011                	j	1d6 <gets+0x60>
 1d4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1d6:	9d66                	add	s10,s10,s9
 1d8:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1dc:	8566                	mv	a0,s9
 1de:	70a6                	ld	ra,104(sp)
 1e0:	7406                	ld	s0,96(sp)
 1e2:	64e6                	ld	s1,88(sp)
 1e4:	6946                	ld	s2,80(sp)
 1e6:	69a6                	ld	s3,72(sp)
 1e8:	6a06                	ld	s4,64(sp)
 1ea:	7ae2                	ld	s5,56(sp)
 1ec:	7b42                	ld	s6,48(sp)
 1ee:	7ba2                	ld	s7,40(sp)
 1f0:	7c02                	ld	s8,32(sp)
 1f2:	6ce2                	ld	s9,24(sp)
 1f4:	6d42                	ld	s10,16(sp)
 1f6:	6165                	addi	sp,sp,112
 1f8:	8082                	ret

00000000000001fa <stat>:

int
stat(const char *n, struct stat *st)
{
 1fa:	1101                	addi	sp,sp,-32
 1fc:	ec06                	sd	ra,24(sp)
 1fe:	e822                	sd	s0,16(sp)
 200:	e04a                	sd	s2,0(sp)
 202:	1000                	addi	s0,sp,32
 204:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	4581                	li	a1,0
 208:	16e000ef          	jal	376 <open>
  if(fd < 0)
 20c:	02054263          	bltz	a0,230 <stat+0x36>
 210:	e426                	sd	s1,8(sp)
 212:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 214:	85ca                	mv	a1,s2
 216:	178000ef          	jal	38e <fstat>
 21a:	892a                	mv	s2,a0
  close(fd);
 21c:	8526                	mv	a0,s1
 21e:	140000ef          	jal	35e <close>
  return r;
 222:	64a2                	ld	s1,8(sp)
}
 224:	854a                	mv	a0,s2
 226:	60e2                	ld	ra,24(sp)
 228:	6442                	ld	s0,16(sp)
 22a:	6902                	ld	s2,0(sp)
 22c:	6105                	addi	sp,sp,32
 22e:	8082                	ret
    return -1;
 230:	597d                	li	s2,-1
 232:	bfcd                	j	224 <stat+0x2a>

0000000000000234 <atoi>:

int
atoi(const char *s)
{
 234:	1141                	addi	sp,sp,-16
 236:	e406                	sd	ra,8(sp)
 238:	e022                	sd	s0,0(sp)
 23a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23c:	00054683          	lbu	a3,0(a0)
 240:	fd06879b          	addiw	a5,a3,-48
 244:	0ff7f793          	zext.b	a5,a5
 248:	4625                	li	a2,9
 24a:	02f66963          	bltu	a2,a5,27c <atoi+0x48>
 24e:	872a                	mv	a4,a0
  n = 0;
 250:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 252:	0705                	addi	a4,a4,1
 254:	0025179b          	slliw	a5,a0,0x2
 258:	9fa9                	addw	a5,a5,a0
 25a:	0017979b          	slliw	a5,a5,0x1
 25e:	9fb5                	addw	a5,a5,a3
 260:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 264:	00074683          	lbu	a3,0(a4)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	fef671e3          	bgeu	a2,a5,252 <atoi+0x1e>
  return n;
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  n = 0;
 27c:	4501                	li	a0,0
 27e:	bfdd                	j	274 <atoi+0x40>

0000000000000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 288:	02b57563          	bgeu	a0,a1,2b2 <memmove+0x32>
    while(n-- > 0)
 28c:	00c05f63          	blez	a2,2aa <memmove+0x2a>
 290:	1602                	slli	a2,a2,0x20
 292:	9201                	srli	a2,a2,0x20
 294:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 298:	872a                	mv	a4,a0
      *dst++ = *src++;
 29a:	0585                	addi	a1,a1,1
 29c:	0705                	addi	a4,a4,1
 29e:	fff5c683          	lbu	a3,-1(a1)
 2a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a6:	fee79ae3          	bne	a5,a4,29a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
    dst += n;
 2b2:	00c50733          	add	a4,a0,a2
    src += n;
 2b6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b8:	fec059e3          	blez	a2,2aa <memmove+0x2a>
 2bc:	fff6079b          	addiw	a5,a2,-1
 2c0:	1782                	slli	a5,a5,0x20
 2c2:	9381                	srli	a5,a5,0x20
 2c4:	fff7c793          	not	a5,a5
 2c8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ca:	15fd                	addi	a1,a1,-1
 2cc:	177d                	addi	a4,a4,-1
 2ce:	0005c683          	lbu	a3,0(a1)
 2d2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d6:	fef71ae3          	bne	a4,a5,2ca <memmove+0x4a>
 2da:	bfc1                	j	2aa <memmove+0x2a>

00000000000002dc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e4:	ca0d                	beqz	a2,316 <memcmp+0x3a>
 2e6:	fff6069b          	addiw	a3,a2,-1
 2ea:	1682                	slli	a3,a3,0x20
 2ec:	9281                	srli	a3,a3,0x20
 2ee:	0685                	addi	a3,a3,1
 2f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	0005c703          	lbu	a4,0(a1)
 2fa:	00e79863          	bne	a5,a4,30a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2fe:	0505                	addi	a0,a0,1
    p2++;
 300:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 302:	fed518e3          	bne	a0,a3,2f2 <memcmp+0x16>
  }
  return 0;
 306:	4501                	li	a0,0
 308:	a019                	j	30e <memcmp+0x32>
      return *p1 - *p2;
 30a:	40e7853b          	subw	a0,a5,a4
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  return 0;
 316:	4501                	li	a0,0
 318:	bfdd                	j	30e <memcmp+0x32>

000000000000031a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 322:	f5fff0ef          	jal	280 <memmove>
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32e:	4885                	li	a7,1
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exit>:
.global exit
exit:
 li a7, SYS_exit
 336:	4889                	li	a7,2
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <wait>:
.global wait
wait:
 li a7, SYS_wait
 33e:	488d                	li	a7,3
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 346:	4891                	li	a7,4
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <read>:
.global read
read:
 li a7, SYS_read
 34e:	4895                	li	a7,5
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <write>:
.global write
write:
 li a7, SYS_write
 356:	48c1                	li	a7,16
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <close>:
.global close
close:
 li a7, SYS_close
 35e:	48d5                	li	a7,21
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <kill>:
.global kill
kill:
 li a7, SYS_kill
 366:	4899                	li	a7,6
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exec>:
.global exec
exec:
 li a7, SYS_exec
 36e:	489d                	li	a7,7
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <open>:
.global open
open:
 li a7, SYS_open
 376:	48bd                	li	a7,15
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37e:	48c5                	li	a7,17
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 386:	48c9                	li	a7,18
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38e:	48a1                	li	a7,8
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <link>:
.global link
link:
 li a7, SYS_link
 396:	48cd                	li	a7,19
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39e:	48d1                	li	a7,20
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a6:	48a5                	li	a7,9
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ae:	48a9                	li	a7,10
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b6:	48ad                	li	a7,11
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3be:	48b1                	li	a7,12
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c6:	48b5                	li	a7,13
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ce:	48b9                	li	a7,14
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 3d6:	48d9                	li	a7,22
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <ps>:
.global ps
ps:
 li a7, SYS_ps
 3de:	48dd                	li	a7,23
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 3e6:	48e1                	li	a7,24
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 3ee:	48e5                	li	a7,25
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 3f6:	48e9                	li	a7,26
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fe:	1101                	addi	sp,sp,-32
 400:	ec06                	sd	ra,24(sp)
 402:	e822                	sd	s0,16(sp)
 404:	1000                	addi	s0,sp,32
 406:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40a:	4605                	li	a2,1
 40c:	fef40593          	addi	a1,s0,-17
 410:	f47ff0ef          	jal	356 <write>
}
 414:	60e2                	ld	ra,24(sp)
 416:	6442                	ld	s0,16(sp)
 418:	6105                	addi	sp,sp,32
 41a:	8082                	ret

000000000000041c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41c:	7139                	addi	sp,sp,-64
 41e:	fc06                	sd	ra,56(sp)
 420:	f822                	sd	s0,48(sp)
 422:	f426                	sd	s1,40(sp)
 424:	f04a                	sd	s2,32(sp)
 426:	ec4e                	sd	s3,24(sp)
 428:	0080                	addi	s0,sp,64
 42a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42c:	c299                	beqz	a3,432 <printint+0x16>
 42e:	0605ce63          	bltz	a1,4aa <printint+0x8e>
  neg = 0;
 432:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 434:	fc040313          	addi	t1,s0,-64
  neg = 0;
 438:	869a                	mv	a3,t1
  i = 0;
 43a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 43c:	00000817          	auipc	a6,0x0
 440:	54480813          	addi	a6,a6,1348 # 980 <digits>
 444:	88be                	mv	a7,a5
 446:	0017851b          	addiw	a0,a5,1
 44a:	87aa                	mv	a5,a0
 44c:	02c5f73b          	remuw	a4,a1,a2
 450:	1702                	slli	a4,a4,0x20
 452:	9301                	srli	a4,a4,0x20
 454:	9742                	add	a4,a4,a6
 456:	00074703          	lbu	a4,0(a4)
 45a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 45e:	872e                	mv	a4,a1
 460:	02c5d5bb          	divuw	a1,a1,a2
 464:	0685                	addi	a3,a3,1
 466:	fcc77fe3          	bgeu	a4,a2,444 <printint+0x28>
  if(neg)
 46a:	000e0c63          	beqz	t3,482 <printint+0x66>
    buf[i++] = '-';
 46e:	fd050793          	addi	a5,a0,-48
 472:	00878533          	add	a0,a5,s0
 476:	02d00793          	li	a5,45
 47a:	fef50823          	sb	a5,-16(a0)
 47e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 482:	fff7899b          	addiw	s3,a5,-1
 486:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 48a:	fff4c583          	lbu	a1,-1(s1)
 48e:	854a                	mv	a0,s2
 490:	f6fff0ef          	jal	3fe <putc>
  while(--i >= 0)
 494:	39fd                	addiw	s3,s3,-1
 496:	14fd                	addi	s1,s1,-1
 498:	fe09d9e3          	bgez	s3,48a <printint+0x6e>
}
 49c:	70e2                	ld	ra,56(sp)
 49e:	7442                	ld	s0,48(sp)
 4a0:	74a2                	ld	s1,40(sp)
 4a2:	7902                	ld	s2,32(sp)
 4a4:	69e2                	ld	s3,24(sp)
 4a6:	6121                	addi	sp,sp,64
 4a8:	8082                	ret
    x = -xx;
 4aa:	40b005bb          	negw	a1,a1
    neg = 1;
 4ae:	4e05                	li	t3,1
    x = -xx;
 4b0:	b751                	j	434 <printint+0x18>

00000000000004b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b2:	711d                	addi	sp,sp,-96
 4b4:	ec86                	sd	ra,88(sp)
 4b6:	e8a2                	sd	s0,80(sp)
 4b8:	e4a6                	sd	s1,72(sp)
 4ba:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4bc:	0005c483          	lbu	s1,0(a1)
 4c0:	26048663          	beqz	s1,72c <vprintf+0x27a>
 4c4:	e0ca                	sd	s2,64(sp)
 4c6:	fc4e                	sd	s3,56(sp)
 4c8:	f852                	sd	s4,48(sp)
 4ca:	f456                	sd	s5,40(sp)
 4cc:	f05a                	sd	s6,32(sp)
 4ce:	ec5e                	sd	s7,24(sp)
 4d0:	e862                	sd	s8,16(sp)
 4d2:	e466                	sd	s9,8(sp)
 4d4:	8b2a                	mv	s6,a0
 4d6:	8a2e                	mv	s4,a1
 4d8:	8bb2                	mv	s7,a2
  state = 0;
 4da:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4dc:	4901                	li	s2,0
 4de:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e8:	06c00c93          	li	s9,108
 4ec:	a00d                	j	50e <vprintf+0x5c>
        putc(fd, c0);
 4ee:	85a6                	mv	a1,s1
 4f0:	855a                	mv	a0,s6
 4f2:	f0dff0ef          	jal	3fe <putc>
 4f6:	a019                	j	4fc <vprintf+0x4a>
    } else if(state == '%'){
 4f8:	03598363          	beq	s3,s5,51e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4fc:	0019079b          	addiw	a5,s2,1
 500:	893e                	mv	s2,a5
 502:	873e                	mv	a4,a5
 504:	97d2                	add	a5,a5,s4
 506:	0007c483          	lbu	s1,0(a5)
 50a:	20048963          	beqz	s1,71c <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 50e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 512:	fe0993e3          	bnez	s3,4f8 <vprintf+0x46>
      if(c0 == '%'){
 516:	fd579ce3          	bne	a5,s5,4ee <vprintf+0x3c>
        state = '%';
 51a:	89be                	mv	s3,a5
 51c:	b7c5                	j	4fc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 51e:	00ea06b3          	add	a3,s4,a4
 522:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 526:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 528:	c681                	beqz	a3,530 <vprintf+0x7e>
 52a:	9752                	add	a4,a4,s4
 52c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 530:	03878e63          	beq	a5,s8,56c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 534:	05978863          	beq	a5,s9,584 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 538:	07500713          	li	a4,117
 53c:	0ee78263          	beq	a5,a4,620 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 540:	07800713          	li	a4,120
 544:	12e78463          	beq	a5,a4,66c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 548:	07000713          	li	a4,112
 54c:	14e78963          	beq	a5,a4,69e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 550:	07300713          	li	a4,115
 554:	18e78863          	beq	a5,a4,6e4 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 558:	02500713          	li	a4,37
 55c:	04e79463          	bne	a5,a4,5a4 <vprintf+0xf2>
        putc(fd, '%');
 560:	85ba                	mv	a1,a4
 562:	855a                	mv	a0,s6
 564:	e9bff0ef          	jal	3fe <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 568:	4981                	li	s3,0
 56a:	bf49                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 56c:	008b8493          	addi	s1,s7,8
 570:	4685                	li	a3,1
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	ea3ff0ef          	jal	41c <printint>
 57e:	8ba6                	mv	s7,s1
      state = 0;
 580:	4981                	li	s3,0
 582:	bfad                	j	4fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 584:	06400793          	li	a5,100
 588:	02f68963          	beq	a3,a5,5ba <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58c:	06c00793          	li	a5,108
 590:	04f68263          	beq	a3,a5,5d4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 594:	07500793          	li	a5,117
 598:	0af68063          	beq	a3,a5,638 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 59c:	07800793          	li	a5,120
 5a0:	0ef68263          	beq	a3,a5,684 <vprintf+0x1d2>
        putc(fd, '%');
 5a4:	02500593          	li	a1,37
 5a8:	855a                	mv	a0,s6
 5aa:	e55ff0ef          	jal	3fe <putc>
        putc(fd, c0);
 5ae:	85a6                	mv	a1,s1
 5b0:	855a                	mv	a0,s6
 5b2:	e4dff0ef          	jal	3fe <putc>
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b791                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e55ff0ef          	jal	41c <printint>
        i += 1;
 5cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
        i += 1;
 5d2:	b72d                	j	4fc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d4:	06400793          	li	a5,100
 5d8:	02f60763          	beq	a2,a5,606 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5dc:	07500793          	li	a5,117
 5e0:	06f60963          	beq	a2,a5,652 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e4:	07800793          	li	a5,120
 5e8:	faf61ee3          	bne	a2,a5,5a4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4641                	li	a2,16
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	e23ff0ef          	jal	41c <printint>
        i += 2;
 5fe:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	bde5                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	008b8493          	addi	s1,s7,8
 60a:	4685                	li	a3,1
 60c:	4629                	li	a2,10
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	e09ff0ef          	jal	41c <printint>
        i += 2;
 618:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	bdf9                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	defff0ef          	jal	41c <printint>
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	b5d9                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4629                	li	a2,10
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	dd7ff0ef          	jal	41c <printint>
        i += 1;
 64a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
        i += 1;
 650:	b575                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	008b8493          	addi	s1,s7,8
 656:	4681                	li	a3,0
 658:	4629                	li	a2,10
 65a:	000ba583          	lw	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	dbdff0ef          	jal	41c <printint>
        i += 2;
 664:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	bd49                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 66c:	008b8493          	addi	s1,s7,8
 670:	4681                	li	a3,0
 672:	4641                	li	a2,16
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	da3ff0ef          	jal	41c <printint>
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
 682:	bdad                	j	4fc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	008b8493          	addi	s1,s7,8
 688:	4681                	li	a3,0
 68a:	4641                	li	a2,16
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	d8bff0ef          	jal	41c <printint>
        i += 1;
 696:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
        i += 1;
 69c:	b585                	j	4fc <vprintf+0x4a>
 69e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a0:	008b8d13          	addi	s10,s7,8
 6a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a8:	03000593          	li	a1,48
 6ac:	855a                	mv	a0,s6
 6ae:	d51ff0ef          	jal	3fe <putc>
  putc(fd, 'x');
 6b2:	07800593          	li	a1,120
 6b6:	855a                	mv	a0,s6
 6b8:	d47ff0ef          	jal	3fe <putc>
 6bc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	2c2b8b93          	addi	s7,s7,706 # 980 <digits>
 6c6:	03c9d793          	srli	a5,s3,0x3c
 6ca:	97de                	add	a5,a5,s7
 6cc:	0007c583          	lbu	a1,0(a5)
 6d0:	855a                	mv	a0,s6
 6d2:	d2dff0ef          	jal	3fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d6:	0992                	slli	s3,s3,0x4
 6d8:	34fd                	addiw	s1,s1,-1
 6da:	f4f5                	bnez	s1,6c6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6dc:	8bea                	mv	s7,s10
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	6d02                	ld	s10,0(sp)
 6e2:	bd29                	j	4fc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	008b8993          	addi	s3,s7,8
 6e8:	000bb483          	ld	s1,0(s7)
 6ec:	cc91                	beqz	s1,708 <vprintf+0x256>
        for(; *s; s++)
 6ee:	0004c583          	lbu	a1,0(s1)
 6f2:	c195                	beqz	a1,716 <vprintf+0x264>
          putc(fd, *s);
 6f4:	855a                	mv	a0,s6
 6f6:	d09ff0ef          	jal	3fe <putc>
        for(; *s; s++)
 6fa:	0485                	addi	s1,s1,1
 6fc:	0004c583          	lbu	a1,0(s1)
 700:	f9f5                	bnez	a1,6f4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 702:	8bce                	mv	s7,s3
      state = 0;
 704:	4981                	li	s3,0
 706:	bbdd                	j	4fc <vprintf+0x4a>
          s = "(null)";
 708:	00000497          	auipc	s1,0x0
 70c:	27048493          	addi	s1,s1,624 # 978 <malloc+0x160>
        for(; *s; s++)
 710:	02800593          	li	a1,40
 714:	b7c5                	j	6f4 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 716:	8bce                	mv	s7,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	b3cd                	j	4fc <vprintf+0x4a>
 71c:	6906                	ld	s2,64(sp)
 71e:	79e2                	ld	s3,56(sp)
 720:	7a42                	ld	s4,48(sp)
 722:	7aa2                	ld	s5,40(sp)
 724:	7b02                	ld	s6,32(sp)
 726:	6be2                	ld	s7,24(sp)
 728:	6c42                	ld	s8,16(sp)
 72a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 72c:	60e6                	ld	ra,88(sp)
 72e:	6446                	ld	s0,80(sp)
 730:	64a6                	ld	s1,72(sp)
 732:	6125                	addi	sp,sp,96
 734:	8082                	ret

0000000000000736 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 736:	715d                	addi	sp,sp,-80
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e010                	sd	a2,0(s0)
 740:	e414                	sd	a3,8(s0)
 742:	e818                	sd	a4,16(s0)
 744:	ec1c                	sd	a5,24(s0)
 746:	03043023          	sd	a6,32(s0)
 74a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	8622                	mv	a2,s0
 750:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 754:	d5fff0ef          	jal	4b2 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6161                	addi	sp,sp,80
 75e:	8082                	ret

0000000000000760 <printf>:

void
printf(const char *fmt, ...)
{
 760:	711d                	addi	sp,sp,-96
 762:	ec06                	sd	ra,24(sp)
 764:	e822                	sd	s0,16(sp)
 766:	1000                	addi	s0,sp,32
 768:	e40c                	sd	a1,8(s0)
 76a:	e810                	sd	a2,16(s0)
 76c:	ec14                	sd	a3,24(s0)
 76e:	f018                	sd	a4,32(s0)
 770:	f41c                	sd	a5,40(s0)
 772:	03043823          	sd	a6,48(s0)
 776:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	00840613          	addi	a2,s0,8
 77e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 782:	85aa                	mv	a1,a0
 784:	4505                	li	a0,1
 786:	d2dff0ef          	jal	4b2 <vprintf>
}
 78a:	60e2                	ld	ra,24(sp)
 78c:	6442                	ld	s0,16(sp)
 78e:	6125                	addi	sp,sp,96
 790:	8082                	ret

0000000000000792 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 792:	1141                	addi	sp,sp,-16
 794:	e406                	sd	ra,8(sp)
 796:	e022                	sd	s0,0(sp)
 798:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	00001797          	auipc	a5,0x1
 7a2:	8627b783          	ld	a5,-1950(a5) # 1000 <freep>
 7a6:	a02d                	j	7d0 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a8:	4618                	lw	a4,8(a2)
 7aa:	9f2d                	addw	a4,a4,a1
 7ac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	6398                	ld	a4,0(a5)
 7b2:	6310                	ld	a2,0(a4)
 7b4:	a83d                	j	7f2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b6:	ff852703          	lw	a4,-8(a0)
 7ba:	9f31                	addw	a4,a4,a2
 7bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7be:	ff053683          	ld	a3,-16(a0)
 7c2:	a091                	j	806 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c4:	6398                	ld	a4,0(a5)
 7c6:	00e7e463          	bltu	a5,a4,7ce <free+0x3c>
 7ca:	00e6ea63          	bltu	a3,a4,7de <free+0x4c>
{
 7ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d0:	fed7fae3          	bgeu	a5,a3,7c4 <free+0x32>
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e6e463          	bltu	a3,a4,7de <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7da:	fee7eae3          	bltu	a5,a4,7ce <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7de:	ff852583          	lw	a1,-8(a0)
 7e2:	6390                	ld	a2,0(a5)
 7e4:	02059813          	slli	a6,a1,0x20
 7e8:	01c85713          	srli	a4,a6,0x1c
 7ec:	9736                	add	a4,a4,a3
 7ee:	fae60de3          	beq	a2,a4,7a8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f6:	4790                	lw	a2,8(a5)
 7f8:	02061593          	slli	a1,a2,0x20
 7fc:	01c5d713          	srli	a4,a1,0x1c
 800:	973e                	add	a4,a4,a5
 802:	fae68ae3          	beq	a3,a4,7b6 <free+0x24>
    p->s.ptr = bp->s.ptr;
 806:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 808:	00000717          	auipc	a4,0x0
 80c:	7ef73c23          	sd	a5,2040(a4) # 1000 <freep>
}
 810:	60a2                	ld	ra,8(sp)
 812:	6402                	ld	s0,0(sp)
 814:	0141                	addi	sp,sp,16
 816:	8082                	ret

0000000000000818 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 818:	7139                	addi	sp,sp,-64
 81a:	fc06                	sd	ra,56(sp)
 81c:	f822                	sd	s0,48(sp)
 81e:	f04a                	sd	s2,32(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 824:	02051993          	slli	s3,a0,0x20
 828:	0209d993          	srli	s3,s3,0x20
 82c:	09bd                	addi	s3,s3,15
 82e:	0049d993          	srli	s3,s3,0x4
 832:	2985                	addiw	s3,s3,1
 834:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 836:	00000517          	auipc	a0,0x0
 83a:	7ca53503          	ld	a0,1994(a0) # 1000 <freep>
 83e:	c905                	beqz	a0,86e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	09377663          	bgeu	a4,s3,8d0 <malloc+0xb8>
 848:	f426                	sd	s1,40(sp)
 84a:	e852                	sd	s4,16(sp)
 84c:	e456                	sd	s5,8(sp)
 84e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 850:	8a4e                	mv	s4,s3
 852:	6705                	lui	a4,0x1
 854:	00e9f363          	bgeu	s3,a4,85a <malloc+0x42>
 858:	6a05                	lui	s4,0x1
 85a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 862:	00000497          	auipc	s1,0x0
 866:	79e48493          	addi	s1,s1,1950 # 1000 <freep>
  if(p == (char*)-1)
 86a:	5afd                	li	s5,-1
 86c:	a83d                	j	8aa <malloc+0x92>
 86e:	f426                	sd	s1,40(sp)
 870:	e852                	sd	s4,16(sp)
 872:	e456                	sd	s5,8(sp)
 874:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 876:	00000797          	auipc	a5,0x0
 87a:	79a78793          	addi	a5,a5,1946 # 1010 <base>
 87e:	00000717          	auipc	a4,0x0
 882:	78f73123          	sd	a5,1922(a4) # 1000 <freep>
 886:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 888:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88c:	b7d1                	j	850 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	e118                	sd	a4,0(a0)
 892:	a899                	j	8e8 <malloc+0xd0>
  hp->s.size = nu;
 894:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 898:	0541                	addi	a0,a0,16
 89a:	ef9ff0ef          	jal	792 <free>
  return freep;
 89e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a0:	c125                	beqz	a0,900 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a4:	4798                	lw	a4,8(a5)
 8a6:	03277163          	bgeu	a4,s2,8c8 <malloc+0xb0>
    if(p == freep)
 8aa:	6098                	ld	a4,0(s1)
 8ac:	853e                	mv	a0,a5
 8ae:	fef71ae3          	bne	a4,a5,8a2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b2:	8552                	mv	a0,s4
 8b4:	b0bff0ef          	jal	3be <sbrk>
  if(p == (char*)-1)
 8b8:	fd551ee3          	bne	a0,s5,894 <malloc+0x7c>
        return 0;
 8bc:	4501                	li	a0,0
 8be:	74a2                	ld	s1,40(sp)
 8c0:	6a42                	ld	s4,16(sp)
 8c2:	6aa2                	ld	s5,8(sp)
 8c4:	6b02                	ld	s6,0(sp)
 8c6:	a03d                	j	8f4 <malloc+0xdc>
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d0:	fae90fe3          	beq	s2,a4,88e <malloc+0x76>
        p->s.size -= nunits;
 8d4:	4137073b          	subw	a4,a4,s3
 8d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8da:	02071693          	slli	a3,a4,0x20
 8de:	01c6d713          	srli	a4,a3,0x1c
 8e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70a73c23          	sd	a0,1816(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f0:	01078513          	addi	a0,a5,16
  }
}
 8f4:	70e2                	ld	ra,56(sp)
 8f6:	7442                	ld	s0,48(sp)
 8f8:	7902                	ld	s2,32(sp)
 8fa:	69e2                	ld	s3,24(sp)
 8fc:	6121                	addi	sp,sp,64
 8fe:	8082                	ret
 900:	74a2                	ld	s1,40(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
 908:	b7f5                	j	8f4 <malloc+0xdc>
