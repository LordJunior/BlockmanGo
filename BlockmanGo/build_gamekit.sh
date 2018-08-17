#!/bin/bash

#更新timeout
export FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT=120

#计时
SECONDS=0

#脚本在项目文件的路径下
project_path="$(pwd)"

#取当前时间字符串添加到文件结尾
now=$(date +"%Y-%m-%d-%H-%M-%S")

#指定项目scheme名称
cloth_scheme="Clothes"
gameclient_scheme="GameClient"
core_scheme="Core"
gender_scheme="GLES2Render"
logic_scheme="Logic"
gamekit_scheme="BlockModsGameKit"

#指定打包的配置名
configuration="Release"

#指定项目地址
workspace_path="$project_path/BlockmanGo.xcworkspace"

#指定资源目的地址
engine_resource_destination_path="$project_path/BlockmanGo/EngineResource/"

#库的输出路径
cloth_output_path="/Users/kiben/blockmango-client/dev/clothes/Bin/Release/lib${cloth_scheme}.a"
gameclient_output_path="/Users/kiben/blockmango-client/dev/client/Bin/Release/lib${gameclient_scheme}.a"
core_output_path="/Users/kiben/blockmango-client/dev/engine/Bin/Release/libLord${core_scheme}.a"
gender_output_path="/Users/kiben/blockmango-client/dev/engine/Bin/Release/libLord${gender_scheme}.a"
logic_output_path="/Users/kiben/blockmango-client/dev/logic/Bin/Release/lib${logic_scheme}.a"

#GameKit的输出路径
gamekit_output_path="/Users/kiben/blockmango-client/dev/client/Shells/IOS/BlockModsGameKit/BlockModsGameKit/Bin/Release/${gamekit_scheme}.framework"

#把引擎相关的库拷贝到指定路径
libs_destination_path="/Users/kiben/blockmango-client/dev/client/Shells/IOS/BlockModsGameKit/BlockModsGameKit/"
#把GameKit拷贝到指定路径
gamekit_destination_path="${project_path}/BlockmanGo/"

#编译Clothes
xcodebuild build -workspace ${workspace_path} -scheme ${cloth_scheme} -configuration ${configuration}
cp ${cloth_output_path} ${libs_destination_path}

#编译Core
xcodebuild build -workspace ${workspace_path} -scheme ${core_scheme} -configuration ${configuration}
cp ${core_output_path} ${libs_destination_path}

#编译Gender
xcodebuild build -workspace ${workspace_path} -scheme ${gender_scheme} -configuration ${configuration}
cp ${gender_output_path} ${libs_destination_path}

#编译Logic
xcodebuild build -workspace ${workspace_path} -scheme ${logic_scheme} -configuration ${configuration}
cp ${logic_output_path} ${libs_destination_path}

#编译Client
xcodebuild build -workspace ${workspace_path} -scheme ${gameclient_scheme} -configuration ${configuration}
cp ${gameclient_output_path} ${libs_destination_path}

#编译Gamekit
xcodebuild build -workspace ${workspace_path} -scheme ${gamekit_scheme} -configuration ${configuration}
cp -R ${gamekit_output_path} ${gamekit_destination_path}

#引用拷贝资源脚本
source ./copyResource.sh $engine_resource_destination_path
#替换装饰路径下的默认背景图
cp $project_path/decorate_default_bg.png $engine_resource_destination_path/Media/Decorate/decorate_default_bg.png

#输出总用时
echo "-----Finished. Total time: ${SECONDS}s -----"


