// Made by https://github.com/onodera-punpun
//
// Used core/killw as base
// Copied some monsterwm code for the atom stuff

#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <err.h>
#include <xcb/xcb.h>
#include <xcb/xcb_icccm.h>

#include "util.h"

static xcb_connection_t *conn;

static void usage(char *);

static void
usage (char *name)
{
	fprintf(stderr, "usage: %s <wid> [wid...]\n", name);
	exit(1);
}

static
xcb_atom_t xcb_atom_get(xcb_connection_t *conn, char *name) {
	xcb_intern_atom_cookie_t cookie=xcb_intern_atom(conn ,0, strlen(name), name);
	xcb_intern_atom_reply_t *reply=xcb_intern_atom_reply(conn, cookie, NULL);
	if(!reply) return XCB_NONE;
	return reply->atom;
}

void
deletewindow(xcb_window_t w)
{
	xcb_client_message_event_t ev;

	ev.response_type = XCB_CLIENT_MESSAGE;
	ev.sequence = 0;
	ev.format = 32;
	ev.window = w;
	ev.type = xcb_atom_get(conn, "WM_PROTOCOLS");
	ev.data.data32[0] = xcb_atom_get(conn, "WM_DELETE_WINDOW");
	ev.data.data32[1] = XCB_CURRENT_TIME;
	xcb_send_event(conn, 0, w, XCB_EVENT_MASK_NO_EVENT, (char *)&ev);
}

int
main(int argc, char **argv)
{	
	xcb_window_t w = 0;

	if (argc < 2)
		usage(argv[0]);

	init_xcb(&conn);

	/* assume remaining arguments are windows */
	while (*argv)
		w = strtoul(*argv++, NULL, 16);

		xcb_icccm_get_wm_protocols_reply_t reply; unsigned int n = 0; bool got = false;
		if (xcb_icccm_get_wm_protocols_reply(conn,
			xcb_icccm_get_wm_protocols(conn, w, xcb_atom_get(conn, "WM_PROTOCOLS")),
			&reply, NULL)) { /* TODO: Handle error? */
			for(; n != reply.atoms_len; ++n) if ((got = reply.atoms[n] == xcb_atom_get(conn, "WM_DELETE_WINDOW"))) break;
			xcb_icccm_get_wm_protocols_reply_wipe(&reply);
		}
		if (got) deletewindow(w);
		else xcb_kill_client(conn, w);

	xcb_flush(conn);

	kill_xcb(&conn);

	return 0;
}
