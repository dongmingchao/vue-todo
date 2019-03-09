#!/usr/bin/env bash
workspace=../www
rm -rf $workspace/dist
cp -r dist $workspace/dist
cd $workspace
cordova run