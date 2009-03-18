#!/bin/bash

# $Id$ $Revision$

# where everything is
graphviz_host=www.graphviz.org

SRCDIR=CURRENT
if test .$1 != . ;then
    SRCDIR=$1
fi
if test .$SRCDIR = .CURRENT ; then
   GRAPHVIZ_PUB_PATH=/data/att_pub/graphviz/development/
else
   GRAPHVIZ_PUB_PATH=/data/att_pub/graphviz/stable/
fi

work=$HOME/tmp/gviz
PREFIX=$HOME/FIX/leopard
export PREFIX

SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
PKGS=$GRAPHVIZ_PUB_PATH/macos/leopard

# search for last graphviz tarball in the public sources
source=
for file in `ssh gviz@www.graphviz.org ls -t $SOURCES`; do
        source=`expr $file : '\(graphviz-[0-9.at]*\).tar.gz$'`
        if test -n "$source"; then
                break
        fi
done

if test -n "$source"
then
	LOG=$source-log.txt

	# clean up previous builds
	mkdir -p $work
	rm -rf $work/*
	cd $work

	# get the sources
	scp gviz@$graphviz_host:$SOURCES/$source.tar.gz . 2>$LOG
	
	# build the package
	tar xzf $source.tar.gz
	(cd $source/macosx/build; sed -e 's/configure --/configure --with-sfdp --/' <Makefile >Makefile.NEW; mv Makefile.NEW Makefile)
	make -C $source/macosx/build >>$LOG 2>&1

	# put the package
	scp $source/macosx/build/graphviz.pkg gviz@$graphviz_host:$PKGS/$source.pkg 2>>$LOG
	scp $LOG gviz@$graphviz_host:$PKGS/$LOG
fi
