#!/bin/bash

# Script to build archive releases of the vim4rally plugin

function usage() {
  echo "Creates a distributable release archive for vim4rally plugin."
  echo ""
  echo "Usage: $0 release-name"
  echo ""
}

# require only 1 argument
if [ $# -eq 0 -o $# -gt 1 ]; then
  usage && exit 1
fi

release_name=$1

echo "Creating vim4rally release: ${release_name}"

archive_files="plugin/rally.properties plugin/rally.vim plugin/lib "
archive_files+="doc/rally.txt CHANGES.vim4rally INSTALL.vim4rally README.vim4rally "
archive_files+="syntax/rally.vim "
archive_files+="autoload/vim/widgets/progressbar.vim "
archive_files+=
base_dir=$(dirname $0)/..
release_dir=${base_dir}/releases

archive_name=${release_dir}/vim4rally_${release_name}.tgz

# Create archive
# note: exclude subversion files
# note: move plugin files under plugin/rally for vim location
tar -C ${base_dir} --exclude=.svn --transform "s@plugin@plugin/rally@" -czvf ${archive_name} ${archive_files}

echo "Generated archive: ${archive_name}"

exit 0
