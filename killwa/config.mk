PREFIX = /usr

CC      = cc
LD      = $(CC)

CFLAGS  = -std=c99 -pedantic -Wall -Os
LDFLAGS = -lxcb -lxcb-icccm
