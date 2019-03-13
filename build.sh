#!/usr/bin/env bash
workspace=../www
rm -rf $workspace/dist
cp platforms/android/* dist/
cp -r dist $workspace/dist
cd $workspace
cordova run