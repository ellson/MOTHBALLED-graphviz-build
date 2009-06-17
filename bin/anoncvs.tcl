#!/usr/bin/expect --
  
if {$argc == 0} {
        send_user "Usage: $argv0 checkout <module>\n"
        send_user "       $argv0 update\n"
        exit
}
 
foreach {a1 a2 a3 a4} $argv {break}
 
spawn cvs -d :pserver:anoncvs@cvs-graphviz.research.att.com:/home/cvsroot login
while {1} {
        expect timeout {
                send_user "Failed to contact cvs server (timeout)\n"
                exit
        } "CVS password: " {
                send "anoncvs\r"
        } eof {
                break
        }
}
set timeout 300
switch $argc {
        1 { spawn cvs -d :pserver:anoncvs@cvs-graphviz.research.att.com:/home/cvsroot $a1 }
        2 { spawn cvs -d :pserver:anoncvs@cvs-graphviz.research.att.com:/home/cvsroot $a1 $a2 }
        3 { spawn cvs -d :pserver:anoncvs@cvs-graphviz.research.att.com:/home/cvsroot $a1 $a2 $a3 }
        4 { spawn cvs -d :pserver:anoncvs@cvs-graphviz.research.att.com:/home/cvsroot $a1 $a2 $a3 $a4 }
}
while {1} {
        expect timeout {
                send_user "Failed to checkout $module from cvs server (timeout)\n"
                exit
        } eof {
                break
        }
}
