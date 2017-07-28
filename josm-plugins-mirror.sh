#!/bin/bash -e

date -Is

cd /home/josm/mirrors/josm-plugins/
pwd

# Pull changes from Subversion
echo $ git checkout master
git checkout master
echo $ git svn fetch
git svn fetch
echo $ git svn rebase
git svn rebase

# Commit externals changes, if any
git config user.name "JOSM GitHub mirror"
git config user.email "openstreetmap@v.nix.is"

# Push the mirror to GitHub
echo $ git remote add mirror git@github.com-josm-plugins:openstreetmap/josm-plugins.git
git remote add mirror git@github.com-josm-plugins:openstreetmap/josm-plugins.git || :
echo $ git push -v mirror master
git push -v mirror master

echo Done ...
echo
