###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:38:29
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:38:40
# @Description:
###
#!/bin/bash
#bitbucket数据库备份
#保存备份个数，备份7天数据
NUMBER=7
#备份保存路径
BAK_DIR=/data1/psql_db
#日期
TIME=$(date +%Y-%m-%d-%H:%M:%S)
#备份工具

TOOL=pg_dump

DB_NAME=bitbucketdb

#如果文件夹不存在则创建
if [ ! -d ${BAK_DIR} ]; then
	mkdir -p ${BAK_DIR}
fi

$TOOL $DB_NAME >$BAK_DIR/$DB_NAME-$TIME.sql

#写创建备份日志
echo -e "\e[1;42mcreate $BAK_DIR/$DB_NAME-$TIME.dupm\e[0m \n" >>$BAK_DIR/log.txt

#找出需要删除的备份
DELFILE=$(ls -lrt ${BAK_DIR}/*.sql | awk '{print $9 }' | head -1)

#判断现在的备份数量是否大于$NUMBER
COUNT=$(ls -lrt $BAK_DIR/*.sql | awk '{print $9 }' | wc -l)

if [ $COUNT -gt $NUMBER ]; then
	#删除最早生成的备份，只保留NUMBER数量的备份
	rm $DELFILE -f
	#写删除文件日志
	echo -e "\e[1;31mdelete $DELFILE\e[0m\n" >>$BAK_DIR/log.txt
fi
