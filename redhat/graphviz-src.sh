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
   GRAPHVIZ_PUB_PATH=/pub/ext_repos/development/
   GRAPHVIZ_ATT_PATH=/pub/int_repos/development/
else
   GRAPHVIZ_PUB_PATH=/pub/ext_repos/stable/
   GRAPHVIZ_ATT_PATH=/pub/int_repos/stable/
fi

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# cleanup previous build
rm -rf graphviz2

# obtain latest from cvs
$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 co graphviz2
#cvs -Qz3 co graphviz2

cd graphviz2

VERSION_MAJOR=`grep 'm4_define(graphviz_version_major' configure.ac | sed 's/.*, \([0-9]*\))/\1/'`
VERSION_MINOR=`grep 'm4_define(graphviz_version_minor' configure.ac | sed 's/.*, \([0-9]*\))/\1/'`
VERSION_MICRO=`grep 'm4_define(graphviz_version_micro' configure.ac | sed 's/.*, \([0-9.]*\))/\1/'`
if test .$SRCDIR = .CURRENT; then
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

#----------------------------------------------------
# obtain latest att branch from cvs

cd ..
rm -rf graphviz2/lib/sfdpgen
$HOME/graphviz-build/redhat/anoncvs.tcl -Qz3 update -d -r att_07932 graphviz2/lib/sfdpgen
#cvs -Qz3 update -d -r att_07932 graphviz2/lib/sfdpgen
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

SOURCES=$GRAPHVIZ_ATT_PATH/SOURCES
SRPMS=$GRAPHVIZ_ATT_PATH/SRPMS

md5sum graphviz-$VERSION.tar.gz >graphviz-$VERSION.tar.gz.md5
ssh $WWW "mkdir -p $SOURCES $SRPMS"
scp -p graphviz-$VERSION.tar.gz graphviz-$VERSION.tar.gz.md5 $WWW:$SOURCES/
ssh $WWW "cd $SOURCES; ln -sf graphviz-$VERSION.tar.gz graphviz-working.tar.gz"

# build a "distroagnostic" src.rpm.
rpmbuild -ts -D "distroagnostic 1" graphviz-$VERSION.tar.gz >/dev/null
scp -p $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$SRPMS/
ssh $WWW "cd $SRPMS; createrepo ."

#----------------------------------------------------

#./graphviz-win.sh
#scp -p graphviz-win.tgz $WWW:$GRAPHVIZ_PATH/graphviz-win-$VERSION.tar.gz
#ssh $WWW "cd $GRAPHVIZ_PATH; ln -sf graphviz-win-$VERSION.tar.gz graphviz-win.tgz; ln -sf graphviz-win-$VERSION.tar.gz graphviz-win-$VERSION.src.tgz"
