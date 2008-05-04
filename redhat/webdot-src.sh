#!/bin/bash

# $Id$ $Revision$

WWW=www.graphviz.org
DATE=`date -u +%Y%m%d.%H%M`
HOST=`uname -n`

GRAPHVIZ_ROOT=/pub/graphviz
SRCDIR=CURRENT
if test .$1 != . ;then
    SRCDIR=$1
fi
GRAPHVIZ_PATH=$GRAPHVIZ_ROOT/$SRCDIR
 
RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# cleanup previous
rm -rf webdot

# obtain latest from cvs
$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 co webdot

cd webdot

if test $SRCDIR = CURRENT; then
    BASEVERSION=`grep 'AC_INIT(webdot' configure.ac | sed 's/AC_INIT(webdot, \([0-9.]*\))/\1/'`
    VERSION=$BASEVERSION.$DATE

    sed "s/\(AC_INIT(webdot, [0-9.]*\))/\1.$DATE)/" <configure.ac >t$$
    mv t$$ configure.ac
else
    VERSION=`grep 'AC_INIT(webdot' configure.ac | sed 's/AC_INIT(webdot, \([0-9.]*\))/\1/'`
fi

./autogen.sh >/dev/null
./configure >/dev/null
make dist >/dev/null

if ! test -f webdot-$VERSION.tar.gz; then
    exit -1
fi

md5sum webdot-$VERSION.tar.gz >webdot-$VERSION.tar.gz.md5
scp -p webdot-$VERSION.tar.gz webdot-$VERSION.tar.gz.md5 $WWW:$GRAPHVIZ_PATH

rpmbuild -ts -D "distroagnostic 1" webdot-$VERSION.tar.gz
scp -p $RPMBUILD/SRPMS/webdot-$VERSION-1.src.rpm $WWW:$GRAPHVIZ_PATH
