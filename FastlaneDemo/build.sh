#!/bin/sh

#
# usage:
# > sh build.sh 1.0.0 200
#

versionNumber=$1 # 1.0.0
buildNumber=$2 # 2000

rm -rf build

basicLanes="InHouse"
for laneName in $basicLanes
do
    fastlane $laneName version:$versionNumber build:$buildNumber
done

channelIds="56d6b3f6e75e2d04e1000010"
for channelId in $channelIds
do
    fastlane Channel version:$versionNumber build:$buildNumber channel_id:$channelId
done

