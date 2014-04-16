#!/bin/sh
# Run this to generate all the initial makefiles, etc.

set -e
if [ ! -f configure.ac -o ! -f COPYING ]; then
	echo "Doesn't look like you're in the source directory" >&2
	exit 1
fi

# old autoreconf/aclocal versions fail hard if m4 doesn't exist
mkdir -p m4
autoreconf --force --install
echo "Now type './configure ...' and 'make' to compile."
./configure --enable-shared --prefix=/usr/lighttpd
make
make install
cp -f src/.libs/lighttpd.so /usr/lighttpd/sbin/lighttpd.so
cd $W/osv
make
./scripts/run.py -n -v -e "/usr/lighttpd/sbin/lighttpd.so -f /usr/lighttpd/lighttpd.conf"
