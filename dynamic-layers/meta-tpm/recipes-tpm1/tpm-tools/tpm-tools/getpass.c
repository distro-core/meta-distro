// SPDX-License-Identifier: MIT
// getpass.c - override for glibc getpass(3)
// allows input/output from stdin/stdout without being hardcoded to /dev/tty

#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <string.h>

#define MAX_PASS_LEN 128

static void disable_echo(struct termios *orig_termios) {
    struct termios new_termios;
    tcgetattr(STDIN_FILENO, orig_termios);
    new_termios = *orig_termios;
    new_termios.c_lflag &= ~ECHO;
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &new_termios);
}

static void restore_echo(const struct termios *orig_termios) {
    tcsetattr(STDIN_FILENO, TCSAFLUSH, orig_termios);
}

char *getpass(const char *prompt) {
    static char password[MAX_PASS_LEN];
    struct termios orig_termios;

    // Display the prompt
    if (prompt) {
        printf("%s", prompt);
        fflush(stdout);
    }

    // Disable echo
    disable_echo(&orig_termios);

    // Read the password
    if (fgets(password, MAX_PASS_LEN, stdin) == NULL) {
        restore_echo(&orig_termios);
        return NULL;
    }

    // Restore echo
    restore_echo(&orig_termios);

    // Remove the trailing newline character, if any
    password[strcspn(password, "\n")] = '\0';

    return password;
}
