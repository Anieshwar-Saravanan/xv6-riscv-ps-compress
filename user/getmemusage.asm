
user/_getmemusage:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    if (argc != 2) {
   8:	4789                	li	a5,2
   a:	00f50c63          	beq	a0,a5,22 <main+0x22>
   e:	e426                	sd	s1,8(sp)
        printf("Usage: test_getmemusage <pid>\n");
  10:	00001517          	auipc	a0,0x1
  14:	8d050513          	addi	a0,a0,-1840 # 8e0 <malloc+0xfc>
  18:	714000ef          	jal	72c <printf>
        exit(1);
  1c:	4505                	li	a0,1
  1e:	2e4000ef          	jal	302 <exit>
  22:	e426                	sd	s1,8(sp)
    }

    int pid = atoi(argv[1]);
  24:	6588                	ld	a0,8(a1)
  26:	1da000ef          	jal	200 <atoi>
  2a:	84aa                	mv	s1,a0
    int mem = getmemusage(pid);
  2c:	376000ef          	jal	3a2 <getmemusage>
  30:	862a                	mv	a2,a0
    if (mem == -1) {
  32:	57fd                	li	a5,-1
  34:	02f50063          	beq	a0,a5,54 <main+0x54>
        printf("Process %d not found.\n", pid);
    } else {
        printf("Memory used by process %d: %d bytes\n", pid, mem);
  38:	85a6                	mv	a1,s1
  3a:	00001517          	auipc	a0,0x1
  3e:	8de50513          	addi	a0,a0,-1826 # 918 <malloc+0x134>
  42:	6ea000ef          	jal	72c <printf>
    }
    sleep(100);
  46:	06400513          	li	a0,100
  4a:	348000ef          	jal	392 <sleep>

    exit(0);
  4e:	4501                	li	a0,0
  50:	2b2000ef          	jal	302 <exit>
        printf("Process %d not found.\n", pid);
  54:	85a6                	mv	a1,s1
  56:	00001517          	auipc	a0,0x1
  5a:	8aa50513          	addi	a0,a0,-1878 # 900 <malloc+0x11c>
  5e:	6ce000ef          	jal	72c <printf>
  62:	b7d5                	j	46 <main+0x46>

0000000000000064 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6c:	f95ff0ef          	jal	0 <main>
  exit(0);
  70:	4501                	li	a0,0
  72:	290000ef          	jal	302 <exit>

0000000000000076 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0xa>
    ;
  return os;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x20>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x20>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf99                	beqz	a5,f0 <strlen+0x2a>
  d4:	0505                	addi	a0,a0,1
  d6:	87aa                	mv	a5,a0
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x12>
  e2:	40a6853b          	subw	a0,a3,a0
  e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfdd                	j	e8 <strlen+0x22>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ca19                	beqz	a2,112 <memset+0x1e>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x14>
  }
  return dst;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strchr>:

