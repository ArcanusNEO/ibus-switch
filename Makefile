MAKEFLAGS += -r
.SUFFIXES: .c .o

CFLAGS ?= -O2 -fno-plt -pipe -flto=auto
CFLAGS += -Wall -Wvla
LDFLAGS ?= -Wl,-O1
LDLIBS += -lsystemd

SRC := $(wildcard *.c)
OBJ := $(patsubst %.c, %.o, $(SRC))

PHONY := all clean

all: ibus-switch

ibus-switch: main.o
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

main.o: main.c cmacs.h
	$(COMPILE.c) $< -o $@

clean:
	$(RM) -- $(OBJ) ibus-switch

cmacs.h:
	$(RM) -- $@
	@wget -qc --show-progress -t 3 --waitretry=3 -O $@ 'https://raw.githubusercontent.com/ArcanusNEO/cmacs/master/cmacs.h'

.c.o:
	$(COMPILE.c) $< -o $@

.SECONDARY: $(OBJ)
.PHONY: $(PHONY)
