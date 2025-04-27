#include "kernel/types.h"
#include "kernel/procinfo.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid;
  struct procinfo pi;

  if (argc != 2) {
    printf("Usage: pinfo <pid>\n");
    exit(1);
  }

  pid = atoi(argv[1]);

  if (pinfo(pid, &pi) < 0) {
    printf("pinfo: failed to get info\n");
    exit(1);
  }

  printf("PID: %d\n", pi.pid);
  printf("PPID: %d\n", pi.ppid);
  printf("State: %d\n", pi.state);
  printf("Memory: %ld bytes\n", pi.sz);
  printf("Name: %s\n", pi.name);

  exit(0);
}
