/*
        fnmatch.c

        (description)

        Copyright (C) 1991, 1992, 1993 Free Software Foundation, Inc.

        This program is free software; you can redistribute it and/or
        modify it under the terms of the GNU General Public License
        as published by the Free Software Foundation; either version 2
        of the License, or (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

        See the GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with this program; if not, write to:

                Free Software Foundation, Inc.
                59 Temple Place - Suite 330
                Boston, MA  02111-1307, USA

*/
static const char rcsid[] = 
        "$Id: fnmatch.c,v 1.3 2006-03-01 21:11:32 kyz Exp $";

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#ifndef _GNU_SOURCE
# define _GNU_SOURCE
#endif

#include <ctype.h>
#include <errno.h>

#include "fnmatch.h"

/* Comment out all this code if we are using the GNU C Library, and are not
   actually compiling the library itself.  This code is part of the GNU C
   Library, but also included in many other GNU distributions.  Compiling
   and linking in this code is a waste when using the GNU C library
   (especially if it is a shared library).  Rather than having every GNU
   program understand `configure --with-gnu-libc' and omit the object files,
   it is simpler to just do this in the source for each such file.
*/

#if defined (_LIBC) || !defined (__GNU_LIBRARY__)

#if !defined(__GNU_LIBRARY__) && !defined(STDC_HEADERS)
#endif

/* Match STRING against the filename pattern PATTERN, returning zero if
   it matches, nonzero if not.  */
int
fnmatch (pattern, string, flags)
const char *pattern;
const char *string;
int         flags;
{
        register const char *p = pattern, *n = string;
        register unsigned char c;

/* Note that this evalutes C many times.  */
#define FOLD(c) ((flags & FNM_CASEFOLD) && isupper (c) ? tolower (c) : (c))

#if defined(_WIN32) || defined(__DOS__)
        flags |= FNM_CASEFOLD;
#endif

        while ((c = *p++) != '\0') {
                c = FOLD (c);

                switch (c) {
                        case '?':
                                if (*n == '\0')
                                        return FNM_NOMATCH;
                                else if ((flags & FNM_FILE_NAME) && *n == '/')
                                        return FNM_NOMATCH;
                                else if ((flags & FNM_PERIOD) && *n == '.' &&
                                                 (n == string
                                                  || ((flags & FNM_FILE_NAME)
                                                          && n[-1] == '/'))) return FNM_NOMATCH;
                                break;

                        case '\\':
                                if (!(flags & FNM_NOESCAPE)) {
                                        c = *p++;
                                        c = FOLD (c);
                                }
                                if (FOLD ((unsigned char) *n) != c)
                                        return FNM_NOMATCH;
                                break;

                        case '*':
                                if ((flags & FNM_PERIOD) && *n == '.' &&
                                        (n == string || ((flags & FNM_FILE_NAME) && n[-1] == '/')))
                                        return FNM_NOMATCH;

                                for (c = *p++; c == '?' || c == '*'; c = *p++, ++n)
                                        if (((flags & FNM_FILE_NAME) && *n == '/') ||
                                                (c == '?' && *n == '\0'))
                                                return FNM_NOMATCH;

                                if (c == '\0')
                                        return 0;

                                {
                                        unsigned char c1 = (!(flags & FNM_NOESCAPE)
                                                                                && c == '\\') ? *p : c;

                                        c1 = FOLD (c1);
                                        for (--p; *n != '\0'; ++n)
                                                if ((c == '[' || FOLD ((unsigned char) *n) == c1) &&
                                                        fnmatch (p, n, flags & ~FNM_PERIOD) == 0)
                                                        return 0;
                                        return FNM_NOMATCH;
                                }

                        case '[':
                                {
                                        /* Nonzero if the sense of the character class is
                                           inverted.  */
                                        register int not;

                                        if (*n == '\0')
                                                return FNM_NOMATCH;

                                        if ((flags & FNM_PERIOD) && *n == '.' &&
                                                (n == string
                                                 || ((flags & FNM_FILE_NAME)
                                                         && n[-1] == '/'))) return FNM_NOMATCH;

                                        not = (*p == '!' || *p == '^');
                                        if (not)
                                                ++p;

                                        c = *p++;
                                        for (;;) {
                                                register unsigned char cstart = c, cend = c;

                                                if (!(flags & FNM_NOESCAPE) && c == '\\')
                                                        cstart = cend = *p++;

                                                cstart = cend = FOLD (cstart);

                                                if (c == '\0')
                                                        /* [ (unterminated) loses.  */
                                                        return FNM_NOMATCH;

                                                c = *p++;
                                                c = FOLD (c);

                                                if ((flags & FNM_FILE_NAME) && c == '/')
                                                        /* [/] can never match.  */
                                                        return FNM_NOMATCH;

                                                if (c == '-' && *p != ']') {
                                                        cend = *p++;
                                                        if (!(flags & FNM_NOESCAPE) && cend == '\\')
                                                                cend = *p++;
                                                        if (cend == '\0')
                                                                return FNM_NOMATCH;
                                                        cend = FOLD (cend);

                                                        c = *p++;
                                                }

                                                if (FOLD ((unsigned char) *n) >= cstart
                                                        && FOLD ((unsigned char) *n) <= cend)
                                                        goto matched;

                                                if (c == ']')
                                                        break;
                                        }
                                        if (!not)
                                                return FNM_NOMATCH;
                                        break;

                                  matched:;
                                        /* Skip the rest of the [...] that already matched.  */
                                        while (c != ']') {
                                                if (c == '\0')
                                                        /* [... (unterminated) loses.  */
                                                        return FNM_NOMATCH;

                                                c = *p++;
                                                if (!(flags & FNM_NOESCAPE) && c == '\\')
                                                        /* XXX 1003.2d11 is unclear if this is right.  */
                                                        ++p;
                                        }
                                        if (not)
                                                return FNM_NOMATCH;
                                }
                                break;

                        default:
                                if (c != FOLD ((unsigned char) *n))
                                        return FNM_NOMATCH;
                }

                ++n;
        }

        if (*n == '\0')
                return 0;

        if ((flags & FNM_LEADING_DIR) && *n == '/')
                /* The FNM_LEADING_DIR flag says that "foo*" matches
                   "foobar/frobozz".  */
                return 0;

        return FNM_NOMATCH;
}

#endif /* _LIBC or not __GNU_LIBRARY__.  */
