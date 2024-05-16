#!/usr/bin/env bash

last_commit_id=`git rev-parse HEAD`

git remote add website_repo https://github.com/maxisioux/maxisioux.github.io.git &>/dev/null
.venv/bin/mkdocs gh-deploy \
  --force --ignore-version \
  --remote-name website_repo \
  --remote-branch main

git reset --hard ${last_commit_id}

