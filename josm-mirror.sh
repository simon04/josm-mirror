#!/bin/bash -e

date -Is

cd /home/simon/mirrors/josm/
pwd

# Pull changes from Subversion
echo $ git checkout master
git checkout master
echo $ git svn fetch
git svn fetch
echo $ git svn rebase
git svn rebase

# Changes already pulled, merge them to the mirror branch
echo $ git branch mirror
git branch mirror || :
echo $ git checkout mirror
git checkout mirror
echo '$ git merge master -m"Merge branch 'master' into mirror"'
git merge master -m"Merge branch 'master' into mirror"

# Just do a plain copy of the externals into this repository.
svn export --force http://svn.apache.org/repos/asf/ant/core/trunk/src/main/org/apache/tools/bzip2                    src/org/apache/tools/bzip2   >/dev/null
svn export --force http://svn.openstreetmap.org/applications/viewer/jmapviewer/src/org/openstreetmap/gui             src/org/openstreetmap/gui    >/dev/null
svn export --force http://svn.openstreetmap.org/applications/share/map-icons/classic.small                           images/styles/standard       >/dev/null
svn export --force http://svn.apache.org/repos/asf/commons/proper/codec/trunk/src/main/java/org/apache/commons/codec src/org/apache/commons/codec >/dev/null

# Commit externals changes, if any
git config user.name "JOSM GitHub mirror"
git config user.email "openstreetmap@v.nix.is"

echo $ git add .
git add .
echo '$ git commit -m"josm-mirror: bumped externals"'
git commit -m"josm-mirror: bumped externals" || :


# Push the mirror to GitHub
echo $ git remote add mirror git@github.com-josm:openstreetmap/josm.git
git remote add mirror git@github.com-josm:openstreetmap/josm.git || :

# Push to our mirrors
echo $ git push -v mirror master
git push -v mirror master
echo $ git push -v mirror mirror
git push -v mirror mirror

echo Done ...
echo
