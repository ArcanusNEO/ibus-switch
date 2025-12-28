MAKEFLAGS += -r
.PHONY: all clean
.SUFFIXES: .c .o .d
SRC := $(shell find . -type f -name '*.c')
OBJ := $(patsubst %.c, %.o, $(SRC))
DEP := $(patsubst %.c, %.d, $(SRC))

CFLAGS ?= -O2 -fno-plt -pipe -flto=auto
CFLAGS += -fwrapv -fms-extensions -Wall -Wvla -Wno-parentheses -I$(CURDIR)
LDFLAGS ?= -Wl,-O1
LDLIBS += -lm -lsystemd

all: ibus-switch

ibus-switch: $(OBJ)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

.c.o:
	$(COMPILE.c) $< -o $@

clean:
	$(RM) -- $(OBJ) $(DEP) ibus-switch

-include $(DEP)
%.d: %.c cmacs.h
	$(COMPILE.c) -MM $< -o $@

cmacs.h:
	$(RM) -- $@
	wget -qc --show-progress -t 3 --waitretry=3 -O $@ https://raw.githubusercontent.com/ArcanusNEO/cmacs/master/cmacs.h

.SECONDARY: $(OBJ)
