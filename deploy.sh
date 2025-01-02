#!/usr/bin/env sh

set -e

npm run docs:build

cd docs/.vuepress/dist

# 如果发布到自定义域名
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

# git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git main

git push -f git@github.com:simin-xxm/simin-xxm.git main:gh-pages

cd -
