
user/_pinfo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/procinfo.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
  int pid;
  struct procinfo pi;

  if (argc != 2) {
   8:	4789                	li	a5,2
   a:	00f50b63          	beq	a0,a5,20 <main+0x20>
    printf("Usage: pinfo <pid>\n");
   e:	00001517          	auipc	a0,0x1
  12:	90250513          	addi	a0,a0,-1790 # 910 <malloc+0xf6>
  16:	74c000ef          	jal	762 <printf>
    exit(1);
  1a:	4505                	li	a0,1
  1c:	31c000ef          	jal	338 <exit>
  }

  pid = atoi(argv[1]);
  20:	6588                	ld	a0,8(a1)
  22:	214000ef          	jal	236 <atoi>

  if (pinfo(pid, &pi) < 0) {
  26:	fc840593          	addi	a1,s0,-56
  2a:	3be000ef          	jal	3e8 <pinfo>
  2e:	04054d63          	bltz	a0,88 <main+0x88>
    printf("pinfo: failed to get info\n");
    exit(1);
  }

  printf("PID: %d\n", pi.pid);
  32:	fc842583          	lw	a1,-56(s0)
  36:	00001517          	auipc	a0,0x1
  3a:	91250513          	addi	a0,a0,-1774 # 948 <malloc+0x12e>
  3e:	724000ef          	jal	762 <printf>
  printf("PPID: %d\n", pi.ppid);
  42:	fcc42583          	lw	a1,-52(s0)
  46:	00001517          	auipc	a0,0x1
  4a:	91250513          	addi	a0,a0,-1774 # 958 <malloc+0x13e>
  4e:	714000ef          	jal	762 <printf>
  printf("State: %d\n", pi.state);
  52:	fd042583          	lw	a1,-48(s0)
  56:	00001517          	auipc	a0,0x1
  5a:	91250513          	addi	a0,a0,-1774 # 968 <malloc+0x14e>
  5e:	704000ef          	jal	762 <printf>
  printf("Memory: %ld bytes\n", pi.sz);
  62:	fd843583          	ld	a1,-40(s0)
  66:	00001517          	auipc	a0,0x1
  6a:	91250513          	addi	a0,a0,-1774 # 978 <malloc+0x15e>
  6e:	6f4000ef          	jal	762 <printf>
  printf("Name: %s\n", pi.name);
  72:	fe040593          	addi	a1,s0,-32
  76:	00001517          	auipc	a0,0x1
  7a:	91a50513          	addi	a0,a0,-1766 # 990 <malloc+0x176>
  7e:	6e4000ef          	jal	762 <printf>

  exit(0);
  82:	4501                	li	a0,0
  84:	2b4000ef          	jal	338 <exit>
    printf("pinfo: failed to get info\n");
  88:	00001517          	auipc	a0,0x1
  8c:	8a050513          	addi	a0,a0,-1888 # 928 <malloc+0x10e>
  90:	6d2000ef          	jal	762 <printf>
    exit(1);
  94:	4505                	li	a0,1
  96:	2a2000ef          	jal	338 <exit>

000000000000009a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  a2:	f5fff0ef          	jal	0 <main>
  exit(0);
  a6:	4501                	li	a0,0
  a8:	290000ef          	jal	338 <exit>

00000000000000ac <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b4:	87aa                	mv	a5,a0
  b6:	0585                	addi	a1,a1,1
  b8:	0785                	addi	a5,a5,1
  ba:	fff5c703          	lbu	a4,-1(a1)
  be:	fee78fa3          	sb	a4,-1(a5)
  c2:	fb75                	bnez	a4,b6 <strcpy+0xa>
    ;
  return os;
}
  c4:	60a2                	ld	ra,8(sp)
  c6:	6402                	ld	s0,0(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cb91                	beqz	a5,ec <strcmp+0x20>
  da:	0005c703          	lbu	a4,0(a1)
  de:	00f71763          	bne	a4,a5,ec <strcmp+0x20>
    p++, q++;
  e2:	0505                	addi	a0,a0,1
  e4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbe5                	bnez	a5,da <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ec:	0005c503          	lbu	a0,0(a1)
}
  f0:	40a7853b          	subw	a0,a5,a0
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strlen>:

