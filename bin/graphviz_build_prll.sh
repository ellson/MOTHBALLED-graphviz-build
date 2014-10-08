#!/bin/bash

# set DIR=ARCHIVE to build stable release
#     DIR=CURRENT (or empty) to build the current snapshot
DIR=$1

BUILD_HOSTS="fc20-64 fc20 fc19-64 fc19 fc18-64 fc18 centos6-64 centos6 centos5-64 centos5"
parallel -j 2 --arg-sep ::: ssh -x {} PATH=/usr/bin:/bin:$PATH graphviz-build/redhat/graphviz-bin-rpm.tcl $DIR ::: $BUILD_HOSTS

BUILD_HOSTS="ubuntu12 ubuntu12-64 ubuntu13 ubuntu13-64"
parallel -j 2 --arg-sep ::: ssh -x {} graphviz-build/ubuntu/graphviz-bin-deb.tcl $DIR ::: $BUILD_HOSTS

BUILD_HOSTS="snares"
parallel -j 2 --arg-sep ::: ssh -x {} graphviz-build/macosx/graphviz-snowleopard-bin-pkg.sh $DIR ::: $BUILD_HOSTS

BUILD_HOSTS="pome"
parallel -j 2 --arg-sep ::: ssh -x {} graphviz-build/macosx/graphviz-mountainlion-bin-pkg.sh $DIR ::: $BUILD_HOSTS

BUILD_HOSTS="empire"
parallel -j 2 --arg-sep ::: ssh -x {} graphviz-build/macosx/graphviz-lion-bin-pkg.sh $DIR ::: $BUILD_HOSTS
