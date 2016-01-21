#!/bin/bash -e

date -Is

cd /home/simon/mirrors/josm-plugins/
pwd

# Initializing at the first time:
# git svn init http://svn.openstreetmap.org/applications/editors/josm/plugins/

# Pull changes from Subversion
echo $ git checkout master
git checkout master
echo $ git svn fetch
git svn fetch
echo $ git svn rebase
git svn rebase

# Just do a plain copy of the externals into this repository.
svn_external () {
  dir_to=${1}${3:-}
  rm -rf $dir_to
  echo $ svn export $2 $dir_to
  svn export --force $2 $dir_to
}
# To update this list, $ git svn show-externals | grep '^/' | sed 's/^./svn_external /'
svn_external 00_core_tools http://josm.openstreetmap.de/svn/trunk/tools
svn_external 00_core_test_lib http://josm.openstreetmap.de/svn/trunk/test/lib
svn_external areaselector https://github.com/JOSM/JOSM-areaselector/trunk
svn_external conflation https://github.com/JOSM/josm-conflation-plugin/trunk
svn_external tofix https://github.com/JOSM/tofix-plugin/trunk
svn_external continuosDownload https://github.com/JOSM/JOSM-continuos-download/trunk
svn_external ElevationProfile/test/config https://josm.openstreetmap.de/svn/trunk/test/config
svn_external ImportImagePlugin/test/config https://josm.openstreetmap.de/svn/trunk/test/config
svn_external alignways/test/config https://josm.openstreetmap.de/svn/trunk/test/config
svn_external apache-commons/src/org/apache/commons/imaging http://svn.apache.org/repos/asf/commons/proper/imaging/trunk/src/main/java/org/apache/commons/imaging
svn_external apache-commons/src/org/apache/commons/io http://svn.apache.org/repos/asf/commons/proper/io/trunk/src/main/java/org/apache/commons/io
svn_external apache-commons/src/org/apache/commons/lang3 https://github.com/apache/commons-lang/trunk/src/main/java/org/apache/commons/lang3
svn_external apache-commons/src/org/apache/commons/collections4 https://github.com/apache/commons-collections/trunk/src/main/java/org/apache/commons/collections4
svn_external graphview/test/config https://josm.openstreetmap.de/svn/trunk/test/config
svn_external mapillary/test/config https://josm.openstreetmap.de/svn/trunk/test/config
svn_external opendata/test/config https://josm.openstreetmap.de/svn/trunk/test/config
svn_external osmarender/stylesheets http://svn.openstreetmap.org/applications/rendering/osmarender/stylesheets
svn_external osmarender/xslt http://svn.openstreetmap.org/applications/rendering/osmarender/xslt
svn_external pbf/proto https://github.com/scrosby/OSM-binary/trunk/src
svn_external pbf/protobuf https://github.com/google/protobuf/tags/v2.6.1/src/google/protobuf/
svn_external pbf/src/crosby https://github.com/scrosby/OSM-binary/trunk/src.java/crosby
svn_external pbf/src/com/google/protobuf http://protobuf.googlecode.com/svn/tags/2.6.0/java/src/main/java/com/google/protobuf
svn_external turnrestrictions/test/config https://josm.openstreetmap.de/svn/trunk/test/config
svn_external wikipedia/test/config https://josm.openstreetmap.de/svn/trunk/test/config

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
