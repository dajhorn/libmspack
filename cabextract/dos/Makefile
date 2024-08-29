#!/usr/bin/env -S wmake -h -e -f
#
# OpenWatcom Makefile for cross compiling cabextract from Linux to DOS.
#
# @note: Git for Windows clones the cabextract/mspack/* symlinks as NTFS
# softlinks, which are incompatible with the watcom toolchain. If the symlinks
# are manually dereferenced, or if NTFS hardlinks are used instead, then a
# Windows host can compile some this project assuming that the posix utilities
# called herein are available.

# These directories should be in the .gitignore file.
# Note that wmake intercepts `mkdir` and `rm`.
OBJECT_DIR  = objects
PRODUCT_DIR = products
TEST_DIR    = tests

# Watcom compiler.
CC = wcc386

# Header locations relative to this wmake file.
CFLAGS = -i="$(OBJECT_DIR);.;..;../mspack;$(%WATCOM)/h"

# Use cabextract/dos/config.h instead of autoconf.
CFLAGS += -dHAVE_CONFIG_H

# Build for a 32-bit DOS target using all optimizations. The -6 switch here
# emits 386 instructions that are ordered for a modern CPU.
CFLAGS += -bt=dos -ohtexan -6

# Watcom linker.
LD = wlink

# The pmodew.exe DPMI extender must be in the $PATH when wlink is invoked.
# Using the wlink path directive here will not work as expected on a Linux
# build host, in part because the path delimiter is \: and not \;.
LFLAGS = system pmodew

# The watcom toolchain is noisy.
CC_SQUELCH = tail +7
LD_SQUELCH = tail +6

# Watcom implies the application name from the first source file name.
CABEXT_SRC  =         &
  ../src/cabextract.c &
  ../mspack/cabd.c    &
  ../mspack/lzxd.c    &
  ../mspack/mszipd.c  &
  ../mspack/qtmd.c    &
  ../mspack/system.c  &
  ../getopt.c         &
  ../getopt1.c        &
  ../md5.c            &

CABEXT_OBJ = $(CABEXT_SRC:../=$(OBJECT_DIR)/)
CABEXT_OBJ = $(CABEXT_OBJ:.c=.obj)

CABINFO_SRC =         &
  ../src/cabinfo.c    &

CABINFO_OBJ = $(CABINFO_SRC:../=$(OBJECT_DIR)/)
CABINFO_OBJ = $(CABINFO_OBJ:.c=.obj)

# @fixme: PMODE/W fails to start if the DOS shell expands $0 during exec() such
# that any part of the fullpath is not 8.3 conformant.
#
# Use `CABEXT.EXE` instead of `cabextract.exe`.
TARGETS = $(PRODUCT_DIR)/CABEXT.EXE $(PRODUCT_DIR)/CABINFO.EXE

# Includeable and sourceable version information.
VERSION_H  = $(OBJECT_DIR)/version.h
VERSION_SH = $(OBJECT_DIR)/version.sh

# Used for punctuating build progress. The ansi escape works in dash and bash
# without the `-e` switch, and the `set` keyword has slashies to avoid
# interception by wmake.
MADE = \s\e\t +x && echo -n '\e[33mMADE \e[0m' && LS_COLORS="ex=33:fi=33" ls --color

# Enable /bin/sh tracing, which makes inline scripting much more readable in
# the output of wmake. Note that wmake for Linux is hardcoded for /bin/sh.
SHOPT = set -x;

# Use this DOS emulator for running unit tests.
DOSBOX = flatpak run com.dosbox_x.DOSBox-X
DOSOPT = -exit -fastlaunch -nolog
DOSCNF = tests.in/dosbox.cnf

# The default rule.
all: .SYMBOLIC $(TARGETS)
	@%null

