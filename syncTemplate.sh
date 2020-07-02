#!/bin/bash

# syncTemplate.sh
#
# Utility to sync the latest TaichiExperiments components by cloning into /tmp
# and copying a subset of files into the current project.
#
# This tool should be run at the _root_ of the locally checked out repository.

set -euxo pipefail

rm -rf /tmp/TaichiExperiments
git clone https://github.com/moddyz/TaichiExperiments /tmp/TaichiExperiments
cp -r /tmp/TaichiExperiments/cmake/macros/* ./cmake/macros/
cp -r /tmp/TaichiExperiments/.clang-format ./
cp -r /tmp/TaichiExperiments/syncTemplate.sh ./
