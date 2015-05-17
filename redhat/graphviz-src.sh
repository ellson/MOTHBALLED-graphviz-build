#!/bin/bash

# $Id$ $Revision$

WWW=www.graphviz.org
DATE=`date -u +%Y%m%d.%H%M`
#HOST=`uname -n`
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
GRAPHVIZ_PUB_PATH=/data/pub/graphviz/$COLLECTION
GRAPHVIZ_ATT_PATH=/data/att_pub/graphviz/$COLLECTION

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# cleanup previous build
rm -rf graphviz2

# obtain latest from mercurial
$HOME/graphviz-build/redhat/hg_copy_repo.sh graphviz
mv graphviz graphviz2

cd graphviz2

if test .$SRCDIR = .CURRENT; then
    ./set_dev_version.sh
fi

./autogen.sh >/dev/null

VERSION=`grep '^PACKAGE_VERSION' config.log | sed 's/^.*=.\([.0-9]*\)./\1/'`

make dist >/dev/null

if ! test -f graphviz-$VERSION.tar.gz; then
    echo "Error: no graphviz-$VERSION.tar.gz was created"
    exit 1
fi

SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
SRPMS=$GRAPHVIZ_PUB_PATH/SRPMS

md5sum graphviz-$VERSION.tar.gz >graphviz-$VERSION.tar.gz.md5
ssh $WWW "mkdir -p $SOURCES $SRPMS"
# don't update tar file if no change
rsync -e ssh -p --ignore-existing graphviz-$VERSION.tar.gz $WWW:$SOURCES/
# but do update md5 so we can tell when sources last checked
rsync -e ssh -p graphviz-$VERSION.tar.gz.md5 $WWW:$SOURCES/
#scp -p graphviz-$VERSION.tar.gz graphviz-$VERSION.tar.gz.md5 $WWW:$SOURCES/
ssh $WWW "cd $SOURCES; ln -sf graphviz-$VERSION.tar.gz graphviz-working.tar.gz"

# build a "distroagnostic" src.rpm.
rpmbuild -ts -D "distroagnostic 1" graphviz-$VERSION.tar.gz >/dev/null
rsync -e ssh -p --ignore-existing $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$SRPMS/
# scp -p $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$SRPMS/
ssh $WWW "cd $SRPMS; createrepo ."

tar cf - rtest | gzip >rtest.tgz
rsync -e ssh -p rtest.tgz $WWW:$SOURCES/
# scp -p rtest.tgz $WWW:$SOURCES/

