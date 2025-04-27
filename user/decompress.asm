
user/_decompress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decompress_file>:
#include "kernel/fcntl.h"

#define BLOCK_SIZE 512
#define MAX_FILENAME 256

void decompress_file(int src_fd, int dest_fd) {
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	23813823          	sd	s8,560(sp)
  2c:	23913423          	sd	s9,552(sp)
  30:	23a13023          	sd	s10,544(sp)
  34:	21b13c23          	sd	s11,536(sp)
  38:	0500                	addi	s0,sp,640
  3a:	8caa                	mv	s9,a0
  3c:	8a2e                	mv	s4,a1
    char buf[BLOCK_SIZE];
    char curr_char;
    int count, n;
    int i = 0;

    while ((n = read(src_fd, buf, BLOCK_SIZE)) > 0) {
  3e:	d9040d13          	addi	s10,s0,-624
                }
                i = 0;
            }
            
            count = buf[i++] - '0';
            if (count < 1 || count > 9) {
  42:	4c21                	li	s8,8
                fprintf(2, "decompress: invalid count %d\n", count);
                exit(1);
            }

            for (int j = 0; j < count; j++) {
                if (write(dest_fd, &curr_char, 1) != 1) {
  44:	d8f40a93          	addi	s5,s0,-625
  48:	4905                	li	s2,1
    while ((n = read(src_fd, buf, BLOCK_SIZE)) > 0) {
  4a:	20000613          	li	a2,512
  4e:	85ea                	mv	a1,s10
  50:	8566                	mv	a0,s9
  52:	4e6000ef          	jal	538 <read>
  56:	8baa                	mv	s7,a0
  58:	0aa05863          	blez	a0,108 <decompress_file+0x108>
  5c:	4b01                	li	s6,0
                n = read(src_fd, buf, BLOCK_SIZE);
  5e:	20000d93          	li	s11,512
  62:	a0b9                	j	b0 <decompress_file+0xb0>
                    fprintf(2, "decompress: unexpected EOF\n");
  64:	00001597          	auipc	a1,0x1
  68:	a9c58593          	addi	a1,a1,-1380 # b00 <malloc+0xfe>
  6c:	4509                	li	a0,2
  6e:	0b3000ef          	jal	920 <fprintf>
                    exit(1);
  72:	4505                	li	a0,1
  74:	4ac000ef          	jal	520 <exit>
            count = buf[i++] - '0';
  78:	00178b1b          	addiw	s6,a5,1
  7c:	f9078793          	addi	a5,a5,-112
  80:	97a2                	add	a5,a5,s0
  82:	e007c603          	lbu	a2,-512(a5)
            if (count < 1 || count > 9) {
  86:	0006099b          	sext.w	s3,a2
  8a:	fcf6079b          	addiw	a5,a2,-49
  8e:	04fc6763          	bltu	s8,a5,dc <decompress_file+0xdc>
  92:	fd09899b          	addiw	s3,s3,-48
            for (int j = 0; j < count; j++) {
  96:	4481                	li	s1,0
                if (write(dest_fd, &curr_char, 1) != 1) {
  98:	864a                	mv	a2,s2
  9a:	85d6                	mv	a1,s5
  9c:	8552                	mv	a0,s4
  9e:	4a2000ef          	jal	540 <write>
  a2:	05251963          	bne	a0,s2,f4 <decompress_file+0xf4>
            for (int j = 0; j < count; j++) {
  a6:	2485                	addiw	s1,s1,1
  a8:	ff3498e3          	bne	s1,s3,98 <decompress_file+0x98>
        while (i < n) {
  ac:	f97b5fe3          	bge	s6,s7,4a <decompress_file+0x4a>
            curr_char = buf[i++];
  b0:	001b079b          	addiw	a5,s6,1
  b4:	f90b0713          	addi	a4,s6,-112
  b8:	00870b33          	add	s6,a4,s0
  bc:	e00b4703          	lbu	a4,-512(s6)
  c0:	d8e407a3          	sb	a4,-625(s0)
            if (i >= n) {
  c4:	fb77cae3          	blt	a5,s7,78 <decompress_file+0x78>
                n = read(src_fd, buf, BLOCK_SIZE);
  c8:	866e                	mv	a2,s11
  ca:	85ea                	mv	a1,s10
  cc:	8566                	mv	a0,s9
  ce:	46a000ef          	jal	538 <read>
  d2:	8baa                	mv	s7,a0
                if (n <= 0) {
  d4:	f8a058e3          	blez	a0,64 <decompress_file+0x64>
                i = 0;
  d8:	4781                	li	a5,0
  da:	bf79                	j	78 <decompress_file+0x78>
                fprintf(2, "decompress: invalid count %d\n", count);
  dc:	fd06061b          	addiw	a2,a2,-48
  e0:	00001597          	auipc	a1,0x1
  e4:	a4058593          	addi	a1,a1,-1472 # b20 <malloc+0x11e>
  e8:	4509                	li	a0,2
  ea:	037000ef          	jal	920 <fprintf>
                exit(1);
  ee:	4505                	li	a0,1
  f0:	430000ef          	jal	520 <exit>
                    fprintf(2, "decompress: write error\n");
  f4:	00001597          	auipc	a1,0x1
  f8:	a4c58593          	addi	a1,a1,-1460 # b40 <malloc+0x13e>
  fc:	4509                	li	a0,2
  fe:	023000ef          	jal	920 <fprintf>
                    exit(1);
 102:	4505                	li	a0,1
 104:	41c000ef          	jal	520 <exit>
            }
        }
        i = 0;
    }

    if (n < 0) {
 108:	02054f63          	bltz	a0,146 <decompress_file+0x146>
        fprintf(2, "decompress: read error\n");
        exit(1);
    }
}
 10c:	27813083          	ld	ra,632(sp)
 110:	27013403          	ld	s0,624(sp)
 114:	26813483          	ld	s1,616(sp)
 118:	26013903          	ld	s2,608(sp)
 11c:	25813983          	ld	s3,600(sp)
 120:	25013a03          	ld	s4,592(sp)
 124:	24813a83          	ld	s5,584(sp)
 128:	24013b03          	ld	s6,576(sp)
 12c:	23813b83          	ld	s7,568(sp)
 130:	23013c03          	ld	s8,560(sp)
 134:	22813c83          	ld	s9,552(sp)
 138:	22013d03          	ld	s10,544(sp)
 13c:	21813d83          	ld	s11,536(sp)
 140:	28010113          	addi	sp,sp,640
 144:	8082                	ret
        fprintf(2, "decompress: read error\n");
 146:	00001597          	auipc	a1,0x1
 14a:	a1a58593          	addi	a1,a1,-1510 # b60 <malloc+0x15e>
 14e:	4509                	li	a0,2
 150:	7d0000ef          	jal	920 <fprintf>
        exit(1);
 154:	4505                	li	a0,1
 156:	3ca000ef          	jal	520 <exit>

000000000000015a <create_output_filename>:

void create_output_filename(const char* input, char* output) {
 15a:	1141                	addi	sp,sp,-16
 15c:	e406                	sd	ra,8(sp)
 15e:	e022                	sd	s0,0(sp)
 160:	0800                	addi	s0,sp,16
    int i = 0;
    
    // Copy input filename
    while (input[i] != '\0' && i < MAX_FILENAME - 5) {
 162:	00054703          	lbu	a4,0(a0)
 166:	c73d                	beqz	a4,1d4 <create_output_filename+0x7a>
 168:	4785                	li	a5,1
 16a:	0fc00813          	li	a6,252
 16e:	a011                	j	172 <create_output_filename+0x18>
 170:	87b6                	mv	a5,a3
        output[i] = input[i];
 172:	00f586b3          	add	a3,a1,a5
 176:	fee68fa3          	sb	a4,-1(a3)
        i++;
 17a:	0007861b          	sext.w	a2,a5
    while (input[i] != '\0' && i < MAX_FILENAME - 5) {
 17e:	00f50733          	add	a4,a0,a5
 182:	00074703          	lbu	a4,0(a4)
 186:	c709                	beqz	a4,190 <create_output_filename+0x36>
 188:	00178693          	addi	a3,a5,1
 18c:	ff0692e3          	bne	a3,a6,170 <create_output_filename+0x16>
    }
    
    // Append .dec extension
    output[i++] = '.';
 190:	97ae                	add	a5,a5,a1
 192:	02e00713          	li	a4,46
 196:	00e78023          	sb	a4,0(a5)
 19a:	0016079b          	addiw	a5,a2,1
    output[i++] = 'd';
 19e:	97ae                	add	a5,a5,a1
 1a0:	06400713          	li	a4,100
 1a4:	00e78023          	sb	a4,0(a5)
 1a8:	0026079b          	addiw	a5,a2,2
    output[i++] = 'e';
 1ac:	97ae                	add	a5,a5,a1
 1ae:	06500713          	li	a4,101
 1b2:	00e78023          	sb	a4,0(a5)
 1b6:	0036079b          	addiw	a5,a2,3
    output[i++] = 'c';
 1ba:	97ae                	add	a5,a5,a1
 1bc:	06300713          	li	a4,99
 1c0:	00e78023          	sb	a4,0(a5)
 1c4:	2611                	addiw	a2,a2,4
    output[i] = '\0';
 1c6:	95b2                	add	a1,a1,a2
 1c8:	00058023          	sb	zero,0(a1)
}
 1cc:	60a2                	ld	ra,8(sp)
 1ce:	6402                	ld	s0,0(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret
    int i = 0;
 1d4:	4601                	li	a2,0
    while (input[i] != '\0' && i < MAX_FILENAME - 5) {
 1d6:	4781                	li	a5,0
 1d8:	bf65                	j	190 <create_output_filename+0x36>

00000000000001da <main>:

int main(int argc, char *argv[]) {
 1da:	7169                	addi	sp,sp,-304
 1dc:	f606                	sd	ra,296(sp)
 1de:	f222                	sd	s0,288(sp)
 1e0:	ee26                	sd	s1,280(sp)
 1e2:	1a00                	addi	s0,sp,304
 1e4:	84ae                	mv	s1,a1
    int src_fd, dest_fd;
    char output_filename[MAX_FILENAME];

    if (argc != 2) {
 1e6:	4789                	li	a5,2
 1e8:	00f50f63          	beq	a0,a5,206 <main+0x2c>
 1ec:	ea4a                	sd	s2,272(sp)
 1ee:	e64e                	sd	s3,264(sp)
        fprintf(2, "Usage: %s <compressed-input>\n", argv[0]);
 1f0:	6190                	ld	a2,0(a1)
 1f2:	00001597          	auipc	a1,0x1
 1f6:	98658593          	addi	a1,a1,-1658 # b78 <malloc+0x176>
 1fa:	853e                	mv	a0,a5
 1fc:	724000ef          	jal	920 <fprintf>
        exit(1);
 200:	4505                	li	a0,1
 202:	31e000ef          	jal	520 <exit>
 206:	ea4a                	sd	s2,272(sp)
    }

    // Open input file
    if ((src_fd = open(argv[1], O_RDONLY)) < 0) {
 208:	4581                	li	a1,0
 20a:	6488                	ld	a0,8(s1)
 20c:	354000ef          	jal	560 <open>
 210:	892a                	mv	s2,a0
 212:	02054e63          	bltz	a0,24e <main+0x74>
 216:	e64e                	sd	s3,264(sp)
        fprintf(2, "decompress: cannot open %s\n", argv[1]);
        exit(1);
    }

    // Create output filename
    create_output_filename(argv[1], output_filename);
 218:	ed040993          	addi	s3,s0,-304
 21c:	85ce                	mv	a1,s3
 21e:	6488                	ld	a0,8(s1)
 220:	f3bff0ef          	jal	15a <create_output_filename>
    
    // Create output file
    if ((dest_fd = open(output_filename, O_CREATE | O_WRONLY)) < 0) {
 224:	20100593          	li	a1,513
 228:	854e                	mv	a0,s3
 22a:	336000ef          	jal	560 <open>
 22e:	84aa                	mv	s1,a0
 230:	02054b63          	bltz	a0,266 <main+0x8c>
        fprintf(2, "decompress: cannot create %s\n", output_filename);
        close(src_fd);
        exit(1);
    }

    decompress_file(src_fd, dest_fd);
 234:	85aa                	mv	a1,a0
 236:	854a                	mv	a0,s2
 238:	dc9ff0ef          	jal	0 <decompress_file>

    close(src_fd);
 23c:	854a                	mv	a0,s2
 23e:	30a000ef          	jal	548 <close>
    close(dest_fd);
 242:	8526                	mv	a0,s1
 244:	304000ef          	jal	548 <close>
    exit(0);
 248:	4501                	li	a0,0
 24a:	2d6000ef          	jal	520 <exit>
 24e:	e64e                	sd	s3,264(sp)
        fprintf(2, "decompress: cannot open %s\n", argv[1]);
 250:	6490                	ld	a2,8(s1)
 252:	00001597          	auipc	a1,0x1
 256:	94658593          	addi	a1,a1,-1722 # b98 <malloc+0x196>
 25a:	4509                	li	a0,2
 25c:	6c4000ef          	jal	920 <fprintf>
        exit(1);
 260:	4505                	li	a0,1
 262:	2be000ef          	jal	520 <exit>
        fprintf(2, "decompress: cannot create %s\n", output_filename);
 266:	864e                	mv	a2,s3
 268:	00001597          	auipc	a1,0x1
 26c:	95058593          	addi	a1,a1,-1712 # bb8 <malloc+0x1b6>
 270:	4509                	li	a0,2
 272:	6ae000ef          	jal	920 <fprintf>
        close(src_fd);
 276:	854a                	mv	a0,s2
 278:	2d0000ef          	jal	548 <close>
        exit(1);
 27c:	4505                	li	a0,1
 27e:	2a2000ef          	jal	520 <exit>

0000000000000282 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  extern int main();
  main();
 28a:	f51ff0ef          	jal	1da <main>
  exit(0);
 28e:	4501                	li	a0,0
 290:	290000ef          	jal	520 <exit>

0000000000000294 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 29c:	87aa                	mv	a5,a0
 29e:	0585                	addi	a1,a1,1
 2a0:	0785                	addi	a5,a5,1
 2a2:	fff5c703          	lbu	a4,-1(a1)
 2a6:	fee78fa3          	sb	a4,-1(a5)
 2aa:	fb75                	bnez	a4,29e <strcpy+0xa>
    ;
  return os;
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	cb91                	beqz	a5,2d4 <strcmp+0x20>
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00f71763          	bne	a4,a5,2d4 <strcmp+0x20>
    p++, q++;
 2ca:	0505                	addi	a0,a0,1
 2cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	fbe5                	bnez	a5,2c2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2d4:	0005c503          	lbu	a0,0(a1)
}
 2d8:	40a7853b          	subw	a0,a5,a0
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <strlen>:

uint
strlen(const char *s)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	cf99                	beqz	a5,30e <strlen+0x2a>
 2f2:	0505                	addi	a0,a0,1
 2f4:	87aa                	mv	a5,a0
 2f6:	86be                	mv	a3,a5
 2f8:	0785                	addi	a5,a5,1
 2fa:	fff7c703          	lbu	a4,-1(a5)
 2fe:	ff65                	bnez	a4,2f6 <strlen+0x12>
 300:	40a6853b          	subw	a0,a3,a0
 304:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
  for(n = 0; s[n]; n++)
 30e:	4501                	li	a0,0
 310:	bfdd                	j	306 <strlen+0x22>

0000000000000312 <memset>:

void*
memset(void *dst, int c, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e406                	sd	ra,8(sp)
 316:	e022                	sd	s0,0(sp)
 318:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31a:	ca19                	beqz	a2,330 <memset+0x1e>
 31c:	87aa                	mv	a5,a0
 31e:	1602                	slli	a2,a2,0x20
 320:	9201                	srli	a2,a2,0x20
 322:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 326:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32a:	0785                	addi	a5,a5,1
 32c:	fee79de3          	bne	a5,a4,326 <memset+0x14>
  }
  return dst;
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <strchr>:

char*
strchr(const char *s, char c)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 340:	00054783          	lbu	a5,0(a0)
 344:	cf81                	beqz	a5,35c <strchr+0x24>
    if(*s == c)
 346:	00f58763          	beq	a1,a5,354 <strchr+0x1c>
  for(; *s; s++)
 34a:	0505                	addi	a0,a0,1
 34c:	00054783          	lbu	a5,0(a0)
 350:	fbfd                	bnez	a5,346 <strchr+0xe>
      return (char*)s;
  return 0;
 352:	4501                	li	a0,0
}
 354:	60a2                	ld	ra,8(sp)
 356:	6402                	ld	s0,0(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
  return 0;
 35c:	4501                	li	a0,0
 35e:	bfdd                	j	354 <strchr+0x1c>

0000000000000360 <gets>:

char*
gets(char *buf, int max)
{
 360:	7159                	addi	sp,sp,-112
 362:	f486                	sd	ra,104(sp)
 364:	f0a2                	sd	s0,96(sp)
 366:	eca6                	sd	s1,88(sp)
 368:	e8ca                	sd	s2,80(sp)
 36a:	e4ce                	sd	s3,72(sp)
 36c:	e0d2                	sd	s4,64(sp)
 36e:	fc56                	sd	s5,56(sp)
 370:	f85a                	sd	s6,48(sp)
 372:	f45e                	sd	s7,40(sp)
 374:	f062                	sd	s8,32(sp)
 376:	ec66                	sd	s9,24(sp)
 378:	e86a                	sd	s10,16(sp)
 37a:	1880                	addi	s0,sp,112
 37c:	8caa                	mv	s9,a0
 37e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 380:	892a                	mv	s2,a0
 382:	4481                	li	s1,0
    cc = read(0, &c, 1);
 384:	f9f40b13          	addi	s6,s0,-97
 388:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 38a:	4ba9                	li	s7,10
 38c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 38e:	8d26                	mv	s10,s1
 390:	0014899b          	addiw	s3,s1,1
 394:	84ce                	mv	s1,s3
 396:	0349d563          	bge	s3,s4,3c0 <gets+0x60>
    cc = read(0, &c, 1);
 39a:	8656                	mv	a2,s5
 39c:	85da                	mv	a1,s6
 39e:	4501                	li	a0,0
 3a0:	198000ef          	jal	538 <read>
    if(cc < 1)
 3a4:	00a05e63          	blez	a0,3c0 <gets+0x60>
    buf[i++] = c;
 3a8:	f9f44783          	lbu	a5,-97(s0)
 3ac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b0:	01778763          	beq	a5,s7,3be <gets+0x5e>
 3b4:	0905                	addi	s2,s2,1
 3b6:	fd879ce3          	bne	a5,s8,38e <gets+0x2e>
    buf[i++] = c;
 3ba:	8d4e                	mv	s10,s3
 3bc:	a011                	j	3c0 <gets+0x60>
 3be:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3c0:	9d66                	add	s10,s10,s9
 3c2:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3c6:	8566                	mv	a0,s9
 3c8:	70a6                	ld	ra,104(sp)
 3ca:	7406                	ld	s0,96(sp)
 3cc:	64e6                	ld	s1,88(sp)
 3ce:	6946                	ld	s2,80(sp)
 3d0:	69a6                	ld	s3,72(sp)
 3d2:	6a06                	ld	s4,64(sp)
 3d4:	7ae2                	ld	s5,56(sp)
 3d6:	7b42                	ld	s6,48(sp)
 3d8:	7ba2                	ld	s7,40(sp)
 3da:	7c02                	ld	s8,32(sp)
 3dc:	6ce2                	ld	s9,24(sp)
 3de:	6d42                	ld	s10,16(sp)
 3e0:	6165                	addi	sp,sp,112
 3e2:	8082                	ret

00000000000003e4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	e04a                	sd	s2,0(sp)
 3ec:	1000                	addi	s0,sp,32
 3ee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f0:	4581                	li	a1,0
 3f2:	16e000ef          	jal	560 <open>
  if(fd < 0)
 3f6:	02054263          	bltz	a0,41a <stat+0x36>
 3fa:	e426                	sd	s1,8(sp)
 3fc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3fe:	85ca                	mv	a1,s2
 400:	178000ef          	jal	578 <fstat>
 404:	892a                	mv	s2,a0
  close(fd);
 406:	8526                	mv	a0,s1
 408:	140000ef          	jal	548 <close>
  return r;
 40c:	64a2                	ld	s1,8(sp)
}
 40e:	854a                	mv	a0,s2
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6902                	ld	s2,0(sp)
 416:	6105                	addi	sp,sp,32
 418:	8082                	ret
    return -1;
 41a:	597d                	li	s2,-1
 41c:	bfcd                	j	40e <stat+0x2a>

000000000000041e <atoi>:

int
atoi(const char *s)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e406                	sd	ra,8(sp)
 422:	e022                	sd	s0,0(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 426:	00054683          	lbu	a3,0(a0)
 42a:	fd06879b          	addiw	a5,a3,-48
 42e:	0ff7f793          	zext.b	a5,a5
 432:	4625                	li	a2,9
 434:	02f66963          	bltu	a2,a5,466 <atoi+0x48>
 438:	872a                	mv	a4,a0
  n = 0;
 43a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 43c:	0705                	addi	a4,a4,1
 43e:	0025179b          	slliw	a5,a0,0x2
 442:	9fa9                	addw	a5,a5,a0
 444:	0017979b          	slliw	a5,a5,0x1
 448:	9fb5                	addw	a5,a5,a3
 44a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 44e:	00074683          	lbu	a3,0(a4)
 452:	fd06879b          	addiw	a5,a3,-48
 456:	0ff7f793          	zext.b	a5,a5
 45a:	fef671e3          	bgeu	a2,a5,43c <atoi+0x1e>
  return n;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
  n = 0;
 466:	4501                	li	a0,0
 468:	bfdd                	j	45e <atoi+0x40>

000000000000046a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 472:	02b57563          	bgeu	a0,a1,49c <memmove+0x32>
    while(n-- > 0)
 476:	00c05f63          	blez	a2,494 <memmove+0x2a>
 47a:	1602                	slli	a2,a2,0x20
 47c:	9201                	srli	a2,a2,0x20
 47e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 482:	872a                	mv	a4,a0
      *dst++ = *src++;
 484:	0585                	addi	a1,a1,1
 486:	0705                	addi	a4,a4,1
 488:	fff5c683          	lbu	a3,-1(a1)
 48c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 490:	fee79ae3          	bne	a5,a4,484 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 494:	60a2                	ld	ra,8(sp)
 496:	6402                	ld	s0,0(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret
    dst += n;
 49c:	00c50733          	add	a4,a0,a2
    src += n;
 4a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a2:	fec059e3          	blez	a2,494 <memmove+0x2a>
 4a6:	fff6079b          	addiw	a5,a2,-1
 4aa:	1782                	slli	a5,a5,0x20
 4ac:	9381                	srli	a5,a5,0x20
 4ae:	fff7c793          	not	a5,a5
 4b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b4:	15fd                	addi	a1,a1,-1
 4b6:	177d                	addi	a4,a4,-1
 4b8:	0005c683          	lbu	a3,0(a1)
 4bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c0:	fef71ae3          	bne	a4,a5,4b4 <memmove+0x4a>
 4c4:	bfc1                	j	494 <memmove+0x2a>

00000000000004c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e406                	sd	ra,8(sp)
 4ca:	e022                	sd	s0,0(sp)
 4cc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ce:	ca0d                	beqz	a2,500 <memcmp+0x3a>
 4d0:	fff6069b          	addiw	a3,a2,-1
 4d4:	1682                	slli	a3,a3,0x20
 4d6:	9281                	srli	a3,a3,0x20
 4d8:	0685                	addi	a3,a3,1
 4da:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4dc:	00054783          	lbu	a5,0(a0)
 4e0:	0005c703          	lbu	a4,0(a1)
 4e4:	00e79863          	bne	a5,a4,4f4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4e8:	0505                	addi	a0,a0,1
    p2++;
 4ea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ec:	fed518e3          	bne	a0,a3,4dc <memcmp+0x16>
  }
  return 0;
 4f0:	4501                	li	a0,0
 4f2:	a019                	j	4f8 <memcmp+0x32>
      return *p1 - *p2;
 4f4:	40e7853b          	subw	a0,a5,a4
}
 4f8:	60a2                	ld	ra,8(sp)
 4fa:	6402                	ld	s0,0(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret
  return 0;
 500:	4501                	li	a0,0
 502:	bfdd                	j	4f8 <memcmp+0x32>

0000000000000504 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 504:	1141                	addi	sp,sp,-16
 506:	e406                	sd	ra,8(sp)
 508:	e022                	sd	s0,0(sp)
 50a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 50c:	f5fff0ef          	jal	46a <memmove>
}
 510:	60a2                	ld	ra,8(sp)
 512:	6402                	ld	s0,0(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret

0000000000000518 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 518:	4885                	li	a7,1
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <exit>:
.global exit
exit:
 li a7, SYS_exit
 520:	4889                	li	a7,2
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <wait>:
.global wait
wait:
 li a7, SYS_wait
 528:	488d                	li	a7,3
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 530:	4891                	li	a7,4
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <read>:
.global read
read:
 li a7, SYS_read
 538:	4895                	li	a7,5
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <write>:
.global write
write:
 li a7, SYS_write
 540:	48c1                	li	a7,16
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <close>:
.global close
close:
 li a7, SYS_close
 548:	48d5                	li	a7,21
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <kill>:
.global kill
kill:
 li a7, SYS_kill
 550:	4899                	li	a7,6
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <exec>:
.global exec
exec:
 li a7, SYS_exec
 558:	489d                	li	a7,7
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <open>:
.global open
open:
 li a7, SYS_open
 560:	48bd                	li	a7,15
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 568:	48c5                	li	a7,17
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 570:	48c9                	li	a7,18
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 578:	48a1                	li	a7,8
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <link>:
.global link
link:
 li a7, SYS_link
 580:	48cd                	li	a7,19
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 588:	48d1                	li	a7,20
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 590:	48a5                	li	a7,9
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <dup>:
.global dup
dup:
 li a7, SYS_dup
 598:	48a9                	li	a7,10
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a0:	48ad                	li	a7,11
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5a8:	48b1                	li	a7,12
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b0:	48b5                	li	a7,13
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5b8:	48b9                	li	a7,14
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <getmemusage>:
.global getmemusage
getmemusage:
 li a7, SYS_getmemusage
 5c0:	48d9                	li	a7,22
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <ps>:
.global ps
ps:
 li a7, SYS_ps
 5c8:	48dd                	li	a7,23
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <pinfo>:
.global pinfo
pinfo:
 li a7, SYS_pinfo
 5d0:	48e1                	li	a7,24
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <getidlepid>:
.global getidlepid
getidlepid:
 li a7, SYS_getidlepid
 5d8:	48e5                	li	a7,25
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <getactiveprocesses>:
.global getactiveprocesses
getactiveprocesses:
 li a7, SYS_getactiveprocesses
 5e0:	48e9                	li	a7,26
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e8:	1101                	addi	sp,sp,-32
 5ea:	ec06                	sd	ra,24(sp)
 5ec:	e822                	sd	s0,16(sp)
 5ee:	1000                	addi	s0,sp,32
 5f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f4:	4605                	li	a2,1
 5f6:	fef40593          	addi	a1,s0,-17
 5fa:	f47ff0ef          	jal	540 <write>
}
 5fe:	60e2                	ld	ra,24(sp)
 600:	6442                	ld	s0,16(sp)
 602:	6105                	addi	sp,sp,32
 604:	8082                	ret

0000000000000606 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 606:	7139                	addi	sp,sp,-64
 608:	fc06                	sd	ra,56(sp)
 60a:	f822                	sd	s0,48(sp)
 60c:	f426                	sd	s1,40(sp)
 60e:	f04a                	sd	s2,32(sp)
 610:	ec4e                	sd	s3,24(sp)
 612:	0080                	addi	s0,sp,64
 614:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 616:	c299                	beqz	a3,61c <printint+0x16>
 618:	0605ce63          	bltz	a1,694 <printint+0x8e>
  neg = 0;
 61c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 61e:	fc040313          	addi	t1,s0,-64
  neg = 0;
 622:	869a                	mv	a3,t1
  i = 0;
 624:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 626:	00000817          	auipc	a6,0x0
 62a:	5ba80813          	addi	a6,a6,1466 # be0 <digits>
 62e:	88be                	mv	a7,a5
 630:	0017851b          	addiw	a0,a5,1
 634:	87aa                	mv	a5,a0
 636:	02c5f73b          	remuw	a4,a1,a2
 63a:	1702                	slli	a4,a4,0x20
 63c:	9301                	srli	a4,a4,0x20
 63e:	9742                	add	a4,a4,a6
 640:	00074703          	lbu	a4,0(a4)
 644:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 648:	872e                	mv	a4,a1
 64a:	02c5d5bb          	divuw	a1,a1,a2
 64e:	0685                	addi	a3,a3,1
 650:	fcc77fe3          	bgeu	a4,a2,62e <printint+0x28>
  if(neg)
 654:	000e0c63          	beqz	t3,66c <printint+0x66>
    buf[i++] = '-';
 658:	fd050793          	addi	a5,a0,-48
 65c:	00878533          	add	a0,a5,s0
 660:	02d00793          	li	a5,45
 664:	fef50823          	sb	a5,-16(a0)
 668:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 66c:	fff7899b          	addiw	s3,a5,-1
 670:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 674:	fff4c583          	lbu	a1,-1(s1)
 678:	854a                	mv	a0,s2
 67a:	f6fff0ef          	jal	5e8 <putc>
  while(--i >= 0)
 67e:	39fd                	addiw	s3,s3,-1
 680:	14fd                	addi	s1,s1,-1
 682:	fe09d9e3          	bgez	s3,674 <printint+0x6e>
}
 686:	70e2                	ld	ra,56(sp)
 688:	7442                	ld	s0,48(sp)
 68a:	74a2                	ld	s1,40(sp)
 68c:	7902                	ld	s2,32(sp)
 68e:	69e2                	ld	s3,24(sp)
 690:	6121                	addi	sp,sp,64
 692:	8082                	ret
    x = -xx;
 694:	40b005bb          	negw	a1,a1
    neg = 1;
 698:	4e05                	li	t3,1
    x = -xx;
 69a:	b751                	j	61e <printint+0x18>

000000000000069c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 69c:	711d                	addi	sp,sp,-96
 69e:	ec86                	sd	ra,88(sp)
 6a0:	e8a2                	sd	s0,80(sp)
 6a2:	e4a6                	sd	s1,72(sp)
 6a4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a6:	0005c483          	lbu	s1,0(a1)
 6aa:	26048663          	beqz	s1,916 <vprintf+0x27a>
 6ae:	e0ca                	sd	s2,64(sp)
 6b0:	fc4e                	sd	s3,56(sp)
 6b2:	f852                	sd	s4,48(sp)
 6b4:	f456                	sd	s5,40(sp)
 6b6:	f05a                	sd	s6,32(sp)
 6b8:	ec5e                	sd	s7,24(sp)
 6ba:	e862                	sd	s8,16(sp)
 6bc:	e466                	sd	s9,8(sp)
 6be:	8b2a                	mv	s6,a0
 6c0:	8a2e                	mv	s4,a1
 6c2:	8bb2                	mv	s7,a2
  state = 0;
 6c4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6c6:	4901                	li	s2,0
 6c8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6ca:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6d2:	06c00c93          	li	s9,108
 6d6:	a00d                	j	6f8 <vprintf+0x5c>
        putc(fd, c0);
 6d8:	85a6                	mv	a1,s1
 6da:	855a                	mv	a0,s6
 6dc:	f0dff0ef          	jal	5e8 <putc>
 6e0:	a019                	j	6e6 <vprintf+0x4a>
    } else if(state == '%'){
 6e2:	03598363          	beq	s3,s5,708 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6e6:	0019079b          	addiw	a5,s2,1
 6ea:	893e                	mv	s2,a5
 6ec:	873e                	mv	a4,a5
 6ee:	97d2                	add	a5,a5,s4
 6f0:	0007c483          	lbu	s1,0(a5)
 6f4:	20048963          	beqz	s1,906 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 6f8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6fc:	fe0993e3          	bnez	s3,6e2 <vprintf+0x46>
      if(c0 == '%'){
 700:	fd579ce3          	bne	a5,s5,6d8 <vprintf+0x3c>
        state = '%';
 704:	89be                	mv	s3,a5
 706:	b7c5                	j	6e6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 708:	00ea06b3          	add	a3,s4,a4
 70c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 710:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 712:	c681                	beqz	a3,71a <vprintf+0x7e>
 714:	9752                	add	a4,a4,s4
 716:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 71a:	03878e63          	beq	a5,s8,756 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 71e:	05978863          	beq	a5,s9,76e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 722:	07500713          	li	a4,117
 726:	0ee78263          	beq	a5,a4,80a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 72a:	07800713          	li	a4,120
 72e:	12e78463          	beq	a5,a4,856 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 732:	07000713          	li	a4,112
 736:	14e78963          	beq	a5,a4,888 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 73a:	07300713          	li	a4,115
 73e:	18e78863          	beq	a5,a4,8ce <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 742:	02500713          	li	a4,37
 746:	04e79463          	bne	a5,a4,78e <vprintf+0xf2>
        putc(fd, '%');
 74a:	85ba                	mv	a1,a4
 74c:	855a                	mv	a0,s6
 74e:	e9bff0ef          	jal	5e8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 752:	4981                	li	s3,0
 754:	bf49                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 756:	008b8493          	addi	s1,s7,8
 75a:	4685                	li	a3,1
 75c:	4629                	li	a2,10
 75e:	000ba583          	lw	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	ea3ff0ef          	jal	606 <printint>
 768:	8ba6                	mv	s7,s1
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bfad                	j	6e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 76e:	06400793          	li	a5,100
 772:	02f68963          	beq	a3,a5,7a4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 776:	06c00793          	li	a5,108
 77a:	04f68263          	beq	a3,a5,7be <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 77e:	07500793          	li	a5,117
 782:	0af68063          	beq	a3,a5,822 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 786:	07800793          	li	a5,120
 78a:	0ef68263          	beq	a3,a5,86e <vprintf+0x1d2>
        putc(fd, '%');
 78e:	02500593          	li	a1,37
 792:	855a                	mv	a0,s6
 794:	e55ff0ef          	jal	5e8 <putc>
        putc(fd, c0);
 798:	85a6                	mv	a1,s1
 79a:	855a                	mv	a0,s6
 79c:	e4dff0ef          	jal	5e8 <putc>
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b791                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a4:	008b8493          	addi	s1,s7,8
 7a8:	4685                	li	a3,1
 7aa:	4629                	li	a2,10
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	e55ff0ef          	jal	606 <printint>
        i += 1;
 7b6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b8:	8ba6                	mv	s7,s1
      state = 0;
 7ba:	4981                	li	s3,0
        i += 1;
 7bc:	b72d                	j	6e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7be:	06400793          	li	a5,100
 7c2:	02f60763          	beq	a2,a5,7f0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7c6:	07500793          	li	a5,117
 7ca:	06f60963          	beq	a2,a5,83c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ce:	07800793          	li	a5,120
 7d2:	faf61ee3          	bne	a2,a5,78e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	008b8493          	addi	s1,s7,8
 7da:	4681                	li	a3,0
 7dc:	4641                	li	a2,16
 7de:	000ba583          	lw	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	e23ff0ef          	jal	606 <printint>
        i += 2;
 7e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ea:	8ba6                	mv	s7,s1
      state = 0;
 7ec:	4981                	li	s3,0
        i += 2;
 7ee:	bde5                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f0:	008b8493          	addi	s1,s7,8
 7f4:	4685                	li	a3,1
 7f6:	4629                	li	a2,10
 7f8:	000ba583          	lw	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	e09ff0ef          	jal	606 <printint>
        i += 2;
 802:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 804:	8ba6                	mv	s7,s1
      state = 0;
 806:	4981                	li	s3,0
        i += 2;
 808:	bdf9                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 80a:	008b8493          	addi	s1,s7,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000ba583          	lw	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	defff0ef          	jal	606 <printint>
 81c:	8ba6                	mv	s7,s1
      state = 0;
 81e:	4981                	li	s3,0
 820:	b5d9                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 822:	008b8493          	addi	s1,s7,8
 826:	4681                	li	a3,0
 828:	4629                	li	a2,10
 82a:	000ba583          	lw	a1,0(s7)
 82e:	855a                	mv	a0,s6
 830:	dd7ff0ef          	jal	606 <printint>
        i += 1;
 834:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	8ba6                	mv	s7,s1
      state = 0;
 838:	4981                	li	s3,0
        i += 1;
 83a:	b575                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 83c:	008b8493          	addi	s1,s7,8
 840:	4681                	li	a3,0
 842:	4629                	li	a2,10
 844:	000ba583          	lw	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	dbdff0ef          	jal	606 <printint>
        i += 2;
 84e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 850:	8ba6                	mv	s7,s1
      state = 0;
 852:	4981                	li	s3,0
        i += 2;
 854:	bd49                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 856:	008b8493          	addi	s1,s7,8
 85a:	4681                	li	a3,0
 85c:	4641                	li	a2,16
 85e:	000ba583          	lw	a1,0(s7)
 862:	855a                	mv	a0,s6
 864:	da3ff0ef          	jal	606 <printint>
 868:	8ba6                	mv	s7,s1
      state = 0;
 86a:	4981                	li	s3,0
 86c:	bdad                	j	6e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 86e:	008b8493          	addi	s1,s7,8
 872:	4681                	li	a3,0
 874:	4641                	li	a2,16
 876:	000ba583          	lw	a1,0(s7)
 87a:	855a                	mv	a0,s6
 87c:	d8bff0ef          	jal	606 <printint>
        i += 1;
 880:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 882:	8ba6                	mv	s7,s1
      state = 0;
 884:	4981                	li	s3,0
        i += 1;
 886:	b585                	j	6e6 <vprintf+0x4a>
 888:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 88a:	008b8d13          	addi	s10,s7,8
 88e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 892:	03000593          	li	a1,48
 896:	855a                	mv	a0,s6
 898:	d51ff0ef          	jal	5e8 <putc>
  putc(fd, 'x');
 89c:	07800593          	li	a1,120
 8a0:	855a                	mv	a0,s6
 8a2:	d47ff0ef          	jal	5e8 <putc>
 8a6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a8:	00000b97          	auipc	s7,0x0
 8ac:	338b8b93          	addi	s7,s7,824 # be0 <digits>
 8b0:	03c9d793          	srli	a5,s3,0x3c
 8b4:	97de                	add	a5,a5,s7
 8b6:	0007c583          	lbu	a1,0(a5)
 8ba:	855a                	mv	a0,s6
 8bc:	d2dff0ef          	jal	5e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8c0:	0992                	slli	s3,s3,0x4
 8c2:	34fd                	addiw	s1,s1,-1
 8c4:	f4f5                	bnez	s1,8b0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8c6:	8bea                	mv	s7,s10
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	6d02                	ld	s10,0(sp)
 8cc:	bd29                	j	6e6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ce:	008b8993          	addi	s3,s7,8
 8d2:	000bb483          	ld	s1,0(s7)
 8d6:	cc91                	beqz	s1,8f2 <vprintf+0x256>
        for(; *s; s++)
 8d8:	0004c583          	lbu	a1,0(s1)
 8dc:	c195                	beqz	a1,900 <vprintf+0x264>
          putc(fd, *s);
 8de:	855a                	mv	a0,s6
 8e0:	d09ff0ef          	jal	5e8 <putc>
        for(; *s; s++)
 8e4:	0485                	addi	s1,s1,1
 8e6:	0004c583          	lbu	a1,0(s1)
 8ea:	f9f5                	bnez	a1,8de <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8ec:	8bce                	mv	s7,s3
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	bbdd                	j	6e6 <vprintf+0x4a>
          s = "(null)";
 8f2:	00000497          	auipc	s1,0x0
 8f6:	2e648493          	addi	s1,s1,742 # bd8 <malloc+0x1d6>
        for(; *s; s++)
 8fa:	02800593          	li	a1,40
 8fe:	b7c5                	j	8de <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 900:	8bce                	mv	s7,s3
      state = 0;
 902:	4981                	li	s3,0
 904:	b3cd                	j	6e6 <vprintf+0x4a>
 906:	6906                	ld	s2,64(sp)
 908:	79e2                	ld	s3,56(sp)
 90a:	7a42                	ld	s4,48(sp)
 90c:	7aa2                	ld	s5,40(sp)
 90e:	7b02                	ld	s6,32(sp)
 910:	6be2                	ld	s7,24(sp)
 912:	6c42                	ld	s8,16(sp)
 914:	6ca2                	ld	s9,8(sp)
    }
  }
}
 916:	60e6                	ld	ra,88(sp)
 918:	6446                	ld	s0,80(sp)
 91a:	64a6                	ld	s1,72(sp)
 91c:	6125                	addi	sp,sp,96
 91e:	8082                	ret

0000000000000920 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 920:	715d                	addi	sp,sp,-80
 922:	ec06                	sd	ra,24(sp)
 924:	e822                	sd	s0,16(sp)
 926:	1000                	addi	s0,sp,32
 928:	e010                	sd	a2,0(s0)
 92a:	e414                	sd	a3,8(s0)
 92c:	e818                	sd	a4,16(s0)
 92e:	ec1c                	sd	a5,24(s0)
 930:	03043023          	sd	a6,32(s0)
 934:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 938:	8622                	mv	a2,s0
 93a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 93e:	d5fff0ef          	jal	69c <vprintf>
}
 942:	60e2                	ld	ra,24(sp)
 944:	6442                	ld	s0,16(sp)
 946:	6161                	addi	sp,sp,80
 948:	8082                	ret

000000000000094a <printf>:

void
printf(const char *fmt, ...)
{
 94a:	711d                	addi	sp,sp,-96
 94c:	ec06                	sd	ra,24(sp)
 94e:	e822                	sd	s0,16(sp)
 950:	1000                	addi	s0,sp,32
 952:	e40c                	sd	a1,8(s0)
 954:	e810                	sd	a2,16(s0)
 956:	ec14                	sd	a3,24(s0)
 958:	f018                	sd	a4,32(s0)
 95a:	f41c                	sd	a5,40(s0)
 95c:	03043823          	sd	a6,48(s0)
 960:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 964:	00840613          	addi	a2,s0,8
 968:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 96c:	85aa                	mv	a1,a0
 96e:	4505                	li	a0,1
 970:	d2dff0ef          	jal	69c <vprintf>
}
 974:	60e2                	ld	ra,24(sp)
 976:	6442                	ld	s0,16(sp)
 978:	6125                	addi	sp,sp,96
 97a:	8082                	ret

000000000000097c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 97c:	1141                	addi	sp,sp,-16
 97e:	e406                	sd	ra,8(sp)
 980:	e022                	sd	s0,0(sp)
 982:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 984:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	00000797          	auipc	a5,0x0
 98c:	6787b783          	ld	a5,1656(a5) # 1000 <freep>
 990:	a02d                	j	9ba <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 992:	4618                	lw	a4,8(a2)
 994:	9f2d                	addw	a4,a4,a1
 996:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 99a:	6398                	ld	a4,0(a5)
 99c:	6310                	ld	a2,0(a4)
 99e:	a83d                	j	9dc <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9a0:	ff852703          	lw	a4,-8(a0)
 9a4:	9f31                	addw	a4,a4,a2
 9a6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9a8:	ff053683          	ld	a3,-16(a0)
 9ac:	a091                	j	9f0 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ae:	6398                	ld	a4,0(a5)
 9b0:	00e7e463          	bltu	a5,a4,9b8 <free+0x3c>
 9b4:	00e6ea63          	bltu	a3,a4,9c8 <free+0x4c>
{
 9b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ba:	fed7fae3          	bgeu	a5,a3,9ae <free+0x32>
 9be:	6398                	ld	a4,0(a5)
 9c0:	00e6e463          	bltu	a3,a4,9c8 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c4:	fee7eae3          	bltu	a5,a4,9b8 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9c8:	ff852583          	lw	a1,-8(a0)
 9cc:	6390                	ld	a2,0(a5)
 9ce:	02059813          	slli	a6,a1,0x20
 9d2:	01c85713          	srli	a4,a6,0x1c
 9d6:	9736                	add	a4,a4,a3
 9d8:	fae60de3          	beq	a2,a4,992 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9dc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9e0:	4790                	lw	a2,8(a5)
 9e2:	02061593          	slli	a1,a2,0x20
 9e6:	01c5d713          	srli	a4,a1,0x1c
 9ea:	973e                	add	a4,a4,a5
 9ec:	fae68ae3          	beq	a3,a4,9a0 <free+0x24>
    p->s.ptr = bp->s.ptr;
 9f0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9f2:	00000717          	auipc	a4,0x0
 9f6:	60f73723          	sd	a5,1550(a4) # 1000 <freep>
}
 9fa:	60a2                	ld	ra,8(sp)
 9fc:	6402                	ld	s0,0(sp)
 9fe:	0141                	addi	sp,sp,16
 a00:	8082                	ret

0000000000000a02 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a02:	7139                	addi	sp,sp,-64
 a04:	fc06                	sd	ra,56(sp)
 a06:	f822                	sd	s0,48(sp)
 a08:	f04a                	sd	s2,32(sp)
 a0a:	ec4e                	sd	s3,24(sp)
 a0c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a0e:	02051993          	slli	s3,a0,0x20
 a12:	0209d993          	srli	s3,s3,0x20
 a16:	09bd                	addi	s3,s3,15
 a18:	0049d993          	srli	s3,s3,0x4
 a1c:	2985                	addiw	s3,s3,1
 a1e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a20:	00000517          	auipc	a0,0x0
 a24:	5e053503          	ld	a0,1504(a0) # 1000 <freep>
 a28:	c905                	beqz	a0,a58 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a2a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a2c:	4798                	lw	a4,8(a5)
 a2e:	09377663          	bgeu	a4,s3,aba <malloc+0xb8>
 a32:	f426                	sd	s1,40(sp)
 a34:	e852                	sd	s4,16(sp)
 a36:	e456                	sd	s5,8(sp)
 a38:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a3a:	8a4e                	mv	s4,s3
 a3c:	6705                	lui	a4,0x1
 a3e:	00e9f363          	bgeu	s3,a4,a44 <malloc+0x42>
 a42:	6a05                	lui	s4,0x1
 a44:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a48:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a4c:	00000497          	auipc	s1,0x0
 a50:	5b448493          	addi	s1,s1,1460 # 1000 <freep>
  if(p == (char*)-1)
 a54:	5afd                	li	s5,-1
 a56:	a83d                	j	a94 <malloc+0x92>
 a58:	f426                	sd	s1,40(sp)
 a5a:	e852                	sd	s4,16(sp)
 a5c:	e456                	sd	s5,8(sp)
 a5e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a60:	00000797          	auipc	a5,0x0
 a64:	5b078793          	addi	a5,a5,1456 # 1010 <base>
 a68:	00000717          	auipc	a4,0x0
 a6c:	58f73c23          	sd	a5,1432(a4) # 1000 <freep>
 a70:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a72:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a76:	b7d1                	j	a3a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a78:	6398                	ld	a4,0(a5)
 a7a:	e118                	sd	a4,0(a0)
 a7c:	a899                	j	ad2 <malloc+0xd0>
  hp->s.size = nu;
 a7e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a82:	0541                	addi	a0,a0,16
 a84:	ef9ff0ef          	jal	97c <free>
  return freep;
 a88:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a8a:	c125                	beqz	a0,aea <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a8e:	4798                	lw	a4,8(a5)
 a90:	03277163          	bgeu	a4,s2,ab2 <malloc+0xb0>
    if(p == freep)
 a94:	6098                	ld	a4,0(s1)
 a96:	853e                	mv	a0,a5
 a98:	fef71ae3          	bne	a4,a5,a8c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a9c:	8552                	mv	a0,s4
 a9e:	b0bff0ef          	jal	5a8 <sbrk>
  if(p == (char*)-1)
 aa2:	fd551ee3          	bne	a0,s5,a7e <malloc+0x7c>
        return 0;
 aa6:	4501                	li	a0,0
 aa8:	74a2                	ld	s1,40(sp)
 aaa:	6a42                	ld	s4,16(sp)
 aac:	6aa2                	ld	s5,8(sp)
 aae:	6b02                	ld	s6,0(sp)
 ab0:	a03d                	j	ade <malloc+0xdc>
 ab2:	74a2                	ld	s1,40(sp)
 ab4:	6a42                	ld	s4,16(sp)
 ab6:	6aa2                	ld	s5,8(sp)
 ab8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aba:	fae90fe3          	beq	s2,a4,a78 <malloc+0x76>
        p->s.size -= nunits;
 abe:	4137073b          	subw	a4,a4,s3
 ac2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ac4:	02071693          	slli	a3,a4,0x20
 ac8:	01c6d713          	srli	a4,a3,0x1c
 acc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ace:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ad2:	00000717          	auipc	a4,0x0
 ad6:	52a73723          	sd	a0,1326(a4) # 1000 <freep>
      return (void*)(p + 1);
 ada:	01078513          	addi	a0,a5,16
  }
}
 ade:	70e2                	ld	ra,56(sp)
 ae0:	7442                	ld	s0,48(sp)
 ae2:	7902                	ld	s2,32(sp)
 ae4:	69e2                	ld	s3,24(sp)
 ae6:	6121                	addi	sp,sp,64
 ae8:	8082                	ret
 aea:	74a2                	ld	s1,40(sp)
 aec:	6a42                	ld	s4,16(sp)
 aee:	6aa2                	ld	s5,8(sp)
 af0:	6b02                	ld	s6,0(sp)
 af2:	b7f5                	j	ade <malloc+0xdc>
