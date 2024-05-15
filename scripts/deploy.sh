#!/usr/bin/env bash

git remote add maxisioux.github.io git@github.com:maxisioux/maxisioux.github.io &>/dev/null
.venv/bin/mkdocs gh-deploy \
  --force --ignore-version \
  --remote-name maxisioux.github.io \
  --remote-branch main
