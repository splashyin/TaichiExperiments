#!/bin/bash

# syncTemplate.sh
#
# Utility to sync the latest cmakeExample components by cloning into /tmp
# and copying a subset of files into the current project.
#
# This tool should be run at the _root_ of the locally checked out repository.

set -euxo pipefail

rm -rf /tmp/cmakeExample
git clone https://github.com/moddyz/cmakeExample /tmp/cmakeExample
cp -r /tmp/cmakeExample/cmake/macros/* ./cmake/macros/
cp -r /tmp/cmakeExample/.clang-format ./
cp -r /tmp/cmakeExample/syncTemplate.sh ./
