#!/bin/bash

# $Id$ $Revision$

WWW=www.graphviz.org
DATE=`date -u +%Y%m%d.%H%M`
#HOST=`uname -n`
HOST=`hostname`

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
GRAPHVIZ_PUB_PATH=/data/pub/graphviz/$COLLECTION
GRAPHVIZ_ATT_PATH=/data/att_pub/graphviz/$COLLECTION

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# cleanup previous build
rm -rf graphviz2

# obtain latest from cvs
$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 co graphviz2
#cvs -Qz3 co graphviz2

cd graphviz2

if test .$SRCDIR = .CURRENT; then
    ./set_dev_vesion.sh
fi

./autogen.sh >/dev/null

make dist >/dev/null

if ! test -f graphviz-$VERSION.tar.gz; then
    exit -1
fi

SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
SRPMS=$GRAPHVIZ_PUB_PATH/SRPMS

md5sum graphviz-$VERSION.tar.gz >graphviz-$VERSION.tar.gz.md5
ssh $WWW "mkdir -p $SOURCES $SRPMS"
scp -p graphviz-$VERSION.tar.gz graphviz-$VERSION.tar.gz.md5 $WWW:$SOURCES/
ssh $WWW "cd $SOURCES; ln -sf graphviz-$VERSION.tar.gz graphviz-working.tar.gz"

# build a "distroagnostic" src.rpm.
rpmbuild -ts -D "distroagnostic 1" graphviz-$VERSION.tar.gz >/dev/null
scp -p $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$SRPMS/
ssh $WWW "cd $SRPMS; createrepo ."

tar cf - rtest | gzip >rtest.tgz
scp -p rtest.tgz $WWW:$SOURCES/

