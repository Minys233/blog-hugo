#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
# delete fucking DS_Store
rm **/.DS_Store
# Build the project.
hugo -t meme # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
echo "Go to public submodule"
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
echo "Push public"
git push origin master

# Come Back up to the Project Root
echo "Back to main module"
cd ..
git add .
git commit -m "$msg"
echo "Push main module"
git push

