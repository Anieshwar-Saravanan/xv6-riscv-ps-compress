#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define MAX_PROCESSES 64  // or some big number


int
main(void)
{
  int pids[MAX_PROCESSES];
  int count = getactiveprocesses(pids, MAX_PROCESSES);
  
  if (count < 0) {
    printf("Error retrieving active processes\n");
    exit(1);
  }

  printf("Active processes:\n");
  for (int i = 0; i < count; i++) {
    printf("%d\n", pids[i]);
  }

  exit(0);
}