# Check for a watcom build environment.
preflight: .SYMBOLIC
	@(                                                &
	  if test -z '$(%WATCOM)'; then                   &
	    echo 'ERROR: $$WATCOM is not set.';           &
	    exit 1;                                       &
	  fi;                                             &
	  if ! test -d '$(%WATCOM)/h'; then               &
	    echo 'ERROR: $$WATCOM/h is not a directory.'; &
	    exit 1;                                       &
	  fi;                                             &
	  if ! which -s '$(CC)'; then                     &
	    echo 'ERROR: $(CC) is not in $$PATH.';        &
	    exit 1;                                       &
	  fi;                                             &
	  if ! which -s '$(LD)'; then                     &
	    echo 'ERROR: $(LD) is not in $$PATH.';        &
	    exit 1;                                       &
	  fi;                                             &
	)

$(OBJECT_DIR):
	mkdir -p $@/mspack
	mkdir -p $@/src

$(PRODUCT_DIR):
	mkdir -p $@

$(TEST_DIR): tests.in
	mkdir -p $@

# Create the version.sh file from the configure.ac file.
$(VERSION_SH): ../configure.ac $(OBJECT_DIR)
	@($(SHOPT)                                          &
	  awk -F '[][]'                                     &
	      -e '/AC_INIT/{ print "VERSION=" $$4; exit; }' &
	      ../configure.ac;                              &
	  if test -d ../../.git && which -s git; then       &
	    echo COMMIT_HASH=`git rev-parse --short HEAD`;  &
	  fi;                                               &
	) >$@
	@$(MADE) $@

# Create the version.h file from the version.sh file.
$(VERSION_H): $(VERSION_SH)
	@($(SHOPT)                                       &
	  . $(VERSION_SH);                               &
	  echo "$#define VERSION \"$$VERSION for DOS\""; &
	  if test ! -z \"$$COMMIT_HASH\"; then           &
	    echo "$#define COMMIT_HASH 0x$$COMMIT_HASH"; &
	  fi;                                            &
	) >$@
	@$(MADE) $@

# @note: The `.c.obj:` rule requires these `.c:` rules because the _OBJ
# directory is not the _SRC directory. Rather, because the build tree is
# separate from the source tree. Doing this prevents...
#
#   Error(F38): (foo.obj) does not exist and cannot be made from existing files
#
# Idiomatically declare paths that contain source files.
.c: ../src/
.c: ../mspack/
.c: ../

# This implicit wmake rule is like `%.o: %.c` in a
# posix makefile, but it cannot have dependencies.
.c.obj:
	$(CC) $(CFLAGS) -fo=$@ $< | $(CC_SQUELCH)
	@$(MADE) $@

$(PRODUCT_DIR)/CABEXT.EXE: $(PRODUCT_DIR) $(VERSION_H) $(CABEXT_OBJ)
	!PATH="$(%PATH):$(%WATCOM)/binw" &
	  $(LD) $(LFLAGS) name $@ file { $(CABEXT_OBJ) } | $(LD_SQUELCH)
	@$(MADE) $@

$(PRODUCT_DIR)/CABINFO.EXE: $(PRODUCT_DIR) $(VERSION_H) $(CABINFO_OBJ)
	!PATH="$(%PATH):$(%WATCOM)/binw" &
	  $(LD) $(LFLAGS) name $@ file { $(CABINFO_OBJ) } | $(LD_SQUELCH)
	@$(MADE) $@

clean: .SYMBOLIC
	rm -fr $(OBJECT_DIR)
	rm -fr $(PRODUCT_DIR)
	rm -fr $(TEST_DIR)

$(TEST_DIR)/report.txt: .PRECIOUS $(TEST_DIR) $(DOSCNF) $(TARGETS)
	$(DOSBOX) $(DOSOPT) -conf $(DOSCNF)
	cat $(TEST_DIR)/*.result >$@
	dos2unix $@
	@(                                         &
	  if grep -e ':FAIL$$' $@;                 &
	    then false;                            &
	    else echo '\e[32mALL TESTS PASS\e[0m'; &
	  fi;                                      &
	)

test: .SYMBOLIC $(TEST_DIR)/report.txt
	@%null
