#!/usr/bin/tclsh

# $Id$ $Revision$

#################################################

set graphviz_host www.graphviz.org
set graphviz_path /pub/graphviz

################################################
set build_host [exec uname -n]
set work $env(HOME)/tmp/gviz/$build_host
set rpmbuild $env(HOME)/rpmbuild/$build_host
file mkdir $work $rpmbuild/BUILD $rpmbuild/SPECS $rpmbuild/RPMS $rpmbuild/SRPMS

set source_dir CURRENT
if {$argc} {
   set source_dir [lindex $argv 0]
}
set path $graphviz_path/$source_dir

proc getfile {host path sourcefile} { exec scp $host:/$path/$sourcefile . }
proc putfile {host path fn} { exec scp $fn $host:/$path/ }
proc getindex {host path} { exec ssh $host ls $path }

cd $work
foreach f [glob -nocomplain webdot*] {file delete -force $f}

set index [getindex $graphviz_host $path]
foreach {. v} [regexp -all -inline -- {webdot-([0-9.]*?).tar.gz} $index] {
  lappend versions $v
}
if {! [info exists versions]} {
    error "no webdot snapshots found"
}
set version [lindex [lsort -decreasing -dictionary $versions] 0]

set sourcefile webdot-$version.tar.gz

puts "getting $sourcefile"

# get sourcefile into local temporary directory
getfile $graphviz_host $path $sourcefile

puts "making..."

# make products
catch {exec rpmbuild --quiet -ta $sourcefile} buildlog

set f [open webdot-linux-buildlog-$version.txt w]
puts $f $buildlog
close $f

puts "... done making."

set productfiles [concat \
  [glob -nocomplain $rpmbuild/RPMS/noarch/webdot*$version*.noarch.rpm] \
  [glob -nocomplain $rpmbuild/SRPMS/webdot*$version*.src.rpm] \
  webdot-linux-buildlog-$version.txt]

foreach fn $productfiles {
  putfile $graphviz_host $path $fn
}

puts "done"
