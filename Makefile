MAKEFLAGS += -r
.PHONY: all clean
.SUFFIXES: .c .o .d
SRC := $(shell find . -path ./src -prune -o -type f -name "*.c" -print)
OBJ := $(patsubst %.c, %.o, $(SRC))
DEP := $(patsubst %.c, %.d, $(SRC))

WGET := wget -qc --show-progress -t 3 --waitretry=3

CFLAGS ?= -O3 -fno-plt -pipe -flto=auto
CFLAGS += -D_GNU_SOURCE=1 -fwrapv -fms-extensions -Wall -Wvla -Wno-parentheses -Wno-microsoft -I$(CURDIR)
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
	@$(WGET) -O $@ https://raw.github.com/ArcanusNEO/cmacs/master/cmacs.h || ($(RM) $@ && false)

.SECONDARY: $(OBJ)
