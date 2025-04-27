
user/_compress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <compress_file>:
#include "user/user.h"
#include "kernel/fcntl.h"

#define BLOCK_SIZE 512

void compress_file(int src_fd, int dest_fd) {
   0:	d7010113          	addi	sp,sp,-656
   4:	28113423          	sd	ra,648(sp)
   8:	28813023          	sd	s0,640(sp)
   c:	26913c23          	sd	s1,632(sp)
  10:	27213823          	sd	s2,624(sp)
  14:	27313423          	sd	s3,616(sp)
  18:	27413023          	sd	s4,608(sp)
  1c:	25513c23          	sd	s5,600(sp)
  20:	25613823          	sd	s6,592(sp)
  24:	25713423          	sd	s7,584(sp)
  28:	25813023          	sd	s8,576(sp)
  2c:	23913c23          	sd	s9,568(sp)
  30:	23a13823          	sd	s10,560(sp)
  34:	23b13423          	sd	s11,552(sp)
  38:	0d00                	addi	s0,sp,656
  3a:	d6a43c23          	sd	a0,-648(s0)
  3e:	8c2e                	mv	s8,a1
    char buf[BLOCK_SIZE];
    char curr, prev = 0;
    int count = 0;
  40:	4901                	li	s2,0
    char curr, prev = 0;
  42:	4981                	li	s3,0
    int n;
    char output[2];

    while ((n = read(src_fd, buf, BLOCK_SIZE)) > 0) {
  44:	d9040d93          	addi	s11,s0,-624
                    output[0] = prev;
                    output[1] = '0' + count;
                    write(dest_fd, output, 2);
                }
                prev = curr;
                count = 1;
  48:	4a85                	li	s5,1
                    write(dest_fd, output, 2);
  4a:	d8840d13          	addi	s10,s0,-632
                if (count > 9) count = 9; // Limit to single digit
  4e:	4ba5                	li	s7,9
    while ((n = read(src_fd, buf, BLOCK_SIZE)) > 0) {
  50:	20000613          	li	a2,512
  54:	85ee                	mv	a1,s11
  56:	d7843503          	ld	a0,-648(s0)
  5a:	400000ef          	jal	45a <read>
  5e:	04a05963          	blez	a0,b0 <compress_file+0xb0>
  62:	d9040493          	addi	s1,s0,-624
  66:	00950a33          	add	s4,a0,s1
                    write(dest_fd, output, 2);
  6a:	4b09                	li	s6,2
                if (count > 9) count = 9; // Limit to single digit
  6c:	4ca5                	li	s9,9
  6e:	a819                	j	84 <compress_file+0x84>
                count++;
  70:	0019079b          	addiw	a5,s2,1
  74:	893e                	mv	s2,a5
                if (count > 9) count = 9; // Limit to single digit
  76:	00fbd363          	bge	s7,a5,7c <compress_file+0x7c>
  7a:	8966                	mv	s2,s9
  7c:	2901                	sext.w	s2,s2
        for (int i = 0; i < n; i++) {
  7e:	0485                	addi	s1,s1,1
  80:	fd4488e3          	beq	s1,s4,50 <compress_file+0x50>
            curr = buf[i];
  84:	87ce                	mv	a5,s3
  86:	0004c983          	lbu	s3,0(s1)
            if (curr == prev) {
  8a:	fef983e3          	beq	s3,a5,70 <compress_file+0x70>
                if (count > 0) {
  8e:	01204463          	bgtz	s2,96 <compress_file+0x96>
                count = 1;
  92:	8956                	mv	s2,s5
  94:	b7ed                	j	7e <compress_file+0x7e>
                    output[0] = prev;
  96:	d8f40423          	sb	a5,-632(s0)
                    output[1] = '0' + count;
  9a:	0309091b          	addiw	s2,s2,48
  9e:	d92404a3          	sb	s2,-631(s0)
                    write(dest_fd, output, 2);
  a2:	865a                	mv	a2,s6
  a4:	85ea                	mv	a1,s10
  a6:	8562                	mv	a0,s8
  a8:	3ba000ef          	jal	462 <write>
                count = 1;
  ac:	8956                	mv	s2,s5
  ae:	bfc1                	j	7e <compress_file+0x7e>
            }
        }
    }

    // Write final pair
    if (count > 0) {
  b0:	03204f63          	bgtz	s2,ee <compress_file+0xee>
        output[0] = prev;
        output[1] = '0' + count;
        write(dest_fd, output, 2);
    }
}
  b4:	28813083          	ld	ra,648(sp)
  b8:	28013403          	ld	s0,640(sp)
  bc:	27813483          	ld	s1,632(sp)
  c0:	27013903          	ld	s2,624(sp)
  c4:	26813983          	ld	s3,616(sp)
  c8:	26013a03          	ld	s4,608(sp)
  cc:	25813a83          	ld	s5,600(sp)
  d0:	25013b03          	ld	s6,592(sp)
  d4:	24813b83          	ld	s7,584(sp)
  d8:	24013c03          	ld	s8,576(sp)
  dc:	23813c83          	ld	s9,568(sp)
  e0:	23013d03          	ld	s10,560(sp)
  e4:	22813d83          	ld	s11,552(sp)
  e8:	29010113          	addi	sp,sp,656
  ec:	8082                	ret
        output[0] = prev;
  ee:	d9340423          	sb	s3,-632(s0)
        output[1] = '0' + count;
  f2:	0309091b          	addiw	s2,s2,48
  f6:	d92404a3          	sb	s2,-631(s0)
        write(dest_fd, output, 2);
  fa:	4609                	li	a2,2
  fc:	d8840593          	addi	a1,s0,-632
 100:	8562                	mv	a0,s8
 102:	360000ef          	jal	462 <write>
}
 106:	b77d                	j	b4 <compress_file+0xb4>

