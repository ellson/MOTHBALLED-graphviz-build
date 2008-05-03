#!/bin/bash

# where everything is
graphviz_host=www.graphviz.org
graphviz_path=/pub/graphviz
path=$graphviz_path/$1

# search for last graphviz tarball in the public sources
source=`ssh gviz@www.graphviz.org ls -r $path | sed -n 's/^\(graphviz-[0-9.]*\).tar.gz$/\1/p
t found
b
:found
q'`

if test -n $source
then
	scp gviz@$graphviz_host:$path/$source.tar.gz .
	tar xzf $source.tar.gz
	make -C $source/macosx/build
	scp $source/macosx/build/graphviz-*.pkg gviz@$graphviz_host:$path/
fi
