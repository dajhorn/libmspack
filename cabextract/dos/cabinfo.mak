#!/usr/bin/env -S wmake -h -e -f
#
# Open Watcom v2 Makefile for cross compiling cabinfo.exe from Linux to DOS.

# Build objects; must not be shared with cabext.
OBJECT_DIR = objects/cabinfo

# Build products; shared with cabext.
PRODUCT_DIR = products

# Repository information generated from git.
VERSION_H = objects/version.h

# Use the watcom compiler for 16-bit targets.
CC = wcc

# Build for a real 16-bit DOS target using all watcom optimizations.
CFLAGS = -0 -bt=dos -obehiklmnrt

# Use the small memory model.
CFLAGS += -ms

# Header locations; all are relative to this wmake file.
CFLAGS += -i="objects;.;..;../mspack;$(%WATCOM)/h"

# And use the bundled dos/config.h file instead of autoconf.
CFLAGS += -dHAVE_CONFIG_H

# Use the watcom linker.
LD = wlink
LFLAGS = system dos

# The watcom toolchain is noisy.
CC_SQUELCH = tail +7
LD_SQUELCH = tail +6

CABINFO_SRC =         &
  ../src/cabinfo.c    &
  ../mspack/macros.c  &

CABINFO_OBJ = $(CABINFO_SRC:../=$(OBJECT_DIR)/)
CABINFO_OBJ = $(CABINFO_OBJ:.c=.obj)

CABINFO_EXE = $(PRODUCT_DIR)/CABINFO.EXE

# The default rule.
$(CABINFO_EXE): $(VERSION_H) $(CABINFO_OBJ)
	$(LD) $(LFLAGS) name $@ file { $(CABINFO_OBJ) } | $(LD_SQUELCH)

$(VERSION_H): $(OBJECT_DIR)
	$(MAKE) -h -f version.mak $(VERSION_H)

$(OBJECT_DIR): $(PRODUCT_DIR)
	mkdir -p $@/mspack
	mkdir -p $@/src

$(PRODUCT_DIR):
	mkdir -p $@

clean: .SYMBOLIC
	rm -fr $(CABINFO_EXE) $(OBJECT_DIR)

# Idiomatically declare paths that contain source files.
.c: ../src/
.c: ../mspack/
.c: ../

# Idiomatically declare the implicit build rule.
.c.obj:
	$(CC) $(CFLAGS) -fo=$@ -fr=$@.err $< | $(CC_SQUELCH)
