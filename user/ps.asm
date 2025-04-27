
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/procinfo.h"

int
main(int argc, char *argv[])
{
   0:	81010113          	addi	sp,sp,-2032
   4:	7e113423          	sd	ra,2024(sp)
   8:	7e813023          	sd	s0,2016(sp)
   c:	7c913c23          	sd	s1,2008(sp)
  10:	7d213823          	sd	s2,2000(sp)
  14:	7d313423          	sd	s3,1992(sp)
  18:	7d413023          	sd	s4,1984(sp)
  1c:	7b513c23          	sd	s5,1976(sp)
  20:	7b613823          	sd	s6,1968(sp)
  24:	7b713423          	sd	s7,1960(sp)
  28:	7b813023          	sd	s8,1952(sp)
  2c:	79913c23          	sd	s9,1944(sp)
  30:	7f010413          	addi	s0,sp,2032
  34:	d9010113          	addi	sp,sp,-624
    struct procinfo procs[64];
    int n = ps(procs, 64);
  38:	04000593          	li	a1,64
  3c:	77fd                	lui	a5,0xfffff
  3e:	5a078793          	addi	a5,a5,1440 # fffffffffffff5a0 <base+0xffffffffffffe590>
  42:	00f40533          	add	a0,s0,a5
  46:	406000ef          	jal	44c <ps>

    if (n < 0) {
  4a:	04054663          	bltz	a0,96 <main+0x96>
  4e:	892a                	mv	s2,a0
        printf("ps syscall failed\n");
        exit(1);
    }

    printf("PID\tSTATE\t\tMEM\tNAME\n");
  50:	00001517          	auipc	a0,0x1
  54:	98050513          	addi	a0,a0,-1664 # 9d0 <malloc+0x14a>
  58:	776000ef          	jal	7ce <printf>
    for (int i = 0; i < n; i++) {
  5c:	0b205263          	blez	s2,100 <main+0x100>
  60:	77fd                	lui	a5,0xfffff
  62:	5b878793          	addi	a5,a5,1464 # fffffffffffff5b8 <base+0xffffffffffffe5a8>
  66:	00f404b3          	add	s1,s0,a5
  6a:	02800793          	li	a5,40
  6e:	02f90933          	mul	s2,s2,a5
  72:	9926                	add	s2,s2,s1
        char *state;
        // Check if state is an integer and map it to a string
        switch (procs[i].state) {
  74:	498d                	li	s3,3
            case 1: state = "SLEEPING"; break;
            case 2: state = "RUNNABLE"; break;
            case 3: state = "RUNNING"; break;
  76:	00001c97          	auipc	s9,0x1
  7a:	92ac8c93          	addi	s9,s9,-1750 # 9a0 <malloc+0x11a>
        switch (procs[i].state) {
  7e:	4c11                	li	s8,4
            case 4: state = "ZOMBIE"; break;
  80:	00001b97          	auipc	s7,0x1
  84:	928b8b93          	addi	s7,s7,-1752 # 9a8 <malloc+0x122>
        switch (procs[i].state) {
  88:	4a85                	li	s5,1
            case 1: state = "SLEEPING"; break;
  8a:	00001a17          	auipc	s4,0x1
  8e:	8f6a0a13          	addi	s4,s4,-1802 # 980 <malloc+0xfa>
        switch (procs[i].state) {
  92:	4b09                	li	s6,2
  94:	a089                	j	d6 <main+0xd6>
        printf("ps syscall failed\n");
  96:	00001517          	auipc	a0,0x1
  9a:	92250513          	addi	a0,a0,-1758 # 9b8 <malloc+0x132>
  9e:	730000ef          	jal	7ce <printf>
        exit(1);
  a2:	4505                	li	a0,1
  a4:	300000ef          	jal	3a4 <exit>
            case 4: state = "ZOMBIE"; break;
  a8:	865e                	mv	a2,s7
        switch (procs[i].state) {
  aa:	01878863          	beq	a5,s8,ba <main+0xba>
            default: state = "UNKNOWN"; break;
  ae:	00001617          	auipc	a2,0x1
  b2:	90260613          	addi	a2,a2,-1790 # 9b0 <malloc+0x12a>
  b6:	a011                	j	ba <main+0xba>
            case 3: state = "RUNNING"; break;
  b8:	8666                	mv	a2,s9
        }

        // Use appropriate format specifiers:
        printf("%d\t%s\t%ld\t%s\n", procs[i].pid, state, procs[i].sz, procs[i].name);
  ba:	ff873683          	ld	a3,-8(a4)
  be:	fe872583          	lw	a1,-24(a4)
  c2:	00001517          	auipc	a0,0x1
  c6:	92650513          	addi	a0,a0,-1754 # 9e8 <malloc+0x162>
  ca:	704000ef          	jal	7ce <printf>
    for (int i = 0; i < n; i++) {
  ce:	02848493          	addi	s1,s1,40
  d2:	03248763          	beq	s1,s2,100 <main+0x100>
        switch (procs[i].state) {
  d6:	8726                	mv	a4,s1
  d8:	ff04a783          	lw	a5,-16(s1)
  dc:	fd378ee3          	beq	a5,s3,b8 <main+0xb8>
  e0:	fcf9c4e3          	blt	s3,a5,a8 <main+0xa8>
            case 1: state = "SLEEPING"; break;
  e4:	8652                	mv	a2,s4
        switch (procs[i].state) {
  e6:	fd578ae3          	beq	a5,s5,ba <main+0xba>
  ea:	00001617          	auipc	a2,0x1
  ee:	8a660613          	addi	a2,a2,-1882 # 990 <malloc+0x10a>
  f2:	fd6784e3          	beq	a5,s6,ba <main+0xba>
            default: state = "UNKNOWN"; break;
  f6:	00001617          	auipc	a2,0x1
  fa:	8ba60613          	addi	a2,a2,-1862 # 9b0 <malloc+0x12a>
  fe:	bf75                	j	ba <main+0xba>
    }

    exit(0);
 100:	4501                	li	a0,0
 102:	2a2000ef          	jal	3a4 <exit>

0000000000000106 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10e:	ef3ff0ef          	jal	0 <main>
  exit(0);
 112:	4501                	li	a0,0
 114:	290000ef          	jal	3a4 <exit>

0000000000000118 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	87aa                	mv	a5,a0
 122:	0585                	addi	a1,a1,1
 124:	0785                	addi	a5,a5,1
 126:	fff5c703          	lbu	a4,-1(a1)
 12a:	fee78fa3          	sb	a4,-1(a5)
 12e:	fb75                	bnez	a4,122 <strcpy+0xa>
    ;
  return os;
}
 130:	60a2                	ld	ra,8(sp)
 132:	6402                	ld	s0,0(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e406                	sd	ra,8(sp)
 13c:	e022                	sd	s0,0(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x20>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x20>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strlen>:

uint
strlen(const char *s)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 170:	00054783          	lbu	a5,0(a0)
 174:	cf99                	beqz	a5,192 <strlen+0x2a>
 176:	0505                	addi	a0,a0,1
 178:	87aa                	mv	a5,a0
 17a:	86be                	mv	a3,a5
 17c:	0785                	addi	a5,a5,1
 17e:	fff7c703          	lbu	a4,-1(a5)
 182:	ff65                	bnez	a4,17a <strlen+0x12>
 184:	40a6853b          	subw	a0,a3,a0
 188:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18a:	60a2                	ld	ra,8(sp)
 18c:	6402                	ld	s0,0(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
  for(n = 0; s[n]; n++)
 192:	4501                	li	a0,0
 194:	bfdd                	j	18a <strlen+0x22>

0000000000000196 <memset>:

void*
memset(void *dst, int c, uint n)
{
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1e>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x14>
  }
  return dst;
}
 1b4:	60a2                	ld	ra,8(sp)
 1b6:	6402                	ld	s0,0(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strchr>:

char*
strchr(const char *s, char c)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cf81                	beqz	a5,1e0 <strchr+0x24>
    if(*s == c)
 1ca:	00f58763          	beq	a1,a5,1d8 <strchr+0x1c>
  for(; *s; s++)
 1ce:	0505                	addi	a0,a0,1
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	fbfd                	bnez	a5,1ca <strchr+0xe>
      return (char*)s;
  return 0;
 1d6:	4501                	li	a0,0
}
 1d8:	60a2                	ld	ra,8(sp)
 1da:	6402                	ld	s0,0(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  return 0;
 1e0:	4501                	li	a0,0
 1e2:	bfdd                	j	1d8 <strchr+0x1c>

00000000000001e4 <gets>:

char*
gets(char *buf, int max)
{
 1e4:	7159                	addi	sp,sp,-112
 1e6:	f486                	sd	ra,104(sp)
 1e8:	f0a2                	sd	s0,96(sp)
 1ea:	eca6                	sd	s1,88(sp)
 1ec:	e8ca                	sd	s2,80(sp)
 1ee:	e4ce                	sd	s3,72(sp)
 1f0:	e0d2                	sd	s4,64(sp)
 1f2:	fc56                	sd	s5,56(sp)
 1f4:	f85a                	sd	s6,48(sp)
 1f6:	f45e                	sd	s7,40(sp)
 1f8:	f062                	sd	s8,32(sp)
 1fa:	ec66                	sd	s9,24(sp)
 1fc:	e86a                	sd	s10,16(sp)
 1fe:	1880                	addi	s0,sp,112
 200:	8caa                	mv	s9,a0
 202:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 204:	892a                	mv	s2,a0
 206:	4481                	li	s1,0
    cc = read(0, &c, 1);
 208:	f9f40b13          	addi	s6,s0,-97
 20c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20e:	4ba9                	li	s7,10
 210:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 212:	8d26                	mv	s10,s1
 214:	0014899b          	addiw	s3,s1,1
 218:	84ce                	mv	s1,s3
 21a:	0349d563          	bge	s3,s4,244 <gets+0x60>
    cc = read(0, &c, 1);
 21e:	8656                	mv	a2,s5
 220:	85da                	mv	a1,s6
 222:	4501                	li	a0,0
 224:	198000ef          	jal	3bc <read>
    if(cc < 1)
 228:	00a05e63          	blez	a0,244 <gets+0x60>
    buf[i++] = c;
 22c:	f9f44783          	lbu	a5,-97(s0)
 230:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 234:	01778763          	beq	a5,s7,242 <gets+0x5e>
 238:	0905                	addi	s2,s2,1
 23a:	fd879ce3          	bne	a5,s8,212 <gets+0x2e>
    buf[i++] = c;
 23e:	8d4e                	mv	s10,s3
 240:	a011                	j	244 <gets+0x60>
 242:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 244:	9d66                	add	s10,s10,s9
 246:	000d0023          	sb	zero,0(s10)
  return buf;
}
 24a:	8566                	mv	a0,s9
 24c:	70a6                	ld	ra,104(sp)
 24e:	7406                	ld	s0,96(sp)
 250:	64e6                	ld	s1,88(sp)
 252:	6946                	ld	s2,80(sp)
 254:	69a6                	ld	s3,72(sp)
 256:	6a06                	ld	s4,64(sp)
 258:	7ae2                	ld	s5,56(sp)
 25a:	7b42                	ld	s6,48(sp)
 25c:	7ba2                	ld	s7,40(sp)
 25e:	7c02                	ld	s8,32(sp)
 260:	6ce2                	ld	s9,24(sp)
 262:	6d42                	ld	s10,16(sp)
 264:	6165                	addi	sp,sp,112
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e04a                	sd	s2,0(sp)
 270:	1000                	addi	s0,sp,32
 272:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	4581                	li	a1,0
 276:	16e000ef          	jal	3e4 <open>
  if(fd < 0)
 27a:	02054263          	bltz	a0,29e <stat+0x36>
 27e:	e426                	sd	s1,8(sp)
 280:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 282:	85ca                	mv	a1,s2
 284:	178000ef          	jal	3fc <fstat>
 288:	892a                	mv	s2,a0
  close(fd);
 28a:	8526                	mv	a0,s1
 28c:	140000ef          	jal	3cc <close>
  return r;
 290:	64a2                	ld	s1,8(sp)
}
 292:	854a                	mv	a0,s2
 294:	60e2                	ld	ra,24(sp)
 296:	6442                	ld	s0,16(sp)
 298:	6902                	ld	s2,0(sp)
 29a:	6105                	addi	sp,sp,32
 29c:	8082                	ret
    return -1;
 29e:	597d                	li	s2,-1
 2a0:	bfcd                	j	292 <stat+0x2a>

00000000000002a2 <atoi>:

int
atoi(const char *s)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2aa:	00054683          	lbu	a3,0(a0)
 2ae:	fd06879b          	addiw	a5,a3,-48
 2b2:	0ff7f793          	zext.b	a5,a5
 2b6:	4625                	li	a2,9
 2b8:	02f66963          	bltu	a2,a5,2ea <atoi+0x48>
 2bc:	872a                	mv	a4,a0
  n = 0;
 2be:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c0:	0705                	addi	a4,a4,1
 2c2:	0025179b          	slliw	a5,a0,0x2
 2c6:	9fa9                	addw	a5,a5,a0
 2c8:	0017979b          	slliw	a5,a5,0x1
 2cc:	9fb5                	addw	a5,a5,a3
 2ce:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d2:	00074683          	lbu	a3,0(a4)
 2d6:	fd06879b          	addiw	a5,a3,-48
 2da:	0ff7f793          	zext.b	a5,a5
 2de:	fef671e3          	bgeu	a2,a5,2c0 <atoi+0x1e>
  return n;
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  n = 0;
 2ea:	4501                	li	a0,0
 2ec:	bfdd                	j	2e2 <atoi+0x40>

00000000000002ee <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e406                	sd	ra,8(sp)
 2f2:	e022                	sd	s0,0(sp)
 2f4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f6:	02b57563          	bgeu	a0,a1,320 <memmove+0x32>
    while(n-- > 0)
 2fa:	00c05f63          	blez	a2,318 <memmove+0x2a>
 2fe:	1602                	slli	a2,a2,0x20
 300:	9201                	srli	a2,a2,0x20
 302:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 306:	872a                	mv	a4,a0
      *dst++ = *src++;
 308:	0585                	addi	a1,a1,1
 30a:	0705                	addi	a4,a4,1
 30c:	fff5c683          	lbu	a3,-1(a1)
 310:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 314:	fee79ae3          	bne	a5,a4,308 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
    dst += n;
 320:	00c50733          	add	a4,a0,a2
    src += n;
 324:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 326:	fec059e3          	blez	a2,318 <memmove+0x2a>
 32a:	fff6079b          	addiw	a5,a2,-1
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	fff7c793          	not	a5,a5
 336:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 338:	15fd                	addi	a1,a1,-1
 33a:	177d                	addi	a4,a4,-1
 33c:	0005c683          	lbu	a3,0(a1)
 340:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 344:	fef71ae3          	bne	a4,a5,338 <memmove+0x4a>
 348:	bfc1                	j	318 <memmove+0x2a>

000000000000034a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 352:	ca0d                	beqz	a2,384 <memcmp+0x3a>
 354:	fff6069b          	addiw	a3,a2,-1
 358:	1682                	slli	a3,a3,0x20
 35a:	9281                	srli	a3,a3,0x20
 35c:	0685                	addi	a3,a3,1
 35e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 360:	00054783          	lbu	a5,0(a0)
 364:	0005c703          	lbu	a4,0(a1)
 368:	00e79863          	bne	a5,a4,378 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 36c:	0505                	addi	a0,a0,1
    p2++;
 36e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 370:	fed518e3          	bne	a0,a3,360 <memcmp+0x16>
  }
  return 0;
 374:	4501                	li	a0,0
 376:	a019                	j	37c <memcmp+0x32>
      return *p1 - *p2;
 378:	40e7853b          	subw	a0,a5,a4
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfdd                	j	37c <memcmp+0x32>

0000000000000388 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 390:	f5fff0ef          	jal	2ee <memmove>
}
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret

000000000000039c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39c:	4885                	li	a7,1
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a4:	4889                	li	a7,2
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ac:	488d                	li	a7,3
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b4:	4891                	li	a7,4
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <read>:
.global read
read:
 li a7, SYS_read
 3bc:	4895                	li	a7,5
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <write>:
.global write
write:
 li a7, SYS_write
 3c4:	48c1                	li	a7,16
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <close>:
.global close
close:
 li a7, SYS_close
 3cc:	48d5                	li	a7,21
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d4:	4899                	li	a7,6
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3dc:	489d                	li	a7,7
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <open>:
.global open
open:
 li a7, SYS_open
 3e4:	48bd                	li	a7,15
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ec:	48c5                	li	a7,17
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f4:	48c9                	li	a7,18
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fc:	48a1                	li	a7,8
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <link>:
.global link
link:
 li a7, SYS_link
 404:	48cd                	li	a7,19
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40c:	48d1                	li	a7,20
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 414:	48a5                	li	a7,9
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <dup>:
.global dup
dup:
 li a7, SYS_dup
 41c:	48a9                	li	a7,10
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 424:	48ad                	li	a7,11
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 42c:	48b1                	li	a7,12
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 434:	48b5                	li	a7,13
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43c:	48b9                	li	a7,14
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 444:	48d9                	li	a7,22
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <ps>:
.global ps
ps:
 li a7, SYS_ps
 44c:	48dd                	li	a7,23
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 454:	48e1                	li	a7,24
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 45c:	48e5                	li	a7,25
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 464:	48e9                	li	a7,26
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	1000                	addi	s0,sp,32
 474:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 478:	4605                	li	a2,1
 47a:	fef40593          	addi	a1,s0,-17
 47e:	f47ff0ef          	jal	3c4 <write>
}
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret

000000000000048a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48a:	7139                	addi	sp,sp,-64
 48c:	fc06                	sd	ra,56(sp)
 48e:	f822                	sd	s0,48(sp)
 490:	f426                	sd	s1,40(sp)
 492:	f04a                	sd	s2,32(sp)
 494:	ec4e                	sd	s3,24(sp)
 496:	0080                	addi	s0,sp,64
 498:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49a:	c299                	beqz	a3,4a0 <printint+0x16>
 49c:	0605ce63          	bltz	a1,518 <printint+0x8e>
  neg = 0;
 4a0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4a2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4a6:	869a                	mv	a3,t1
  i = 0;
 4a8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4aa:	00000817          	auipc	a6,0x0
 4ae:	55680813          	addi	a6,a6,1366 # a00 <digits>
 4b2:	88be                	mv	a7,a5
 4b4:	0017851b          	addiw	a0,a5,1
 4b8:	87aa                	mv	a5,a0
 4ba:	02c5f73b          	remuw	a4,a1,a2
 4be:	1702                	slli	a4,a4,0x20
 4c0:	9301                	srli	a4,a4,0x20
 4c2:	9742                	add	a4,a4,a6
 4c4:	00074703          	lbu	a4,0(a4)
 4c8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4cc:	872e                	mv	a4,a1
 4ce:	02c5d5bb          	divuw	a1,a1,a2
 4d2:	0685                	addi	a3,a3,1
 4d4:	fcc77fe3          	bgeu	a4,a2,4b2 <printint+0x28>
  if(neg)
 4d8:	000e0c63          	beqz	t3,4f0 <printint+0x66>
    buf[i++] = '-';
 4dc:	fd050793          	addi	a5,a0,-48
 4e0:	00878533          	add	a0,a5,s0
 4e4:	02d00793          	li	a5,45
 4e8:	fef50823          	sb	a5,-16(a0)
 4ec:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4f0:	fff7899b          	addiw	s3,a5,-1
 4f4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4f8:	fff4c583          	lbu	a1,-1(s1)
 4fc:	854a                	mv	a0,s2
 4fe:	f6fff0ef          	jal	46c <putc>
  while(--i >= 0)
 502:	39fd                	addiw	s3,s3,-1
 504:	14fd                	addi	s1,s1,-1
 506:	fe09d9e3          	bgez	s3,4f8 <printint+0x6e>
}
 50a:	70e2                	ld	ra,56(sp)
 50c:	7442                	ld	s0,48(sp)
 50e:	74a2                	ld	s1,40(sp)
 510:	7902                	ld	s2,32(sp)
 512:	69e2                	ld	s3,24(sp)
 514:	6121                	addi	sp,sp,64
 516:	8082                	ret
    x = -xx;
 518:	40b005bb          	negw	a1,a1
    neg = 1;
 51c:	4e05                	li	t3,1
    x = -xx;
 51e:	b751                	j	4a2 <printint+0x18>

0000000000000520 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 520:	711d                	addi	sp,sp,-96
 522:	ec86                	sd	ra,88(sp)
 524:	e8a2                	sd	s0,80(sp)
 526:	e4a6                	sd	s1,72(sp)
 528:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c483          	lbu	s1,0(a1)
 52e:	26048663          	beqz	s1,79a <vprintf+0x27a>
 532:	e0ca                	sd	s2,64(sp)
 534:	fc4e                	sd	s3,56(sp)
 536:	f852                	sd	s4,48(sp)
 538:	f456                	sd	s5,40(sp)
 53a:	f05a                	sd	s6,32(sp)
 53c:	ec5e                	sd	s7,24(sp)
 53e:	e862                	sd	s8,16(sp)
 540:	e466                	sd	s9,8(sp)
 542:	8b2a                	mv	s6,a0
 544:	8a2e                	mv	s4,a1
 546:	8bb2                	mv	s7,a2
  state = 0;
 548:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 54a:	4901                	li	s2,0
 54c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 54e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 552:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 556:	06c00c93          	li	s9,108
 55a:	a00d                	j	57c <vprintf+0x5c>
        putc(fd, c0);
 55c:	85a6                	mv	a1,s1
 55e:	855a                	mv	a0,s6
 560:	f0dff0ef          	jal	46c <putc>
 564:	a019                	j	56a <vprintf+0x4a>
    } else if(state == '%'){
 566:	03598363          	beq	s3,s5,58c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 56a:	0019079b          	addiw	a5,s2,1
 56e:	893e                	mv	s2,a5
 570:	873e                	mv	a4,a5
 572:	97d2                	add	a5,a5,s4
 574:	0007c483          	lbu	s1,0(a5)
 578:	20048963          	beqz	s1,78a <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 57c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 580:	fe0993e3          	bnez	s3,566 <vprintf+0x46>
      if(c0 == '%'){
 584:	fd579ce3          	bne	a5,s5,55c <vprintf+0x3c>
        state = '%';
 588:	89be                	mv	s3,a5
 58a:	b7c5                	j	56a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 58c:	00ea06b3          	add	a3,s4,a4
 590:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 594:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 596:	c681                	beqz	a3,59e <vprintf+0x7e>
 598:	9752                	add	a4,a4,s4
 59a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 59e:	03878e63          	beq	a5,s8,5da <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5a2:	05978863          	beq	a5,s9,5f2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a6:	07500713          	li	a4,117
 5aa:	0ee78263          	beq	a5,a4,68e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ae:	07800713          	li	a4,120
 5b2:	12e78463          	beq	a5,a4,6da <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5b6:	07000713          	li	a4,112
 5ba:	14e78963          	beq	a5,a4,70c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5be:	07300713          	li	a4,115
 5c2:	18e78863          	beq	a5,a4,752 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c6:	02500713          	li	a4,37
 5ca:	04e79463          	bne	a5,a4,612 <vprintf+0xf2>
        putc(fd, '%');
 5ce:	85ba                	mv	a1,a4
 5d0:	855a                	mv	a0,s6
 5d2:	e9bff0ef          	jal	46c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bf49                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	ea3ff0ef          	jal	48a <printint>
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bfad                	j	56a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5f2:	06400793          	li	a5,100
 5f6:	02f68963          	beq	a3,a5,628 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fa:	06c00793          	li	a5,108
 5fe:	04f68263          	beq	a3,a5,642 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 602:	07500793          	li	a5,117
 606:	0af68063          	beq	a3,a5,6a6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 60a:	07800793          	li	a5,120
 60e:	0ef68263          	beq	a3,a5,6f2 <vprintf+0x1d2>
        putc(fd, '%');
 612:	02500593          	li	a1,37
 616:	855a                	mv	a0,s6
 618:	e55ff0ef          	jal	46c <putc>
        putc(fd, c0);
 61c:	85a6                	mv	a1,s1
 61e:	855a                	mv	a0,s6
 620:	e4dff0ef          	jal	46c <putc>
      state = 0;
 624:	4981                	li	s3,0
 626:	b791                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	008b8493          	addi	s1,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e55ff0ef          	jal	48a <printint>
        i += 1;
 63a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	b72d                	j	56a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 642:	06400793          	li	a5,100
 646:	02f60763          	beq	a2,a5,674 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 64a:	07500793          	li	a5,117
 64e:	06f60963          	beq	a2,a5,6c0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 652:	07800793          	li	a5,120
 656:	faf61ee3          	bne	a2,a5,612 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000ba583          	lw	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e23ff0ef          	jal	48a <printint>
        i += 2;
 66c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bde5                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8493          	addi	s1,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	e09ff0ef          	jal	48a <printint>
        i += 2;
 686:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	bdf9                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 68e:	008b8493          	addi	s1,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	defff0ef          	jal	48a <printint>
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b5d9                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dd7ff0ef          	jal	48a <printint>
        i += 1;
 6b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
        i += 1;
 6be:	b575                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c0:	008b8493          	addi	s1,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4629                	li	a2,10
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	dbdff0ef          	jal	48a <printint>
        i += 2;
 6d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d4:	8ba6                	mv	s7,s1
      state = 0;
 6d6:	4981                	li	s3,0
        i += 2;
 6d8:	bd49                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6da:	008b8493          	addi	s1,s7,8
 6de:	4681                	li	a3,0
 6e0:	4641                	li	a2,16
 6e2:	000ba583          	lw	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	da3ff0ef          	jal	48a <printint>
 6ec:	8ba6                	mv	s7,s1
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bdad                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8493          	addi	s1,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	d8bff0ef          	jal	48a <printint>
        i += 1;
 704:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	8ba6                	mv	s7,s1
      state = 0;
 708:	4981                	li	s3,0
        i += 1;
 70a:	b585                	j	56a <vprintf+0x4a>
 70c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 70e:	008b8d13          	addi	s10,s7,8
 712:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 716:	03000593          	li	a1,48
 71a:	855a                	mv	a0,s6
 71c:	d51ff0ef          	jal	46c <putc>
  putc(fd, 'x');
 720:	07800593          	li	a1,120
 724:	855a                	mv	a0,s6
 726:	d47ff0ef          	jal	46c <putc>
 72a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72c:	00000b97          	auipc	s7,0x0
 730:	2d4b8b93          	addi	s7,s7,724 # a00 <digits>
 734:	03c9d793          	srli	a5,s3,0x3c
 738:	97de                	add	a5,a5,s7
 73a:	0007c583          	lbu	a1,0(a5)
 73e:	855a                	mv	a0,s6
 740:	d2dff0ef          	jal	46c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 744:	0992                	slli	s3,s3,0x4
 746:	34fd                	addiw	s1,s1,-1
 748:	f4f5                	bnez	s1,734 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 74a:	8bea                	mv	s7,s10
      state = 0;
 74c:	4981                	li	s3,0
 74e:	6d02                	ld	s10,0(sp)
 750:	bd29                	j	56a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 752:	008b8993          	addi	s3,s7,8
 756:	000bb483          	ld	s1,0(s7)
 75a:	cc91                	beqz	s1,776 <vprintf+0x256>
        for(; *s; s++)
 75c:	0004c583          	lbu	a1,0(s1)
 760:	c195                	beqz	a1,784 <vprintf+0x264>
          putc(fd, *s);
 762:	855a                	mv	a0,s6
 764:	d09ff0ef          	jal	46c <putc>
        for(; *s; s++)
 768:	0485                	addi	s1,s1,1
 76a:	0004c583          	lbu	a1,0(s1)
 76e:	f9f5                	bnez	a1,762 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 770:	8bce                	mv	s7,s3
      state = 0;
 772:	4981                	li	s3,0
 774:	bbdd                	j	56a <vprintf+0x4a>
          s = "(null)";
 776:	00000497          	auipc	s1,0x0
 77a:	28248493          	addi	s1,s1,642 # 9f8 <malloc+0x172>
        for(; *s; s++)
 77e:	02800593          	li	a1,40
 782:	b7c5                	j	762 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 784:	8bce                	mv	s7,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	b3cd                	j	56a <vprintf+0x4a>
 78a:	6906                	ld	s2,64(sp)
 78c:	79e2                	ld	s3,56(sp)
 78e:	7a42                	ld	s4,48(sp)
 790:	7aa2                	ld	s5,40(sp)
 792:	7b02                	ld	s6,32(sp)
 794:	6be2                	ld	s7,24(sp)
 796:	6c42                	ld	s8,16(sp)
 798:	6ca2                	ld	s9,8(sp)
    }
  }
}
 79a:	60e6                	ld	ra,88(sp)
 79c:	6446                	ld	s0,80(sp)
 79e:	64a6                	ld	s1,72(sp)
 7a0:	6125                	addi	sp,sp,96
 7a2:	8082                	ret

00000000000007a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a4:	715d                	addi	sp,sp,-80
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	e010                	sd	a2,0(s0)
 7ae:	e414                	sd	a3,8(s0)
 7b0:	e818                	sd	a4,16(s0)
 7b2:	ec1c                	sd	a5,24(s0)
 7b4:	03043023          	sd	a6,32(s0)
 7b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7bc:	8622                	mv	a2,s0
 7be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c2:	d5fff0ef          	jal	520 <vprintf>
}
 7c6:	60e2                	ld	ra,24(sp)
 7c8:	6442                	ld	s0,16(sp)
 7ca:	6161                	addi	sp,sp,80
 7cc:	8082                	ret

00000000000007ce <printf>:

void
printf(const char *fmt, ...)
{
 7ce:	711d                	addi	sp,sp,-96
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	addi	s0,sp,32
 7d6:	e40c                	sd	a1,8(s0)
 7d8:	e810                	sd	a2,16(s0)
 7da:	ec14                	sd	a3,24(s0)
 7dc:	f018                	sd	a4,32(s0)
 7de:	f41c                	sd	a5,40(s0)
 7e0:	03043823          	sd	a6,48(s0)
 7e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	00840613          	addi	a2,s0,8
 7ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f0:	85aa                	mv	a1,a0
 7f2:	4505                	li	a0,1
 7f4:	d2dff0ef          	jal	520 <vprintf>
}
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	6125                	addi	sp,sp,96
 7fe:	8082                	ret

0000000000000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	1141                	addi	sp,sp,-16
 802:	e406                	sd	ra,8(sp)
 804:	e022                	sd	s0,0(sp)
 806:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 808:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80c:	00000797          	auipc	a5,0x0
 810:	7f47b783          	ld	a5,2036(a5) # 1000 <freep>
 814:	a02d                	j	83e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 816:	4618                	lw	a4,8(a2)
 818:	9f2d                	addw	a4,a4,a1
 81a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81e:	6398                	ld	a4,0(a5)
 820:	6310                	ld	a2,0(a4)
 822:	a83d                	j	860 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 824:	ff852703          	lw	a4,-8(a0)
 828:	9f31                	addw	a4,a4,a2
 82a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82c:	ff053683          	ld	a3,-16(a0)
 830:	a091                	j	874 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	6398                	ld	a4,0(a5)
 834:	00e7e463          	bltu	a5,a4,83c <free+0x3c>
 838:	00e6ea63          	bltu	a3,a4,84c <free+0x4c>
{
 83c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83e:	fed7fae3          	bgeu	a5,a3,832 <free+0x32>
 842:	6398                	ld	a4,0(a5)
 844:	00e6e463          	bltu	a3,a4,84c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 848:	fee7eae3          	bltu	a5,a4,83c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 84c:	ff852583          	lw	a1,-8(a0)
 850:	6390                	ld	a2,0(a5)
 852:	02059813          	slli	a6,a1,0x20
 856:	01c85713          	srli	a4,a6,0x1c
 85a:	9736                	add	a4,a4,a3
 85c:	fae60de3          	beq	a2,a4,816 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 860:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 864:	4790                	lw	a2,8(a5)
 866:	02061593          	slli	a1,a2,0x20
 86a:	01c5d713          	srli	a4,a1,0x1c
 86e:	973e                	add	a4,a4,a5
 870:	fae68ae3          	beq	a3,a4,824 <free+0x24>
    p->s.ptr = bp->s.ptr;
 874:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 876:	00000717          	auipc	a4,0x0
 87a:	78f73523          	sd	a5,1930(a4) # 1000 <freep>
}
 87e:	60a2                	ld	ra,8(sp)
 880:	6402                	ld	s0,0(sp)
 882:	0141                	addi	sp,sp,16
 884:	8082                	ret

0000000000000886 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 886:	7139                	addi	sp,sp,-64
 888:	fc06                	sd	ra,56(sp)
 88a:	f822                	sd	s0,48(sp)
 88c:	f04a                	sd	s2,32(sp)
 88e:	ec4e                	sd	s3,24(sp)
 890:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 892:	02051993          	slli	s3,a0,0x20
 896:	0209d993          	srli	s3,s3,0x20
 89a:	09bd                	addi	s3,s3,15
 89c:	0049d993          	srli	s3,s3,0x4
 8a0:	2985                	addiw	s3,s3,1
 8a2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8a4:	00000517          	auipc	a0,0x0
 8a8:	75c53503          	ld	a0,1884(a0) # 1000 <freep>
 8ac:	c905                	beqz	a0,8dc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b0:	4798                	lw	a4,8(a5)
 8b2:	09377663          	bgeu	a4,s3,93e <malloc+0xb8>
 8b6:	f426                	sd	s1,40(sp)
 8b8:	e852                	sd	s4,16(sp)
 8ba:	e456                	sd	s5,8(sp)
 8bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8be:	8a4e                	mv	s4,s3
 8c0:	6705                	lui	a4,0x1
 8c2:	00e9f363          	bgeu	s3,a4,8c8 <malloc+0x42>
 8c6:	6a05                	lui	s4,0x1
 8c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d0:	00000497          	auipc	s1,0x0
 8d4:	73048493          	addi	s1,s1,1840 # 1000 <freep>
  if(p == (char*)-1)
 8d8:	5afd                	li	s5,-1
 8da:	a83d                	j	918 <malloc+0x92>
 8dc:	f426                	sd	s1,40(sp)
 8de:	e852                	sd	s4,16(sp)
 8e0:	e456                	sd	s5,8(sp)
 8e2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e4:	00000797          	auipc	a5,0x0
 8e8:	72c78793          	addi	a5,a5,1836 # 1010 <base>
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70f73a23          	sd	a5,1812(a4) # 1000 <freep>
 8f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fa:	b7d1                	j	8be <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8fc:	6398                	ld	a4,0(a5)
 8fe:	e118                	sd	a4,0(a0)
 900:	a899                	j	956 <malloc+0xd0>
  hp->s.size = nu;
 902:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 906:	0541                	addi	a0,a0,16
 908:	ef9ff0ef          	jal	800 <free>
  return freep;
 90c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 90e:	c125                	beqz	a0,96e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 910:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 912:	4798                	lw	a4,8(a5)
 914:	03277163          	bgeu	a4,s2,936 <malloc+0xb0>
    if(p == freep)
 918:	6098                	ld	a4,0(s1)
 91a:	853e                	mv	a0,a5
 91c:	fef71ae3          	bne	a4,a5,910 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 920:	8552                	mv	a0,s4
 922:	b0bff0ef          	jal	42c <sbrk>
  if(p == (char*)-1)
 926:	fd551ee3          	bne	a0,s5,902 <malloc+0x7c>
        return 0;
 92a:	4501                	li	a0,0
 92c:	74a2                	ld	s1,40(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
 934:	a03d                	j	962 <malloc+0xdc>
 936:	74a2                	ld	s1,40(sp)
 938:	6a42                	ld	s4,16(sp)
 93a:	6aa2                	ld	s5,8(sp)
 93c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 93e:	fae90fe3          	beq	s2,a4,8fc <malloc+0x76>
        p->s.size -= nunits;
 942:	4137073b          	subw	a4,a4,s3
 946:	c798                	sw	a4,8(a5)
        p += p->s.size;
 948:	02071693          	slli	a3,a4,0x20
 94c:	01c6d713          	srli	a4,a3,0x1c
 950:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 952:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 956:	00000717          	auipc	a4,0x0
 95a:	6aa73523          	sd	a0,1706(a4) # 1000 <freep>
      return (void*)(p + 1);
 95e:	01078513          	addi	a0,a5,16
  }
}
 962:	70e2                	ld	ra,56(sp)
 964:	7442                	ld	s0,48(sp)
 966:	7902                	ld	s2,32(sp)
 968:	69e2                	ld	s3,24(sp)
 96a:	6121                	addi	sp,sp,64
 96c:	8082                	ret
 96e:	74a2                	ld	s1,40(sp)
 970:	6a42                	ld	s4,16(sp)
 972:	6aa2                	ld	s5,8(sp)
 974:	6b02                	ld	s6,0(sp)
 976:	b7f5                	j	962 <malloc+0xdc>
