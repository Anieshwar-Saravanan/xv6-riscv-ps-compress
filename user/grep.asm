
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	711d                	addi	sp,sp,-96
 108:	ec86                	sd	ra,88(sp)
 10a:	e8a2                	sd	s0,80(sp)
 10c:	e4a6                	sd	s1,72(sp)
 10e:	e0ca                	sd	s2,64(sp)
 110:	fc4e                	sd	s3,56(sp)
 112:	f852                	sd	s4,48(sp)
 114:	f456                	sd	s5,40(sp)
 116:	f05a                	sd	s6,32(sp)
 118:	ec5e                	sd	s7,24(sp)
 11a:	e862                	sd	s8,16(sp)
 11c:	e466                	sd	s9,8(sp)
 11e:	e06a                	sd	s10,0(sp)
 120:	1080                	addi	s0,sp,96
 122:	8aaa                	mv	s5,a0
 124:	8cae                	mv	s9,a1
  m = 0;
 126:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 128:	3ff00d13          	li	s10,1023
 12c:	00001b97          	auipc	s7,0x1
 130:	ee4b8b93          	addi	s7,s7,-284 # 1010 <buf>
    while((q = strchr(p, '\n')) != 0){
 134:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 136:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	a82d                	j	172 <grep+0x6c>
      p = q+1;
 13a:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 13e:	85ce                	mv	a1,s3
 140:	854a                	mv	a0,s2
 142:	1d6000ef          	jal	318 <strchr>
 146:	84aa                	mv	s1,a0
 148:	c11d                	beqz	a0,16e <grep+0x68>
      *q = 0;
 14a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 14e:	85ca                	mv	a1,s2
 150:	8556                	mv	a0,s5
 152:	f6fff0ef          	jal	c0 <match>
 156:	d175                	beqz	a0,13a <grep+0x34>
        *q = '\n';
 158:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 15c:	00148613          	addi	a2,s1,1
 160:	4126063b          	subw	a2,a2,s2
 164:	85ca                	mv	a1,s2
 166:	8562                	mv	a0,s8
 168:	3b8000ef          	jal	520 <write>
 16c:	b7f9                	j	13a <grep+0x34>
    if(m > 0){
 16e:	03604463          	bgtz	s6,196 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 172:	416d063b          	subw	a2,s10,s6
 176:	016b85b3          	add	a1,s7,s6
 17a:	8566                	mv	a0,s9
 17c:	39c000ef          	jal	518 <read>
 180:	02a05863          	blez	a0,1b0 <grep+0xaa>
    m += n;
 184:	00ab0a3b          	addw	s4,s6,a0
 188:	8b52                	mv	s6,s4
    buf[m] = '\0';
 18a:	014b87b3          	add	a5,s7,s4
 18e:	00078023          	sb	zero,0(a5)
    p = buf;
 192:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 194:	b76d                	j	13e <grep+0x38>
      m -= p - buf;
 196:	00001517          	auipc	a0,0x1
 19a:	e7a50513          	addi	a0,a0,-390 # 1010 <buf>
 19e:	40a907b3          	sub	a5,s2,a0
 1a2:	40fa063b          	subw	a2,s4,a5
 1a6:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 1a8:	85ca                	mv	a1,s2
 1aa:	2a0000ef          	jal	44a <memmove>
 1ae:	b7d1                	j	172 <grep+0x6c>
}
 1b0:	60e6                	ld	ra,88(sp)
 1b2:	6446                	ld	s0,80(sp)
 1b4:	64a6                	ld	s1,72(sp)
 1b6:	6906                	ld	s2,64(sp)
 1b8:	79e2                	ld	s3,56(sp)
 1ba:	7a42                	ld	s4,48(sp)
 1bc:	7aa2                	ld	s5,40(sp)
 1be:	7b02                	ld	s6,32(sp)
 1c0:	6be2                	ld	s7,24(sp)
 1c2:	6c42                	ld	s8,16(sp)
 1c4:	6ca2                	ld	s9,8(sp)
 1c6:	6d02                	ld	s10,0(sp)
 1c8:	6125                	addi	sp,sp,96
 1ca:	8082                	ret

00000000000001cc <main>:
{
 1cc:	7179                	addi	sp,sp,-48
 1ce:	f406                	sd	ra,40(sp)
 1d0:	f022                	sd	s0,32(sp)
 1d2:	ec26                	sd	s1,24(sp)
 1d4:	e84a                	sd	s2,16(sp)
 1d6:	e44e                	sd	s3,8(sp)
 1d8:	e052                	sd	s4,0(sp)
 1da:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1dc:	4785                	li	a5,1
 1de:	04a7d663          	bge	a5,a0,22a <main+0x5e>
  pattern = argv[1];
 1e2:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e6:	4789                	li	a5,2
 1e8:	04a7db63          	bge	a5,a0,23e <main+0x72>
 1ec:	01058913          	addi	s2,a1,16
 1f0:	ffd5099b          	addiw	s3,a0,-3
 1f4:	02099793          	slli	a5,s3,0x20
 1f8:	01d7d993          	srli	s3,a5,0x1d
 1fc:	05e1                	addi	a1,a1,24
 1fe:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 200:	4581                	li	a1,0
 202:	00093503          	ld	a0,0(s2)
 206:	33a000ef          	jal	540 <open>
 20a:	84aa                	mv	s1,a0
 20c:	04054063          	bltz	a0,24c <main+0x80>
    grep(pattern, fd);
 210:	85aa                	mv	a1,a0
 212:	8552                	mv	a0,s4
 214:	ef3ff0ef          	jal	106 <grep>
    close(fd);
 218:	8526                	mv	a0,s1
 21a:	30e000ef          	jal	528 <close>
  for(i = 2; i < argc; i++){
 21e:	0921                	addi	s2,s2,8
 220:	ff3910e3          	bne	s2,s3,200 <main+0x34>
  exit(0);
 224:	4501                	li	a0,0
 226:	2da000ef          	jal	500 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 22a:	00001597          	auipc	a1,0x1
 22e:	8b658593          	addi	a1,a1,-1866 # ae0 <malloc+0xfe>
 232:	4509                	li	a0,2
 234:	6cc000ef          	jal	900 <fprintf>
    exit(1);
 238:	4505                	li	a0,1
 23a:	2c6000ef          	jal	500 <exit>
    grep(pattern, 0);
 23e:	4581                	li	a1,0
 240:	8552                	mv	a0,s4
 242:	ec5ff0ef          	jal	106 <grep>
    exit(0);
 246:	4501                	li	a0,0
 248:	2b8000ef          	jal	500 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 24c:	00093583          	ld	a1,0(s2)
 250:	00001517          	auipc	a0,0x1
 254:	8b050513          	addi	a0,a0,-1872 # b00 <malloc+0x11e>
 258:	6d2000ef          	jal	92a <printf>
      exit(1);
 25c:	4505                	li	a0,1
 25e:	2a2000ef          	jal	500 <exit>

0000000000000262 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  extern int main();
  main();
 26a:	f63ff0ef          	jal	1cc <main>
  exit(0);
 26e:	4501                	li	a0,0
 270:	290000ef          	jal	500 <exit>

0000000000000274 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27c:	87aa                	mv	a5,a0
 27e:	0585                	addi	a1,a1,1
 280:	0785                	addi	a5,a5,1
 282:	fff5c703          	lbu	a4,-1(a1)
 286:	fee78fa3          	sb	a4,-1(a5)
 28a:	fb75                	bnez	a4,27e <strcpy+0xa>
    ;
  return os;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb91                	beqz	a5,2b4 <strcmp+0x20>
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00f71763          	bne	a4,a5,2b4 <strcmp+0x20>
    p++, q++;
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbe5                	bnez	a5,2a2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2b4:	0005c503          	lbu	a0,0(a1)
}
 2b8:	40a7853b          	subw	a0,a5,a0
 2bc:	60a2                	ld	ra,8(sp)
 2be:	6402                	ld	s0,0(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <strlen>:

uint
strlen(const char *s)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	cf99                	beqz	a5,2ee <strlen+0x2a>
 2d2:	0505                	addi	a0,a0,1
 2d4:	87aa                	mv	a5,a0
 2d6:	86be                	mv	a3,a5
 2d8:	0785                	addi	a5,a5,1
 2da:	fff7c703          	lbu	a4,-1(a5)
 2de:	ff65                	bnez	a4,2d6 <strlen+0x12>
 2e0:	40a6853b          	subw	a0,a3,a0
 2e4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e6:	60a2                	ld	ra,8(sp)
 2e8:	6402                	ld	s0,0(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  for(n = 0; s[n]; n++)
 2ee:	4501                	li	a0,0
 2f0:	bfdd                	j	2e6 <strlen+0x22>

00000000000002f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2fa:	ca19                	beqz	a2,310 <memset+0x1e>
 2fc:	87aa                	mv	a5,a0
 2fe:	1602                	slli	a2,a2,0x20
 300:	9201                	srli	a2,a2,0x20
 302:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 306:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 30a:	0785                	addi	a5,a5,1
 30c:	fee79de3          	bne	a5,a4,306 <memset+0x14>
  }
  return dst;
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <strchr>:

char*
strchr(const char *s, char c)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 320:	00054783          	lbu	a5,0(a0)
 324:	cf81                	beqz	a5,33c <strchr+0x24>
    if(*s == c)
 326:	00f58763          	beq	a1,a5,334 <strchr+0x1c>
  for(; *s; s++)
 32a:	0505                	addi	a0,a0,1
 32c:	00054783          	lbu	a5,0(a0)
 330:	fbfd                	bnez	a5,326 <strchr+0xe>
      return (char*)s;
  return 0;
 332:	4501                	li	a0,0
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  return 0;
 33c:	4501                	li	a0,0
 33e:	bfdd                	j	334 <strchr+0x1c>

0000000000000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	7159                	addi	sp,sp,-112
 342:	f486                	sd	ra,104(sp)
 344:	f0a2                	sd	s0,96(sp)
 346:	eca6                	sd	s1,88(sp)
 348:	e8ca                	sd	s2,80(sp)
 34a:	e4ce                	sd	s3,72(sp)
 34c:	e0d2                	sd	s4,64(sp)
 34e:	fc56                	sd	s5,56(sp)
 350:	f85a                	sd	s6,48(sp)
 352:	f45e                	sd	s7,40(sp)
 354:	f062                	sd	s8,32(sp)
 356:	ec66                	sd	s9,24(sp)
 358:	e86a                	sd	s10,16(sp)
 35a:	1880                	addi	s0,sp,112
 35c:	8caa                	mv	s9,a0
 35e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 360:	892a                	mv	s2,a0
 362:	4481                	li	s1,0
    cc = read(0, &c, 1);
 364:	f9f40b13          	addi	s6,s0,-97
 368:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 36a:	4ba9                	li	s7,10
 36c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 36e:	8d26                	mv	s10,s1
 370:	0014899b          	addiw	s3,s1,1
 374:	84ce                	mv	s1,s3
 376:	0349d563          	bge	s3,s4,3a0 <gets+0x60>
    cc = read(0, &c, 1);
 37a:	8656                	mv	a2,s5
 37c:	85da                	mv	a1,s6
 37e:	4501                	li	a0,0
 380:	198000ef          	jal	518 <read>
    if(cc < 1)
 384:	00a05e63          	blez	a0,3a0 <gets+0x60>
    buf[i++] = c;
 388:	f9f44783          	lbu	a5,-97(s0)
 38c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 390:	01778763          	beq	a5,s7,39e <gets+0x5e>
 394:	0905                	addi	s2,s2,1
 396:	fd879ce3          	bne	a5,s8,36e <gets+0x2e>
    buf[i++] = c;
 39a:	8d4e                	mv	s10,s3
 39c:	a011                	j	3a0 <gets+0x60>
 39e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3a0:	9d66                	add	s10,s10,s9
 3a2:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3a6:	8566                	mv	a0,s9
 3a8:	70a6                	ld	ra,104(sp)
 3aa:	7406                	ld	s0,96(sp)
 3ac:	64e6                	ld	s1,88(sp)
 3ae:	6946                	ld	s2,80(sp)
 3b0:	69a6                	ld	s3,72(sp)
 3b2:	6a06                	ld	s4,64(sp)
 3b4:	7ae2                	ld	s5,56(sp)
 3b6:	7b42                	ld	s6,48(sp)
 3b8:	7ba2                	ld	s7,40(sp)
 3ba:	7c02                	ld	s8,32(sp)
 3bc:	6ce2                	ld	s9,24(sp)
 3be:	6d42                	ld	s10,16(sp)
 3c0:	6165                	addi	sp,sp,112
 3c2:	8082                	ret

00000000000003c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c4:	1101                	addi	sp,sp,-32
 3c6:	ec06                	sd	ra,24(sp)
 3c8:	e822                	sd	s0,16(sp)
 3ca:	e04a                	sd	s2,0(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d0:	4581                	li	a1,0
 3d2:	16e000ef          	jal	540 <open>
  if(fd < 0)
 3d6:	02054263          	bltz	a0,3fa <stat+0x36>
 3da:	e426                	sd	s1,8(sp)
 3dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3de:	85ca                	mv	a1,s2
 3e0:	178000ef          	jal	558 <fstat>
 3e4:	892a                	mv	s2,a0
  close(fd);
 3e6:	8526                	mv	a0,s1
 3e8:	140000ef          	jal	528 <close>
  return r;
 3ec:	64a2                	ld	s1,8(sp)
}
 3ee:	854a                	mv	a0,s2
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	6902                	ld	s2,0(sp)
 3f6:	6105                	addi	sp,sp,32
 3f8:	8082                	ret
    return -1;
 3fa:	597d                	li	s2,-1
 3fc:	bfcd                	j	3ee <stat+0x2a>

00000000000003fe <atoi>:

int
atoi(const char *s)
{
 3fe:	1141                	addi	sp,sp,-16
 400:	e406                	sd	ra,8(sp)
 402:	e022                	sd	s0,0(sp)
 404:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 406:	00054683          	lbu	a3,0(a0)
 40a:	fd06879b          	addiw	a5,a3,-48
 40e:	0ff7f793          	zext.b	a5,a5
 412:	4625                	li	a2,9
 414:	02f66963          	bltu	a2,a5,446 <atoi+0x48>
 418:	872a                	mv	a4,a0
  n = 0;
 41a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 41c:	0705                	addi	a4,a4,1
 41e:	0025179b          	slliw	a5,a0,0x2
 422:	9fa9                	addw	a5,a5,a0
 424:	0017979b          	slliw	a5,a5,0x1
 428:	9fb5                	addw	a5,a5,a3
 42a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 42e:	00074683          	lbu	a3,0(a4)
 432:	fd06879b          	addiw	a5,a3,-48
 436:	0ff7f793          	zext.b	a5,a5
 43a:	fef671e3          	bgeu	a2,a5,41c <atoi+0x1e>
  return n;
}
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  n = 0;
 446:	4501                	li	a0,0
 448:	bfdd                	j	43e <atoi+0x40>

000000000000044a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e406                	sd	ra,8(sp)
 44e:	e022                	sd	s0,0(sp)
 450:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 452:	02b57563          	bgeu	a0,a1,47c <memmove+0x32>
    while(n-- > 0)
 456:	00c05f63          	blez	a2,474 <memmove+0x2a>
 45a:	1602                	slli	a2,a2,0x20
 45c:	9201                	srli	a2,a2,0x20
 45e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 462:	872a                	mv	a4,a0
      *dst++ = *src++;
 464:	0585                	addi	a1,a1,1
 466:	0705                	addi	a4,a4,1
 468:	fff5c683          	lbu	a3,-1(a1)
 46c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 470:	fee79ae3          	bne	a5,a4,464 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 474:	60a2                	ld	ra,8(sp)
 476:	6402                	ld	s0,0(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret
    dst += n;
 47c:	00c50733          	add	a4,a0,a2
    src += n;
 480:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 482:	fec059e3          	blez	a2,474 <memmove+0x2a>
 486:	fff6079b          	addiw	a5,a2,-1
 48a:	1782                	slli	a5,a5,0x20
 48c:	9381                	srli	a5,a5,0x20
 48e:	fff7c793          	not	a5,a5
 492:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 494:	15fd                	addi	a1,a1,-1
 496:	177d                	addi	a4,a4,-1
 498:	0005c683          	lbu	a3,0(a1)
 49c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4a0:	fef71ae3          	bne	a4,a5,494 <memmove+0x4a>
 4a4:	bfc1                	j	474 <memmove+0x2a>

00000000000004a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ae:	ca0d                	beqz	a2,4e0 <memcmp+0x3a>
 4b0:	fff6069b          	addiw	a3,a2,-1
 4b4:	1682                	slli	a3,a3,0x20
 4b6:	9281                	srli	a3,a3,0x20
 4b8:	0685                	addi	a3,a3,1
 4ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4bc:	00054783          	lbu	a5,0(a0)
 4c0:	0005c703          	lbu	a4,0(a1)
 4c4:	00e79863          	bne	a5,a4,4d4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4c8:	0505                	addi	a0,a0,1
    p2++;
 4ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4cc:	fed518e3          	bne	a0,a3,4bc <memcmp+0x16>
  }
  return 0;
 4d0:	4501                	li	a0,0
 4d2:	a019                	j	4d8 <memcmp+0x32>
      return *p1 - *p2;
 4d4:	40e7853b          	subw	a0,a5,a4
}
 4d8:	60a2                	ld	ra,8(sp)
 4da:	6402                	ld	s0,0(sp)
 4dc:	0141                	addi	sp,sp,16
 4de:	8082                	ret
  return 0;
 4e0:	4501                	li	a0,0
 4e2:	bfdd                	j	4d8 <memcmp+0x32>

00000000000004e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e4:	1141                	addi	sp,sp,-16
 4e6:	e406                	sd	ra,8(sp)
 4e8:	e022                	sd	s0,0(sp)
 4ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ec:	f5fff0ef          	jal	44a <memmove>
}
 4f0:	60a2                	ld	ra,8(sp)
 4f2:	6402                	ld	s0,0(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret

00000000000004f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4f8:	4885                	li	a7,1
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <exit>:
.global exit
exit:
 li a7, SYS_exit
 500:	4889                	li	a7,2
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <wait>:
.global wait
wait:
 li a7, SYS_wait
 508:	488d                	li	a7,3
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 510:	4891                	li	a7,4
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <read>:
.global read
read:
 li a7, SYS_read
 518:	4895                	li	a7,5
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <write>:
.global write
write:
 li a7, SYS_write
 520:	48c1                	li	a7,16
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <close>:
.global close
close:
 li a7, SYS_close
 528:	48d5                	li	a7,21
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <kill>:
.global kill
kill:
 li a7, SYS_kill
 530:	4899                	li	a7,6
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <exec>:
.global exec
exec:
 li a7, SYS_exec
 538:	489d                	li	a7,7
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <open>:
.global open
open:
 li a7, SYS_open
 540:	48bd                	li	a7,15
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 548:	48c5                	li	a7,17
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 550:	48c9                	li	a7,18
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 558:	48a1                	li	a7,8
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <link>:
.global link
link:
 li a7, SYS_link
 560:	48cd                	li	a7,19
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 568:	48d1                	li	a7,20
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 570:	48a5                	li	a7,9
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <dup>:
.global dup
dup:
 li a7, SYS_dup
 578:	48a9                	li	a7,10
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 580:	48ad                	li	a7,11
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 588:	48b1                	li	a7,12
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 590:	48b5                	li	a7,13
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 598:	48b9                	li	a7,14
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 5a0:	48d9                	li	a7,22
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5a8:	48dd                	li	a7,23
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 5b0:	48e1                	li	a7,24
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 5b8:	48e5                	li	a7,25
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 5c0:	48e9                	li	a7,26
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c8:	1101                	addi	sp,sp,-32
 5ca:	ec06                	sd	ra,24(sp)
 5cc:	e822                	sd	s0,16(sp)
 5ce:	1000                	addi	s0,sp,32
 5d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d4:	4605                	li	a2,1
 5d6:	fef40593          	addi	a1,s0,-17
 5da:	f47ff0ef          	jal	520 <write>
}
 5de:	60e2                	ld	ra,24(sp)
 5e0:	6442                	ld	s0,16(sp)
 5e2:	6105                	addi	sp,sp,32
 5e4:	8082                	ret

00000000000005e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e6:	7139                	addi	sp,sp,-64
 5e8:	fc06                	sd	ra,56(sp)
 5ea:	f822                	sd	s0,48(sp)
 5ec:	f426                	sd	s1,40(sp)
 5ee:	f04a                	sd	s2,32(sp)
 5f0:	ec4e                	sd	s3,24(sp)
 5f2:	0080                	addi	s0,sp,64
 5f4:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f6:	c299                	beqz	a3,5fc <printint+0x16>
 5f8:	0605ce63          	bltz	a1,674 <printint+0x8e>
  neg = 0;
 5fc:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5fe:	fc040313          	addi	t1,s0,-64
  neg = 0;
 602:	869a                	mv	a3,t1
  i = 0;
 604:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 606:	00000817          	auipc	a6,0x0
 60a:	51a80813          	addi	a6,a6,1306 # b20 <digits>
 60e:	88be                	mv	a7,a5
 610:	0017851b          	addiw	a0,a5,1
 614:	87aa                	mv	a5,a0
 616:	02c5f73b          	remuw	a4,a1,a2
 61a:	1702                	slli	a4,a4,0x20
 61c:	9301                	srli	a4,a4,0x20
 61e:	9742                	add	a4,a4,a6
 620:	00074703          	lbu	a4,0(a4)
 624:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 628:	872e                	mv	a4,a1
 62a:	02c5d5bb          	divuw	a1,a1,a2
 62e:	0685                	addi	a3,a3,1
 630:	fcc77fe3          	bgeu	a4,a2,60e <printint+0x28>
  if(neg)
 634:	000e0c63          	beqz	t3,64c <printint+0x66>
    buf[i++] = '-';
 638:	fd050793          	addi	a5,a0,-48
 63c:	00878533          	add	a0,a5,s0
 640:	02d00793          	li	a5,45
 644:	fef50823          	sb	a5,-16(a0)
 648:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 64c:	fff7899b          	addiw	s3,a5,-1
 650:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 654:	fff4c583          	lbu	a1,-1(s1)
 658:	854a                	mv	a0,s2
 65a:	f6fff0ef          	jal	5c8 <putc>
  while(--i >= 0)
 65e:	39fd                	addiw	s3,s3,-1
 660:	14fd                	addi	s1,s1,-1
 662:	fe09d9e3          	bgez	s3,654 <printint+0x6e>
}
 666:	70e2                	ld	ra,56(sp)
 668:	7442                	ld	s0,48(sp)
 66a:	74a2                	ld	s1,40(sp)
 66c:	7902                	ld	s2,32(sp)
 66e:	69e2                	ld	s3,24(sp)
 670:	6121                	addi	sp,sp,64
 672:	8082                	ret
    x = -xx;
 674:	40b005bb          	negw	a1,a1
    neg = 1;
 678:	4e05                	li	t3,1
    x = -xx;
 67a:	b751                	j	5fe <printint+0x18>

