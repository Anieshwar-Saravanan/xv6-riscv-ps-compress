#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    int pid = getpid();
    struct secureinfo info;

    if (getsecureinfo(pid, (uint64)&info) < 0) {
        printf("getsecureinfo failed\n");
        exit(1);
    }

    printf("Secure info:\n");
    printf("Secret: %d\n", info.secret);
    printf("Timestamp: %d\n", info.timestamp);

    exit(0);
}
