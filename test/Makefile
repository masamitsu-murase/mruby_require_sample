# makefile discription.
# basic build file for require library

# project-specific macros
# extension of the executable-file is modifiable(.exe .out ...)
BASEDIR = .
TARGET := $(BASEDIR)/mruby_require_test
MRBCSRC := $(patsubst %.rb,%.c,$(wildcard $(BASEDIR)/*.rb))
LIBR := $(BASEDIR)/../lib/libmruby_require.a

EXCEPT1 := $(MRBCSRC)

OBJ1 := $(patsubst %.c,%.o,$(filter-out $(EXCEPT1),$(wildcard $(BASEDIR)/*.c)))
OBJMRB := $(patsubst %.c,%.o,$(MRBCSRC))
OBJS := $(OBJ1) $(OBJ2) $(OBJ3)

MRBC := $(BASEDIR)/../vendors/bin/mrbc

# libraries, includes
LIBS = -ldl -lm

ifeq ($(shell uname -s),Darwin)
  LDFLAGS = -Wl,-allow_stack_execute
else
  LDFLAGS = 
endif

ifeq ($(strip $(COMPILE_MODE)),)
  # default compile option
  COMPILE_MODE = debug
endif

ifeq ($(COMPILE_MODE),debug)
  CFLAGS = -g -O3 -rdynamic
else ifeq ($(COMPILE_MODE),release)
  CFLAGS = -O3 -rdynamic
else ifeq ($(COMPILE_MODE),small)
  CFLAGS = -Os -rdynamic
endif

ALL_CFLAGS = -Wall -Werror-implicit-function-declaration -std=c99 $(CFLAGS) $(MRUBY_CFLAGS)



##############################
# internal variables

export CP := cp
export RM_F := rm -f
export CAT := cat


##############################
# generic build targets, rules

.PHONY : all
all : $(TARGET)

.PHONY : run
run : $(TARGET)
	./$(TARGET)

# executable constructed using linker from object files
$(TARGET) : $(OBJS) $(OBJMRB) $(LIBR)
	$(LL) -o $@ $(CFLAGS) $(LDFLAGS) $^ $(MRUBY_LIBS) $(LIBS)

-include $(OBJS:.o=.d) $(OBJMRB:.o=.d)

# mrby complie
$(OBJMRB) : %.o : %.rb
	$(MRBC) -Bdata_$(*F) $<
	$(CC) $(ALL_CFLAGS) -MMD $(INCLUDES) -c $(basename $<).c -o $@

# objects compiled from source
$(OBJS) : %.o : %.c
	$(CC) $(ALL_CFLAGS) -MMD $(INCLUDES) -c $< -o $@

# clean up
.PHONY : clean #cleandep
clean :
	@echo "make: removing targets, objects and depend files of `pwd`"
	-$(RM_F) $(TARGET) $(OBJS) $(OBJMRB)
	-$(RM_F) $(OBJMRB:.o=.c)
	-$(RM_F) $(OBJMRB)
	-$(RM_F) $(OBJS:.o=.d) $(OBJY:.o=.d)
	-$(RM_F) $(patsubst %.c,%.o,$(EXCEPT1)) $(patsubst %.c,%.d,$(EXCEPT1))
