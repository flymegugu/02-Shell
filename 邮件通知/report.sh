#/bin/bash
MAILLOG=/root/reportMail/$(date +%F)-mail.txt
DIR=/data1/rsync_dir
ALLDB=$DIR/alldb/all_db
BINLOG=$DIR/binlog
#Bitbucket
BIT1=$DIR/rsync_bit_client_backup/backups
BIT2=$DIR/rsync_psql
#Jira
JIRA_ATTACH=$DIR/rsync_jira/attach_bak/jiraAttach
JIRA_SELF=$DIR/rsync_jira/self_bak
JIRA_SQL=$DIR/rsync_jira/sql_bak
#Conluence
WIKI_ATTACH=$DIR/rsync_wiki/attach_bak
WIKI_SELF=$DIR/rsync_wiki/self_bak
WIKI_SQL=$DIR/rsync_wiki/sql_bak
#openldap
LDAP=$DIR/rsync_ldap/ldap
OPENLDAP=$DIR/rsync_ldap/openldap
SLAPCAT=$DIR/rsync_ldap/slapcat

printTitle() {
	echo -e "\n******$1_$(date +%F)******" >>$MAILLOG
}

printContent() {
	echo "$1" | awk -F" " 'BEGIN{printf "备份信息: " } {print $9,$5  } END{print "备份时间: " $6,$7}' >>$MAILLOG
}

cd $ALLDB
printTitle "MySQL全库备份(每周日)"
printContent "$(ls -lhrt *.sql | tail -n 1)"

cd $BINLOG
printTitle "Mysql-binlog备份"
printContent "$(ls -lrht mysql-bin* | tail -n 1)"

cd $BIT1
printTitle "Bitbucket备份"
printContent "$(ls -lrht *.tar | tail -n 1)"
cd $BIT2
printContent "$(ls -lrht *.sql | tail -n 1)"

cd $JIRA_ATTACH
printTitle "Jira附件备份"
printContent "$(ls -lrht *.gz | tail -n 1)"
cd $JIRA_SELF
printTitle "Jira默认备份"
printContent "$(ls -lrht *.zip | tail -n 1)"
cd $JIRA_SQL
printTitle "Jira库备份"
printContent "$(ls -lrht *.sql | tail -n 1)"

cd $WIKI_ATTACH
printTitle "Confluence附件备份"
printContent "$(ls -lrht *.gz | tail -n 1)"
cd $WIKI_SELF
printTitle "Confluence默认备份"
printContent "$(ls -lrht *.zip | tail -n 1)"
cd $WIKI_SQL
printTitle "Confluence库备份"
printContent "$(ls -lrht *.sql | tail -n 1)"
cd $LDAP
printTitle "LDAP目录备份"
printContent "$(ls -lrht *.gz | tail -n 1)"
cd $OPENLDAP
printTitle "LDAP目录备份"
printContent "$(ls -lrht *.gz | tail -n 1)"
cd $SLAPCAT
printTitle "LDAP_SLAPCAT备份"
printContent "$(ls -lrht *.ldif | tail -n 1)"
