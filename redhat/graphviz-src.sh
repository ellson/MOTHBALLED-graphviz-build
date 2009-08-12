#!/bin/bash

# $Id$ $Revision$

WWW=www.graphviz.org
DATE=`date -u +%Y%m%d.%H%M`
#HOST=`uname -n`
HOST=`hostname -f`

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

VERSION_MAJOR=`grep 'm4_define(graphviz_version_major' configure.ac | sed 's/.*, \([0-9]*\))/\1/'`
VERSION_MINOR=`grep 'm4_define(graphviz_version_minor' configure.ac | sed 's/.*, \([0-9]*\))/\1/'`
VERSION_MICRO=`grep 'm4_define(graphviz_version_micro' configure.ac | sed 's/.*, \([0-9.]*\))/\1/'`
if test .$SRCDIR = .CURRENT; then
    VERSION_MICRO=$DATE
    sed "s/\(m4_define(graphviz_version_micro, \)[0-9.]*)/\1$VERSION_MICRO)/" <configure.ac >t$$
    mv t$$ configure.ac
    sed "s/\(GRAPHVIZ_COLLECTION\)=.*/\1=$COLLECTION/" <configure.ac >t$$
    mv t$$ configure.ac
fi
VERSION=$VERSION_MAJOR.$VERSION_MINOR.$VERSION_MICRO

VERSION_DATE=$DATE
sed "s/VERSION_DATE=.*/VERSION_DATE=$VERSION_DATE/" <configure.ac >t$$
mv t$$ configure.ac

./autogen.sh >/dev/null

grep 'PACKAGE\|VERSION\|GVPLUGIN' config.h > graphviz_version.h

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

if test .$SRCDIR = .CURRENT; then
    VERSION_MICRO=$DATE.att
else
    VERSION_MICRO=$VERSION_MICRO.att
fi

sed "s/\(m4_define(graphviz_version_micro, \)[0-9.]*)/\1$VERSION_MICRO)/" <configure.ac >t$$
mv t$$ configure.ac
sed "s/COLLECTION=development/COLLECTION=$COLLECTION/" <configure.ac >t$$
mv t$$ configure.ac
VERSION=$VERSION_MAJOR.$VERSION_MINOR.$VERSION_MICRO

sed "s/VERSION_DATE=.*/VERSION_DATE=$VERSION_DATE/" <configure.ac >t$$
mv t$$ configure.ac

# modify debian rules
sed "s/--without-sfdp/--with-sfdp/" <debian/rules >t$$1
sed "s/--without-smyrna/--with-smyrna/" <t$$1 >t$$2
sed "s/--without-gtk /--with-gtk /" <t$$2 >t$$1
sed "s/--without-gtkgl/--with-gtkgl/" <t$$1 >t$$2
sed "s/--without-gtkglext/--with-gtkglext/" <t$$2 >t$$1
sed "s/--without-glade/--with-glade/" <t$$1 >debian/rules
rm -f t$$1 t$$2

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
