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


GRAPHVIZ_PUB_PATH=/data/pub/graphviz/$COLLECTION/
GRAPHVIZ_ATT_PATH=/data/att_pub/graphviz/$COLLECTION/

RPMBUILD=$HOME/rpmbuild/$HOST
cd $HOME/tmp/gviz

# # cleanup previous build
# rm -rf graphviz-master master.zip*
# 
# # obtain latest from git
# wget -q https://github.com/ellson/graphviz/archive/master.zip
# unzip -q master.zip
# rm -rf master.zip*
# 
# cd graphviz-master
# 
# if test .$SRCDIR = .CURRENT; then
#     ./set_dev_version.sh
# fi

# obtain latest from git
if test -d webdot-master; then
    cd webdot-master
    git pull
else
    git clone https://github.com/ellson/webdot.git webdot-master
    cd webdot-master
fi

./autogen.sh >/dev/null

VERSION=`grep '^PACKAGE_VERSION' config.log | sed 's/^.*=.\([.0-9]*\)./\1/'`

make dist >/dev/null

if ! test -f webdot-$VERSION.tar.gz; then
    echo "Error: no webdot-$VERSION.tar.gz was created"
    exit 1
fi


SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
SRPMS=$GRAPHVIZ_PUB_PATH/SRPMS
md5sum webdot-$VERSION.tar.gz >webdot-$VERSION.tar.gz.md5

ssh $WWW "mkdir -p $SOURCES $SRPMS"
scp -p webdot-$VERSION.tar.gz webdot-$VERSION.tar.gz.md5 $WWW:$SOURCES/

ssh $WWW "cd $SOURCES; ln -sf webdot-$VERSION.tar.gz webdot-working.tar.gz"


# build a "distroagnostic" src.rpm.
#*******************************************************************************
rpmbuild -ts -D "distroagnostic 1" webdot-$VERSION.tar.gz >/dev/null
scp -p $RPMBUILD/SRPMS/webdot-$VERSION-1.src.rpm $WWW:$SRPMS/
#*******************************************************************************

ssh $WWW "cd $SRPMS; createrepo ."
