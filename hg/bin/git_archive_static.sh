#!/bin/bash

[ $# -eq 0 ] && { echo "Usage $0 git_repository_name"; exit 999; }
base=$1

#Remove _git from the lines below after testing is finished
cd /home/gitroot/graphviz.git
git archive --format=tar HEAD doc/* | gzip > ~/doc_git.tgz

cd /home/gitroot/${base}.git
git archive --format=tar HEAD | gzip > ~/html_git.tgz



