#!/bin/bash

set -euxo pipefail

# Check out the master branch and freshly build the documentation
# and install to /tmp
git checkout master
rm -rfv ./build
mkdir -p /tmp/TaichiExperiments
rm -rfv /tmp/TaichiExperiments
./build.sh /tmp/TaichiExperiments

# Checkout the gh-pages branch, remove all files, and copy the
# installed documentation into the repo root.
git checkout gh-pages
rm -rf *
cp -r /tmp/TaichiExperiments/docs/doxygen_docs/html/* ./

# Clean-up temporary install location.
rm -rfv /tmp/TaichiExperiments

# Stage and commit the changes, optionally rebasing (interactively).
git add *
git commit -a -m "Updated documentation."
git rebase --interactive --root

# Then, force push the changes (living dangerously).
git push origin -f

# Switch back to the master branch.
git checkout master