0000000000000108 <main>:

int main(int argc, char *argv[]) {
 108:	7179                	addi	sp,sp,-48
 10a:	f406                	sd	ra,40(sp)
 10c:	f022                	sd	s0,32(sp)
 10e:	ec26                	sd	s1,24(sp)
 110:	1800                	addi	s0,sp,48
 112:	84ae                	mv	s1,a1
    int src_fd, dest_fd;

    if (argc != 3) {
 114:	478d                	li	a5,3
 116:	00f50f63          	beq	a0,a5,134 <main+0x2c>
 11a:	e84a                	sd	s2,16(sp)
 11c:	e44e                	sd	s3,8(sp)
        fprintf(2, "Usage: %s <input> <output>\n", argv[0]);
 11e:	6190                	ld	a2,0(a1)
 120:	00001597          	auipc	a1,0x1
 124:	90058593          	addi	a1,a1,-1792 # a20 <malloc+0xfc>
 128:	4509                	li	a0,2
 12a:	718000ef          	jal	842 <fprintf>
        exit(1);
 12e:	4505                	li	a0,1
 130:	312000ef          	jal	442 <exit>
 134:	e84a                	sd	s2,16(sp)
    }

    // Open input file
    if ((src_fd = open(argv[1], O_RDONLY)) < 0) {
 136:	4581                	li	a1,0
 138:	6488                	ld	a0,8(s1)
 13a:	348000ef          	jal	482 <open>
 13e:	892a                	mv	s2,a0
 140:	02054863          	bltz	a0,170 <main+0x68>
 144:	e44e                	sd	s3,8(sp)
        fprintf(2, "compress: cannot open %s\n", argv[1]);
        exit(1);
    }

    // Create output file
    if ((dest_fd = open(argv[2], O_CREATE | O_WRONLY)) < 0) {
 146:	20100593          	li	a1,513
 14a:	6888                	ld	a0,16(s1)
 14c:	336000ef          	jal	482 <open>
 150:	89aa                	mv	s3,a0
 152:	02054b63          	bltz	a0,188 <main+0x80>
        fprintf(2, "compress: cannot create %s\n", argv[2]);
        close(src_fd);
        exit(1);
    }

    compress_file(src_fd, dest_fd);
 156:	85aa                	mv	a1,a0
 158:	854a                	mv	a0,s2
 15a:	ea7ff0ef          	jal	0 <compress_file>

    close(src_fd);
 15e:	854a                	mv	a0,s2
 160:	30a000ef          	jal	46a <close>
    close(dest_fd);
 164:	854e                	mv	a0,s3
 166:	304000ef          	jal	46a <close>
    exit(0);
 16a:	4501                	li	a0,0
 16c:	2d6000ef          	jal	442 <exit>
 170:	e44e                	sd	s3,8(sp)
        fprintf(2, "compress: cannot open %s\n", argv[1]);
 172:	6490                	ld	a2,8(s1)
 174:	00001597          	auipc	a1,0x1
 178:	8cc58593          	addi	a1,a1,-1844 # a40 <malloc+0x11c>
 17c:	4509                	li	a0,2
 17e:	6c4000ef          	jal	842 <fprintf>
        exit(1);
 182:	4505                	li	a0,1
 184:	2be000ef          	jal	442 <exit>
        fprintf(2, "compress: cannot create %s\n", argv[2]);
 188:	6890                	ld	a2,16(s1)
 18a:	00001597          	auipc	a1,0x1
 18e:	8d658593          	addi	a1,a1,-1834 # a60 <malloc+0x13c>
 192:	4509                	li	a0,2
 194:	6ae000ef          	jal	842 <fprintf>
        close(src_fd);
 198:	854a                	mv	a0,s2
 19a:	2d0000ef          	jal	46a <close>
        exit(1);
 19e:	4505                	li	a0,1
 1a0:	2a2000ef          	jal	442 <exit>

00000000000001a4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e406                	sd	ra,8(sp)
 1a8:	e022                	sd	s0,0(sp)
 1aa:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ac:	f5dff0ef          	jal	108 <main>
  exit(0);
 1b0:	4501                	li	a0,0
 1b2:	290000ef          	jal	442 <exit>

00000000000001b6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1be:	87aa                	mv	a5,a0
 1c0:	0585                	addi	a1,a1,1
 1c2:	0785                	addi	a5,a5,1
 1c4:	fff5c703          	lbu	a4,-1(a1)
 1c8:	fee78fa3          	sb	a4,-1(a5)
 1cc:	fb75                	bnez	a4,1c0 <strcpy+0xa>
    ;
  return os;
}
 1ce:	60a2                	ld	ra,8(sp)
 1d0:	6402                	ld	s0,0(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret

00000000000001d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e406                	sd	ra,8(sp)
 1da:	e022                	sd	s0,0(sp)
 1dc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cb91                	beqz	a5,1f6 <strcmp+0x20>
 1e4:	0005c703          	lbu	a4,0(a1)
 1e8:	00f71763          	bne	a4,a5,1f6 <strcmp+0x20>
    p++, q++;
 1ec:	0505                	addi	a0,a0,1
 1ee:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f0:	00054783          	lbu	a5,0(a0)
 1f4:	fbe5                	bnez	a5,1e4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1f6:	0005c503          	lbu	a0,0(a1)
}
 1fa:	40a7853b          	subw	a0,a5,a0
 1fe:	60a2                	ld	ra,8(sp)
 200:	6402                	ld	s0,0(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <strlen>:

uint
strlen(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e406                	sd	ra,8(sp)
 20a:	e022                	sd	s0,0(sp)
 20c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 20e:	00054783          	lbu	a5,0(a0)
 212:	cf99                	beqz	a5,230 <strlen+0x2a>
 214:	0505                	addi	a0,a0,1
 216:	87aa                	mv	a5,a0
 218:	86be                	mv	a3,a5
 21a:	0785                	addi	a5,a5,1
 21c:	fff7c703          	lbu	a4,-1(a5)
 220:	ff65                	bnez	a4,218 <strlen+0x12>
 222:	40a6853b          	subw	a0,a3,a0
 226:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 228:	60a2                	ld	ra,8(sp)
 22a:	6402                	ld	s0,0(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  for(n = 0; s[n]; n++)
 230:	4501                	li	a0,0
 232:	bfdd                	j	228 <strlen+0x22>

0000000000000234 <memset>:

void*
memset(void *dst, int c, uint n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e406                	sd	ra,8(sp)
 238:	e022                	sd	s0,0(sp)
 23a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 23c:	ca19                	beqz	a2,252 <memset+0x1e>
 23e:	87aa                	mv	a5,a0
 240:	1602                	slli	a2,a2,0x20
 242:	9201                	srli	a2,a2,0x20
 244:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 248:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 24c:	0785                	addi	a5,a5,1
 24e:	fee79de3          	bne	a5,a4,248 <memset+0x14>
  }
  return dst;
}
 252:	60a2                	ld	ra,8(sp)
 254:	6402                	ld	s0,0(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret

000000000000025a <strchr>:

char*
strchr(const char *s, char c)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  for(; *s; s++)
 262:	00054783          	lbu	a5,0(a0)
 266:	cf81                	beqz	a5,27e <strchr+0x24>
    if(*s == c)
 268:	00f58763          	beq	a1,a5,276 <strchr+0x1c>
  for(; *s; s++)
 26c:	0505                	addi	a0,a0,1
 26e:	00054783          	lbu	a5,0(a0)
 272:	fbfd                	bnez	a5,268 <strchr+0xe>
      return (char*)s;
  return 0;
 274:	4501                	li	a0,0
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  return 0;
 27e:	4501                	li	a0,0
 280:	bfdd                	j	276 <strchr+0x1c>

0000000000000282 <gets>:

char*
gets(char *buf, int max)
{
 282:	7159                	addi	sp,sp,-112
 284:	f486                	sd	ra,104(sp)
 286:	f0a2                	sd	s0,96(sp)
 288:	eca6                	sd	s1,88(sp)
 28a:	e8ca                	sd	s2,80(sp)
 28c:	e4ce                	sd	s3,72(sp)
 28e:	e0d2                	sd	s4,64(sp)
 290:	fc56                	sd	s5,56(sp)
 292:	f85a                	sd	s6,48(sp)
 294:	f45e                	sd	s7,40(sp)
 296:	f062                	sd	s8,32(sp)
 298:	ec66                	sd	s9,24(sp)
 29a:	e86a                	sd	s10,16(sp)
 29c:	1880                	addi	s0,sp,112
 29e:	8caa                	mv	s9,a0
 2a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a2:	892a                	mv	s2,a0
 2a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2a6:	f9f40b13          	addi	s6,s0,-97
 2aa:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ac:	4ba9                	li	s7,10
 2ae:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2b0:	8d26                	mv	s10,s1
 2b2:	0014899b          	addiw	s3,s1,1
 2b6:	84ce                	mv	s1,s3
 2b8:	0349d563          	bge	s3,s4,2e2 <gets+0x60>
    cc = read(0, &c, 1);
 2bc:	8656                	mv	a2,s5
 2be:	85da                	mv	a1,s6
 2c0:	4501                	li	a0,0
 2c2:	198000ef          	jal	45a <read>
    if(cc < 1)
 2c6:	00a05e63          	blez	a0,2e2 <gets+0x60>
    buf[i++] = c;
 2ca:	f9f44783          	lbu	a5,-97(s0)
 2ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d2:	01778763          	beq	a5,s7,2e0 <gets+0x5e>
 2d6:	0905                	addi	s2,s2,1
 2d8:	fd879ce3          	bne	a5,s8,2b0 <gets+0x2e>
    buf[i++] = c;
 2dc:	8d4e                	mv	s10,s3
 2de:	a011                	j	2e2 <gets+0x60>
 2e0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 2e2:	9d66                	add	s10,s10,s9
 2e4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2e8:	8566                	mv	a0,s9
 2ea:	70a6                	ld	ra,104(sp)
 2ec:	7406                	ld	s0,96(sp)
 2ee:	64e6                	ld	s1,88(sp)
 2f0:	6946                	ld	s2,80(sp)
 2f2:	69a6                	ld	s3,72(sp)
 2f4:	6a06                	ld	s4,64(sp)
 2f6:	7ae2                	ld	s5,56(sp)
 2f8:	7b42                	ld	s6,48(sp)
 2fa:	7ba2                	ld	s7,40(sp)
 2fc:	7c02                	ld	s8,32(sp)
 2fe:	6ce2                	ld	s9,24(sp)
 300:	6d42                	ld	s10,16(sp)
 302:	6165                	addi	sp,sp,112
 304:	8082                	ret

0000000000000306 <stat>:

int
stat(const char *n, struct stat *st)
{
 306:	1101                	addi	sp,sp,-32
 308:	ec06                	sd	ra,24(sp)
 30a:	e822                	sd	s0,16(sp)
 30c:	e04a                	sd	s2,0(sp)
 30e:	1000                	addi	s0,sp,32
 310:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 312:	4581                	li	a1,0
 314:	16e000ef          	jal	482 <open>
  if(fd < 0)
 318:	02054263          	bltz	a0,33c <stat+0x36>
 31c:	e426                	sd	s1,8(sp)
 31e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 320:	85ca                	mv	a1,s2
 322:	178000ef          	jal	49a <fstat>
 326:	892a                	mv	s2,a0
  close(fd);
 328:	8526                	mv	a0,s1
 32a:	140000ef          	jal	46a <close>
  return r;
 32e:	64a2                	ld	s1,8(sp)
}
 330:	854a                	mv	a0,s2
 332:	60e2                	ld	ra,24(sp)
 334:	6442                	ld	s0,16(sp)
 336:	6902                	ld	s2,0(sp)
 338:	6105                	addi	sp,sp,32
 33a:	8082                	ret
    return -1;
 33c:	597d                	li	s2,-1
 33e:	bfcd                	j	330 <stat+0x2a>

0000000000000340 <atoi>:

int
atoi(const char *s)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 348:	00054683          	lbu	a3,0(a0)
 34c:	fd06879b          	addiw	a5,a3,-48
 350:	0ff7f793          	zext.b	a5,a5
 354:	4625                	li	a2,9
 356:	02f66963          	bltu	a2,a5,388 <atoi+0x48>
 35a:	872a                	mv	a4,a0
  n = 0;
 35c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 35e:	0705                	addi	a4,a4,1
 360:	0025179b          	slliw	a5,a0,0x2
 364:	9fa9                	addw	a5,a5,a0
 366:	0017979b          	slliw	a5,a5,0x1
 36a:	9fb5                	addw	a5,a5,a3
 36c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 370:	00074683          	lbu	a3,0(a4)
 374:	fd06879b          	addiw	a5,a3,-48
 378:	0ff7f793          	zext.b	a5,a5
 37c:	fef671e3          	bgeu	a2,a5,35e <atoi+0x1e>
  return n;
}
 380:	60a2                	ld	ra,8(sp)
 382:	6402                	ld	s0,0(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
  n = 0;
 388:	4501                	li	a0,0
 38a:	bfdd                	j	380 <atoi+0x40>

000000000000038c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e406                	sd	ra,8(sp)
 390:	e022                	sd	s0,0(sp)
 392:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 394:	02b57563          	bgeu	a0,a1,3be <memmove+0x32>
    while(n-- > 0)
 398:	00c05f63          	blez	a2,3b6 <memmove+0x2a>
 39c:	1602                	slli	a2,a2,0x20
 39e:	9201                	srli	a2,a2,0x20
 3a0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3a4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3a6:	0585                	addi	a1,a1,1
 3a8:	0705                	addi	a4,a4,1
 3aa:	fff5c683          	lbu	a3,-1(a1)
 3ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b2:	fee79ae3          	bne	a5,a4,3a6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret
    dst += n;
 3be:	00c50733          	add	a4,a0,a2
    src += n;
 3c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3c4:	fec059e3          	blez	a2,3b6 <memmove+0x2a>
 3c8:	fff6079b          	addiw	a5,a2,-1
 3cc:	1782                	slli	a5,a5,0x20
 3ce:	9381                	srli	a5,a5,0x20
 3d0:	fff7c793          	not	a5,a5
 3d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3d6:	15fd                	addi	a1,a1,-1
 3d8:	177d                	addi	a4,a4,-1
 3da:	0005c683          	lbu	a3,0(a1)
 3de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e2:	fef71ae3          	bne	a4,a5,3d6 <memmove+0x4a>
 3e6:	bfc1                	j	3b6 <memmove+0x2a>

00000000000003e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f0:	ca0d                	beqz	a2,422 <memcmp+0x3a>
 3f2:	fff6069b          	addiw	a3,a2,-1
 3f6:	1682                	slli	a3,a3,0x20
 3f8:	9281                	srli	a3,a3,0x20
 3fa:	0685                	addi	a3,a3,1
 3fc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3fe:	00054783          	lbu	a5,0(a0)
 402:	0005c703          	lbu	a4,0(a1)
 406:	00e79863          	bne	a5,a4,416 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 40a:	0505                	addi	a0,a0,1
    p2++;
 40c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 40e:	fed518e3          	bne	a0,a3,3fe <memcmp+0x16>
  }
  return 0;
 412:	4501                	li	a0,0
 414:	a019                	j	41a <memcmp+0x32>
      return *p1 - *p2;
 416:	40e7853b          	subw	a0,a5,a4
}
 41a:	60a2                	ld	ra,8(sp)
 41c:	6402                	ld	s0,0(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  return 0;
 422:	4501                	li	a0,0
 424:	bfdd                	j	41a <memcmp+0x32>

0000000000000426 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 42e:	f5fff0ef          	jal	38c <memmove>
}
 432:	60a2                	ld	ra,8(sp)
 434:	6402                	ld	s0,0(sp)
 436:	0141                	addi	sp,sp,16
 438:	8082                	ret

000000000000043a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43a:	4885                	li	a7,1
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <exit>:
.global exit
exit:
 li a7, SYS_exit
 442:	4889                	li	a7,2
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <wait>:
.global wait
wait:
 li a7, SYS_wait
 44a:	488d                	li	a7,3
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 452:	4891                	li	a7,4
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <read>:
.global read
read:
 li a7, SYS_read
 45a:	4895                	li	a7,5
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <write>:
.global write
write:
 li a7, SYS_write
 462:	48c1                	li	a7,16
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <close>:
.global close
close:
 li a7, SYS_close
 46a:	48d5                	li	a7,21
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <kill>:
.global kill
kill:
 li a7, SYS_kill
 472:	4899                	li	a7,6
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <exec>:
.global exec
exec:
 li a7, SYS_exec
 47a:	489d                	li	a7,7
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <open>:
.global open
open:
 li a7, SYS_open
 482:	48bd                	li	a7,15
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48a:	48c5                	li	a7,17
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 492:	48c9                	li	a7,18
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49a:	48a1                	li	a7,8
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <link>:
.global link
link:
 li a7, SYS_link
 4a2:	48cd                	li	a7,19
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4aa:	48d1                	li	a7,20
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b2:	48a5                	li	a7,9
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ba:	48a9                	li	a7,10
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c2:	48ad                	li	a7,11
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ca:	48b1                	li	a7,12
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d2:	48b5                	li	a7,13
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4da:	48b9                	li	a7,14
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 4e2:	48d9                	li	a7,22
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <ps>:
.global ps
ps:
 li a7, SYS_ps
 4ea:	48dd                	li	a7,23
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 4f2:	48e1                	li	a7,24
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 4fa:	48e5                	li	a7,25
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 502:	48e9                	li	a7,26
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 50a:	1101                	addi	sp,sp,-32
 50c:	ec06                	sd	ra,24(sp)
 50e:	e822                	sd	s0,16(sp)
 510:	1000                	addi	s0,sp,32
 512:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 516:	4605                	li	a2,1
 518:	fef40593          	addi	a1,s0,-17
 51c:	f47ff0ef          	jal	462 <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	7139                	addi	sp,sp,-64
 52a:	fc06                	sd	ra,56(sp)
 52c:	f822                	sd	s0,48(sp)
 52e:	f426                	sd	s1,40(sp)
 530:	f04a                	sd	s2,32(sp)
 532:	ec4e                	sd	s3,24(sp)
 534:	0080                	addi	s0,sp,64
 536:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 538:	c299                	beqz	a3,53e <printint+0x16>
 53a:	0605ce63          	bltz	a1,5b6 <printint+0x8e>
  neg = 0;
 53e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 540:	fc040313          	addi	t1,s0,-64
  neg = 0;
 544:	869a                	mv	a3,t1
  i = 0;
 546:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 548:	00000817          	auipc	a6,0x0
 54c:	54080813          	addi	a6,a6,1344 # a88 <digits>
 550:	88be                	mv	a7,a5
 552:	0017851b          	addiw	a0,a5,1
 556:	87aa                	mv	a5,a0
 558:	02c5f73b          	remuw	a4,a1,a2
 55c:	1702                	slli	a4,a4,0x20
 55e:	9301                	srli	a4,a4,0x20
 560:	9742                	add	a4,a4,a6
 562:	00074703          	lbu	a4,0(a4)
 566:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 56a:	872e                	mv	a4,a1
 56c:	02c5d5bb          	divuw	a1,a1,a2
 570:	0685                	addi	a3,a3,1
 572:	fcc77fe3          	bgeu	a4,a2,550 <printint+0x28>
  if(neg)
 576:	000e0c63          	beqz	t3,58e <printint+0x66>
    buf[i++] = '-';
 57a:	fd050793          	addi	a5,a0,-48
 57e:	00878533          	add	a0,a5,s0
 582:	02d00793          	li	a5,45
 586:	fef50823          	sb	a5,-16(a0)
 58a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 58e:	fff7899b          	addiw	s3,a5,-1
 592:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 596:	fff4c583          	lbu	a1,-1(s1)
 59a:	854a                	mv	a0,s2
 59c:	f6fff0ef          	jal	50a <putc>
  while(--i >= 0)
 5a0:	39fd                	addiw	s3,s3,-1
 5a2:	14fd                	addi	s1,s1,-1
 5a4:	fe09d9e3          	bgez	s3,596 <printint+0x6e>
}
 5a8:	70e2                	ld	ra,56(sp)
 5aa:	7442                	ld	s0,48(sp)
 5ac:	74a2                	ld	s1,40(sp)
 5ae:	7902                	ld	s2,32(sp)
 5b0:	69e2                	ld	s3,24(sp)
 5b2:	6121                	addi	sp,sp,64
 5b4:	8082                	ret
    x = -xx;
 5b6:	40b005bb          	negw	a1,a1
    neg = 1;
 5ba:	4e05                	li	t3,1
    x = -xx;
 5bc:	b751                	j	540 <printint+0x18>

00000000000005be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5be:	711d                	addi	sp,sp,-96
 5c0:	ec86                	sd	ra,88(sp)
 5c2:	e8a2                	sd	s0,80(sp)
 5c4:	e4a6                	sd	s1,72(sp)
 5c6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c8:	0005c483          	lbu	s1,0(a1)
 5cc:	26048663          	beqz	s1,838 <vprintf+0x27a>
 5d0:	e0ca                	sd	s2,64(sp)
 5d2:	fc4e                	sd	s3,56(sp)
 5d4:	f852                	sd	s4,48(sp)
 5d6:	f456                	sd	s5,40(sp)
 5d8:	f05a                	sd	s6,32(sp)
 5da:	ec5e                	sd	s7,24(sp)
 5dc:	e862                	sd	s8,16(sp)
 5de:	e466                	sd	s9,8(sp)
 5e0:	8b2a                	mv	s6,a0
 5e2:	8a2e                	mv	s4,a1
 5e4:	8bb2                	mv	s7,a2
  state = 0;
 5e6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5e8:	4901                	li	s2,0
 5ea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5f4:	06c00c93          	li	s9,108
 5f8:	a00d                	j	61a <vprintf+0x5c>
        putc(fd, c0);
 5fa:	85a6                	mv	a1,s1
 5fc:	855a                	mv	a0,s6
 5fe:	f0dff0ef          	jal	50a <putc>
 602:	a019                	j	608 <vprintf+0x4a>
    } else if(state == '%'){
 604:	03598363          	beq	s3,s5,62a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 608:	0019079b          	addiw	a5,s2,1
 60c:	893e                	mv	s2,a5
 60e:	873e                	mv	a4,a5
 610:	97d2                	add	a5,a5,s4
 612:	0007c483          	lbu	s1,0(a5)
 616:	20048963          	beqz	s1,828 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 61a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 61e:	fe0993e3          	bnez	s3,604 <vprintf+0x46>
      if(c0 == '%'){
 622:	fd579ce3          	bne	a5,s5,5fa <vprintf+0x3c>
        state = '%';
 626:	89be                	mv	s3,a5
 628:	b7c5                	j	608 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 62a:	00ea06b3          	add	a3,s4,a4
 62e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 632:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 634:	c681                	beqz	a3,63c <vprintf+0x7e>
 636:	9752                	add	a4,a4,s4
 638:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 63c:	03878e63          	beq	a5,s8,678 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 640:	05978863          	beq	a5,s9,690 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 644:	07500713          	li	a4,117
 648:	0ee78263          	beq	a5,a4,72c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 64c:	07800713          	li	a4,120
 650:	12e78463          	beq	a5,a4,778 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 654:	07000713          	li	a4,112
 658:	14e78963          	beq	a5,a4,7aa <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 65c:	07300713          	li	a4,115
 660:	18e78863          	beq	a5,a4,7f0 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 664:	02500713          	li	a4,37
 668:	04e79463          	bne	a5,a4,6b0 <vprintf+0xf2>
        putc(fd, '%');
 66c:	85ba                	mv	a1,a4
 66e:	855a                	mv	a0,s6
 670:	e9bff0ef          	jal	50a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 674:	4981                	li	s3,0
 676:	bf49                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 678:	008b8493          	addi	s1,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	ea3ff0ef          	jal	528 <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bfad                	j	608 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 690:	06400793          	li	a5,100
 694:	02f68963          	beq	a3,a5,6c6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 698:	06c00793          	li	a5,108
 69c:	04f68263          	beq	a3,a5,6e0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6a0:	07500793          	li	a5,117
 6a4:	0af68063          	beq	a3,a5,744 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6a8:	07800793          	li	a5,120
 6ac:	0ef68263          	beq	a3,a5,790 <vprintf+0x1d2>
        putc(fd, '%');
 6b0:	02500593          	li	a1,37
 6b4:	855a                	mv	a0,s6
 6b6:	e55ff0ef          	jal	50a <putc>
        putc(fd, c0);
 6ba:	85a6                	mv	a1,s1
 6bc:	855a                	mv	a0,s6
 6be:	e4dff0ef          	jal	50a <putc>
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b791                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e55ff0ef          	jal	528 <printint>
        i += 1;
 6d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6da:	8ba6                	mv	s7,s1
      state = 0;
 6dc:	4981                	li	s3,0
        i += 1;
 6de:	b72d                	j	608 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e0:	06400793          	li	a5,100
 6e4:	02f60763          	beq	a2,a5,712 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e8:	07500793          	li	a5,117
 6ec:	06f60963          	beq	a2,a5,75e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f0:	07800793          	li	a5,120
 6f4:	faf61ee3          	bne	a2,a5,6b0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4641                	li	a2,16
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e23ff0ef          	jal	528 <printint>
        i += 2;
 70a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
        i += 2;
 710:	bde5                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 712:	008b8493          	addi	s1,s7,8
 716:	4685                	li	a3,1
 718:	4629                	li	a2,10
 71a:	000ba583          	lw	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	e09ff0ef          	jal	528 <printint>
        i += 2;
 724:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 726:	8ba6                	mv	s7,s1
      state = 0;
 728:	4981                	li	s3,0
        i += 2;
 72a:	bdf9                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 72c:	008b8493          	addi	s1,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	defff0ef          	jal	528 <printint>
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
 742:	b5d9                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	dd7ff0ef          	jal	528 <printint>
        i += 1;
 756:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
        i += 1;
 75c:	b575                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	008b8493          	addi	s1,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	dbdff0ef          	jal	528 <printint>
        i += 2;
 770:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
        i += 2;
 776:	bd49                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 778:	008b8493          	addi	s1,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000ba583          	lw	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	da3ff0ef          	jal	528 <printint>
 78a:	8ba6                	mv	s7,s1
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bdad                	j	608 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 790:	008b8493          	addi	s1,s7,8
 794:	4681                	li	a3,0
 796:	4641                	li	a2,16
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	d8bff0ef          	jal	528 <printint>
        i += 1;
 7a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a4:	8ba6                	mv	s7,s1
      state = 0;
 7a6:	4981                	li	s3,0
        i += 1;
 7a8:	b585                	j	608 <vprintf+0x4a>
 7aa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ac:	008b8d13          	addi	s10,s7,8
 7b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b4:	03000593          	li	a1,48
 7b8:	855a                	mv	a0,s6
 7ba:	d51ff0ef          	jal	50a <putc>
  putc(fd, 'x');
 7be:	07800593          	li	a1,120
 7c2:	855a                	mv	a0,s6
 7c4:	d47ff0ef          	jal	50a <putc>
 7c8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ca:	00000b97          	auipc	s7,0x0
 7ce:	2beb8b93          	addi	s7,s7,702 # a88 <digits>
 7d2:	03c9d793          	srli	a5,s3,0x3c
 7d6:	97de                	add	a5,a5,s7
 7d8:	0007c583          	lbu	a1,0(a5)
 7dc:	855a                	mv	a0,s6
 7de:	d2dff0ef          	jal	50a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e2:	0992                	slli	s3,s3,0x4
 7e4:	34fd                	addiw	s1,s1,-1
 7e6:	f4f5                	bnez	s1,7d2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7e8:	8bea                	mv	s7,s10
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	6d02                	ld	s10,0(sp)
 7ee:	bd29                	j	608 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7f0:	008b8993          	addi	s3,s7,8
 7f4:	000bb483          	ld	s1,0(s7)
 7f8:	cc91                	beqz	s1,814 <vprintf+0x256>
        for(; *s; s++)
 7fa:	0004c583          	lbu	a1,0(s1)
 7fe:	c195                	beqz	a1,822 <vprintf+0x264>
          putc(fd, *s);
 800:	855a                	mv	a0,s6
 802:	d09ff0ef          	jal	50a <putc>
        for(; *s; s++)
 806:	0485                	addi	s1,s1,1
 808:	0004c583          	lbu	a1,0(s1)
 80c:	f9f5                	bnez	a1,800 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 80e:	8bce                	mv	s7,s3
      state = 0;
 810:	4981                	li	s3,0
 812:	bbdd                	j	608 <vprintf+0x4a>
          s = "(null)";
 814:	00000497          	auipc	s1,0x0
 818:	26c48493          	addi	s1,s1,620 # a80 <malloc+0x15c>
        for(; *s; s++)
 81c:	02800593          	li	a1,40
 820:	b7c5                	j	800 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 822:	8bce                	mv	s7,s3
      state = 0;
 824:	4981                	li	s3,0
 826:	b3cd                	j	608 <vprintf+0x4a>
 828:	6906                	ld	s2,64(sp)
 82a:	79e2                	ld	s3,56(sp)
 82c:	7a42                	ld	s4,48(sp)
 82e:	7aa2                	ld	s5,40(sp)
 830:	7b02                	ld	s6,32(sp)
 832:	6be2                	ld	s7,24(sp)
 834:	6c42                	ld	s8,16(sp)
 836:	6ca2                	ld	s9,8(sp)
    }
  }
}
 838:	60e6                	ld	ra,88(sp)
 83a:	6446                	ld	s0,80(sp)
 83c:	64a6                	ld	s1,72(sp)
 83e:	6125                	addi	sp,sp,96
 840:	8082                	ret

