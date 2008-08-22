#!/usr/bin/env tclsh

# $Id$ $Revision$


#################################################

#set host www.graphviz.org
set host 192.20.225.20
set path /data/pub/graphviz/CURRENT

set WWWHOST www.research.att.com
set WWWDIR wwwfiles/graphviz_log

set work /tmp/gviz

################################################

source /home/gviz/bin/graphviz-helpers.tcl

cd $work
foreach f [glob -nocomplain graphviz* rtest*] {
  exec rm -rf $f
}

set index [getindex $host $path]
foreach {. v} [regexp -all -inline -- {>graphviz-([0-9.]*?).tar.gz} $index] {
  lappend versions $v
}
if {! [info exists versions]} {
    error "no graphviz snapshots found"
}
set version [lindex [lsort -decreasing -dictionary $versions] 0]

set sourcefile graphviz-$version.tar.gz

#puts "getting http://$host/$path/$sourcefile"

# get sourcefile
getfile $host $path $sourcefile

# get rtest
getfile $host $path rtest.tgz

#puts "making..."

#translation from uname result to ARCH for rtest results
array set ARCH {
	IRIX64.IP27.sgi_cc	sgi.mips3
	IRIX64.IP35.sgi_cc	IRIX64.IP35.sgi_cc
	Linux.i686.gcc2.96	linux.i386
	Linux.i686.gcc3.2.1	linux.i386
	Linux.i686.gcc3.4.6	linux.i386
	Linux.i686.gcc3.5.0	linux.i386
	Linux.i686.gcc4.0.0	linux.i386
	Linux.i686.gcc4.0.1	linux.i386
	Linux.i686.gcc4.0.2	linux.i386
	Linux.i686.gcc4.1.0	linux.i386
	Linux.x86_64.gcc3.2.3	linux.i386
        Linux.x86_64.gcc3.4.3   linux.i386
        Linux.x86_64.gcc4.0.0   linux.i386
        Linux.x86_64.gcc4.0.1   linux.i386
        Linux.x86_64.gcc4.0.2   linux.i386
        Linux.x86_64.gcc4.1.0   linux.i386
	Linux.ia64.icc8.0	Linux.ia64.icc8.0   
	Linux.ia64.icc8.1	Linux.ia64.icc8.0   
	SunOS.sun4u.sun_cc	sol6.sun4
}

if {[info exists env(CC)]} { set CC $env(CC) } { set CC cc }
if {[info exists env(LD)]} { set LD $env(LD) } { set LD ld }
set WHICHCC [exec whichcc $CC]

set GV graphviz-$version
set HOST [lindex [split [info hostname] .] 0]
set PLATFORM $env(PLATFORM)
set PREFIX $env(PREFIX)
set PLATFORMCC $PLATFORM.$WHICHCC
set TESTID $PLATFORMCC.$GV

set LOGDIR $work/graphviz_log
# clean out old results
exec /bin/rm -rf $LOGDIR
set LOGDIR $LOGDIR/$TESTID
file mkdir $LOGDIR

# unpack
exec $env(ZCAT) $GV.tar.gz | $env(TAR) xf -
exec $env(ZCAT) rtest.tgz | $env(TAR) xf -

# make products
cd $work/$GV

set err $LOGDIR/err.txt
set log $LOGDIR/log.txt

set f [open $err w]
puts $f "TEST REPORT: $TESTID"
puts $f "       HOST: $HOST"
puts $f "         CC: $CC"
puts $f "         LD: $LD"
puts $f ""
puts $f "( Full logs at: http://$WWWHOST/~gviz/graphviz_log/ )"
puts $f ""
puts $f "CONFIGURE ERRORS:"
puts $f ""

set have_errs 0

if {[catch {exec [pwd]/configure --prefix=$PREFIX --with-mylibgd --disable-perl  >$log} errs]} {
	puts $f $errs
	flush $f
	incr have_errs
}

puts $f ""
puts $f "MAKE ERRORS:"
puts $f ""

#if {[catch {exec make clean >>$log} errs]} {
#	puts $f $errs
#	flush $f
#	incr have_errs
#}

if {[info exists env(MAKEOPTS)]} {
	if {[catch {exec make $env(MAKEOPTS) >>$log} errs]} {
		puts $f $errs
		flush $f
		incr have_errs
	}
} {
	if {[catch {exec make >>$log} errs]} {
		puts $f $errs
		flush $f
		incr have_errs
	}
}

puts $f ""
puts $f "INSTALL ERRORS:"
puts $f ""

if {[catch {exec make install >>$log} errs]} {
	puts $f $errs
	flush $f
	incr have_errs
}

puts $f ""
puts $f "TEST ERRORS:"
puts $f ""
	
catch {exec dot -V} dotver
set dotver [lindex [split $dotver] 4]
if {![string equal $version $dotver]} {
	puts $f "Wrong version installed: $dotver. Build failure?"
	puts $f "(No further tests will be attempted.)"
	flush $f
	incr have_errs
} {

	cd $work/rtest
	set env(ARCH) $ARCH($PLATFORMCC)
	set env(INSTALLROOT) $PREFIX
	
	if {[catch {exec $env(KSH) [pwd]/doit >>$log} errs]} {
		puts $f $errs
		flush $f
		incr have_errs
	}
}
	
puts $f ""
puts $f "TESTS COMPLETE"
close $f

if {$have_errs} {
#	exec $env(MAILCMD) -s "graphviz build and test errors - $HOST - $PLATFORMCC" erg@research.att.com north@research.att.com ellson@research.att.com <$err
	exec $env(MAILCMD) -s "graphviz build and test errors - $HOST - $PLATFORMCC" north@research.att.com <$err
}

set f [open $LOGDIR/index.html w]
puts $f "<html><head><title>Graphviz Regression Test Report</title></head><body bgcolor=\"white\"><pre>"
puts $f {[<a href="log.txt">build log</a>] [<a href="rtest/">regression test results</a>]}
puts $f ""
set fin [open $err r]
fcopy $fin $f
close $fin
puts $f "</pre></body></html>"
close $f
file delete $err

exec cp -rp $work/rtest/$ARCH($PLATFORMCC) $LOGDIR/rtest
if {[catch {exec ssh $WWWHOST rm -rf $WWWDIR/$PLATFORMCC*} err]} {puts $err}
if {[catch {exec scp -rp $LOGDIR $WWWHOST:$WWWDIR/} err]} {puts $err}
