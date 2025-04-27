
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	92250513          	addi	a0,a0,-1758 # 930 <malloc+0xf4>
  16:	384000ef          	jal	39a <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3b2000ef          	jal	3d2 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3ac000ef          	jal	3d2 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	90e90913          	addi	s2,s2,-1778 # 938 <malloc+0xfc>
  32:	854a                	mv	a0,s2
  34:	750000ef          	jal	784 <printf>
    pid = fork();
  38:	31a000ef          	jal	352 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	31c000ef          	jal	362 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	93650513          	addi	a0,a0,-1738 # 988 <malloc+0x14c>
  5a:	72a000ef          	jal	784 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2fa000ef          	jal	35a <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	8c850513          	addi	a0,a0,-1848 # 930 <malloc+0xf4>
  70:	332000ef          	jal	3a2 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8ba50513          	addi	a0,a0,-1862 # 930 <malloc+0xf4>
  7e:	31c000ef          	jal	39a <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	8cc50513          	addi	a0,a0,-1844 # 950 <malloc+0x114>
  8c:	6f8000ef          	jal	784 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2c8000ef          	jal	35a <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	8ca50513          	addi	a0,a0,-1846 # 968 <malloc+0x12c>
  a6:	2ec000ef          	jal	392 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8c650513          	addi	a0,a0,-1850 # 970 <malloc+0x134>
  b2:	6d2000ef          	jal	784 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2a2000ef          	jal	35a <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	290000ef          	jal	35a <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e406                	sd	ra,8(sp)
  d2:	e022                	sd	s0,0(sp)
  d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d6:	87aa                	mv	a5,a0
  d8:	0585                	addi	a1,a1,1
  da:	0785                	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fb75                	bnez	a4,d8 <strcpy+0xa>
    ;
  return os;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x20>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x20>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf99                	beqz	a5,148 <strlen+0x2a>
 12c:	0505                	addi	a0,a0,1
 12e:	87aa                	mv	a5,a0
 130:	86be                	mv	a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	ff65                	bnez	a4,130 <strlen+0x12>
 13a:	40a6853b          	subw	a0,a3,a0
 13e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  for(n = 0; s[n]; n++)
 148:	4501                	li	a0,0
 14a:	bfdd                	j	140 <strlen+0x22>

000000000000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e406                	sd	ra,8(sp)
 150:	e022                	sd	s0,0(sp)
 152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 154:	ca19                	beqz	a2,16a <memset+0x1e>
 156:	87aa                	mv	a5,a0
 158:	1602                	slli	a2,a2,0x20
 15a:	9201                	srli	a2,a2,0x20
 15c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 164:	0785                	addi	a5,a5,1
 166:	fee79de3          	bne	a5,a4,160 <memset+0x14>
  }
  return dst;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strchr>:

