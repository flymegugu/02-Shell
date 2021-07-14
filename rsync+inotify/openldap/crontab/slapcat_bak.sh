###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:36:14
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:37:11
# @Description:
###
#!/bin/bash

LDAPBK=ldap-$(date +%Y%m%d-%H-%M-%S).ldif

BACKUP_DIR=/data2/openldap_bak/slapcat

BACKUP_EXEC=$(which slapcat)

PACKAGE=(which tar)

NUMBER=4

checkdir() {
	if [ ! -d "$BACKUP_DIR" ]; then
		mkdir -p ${BACKUP_DIR}
	fi
}

backuping() {
	${BACKUP_EXEC} -v -l ${BACKUP_DIR}/${LDAPBK} &>/dev/null

}
#执行开始
checkdir
backuping

#写创建备份日志
echo -e "at $(date) create $(date +%Y%m%d-%H-%M-%S).ldif\n" >>${BACKUP_DIR}/log.txt

DELFILE=$(ls -l -crt ${BACKUP_DIR}/*.ldif | awk '{print $9 }' | head -1)

#判断现在的备份数量是否大于$NUMBER
COUNT=$(ls -l -crt ${BACKUP_DIR}/*.ldif | awk '{print $9 }' | wc -l)

if [ ${COUNT} -gt ${NUMBER} ]; then
	#删除最早生成的备份，只保留NUMBER数量的备份
	rm ${DELFILE}
	#写删除文件日志
	echo -e "at $(date) delete ${DELFILE} \n" >>${BACKUP_DIR}/log.txt
fi