000000000000067c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67c:	711d                	addi	sp,sp,-96
 67e:	ec86                	sd	ra,88(sp)
 680:	e8a2                	sd	s0,80(sp)
 682:	e4a6                	sd	s1,72(sp)
 684:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 686:	0005c483          	lbu	s1,0(a1)
 68a:	26048663          	beqz	s1,8f6 <vprintf+0x27a>
 68e:	e0ca                	sd	s2,64(sp)
 690:	fc4e                	sd	s3,56(sp)
 692:	f852                	sd	s4,48(sp)
 694:	f456                	sd	s5,40(sp)
 696:	f05a                	sd	s6,32(sp)
 698:	ec5e                	sd	s7,24(sp)
 69a:	e862                	sd	s8,16(sp)
 69c:	e466                	sd	s9,8(sp)
 69e:	8b2a                	mv	s6,a0
 6a0:	8a2e                	mv	s4,a1
 6a2:	8bb2                	mv	s7,a2
  state = 0;
 6a4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a6:	4901                	li	s2,0
 6a8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6aa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b2:	06c00c93          	li	s9,108
 6b6:	a00d                	j	6d8 <vprintf+0x5c>
        putc(fd, c0);
 6b8:	85a6                	mv	a1,s1
 6ba:	855a                	mv	a0,s6
 6bc:	f0dff0ef          	jal	5c8 <putc>
 6c0:	a019                	j	6c6 <vprintf+0x4a>
    } else if(state == '%'){
 6c2:	03598363          	beq	s3,s5,6e8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6c6:	0019079b          	addiw	a5,s2,1
 6ca:	893e                	mv	s2,a5
 6cc:	873e                	mv	a4,a5
 6ce:	97d2                	add	a5,a5,s4
 6d0:	0007c483          	lbu	s1,0(a5)
 6d4:	20048963          	beqz	s1,8e6 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 6d8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6dc:	fe0993e3          	bnez	s3,6c2 <vprintf+0x46>
      if(c0 == '%'){
 6e0:	fd579ce3          	bne	a5,s5,6b8 <vprintf+0x3c>
        state = '%';
 6e4:	89be                	mv	s3,a5
 6e6:	b7c5                	j	6c6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e8:	00ea06b3          	add	a3,s4,a4
 6ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f2:	c681                	beqz	a3,6fa <vprintf+0x7e>
 6f4:	9752                	add	a4,a4,s4
 6f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6fa:	03878e63          	beq	a5,s8,736 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6fe:	05978863          	beq	a5,s9,74e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 702:	07500713          	li	a4,117
 706:	0ee78263          	beq	a5,a4,7ea <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 70a:	07800713          	li	a4,120
 70e:	12e78463          	beq	a5,a4,836 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	14e78963          	beq	a5,a4,868 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 71a:	07300713          	li	a4,115
 71e:	18e78863          	beq	a5,a4,8ae <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 722:	02500713          	li	a4,37
 726:	04e79463          	bne	a5,a4,76e <vprintf+0xf2>
        putc(fd, '%');
 72a:	85ba                	mv	a1,a4
 72c:	855a                	mv	a0,s6
 72e:	e9bff0ef          	jal	5c8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 732:	4981                	li	s3,0
 734:	bf49                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 736:	008b8493          	addi	s1,s7,8
 73a:	4685                	li	a3,1
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	ea3ff0ef          	jal	5e6 <printint>
 748:	8ba6                	mv	s7,s1
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bfad                	j	6c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 74e:	06400793          	li	a5,100
 752:	02f68963          	beq	a3,a5,784 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 756:	06c00793          	li	a5,108
 75a:	04f68263          	beq	a3,a5,79e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 75e:	07500793          	li	a5,117
 762:	0af68063          	beq	a3,a5,802 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 766:	07800793          	li	a5,120
 76a:	0ef68263          	beq	a3,a5,84e <vprintf+0x1d2>
        putc(fd, '%');
 76e:	02500593          	li	a1,37
 772:	855a                	mv	a0,s6
 774:	e55ff0ef          	jal	5c8 <putc>
        putc(fd, c0);
 778:	85a6                	mv	a1,s1
 77a:	855a                	mv	a0,s6
 77c:	e4dff0ef          	jal	5c8 <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	b791                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 784:	008b8493          	addi	s1,s7,8
 788:	4685                	li	a3,1
 78a:	4629                	li	a2,10
 78c:	000ba583          	lw	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	e55ff0ef          	jal	5e6 <printint>
        i += 1;
 796:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 798:	8ba6                	mv	s7,s1
      state = 0;
 79a:	4981                	li	s3,0
        i += 1;
 79c:	b72d                	j	6c6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 79e:	06400793          	li	a5,100
 7a2:	02f60763          	beq	a2,a5,7d0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a6:	07500793          	li	a5,117
 7aa:	06f60963          	beq	a2,a5,81c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ae:	07800793          	li	a5,120
 7b2:	faf61ee3          	bne	a2,a5,76e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b6:	008b8493          	addi	s1,s7,8
 7ba:	4681                	li	a3,0
 7bc:	4641                	li	a2,16
 7be:	000ba583          	lw	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	e23ff0ef          	jal	5e6 <printint>
        i += 2;
 7c8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ca:	8ba6                	mv	s7,s1
      state = 0;
 7cc:	4981                	li	s3,0
        i += 2;
 7ce:	bde5                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d0:	008b8493          	addi	s1,s7,8
 7d4:	4685                	li	a3,1
 7d6:	4629                	li	a2,10
 7d8:	000ba583          	lw	a1,0(s7)
 7dc:	855a                	mv	a0,s6
 7de:	e09ff0ef          	jal	5e6 <printint>
        i += 2;
 7e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e4:	8ba6                	mv	s7,s1
      state = 0;
 7e6:	4981                	li	s3,0
        i += 2;
 7e8:	bdf9                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ea:	008b8493          	addi	s1,s7,8
 7ee:	4681                	li	a3,0
 7f0:	4629                	li	a2,10
 7f2:	000ba583          	lw	a1,0(s7)
 7f6:	855a                	mv	a0,s6
 7f8:	defff0ef          	jal	5e6 <printint>
 7fc:	8ba6                	mv	s7,s1
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b5d9                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 802:	008b8493          	addi	s1,s7,8
 806:	4681                	li	a3,0
 808:	4629                	li	a2,10
 80a:	000ba583          	lw	a1,0(s7)
 80e:	855a                	mv	a0,s6
 810:	dd7ff0ef          	jal	5e6 <printint>
        i += 1;
 814:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 816:	8ba6                	mv	s7,s1
      state = 0;
 818:	4981                	li	s3,0
        i += 1;
 81a:	b575                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81c:	008b8493          	addi	s1,s7,8
 820:	4681                	li	a3,0
 822:	4629                	li	a2,10
 824:	000ba583          	lw	a1,0(s7)
 828:	855a                	mv	a0,s6
 82a:	dbdff0ef          	jal	5e6 <printint>
        i += 2;
 82e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 830:	8ba6                	mv	s7,s1
      state = 0;
 832:	4981                	li	s3,0
        i += 2;
 834:	bd49                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 836:	008b8493          	addi	s1,s7,8
 83a:	4681                	li	a3,0
 83c:	4641                	li	a2,16
 83e:	000ba583          	lw	a1,0(s7)
 842:	855a                	mv	a0,s6
 844:	da3ff0ef          	jal	5e6 <printint>
 848:	8ba6                	mv	s7,s1
      state = 0;
 84a:	4981                	li	s3,0
 84c:	bdad                	j	6c6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 84e:	008b8493          	addi	s1,s7,8
 852:	4681                	li	a3,0
 854:	4641                	li	a2,16
 856:	000ba583          	lw	a1,0(s7)
 85a:	855a                	mv	a0,s6
 85c:	d8bff0ef          	jal	5e6 <printint>
        i += 1;
 860:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 862:	8ba6                	mv	s7,s1
      state = 0;
 864:	4981                	li	s3,0
        i += 1;
 866:	b585                	j	6c6 <vprintf+0x4a>
 868:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 86a:	008b8d13          	addi	s10,s7,8
 86e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 872:	03000593          	li	a1,48
 876:	855a                	mv	a0,s6
 878:	d51ff0ef          	jal	5c8 <putc>
  putc(fd, 'x');
 87c:	07800593          	li	a1,120
 880:	855a                	mv	a0,s6
 882:	d47ff0ef          	jal	5c8 <putc>
 886:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 888:	00000b97          	auipc	s7,0x0
 88c:	298b8b93          	addi	s7,s7,664 # b20 <digits>
 890:	03c9d793          	srli	a5,s3,0x3c
 894:	97de                	add	a5,a5,s7
 896:	0007c583          	lbu	a1,0(a5)
 89a:	855a                	mv	a0,s6
 89c:	d2dff0ef          	jal	5c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a0:	0992                	slli	s3,s3,0x4
 8a2:	34fd                	addiw	s1,s1,-1
 8a4:	f4f5                	bnez	s1,890 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8a6:	8bea                	mv	s7,s10
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	6d02                	ld	s10,0(sp)
 8ac:	bd29                	j	6c6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ae:	008b8993          	addi	s3,s7,8
 8b2:	000bb483          	ld	s1,0(s7)
 8b6:	cc91                	beqz	s1,8d2 <vprintf+0x256>
        for(; *s; s++)
 8b8:	0004c583          	lbu	a1,0(s1)
 8bc:	c195                	beqz	a1,8e0 <vprintf+0x264>
          putc(fd, *s);
 8be:	855a                	mv	a0,s6
 8c0:	d09ff0ef          	jal	5c8 <putc>
        for(; *s; s++)
 8c4:	0485                	addi	s1,s1,1
 8c6:	0004c583          	lbu	a1,0(s1)
 8ca:	f9f5                	bnez	a1,8be <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8cc:	8bce                	mv	s7,s3
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	bbdd                	j	6c6 <vprintf+0x4a>
          s = "(null)";
 8d2:	00000497          	auipc	s1,0x0
 8d6:	24648493          	addi	s1,s1,582 # b18 <malloc+0x136>
        for(; *s; s++)
 8da:	02800593          	li	a1,40
 8de:	b7c5                	j	8be <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8e0:	8bce                	mv	s7,s3
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b3cd                	j	6c6 <vprintf+0x4a>
 8e6:	6906                	ld	s2,64(sp)
 8e8:	79e2                	ld	s3,56(sp)
 8ea:	7a42                	ld	s4,48(sp)
 8ec:	7aa2                	ld	s5,40(sp)
 8ee:	7b02                	ld	s6,32(sp)
 8f0:	6be2                	ld	s7,24(sp)
 8f2:	6c42                	ld	s8,16(sp)
 8f4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8f6:	60e6                	ld	ra,88(sp)
 8f8:	6446                	ld	s0,80(sp)
 8fa:	64a6                	ld	s1,72(sp)
 8fc:	6125                	addi	sp,sp,96
 8fe:	8082                	ret

0000000000000900 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 900:	715d                	addi	sp,sp,-80
 902:	ec06                	sd	ra,24(sp)
 904:	e822                	sd	s0,16(sp)
 906:	1000                	addi	s0,sp,32
 908:	e010                	sd	a2,0(s0)
 90a:	e414                	sd	a3,8(s0)
 90c:	e818                	sd	a4,16(s0)
 90e:	ec1c                	sd	a5,24(s0)
 910:	03043023          	sd	a6,32(s0)
 914:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	8622                	mv	a2,s0
 91a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 91e:	d5fff0ef          	jal	67c <vprintf>
}
 922:	60e2                	ld	ra,24(sp)
 924:	6442                	ld	s0,16(sp)
 926:	6161                	addi	sp,sp,80
 928:	8082                	ret

000000000000092a <printf>:

void
printf(const char *fmt, ...)
{
 92a:	711d                	addi	sp,sp,-96
 92c:	ec06                	sd	ra,24(sp)
 92e:	e822                	sd	s0,16(sp)
 930:	1000                	addi	s0,sp,32
 932:	e40c                	sd	a1,8(s0)
 934:	e810                	sd	a2,16(s0)
 936:	ec14                	sd	a3,24(s0)
 938:	f018                	sd	a4,32(s0)
 93a:	f41c                	sd	a5,40(s0)
 93c:	03043823          	sd	a6,48(s0)
 940:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 944:	00840613          	addi	a2,s0,8
 948:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 94c:	85aa                	mv	a1,a0
 94e:	4505                	li	a0,1
 950:	d2dff0ef          	jal	67c <vprintf>
}
 954:	60e2                	ld	ra,24(sp)
 956:	6442                	ld	s0,16(sp)
 958:	6125                	addi	sp,sp,96
 95a:	8082                	ret

000000000000095c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95c:	1141                	addi	sp,sp,-16
 95e:	e406                	sd	ra,8(sp)
 960:	e022                	sd	s0,0(sp)
 962:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 964:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	00000797          	auipc	a5,0x0
 96c:	6987b783          	ld	a5,1688(a5) # 1000 <freep>
 970:	a02d                	j	99a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 972:	4618                	lw	a4,8(a2)
 974:	9f2d                	addw	a4,a4,a1
 976:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97a:	6398                	ld	a4,0(a5)
 97c:	6310                	ld	a2,0(a4)
 97e:	a83d                	j	9bc <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 980:	ff852703          	lw	a4,-8(a0)
 984:	9f31                	addw	a4,a4,a2
 986:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 988:	ff053683          	ld	a3,-16(a0)
 98c:	a091                	j	9d0 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98e:	6398                	ld	a4,0(a5)
 990:	00e7e463          	bltu	a5,a4,998 <free+0x3c>
 994:	00e6ea63          	bltu	a3,a4,9a8 <free+0x4c>
{
 998:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99a:	fed7fae3          	bgeu	a5,a3,98e <free+0x32>
 99e:	6398                	ld	a4,0(a5)
 9a0:	00e6e463          	bltu	a3,a4,9a8 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a4:	fee7eae3          	bltu	a5,a4,998 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9a8:	ff852583          	lw	a1,-8(a0)
 9ac:	6390                	ld	a2,0(a5)
 9ae:	02059813          	slli	a6,a1,0x20
 9b2:	01c85713          	srli	a4,a6,0x1c
 9b6:	9736                	add	a4,a4,a3
 9b8:	fae60de3          	beq	a2,a4,972 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c0:	4790                	lw	a2,8(a5)
 9c2:	02061593          	slli	a1,a2,0x20
 9c6:	01c5d713          	srli	a4,a1,0x1c
 9ca:	973e                	add	a4,a4,a5
 9cc:	fae68ae3          	beq	a3,a4,980 <free+0x24>
    p->s.ptr = bp->s.ptr;
 9d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9d2:	00000717          	auipc	a4,0x0
 9d6:	62f73723          	sd	a5,1582(a4) # 1000 <freep>
}
 9da:	60a2                	ld	ra,8(sp)
 9dc:	6402                	ld	s0,0(sp)
 9de:	0141                	addi	sp,sp,16
 9e0:	8082                	ret

00000000000009e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e2:	7139                	addi	sp,sp,-64
 9e4:	fc06                	sd	ra,56(sp)
 9e6:	f822                	sd	s0,48(sp)
 9e8:	f04a                	sd	s2,32(sp)
 9ea:	ec4e                	sd	s3,24(sp)
 9ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ee:	02051993          	slli	s3,a0,0x20
 9f2:	0209d993          	srli	s3,s3,0x20
 9f6:	09bd                	addi	s3,s3,15
 9f8:	0049d993          	srli	s3,s3,0x4
 9fc:	2985                	addiw	s3,s3,1
 9fe:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a00:	00000517          	auipc	a0,0x0
 a04:	60053503          	ld	a0,1536(a0) # 1000 <freep>
 a08:	c905                	beqz	a0,a38 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0c:	4798                	lw	a4,8(a5)
 a0e:	09377663          	bgeu	a4,s3,a9a <malloc+0xb8>
 a12:	f426                	sd	s1,40(sp)
 a14:	e852                	sd	s4,16(sp)
 a16:	e456                	sd	s5,8(sp)
 a18:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a1a:	8a4e                	mv	s4,s3
 a1c:	6705                	lui	a4,0x1
 a1e:	00e9f363          	bgeu	s3,a4,a24 <malloc+0x42>
 a22:	6a05                	lui	s4,0x1
 a24:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a28:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a2c:	00000497          	auipc	s1,0x0
 a30:	5d448493          	addi	s1,s1,1492 # 1000 <freep>
  if(p == (char*)-1)
 a34:	5afd                	li	s5,-1
 a36:	a83d                	j	a74 <malloc+0x92>
 a38:	f426                	sd	s1,40(sp)
 a3a:	e852                	sd	s4,16(sp)
 a3c:	e456                	sd	s5,8(sp)
 a3e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a40:	00001797          	auipc	a5,0x1
 a44:	9d078793          	addi	a5,a5,-1584 # 1410 <base>
 a48:	00000717          	auipc	a4,0x0
 a4c:	5af73c23          	sd	a5,1464(a4) # 1000 <freep>
 a50:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a52:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a56:	b7d1                	j	a1a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a58:	6398                	ld	a4,0(a5)
 a5a:	e118                	sd	a4,0(a0)
 a5c:	a899                	j	ab2 <malloc+0xd0>
  hp->s.size = nu;
 a5e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a62:	0541                	addi	a0,a0,16
 a64:	ef9ff0ef          	jal	95c <free>
  return freep;
 a68:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a6a:	c125                	beqz	a0,aca <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a6e:	4798                	lw	a4,8(a5)
 a70:	03277163          	bgeu	a4,s2,a92 <malloc+0xb0>
    if(p == freep)
 a74:	6098                	ld	a4,0(s1)
 a76:	853e                	mv	a0,a5
 a78:	fef71ae3          	bne	a4,a5,a6c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a7c:	8552                	mv	a0,s4
 a7e:	b0bff0ef          	jal	588 <sbrk>
  if(p == (char*)-1)
 a82:	fd551ee3          	bne	a0,s5,a5e <malloc+0x7c>
        return 0;
 a86:	4501                	li	a0,0
 a88:	74a2                	ld	s1,40(sp)
 a8a:	6a42                	ld	s4,16(sp)
 a8c:	6aa2                	ld	s5,8(sp)
 a8e:	6b02                	ld	s6,0(sp)
 a90:	a03d                	j	abe <malloc+0xdc>
 a92:	74a2                	ld	s1,40(sp)
 a94:	6a42                	ld	s4,16(sp)
 a96:	6aa2                	ld	s5,8(sp)
 a98:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a9a:	fae90fe3          	beq	s2,a4,a58 <malloc+0x76>
        p->s.size -= nunits;
 a9e:	4137073b          	subw	a4,a4,s3
 aa2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aa4:	02071693          	slli	a3,a4,0x20
 aa8:	01c6d713          	srli	a4,a3,0x1c
 aac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ab2:	00000717          	auipc	a4,0x0
 ab6:	54a73723          	sd	a0,1358(a4) # 1000 <freep>
      return (void*)(p + 1);
 aba:	01078513          	addi	a0,a5,16
  }
}
 abe:	70e2                	ld	ra,56(sp)
 ac0:	7442                	ld	s0,48(sp)
 ac2:	7902                	ld	s2,32(sp)
 ac4:	69e2                	ld	s3,24(sp)
 ac6:	6121                	addi	sp,sp,64
 ac8:	8082                	ret
 aca:	74a2                	ld	s1,40(sp)
 acc:	6a42                	ld	s4,16(sp)
 ace:	6aa2                	ld	s5,8(sp)
 ad0:	6b02                	ld	s6,0(sp)
 ad2:	b7f5                	j	abe <malloc+0xdc>
