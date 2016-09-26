/* See LICENSE file for copyright and license details. */

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>

static void usage(char *);
static void set_title(Display* d, Window w, char* name);

static void
usage(char *name)
{
	fprintf(stderr, "usage: %s <name> <wid>\n", name);
	exit(1);
}

static void
set_title(Display* d, Window w, char* name)
{
	XSync(d, False);
	int ret=XChangeProperty(d, w,
		XInternAtom(d, "WM_NAME", False),
		XInternAtom(d, "STRING", False), 8,
		PropModeReplace, (unsigned char*)name, strlen(name)+1);
	if(ret==0)
		return;
	ret=XChangeProperty(d, w,
		XInternAtom(d, "_NET_WM_NAME", False),
		XInternAtom(d, "STRING", False), 8,
		PropModeReplace, (unsigned char*)name, strlen(name)+1);
}

int
main(int argc, char **argv)
{
	Display* d;
	char* name=argv[1];

	if (argc != 3)
		usage(argv[0]);

	d=XOpenDisplay(NULL);

	set_title(d, strtoul(argv[2], NULL, 16), name);

	XFlush(d);
	XCloseDisplay(d);

	return 0;
}