0000000000000842 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 842:	715d                	addi	sp,sp,-80
 844:	ec06                	sd	ra,24(sp)
 846:	e822                	sd	s0,16(sp)
 848:	1000                	addi	s0,sp,32
 84a:	e010                	sd	a2,0(s0)
 84c:	e414                	sd	a3,8(s0)
 84e:	e818                	sd	a4,16(s0)
 850:	ec1c                	sd	a5,24(s0)
 852:	03043023          	sd	a6,32(s0)
 856:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 85a:	8622                	mv	a2,s0
 85c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 860:	d5fff0ef          	jal	5be <vprintf>
}
 864:	60e2                	ld	ra,24(sp)
 866:	6442                	ld	s0,16(sp)
 868:	6161                	addi	sp,sp,80
 86a:	8082                	ret

000000000000086c <printf>:

void
printf(const char *fmt, ...)
{
 86c:	711d                	addi	sp,sp,-96
 86e:	ec06                	sd	ra,24(sp)
 870:	e822                	sd	s0,16(sp)
 872:	1000                	addi	s0,sp,32
 874:	e40c                	sd	a1,8(s0)
 876:	e810                	sd	a2,16(s0)
 878:	ec14                	sd	a3,24(s0)
 87a:	f018                	sd	a4,32(s0)
 87c:	f41c                	sd	a5,40(s0)
 87e:	03043823          	sd	a6,48(s0)
 882:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 886:	00840613          	addi	a2,s0,8
 88a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 88e:	85aa                	mv	a1,a0
 890:	4505                	li	a0,1
 892:	d2dff0ef          	jal	5be <vprintf>
}
 896:	60e2                	ld	ra,24(sp)
 898:	6442                	ld	s0,16(sp)
 89a:	6125                	addi	sp,sp,96
 89c:	8082                	ret

