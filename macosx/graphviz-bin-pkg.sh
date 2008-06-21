#!/bin/bash

# $Id$ $Revision$

# where everything is
graphviz_host=www.graphviz.org
graphviz_path=/pub/graphviz

if test -z $1; then
    path=$graphviz_path/CURRENT
else
    path=$graphviz_path/$1
fi

work=$HOME/tmp/gviz
fix=$HOME/fix

# search for last graphviz tarball in the public sources
source=
for file in `ssh gviz@www.graphviz.org ls -t $path`; do
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
	scp gviz@$graphviz_host:$path/$source.tar.gz . 2>$LOG
	
	# build the package
	tar xzf $source.tar.gz
	make -C $source/macosx/build PREBUILD=$fix >>$LOG 2>&1

	# put the package
	scp $source/macosx/build/graphviz.pkg gviz@$graphviz_host:$path/$source.pkg 2>>$LOG
fi
