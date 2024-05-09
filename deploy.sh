#!/bin/bash

git_user=maxisioux

git remote remove site
git remote add site https://github.com/${git_user}/${git_user}.github.io.git

echo "-->start deploy the update docs to github.io"
mkdocs gh-deploy --config-file mkdocs.yml --remote-name site --remote-branch main

echo "-->deploy finshed, check the site with: https://${git_user}.github.io"