char*
strchr(const char *s, char c)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  for(; *s; s++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf81                	beqz	a5,13e <strchr+0x24>
    if(*s == c)
 128:	00f58763          	beq	a1,a5,136 <strchr+0x1c>
  for(; *s; s++)
 12c:	0505                	addi	a0,a0,1
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbfd                	bnez	a5,128 <strchr+0xe>
      return (char*)s;
  return 0;
 134:	4501                	li	a0,0
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfdd                	j	136 <strchr+0x1c>

0000000000000142 <gets>:

char*
gets(char *buf, int max)
{
 142:	7159                	addi	sp,sp,-112
 144:	f486                	sd	ra,104(sp)
 146:	f0a2                	sd	s0,96(sp)
 148:	eca6                	sd	s1,88(sp)
 14a:	e8ca                	sd	s2,80(sp)
 14c:	e4ce                	sd	s3,72(sp)
 14e:	e0d2                	sd	s4,64(sp)
 150:	fc56                	sd	s5,56(sp)
 152:	f85a                	sd	s6,48(sp)
 154:	f45e                	sd	s7,40(sp)
 156:	f062                	sd	s8,32(sp)
 158:	ec66                	sd	s9,24(sp)
 15a:	e86a                	sd	s10,16(sp)
 15c:	1880                	addi	s0,sp,112
 15e:	8caa                	mv	s9,a0
 160:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 162:	892a                	mv	s2,a0
 164:	4481                	li	s1,0
    cc = read(0, &c, 1);
 166:	f9f40b13          	addi	s6,s0,-97
 16a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16c:	4ba9                	li	s7,10
 16e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 170:	8d26                	mv	s10,s1
 172:	0014899b          	addiw	s3,s1,1
 176:	84ce                	mv	s1,s3
 178:	0349d563          	bge	s3,s4,1a2 <gets+0x60>
    cc = read(0, &c, 1);
 17c:	8656                	mv	a2,s5
 17e:	85da                	mv	a1,s6
 180:	4501                	li	a0,0
 182:	198000ef          	jal	31a <read>
    if(cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x60>
    buf[i++] = c;
 18a:	f9f44783          	lbu	a5,-97(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	01778763          	beq	a5,s7,1a0 <gets+0x5e>
 196:	0905                	addi	s2,s2,1
 198:	fd879ce3          	bne	a5,s8,170 <gets+0x2e>
    buf[i++] = c;
 19c:	8d4e                	mv	s10,s3
 19e:	a011                	j	1a2 <gets+0x60>
 1a0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1a2:	9d66                	add	s10,s10,s9
 1a4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1a8:	8566                	mv	a0,s9
 1aa:	70a6                	ld	ra,104(sp)
 1ac:	7406                	ld	s0,96(sp)
 1ae:	64e6                	ld	s1,88(sp)
 1b0:	6946                	ld	s2,80(sp)
 1b2:	69a6                	ld	s3,72(sp)
 1b4:	6a06                	ld	s4,64(sp)
 1b6:	7ae2                	ld	s5,56(sp)
 1b8:	7b42                	ld	s6,48(sp)
 1ba:	7ba2                	ld	s7,40(sp)
 1bc:	7c02                	ld	s8,32(sp)
 1be:	6ce2                	ld	s9,24(sp)
 1c0:	6d42                	ld	s10,16(sp)
 1c2:	6165                	addi	sp,sp,112
 1c4:	8082                	ret

00000000000001c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c6:	1101                	addi	sp,sp,-32
 1c8:	ec06                	sd	ra,24(sp)
 1ca:	e822                	sd	s0,16(sp)
 1cc:	e04a                	sd	s2,0(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	4581                	li	a1,0
 1d4:	16e000ef          	jal	342 <open>
  if(fd < 0)
 1d8:	02054263          	bltz	a0,1fc <stat+0x36>
 1dc:	e426                	sd	s1,8(sp)
 1de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e0:	85ca                	mv	a1,s2
 1e2:	178000ef          	jal	35a <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	140000ef          	jal	32a <close>
  return r;
 1ee:	64a2                	ld	s1,8(sp)
}
 1f0:	854a                	mv	a0,s2
 1f2:	60e2                	ld	ra,24(sp)
 1f4:	6442                	ld	s0,16(sp)
 1f6:	6902                	ld	s2,0(sp)
 1f8:	6105                	addi	sp,sp,32
 1fa:	8082                	ret
    return -1;
 1fc:	597d                	li	s2,-1
 1fe:	bfcd                	j	1f0 <stat+0x2a>

0000000000000200 <atoi>:

int
atoi(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 208:	00054683          	lbu	a3,0(a0)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	4625                	li	a2,9
 216:	02f66963          	bltu	a2,a5,248 <atoi+0x48>
 21a:	872a                	mv	a4,a0
  n = 0;
 21c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21e:	0705                	addi	a4,a4,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb5                	addw	a5,a5,a3
 22c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 230:	00074683          	lbu	a3,0(a4)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	fef671e3          	bgeu	a2,a5,21e <atoi+0x1e>
  return n;
}
 240:	60a2                	ld	ra,8(sp)
 242:	6402                	ld	s0,0(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfdd                	j	240 <atoi+0x40>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57563          	bgeu	a0,a1,27e <memmove+0x32>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x2a>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
    dst += n;
 27e:	00c50733          	add	a4,a0,a2
    src += n;
 282:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 284:	fec059e3          	blez	a2,276 <memmove+0x2a>
 288:	fff6079b          	addiw	a5,a2,-1
 28c:	1782                	slli	a5,a5,0x20
 28e:	9381                	srli	a5,a5,0x20
 290:	fff7c793          	not	a5,a5
 294:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 296:	15fd                	addi	a1,a1,-1
 298:	177d                	addi	a4,a4,-1
 29a:	0005c683          	lbu	a3,0(a1)
 29e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a2:	fef71ae3          	bne	a4,a5,296 <memmove+0x4a>
 2a6:	bfc1                	j	276 <memmove+0x2a>

00000000000002a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	ca0d                	beqz	a2,2e2 <memcmp+0x3a>
 2b2:	fff6069b          	addiw	a3,a2,-1
 2b6:	1682                	slli	a3,a3,0x20
 2b8:	9281                	srli	a3,a3,0x20
 2ba:	0685                	addi	a3,a3,1
 2bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00e79863          	bne	a5,a4,2d6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2ca:	0505                	addi	a0,a0,1
    p2++;
 2cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ce:	fed518e3          	bne	a0,a3,2be <memcmp+0x16>
  }
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	a019                	j	2da <memcmp+0x32>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	bfdd                	j	2da <memcmp+0x32>

00000000000002e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ee:	f5fff0ef          	jal	24c <memmove>
}
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fa:	4885                	li	a7,1
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <exit>:
.global exit
exit:
 li a7, SYS_exit
 302:	4889                	li	a7,2
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <wait>:
.global wait
wait:
 li a7, SYS_wait
 30a:	488d                	li	a7,3
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 312:	4891                	li	a7,4
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <read>:
.global read
read:
 li a7, SYS_read
 31a:	4895                	li	a7,5
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <write>:
.global write
write:
 li a7, SYS_write
 322:	48c1                	li	a7,16
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <close>:
.global close
close:
 li a7, SYS_close
 32a:	48d5                	li	a7,21
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <kill>:
.global kill
kill:
 li a7, SYS_kill
 332:	4899                	li	a7,6
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <exec>:
.global exec
exec:
 li a7, SYS_exec
 33a:	489d                	li	a7,7
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <open>:
.global open
open:
 li a7, SYS_open
 342:	48bd                	li	a7,15
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34a:	48c5                	li	a7,17
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 352:	48c9                	li	a7,18
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35a:	48a1                	li	a7,8
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <link>:
.global link
link:
 li a7, SYS_link
 362:	48cd                	li	a7,19
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36a:	48d1                	li	a7,20
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 372:	48a5                	li	a7,9
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <dup>:
.global dup
dup:
 li a7, SYS_dup
 37a:	48a9                	li	a7,10
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 382:	48ad                	li	a7,11
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38a:	48b1                	li	a7,12
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 392:	48b5                	li	a7,13
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39a:	48b9                	li	a7,14
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 3a2:	48d9                	li	a7,22
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <ps>:
.global ps
ps:
 li a7, SYS_ps
 3aa:	48dd                	li	a7,23
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 3b2:	48e1                	li	a7,24
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 3ba:	48e5                	li	a7,25
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 3c2:	48e9                	li	a7,26
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	1000                	addi	s0,sp,32
 3d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d6:	4605                	li	a2,1
 3d8:	fef40593          	addi	a1,s0,-17
 3dc:	f47ff0ef          	jal	322 <write>
}
 3e0:	60e2                	ld	ra,24(sp)
 3e2:	6442                	ld	s0,16(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e8:	7139                	addi	sp,sp,-64
 3ea:	fc06                	sd	ra,56(sp)
 3ec:	f822                	sd	s0,48(sp)
 3ee:	f426                	sd	s1,40(sp)
 3f0:	f04a                	sd	s2,32(sp)
 3f2:	ec4e                	sd	s3,24(sp)
 3f4:	0080                	addi	s0,sp,64
 3f6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f8:	c299                	beqz	a3,3fe <printint+0x16>
 3fa:	0605ce63          	bltz	a1,476 <printint+0x8e>
  neg = 0;
 3fe:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 400:	fc040313          	addi	t1,s0,-64
  neg = 0;
 404:	869a                	mv	a3,t1
  i = 0;
 406:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 408:	00000817          	auipc	a6,0x0
 40c:	54080813          	addi	a6,a6,1344 # 948 <digits>
 410:	88be                	mv	a7,a5
 412:	0017851b          	addiw	a0,a5,1
 416:	87aa                	mv	a5,a0
 418:	02c5f73b          	remuw	a4,a1,a2
 41c:	1702                	slli	a4,a4,0x20
 41e:	9301                	srli	a4,a4,0x20
 420:	9742                	add	a4,a4,a6
 422:	00074703          	lbu	a4,0(a4)
 426:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 42a:	872e                	mv	a4,a1
 42c:	02c5d5bb          	divuw	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fcc77fe3          	bgeu	a4,a2,410 <printint+0x28>
  if(neg)
 436:	000e0c63          	beqz	t3,44e <printint+0x66>
    buf[i++] = '-';
 43a:	fd050793          	addi	a5,a0,-48
 43e:	00878533          	add	a0,a5,s0
 442:	02d00793          	li	a5,45
 446:	fef50823          	sb	a5,-16(a0)
 44a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 44e:	fff7899b          	addiw	s3,a5,-1
 452:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 456:	fff4c583          	lbu	a1,-1(s1)
 45a:	854a                	mv	a0,s2
 45c:	f6fff0ef          	jal	3ca <putc>
  while(--i >= 0)
 460:	39fd                	addiw	s3,s3,-1
 462:	14fd                	addi	s1,s1,-1
 464:	fe09d9e3          	bgez	s3,456 <printint+0x6e>
}
 468:	70e2                	ld	ra,56(sp)
 46a:	7442                	ld	s0,48(sp)
 46c:	74a2                	ld	s1,40(sp)
 46e:	7902                	ld	s2,32(sp)
 470:	69e2                	ld	s3,24(sp)
 472:	6121                	addi	sp,sp,64
 474:	8082                	ret
    x = -xx;
 476:	40b005bb          	negw	a1,a1
    neg = 1;
 47a:	4e05                	li	t3,1
    x = -xx;
 47c:	b751                	j	400 <printint+0x18>

000000000000047e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47e:	711d                	addi	sp,sp,-96
 480:	ec86                	sd	ra,88(sp)
 482:	e8a2                	sd	s0,80(sp)
 484:	e4a6                	sd	s1,72(sp)
 486:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 488:	0005c483          	lbu	s1,0(a1)
 48c:	26048663          	beqz	s1,6f8 <vprintf+0x27a>
 490:	e0ca                	sd	s2,64(sp)
 492:	fc4e                	sd	s3,56(sp)
 494:	f852                	sd	s4,48(sp)
 496:	f456                	sd	s5,40(sp)
 498:	f05a                	sd	s6,32(sp)
 49a:	ec5e                	sd	s7,24(sp)
 49c:	e862                	sd	s8,16(sp)
 49e:	e466                	sd	s9,8(sp)
 4a0:	8b2a                	mv	s6,a0
 4a2:	8a2e                	mv	s4,a1
 4a4:	8bb2                	mv	s7,a2
  state = 0;
 4a6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a8:	4901                	li	s2,0
 4aa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ac:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b4:	06c00c93          	li	s9,108
 4b8:	a00d                	j	4da <vprintf+0x5c>
        putc(fd, c0);
 4ba:	85a6                	mv	a1,s1
 4bc:	855a                	mv	a0,s6
 4be:	f0dff0ef          	jal	3ca <putc>
 4c2:	a019                	j	4c8 <vprintf+0x4a>
    } else if(state == '%'){
 4c4:	03598363          	beq	s3,s5,4ea <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4c8:	0019079b          	addiw	a5,s2,1
 4cc:	893e                	mv	s2,a5
 4ce:	873e                	mv	a4,a5
 4d0:	97d2                	add	a5,a5,s4
 4d2:	0007c483          	lbu	s1,0(a5)
 4d6:	20048963          	beqz	s1,6e8 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4da:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4de:	fe0993e3          	bnez	s3,4c4 <vprintf+0x46>
      if(c0 == '%'){
 4e2:	fd579ce3          	bne	a5,s5,4ba <vprintf+0x3c>
        state = '%';
 4e6:	89be                	mv	s3,a5
 4e8:	b7c5                	j	4c8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ea:	00ea06b3          	add	a3,s4,a4
 4ee:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f4:	c681                	beqz	a3,4fc <vprintf+0x7e>
 4f6:	9752                	add	a4,a4,s4
 4f8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4fc:	03878e63          	beq	a5,s8,538 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 500:	05978863          	beq	a5,s9,550 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 504:	07500713          	li	a4,117
 508:	0ee78263          	beq	a5,a4,5ec <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50c:	07800713          	li	a4,120
 510:	12e78463          	beq	a5,a4,638 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 514:	07000713          	li	a4,112
 518:	14e78963          	beq	a5,a4,66a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 51c:	07300713          	li	a4,115
 520:	18e78863          	beq	a5,a4,6b0 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 524:	02500713          	li	a4,37
 528:	04e79463          	bne	a5,a4,570 <vprintf+0xf2>
        putc(fd, '%');
 52c:	85ba                	mv	a1,a4
 52e:	855a                	mv	a0,s6
 530:	e9bff0ef          	jal	3ca <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 534:	4981                	li	s3,0
 536:	bf49                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 538:	008b8493          	addi	s1,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	ea3ff0ef          	jal	3e8 <printint>
 54a:	8ba6                	mv	s7,s1
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bfad                	j	4c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 550:	06400793          	li	a5,100
 554:	02f68963          	beq	a3,a5,586 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 558:	06c00793          	li	a5,108
 55c:	04f68263          	beq	a3,a5,5a0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 560:	07500793          	li	a5,117
 564:	0af68063          	beq	a3,a5,604 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 568:	07800793          	li	a5,120
 56c:	0ef68263          	beq	a3,a5,650 <vprintf+0x1d2>
        putc(fd, '%');
 570:	02500593          	li	a1,37
 574:	855a                	mv	a0,s6
 576:	e55ff0ef          	jal	3ca <putc>
        putc(fd, c0);
 57a:	85a6                	mv	a1,s1
 57c:	855a                	mv	a0,s6
 57e:	e4dff0ef          	jal	3ca <putc>
      state = 0;
 582:	4981                	li	s3,0
 584:	b791                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	008b8493          	addi	s1,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e55ff0ef          	jal	3e8 <printint>
        i += 1;
 598:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
        i += 1;
 59e:	b72d                	j	4c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a0:	06400793          	li	a5,100
 5a4:	02f60763          	beq	a2,a5,5d2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a8:	07500793          	li	a5,117
 5ac:	06f60963          	beq	a2,a5,61e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b0:	07800793          	li	a5,120
 5b4:	faf61ee3          	bne	a2,a5,570 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	e23ff0ef          	jal	3e8 <printint>
        i += 2;
 5ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
        i += 2;
 5d0:	bde5                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	e09ff0ef          	jal	3e8 <printint>
        i += 2;
 5e4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	bdf9                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	defff0ef          	jal	3e8 <printint>
 5fe:	8ba6                	mv	s7,s1
      state = 0;
 600:	4981                	li	s3,0
 602:	b5d9                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	008b8493          	addi	s1,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	dd7ff0ef          	jal	3e8 <printint>
        i += 1;
 616:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 618:	8ba6                	mv	s7,s1
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	b575                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b8493          	addi	s1,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000ba583          	lw	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	dbdff0ef          	jal	3e8 <printint>
        i += 2;
 630:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
        i += 2;
 636:	bd49                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	da3ff0ef          	jal	3e8 <printint>
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bdad                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	008b8493          	addi	s1,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	d8bff0ef          	jal	3e8 <printint>
        i += 1;
 662:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
        i += 1;
 668:	b585                	j	4c8 <vprintf+0x4a>
 66a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66c:	008b8d13          	addi	s10,s7,8
 670:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 674:	03000593          	li	a1,48
 678:	855a                	mv	a0,s6
 67a:	d51ff0ef          	jal	3ca <putc>
  putc(fd, 'x');
 67e:	07800593          	li	a1,120
 682:	855a                	mv	a0,s6
 684:	d47ff0ef          	jal	3ca <putc>
 688:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	00000b97          	auipc	s7,0x0
 68e:	2beb8b93          	addi	s7,s7,702 # 948 <digits>
 692:	03c9d793          	srli	a5,s3,0x3c
 696:	97de                	add	a5,a5,s7
 698:	0007c583          	lbu	a1,0(a5)
 69c:	855a                	mv	a0,s6
 69e:	d2dff0ef          	jal	3ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	34fd                	addiw	s1,s1,-1
 6a6:	f4f5                	bnez	s1,692 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6a8:	8bea                	mv	s7,s10
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	6d02                	ld	s10,0(sp)
 6ae:	bd29                	j	4c8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6b0:	008b8993          	addi	s3,s7,8
 6b4:	000bb483          	ld	s1,0(s7)
 6b8:	cc91                	beqz	s1,6d4 <vprintf+0x256>
        for(; *s; s++)
 6ba:	0004c583          	lbu	a1,0(s1)
 6be:	c195                	beqz	a1,6e2 <vprintf+0x264>
          putc(fd, *s);
 6c0:	855a                	mv	a0,s6
 6c2:	d09ff0ef          	jal	3ca <putc>
        for(; *s; s++)
 6c6:	0485                	addi	s1,s1,1
 6c8:	0004c583          	lbu	a1,0(s1)
 6cc:	f9f5                	bnez	a1,6c0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bbdd                	j	4c8 <vprintf+0x4a>
          s = "(null)";
 6d4:	00000497          	auipc	s1,0x0
 6d8:	26c48493          	addi	s1,s1,620 # 940 <malloc+0x15c>
        for(; *s; s++)
 6dc:	02800593          	li	a1,40
 6e0:	b7c5                	j	6c0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6e2:	8bce                	mv	s7,s3
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b3cd                	j	4c8 <vprintf+0x4a>
 6e8:	6906                	ld	s2,64(sp)
 6ea:	79e2                	ld	s3,56(sp)
 6ec:	7a42                	ld	s4,48(sp)
 6ee:	7aa2                	ld	s5,40(sp)
 6f0:	7b02                	ld	s6,32(sp)
 6f2:	6be2                	ld	s7,24(sp)
 6f4:	6c42                	ld	s8,16(sp)
 6f6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6f8:	60e6                	ld	ra,88(sp)
 6fa:	6446                	ld	s0,80(sp)
 6fc:	64a6                	ld	s1,72(sp)
 6fe:	6125                	addi	sp,sp,96
 700:	8082                	ret

0000000000000702 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 702:	715d                	addi	sp,sp,-80
 704:	ec06                	sd	ra,24(sp)
 706:	e822                	sd	s0,16(sp)
 708:	1000                	addi	s0,sp,32
 70a:	e010                	sd	a2,0(s0)
 70c:	e414                	sd	a3,8(s0)
 70e:	e818                	sd	a4,16(s0)
 710:	ec1c                	sd	a5,24(s0)
 712:	03043023          	sd	a6,32(s0)
 716:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71a:	8622                	mv	a2,s0
 71c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 720:	d5fff0ef          	jal	47e <vprintf>
}
 724:	60e2                	ld	ra,24(sp)
 726:	6442                	ld	s0,16(sp)
 728:	6161                	addi	sp,sp,80
 72a:	8082                	ret

000000000000072c <printf>:

void
printf(const char *fmt, ...)
{
 72c:	711d                	addi	sp,sp,-96
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e40c                	sd	a1,8(s0)
 736:	e810                	sd	a2,16(s0)
 738:	ec14                	sd	a3,24(s0)
 73a:	f018                	sd	a4,32(s0)
 73c:	f41c                	sd	a5,40(s0)
 73e:	03043823          	sd	a6,48(s0)
 742:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 746:	00840613          	addi	a2,s0,8
 74a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74e:	85aa                	mv	a1,a0
 750:	4505                	li	a0,1
 752:	d2dff0ef          	jal	47e <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6125                	addi	sp,sp,96
 75c:	8082                	ret

000000000000075e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75e:	1141                	addi	sp,sp,-16
 760:	e406                	sd	ra,8(sp)
 762:	e022                	sd	s0,0(sp)
 764:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 766:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	00001797          	auipc	a5,0x1
 76e:	8967b783          	ld	a5,-1898(a5) # 1000 <freep>
 772:	a02d                	j	79c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 774:	4618                	lw	a4,8(a2)
 776:	9f2d                	addw	a4,a4,a1
 778:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	6398                	ld	a4,0(a5)
 77e:	6310                	ld	a2,0(a4)
 780:	a83d                	j	7be <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 782:	ff852703          	lw	a4,-8(a0)
 786:	9f31                	addw	a4,a4,a2
 788:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78a:	ff053683          	ld	a3,-16(a0)
 78e:	a091                	j	7d2 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	6398                	ld	a4,0(a5)
 792:	00e7e463          	bltu	a5,a4,79a <free+0x3c>
 796:	00e6ea63          	bltu	a3,a4,7aa <free+0x4c>
{
 79a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	fed7fae3          	bgeu	a5,a3,790 <free+0x32>
 7a0:	6398                	ld	a4,0(a5)
 7a2:	00e6e463          	bltu	a3,a4,7aa <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	fee7eae3          	bltu	a5,a4,79a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7aa:	ff852583          	lw	a1,-8(a0)
 7ae:	6390                	ld	a2,0(a5)
 7b0:	02059813          	slli	a6,a1,0x20
 7b4:	01c85713          	srli	a4,a6,0x1c
 7b8:	9736                	add	a4,a4,a3
 7ba:	fae60de3          	beq	a2,a4,774 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c2:	4790                	lw	a2,8(a5)
 7c4:	02061593          	slli	a1,a2,0x20
 7c8:	01c5d713          	srli	a4,a1,0x1c
 7cc:	973e                	add	a4,a4,a5
 7ce:	fae68ae3          	beq	a3,a4,782 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82f73623          	sd	a5,-2004(a4) # 1000 <freep>
}
 7dc:	60a2                	ld	ra,8(sp)
 7de:	6402                	ld	s0,0(sp)
 7e0:	0141                	addi	sp,sp,16
 7e2:	8082                	ret

00000000000007e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e4:	7139                	addi	sp,sp,-64
 7e6:	fc06                	sd	ra,56(sp)
 7e8:	f822                	sd	s0,48(sp)
 7ea:	f04a                	sd	s2,32(sp)
 7ec:	ec4e                	sd	s3,24(sp)
 7ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f0:	02051993          	slli	s3,a0,0x20
 7f4:	0209d993          	srli	s3,s3,0x20
 7f8:	09bd                	addi	s3,s3,15
 7fa:	0049d993          	srli	s3,s3,0x4
 7fe:	2985                	addiw	s3,s3,1
 800:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 802:	00000517          	auipc	a0,0x0
 806:	7fe53503          	ld	a0,2046(a0) # 1000 <freep>
 80a:	c905                	beqz	a0,83a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	09377663          	bgeu	a4,s3,89c <malloc+0xb8>
 814:	f426                	sd	s1,40(sp)
 816:	e852                	sd	s4,16(sp)
 818:	e456                	sd	s5,8(sp)
 81a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81c:	8a4e                	mv	s4,s3
 81e:	6705                	lui	a4,0x1
 820:	00e9f363          	bgeu	s3,a4,826 <malloc+0x42>
 824:	6a05                	lui	s4,0x1
 826:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82e:	00000497          	auipc	s1,0x0
 832:	7d248493          	addi	s1,s1,2002 # 1000 <freep>
  if(p == (char*)-1)
 836:	5afd                	li	s5,-1
 838:	a83d                	j	876 <malloc+0x92>
 83a:	f426                	sd	s1,40(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 842:	00000797          	auipc	a5,0x0
 846:	7ce78793          	addi	a5,a5,1998 # 1010 <base>
 84a:	00000717          	auipc	a4,0x0
 84e:	7af73b23          	sd	a5,1974(a4) # 1000 <freep>
 852:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 854:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 858:	b7d1                	j	81c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 85a:	6398                	ld	a4,0(a5)
 85c:	e118                	sd	a4,0(a0)
 85e:	a899                	j	8b4 <malloc+0xd0>
  hp->s.size = nu;
 860:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 864:	0541                	addi	a0,a0,16
 866:	ef9ff0ef          	jal	75e <free>
  return freep;
 86a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 86c:	c125                	beqz	a0,8cc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 870:	4798                	lw	a4,8(a5)
 872:	03277163          	bgeu	a4,s2,894 <malloc+0xb0>
    if(p == freep)
 876:	6098                	ld	a4,0(s1)
 878:	853e                	mv	a0,a5
 87a:	fef71ae3          	bne	a4,a5,86e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 87e:	8552                	mv	a0,s4
 880:	b0bff0ef          	jal	38a <sbrk>
  if(p == (char*)-1)
 884:	fd551ee3          	bne	a0,s5,860 <malloc+0x7c>
        return 0;
 888:	4501                	li	a0,0
 88a:	74a2                	ld	s1,40(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	a03d                	j	8c0 <malloc+0xdc>
 894:	74a2                	ld	s1,40(sp)
 896:	6a42                	ld	s4,16(sp)
 898:	6aa2                	ld	s5,8(sp)
 89a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89c:	fae90fe3          	beq	s2,a4,85a <malloc+0x76>
        p->s.size -= nunits;
 8a0:	4137073b          	subw	a4,a4,s3
 8a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a6:	02071693          	slli	a3,a4,0x20
 8aa:	01c6d713          	srli	a4,a3,0x1c
 8ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74a73623          	sd	a0,1868(a4) # 1000 <freep>
      return (void*)(p + 1);
 8bc:	01078513          	addi	a0,a5,16
  }
}
 8c0:	70e2                	ld	ra,56(sp)
 8c2:	7442                	ld	s0,48(sp)
 8c4:	7902                	ld	s2,32(sp)
 8c6:	69e2                	ld	s3,24(sp)
 8c8:	6121                	addi	sp,sp,64
 8ca:	8082                	ret
 8cc:	74a2                	ld	s1,40(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
 8d4:	b7f5                	j	8c0 <malloc+0xdc>
