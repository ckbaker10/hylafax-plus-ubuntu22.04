#! /usr/bin/mawk -f
#      $Id: rfc2047-encode.awk.in 600 2007-08-23 04:14:32Z faxguy $
#
# HylaFAX Facsimile Software
#
# Copyright 2006 Patrice Fournier
# Copyright 2006 iFAX Solutions Inc.
#
# Permission to use, copy, modify, distribute, and sell this software and 
# its documentation for any purpose is hereby granted without fee, provided
# that (i) the above copyright notices and this permission notice appear in
# all copies of the software and related documentation, and (ii) the names of
# Sam Leffler and Silicon Graphics may not be used in any advertising or
# publicity relating to the software without the specific, prior written
# permission of Sam Leffler and Silicon Graphics.
# 
# THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY 
# WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  
# 
# IN NO EVENT SHALL SAM LEFFLER OR SILICON GRAPHICS BE LIABLE FOR
# ANY SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND,
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER OR NOT ADVISED OF THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF 
# LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE 
# OF THIS SOFTWARE.
#


BEGIN {
  for (i = 0; i < 256; i++) {
    c = sprintf("%c", i);
    if ((i >= 48 && i <= 57) || (i >= 65 && i <= 90) || (i >= 97 && i <= 122))
      qp[c] = c;
    else
      qp[c] = sprintf("=%02X", i);
  }
}

{
  l=1;
  len = length();
  while (l <= len) {
    printf("=?" charset "?Q?");
    pos = 5 + length(charset);
    for (; pos < 70 && l <= len; l++) {
      printf(qp[substr($0, l, 1)]);
      pos += length(qp[substr($0, l, 1)]);
    }
    printf("?=");
    if (l < len) {
      print("");
      printf(" ");
    }
  }
}

