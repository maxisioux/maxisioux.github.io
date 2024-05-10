#!/bin/bash

#######################################
# 部署前需先将本仓库的修改进行提交
# 部署需要渠道github.io仓库下操作
# 详细的操作说明请参考： mkdocs gh-deploy --help
#######################################

git_user=maxisioux

mkdocs_dir=`pwd`
echo "mkdocs_dir: ${mkdocs_dir}"
pages_dir=${mkdocs_dir}/../${git_user}.github.io
pages_dir=$(cd "$(dirname "$pages_dir")"; pwd)/$(basename "$pages_dir")
echo "pages_dir: ${pages_dir}"

echo "-->start deploy the update docs to github.io"
cd ${pages_dir}
mkdocs gh-deploy --config-file ${mkdocs}/mkdocs.yml --remote-name origin --remote-branch main

cd ${mkdocs_dir}
echo "-->deploy finshed, check the site with: https://${git_user}.github.io"

