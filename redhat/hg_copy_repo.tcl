#!/bin/env expect
  
if {$argc == 0} {
        send_user "Usage: $argv0 repository_name\n"
        exit
}
set timeout 300 
foreach {a1} $argv {break}
 
spawn ~/graphviz-build/bin/hg_copy_repo.sh $a1
while {1} {
        expect timeout {
                send_user "Failed to checkout $a1 from mercurial server (timeout)\n"
                exit
        } eof {
                break
        }
}
