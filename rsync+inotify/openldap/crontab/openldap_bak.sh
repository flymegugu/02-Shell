###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:36:09
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:36:57
# @Description:
###
#!/bin/bash

#保存备份个数，备份4天数据
NUMBER=4
#备份保存路径
BACKUP_DIR=/data2/openldap_bak/openldap
#日期
DATE_TIME=$(date +%Y%m%d-%H-%M-%S)

NAME=openldap

#如果文件夹不存在则创建
if [ ! -d ${BACKUP_DIR} ]; then
	mkdir -p ${BACKUP_DIR}
fi
cd /etc/
tar -czf "${NAME}_${DATE_TIME}_bak.tar.gz" openldap
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
