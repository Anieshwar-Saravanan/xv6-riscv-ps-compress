#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define BLOCK_SIZE 512
#define MAX_FILENAME 256

void decompress_file(int src_fd, int dest_fd) {
    char buf[BLOCK_SIZE];
    char curr_char;
    int count, n;
    int i = 0;

    while ((n = read(src_fd, buf, BLOCK_SIZE)) > 0) {
        while (i < n) {
            curr_char = buf[i++];
            
            if (i >= n) {
                n = read(src_fd, buf, BLOCK_SIZE);
                if (n <= 0) {
                    fprintf(2, "decompress: unexpected EOF\n");
                    exit(1);
                }
                i = 0;
            }
            
            count = buf[i++] - '0';
            if (count < 1 || count > 9) {
                fprintf(2, "decompress: invalid count %d\n", count);
                exit(1);
            }

            for (int j = 0; j < count; j++) {
                if (write(dest_fd, &curr_char, 1) != 1) {
                    fprintf(2, "decompress: write error\n");
                    exit(1);
                }
            }
        }
        i = 0;
    }

    if (n < 0) {
        fprintf(2, "decompress: read error\n");
        exit(1);
    }
}

void create_output_filename(const char* input, char* output) {
    int i = 0;
    
    // Copy input filename
    while (input[i] != '\0' && i < MAX_FILENAME - 5) {
        output[i] = input[i];
        i++;
    }
    
    // Append .dec extension
    output[i++] = '.';
    output[i++] = 'd';
    output[i++] = 'e';
    output[i++] = 'c';
    output[i] = '\0';
}

int main(int argc, char *argv[]) {
    int src_fd, dest_fd;
    char output_filename[MAX_FILENAME];

    if (argc != 2) {
        fprintf(2, "Usage: %s <compressed-input>\n", argv[0]);
        exit(1);
    }

    // Open input file
    if ((src_fd = open(argv[1], O_RDONLY)) < 0) {
        fprintf(2, "decompress: cannot open %s\n", argv[1]);
        exit(1);
    }

    // Create output filename
    create_output_filename(argv[1], output_filename);
    
    // Create output file
    if ((dest_fd = open(output_filename, O_CREATE | O_WRONLY)) < 0) {
        fprintf(2, "decompress: cannot create %s\n", output_filename);
        close(src_fd);
        exit(1);
    }

    decompress_file(src_fd, dest_fd);

    close(src_fd);
    close(dest_fd);
    exit(0);
}