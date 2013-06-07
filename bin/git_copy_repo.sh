#!/bin/bash
[ $# -eq 0 ] && { echo "Usage $0 git_copy_repo repo_name"; exit 999; }

base=$1

SERVER="hg.research.att.com"
USR="gviz"

OUT="git_output_$base"
> $OUT
ssh $USR@$SERVER "(bin/git_get_repo_tgz.sh ${base})" > $OUT 2>&1
scp -r $USR@$SERVER:${base}_git.tgz . >> $OUT 2>&1
tar xzf ${base}_git.tgz 2>> $OUT
chmod 775 ${base}_git >> $OUT 2>&1
touch ${base}_git
rm ${base}_git.tgz >> $OUT 2>&1
if [ ! -s $OUT ]
then
	rm $OUT
fi

