#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define BLOCK_SIZE 512

void compress_file(int src_fd, int dest_fd) {
    char buf[BLOCK_SIZE];
    char curr, prev = 0;
    int count = 0;
    int n;
    char output[2];

    while ((n = read(src_fd, buf, BLOCK_SIZE)) > 0) {
        for (int i = 0; i < n; i++) {
            curr = buf[i];
            if (curr == prev) {
                count++;
                if (count > 9) count = 9; // Limit to single digit
            } else {
                if (count > 0) {
                    output[0] = prev;
                    output[1] = '0' + count;
                    write(dest_fd, output, 2);
                }
                prev = curr;
                count = 1;
            }
        }
    }

    // Write final pair
    if (count > 0) {
        output[0] = prev;
        output[1] = '0' + count;
        write(dest_fd, output, 2);
    }
}

int main(int argc, char *argv[]) {
    int src_fd, dest_fd;

    if (argc != 3) {
        fprintf(2, "Usage: %s <input> <output>\n", argv[0]);
        exit(1);
    }

    // Open input file
    if ((src_fd = open(argv[1], O_RDONLY)) < 0) {
        fprintf(2, "compress: cannot open %s\n", argv[1]);
        exit(1);
    }

    // Create output file
    if ((dest_fd = open(argv[2], O_CREATE | O_WRONLY)) < 0) {
        fprintf(2, "compress: cannot create %s\n", argv[2]);
        close(src_fd);
        exit(1);
    }

    compress_file(src_fd, dest_fd);

    close(src_fd);
    close(dest_fd);
    exit(0);
}