#!/bin/bash

# set DIR=ARCHIVE to build stable release
#     DIR=CURRENT (or empty) to build the current snapshot
DIR=$1
ERR=graphviz_build_err
OUT=graphviz_build_out
rm -rf $ERR $OUT

BUILD_HOSTS="
	gviz@bld-centos5
        gviz@bld-centos6
        gviz@bld-centos7
        gviz@bld-centos5-32
        gviz@bld-centos6-32
        gviz@bld-centos7-32
        gviz@bld-fedora21
        gviz@bld-fedora22
        gviz@bld-fedora23
        gviz@bld-fedora24
        gviz@bld-fedora25
        gviz@bld-fedora21-32
        gviz@bld-fedora22-32
        gviz@bld-fedora23-32
        gviz@bld-fedora24-32
        gviz@bld-fedora25-32
"
pssh -H "$BUILD_HOSTS" -o $OUT -e $ERR -t 12000 -p 4 PATH=/usr/bin:/bin:$PATH graphviz-build/redhat/graphviz-bin-rpm.tcl $DIR

BUILD_HOSTS="
	gviz@pome
"
pssh -H "$BUILD_HOSTS" -o $OUT -e $ERR -t 12000 -p 4 graphviz-build/macosx/graphviz-mountainlion-bin-pkg.sh $DIR

BUILD_HOSTS="
	gviz@empire
"
pssh -H "$BUILD_HOSTS" -o $OUT -e $ERR -t 12000 -p 4 graphviz-build/macosx/graphviz-lion-bin-pkg.sh $DIR
