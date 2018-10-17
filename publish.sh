#!/bin/bash

# go to the output directory and create a new git repo
mkdir output
cp -r dist output/
cp -r apis output/
cp -r _public/* output/
cp -r src/assets output/

cd output || exit 1 # abort script if folder does not exists
git init

# inside this git repo we'll pretend to be a new user
git config user.name "Travis CI"
git config user.email "${GH_EMAIL}"

# The first and only commit to this new Git repo contains all the
# files present with the commit message "Deploy to GitHub Pages".
git add .
git commit -m "Deploy to GitHub Pages $(date)"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
git push --force "https://${GH_TOKEN}@${GH_REF}" master:gh-pages
git push --force "https://${GE_TOKEN}@${GE_REF}" master:gh-pages

exit $?