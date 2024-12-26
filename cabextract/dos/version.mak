#!/usr/bin/env -S wmake -h -e -f
#
# Open Watcom v2 Makefile for generating version details from a git repo.

OBJECT_DIR  = objects

# Includeable and sourceable version information.
VERSION_H  = $(OBJECT_DIR)/version.h
VERSION_SH = $(OBJECT_DIR)/version.sh

# Enable /bin/sh tracing, which makes inline scripting much more readable in
# the output of wmake. Note that wmake for Linux is hardcoded for /bin/sh.
#SHOPT = set -x;

# Generates $(VERSION_SH) from the git log.
GIT_FORMAT = "format:COMMIT_HASH='%h'%nCOMMIT_AUTHOR_EMAIL='%ae'%nCOMMIT_AUTHOR_NAME='%an'%nMAINTAINED_BY='%ae (%an)'%n"

# Create the version.h file from the version.sh file.
$(VERSION_H): $(VERSION_SH)
	@($(SHOPT)                                       &
	  . $(VERSION_SH);                               &
	  echo "$#define VERSION \"$$VERSION for DOS\""; &
	  if test ! -z \"$$COMMIT_HASH\"; then           &
	    echo "$#define COMMIT_HASH 0x$$COMMIT_HASH"; &
	  fi;                                            &
	) >$@

# Create the version.sh file from the configure.ac file.
$(VERSION_SH): ../configure.ac $(OBJECT_DIR) $(PRODUCT_DIR)
	@($(SHOPT)                                          &
	  awk -F '[][]'                                     &
	      -e '/AC_INIT/{ print "VERSION=" $$4; exit; }' &
	      ../configure.ac;                              &
	  if test -d ../../.git && which -s git; then       &
	    git log -1 --pretty=$(GIT_FORMAT);              &
	  fi;                                               &
	) >$@

clean: .SYMBOLIC
	rm -f $(VERSION_H) $(VERSION_SH)
