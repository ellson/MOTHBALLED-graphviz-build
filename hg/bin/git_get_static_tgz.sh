#!/bin/bash

base="graphviz-web"

git_repo=${base}-static
OUT=output_$git_repo
>$OUT
cd /home/gviz

rm ${git_repo}.tgz >> $OUT 2>&1
rm doc.tgz >> $OUT 2>&1
#Set timestamps, create compressed file
bin/git_archive_static.sh $git_repo >> $OUT 2>&1
if [ ! -s $OUT ]
then
	rm $OUT
fi

