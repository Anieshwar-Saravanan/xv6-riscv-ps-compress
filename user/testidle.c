#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
    int pid = getidlepid();
    if(pid == -1)
        printf("No idle process found.\n");
    else
        printf("Idle process PID: %d\n", pid);
    exit(0);
}
