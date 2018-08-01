#!/bin/bash

#更新timeout
export FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT=120

if [ ! $1 ]; then
    echo "请输入参数， 并且是个目录"
    exit
fi

if [ ! -d $1 ]; then
    echo "输入参数 不是一个目录"
    exit
fi

#计时
SECONDS=0

destination_Path=$1

#资源所在路径
engineResource_Path="/Users/kiben/blockmango-client/res/client"

cd ${engineResource_Path}

for file in `ls`
do
case $file in
    "Media")
            cp -R ${engineResource_Path}/${file} ${destination_Path}
            ;;
    "recipe")
            cp -R ${engineResource_Path}/${file} ${destination_Path}
            ;;
    "resource.cfg")
            cp ${engineResource_Path}/${file} ${destination_Path}
            ;;
esac
done

#输出总用时
echo "-----Finished. Total time: ${SECONDS}s -----"


