#!/usr/bin/env bash
workspace=../www
rm -rf $workspace/dist
cp plantform/android/* dist/
cp -r dist $workspace/dist
cd $workspace
cordova build