000000000000089e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89e:	1141                	addi	sp,sp,-16
 8a0:	e406                	sd	ra,8(sp)
 8a2:	e022                	sd	s0,0(sp)
 8a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	00000797          	auipc	a5,0x0
 8ae:	7567b783          	ld	a5,1878(a5) # 1000 <freep>
 8b2:	a02d                	j	8dc <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8b4:	4618                	lw	a4,8(a2)
 8b6:	9f2d                	addw	a4,a4,a1
 8b8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	6398                	ld	a4,0(a5)
 8be:	6310                	ld	a2,0(a4)
 8c0:	a83d                	j	8fe <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8c2:	ff852703          	lw	a4,-8(a0)
 8c6:	9f31                	addw	a4,a4,a2
 8c8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ca:	ff053683          	ld	a3,-16(a0)
 8ce:	a091                	j	912 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d0:	6398                	ld	a4,0(a5)
 8d2:	00e7e463          	bltu	a5,a4,8da <free+0x3c>
 8d6:	00e6ea63          	bltu	a3,a4,8ea <free+0x4c>
{
 8da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8dc:	fed7fae3          	bgeu	a5,a3,8d0 <free+0x32>
 8e0:	6398                	ld	a4,0(a5)
 8e2:	00e6e463          	bltu	a3,a4,8ea <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e6:	fee7eae3          	bltu	a5,a4,8da <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8ea:	ff852583          	lw	a1,-8(a0)
 8ee:	6390                	ld	a2,0(a5)
 8f0:	02059813          	slli	a6,a1,0x20
 8f4:	01c85713          	srli	a4,a6,0x1c
 8f8:	9736                	add	a4,a4,a3
 8fa:	fae60de3          	beq	a2,a4,8b4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 902:	4790                	lw	a2,8(a5)
 904:	02061593          	slli	a1,a2,0x20
 908:	01c5d713          	srli	a4,a1,0x1c
 90c:	973e                	add	a4,a4,a5
 90e:	fae68ae3          	beq	a3,a4,8c2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 912:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 914:	00000717          	auipc	a4,0x0
 918:	6ef73623          	sd	a5,1772(a4) # 1000 <freep>
}
 91c:	60a2                	ld	ra,8(sp)
 91e:	6402                	ld	s0,0(sp)
 920:	0141                	addi	sp,sp,16
 922:	8082                	ret

