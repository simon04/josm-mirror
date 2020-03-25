#!/bin/bash -e
set -e

date -Is

cd /home/josm/mirrors/josm/
pwd

# Pull changes from Subversion
echo $ git checkout master
git checkout master
echo $ git svn fetch
git svn fetch
echo $ git svn rebase
git svn rebase

# Push the mirror to GitHub
echo $ git remote add mirror git@github.com-josm:openstreetmap/josm.git
git remote add mirror git@github.com-josm:openstreetmap/josm.git || :

# Push to our mirrors
echo $ git push -v mirror master
git push -v mirror master

echo Done ...
echo
