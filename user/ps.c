#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/procinfo.h"

int
main(int argc, char *argv[])
{
    struct procinfo procs[64];
    int n = ps(procs, 64);

    if (n < 0) {
        printf("ps syscall failed\n");
        exit(1);
    }

    printf("PID\tSTATE\t\tMEM\tNAME\n");
    for (int i = 0; i < n; i++) {
        char *state;
        // Check if state is an integer and map it to a string
        switch (procs[i].state) {
            case 1: state = "SLEEPING"; break;
            case 2: state = "RUNNABLE"; break;
            case 3: state = "RUNNING"; break;
            case 4: state = "ZOMBIE"; break;
            default: state = "UNKNOWN"; break;
        }

        // Use appropriate format specifiers:
        printf("%d\t%s\t%ld\t%s\n", procs[i].pid, state, procs[i].sz, procs[i].name);
    }

    exit(0);
}