0000000000000924 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 924:	7139                	addi	sp,sp,-64
 926:	fc06                	sd	ra,56(sp)
 928:	f822                	sd	s0,48(sp)
 92a:	f04a                	sd	s2,32(sp)
 92c:	ec4e                	sd	s3,24(sp)
 92e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 930:	02051993          	slli	s3,a0,0x20
 934:	0209d993          	srli	s3,s3,0x20
 938:	09bd                	addi	s3,s3,15
 93a:	0049d993          	srli	s3,s3,0x4
 93e:	2985                	addiw	s3,s3,1
 940:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 942:	00000517          	auipc	a0,0x0
 946:	6be53503          	ld	a0,1726(a0) # 1000 <freep>
 94a:	c905                	beqz	a0,97a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94e:	4798                	lw	a4,8(a5)
 950:	09377663          	bgeu	a4,s3,9dc <malloc+0xb8>
 954:	f426                	sd	s1,40(sp)
 956:	e852                	sd	s4,16(sp)
 958:	e456                	sd	s5,8(sp)
 95a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 95c:	8a4e                	mv	s4,s3
 95e:	6705                	lui	a4,0x1
 960:	00e9f363          	bgeu	s3,a4,966 <malloc+0x42>
 964:	6a05                	lui	s4,0x1
 966:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 96a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 96e:	00000497          	auipc	s1,0x0
 972:	69248493          	addi	s1,s1,1682 # 1000 <freep>
  if(p == (char*)-1)
 976:	5afd                	li	s5,-1
 978:	a83d                	j	9b6 <malloc+0x92>
 97a:	f426                	sd	s1,40(sp)
 97c:	e852                	sd	s4,16(sp)
 97e:	e456                	sd	s5,8(sp)
 980:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 982:	00000797          	auipc	a5,0x0
 986:	68e78793          	addi	a5,a5,1678 # 1010 <base>
 98a:	00000717          	auipc	a4,0x0
 98e:	66f73b23          	sd	a5,1654(a4) # 1000 <freep>
 992:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 994:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 998:	b7d1                	j	95c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 99a:	6398                	ld	a4,0(a5)
 99c:	e118                	sd	a4,0(a0)
 99e:	a899                	j	9f4 <malloc+0xd0>
  hp->s.size = nu;
 9a0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a4:	0541                	addi	a0,a0,16
 9a6:	ef9ff0ef          	jal	89e <free>
  return freep;
 9aa:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9ac:	c125                	beqz	a0,a0c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b0:	4798                	lw	a4,8(a5)
 9b2:	03277163          	bgeu	a4,s2,9d4 <malloc+0xb0>
    if(p == freep)
 9b6:	6098                	ld	a4,0(s1)
 9b8:	853e                	mv	a0,a5
 9ba:	fef71ae3          	bne	a4,a5,9ae <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9be:	8552                	mv	a0,s4
 9c0:	b0bff0ef          	jal	4ca <sbrk>
  if(p == (char*)-1)
 9c4:	fd551ee3          	bne	a0,s5,9a0 <malloc+0x7c>
        return 0;
 9c8:	4501                	li	a0,0
 9ca:	74a2                	ld	s1,40(sp)
 9cc:	6a42                	ld	s4,16(sp)
 9ce:	6aa2                	ld	s5,8(sp)
 9d0:	6b02                	ld	s6,0(sp)
 9d2:	a03d                	j	a00 <malloc+0xdc>
 9d4:	74a2                	ld	s1,40(sp)
 9d6:	6a42                	ld	s4,16(sp)
 9d8:	6aa2                	ld	s5,8(sp)
 9da:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9dc:	fae90fe3          	beq	s2,a4,99a <malloc+0x76>
        p->s.size -= nunits;
 9e0:	4137073b          	subw	a4,a4,s3
 9e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e6:	02071693          	slli	a3,a4,0x20
 9ea:	01c6d713          	srli	a4,a3,0x1c
 9ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f4:	00000717          	auipc	a4,0x0
 9f8:	60a73623          	sd	a0,1548(a4) # 1000 <freep>
      return (void*)(p + 1);
 9fc:	01078513          	addi	a0,a5,16
  }
}
 a00:	70e2                	ld	ra,56(sp)
 a02:	7442                	ld	s0,48(sp)
 a04:	7902                	ld	s2,32(sp)
 a06:	69e2                	ld	s3,24(sp)
 a08:	6121                	addi	sp,sp,64
 a0a:	8082                	ret
 a0c:	74a2                	ld	s1,40(sp)
 a0e:	6a42                	ld	s4,16(sp)
 a10:	6aa2                	ld	s5,8(sp)
 a12:	6b02                	ld	s6,0(sp)
 a14:	b7f5                	j	a00 <malloc+0xdc>
