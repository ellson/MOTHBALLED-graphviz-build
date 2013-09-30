#!/bin/bash
[ $# -eq 0 ] && { echo "Usage $0 repo_name"; exit 1; }

rm -f master.zip*
wget https://github.com/ellson/$1/archive/master.zip
unzip master.zip
(rm -rf $1 master.zip;mv ${1}-master $1)