uint
strlen(const char *s)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 104:	00054783          	lbu	a5,0(a0)
 108:	cf99                	beqz	a5,126 <strlen+0x2a>
 10a:	0505                	addi	a0,a0,1
 10c:	87aa                	mv	a5,a0
 10e:	86be                	mv	a3,a5
 110:	0785                	addi	a5,a5,1
 112:	fff7c703          	lbu	a4,-1(a5)
 116:	ff65                	bnez	a4,10e <strlen+0x12>
 118:	40a6853b          	subw	a0,a3,a0
 11c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret
  for(n = 0; s[n]; n++)
 126:	4501                	li	a0,0
 128:	bfdd                	j	11e <strlen+0x22>

000000000000012a <memset>:

void*
memset(void *dst, int c, uint n)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 132:	ca19                	beqz	a2,148 <memset+0x1e>
 134:	87aa                	mv	a5,a0
 136:	1602                	slli	a2,a2,0x20
 138:	9201                	srli	a2,a2,0x20
 13a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 142:	0785                	addi	a5,a5,1
 144:	fee79de3          	bne	a5,a4,13e <memset+0x14>
  }
  return dst;
}
 148:	60a2                	ld	ra,8(sp)
 14a:	6402                	ld	s0,0(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  for(; *s; s++)
 158:	00054783          	lbu	a5,0(a0)
 15c:	cf81                	beqz	a5,174 <strchr+0x24>
    if(*s == c)
 15e:	00f58763          	beq	a1,a5,16c <strchr+0x1c>
  for(; *s; s++)
 162:	0505                	addi	a0,a0,1
 164:	00054783          	lbu	a5,0(a0)
 168:	fbfd                	bnez	a5,15e <strchr+0xe>
      return (char*)s;
  return 0;
 16a:	4501                	li	a0,0
}
 16c:	60a2                	ld	ra,8(sp)
 16e:	6402                	ld	s0,0(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret
  return 0;
 174:	4501                	li	a0,0
 176:	bfdd                	j	16c <strchr+0x1c>

0000000000000178 <gets>:

char*
gets(char *buf, int max)
{
 178:	7159                	addi	sp,sp,-112
 17a:	f486                	sd	ra,104(sp)
 17c:	f0a2                	sd	s0,96(sp)
 17e:	eca6                	sd	s1,88(sp)
 180:	e8ca                	sd	s2,80(sp)
 182:	e4ce                	sd	s3,72(sp)
 184:	e0d2                	sd	s4,64(sp)
 186:	fc56                	sd	s5,56(sp)
 188:	f85a                	sd	s6,48(sp)
 18a:	f45e                	sd	s7,40(sp)
 18c:	f062                	sd	s8,32(sp)
 18e:	ec66                	sd	s9,24(sp)
 190:	e86a                	sd	s10,16(sp)
 192:	1880                	addi	s0,sp,112
 194:	8caa                	mv	s9,a0
 196:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 198:	892a                	mv	s2,a0
 19a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 19c:	f9f40b13          	addi	s6,s0,-97
 1a0:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a2:	4ba9                	li	s7,10
 1a4:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1a6:	8d26                	mv	s10,s1
 1a8:	0014899b          	addiw	s3,s1,1
 1ac:	84ce                	mv	s1,s3
 1ae:	0349d563          	bge	s3,s4,1d8 <gets+0x60>
    cc = read(0, &c, 1);
 1b2:	8656                	mv	a2,s5
 1b4:	85da                	mv	a1,s6
 1b6:	4501                	li	a0,0
 1b8:	198000ef          	jal	350 <read>
    if(cc < 1)
 1bc:	00a05e63          	blez	a0,1d8 <gets+0x60>
    buf[i++] = c;
 1c0:	f9f44783          	lbu	a5,-97(s0)
 1c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c8:	01778763          	beq	a5,s7,1d6 <gets+0x5e>
 1cc:	0905                	addi	s2,s2,1
 1ce:	fd879ce3          	bne	a5,s8,1a6 <gets+0x2e>
    buf[i++] = c;
 1d2:	8d4e                	mv	s10,s3
 1d4:	a011                	j	1d8 <gets+0x60>
 1d6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1d8:	9d66                	add	s10,s10,s9
 1da:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1de:	8566                	mv	a0,s9
 1e0:	70a6                	ld	ra,104(sp)
 1e2:	7406                	ld	s0,96(sp)
 1e4:	64e6                	ld	s1,88(sp)
 1e6:	6946                	ld	s2,80(sp)
 1e8:	69a6                	ld	s3,72(sp)
 1ea:	6a06                	ld	s4,64(sp)
 1ec:	7ae2                	ld	s5,56(sp)
 1ee:	7b42                	ld	s6,48(sp)
 1f0:	7ba2                	ld	s7,40(sp)
 1f2:	7c02                	ld	s8,32(sp)
 1f4:	6ce2                	ld	s9,24(sp)
 1f6:	6d42                	ld	s10,16(sp)
 1f8:	6165                	addi	sp,sp,112
 1fa:	8082                	ret

00000000000001fc <stat>:

int
stat(const char *n, struct stat *st)
{
 1fc:	1101                	addi	sp,sp,-32
 1fe:	ec06                	sd	ra,24(sp)
 200:	e822                	sd	s0,16(sp)
 202:	e04a                	sd	s2,0(sp)
 204:	1000                	addi	s0,sp,32
 206:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 208:	4581                	li	a1,0
 20a:	16e000ef          	jal	378 <open>
  if(fd < 0)
 20e:	02054263          	bltz	a0,232 <stat+0x36>
 212:	e426                	sd	s1,8(sp)
 214:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 216:	85ca                	mv	a1,s2
 218:	178000ef          	jal	390 <fstat>
 21c:	892a                	mv	s2,a0
  close(fd);
 21e:	8526                	mv	a0,s1
 220:	140000ef          	jal	360 <close>
  return r;
 224:	64a2                	ld	s1,8(sp)
}
 226:	854a                	mv	a0,s2
 228:	60e2                	ld	ra,24(sp)
 22a:	6442                	ld	s0,16(sp)
 22c:	6902                	ld	s2,0(sp)
 22e:	6105                	addi	sp,sp,32
 230:	8082                	ret
    return -1;
 232:	597d                	li	s2,-1
 234:	bfcd                	j	226 <stat+0x2a>

0000000000000236 <atoi>:

int
atoi(const char *s)
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23e:	00054683          	lbu	a3,0(a0)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	4625                	li	a2,9
 24c:	02f66963          	bltu	a2,a5,27e <atoi+0x48>
 250:	872a                	mv	a4,a0
  n = 0;
 252:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 254:	0705                	addi	a4,a4,1
 256:	0025179b          	slliw	a5,a0,0x2
 25a:	9fa9                	addw	a5,a5,a0
 25c:	0017979b          	slliw	a5,a5,0x1
 260:	9fb5                	addw	a5,a5,a3
 262:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 266:	00074683          	lbu	a3,0(a4)
 26a:	fd06879b          	addiw	a5,a3,-48
 26e:	0ff7f793          	zext.b	a5,a5
 272:	fef671e3          	bgeu	a2,a5,254 <atoi+0x1e>
  return n;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  n = 0;
 27e:	4501                	li	a0,0
 280:	bfdd                	j	276 <atoi+0x40>

0000000000000282 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28a:	02b57563          	bgeu	a0,a1,2b4 <memmove+0x32>
    while(n-- > 0)
 28e:	00c05f63          	blez	a2,2ac <memmove+0x2a>
 292:	1602                	slli	a2,a2,0x20
 294:	9201                	srli	a2,a2,0x20
 296:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 29a:	872a                	mv	a4,a0
      *dst++ = *src++;
 29c:	0585                	addi	a1,a1,1
 29e:	0705                	addi	a4,a4,1
 2a0:	fff5c683          	lbu	a3,-1(a1)
 2a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a8:	fee79ae3          	bne	a5,a4,29c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
    dst += n;
 2b4:	00c50733          	add	a4,a0,a2
    src += n;
 2b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ba:	fec059e3          	blez	a2,2ac <memmove+0x2a>
 2be:	fff6079b          	addiw	a5,a2,-1
 2c2:	1782                	slli	a5,a5,0x20
 2c4:	9381                	srli	a5,a5,0x20
 2c6:	fff7c793          	not	a5,a5
 2ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2cc:	15fd                	addi	a1,a1,-1
 2ce:	177d                	addi	a4,a4,-1
 2d0:	0005c683          	lbu	a3,0(a1)
 2d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d8:	fef71ae3          	bne	a4,a5,2cc <memmove+0x4a>
 2dc:	bfc1                	j	2ac <memmove+0x2a>

00000000000002de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e6:	ca0d                	beqz	a2,318 <memcmp+0x3a>
 2e8:	fff6069b          	addiw	a3,a2,-1
 2ec:	1682                	slli	a3,a3,0x20
 2ee:	9281                	srli	a3,a3,0x20
 2f0:	0685                	addi	a3,a3,1
 2f2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	0005c703          	lbu	a4,0(a1)
 2fc:	00e79863          	bne	a5,a4,30c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 300:	0505                	addi	a0,a0,1
    p2++;
 302:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 304:	fed518e3          	bne	a0,a3,2f4 <memcmp+0x16>
  }
  return 0;
 308:	4501                	li	a0,0
 30a:	a019                	j	310 <memcmp+0x32>
      return *p1 - *p2;
 30c:	40e7853b          	subw	a0,a5,a4
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  return 0;
 318:	4501                	li	a0,0
 31a:	bfdd                	j	310 <memcmp+0x32>

000000000000031c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 324:	f5fff0ef          	jal	282 <memmove>
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 330:	4885                	li	a7,1
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exit>:
.global exit
exit:
 li a7, SYS_exit
 338:	4889                	li	a7,2
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <wait>:
.global wait
wait:
 li a7, SYS_wait
 340:	488d                	li	a7,3
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 348:	4891                	li	a7,4
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <read>:
.global read
read:
 li a7, SYS_read
 350:	4895                	li	a7,5
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <write>:
.global write
write:
 li a7, SYS_write
 358:	48c1                	li	a7,16
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <close>:
.global close
close:
 li a7, SYS_close
 360:	48d5                	li	a7,21
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <kill>:
.global kill
kill:
 li a7, SYS_kill
 368:	4899                	li	a7,6
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <exec>:
.global exec
exec:
 li a7, SYS_exec
 370:	489d                	li	a7,7
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <open>:
.global open
open:
 li a7, SYS_open
 378:	48bd                	li	a7,15
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 380:	48c5                	li	a7,17
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 388:	48c9                	li	a7,18
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 390:	48a1                	li	a7,8
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <link>:
.global link
link:
 li a7, SYS_link
 398:	48cd                	li	a7,19
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a0:	48d1                	li	a7,20
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a8:	48a5                	li	a7,9
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b0:	48a9                	li	a7,10
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b8:	48ad                	li	a7,11
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3c0:	48b1                	li	a7,12
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c8:	48b5                	li	a7,13
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d0:	48b9                	li	a7,14
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 3d8:	48d9                	li	a7,22
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3e0:	48dd                	li	a7,23
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 3e8:	48e1                	li	a7,24
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 3f0:	48e5                	li	a7,25
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 3f8:	48e9                	li	a7,26
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	1000                	addi	s0,sp,32
 408:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40c:	4605                	li	a2,1
 40e:	fef40593          	addi	a1,s0,-17
 412:	f47ff0ef          	jal	358 <write>
}
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6105                	addi	sp,sp,32
 41c:	8082                	ret

