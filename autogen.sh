#!/bin/sh

# Before using, you should figure out all the .m4 macros that your
# configure.m4 script needs and make sure they exist in the m4/
# directory.
#
# These are the files that this script might edit:
#    aclocal.m4 configure Makefile.in src/config.h.in \
#    depcomp config.guess config.sub install-sh missing mkinstalldirs \
#
# Here's a command you can run to see what files aclocal will import:
#  aclocal -I ../autoconf --output=- | sed -n 's/^m4_include..\([^]]*\).*/\1/p'

# Because libtoolize isn't in the hermetic build, autogen doesn't run it.
# However, it should be run manually periodically to update these files:
#    in .: ltmain.sh
#    in m4: libtool.m4 ltoptions.m4 ltsugar.m4 ltversion.m4 lt~obsolete.m4

echo "It'd probably be better to just run \`autoreconf' with your favorite flags, but whatever..."
set -ex
rm -rf autom4te.cache

test -x `which aclocal` && aclocal --force -I m4
#grep -q LIBTOOL configure.ac && libtoolize -c -f
test -x `which autoconf` && autoconf -f -W all,no-obsolete
test -x `which autoheader` && autoheader -f -W all
test -x `which automake` && automake -a -c -f -W all

rm -rf autom4te.cache
exit 0
