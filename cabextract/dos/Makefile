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
PACKAGE_DIR = fdpackage
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

# Generates $(VERSION_SH) from the git log.
GIT_FORMAT = "format:COMMIT_HASH='%h'%nCOMMIT_AUTHOR_EMAIL='%ae'%nCOMMIT_AUTHOR_NAME='%an'%nMAINTAINED_BY='%ae (%an)'%n"

# The patch series put in the $(PATCHES_ZIP) file.
GIT_RANGE = upstream..HEAD

# Most apps in FreeDOS distribution are packed by UPX.
UPX = upx
UPXOPT = --ultra-brute -qq
UPXTARGETS = $(PACKAGE_DIR)/BIN/CABEXT.EXE $(PACKAGE_DIR)/BIN/CABINFO.EXE

# The AdvanceCOMP implementation of zip.
ZIP = advzip

# `-a2` is libdeflate, which does 5% better than InfoZIP.
# `-a4i1024` is 1k iterations of zopfli, which does 1% better than libdeflate.
ZIP_DEFLATE = $(ZIP) -a2

# Store the source package, which makes it solid in the binary package.
ZIP_STORE = $(ZIP) -a0

# InfoZIP equivalents.
#ZIP = zip
#ZIP_DEFLATE = $(ZIP) -9 --no-extra --recurse-paths --dos-names
#ZIP_STORE   = $(ZIP) -0 --no-extra --recurse-paths

# Source code for the FreeDOS package.
PATCHES_ZIP = $(PACKAGE_DIR)/SOURCE/CABEXT/PATCHES.ZIP
SOURCES_ZIP = $(PACKAGE_DIR)/SOURCE/CABEXT/SOURCES.ZIP

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

$(PACKAGE_DIR): fdpackage.in
	cp -r $< $@
	mkdir -p $@/BIN

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
	    git log -1 --pretty=$(GIT_FORMAT);              &
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

$(PACKAGE_DIR)/BIN/CABEXT.EXE: $(PRODUCT_DIR)/CABEXT.EXE
	rm -f $@
	$(UPX) $(UPXOPT) -o $@ $<
	@$(MADE) $@

$(PACKAGE_DIR)/BIN/CABINFO.EXE: $(PRODUCT_DIR)/CABINFO.EXE
	rm -f $@
	$(UPX) $(UPXOPT) -o $@ $<
	@$(MADE) $@

clean: .SYMBOLIC
	rm -fr $(OBJECT_DIR)
	rm -fr $(PACKAGE_DIR)
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

$(SOURCES_ZIP): $(PACKAGE_DIR)
	@($(SHOPT)                          &
	  cd ../..;                         &
	  git archive HEAD --format=zip -0; &
	) >$@
	@$(MADE) $@

$(PATCHES_ZIP): $(PACKAGE_DIR)
	@($(SHOPT)                        &
	  cd $^:;                         &
	  git format-patch $(GIT_RANGE);  &
	  if ls *.patch 1>/dev/null 2>&1; &
	  then                            &
	    $(ZIP_STORE) $^. *.patch;     &
	    rm *.patch;                   &
	  else                            &
	    :>$^.;                        &
	  fi;                             &
	)
	@$(MADE) $@

package: .SYMBOLIC $(PACKAGE_DIR) $(PATCHES_ZIP) $(SOURCES_ZIP) $(UPXTARGETS) $(VERSION_SH)
	cp ../AUTHORS   $(PACKAGE_DIR)/DOC/CABEXT/AUTHORS.TXT
	cp ../ChangeLog $(PACKAGE_DIR)/DOC/CABEXT/CHANGES.TXT
	cp ../README    $(PACKAGE_DIR)/DOC/CABEXT/README.TXT
	cp ../NEWS      $(PACKAGE_DIR)/DOC/CABEXT/NEWS.TXT
	cp ../TODO      $(PACKAGE_DIR)/DOC/CABEXT/TODO.TXT
	unix2dos        $(PACKAGE_DIR)/DOC/CABEXT/*.TXT &
	                $(PACKAGE_DIR)/APPINFO/*
	@($(SHOPT)                                                         &
	  . $(VERSION_SH);                                                 &
	  PRODUCT_DIR="`pwd`/$(PRODUCT_DIR)";                              &
	  PACKAGE_OUT="cabextract-$$VERSION+$$COMMIT_HASH.dos.zip";        &
	  cd "$(PACKAGE_DIR)";                                             &
	  sed -e "s/Maintained-by:.*/Maintained-by:  $$MAINTAINED_BY\r/"   &
	      -e "s/Modified-date:.*/Modified-date:  `date --iso-8601`\r/" &
	      -e "s/Version:.*/Version:        $$VERSION\r/"               &
	      -i APPINFO/CABEXT.LSM;                                       &
	  $(ZIP_DEFLATE) "$$PRODUCT_DIR/$$PACKAGE_OUT" *;                  &
	  cd -;                                                            &
	  $(MADE) $(PRODUCT_DIR)/$$PACKAGE_OUT                             &
	)
