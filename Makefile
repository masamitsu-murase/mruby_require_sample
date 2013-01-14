# makefile discription.
# basic build file for mruby

# compiler, linker (gcc), archiver, parser generator
export CC = gcc
export LL = gcc

ifeq ($(strip $(COMPILE_MODE)),)
  # default compile option
  COMPILE_MODE = debug
endif

ifeq ($(COMPILE_MODE),debug)
  CFLAGS = -g -O3
else ifeq ($(COMPILE_MODE),release)
  CFLAGS = -O3
else ifeq ($(COMPILE_MODE),small)
  CFLAGS = -Os
endif

BASEDIR = $(shell pwd)
INCLUDES = -I$(BASEDIR)/include

MRUBY_CFLAGS = -I$(BASEDIR)/vendors/include
MRUBY_LIBS = -L$(BASEDIR)/vendors/lib -lmruby
MRUBY_SRC_DIR = $(BASEDIR)/tmp/mruby/src

ALL_CFLAGS = $(CFLAGS) $(INCLUDES) $(MRUBY_CFLAGS)
ifeq ($(OS),Windows_NT)
  MAKE_FLAGS = --no-print-directory CC=$(CC) LL=$(LL) CFLAGS='$(ALL_CFLAGS)' MRUBY_CFLAGS='$(MRUBY_CFLAGS)' MRUBY_LIBS='$(MRUBY_LIBS)' MRUBY_SRC_DIR='$(MRUBY_SRC_DIR)'
else
  MAKE_FLAGS = --no-print-directory CC='$(CC)' LL='$(LL)' CFLAGS='$(ALL_CFLAGS)' MRUBY_CFLAGS='$(MRUBY_CFLAGS)' MRUBY_LIBS='$(MRUBY_LIBS)' MRUBY_SRC_DIR='$(MRUBY_SRC_DIR)'
endif

##############################
# internal variables

export CP := cp
export RM_F := rm -f
export CAT := cat


##############################
# generic build targets, rules

.PHONY : all
all : vendors/lib/libmruby.a
	@$(MAKE) -C src $(MAKE_FLAGS)

# mruby test
.PHONY : test
test : all
	@$(MAKE) -C test $(MAKE_FLAGS) run

# clean up
.PHONY : clean
clean :
	@$(MAKE) clean -C src $(MAKE_FLAGS)
	@$(MAKE) clean -C test $(MAKE_FLAGS)


##################
# libmruby.a
tmp/mruby:
	mkdir -p tmp/mruby
	cd tmp; git clone git://github.com/mruby/mruby.git

vendors/lib/libmruby.a: tmp/mruby
	cd tmp/mruby && make
	mkdir -p vendors
	cp -r tmp/mruby/include vendors/
	cp -r tmp/mruby/build/host/lib vendors/
	cp -r tmp/mruby/build/host/bin vendors/
