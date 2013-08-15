#!/bin/bash

[ $# -eq 0 ] && { echo "Usage $0 git_repository_name"; exit 999; }
base=$1


cd ~/graphviz
git pull
git archive --format=tar HEAD doc/* | gzip > ~/doc.tgz

cd ~/${base}
git archive --format=tar HEAD | gzip > ~/html.tgz



