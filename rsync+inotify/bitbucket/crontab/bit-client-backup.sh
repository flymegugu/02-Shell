###
# @Author: [MaxGu]
# @Date: 2021-07-14 09:58:22
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 09:58:23
# @Description:
###
#!/bin/bash
source /etc/profile
BIT_BAK=/bitbucketDataBackup/backups
LOG_FILE=/bitbucketDataBackup/backups/log.txt
BIT_CLIENT=/root/Package/bitbucket-backup-client-3.7.0
#保存备份个数，备份2天数据
NUMBER=2
#超出2天备份文件则执行删除
$(ls -lrt ${BIT_BAK}/*.tar &>/dev/null)
if [ $? -eq 0 ]; then
	COUNT=$(ls -lrt ${BIT_BAK}/*.tar | awk '{print $9 }' | wc -l)
	while [[ $COUNT -gt $NUMBER ]]; do
		DELFILE=$(ls -lrt ${BIT_BAK}/*.tar | awk '{print $9 }' | head -1)
		rm -f $DELFILE
		echo $(date +"%Y年%m月%d日 %H:%M:%S") $DELFILE is delete >>${LOG_FILE}
		COUNT=$(ls -lrt ${BIT_BAK}/*.tar | awk '{print $9 }' | wc -l)
	done
fi
cd $BIT_CLIENT
java -jar ./bitbucket-backup-client.jar
