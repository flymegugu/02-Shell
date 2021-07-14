###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:01:01
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 14:16:45
# @Description: 附件备份
###
#!/bin/bash

#保存备份个数，备份7天数据
NUMBER=7
#备份保存路径
BACKUP_DIR=/WIKI_BAKUP/wikiAttach
SRC=/var/atlassian/application-data/confluence/attachments
#日期
DATE_TIME=$(date +%Y%m%d-%H-%M-%S)

NAME=wiki_attach

#如果文件夹不存在则创建
if [ ! -d ${BACKUP_DIR} ]; then
	mkdir -p ${BACKUP_DIR}
fi
cd $SRC
tar -czf "${NAME}_${DATE_TIME}_bak.tar.gz" $SRC
mv "${NAME}_${DATE_TIME}_bak.tar.gz" ${BACKUP_DIR}

#写创建备份日志
echo -e "at $(date) create ${NAME}_${DATE_TIME}_bak.tar.gz\n" >>${BACKUP_DIR}/log.txt

#找出需要删除的备份
DELFILE=$(ls -l -crt ${BACKUP_DIR}/*.gz | awk '{print $9 }' | head -1)

#判断现在的备份数量是否大于$NUMBER
COUNT=$(ls -l -crt ${BACKUP_DIR}/*.gz | awk '{print $9 }' | wc -l)

if [ ${COUNT} -gt ${NUMBER} ]; then
	#删除最早生成的备份，只保留NUMBER数量的备份
	rm ${DELFILE}
	#写删除文件日志
	echo -e "at $(date) delete ${DELFILE} \n" >>${BACKUP_DIR}/log.txt
fi
