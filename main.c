#include <unistd.h>

int main(void) {
	char *const args[] = { "emacs", "-Q", "--fg-daemon", "-l", "/etc/init.el", NULL };
	return execve("/usr/bin/emacs", args, NULL);
}
