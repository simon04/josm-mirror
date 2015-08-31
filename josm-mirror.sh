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
svn_external () {
  dir_to=${1}${3:-}
  rm -rf $dir_to
  echo $ svn export $2 $dir_to
  svn export --force $2 $dir_to
}
# To update this list, $ git svn show-externals | grep '^/' | sed 's/^./svn_external /'
svn_external images/styles/standard http://svn.openstreetmap.org/applications/share/map-icons/classic.small
svn_external src/org/apache/commons/ http://svn.apache.org/repos/asf/commons/proper/jcs/trunk/commons-jcs-core/src/main/java/org/apache/commons/jcs jcs
svn_external src/org/apache/commons/ http://svn.apache.org/repos/asf/commons/proper/logging/trunk/src/main/java/org/apache/commons/logging logging
svn_external src/org/apache/commons/compress/compressors https://github.com/apache/commons-compress/trunk/src/main/java/org/apache/commons/compress/compressors
svn_external src/org/openstreetmap/gui http://svn.openstreetmap.org/applications/viewer/jmapviewer/src/org/openstreetmap/gui
svn_external windows/plugins/stdutils https://github.com/lordmulder/stdutils/tags/1.03

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
