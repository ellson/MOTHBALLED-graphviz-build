#!/bin/bash

# $Id$ $Revision$

# where everything is
graphviz_host=www.graphviz.org
graphviz_path=/data/pub/graphviz

if test -z $1; then
    path=$graphviz_path/development
else
    path=$graphviz_path/stable
fi

work=$HOME/tmp/gviz
fix=$HOME/fix

SOURCES=$path/SOURCES
PKGS=$PATH/windows

# search for last graphviz tarball in the public sources
source=
for file in `ssh gviz@www.graphviz.org ls -r $SOURCES`; do
        source=`expr $file : '\(graphviz-[0-9.]*\).tar.gz$'`
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
	mingw32-make -C $source/windows/build PREBUILD=$fix >>$LOG 2>&1

	# put the package
	scp $source/windows/build/graphviz.msi gviz@$graphviz_host:$PKGS/$source.msi 2>>$LOG
fi
