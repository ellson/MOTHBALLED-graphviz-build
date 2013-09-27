#!/usr/bin/tclsh

# $Id$ $Revision$

set own ""

source [file dirname $argv0]/build1.common

#set pkg webdot
#set isnoarch 1
#
#source [file dirname $argv0]/build2.common

set pkg graphviz
set isnoarch 0

source [file dirname $argv0]/build2.common
source [file dirname $argv0]/build.variations
source [file dirname $argv0]/build3.common
