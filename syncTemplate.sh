#!/bin/bash

# syncTemplate.sh
#
# Utility to sync the latest CMakeTemplate components by cloning into /tmp
# and copying a subset of files into the current project.
#
# This tool should be run at the _root_ of the locally checked out repository.

set -euxo pipefail

rm -rf /tmp/CMakeTemplate
git clone https://github.com/moddyz/CMakeTemplate /tmp/CMakeTemplate
cp -r /tmp/CMakeTemplate/cmake/macros/* ./cmake/macros/
cp -r /tmp/CMakeTemplate/.clang-format ./
cp -r /tmp/CMakeTemplate/syncTemplate.sh ./
