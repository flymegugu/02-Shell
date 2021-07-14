###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:02:00
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:02:11
# @Description: 删除备份
###
#!/bin/bash

SELF_BAK=/var/atlassian/application-data/confluence/backups

LOG_FILE=/var/atlassian/application-data/confluence/backups/log.txt

#保存备份个数，备份7天数据
NUMBER=7
#超出7天备份文件则执行删除
COUNT=$(ls -lrt ${SELF_BAK}/*.zip | awk '{print $9 }' | wc -l)
while [[ $COUNT -gt $NUMBER ]]; do
	DELFILE=$(ls -lrt ${SELF_BAK}/*.zip | awk '{print $9 }' | head -1)
	rm -f $DELFILE
	echo $(date +"%Y年%m月%d日 %H:%M:%S") $DELFILE is delete >>${LOG_FILE}
	COUNT=$(ls -lrt ${SELF_BAK}/*.zip | awk '{print $9 }' | wc -l)
done

echo -e "\e[1;31m$(date +"%Y年%m月%d日 %H:%M:%S") SELF-BAK is successed!\e[0m" >>${LOG_FILE}
