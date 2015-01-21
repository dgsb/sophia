
# sophia makefile
#

CC ?= cc

ifdef ENABLE_COVERAGE
CFLAGS_COVERAGE = --coverage 
else
CFLAGS_COVERAGE =
endif

CFLAGS_DEBUG   = -DSR_INJECTION_ENABLE -g
CFLAGS_OPT     = -O2
CFLAGS_STRICT  = -std=c99 -pedantic -Wextra -Wall
CFLAGS_MISC    = -fPIC -fno-stack-protector -fvisibility=hidden
LDFLAGS_ALL    = -shared -soname $(SOPHIA_DSO).1
SOPHIA_CFLAGS  = $(CFLAGS_INCLUDE) \
                 $(CFLAGS_DEBUG) \
                 $(CFLAGS_OPT) \
                 $(CFLAGS_COVERAGE) \
                 $(CFLAGS_STRICT) \
                 $(CFLAGS_MISC) \
                 $(CFLAGS)
SOPHIA_LDFLAGS = $(LDFLAGS_ALL) $(LDFLAGS)

all: banner clean amalgamation compile static dynamic
banner:
	@echo SOPHIA v1.2
	@echo "cc: $(CC)"
	@echo "cflags: $(CFLAGS_DEBUG) $(CFLAGS_COVERAGE)$(CFLAGS_OPT) $(CFLAGS_STRICT)"
	@echo
amalgamation:
	@echo build
	@sh sophia/build sophia sophia.c
compile:
	@echo cc sophia.c
	@$(CC) $(SOPHIA_CFLAGS) -c sophia.c -o sophia.o
static:
	@echo "ar libsophia.a"
	@ar crs libsophia.a sophia.o
dynamic:
	@echo "ld libsophia.so"
	@ld sophia.o $(SOPHIA_LDFLAGS) -o libsophia.so.1.2
	@ln -sf libsophia.so.1.2 libsophia.so.1
	@ln -sf libsophia.so.1.2 libsophia.so
	@strip --strip-unneeded libsophia.so.1.2
clean:
	@rm -f sophia.c sophia.o
	@rm -f libsophia.a
	@rm -f libsophia.so
	@rm -f libsophia.so.1
	@rm -f libsophia.so.1.2
