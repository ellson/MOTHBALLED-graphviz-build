#!/bin/bash

# set DIR=ARCHIVE to build stable release
#     DIR=CURRENT (or empty) to build the current snapshot
DIR=$1

BUILD_HOSTS="bld-centos5
        bld-centos6
        bld-centos7
        bld-centos5-32
        bld-centos6-32
        bld-centos7-32
        bld-fedora21
        bld-fedora22
        bld-fedora23
        bld-fedora24
        bld-fedora25
        bld-fedora21-32
        bld-fedora22-32
        bld-fedora23-32
        bld-fedora24-32
        bld-fedora25-32"

parallel -j 4 --arg-sep ::: ssh -x gviz@{} PATH=/usr/bin:/bin:$PATH graphviz-build/redhat/graphviz-bin-rpm.tcl $DIR ::: $BUILD_HOSTS

#BUILD_HOSTS="ubuntu12 ubuntu12-64 ubuntu13 ubuntu13-64"
#parallel -j 2 --arg-sep ::: ssh -x gviz@{} graphviz-build/ubuntu/graphviz-bin-deb.tcl $DIR ::: $BUILD_HOSTS

#BUILD_HOSTS="snares"
#parallel -j 2 --arg-sep ::: ssh -x gviz@{} graphviz-build/macosx/graphviz-snowleopard-bin-pkg.sh $DIR ::: $BUILD_HOSTS

BUILD_HOSTS="pome"
parallel -j 2 --arg-sep ::: ssh -x gviz@{} graphviz-build/macosx/graphviz-mountainlion-bin-pkg.sh $DIR ::: $BUILD_HOSTS

BUILD_HOSTS="empire"
parallel -j 2 --arg-sep ::: ssh -x gviz@{} graphviz-build/macosx/graphviz-lion-bin-pkg.sh $DIR ::: $BUILD_HOSTS
