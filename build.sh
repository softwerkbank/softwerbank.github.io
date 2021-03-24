#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
jekyll build

echo "built static site successfully"

# cleanup
rm -rf ../softwerkbank.github.io.gh-pages

echo "cloning gh-pages branch"

#clone `gh-pages' branch of the repository using encrypted GH_TOKEN for authentification
git clone -b gh-pages https://${GH_TOKEN}@github.com/softwerkbank/softwerkbank.github.io.git ../softwerkbank.github.io.gh-pages

echo "finished cloning"

# copy generated HTML site to `gh-pages' branch
cp -R _site/* ../softwerkbank.github.io.gh-pages

# commit and push generated content to `gh-pages' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../softwerkbank.github.io.gh-pages
echo "pushing changes"
git config user.email "kevinwerner85@googlemail.com"
git config user.name "Kevin Werner"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin gh-pages > /dev/null 2>&1

echo "changes pushed"