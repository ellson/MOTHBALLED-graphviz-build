#!/bin/bash

base="graphviz-web"
#remove _git after testing is done
git_repo=${base}-dynamic_git
OUT=output_$git_repo
cd /home/gviz
rm ${git_repo}.tgz >> $OUT 2>&1
#Update set timestamps, create compressed file
bin/git_archive_dynamic.sh $git_repo >> $OUT 2>&1
if [ ! -s $OUT ]
then
	rm $OUT
fi

