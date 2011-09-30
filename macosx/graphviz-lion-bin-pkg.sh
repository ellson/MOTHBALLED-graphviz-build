#!/bin/bash

# $Id$ $Revision$

# where everything is
graphviz_host=www.graphviz.org

SRCDIR=CURRENT
if test .$1 != . ;then
    SRCDIR=$1
fi
if test .$SRCDIR = .CURRENT ; then
   GRAPHVIZ_PUB_PATH=/data/pub/graphviz/development/
else
   GRAPHVIZ_PUB_PATH=/data/pub/graphviz/stable/
fi

work=$HOME/tmp/gviz
PREFIX=$HOME/FIX/Lion.x86_64
export PREFIX
PATH=$PREFIX/bin:$PATH
export PATH

SOURCES=$GRAPHVIZ_PUB_PATH/SOURCES
PKGS=$GRAPHVIZ_PUB_PATH/macos/lion

# search for last graphviz tarball in the public sources
source=
for file in `ssh gviz@www.graphviz.org ls -t $SOURCES`; do
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
	(cd $source; ./configure --enable-swig=no --disable-dependency-tracking --with-ipsepcola --with-quartz --with-smyrna=no --disable-perl --with-extra-includedir="/Users/gviz/FIX/Lion.x86_64/include" --with-extra-libdir="/Users/gviz/FIX/Lion.x86_64/lib" CFLAGS="-O2 " CXXFLAGS="-O2 " OBJCFLAGS="-O2 " LDFLAGS=" -Wl,-dead_strip" GDLIB_CONFIG="/Users/gviz/FIX/Lion.x86_64/bin/gdlib-config" PKG_CONFIG="/Users/gviz/FIX/Lion.x86_64/bin/pkg-config" PKG_CONFIG_PATH="/Users/gviz/FIX/Lion.x86_64/lib/pkgconfig:/usr/X11/lib/pkgconfig" LIBS="-framework CoreFoundation -framework CoreServices -framework ApplicationServices -fexceptions" >>$LOG 2>&1)
	(cd $source/macosx/graphviz.xcodeproj; cp lion.project.pbxproj project.pbxproj)
	(cd $source/macosx/build; cp Makefile.lion Makefile)
	make -C $source/macosx/build >>$LOG 2>&1

	# put the package
	scp $source/macosx/build/graphviz.pkg gviz@$graphviz_host:$PKGS/$source.pkg 2>>$LOG
	scp $LOG gviz@$graphviz_host:$PKGS/$LOG
fi