000000000000041e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41e:	7139                	addi	sp,sp,-64
 420:	fc06                	sd	ra,56(sp)
 422:	f822                	sd	s0,48(sp)
 424:	f426                	sd	s1,40(sp)
 426:	f04a                	sd	s2,32(sp)
 428:	ec4e                	sd	s3,24(sp)
 42a:	0080                	addi	s0,sp,64
 42c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42e:	c299                	beqz	a3,434 <printint+0x16>
 430:	0605ce63          	bltz	a1,4ac <printint+0x8e>
  neg = 0;
 434:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 436:	fc040313          	addi	t1,s0,-64
  neg = 0;
 43a:	869a                	mv	a3,t1
  i = 0;
 43c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 43e:	00000817          	auipc	a6,0x0
 442:	56a80813          	addi	a6,a6,1386 # 9a8 <digits>
 446:	88be                	mv	a7,a5
 448:	0017851b          	addiw	a0,a5,1
 44c:	87aa                	mv	a5,a0
 44e:	02c5f73b          	remuw	a4,a1,a2
 452:	1702                	slli	a4,a4,0x20
 454:	9301                	srli	a4,a4,0x20
 456:	9742                	add	a4,a4,a6
 458:	00074703          	lbu	a4,0(a4)
 45c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 460:	872e                	mv	a4,a1
 462:	02c5d5bb          	divuw	a1,a1,a2
 466:	0685                	addi	a3,a3,1
 468:	fcc77fe3          	bgeu	a4,a2,446 <printint+0x28>
  if(neg)
 46c:	000e0c63          	beqz	t3,484 <printint+0x66>
    buf[i++] = '-';
 470:	fd050793          	addi	a5,a0,-48
 474:	00878533          	add	a0,a5,s0
 478:	02d00793          	li	a5,45
 47c:	fef50823          	sb	a5,-16(a0)
 480:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 484:	fff7899b          	addiw	s3,a5,-1
 488:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 48c:	fff4c583          	lbu	a1,-1(s1)
 490:	854a                	mv	a0,s2
 492:	f6fff0ef          	jal	400 <putc>
  while(--i >= 0)
 496:	39fd                	addiw	s3,s3,-1
 498:	14fd                	addi	s1,s1,-1
 49a:	fe09d9e3          	bgez	s3,48c <printint+0x6e>
}
 49e:	70e2                	ld	ra,56(sp)
 4a0:	7442                	ld	s0,48(sp)
 4a2:	74a2                	ld	s1,40(sp)
 4a4:	7902                	ld	s2,32(sp)
 4a6:	69e2                	ld	s3,24(sp)
 4a8:	6121                	addi	sp,sp,64
 4aa:	8082                	ret
    x = -xx;
 4ac:	40b005bb          	negw	a1,a1
    neg = 1;
 4b0:	4e05                	li	t3,1
    x = -xx;
 4b2:	b751                	j	436 <printint+0x18>

