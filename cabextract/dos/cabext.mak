#!/usr/bin/env -S wmake -h -e -f
#
# Open Watcom v2 Makefile for cross compiling cabinfo.exe from Linux to DOS.

# Build objects; must not be shared with cabext.
OBJECT_DIR = objects/cabext

# Build products; shared with cabext.
PRODUCT_DIR = products

# Repository information generated from git.
VERSION_H = objects/version.h

# Use the watcom compiler for 32-bit targets.
CC = wcc386

# Build for a 32-bit DOS target using all watcom optimizations. The -6 switch
# here emits 386 instructions that are ordered for a modern CPU.
CFLAGS = -6 -bt=dos -obehiklmnrt

# Header locations; all are relative to this wmake file.
CFLAGS += -i="objects;.;..;../mspack;$(%WATCOM)/h"

# And use the bundled dos/config.h file instead of autoconf.
CFLAGS += -dHAVE_CONFIG_H

# Use the watcom linker.
LD = wlink

# PMODE/W is smaller than DOS32/A by half and cabext will never use more than
# two megabytes of XMS memory at runtime for a maximally large lzx dictionary.
LFLAGS = system pmodew option stub=$(%WATCOM)/binw/pmodew.exe

# The watcom toolchain is noisy.
CC_SQUELCH = tail +7
LD_SQUELCH = tail +6

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

CABEXT_EXE = $(PRODUCT_DIR)/CABEXT.EXE

# The default rule.
$(CABEXT_EXE): $(VERSION_H) $(CABEXT_OBJ)
	$(LD) $(LFLAGS) name $@ file { $(CABEXT_OBJ) } | $(LD_SQUELCH)

$(VERSION_H): $(OBJECT_DIR)
	$(MAKE) -h -f version.mak $(VERSION_H)

$(OBJECT_DIR): $(PRODUCT_DIR)
	mkdir -p $@/mspack
	mkdir -p $@/src

$(PRODUCT_DIR):
	mkdir -p $@

clean: .SYMBOLIC
	rm -fr $(CABEXT_EXE) $(OBJECT_DIR)

# Idiomatically declare paths that contain source files.
.c: ../src/
.c: ../mspack/
.c: ../

# Idiomatically declare the implicit build rule.
.c.obj:
	$(CC) $(CFLAGS) -fo=$@ -fr=$@.err $< | $(CC_SQUELCH)
