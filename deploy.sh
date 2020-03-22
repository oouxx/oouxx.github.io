#!/usr/bin/env bash

hugo
git add .
git commit -m "`date` update"
git push origin master:hugo
cd ./public
git commit -m "`date` update"
git push origin master:master
