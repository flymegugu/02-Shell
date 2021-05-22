#!/bin/bash
#此脚本用于进行deb包打包
#此脚本防止文件夹同目录,在当前目录下创建output目录,且需要打包的文件夹存在于src目录中
set -e
DebName=kata-container
Dir=$(pwd)
dpkg -b ${Dir}/src ${Dir}/output/${DebName}.deb
