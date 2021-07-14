###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:35:11
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:35:25
# @Description: mysql应用数据备份
###
#!/bin/bash
#因为需要关闭mysql服务，所以目前不启动此脚本
#用于备份mysql数据库目录
#保存备份个数，备份31天数据
number=4
#备份保存路径
backup_dir=/data2/data1-mysql
#日期
dd=$(date +%Y-%m-%d-%H-%M-%S)
src=/data1/mysql
name=mysql

#如果文件夹不存在则创建
if [ ! -d ${backup_dir} ]; then
	mkdir -p ${backup_dir}
fi
cd $backup_dir
tar -czPf $name-$dd-bak.tar.gz $src

#写创建备份日志
echo "create $name-$dd-bak.tar.gz" >>${backup_dir}/log.txt

#找出需要删除的备份
delfile=$(ls -l -crt ${backup_dir}/*.gz | awk '{print $9 }' | head -1)

#判断现在的备份数量是否大于$number
count=$(ls -l -crt ${backup_dir}/*.gz | awk '{print $9 }' | wc -l)

if [ $count -gt $number ]; then
	#删除最早生成的备份，只保留number数量的备份
	rm $delfile
	#写删除文件日志
	echo "delete $delfile" >>${backup_dir}/log.txt
fi
