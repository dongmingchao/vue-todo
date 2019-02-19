#!/usr/bin/env bash
workspace=../www
rm -rf $workspace/dist
cp -r dist $workspace/dist
cp _public/index.html $workspace/
cd $workspace
cordova run