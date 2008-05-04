#!/bin/bash

# $Id$ $Revision$

WWW=www.graphviz.org
HOST=`uname -n`

GRAPHVIZ_ROOT=/pub/graphviz
SRCDIR=CURRENT
if test .$1 != . ;then
    SRCDIR=$1
fi
GRAPHVIZ_PATH=$GRAPHVIZ_ROOT/$SRCDIR

cd $HOME/tmp/gviz/graphviz2

doxygen >/dev/null
tar cfz - doxygen >doxygen.tgz
scp -p doxygen.tgz $WWW:$GRAPHVIZ_PATH
ssh $WWW "cd $GRAPHVIZ_PATH; tar xfz doxygen.tgz"
