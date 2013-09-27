#!/usr/bin/tclsh

# $Id$ $Revision$

#set own att       - no special AT&T support in graphviz.spec.in  anymore
set own ""

set rtest 0

source [file dirname $argv0]/build1.common

set pkg graphviz
set isnoarch 0

source [file dirname $argv0]/build2.common
source [file dirname $argv0]/build3.common
