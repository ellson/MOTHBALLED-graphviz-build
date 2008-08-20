#!/usr/bin/tclsh

# $Id$ $Revision$

#################################################

set graphviz_host www.graphviz.org
set graphviz_path /pub/ext_repos

################################################
set build_host [exec uname -n]
set work $env(HOME)/tmp/gviz/$build_host
set rpmbuild $env(HOME)/rpmbuild/$build_host
file mkdir $work $rpmbuild/BUILD $rpmbuild/SPECS $rpmbuild/RPMS $rpmbuild/SRPMS

set source_dir CURRENT
if {$argc} {
   set source_dir [lindex $argv 0]
}
if {[string equal $source_dir CURRENT]} {
    set path $graphviz_path/development
} {
    set path $graphviz_path/stable
}

proc getfile {host path fn} { exec scp $host:/$path/$fn . }
proc makedir {host path} { exec ssh $host "mkdir -p $path" }
proc createrepo {host path} { exec ssh $host "cd $path; createrepo ." }
proc putfile {host path fn} { exec scp $fn $host:/$path/ }
proc getindex {host path} { exec ssh $host ls $path }

cd $work
foreach f [glob -nocomplain webdot*] {file delete -force $f}

set SOURCES $path/SOURCES

set index [getindex $graphviz_host $SOURCES]
foreach {. v} [regexp -all -inline -- {webdot-([0-9.]*?).tar.gz} $index] {
  lappend versions $v
}
if {! [info exists versions]} {
    puts stderr "no webdot snapshots found"
    exit
}
set version [lindex [lsort -decreasing -dictionary $versions] 0]

set sourcefile webdot-$version.tar.gz

puts "getting $sourcefile"

# get sourcefile into local temporary directory
getfile $graphviz_host $SOURCES $sourcefile

puts "making..."

# make products
catch {exec rpmbuild --quiet -ta $sourcefile} buildlog

set f [open webdot-linux-buildlog-$version.txt w]
puts $f $buildlog
close $f

puts "... done making."

set productfiles [concat \
  [glob -nocomplain $rpmbuild/RPMS/noarch/webdot*$version*.noarch.rpm] \
  webdot-linux-buildlog-$version.txt]

set RPMS $path/RPMS/noarch
makedir $graphviz_host $RPMS

foreach fn $productfiles {
  putfile $graphviz_host $RPMS $fn
}
createrepo $graphviz_host $RPMS

puts "done"
