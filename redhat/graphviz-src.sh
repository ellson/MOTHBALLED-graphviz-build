#!/bin/bash

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

# cleanup previous build
rm -rf graphviz2

# obtain latest from cvs
$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 co graphviz2

cd graphviz2

if test $SRCDIR = CURRENT; then
    BASEVERSION=`grep 'AC_INIT(graphviz' configure.ac | sed 's/AC_INIT(graphviz, \([0-9.]*\))/\1/'`
    VERSION=$BASEVERSION.$DATE

    sed "s/\(AC_INIT(graphviz, [0-9.]*\))/\1.$DATE)/" <configure.ac >t$$
    mv t$$ configure.ac
else
    VERSION=`grep 'AC_INIT(graphviz' configure.ac | sed 's/AC_INIT(graphviz, \([0-9.]*\))/\1/'`
fi

./autogen.sh >/dev/null
make dist >/dev/null

if ! test -f graphviz-$VERSION.tar.gz; then
    exit -1
fi

md5sum graphviz-$VERSION.tar.gz >graphviz-$VERSION.tar.gz.md5
scp -p graphviz-$VERSION.tar.gz graphviz-$VERSION.tar.gz.md5 $WWW:$GRAPHVIZ_PATH
ssh $WWW "cd $GRAPHVIZ_PATH; ln -sf graphviz-$VERSION.tar.gz graphviz-working.tar.gz"

# build a "distroagnostic" src.rpm.
rpmbuild -ts -D "distroagnostic 1" graphviz-$VERSION.tar.gz >/dev/null
scp -p $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$GRAPHVIZ_PATH

tar cf - rtest | gzip >rtest.tgz
scp -p rtest.tgz $WWW:$GRAPHVIZ_PATH

#./graphviz-win.sh
#scp -p graphviz-win.tgz $WWW:$GRAPHVIZ_PATH/graphviz-win-$VERSION.tar.gz
#ssh $WWW "cd $GRAPHVIZ_PATH; ln -sf graphviz-win-$VERSION.tar.gz graphviz-win.tgz; ln -sf graphviz-win-$VERSION.tar.gz graphviz-win-$VERSION.src.tgz"
