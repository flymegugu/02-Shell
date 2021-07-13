#/bin/bash
###
# @Author: [MaxGu]
# @Date: 2021-07-13 15:51:32
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-13 15:52:20
# @Description:
###
source /etc/profile
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"
/usr/bin/mail -s "每日备份同步信息" abc@qq.com </root/reportMail/$(date +%F)-mail.txt &>/dev/null