char*
strchr(const char *s, char c)
{
 172:	1141                	addi	sp,sp,-16
 174:	e406                	sd	ra,8(sp)
 176:	e022                	sd	s0,0(sp)
 178:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	cf81                	beqz	a5,196 <strchr+0x24>
    if(*s == c)
 180:	00f58763          	beq	a1,a5,18e <strchr+0x1c>
  for(; *s; s++)
 184:	0505                	addi	a0,a0,1
 186:	00054783          	lbu	a5,0(a0)
 18a:	fbfd                	bnez	a5,180 <strchr+0xe>
      return (char*)s;
  return 0;
 18c:	4501                	li	a0,0
}
 18e:	60a2                	ld	ra,8(sp)
 190:	6402                	ld	s0,0(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret
  return 0;
 196:	4501                	li	a0,0
 198:	bfdd                	j	18e <strchr+0x1c>

000000000000019a <gets>:

char*
gets(char *buf, int max)
{
 19a:	7159                	addi	sp,sp,-112
 19c:	f486                	sd	ra,104(sp)
 19e:	f0a2                	sd	s0,96(sp)
 1a0:	eca6                	sd	s1,88(sp)
 1a2:	e8ca                	sd	s2,80(sp)
 1a4:	e4ce                	sd	s3,72(sp)
 1a6:	e0d2                	sd	s4,64(sp)
 1a8:	fc56                	sd	s5,56(sp)
 1aa:	f85a                	sd	s6,48(sp)
 1ac:	f45e                	sd	s7,40(sp)
 1ae:	f062                	sd	s8,32(sp)
 1b0:	ec66                	sd	s9,24(sp)
 1b2:	e86a                	sd	s10,16(sp)
 1b4:	1880                	addi	s0,sp,112
 1b6:	8caa                	mv	s9,a0
 1b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ba:	892a                	mv	s2,a0
 1bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1be:	f9f40b13          	addi	s6,s0,-97
 1c2:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c4:	4ba9                	li	s7,10
 1c6:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1c8:	8d26                	mv	s10,s1
 1ca:	0014899b          	addiw	s3,s1,1
 1ce:	84ce                	mv	s1,s3
 1d0:	0349d563          	bge	s3,s4,1fa <gets+0x60>
    cc = read(0, &c, 1);
 1d4:	8656                	mv	a2,s5
 1d6:	85da                	mv	a1,s6
 1d8:	4501                	li	a0,0
 1da:	198000ef          	jal	372 <read>
    if(cc < 1)
 1de:	00a05e63          	blez	a0,1fa <gets+0x60>
    buf[i++] = c;
 1e2:	f9f44783          	lbu	a5,-97(s0)
 1e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ea:	01778763          	beq	a5,s7,1f8 <gets+0x5e>
 1ee:	0905                	addi	s2,s2,1
 1f0:	fd879ce3          	bne	a5,s8,1c8 <gets+0x2e>
    buf[i++] = c;
 1f4:	8d4e                	mv	s10,s3
 1f6:	a011                	j	1fa <gets+0x60>
 1f8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1fa:	9d66                	add	s10,s10,s9
 1fc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 200:	8566                	mv	a0,s9
 202:	70a6                	ld	ra,104(sp)
 204:	7406                	ld	s0,96(sp)
 206:	64e6                	ld	s1,88(sp)
 208:	6946                	ld	s2,80(sp)
 20a:	69a6                	ld	s3,72(sp)
 20c:	6a06                	ld	s4,64(sp)
 20e:	7ae2                	ld	s5,56(sp)
 210:	7b42                	ld	s6,48(sp)
 212:	7ba2                	ld	s7,40(sp)
 214:	7c02                	ld	s8,32(sp)
 216:	6ce2                	ld	s9,24(sp)
 218:	6d42                	ld	s10,16(sp)
 21a:	6165                	addi	sp,sp,112
 21c:	8082                	ret

000000000000021e <stat>:

int
stat(const char *n, struct stat *st)
{
 21e:	1101                	addi	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e04a                	sd	s2,0(sp)
 226:	1000                	addi	s0,sp,32
 228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22a:	4581                	li	a1,0
 22c:	16e000ef          	jal	39a <open>
  if(fd < 0)
 230:	02054263          	bltz	a0,254 <stat+0x36>
 234:	e426                	sd	s1,8(sp)
 236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 238:	85ca                	mv	a1,s2
 23a:	178000ef          	jal	3b2 <fstat>
 23e:	892a                	mv	s2,a0
  close(fd);
 240:	8526                	mv	a0,s1
 242:	140000ef          	jal	382 <close>
  return r;
 246:	64a2                	ld	s1,8(sp)
}
 248:	854a                	mv	a0,s2
 24a:	60e2                	ld	ra,24(sp)
 24c:	6442                	ld	s0,16(sp)
 24e:	6902                	ld	s2,0(sp)
 250:	6105                	addi	sp,sp,32
 252:	8082                	ret
    return -1;
 254:	597d                	li	s2,-1
 256:	bfcd                	j	248 <stat+0x2a>

0000000000000258 <atoi>:

int
atoi(const char *s)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 260:	00054683          	lbu	a3,0(a0)
 264:	fd06879b          	addiw	a5,a3,-48
 268:	0ff7f793          	zext.b	a5,a5
 26c:	4625                	li	a2,9
 26e:	02f66963          	bltu	a2,a5,2a0 <atoi+0x48>
 272:	872a                	mv	a4,a0
  n = 0;
 274:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 276:	0705                	addi	a4,a4,1
 278:	0025179b          	slliw	a5,a0,0x2
 27c:	9fa9                	addw	a5,a5,a0
 27e:	0017979b          	slliw	a5,a5,0x1
 282:	9fb5                	addw	a5,a5,a3
 284:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 288:	00074683          	lbu	a3,0(a4)
 28c:	fd06879b          	addiw	a5,a3,-48
 290:	0ff7f793          	zext.b	a5,a5
 294:	fef671e3          	bgeu	a2,a5,276 <atoi+0x1e>
  return n;
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  n = 0;
 2a0:	4501                	li	a0,0
 2a2:	bfdd                	j	298 <atoi+0x40>

00000000000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e406                	sd	ra,8(sp)
 2a8:	e022                	sd	s0,0(sp)
 2aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ac:	02b57563          	bgeu	a0,a1,2d6 <memmove+0x32>
    while(n-- > 0)
 2b0:	00c05f63          	blez	a2,2ce <memmove+0x2a>
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2bc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2be:	0585                	addi	a1,a1,1
 2c0:	0705                	addi	a4,a4,1
 2c2:	fff5c683          	lbu	a3,-1(a1)
 2c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ca:	fee79ae3          	bne	a5,a4,2be <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
    dst += n;
 2d6:	00c50733          	add	a4,a0,a2
    src += n;
 2da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2dc:	fec059e3          	blez	a2,2ce <memmove+0x2a>
 2e0:	fff6079b          	addiw	a5,a2,-1
 2e4:	1782                	slli	a5,a5,0x20
 2e6:	9381                	srli	a5,a5,0x20
 2e8:	fff7c793          	not	a5,a5
 2ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ee:	15fd                	addi	a1,a1,-1
 2f0:	177d                	addi	a4,a4,-1
 2f2:	0005c683          	lbu	a3,0(a1)
 2f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fa:	fef71ae3          	bne	a4,a5,2ee <memmove+0x4a>
 2fe:	bfc1                	j	2ce <memmove+0x2a>

0000000000000300 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	ca0d                	beqz	a2,33a <memcmp+0x3a>
 30a:	fff6069b          	addiw	a3,a2,-1
 30e:	1682                	slli	a3,a3,0x20
 310:	9281                	srli	a3,a3,0x20
 312:	0685                	addi	a3,a3,1
 314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x16>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x32>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  return 0;
 33a:	4501                	li	a0,0
 33c:	bfdd                	j	332 <memcmp+0x32>

000000000000033e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 346:	f5fff0ef          	jal	2a4 <memmove>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 352:	4885                	li	a7,1
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exit>:
.global exit
exit:
 li a7, SYS_exit
 35a:	4889                	li	a7,2
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <wait>:
.global wait
wait:
 li a7, SYS_wait
 362:	488d                	li	a7,3
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36a:	4891                	li	a7,4
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <read>:
.global read
read:
 li a7, SYS_read
 372:	4895                	li	a7,5
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <write>:
.global write
write:
 li a7, SYS_write
 37a:	48c1                	li	a7,16
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <close>:
.global close
close:
 li a7, SYS_close
 382:	48d5                	li	a7,21
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <kill>:
.global kill
kill:
 li a7, SYS_kill
 38a:	4899                	li	a7,6
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exec>:
.global exec
exec:
 li a7, SYS_exec
 392:	489d                	li	a7,7
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <open>:
.global open
open:
 li a7, SYS_open
 39a:	48bd                	li	a7,15
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a2:	48c5                	li	a7,17
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3aa:	48c9                	li	a7,18
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b2:	48a1                	li	a7,8
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <link>:
.global link
link:
 li a7, SYS_link
 3ba:	48cd                	li	a7,19
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c2:	48d1                	li	a7,20
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ca:	48a5                	li	a7,9
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d2:	48a9                	li	a7,10
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3da:	48ad                	li	a7,11
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e2:	48b1                	li	a7,12
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ea:	48b5                	li	a7,13
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f2:	48b9                	li	a7,14
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 3fa:	48d9                	li	a7,22
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <ps>:
.global ps
ps:
 li a7, SYS_ps
 402:	48dd                	li	a7,23
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 40a:	48e1                	li	a7,24
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 412:	48e5                	li	a7,25
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 41a:	48e9                	li	a7,26
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 422:	1101                	addi	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	1000                	addi	s0,sp,32
 42a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42e:	4605                	li	a2,1
 430:	fef40593          	addi	a1,s0,-17
 434:	f47ff0ef          	jal	37a <write>
}
 438:	60e2                	ld	ra,24(sp)
 43a:	6442                	ld	s0,16(sp)
 43c:	6105                	addi	sp,sp,32
 43e:	8082                	ret

0000000000000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	7139                	addi	sp,sp,-64
 442:	fc06                	sd	ra,56(sp)
 444:	f822                	sd	s0,48(sp)
 446:	f426                	sd	s1,40(sp)
 448:	f04a                	sd	s2,32(sp)
 44a:	ec4e                	sd	s3,24(sp)
 44c:	0080                	addi	s0,sp,64
 44e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 450:	c299                	beqz	a3,456 <printint+0x16>
 452:	0605ce63          	bltz	a1,4ce <printint+0x8e>
  neg = 0;
 456:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 458:	fc040313          	addi	t1,s0,-64
  neg = 0;
 45c:	869a                	mv	a3,t1
  i = 0;
 45e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 460:	00000817          	auipc	a6,0x0
 464:	55080813          	addi	a6,a6,1360 # 9b0 <digits>
 468:	88be                	mv	a7,a5
 46a:	0017851b          	addiw	a0,a5,1
 46e:	87aa                	mv	a5,a0
 470:	02c5f73b          	remuw	a4,a1,a2
 474:	1702                	slli	a4,a4,0x20
 476:	9301                	srli	a4,a4,0x20
 478:	9742                	add	a4,a4,a6
 47a:	00074703          	lbu	a4,0(a4)
 47e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 482:	872e                	mv	a4,a1
 484:	02c5d5bb          	divuw	a1,a1,a2
 488:	0685                	addi	a3,a3,1
 48a:	fcc77fe3          	bgeu	a4,a2,468 <printint+0x28>
  if(neg)
 48e:	000e0c63          	beqz	t3,4a6 <printint+0x66>
    buf[i++] = '-';
 492:	fd050793          	addi	a5,a0,-48
 496:	00878533          	add	a0,a5,s0
 49a:	02d00793          	li	a5,45
 49e:	fef50823          	sb	a5,-16(a0)
 4a2:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4a6:	fff7899b          	addiw	s3,a5,-1
 4aa:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4ae:	fff4c583          	lbu	a1,-1(s1)
 4b2:	854a                	mv	a0,s2
 4b4:	f6fff0ef          	jal	422 <putc>
  while(--i >= 0)
 4b8:	39fd                	addiw	s3,s3,-1
 4ba:	14fd                	addi	s1,s1,-1
 4bc:	fe09d9e3          	bgez	s3,4ae <printint+0x6e>
}
 4c0:	70e2                	ld	ra,56(sp)
 4c2:	7442                	ld	s0,48(sp)
 4c4:	74a2                	ld	s1,40(sp)
 4c6:	7902                	ld	s2,32(sp)
 4c8:	69e2                	ld	s3,24(sp)
 4ca:	6121                	addi	sp,sp,64
 4cc:	8082                	ret
    x = -xx;
 4ce:	40b005bb          	negw	a1,a1
    neg = 1;
 4d2:	4e05                	li	t3,1
    x = -xx;
 4d4:	b751                	j	458 <printint+0x18>

