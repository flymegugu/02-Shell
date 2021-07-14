###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:34:33
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:34:47
# @Description:
###
#!/bin/bash
#wiki的数据库备份
#保存备份个数，备份7天数据
number=7
#备份保存路径
backup_dir=/data2/wiki_db
#日期
dd=$(date +%Y-%m-%d-%H:%M:%S)
#备份工具
tool=mysqldump
#用户名 mysql5.7 mysqldump需要再配置文件写用户密码
#username=root
#密码
#password=xxx
#将要备份的数据库

database_name=confluencedb

#如果文件夹不存在则创建
if [ ! -d $backup_dir ]; then
	mkdir -p $backup_dir
fi

$tool $database_name --quick --events --single-transaction >$backup_dir/Full-$database_name-$dd.sql

#写创建备份日志
echo "create $backup_dir/Full-$database_name-$dd.dupm" >>$backup_dir/log.txt

#找出需要删除的备份
delfile=$(ls -lrt $backup_dir/*.sql | awk '{print $9 }' | head -1)

#判断现在的备份数量是否大于$number
count=$(ls -lrt $backup_dir/*.sql | awk '{print $9 }' | wc -l)

if [ $count -gt $number ]; then
	#删除最早生成的备份，只保留number数量的备份
	rm $delfile -f
	#写删除文件日志
	echo "delete $delfile" >>$backup_dir/log.txt
fi
