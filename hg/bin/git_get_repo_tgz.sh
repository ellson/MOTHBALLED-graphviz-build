#!/bin/bash

[ $# -eq 0 ] && { echo "Usage $0 git_repository_name"; exit 999; }
cd /home/gviz

base=$1
OUT="output_${base}_git"
> $OUT
#Remove the compressed file to force git to update its repo and reset timestamps

#*******************************************************************************
#Remove _git after testing is completed
#*******************************************************************************

rm ${base}_git.tgz >> $OUT 2>&1
#Set timestamps, create compressed file
bin/git_archive.sh ${base} >> $OUT 2>&1
if [ ! -s $OUT ]
then
	rm $OUT
fi

