#!/bin/bash

base="graphviz-web"
#Remove _git from the line below after testing is finished
git_repo=${base}-static
OUT=output_$git_repo
>$OUT
cd /home/gviz
#Remove _git from the lines below after testing is finished
rm ${git_repo}.tgz >> $OUT 2>&1
rm doc_git.tgz >> $OUT 2>&1
#Set timestamps, create compressed file
bin/git_archive_static.sh $git_repo >> $OUT 2>&1
if [ ! -s $OUT ]
then
	rm $OUT
fi

