###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:33:24
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:33:38
# @Description:
###
#!/bin/bash
#脚本用户备份增量binlog文件
#binlog文件备份位置
BIN_BAK=/data2/binlog

#binlog文件原始目录
BIN_DIR=/application/mysql/binlog

#binlog日志记录位置
LOG_FILE=/data2/binlog/log.txt

#binlog日志index
BIN_INDEX=/application/mysql/binlog/mysql-bin.index

#保存备份个数，备份6天数据
NUMBER=6
if [ ! -d ${BIN_BAK} ]; then
	mkdir -p ${BIN_BAK}
fi
/application/mysql/bin/mysqladmin flush-logs
#查看记录中有多少条bin日志
INDEX_COUNT=$(wc -l ${BIN_INDEX} | awk '{print $1}')

NUM=0

for file in $(cat ${BIN_INDEX}); do
	BASE=$(basename $file)
	NUM=$(expr $NUM + 1)
	#如果等于index文件中二进制文件个数，则不再写入LOG_FILE
	if [ $NUM -eq ${INDEX_COUNT} ]; then
		echo $BASE skip! >>${LOG_FILE}
	else
		dest=${BIN_BAK}/$BASE
		if (test -e $dest); then
			echo $BASE exist! >>${LOG_FILE}
		else
			cp ${BIN_DIR}/$BASE ${BIN_BAK}/
			if [ $? -eq 0 ]; then
				#echo -e "\e[1;31m$BASE "已复制到" ${BIN_BAK}\e[0m" >> $LOG_FILE
				echo -e "\e[1;31m$(date +"%Y年%m月%d日 %H:%M:%S") ${BIN_DIR}/$BASE 已复制到 ${BIN_BAK}目录中\e[0m" >>${LOG_FILE}
			fi
		fi

	fi

done
##超出6天binlog文件则执行删除
#COUNT=$(ls -lc  ${BIN_BAK}/mysql-bin.* | awk '{print $9 }' | wc -l)
#while [[ $COUNT -gt $NUMBER ]]
#do
#        DELFILE=$(ls -lrt  ${BIN_BAK}/mysql-bin.* | awk '{print $9 }' | head -1)
#        rm -f $DELFILE
#        echo $(date +"%Y年%m月%d日 %H:%M:%S") $DELFILE is delete >> ${LOG_FILE}
#        COUNT=$(ls -lrt  ${BIN_BAK}/mysql-bin.* | awk '{print $9 }' | wc -l)
#done
#
#echo -e "\e[1;31m$(date +"%Y年%m月%d日 %H:%M:%S") BinLog-Bak is successed!\e[0m" >> ${LOG_FILE}