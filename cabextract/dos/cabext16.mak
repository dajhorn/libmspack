#!/usr/bin/env -S wmake -h -e -f
#
# Open Watcom v2 Makefile for cross compiling cabinfo.exe from Linux to DOS.

# Build objects.
OBJECT_DIR = objects/cabext16

# Build products.
PRODUCT_DIR = products

# Repository information generated from git.
VERSION_H = objects/version.h

# Use the watcom compiler for 16-bit targets.
CC = wcc

# Build for a real 16-bit DOS target using all watcom optimizations.
CFLAGS = -0 -bt=dos -obehiklmnrt

# Use the large memory model.
CFLAGS += -ml

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

# The LZX and Quantum decompressors are omitted because they use dictionaries
# that exceed the maximum 16-bit segment size. Tooling for XMS is needed here.
CABEXT16_SRC  =       &
  ../src/cabextract.c &
  ../mspack/cabd.c    &
  ../mspack/macros.c  &
  ../mspack/mszipd.c  &
  ../mspack/system.c  &
  ../getopt.c         &
  ../getopt1.c        &
  ../md5.c            &

CABEXT16_OBJ = $(CABEXT16_SRC:../=$(OBJECT_DIR)/)
CABEXT16_OBJ = $(CABEXT16_OBJ:.c=.obj)

CABEXT16_EXE = $(PRODUCT_DIR)/CABEXT16.EXE

# The default rule.
$(CABEXT16_EXE): $(VERSION_H) $(CABEXT16_OBJ)
	$(LD) $(LFLAGS) name $@ file { $(CABEXT16_OBJ) } | $(LD_SQUELCH)

$(VERSION_H): $(OBJECT_DIR)
	$(MAKE) -h -f version.mak $(VERSION_H)

$(OBJECT_DIR): $(PRODUCT_DIR)
	mkdir -p $@/mspack
	mkdir -p $@/src

$(PRODUCT_DIR):
	mkdir -p $@

clean: .SYMBOLIC
	rm -fr $(CABEXT16_EXE) $(OBJECT_DIR)

# Idiomatically declare paths that contain source files.
.c: ../src/
.c: ../mspack/
.c: ../

# Idiomatically declare the implicit build rule.
.c.obj:
	$(CC) $(CFLAGS) -fo=$@ -fr=$@.err $< | $(CC_SQUELCH)
