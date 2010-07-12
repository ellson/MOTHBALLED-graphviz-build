#!/bin/bash

date

#prll.sh should already be in user's shell
#source bin/prll.sh

VHOSTS="fc10 fc10-64 \
	fc11 fc11-64 \
	fc12 fc12-64 \
	fc13 fc13-64 \
	centos4 centos4-64 \
	centos5 centos5-64"

#for i in $VHOSTS; do echo $i;done

function vtest() {
	exec ssh $1 graphviz-build/redhat/graphviz-bin-rpm.tcl ;
}

PRLL_NR_CPUS=2 prll vtest $VHOSTS

date

function vtest_att() {
	exec ssh $1 graphviz-build/redhat/graphviz-bin-att-rpm.tcl ;
}

PRLL_NR_CPUS=2 prll vtest_att $VHOSTS

date
