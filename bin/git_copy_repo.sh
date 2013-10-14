#!/bin/bash
[ $# -eq 0 ] && { echo "Usage $0 repo_name"; exit 1; }

rm -f master master.* 
wget https://github.com/ellson/$1/archive/master.zip
if test -f master.zip; then
	unzip -q master.zip
	rm master.zip
else
	if test -f master; then
		unzip -q master
		rm master
	else
		echo "Failed to transfer master.zip"; exit 1
	fi
fi
(if test -d $1; then rm -rf $1; fi; mv ${1}-master $1; exit)
