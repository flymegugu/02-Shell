#!/bin/bash
#用于批量保存镜像至压缩包
source /etc/profile
mkdir $HOME/images_Dir &> /dev/null
dir=$HOME/images_Dir
images_name=$dir/images_name.txt

#images_tar=$HOME/images_tar.txt
#### 镜像名字
docker images | awk 'BEGIN {FS=" ";OFS=":"}{print $1,$2}'|awk 'NR>1 {print $1}' >$images_name
#### 镜像tar包名
#docker images | awk -F" " '{print $1}'|awk 'NR>1 {print $1}'|sed 's@\/@-@g'>$images_tar
while read line
do
  echo $line > $dir/tmp.txt
  docker save $line > $dir/"`awk -F":" '{print $1 "-" $NF}' $dir/tmp.txt | sed -r 's@\.|\/@-@g'`".tar
done < $images_name
echo "docker save finished  in $dir !"
