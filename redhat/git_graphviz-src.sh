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
if test -d graphviz-master; then
    cd graphviz-master
    git pull
else
    git clone https://github.com/ellson/graphviz.git graphviz-master
    cd graphviz-master
    rm -f graphviz-*.tar.gz
fi

./autogen.sh >graphviz-srclog-$VERSION.txt

VERSION=`grep '^PACKAGE_VERSION' config.log | sed 's/^.*=.\([.0-9]*\)./\1/'`

#LOG="$pkg-linux-log-$version$dist.$pkgarch.txt"

make dist >>graphviz-srclog-$VERSION.txt

if ! test -f graphviz-$VERSION.tar.gz; then
    echo "Error: no graphviz-$VERSION.tar.gz was created"
    exit 1
fi

SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
SRPMS=$GRAPHVIZ_PUB_PATH/SRPMS
md5sum graphviz-$VERSION.tar.gz >graphviz-$VERSION.tar.gz.md5

ssh $WWW "mkdir -p $SOURCES $SRPMS"
# don't clobber existing version, if already present
rsync -e ssh --ignore-existing graphviz-$VERSION.tar.gz $WWW:$SOURCES/
rsync -e ssh --ignore-existing graphviz-$VERSION.tar.gz.md5 $WWW:$SOURCES/

# srclog is updated every time for checks of most recent build
rsync -e ssh graphviz-srclog-$VERSION.txt $WWW:$SOURCES/

ssh $WWW "cd $SOURCES; ln -sf graphviz-$VERSION.tar.gz graphviz-working.tar.gz"

# build a "distroagnostic" src.rpm.
#**************************************************************************
rpmbuild -ts -D "distroagnostic 1" graphviz-$VERSION.tar.gz >/dev/null

# don't clobber existing version, if already present
rsync -e ssh --ignore-existing $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$SRPMS/
#**************************************************************************

ssh $WWW "cd $SRPMS; createrepo ."

#**************************************************************************
tar cf - rtest | gzip >rtest.tgz
scp -p rtest.tgz $WWW:$SOURCES/
#**************************************************************************