00000000000004b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b4:	711d                	addi	sp,sp,-96
 4b6:	ec86                	sd	ra,88(sp)
 4b8:	e8a2                	sd	s0,80(sp)
 4ba:	e4a6                	sd	s1,72(sp)
 4bc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4be:	0005c483          	lbu	s1,0(a1)
 4c2:	26048663          	beqz	s1,72e <vprintf+0x27a>
 4c6:	e0ca                	sd	s2,64(sp)
 4c8:	fc4e                	sd	s3,56(sp)
 4ca:	f852                	sd	s4,48(sp)
 4cc:	f456                	sd	s5,40(sp)
 4ce:	f05a                	sd	s6,32(sp)
 4d0:	ec5e                	sd	s7,24(sp)
 4d2:	e862                	sd	s8,16(sp)
 4d4:	e466                	sd	s9,8(sp)
 4d6:	8b2a                	mv	s6,a0
 4d8:	8a2e                	mv	s4,a1
 4da:	8bb2                	mv	s7,a2
  state = 0;
 4dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4de:	4901                	li	s2,0
 4e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	06c00c93          	li	s9,108
 4ee:	a00d                	j	510 <vprintf+0x5c>
        putc(fd, c0);
 4f0:	85a6                	mv	a1,s1
 4f2:	855a                	mv	a0,s6
 4f4:	f0dff0ef          	jal	400 <putc>
 4f8:	a019                	j	4fe <vprintf+0x4a>
    } else if(state == '%'){
 4fa:	03598363          	beq	s3,s5,520 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4fe:	0019079b          	addiw	a5,s2,1
 502:	893e                	mv	s2,a5
 504:	873e                	mv	a4,a5
 506:	97d2                	add	a5,a5,s4
 508:	0007c483          	lbu	s1,0(a5)
 50c:	20048963          	beqz	s1,71e <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 510:	0004879b          	sext.w	a5,s1
    if(state == 0){
 514:	fe0993e3          	bnez	s3,4fa <vprintf+0x46>
      if(c0 == '%'){
 518:	fd579ce3          	bne	a5,s5,4f0 <vprintf+0x3c>
        state = '%';
 51c:	89be                	mv	s3,a5
 51e:	b7c5                	j	4fe <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 520:	00ea06b3          	add	a3,s4,a4
 524:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 528:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 52a:	c681                	beqz	a3,532 <vprintf+0x7e>
 52c:	9752                	add	a4,a4,s4
 52e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 532:	03878e63          	beq	a5,s8,56e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 536:	05978863          	beq	a5,s9,586 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 53a:	07500713          	li	a4,117
 53e:	0ee78263          	beq	a5,a4,622 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 542:	07800713          	li	a4,120
 546:	12e78463          	beq	a5,a4,66e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 54a:	07000713          	li	a4,112
 54e:	14e78963          	beq	a5,a4,6a0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 552:	07300713          	li	a4,115
 556:	18e78863          	beq	a5,a4,6e6 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 55a:	02500713          	li	a4,37
 55e:	04e79463          	bne	a5,a4,5a6 <vprintf+0xf2>
        putc(fd, '%');
 562:	85ba                	mv	a1,a4
 564:	855a                	mv	a0,s6
 566:	e9bff0ef          	jal	400 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf49                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 56e:	008b8493          	addi	s1,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	ea3ff0ef          	jal	41e <printint>
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
 584:	bfad                	j	4fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 586:	06400793          	li	a5,100
 58a:	02f68963          	beq	a3,a5,5bc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58e:	06c00793          	li	a5,108
 592:	04f68263          	beq	a3,a5,5d6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 596:	07500793          	li	a5,117
 59a:	0af68063          	beq	a3,a5,63a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 59e:	07800793          	li	a5,120
 5a2:	0ef68263          	beq	a3,a5,686 <vprintf+0x1d2>
        putc(fd, '%');
 5a6:	02500593          	li	a1,37
 5aa:	855a                	mv	a0,s6
 5ac:	e55ff0ef          	jal	400 <putc>
        putc(fd, c0);
 5b0:	85a6                	mv	a1,s1
 5b2:	855a                	mv	a0,s6
 5b4:	e4dff0ef          	jal	400 <putc>
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b791                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e55ff0ef          	jal	41e <printint>
        i += 1;
 5ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
        i += 1;
 5d4:	b72d                	j	4fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	06400793          	li	a5,100
 5da:	02f60763          	beq	a2,a5,608 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5de:	07500793          	li	a5,117
 5e2:	06f60963          	beq	a2,a5,654 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e6:	07800793          	li	a5,120
 5ea:	faf61ee3          	bne	a2,a5,5a6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	e23ff0ef          	jal	41e <printint>
        i += 2;
 600:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
        i += 2;
 606:	bde5                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 608:	008b8493          	addi	s1,s7,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e09ff0ef          	jal	41e <printint>
        i += 2;
 61a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	bdf9                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	defff0ef          	jal	41e <printint>
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
 638:	b5d9                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	dd7ff0ef          	jal	41e <printint>
        i += 1;
 64c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	b575                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	008b8493          	addi	s1,s7,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dbdff0ef          	jal	41e <printint>
        i += 2;
 666:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	bd49                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	da3ff0ef          	jal	41e <printint>
 680:	8ba6                	mv	s7,s1
      state = 0;
 682:	4981                	li	s3,0
 684:	bdad                	j	4fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	008b8493          	addi	s1,s7,8
 68a:	4681                	li	a3,0
 68c:	4641                	li	a2,16
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	d8bff0ef          	jal	41e <printint>
        i += 1;
 698:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69a:	8ba6                	mv	s7,s1
      state = 0;
 69c:	4981                	li	s3,0
        i += 1;
 69e:	b585                	j	4fe <vprintf+0x4a>
 6a0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a2:	008b8d13          	addi	s10,s7,8
 6a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6aa:	03000593          	li	a1,48
 6ae:	855a                	mv	a0,s6
 6b0:	d51ff0ef          	jal	400 <putc>
  putc(fd, 'x');
 6b4:	07800593          	li	a1,120
 6b8:	855a                	mv	a0,s6
 6ba:	d47ff0ef          	jal	400 <putc>
 6be:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c0:	00000b97          	auipc	s7,0x0
 6c4:	2e8b8b93          	addi	s7,s7,744 # 9a8 <digits>
 6c8:	03c9d793          	srli	a5,s3,0x3c
 6cc:	97de                	add	a5,a5,s7
 6ce:	0007c583          	lbu	a1,0(a5)
 6d2:	855a                	mv	a0,s6
 6d4:	d2dff0ef          	jal	400 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d8:	0992                	slli	s3,s3,0x4
 6da:	34fd                	addiw	s1,s1,-1
 6dc:	f4f5                	bnez	s1,6c8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6de:	8bea                	mv	s7,s10
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	6d02                	ld	s10,0(sp)
 6e4:	bd29                	j	4fe <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	008b8993          	addi	s3,s7,8
 6ea:	000bb483          	ld	s1,0(s7)
 6ee:	cc91                	beqz	s1,70a <vprintf+0x256>
        for(; *s; s++)
 6f0:	0004c583          	lbu	a1,0(s1)
 6f4:	c195                	beqz	a1,718 <vprintf+0x264>
          putc(fd, *s);
 6f6:	855a                	mv	a0,s6
 6f8:	d09ff0ef          	jal	400 <putc>
        for(; *s; s++)
 6fc:	0485                	addi	s1,s1,1
 6fe:	0004c583          	lbu	a1,0(s1)
 702:	f9f5                	bnez	a1,6f6 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	bbdd                	j	4fe <vprintf+0x4a>
          s = "(null)";
 70a:	00000497          	auipc	s1,0x0
 70e:	29648493          	addi	s1,s1,662 # 9a0 <malloc+0x186>
        for(; *s; s++)
 712:	02800593          	li	a1,40
 716:	b7c5                	j	6f6 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 718:	8bce                	mv	s7,s3
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b3cd                	j	4fe <vprintf+0x4a>
 71e:	6906                	ld	s2,64(sp)
 720:	79e2                	ld	s3,56(sp)
 722:	7a42                	ld	s4,48(sp)
 724:	7aa2                	ld	s5,40(sp)
 726:	7b02                	ld	s6,32(sp)
 728:	6be2                	ld	s7,24(sp)
 72a:	6c42                	ld	s8,16(sp)
 72c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 72e:	60e6                	ld	ra,88(sp)
 730:	6446                	ld	s0,80(sp)
 732:	64a6                	ld	s1,72(sp)
 734:	6125                	addi	sp,sp,96
 736:	8082                	ret

0000000000000738 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 738:	715d                	addi	sp,sp,-80
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e010                	sd	a2,0(s0)
 742:	e414                	sd	a3,8(s0)
 744:	e818                	sd	a4,16(s0)
 746:	ec1c                	sd	a5,24(s0)
 748:	03043023          	sd	a6,32(s0)
 74c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	8622                	mv	a2,s0
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	d5fff0ef          	jal	4b4 <vprintf>
}
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	6161                	addi	sp,sp,80
 760:	8082                	ret

0000000000000762 <printf>:

void
printf(const char *fmt, ...)
{
 762:	711d                	addi	sp,sp,-96
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e40c                	sd	a1,8(s0)
 76c:	e810                	sd	a2,16(s0)
 76e:	ec14                	sd	a3,24(s0)
 770:	f018                	sd	a4,32(s0)
 772:	f41c                	sd	a5,40(s0)
 774:	03043823          	sd	a6,48(s0)
 778:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	00840613          	addi	a2,s0,8
 780:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 784:	85aa                	mv	a1,a0
 786:	4505                	li	a0,1
 788:	d2dff0ef          	jal	4b4 <vprintf>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6125                	addi	sp,sp,96
 792:	8082                	ret

0000000000000794 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 794:	1141                	addi	sp,sp,-16
 796:	e406                	sd	ra,8(sp)
 798:	e022                	sd	s0,0(sp)
 79a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	00001797          	auipc	a5,0x1
 7a4:	8607b783          	ld	a5,-1952(a5) # 1000 <freep>
 7a8:	a02d                	j	7d2 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7aa:	4618                	lw	a4,8(a2)
 7ac:	9f2d                	addw	a4,a4,a1
 7ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	6310                	ld	a2,0(a4)
 7b6:	a83d                	j	7f4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b8:	ff852703          	lw	a4,-8(a0)
 7bc:	9f31                	addw	a4,a4,a2
 7be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c0:	ff053683          	ld	a3,-16(a0)
 7c4:	a091                	j	808 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e7e463          	bltu	a5,a4,7d0 <free+0x3c>
 7cc:	00e6ea63          	bltu	a3,a4,7e0 <free+0x4c>
{
 7d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	fed7fae3          	bgeu	a5,a3,7c6 <free+0x32>
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e6e463          	bltu	a3,a4,7e0 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	fee7eae3          	bltu	a5,a4,7d0 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7e0:	ff852583          	lw	a1,-8(a0)
 7e4:	6390                	ld	a2,0(a5)
 7e6:	02059813          	slli	a6,a1,0x20
 7ea:	01c85713          	srli	a4,a6,0x1c
 7ee:	9736                	add	a4,a4,a3
 7f0:	fae60de3          	beq	a2,a4,7aa <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f8:	4790                	lw	a2,8(a5)
 7fa:	02061593          	slli	a1,a2,0x20
 7fe:	01c5d713          	srli	a4,a1,0x1c
 802:	973e                	add	a4,a4,a5
 804:	fae68ae3          	beq	a3,a4,7b8 <free+0x24>
    p->s.ptr = bp->s.ptr;
 808:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80a:	00000717          	auipc	a4,0x0
 80e:	7ef73b23          	sd	a5,2038(a4) # 1000 <freep>
}
 812:	60a2                	ld	ra,8(sp)
 814:	6402                	ld	s0,0(sp)
 816:	0141                	addi	sp,sp,16
 818:	8082                	ret

000000000000081a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81a:	7139                	addi	sp,sp,-64
 81c:	fc06                	sd	ra,56(sp)
 81e:	f822                	sd	s0,48(sp)
 820:	f04a                	sd	s2,32(sp)
 822:	ec4e                	sd	s3,24(sp)
 824:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 826:	02051993          	slli	s3,a0,0x20
 82a:	0209d993          	srli	s3,s3,0x20
 82e:	09bd                	addi	s3,s3,15
 830:	0049d993          	srli	s3,s3,0x4
 834:	2985                	addiw	s3,s3,1
 836:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 838:	00000517          	auipc	a0,0x0
 83c:	7c853503          	ld	a0,1992(a0) # 1000 <freep>
 840:	c905                	beqz	a0,870 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 844:	4798                	lw	a4,8(a5)
 846:	09377663          	bgeu	a4,s3,8d2 <malloc+0xb8>
 84a:	f426                	sd	s1,40(sp)
 84c:	e852                	sd	s4,16(sp)
 84e:	e456                	sd	s5,8(sp)
 850:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 852:	8a4e                	mv	s4,s3
 854:	6705                	lui	a4,0x1
 856:	00e9f363          	bgeu	s3,a4,85c <malloc+0x42>
 85a:	6a05                	lui	s4,0x1
 85c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 860:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 864:	00000497          	auipc	s1,0x0
 868:	79c48493          	addi	s1,s1,1948 # 1000 <freep>
  if(p == (char*)-1)
 86c:	5afd                	li	s5,-1
 86e:	a83d                	j	8ac <malloc+0x92>
 870:	f426                	sd	s1,40(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 878:	00000797          	auipc	a5,0x0
 87c:	79878793          	addi	a5,a5,1944 # 1010 <base>
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
 888:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88e:	b7d1                	j	852 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 890:	6398                	ld	a4,0(a5)
 892:	e118                	sd	a4,0(a0)
 894:	a899                	j	8ea <malloc+0xd0>
  hp->s.size = nu;
 896:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89a:	0541                	addi	a0,a0,16
 89c:	ef9ff0ef          	jal	794 <free>
  return freep;
 8a0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a2:	c125                	beqz	a0,902 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a6:	4798                	lw	a4,8(a5)
 8a8:	03277163          	bgeu	a4,s2,8ca <malloc+0xb0>
    if(p == freep)
 8ac:	6098                	ld	a4,0(s1)
 8ae:	853e                	mv	a0,a5
 8b0:	fef71ae3          	bne	a4,a5,8a4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b4:	8552                	mv	a0,s4
 8b6:	b0bff0ef          	jal	3c0 <sbrk>
  if(p == (char*)-1)
 8ba:	fd551ee3          	bne	a0,s5,896 <malloc+0x7c>
        return 0;
 8be:	4501                	li	a0,0
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	a03d                	j	8f6 <malloc+0xdc>
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d2:	fae90fe3          	beq	s2,a4,890 <malloc+0x76>
        p->s.size -= nunits;
 8d6:	4137073b          	subw	a4,a4,s3
 8da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8dc:	02071693          	slli	a3,a4,0x20
 8e0:	01c6d713          	srli	a4,a3,0x1c
 8e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ea:	00000717          	auipc	a4,0x0
 8ee:	70a73b23          	sd	a0,1814(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f2:	01078513          	addi	a0,a5,16
  }
}
 8f6:	70e2                	ld	ra,56(sp)
 8f8:	7442                	ld	s0,48(sp)
 8fa:	7902                	ld	s2,32(sp)
 8fc:	69e2                	ld	s3,24(sp)
 8fe:	6121                	addi	sp,sp,64
 900:	8082                	ret
 902:	74a2                	ld	s1,40(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	b7f5                	j	8f6 <malloc+0xdc>
