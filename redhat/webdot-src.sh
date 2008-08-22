#!/bin/bash

# $Id$ $Revision$

WWW=www.graphviz.org
DATE=`date -u +%Y%m%d.%H%M`
HOST=`uname -n`

export CVSROOT=:ext:ellson@cvs-graphviz.research.att.com:/home/cvsroot
export CVS_RSH=ssh

SRCDIR=CURRENT
if test .$1 != . ;then
    SRCDIR=$1
fi

if test .$SRCDIR = .CURRENT ; then
    COLLECTION=development
else
    COLLECTION=stable
fi
GRAPHVIZ_PUB_PATH=/pub/graphviz/$COLLECTION/
GRAPHVIZ_ATT_PATH=/att/graphviz/$COLLECTION/

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# cleanup previous
rm -rf webdot

# obtain latest from cvs
$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 co webdot
#cvs -Qz3 co webdot

cd webdot

if test $SRCDIR = CURRENT; then
    BASEVERSION=`grep 'AC_INIT(webdot' configure.ac | sed 's/AC_INIT(webdot, \([0-9.]*\))/\1/'`
    VERSION=$BASEVERSION.$DATE

    sed "s/\(AC_INIT(webdot, [0-9.]*\))/\1.$DATE)/" <configure.ac >t$$
    mv t$$ configure.ac
    sed "s/\(GRAPHVIZ_COLLECTION\)=.*/\1=$COLLECTION/" <configure.ac >t$$
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

SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
SRPMS=$GRAPHVIZ_PUB_PATH/SRPMS

md5sum webdot-$VERSION.tar.gz >webdot-$VERSION.tar.gz.md5
ssh $WWW "mkdir -p $SOURCES $SRPMS"
scp -p webdot-$VERSION.tar.gz webdot-$VERSION.tar.gz.md5 $WWW:$SOURCES/

rpmbuild -ts -D "distroagnostic 1" webdot-$VERSION.tar.gz
scp -p $RPMBUILD/SRPMS/webdot-$VERSION-1.src.rpm $WWW:$SRPMS/
ssh $WWW "cd $SRPMS; createrepo ."

# copy for internal use
#
#SOURCES=$GRAPHVIZ_ATT_PATH/SOURCES
#SRPMS=$GRAPHVIZ_ATT_PATH/SRPMS
#
#ssh $WWW "mkdir -p $SOURCES $SRPMS"
#scp -p webdot-$VERSION.tar.gz webdot-$VERSION.tar.gz.md5 $WWW:$SOURCES/
#scp -p $RPMBUILD/SRPMS/webdot-$VERSION-1.src.rpm $WWW:$SRPMS/
#ssh $WWW "cd $SRPMS; createrepo ."

