###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:42:04
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:43:17
# @Description:
###
#!/bin/bash

src=/data2/jira_db/

dest=jiraSQL

ip=xxxx

#/usr/local/inotify/bin/inotifywait -mrq --timefmt '%d/%m/%y%H:%M' --format '%T %w %f %e' -e modify,delete,create,attrib $src | while read DATE TIME DIRFILE EVENT;
/usr/local/inotify/bin/inotifywait -mrq --timefmt '%d/%m/%y%H:%M' --format '%T %w %f' -e modify,delete,create,attrib $src | while read DATE TIME DIR FILE; do

	filechange=${DIRFILE}

	flock -xn /var/run/rsync.lock -c "/usr/bin/rsync -az --delete --progress $src jira@$ip::$dest --password-file=/etc/rsyncd.password"

	echo "At ${TIME} on ${DATE}, file $filechange event ${EVENT} was backed up via rsynce" >>/tmp/rsync.log 2>&1

done
