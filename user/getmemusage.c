#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if (argc != 2) {
        printf("Usage: test_getmemusage <pid>\n");
        exit(1);
    }

    int pid = atoi(argv[1]);
    int mem = getmemusage(pid);
    if (mem == -1) {
        printf("Process %d not found.\n", pid);
    } else {
        printf("Memory used by process %d: %d bytes\n", pid, mem);
    }
    sleep(100);

    exit(0);
}