00000000000004d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d6:	711d                	addi	sp,sp,-96
 4d8:	ec86                	sd	ra,88(sp)
 4da:	e8a2                	sd	s0,80(sp)
 4dc:	e4a6                	sd	s1,72(sp)
 4de:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e0:	0005c483          	lbu	s1,0(a1)
 4e4:	26048663          	beqz	s1,750 <vprintf+0x27a>
 4e8:	e0ca                	sd	s2,64(sp)
 4ea:	fc4e                	sd	s3,56(sp)
 4ec:	f852                	sd	s4,48(sp)
 4ee:	f456                	sd	s5,40(sp)
 4f0:	f05a                	sd	s6,32(sp)
 4f2:	ec5e                	sd	s7,24(sp)
 4f4:	e862                	sd	s8,16(sp)
 4f6:	e466                	sd	s9,8(sp)
 4f8:	8b2a                	mv	s6,a0
 4fa:	8a2e                	mv	s4,a1
 4fc:	8bb2                	mv	s7,a2
  state = 0;
 4fe:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 500:	4901                	li	s2,0
 502:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 504:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 508:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	06c00c93          	li	s9,108
 510:	a00d                	j	532 <vprintf+0x5c>
        putc(fd, c0);
 512:	85a6                	mv	a1,s1
 514:	855a                	mv	a0,s6
 516:	f0dff0ef          	jal	422 <putc>
 51a:	a019                	j	520 <vprintf+0x4a>
    } else if(state == '%'){
 51c:	03598363          	beq	s3,s5,542 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 520:	0019079b          	addiw	a5,s2,1
 524:	893e                	mv	s2,a5
 526:	873e                	mv	a4,a5
 528:	97d2                	add	a5,a5,s4
 52a:	0007c483          	lbu	s1,0(a5)
 52e:	20048963          	beqz	s1,740 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 532:	0004879b          	sext.w	a5,s1
    if(state == 0){
 536:	fe0993e3          	bnez	s3,51c <vprintf+0x46>
      if(c0 == '%'){
 53a:	fd579ce3          	bne	a5,s5,512 <vprintf+0x3c>
        state = '%';
 53e:	89be                	mv	s3,a5
 540:	b7c5                	j	520 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 542:	00ea06b3          	add	a3,s4,a4
 546:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 54a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 54c:	c681                	beqz	a3,554 <vprintf+0x7e>
 54e:	9752                	add	a4,a4,s4
 550:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 554:	03878e63          	beq	a5,s8,590 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 558:	05978863          	beq	a5,s9,5a8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 55c:	07500713          	li	a4,117
 560:	0ee78263          	beq	a5,a4,644 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 564:	07800713          	li	a4,120
 568:	12e78463          	beq	a5,a4,690 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 56c:	07000713          	li	a4,112
 570:	14e78963          	beq	a5,a4,6c2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 574:	07300713          	li	a4,115
 578:	18e78863          	beq	a5,a4,708 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 57c:	02500713          	li	a4,37
 580:	04e79463          	bne	a5,a4,5c8 <vprintf+0xf2>
        putc(fd, '%');
 584:	85ba                	mv	a1,a4
 586:	855a                	mv	a0,s6
 588:	e9bff0ef          	jal	422 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bf49                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 590:	008b8493          	addi	s1,s7,8
 594:	4685                	li	a3,1
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	ea3ff0ef          	jal	440 <printint>
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bfad                	j	520 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5a8:	06400793          	li	a5,100
 5ac:	02f68963          	beq	a3,a5,5de <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b0:	06c00793          	li	a5,108
 5b4:	04f68263          	beq	a3,a5,5f8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5b8:	07500793          	li	a5,117
 5bc:	0af68063          	beq	a3,a5,65c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5c0:	07800793          	li	a5,120
 5c4:	0ef68263          	beq	a3,a5,6a8 <vprintf+0x1d2>
        putc(fd, '%');
 5c8:	02500593          	li	a1,37
 5cc:	855a                	mv	a0,s6
 5ce:	e55ff0ef          	jal	422 <putc>
        putc(fd, c0);
 5d2:	85a6                	mv	a1,s1
 5d4:	855a                	mv	a0,s6
 5d6:	e4dff0ef          	jal	422 <putc>
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b791                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e55ff0ef          	jal	440 <printint>
        i += 1;
 5f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
        i += 1;
 5f6:	b72d                	j	520 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f8:	06400793          	li	a5,100
 5fc:	02f60763          	beq	a2,a5,62a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 600:	07500793          	li	a5,117
 604:	06f60963          	beq	a2,a5,676 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 608:	07800793          	li	a5,120
 60c:	faf61ee3          	bne	a2,a5,5c8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	008b8493          	addi	s1,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e23ff0ef          	jal	440 <printint>
        i += 2;
 622:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
        i += 2;
 628:	bde5                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e09ff0ef          	jal	440 <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bdf9                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	defff0ef          	jal	440 <printint>
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
 65a:	b5d9                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	008b8493          	addi	s1,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dd7ff0ef          	jal	440 <printint>
        i += 1;
 66e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
        i += 1;
 674:	b575                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	008b8493          	addi	s1,s7,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	dbdff0ef          	jal	440 <printint>
        i += 2;
 688:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
        i += 2;
 68e:	bd49                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	da3ff0ef          	jal	440 <printint>
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bdad                	j	520 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	008b8493          	addi	s1,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d8bff0ef          	jal	440 <printint>
        i += 1;
 6ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
        i += 1;
 6c0:	b585                	j	520 <vprintf+0x4a>
 6c2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c4:	008b8d13          	addi	s10,s7,8
 6c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6cc:	03000593          	li	a1,48
 6d0:	855a                	mv	a0,s6
 6d2:	d51ff0ef          	jal	422 <putc>
  putc(fd, 'x');
 6d6:	07800593          	li	a1,120
 6da:	855a                	mv	a0,s6
 6dc:	d47ff0ef          	jal	422 <putc>
 6e0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e2:	00000b97          	auipc	s7,0x0
 6e6:	2ceb8b93          	addi	s7,s7,718 # 9b0 <digits>
 6ea:	03c9d793          	srli	a5,s3,0x3c
 6ee:	97de                	add	a5,a5,s7
 6f0:	0007c583          	lbu	a1,0(a5)
 6f4:	855a                	mv	a0,s6
 6f6:	d2dff0ef          	jal	422 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	slli	s3,s3,0x4
 6fc:	34fd                	addiw	s1,s1,-1
 6fe:	f4f5                	bnez	s1,6ea <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 700:	8bea                	mv	s7,s10
      state = 0;
 702:	4981                	li	s3,0
 704:	6d02                	ld	s10,0(sp)
 706:	bd29                	j	520 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 708:	008b8993          	addi	s3,s7,8
 70c:	000bb483          	ld	s1,0(s7)
 710:	cc91                	beqz	s1,72c <vprintf+0x256>
        for(; *s; s++)
 712:	0004c583          	lbu	a1,0(s1)
 716:	c195                	beqz	a1,73a <vprintf+0x264>
          putc(fd, *s);
 718:	855a                	mv	a0,s6
 71a:	d09ff0ef          	jal	422 <putc>
        for(; *s; s++)
 71e:	0485                	addi	s1,s1,1
 720:	0004c583          	lbu	a1,0(s1)
 724:	f9f5                	bnez	a1,718 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 726:	8bce                	mv	s7,s3
      state = 0;
 728:	4981                	li	s3,0
 72a:	bbdd                	j	520 <vprintf+0x4a>
          s = "(null)";
 72c:	00000497          	auipc	s1,0x0
 730:	27c48493          	addi	s1,s1,636 # 9a8 <malloc+0x16c>
        for(; *s; s++)
 734:	02800593          	li	a1,40
 738:	b7c5                	j	718 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b3cd                	j	520 <vprintf+0x4a>
 740:	6906                	ld	s2,64(sp)
 742:	79e2                	ld	s3,56(sp)
 744:	7a42                	ld	s4,48(sp)
 746:	7aa2                	ld	s5,40(sp)
 748:	7b02                	ld	s6,32(sp)
 74a:	6be2                	ld	s7,24(sp)
 74c:	6c42                	ld	s8,16(sp)
 74e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 750:	60e6                	ld	ra,88(sp)
 752:	6446                	ld	s0,80(sp)
 754:	64a6                	ld	s1,72(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret

000000000000075a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75a:	715d                	addi	sp,sp,-80
 75c:	ec06                	sd	ra,24(sp)
 75e:	e822                	sd	s0,16(sp)
 760:	1000                	addi	s0,sp,32
 762:	e010                	sd	a2,0(s0)
 764:	e414                	sd	a3,8(s0)
 766:	e818                	sd	a4,16(s0)
 768:	ec1c                	sd	a5,24(s0)
 76a:	03043023          	sd	a6,32(s0)
 76e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 772:	8622                	mv	a2,s0
 774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 778:	d5fff0ef          	jal	4d6 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6161                	addi	sp,sp,80
 782:	8082                	ret

0000000000000784 <printf>:

void
printf(const char *fmt, ...)
{
 784:	711d                	addi	sp,sp,-96
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e40c                	sd	a1,8(s0)
 78e:	e810                	sd	a2,16(s0)
 790:	ec14                	sd	a3,24(s0)
 792:	f018                	sd	a4,32(s0)
 794:	f41c                	sd	a5,40(s0)
 796:	03043823          	sd	a6,48(s0)
 79a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	00840613          	addi	a2,s0,8
 7a2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a6:	85aa                	mv	a1,a0
 7a8:	4505                	li	a0,1
 7aa:	d2dff0ef          	jal	4d6 <vprintf>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6125                	addi	sp,sp,96
 7b4:	8082                	ret

00000000000007b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b6:	1141                	addi	sp,sp,-16
 7b8:	e406                	sd	ra,8(sp)
 7ba:	e022                	sd	s0,0(sp)
 7bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	00001797          	auipc	a5,0x1
 7c6:	84e7b783          	ld	a5,-1970(a5) # 1010 <freep>
 7ca:	a02d                	j	7f4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7cc:	4618                	lw	a4,8(a2)
 7ce:	9f2d                	addw	a4,a4,a1
 7d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	6398                	ld	a4,0(a5)
 7d6:	6310                	ld	a2,0(a4)
 7d8:	a83d                	j	816 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7da:	ff852703          	lw	a4,-8(a0)
 7de:	9f31                	addw	a4,a4,a2
 7e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e2:	ff053683          	ld	a3,-16(a0)
 7e6:	a091                	j	82a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e7e463          	bltu	a5,a4,7f2 <free+0x3c>
 7ee:	00e6ea63          	bltu	a3,a4,802 <free+0x4c>
{
 7f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	fed7fae3          	bgeu	a5,a3,7e8 <free+0x32>
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e6e463          	bltu	a3,a4,802 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	fee7eae3          	bltu	a5,a4,7f2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 802:	ff852583          	lw	a1,-8(a0)
 806:	6390                	ld	a2,0(a5)
 808:	02059813          	slli	a6,a1,0x20
 80c:	01c85713          	srli	a4,a6,0x1c
 810:	9736                	add	a4,a4,a3
 812:	fae60de3          	beq	a2,a4,7cc <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 81a:	4790                	lw	a2,8(a5)
 81c:	02061593          	slli	a1,a2,0x20
 820:	01c5d713          	srli	a4,a1,0x1c
 824:	973e                	add	a4,a4,a5
 826:	fae68ae3          	beq	a3,a4,7da <free+0x24>
    p->s.ptr = bp->s.ptr;
 82a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82c:	00000717          	auipc	a4,0x0
 830:	7ef73223          	sd	a5,2020(a4) # 1010 <freep>
}
 834:	60a2                	ld	ra,8(sp)
 836:	6402                	ld	s0,0(sp)
 838:	0141                	addi	sp,sp,16
 83a:	8082                	ret

000000000000083c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83c:	7139                	addi	sp,sp,-64
 83e:	fc06                	sd	ra,56(sp)
 840:	f822                	sd	s0,48(sp)
 842:	f04a                	sd	s2,32(sp)
 844:	ec4e                	sd	s3,24(sp)
 846:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	02051993          	slli	s3,a0,0x20
 84c:	0209d993          	srli	s3,s3,0x20
 850:	09bd                	addi	s3,s3,15
 852:	0049d993          	srli	s3,s3,0x4
 856:	2985                	addiw	s3,s3,1
 858:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 85a:	00000517          	auipc	a0,0x0
 85e:	7b653503          	ld	a0,1974(a0) # 1010 <freep>
 862:	c905                	beqz	a0,892 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	09377663          	bgeu	a4,s3,8f4 <malloc+0xb8>
 86c:	f426                	sd	s1,40(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 874:	8a4e                	mv	s4,s3
 876:	6705                	lui	a4,0x1
 878:	00e9f363          	bgeu	s3,a4,87e <malloc+0x42>
 87c:	6a05                	lui	s4,0x1
 87e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 882:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 886:	00000497          	auipc	s1,0x0
 88a:	78a48493          	addi	s1,s1,1930 # 1010 <freep>
  if(p == (char*)-1)
 88e:	5afd                	li	s5,-1
 890:	a83d                	j	8ce <malloc+0x92>
 892:	f426                	sd	s1,40(sp)
 894:	e852                	sd	s4,16(sp)
 896:	e456                	sd	s5,8(sp)
 898:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89a:	00000797          	auipc	a5,0x0
 89e:	78678793          	addi	a5,a5,1926 # 1020 <base>
 8a2:	00000717          	auipc	a4,0x0
 8a6:	76f73723          	sd	a5,1902(a4) # 1010 <freep>
 8aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b0:	b7d1                	j	874 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	e118                	sd	a4,0(a0)
 8b6:	a899                	j	90c <malloc+0xd0>
  hp->s.size = nu;
 8b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8bc:	0541                	addi	a0,a0,16
 8be:	ef9ff0ef          	jal	7b6 <free>
  return freep;
 8c2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8c4:	c125                	beqz	a0,924 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c8:	4798                	lw	a4,8(a5)
 8ca:	03277163          	bgeu	a4,s2,8ec <malloc+0xb0>
    if(p == freep)
 8ce:	6098                	ld	a4,0(s1)
 8d0:	853e                	mv	a0,a5
 8d2:	fef71ae3          	bne	a4,a5,8c6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d6:	8552                	mv	a0,s4
 8d8:	b0bff0ef          	jal	3e2 <sbrk>
  if(p == (char*)-1)
 8dc:	fd551ee3          	bne	a0,s5,8b8 <malloc+0x7c>
        return 0;
 8e0:	4501                	li	a0,0
 8e2:	74a2                	ld	s1,40(sp)
 8e4:	6a42                	ld	s4,16(sp)
 8e6:	6aa2                	ld	s5,8(sp)
 8e8:	6b02                	ld	s6,0(sp)
 8ea:	a03d                	j	918 <malloc+0xdc>
 8ec:	74a2                	ld	s1,40(sp)
 8ee:	6a42                	ld	s4,16(sp)
 8f0:	6aa2                	ld	s5,8(sp)
 8f2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f4:	fae90fe3          	beq	s2,a4,8b2 <malloc+0x76>
        p->s.size -= nunits;
 8f8:	4137073b          	subw	a4,a4,s3
 8fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fe:	02071693          	slli	a3,a4,0x20
 902:	01c6d713          	srli	a4,a3,0x1c
 906:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 908:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90c:	00000717          	auipc	a4,0x0
 910:	70a73223          	sd	a0,1796(a4) # 1010 <freep>
      return (void*)(p + 1);
 914:	01078513          	addi	a0,a5,16
  }
}
 918:	70e2                	ld	ra,56(sp)
 91a:	7442                	ld	s0,48(sp)
 91c:	7902                	ld	s2,32(sp)
 91e:	69e2                	ld	s3,24(sp)
 920:	6121                	addi	sp,sp,64
 922:	8082                	ret
 924:	74a2                	ld	s1,40(sp)
 926:	6a42                	ld	s4,16(sp)
 928:	6aa2                	ld	s5,8(sp)
 92a:	6b02                	ld	s6,0(sp)
 92c:	b7f5                	j	918 <malloc+0xdc>
