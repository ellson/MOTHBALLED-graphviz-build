#!/bin/bash

# $Id$ $Revision$

WWW=www.graphviz.org
HOST=`uname -n`

SRCDIR=CURRENT
if test .$1 != . ;then
    SRCDIR=$1
fi
if test .$SRCDIR = .CURRENT ; then
   GRAPHVIZ_PATH=/data/pub/graphviz/development/
else
   GRAPHVIZ_PATH=/data/pub/graphviz/stable/
fi

cd $HOME/tmp/gviz/graphviz-master

doxygen >/dev/null
tar cfz - doxygen >doxygen.tgz
scp -p doxygen.tgz $WWW:$GRAPHVIZ_PATH
ssh $WWW "cd $GRAPHVIZ_PATH; tar xfz doxygen.tgz"
