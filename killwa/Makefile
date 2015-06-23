include config.mk

HDR = arg.h util.h
SRC =           \
	killwa.c

OBJ = $(SRC:.c=.o)
BIN = $(SRC:.c=)

.POSIX:
.SUFFIXES: .1 .1.gz

all: binutils

binutils: $(BIN)

$(OBJ): $(HDR) util.o

.o:
	@echo "LD $@"
	@$(LD) $< util.o -o $@ $(LDFLAGS)

.c.o:
	@echo "CC $<"
	@$(CC) -c $< -o $@ $(CFLAGS)

install: $(BIN)
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	cp -f $(BIN) $(DESTDIR)$(PREFIX)/bin/

uninstall:
	@echo "uninstalling binaries"
	@for util in $(BIN); do \
		rm -f $(DESTDIR)$(PREFIX)/bin/$$util; \
	done

clean :
	rm -f $(OBJ) $(BIN) util.o
