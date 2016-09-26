CC=cc
LD=cc
CFLAGS=-std=c99 -pedantic -Wall -O2
LDFLAGS=-L/usr/X11R6/lib -lX11

PREFIX=/usr/local

SRC=chwn.c
OBJ=$(SRC:.c=.o)
BIN=$(SRC:.c=)
MAN=$(SRC:.c=.1)

all: $(BIN)

.o:
	$(LD) $< -o $@ $(LDFLAGS)

.c.o:
	$(CC) -c $< -o $@ $(CFLAGS)

install: $(BIN)
	mkdir -p $(PREFIX)/bin/
	cp -f $(BIN) $(PREFIX)/bin
	mkdir -p $(PREFIX)/man/man1
	cp -f $(MAN) $(PREFIX)/man/man1

uninstall:
	cd $(PREFIX) && rm -f $(BIN)
	cd $(PREFIX)/man/man1 && rm -f $(MAN)

clean:
	rm -f $(BIN) $(OBJ)

.PHONY: all install uninstall clean
