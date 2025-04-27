// Test that fork fails gracefully.
// Tiny executable so that the limit can be filling the proc table.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define N  1000

void
print(const char *s)
{
  write(1, s, strlen(s));
}

void
forktest(void)
{
  int n, pid;

  print("fork test\n");

  for(n=0; n<N; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
    exit(1);
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
}

int
main(void)
{
  forktest();
  exit(0);
}

// #include "kernel/types.h"
// #include "user/user.h"
// #include "kernel/stat.h"

// int
// main(void)
// {
//     int pid = fork();
//     if(pid < 0){
//         print("fork failed\n");
//         exit(1);
//     }
//     if(pid == 0){
//         printf("fork test\n");
//         exit(0);  // Child exits
//     } else {
//         wait(0);  // Parent waits for child to avoid zombie
//         print("fork test OK\n");
//     }
//     exit(0);
// }
