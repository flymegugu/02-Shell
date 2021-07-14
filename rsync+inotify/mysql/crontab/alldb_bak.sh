###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:32:58
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:33:10
# @Description:
###
#!/bin/bash
#全备份mysql数据库所有库，用于作为增量恢复基础库
#保存备份个数，备份2天数据
number=2
#备份保存路径
backup_dir=/data2/all_db
#日期
dd=$(date +%Y-%m-%d-%H:%M:%S)
#备份工具
tool=mysqldump
#用户名 mysql5.7 mysqldump需要再配置文件写用户密码

database_name=all-databases

#如果文件夹不存在则创建
if [ ! -d $backup_dir ]; then
	mkdir -p $backup_dir
fi

$tool --all-databases --quick --events --flush-logs --single-transaction >${backup_dir}/all-databases-$dd.sql

#写创建备份日志
echo -e "\e[1;42mcreate ${backup_dir}/${database_name}-$dd.dupm\e[0m \n" >>${backup_dir}/log.txt

#找出需要删除的备份
delfile=$(ls -lrt ${backup_dir}/*.sql | awk '{print $9 }' | head -1)

#判断现在的备份数量是否大于$number
count=$(ls -lrt ${backup_dir}/*.sql | awk '{print $9 }' | wc -l)

if [ $count -gt $number ]; then
	#删除最早生成的备份，只保留number数量的备份
	rm $delfile -f
	#写删除文件日志
	echo -e "\e[1;31mdelete $delfile\e[0m\n" >>${backup_dir}/log.txt
fi
