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

#*******************************************************************************
#Remove after testing is completed
COLLECTION=git_test
#*******************************************************************************

GRAPHVIZ_PUB_PATH=/data/pub/graphviz/$COLLECTION/
GRAPHVIZ_ATT_PATH=/data/att_pub/graphviz/$COLLECTION/

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz_git

# cleanup previous build
#*******************************************************************************
#Remove _git after testing is completed
rm -rf graphviz2
#*******************************************************************************


# obtain latest from mercurial
$HOME/graphviz-build_git/redhat/git_copy_repo.sh graphviz

#*******************************************************************************
#Remove _git after testing is completed
mv graphviz_git graphviz2
#*******************************************************************************


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
#*******************************************************************************
#Remove after testing is completed
#mv graphviz-$VERSION.tar.gz graphviz_git-$VERSION.tar.gz
#*******************************************************************************


SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
SRPMS=$GRAPHVIZ_PUB_PATH/SRPMS
#*******************************************************************************
#Remove _git after testing is completed
md5sum graphviz-$VERSION.tar.gz >graphviz-$VERSION.tar.gz.md5
#*******************************************************************************

ssh $WWW "mkdir -p $SOURCES $SRPMS"
#*******************************************************************************
#Remove _git after testing is completed
scp -p graphviz-$VERSION.tar.gz graphviz-$VERSION.tar.gz.md5 $WWW:$SOURCES/

ssh $WWW "cd $SOURCES; ln -sf graphviz-$VERSION.tar.gz graphviz-working.tar.gz"
#*******************************************************************************


# build a "distroagnostic" src.rpm.
#*******************************************************************************
#Remove _git after testing is completed
rpmbuild -ts -D "distroagnostic 1" graphviz-$VERSION.tar.gz >/dev/null
scp -p $RPMBUILD/SRPMS/graphviz-$VERSION-1.src.rpm $WWW:$SRPMS/
#*******************************************************************************

ssh $WWW "cd $SRPMS; createrepo ."

#*******************************************************************************
#Remove _git after testing is completed
tar cf - rtest | gzip >rtest_git.tgz
scp -p rtest_git.tgz $WWW:$SOURCES/
#*******************************************************************************

