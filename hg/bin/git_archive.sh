#!/bin/bash

[ $# -eq 0 ] && { echo "Usage $0 git_repository_name"; exit 999; }
base=$1

cd /home/gitroot/${base}.git

git archive --format=tar --prefix="${base}_git/" HEAD | gzip > ~/${base}_git.tgz



