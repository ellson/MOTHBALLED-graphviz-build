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

cd $HOME/tmp/gviz/graphviz2

scan-build -o ./graphviz-static-analysis/ ./configure --with-smyrna --with-ortho --with-ipsepcola --with-sfdp
scan-build -o ./graphviz-static-analysis/ make
tar cfz - graphviz-static-analysis >graphviz-static-analysis.tgz
scp -p graphviz-static-analysis.tgz $WWW:$GRAPHVIZ_PATH
ssh $WWW "cd $GRAPHVIZ_PATH; tar xfz graphviz-static-analysis.tgz"
