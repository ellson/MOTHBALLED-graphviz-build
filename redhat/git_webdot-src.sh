#!/bin/bash

WWW=www.graphviz.org
HOST=`hostname`

SRCDIR=CURRENT
if test .$1 != . ;then 
    SRCDIR=$1
fi
if test .$SRCDIR = .CURRENT ; then
   COLLECTION=development
else
   COLLECTION=stable
fi

GRAPHVIZ_PUB_PATH=/data/pub/graphviz/$COLLECTION/
GRAPHVIZ_ATT_PATH=/data/att_pub/graphviz/$COLLECTION/

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# obtain latest from git
if test -d webdot-master; then
    cd webdot-master
    git pull
else
    git clone https://github.com/ellson/webdot.git webdot-master
    cd webdot-master
    rm -f webdot-*.tar.gz
fi

./autogen.sh >webdot-srclog-$VERSION.txt

VERSION=`grep '^PACKAGE_VERSION' config.log | sed 's/^.*=.\([.0-9]*\)./\1/'`

make dist >>webdot-srclog-$VERSION.txt

if ! test -f webdot-$VERSION.tar.gz; then
    echo "Error: no webdot-$VERSION.tar.gz was created"
    exit 1
fi

SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
SRPMS=$GRAPHVIZ_PUB_PATH/SRPMS
md5sum webdot-$VERSION.tar.gz >webdot-$VERSION.tar.gz.md5

ssh $WWW "mkdir -p $SOURCES $SRPMS"
# don't clobber existing version, if already present
rsync -e ssh --ignore-existing webdot-$VERSION.tar.gz $WWW:$SOURCES/
rsync -e ssh --ignore-existing webdot-$VERSION.tar.gz.md5 $WWW:$SOURCES/

# srclog is updated every time for checks of most recent build
rsync -e ssh webdot-srclog-$VERSION.txt $WWW:$SOURCES/

ssh $WWW "cd $SOURCES; ln -sf webdot-$VERSION.tar.gz webdot-working.tar.gz"

# build a "distroagnostic" src.rpm.
#**************************************************************************
rpmbuild -ts -D "distroagnostic 1" webdot-$VERSION.tar.gz >/dev/null

# don't clobber existing version, if already present
rsync -e ssh --ignore-existing $RPMBUILD/SRPMS/webdot-$VERSION-1.src.rpm $WWW:$SRPMS/
#**************************************************************************

ssh $WWW "cd $SRPMS; createrepo ."
