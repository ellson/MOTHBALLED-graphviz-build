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
GRAPHVIZ_ATT_PATH=$GRAPHVIZ_ROOT/ATT_$SRCDIR

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# cleanup previous build
rm -rf graphviz2

# obtain latest from cvs
#$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 co graphviz2
cvs -Qz3 co graphviz2

cd graphviz2

VERSION_MAJOR=`grep 'm4_define(graphviz_version_major' configure.ac | sed 's/.*, \([0-9]*\))/\1/'`
VERSION_MINOR=`grep 'm4_define(graphviz_version_minor' configure.ac | sed 's/.*, \([0-9]*\))/\1/'`
VERSION_MICRO=`grep 'm4_define(graphviz_version_micro' configure.ac | sed 's/.*, \([0-9.]*\))/\1/'`
if test $SRCDIR = CURRENT; then
    VERSION_MICRO=$DATE

    sed "s/\(m4_define(graphviz_version_micro, \)[0-9.]*)/\1$VERSION_MICRO)/" <configure.ac >t$$
    mv t$$ configure.ac
fi
VERSION=$VERSION_MAJOR.$VERSION_MINOR.$VERSION_MICRO

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

#----------------------------------------------------
# obtain latest att branch from cvs

cd ..
rm -rf graphviz2/lib/sfdpgen
#$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 update -d -r att_07932 graphviz2/lib/sfdpgen
cvs -Qz3 update -d -r att_07932 graphviz2/lib/sfdpgen
cd graphviz2

if test $SRCDIR = CURRENT; then
    VERSION_MICRO=$DATE.att
else
    VERSION_MICRO=att
fi

sed "s/\(m4_define(graphviz_version_micro, \)[0-9.]*)/\1$VERSION_MICRO)/" <configure.ac >t$$
mv t$$ configure.ac
VERSION=$VERSION_MAJOR.$VERSION_MINOR.$VERSION_MICRO

./autogen.sh >/dev/null
make dist >/dev/null

if ! test -f graphviz-$VERSION.tar.gz; then
    exit -1
fi

md5sum graphviz-$VERSION.tar.gz >graphviz-$VERSION.tar.gz.md5
scp -p graphviz-$VERSION.tar.gz graphviz-$VERSION.tar.gz.md5 $WWW:$GRAPHVIZ_ATT_PATH
ssh $WWW "cd $GRAPHVIZ_ATT_PATH; ln -sf graphviz-$VERSION.tar.gz graphviz-working.tar.gz"

# build a "distroagnostic" src.rpm.
rpmbuild -ts -D "distroagnostic 1" graphviz-$VERSION.tar.gz >/dev/null
scp -p $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$GRAPHVIZ_ATT_PATH

#----------------------------------------------------

#./graphviz-win.sh
#scp -p graphviz-win.tgz $WWW:$GRAPHVIZ_PATH/graphviz-win-$VERSION.tar.gz
#ssh $WWW "cd $GRAPHVIZ_PATH; ln -sf graphviz-win-$VERSION.tar.gz graphviz-win.tgz; ln -sf graphviz-win-$VERSION.tar.gz graphviz-win-$VERSION.src.tgz"
