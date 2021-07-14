###
# @Author: [MaxGu]
# @Date: 2021-07-14 09:58:54
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 09:59:07
# @Description:
###
#!/bin/bash

src=/bitbucketDataBackup/backups

dest=bitBak

ip=xxxx

/usr/local/inotify/bin/inotifywait -mrq --timefmt '%d/%m/%y%H:%M' --format '%T %w %f' -e modify,delete,create,attrib $src | while read DATE TIME DIR FILE; do

	filechange=${DIR}${FILE}

	flock -xn /var/run/rsync.lock -c "/usr/bin/rsync -az --bwlimit=10000  --delete --progress $src bit@$ip::$dest --password-file=/etc/rsyncd.password"

	echo "At ${TIME} on ${DATE}, file $filechange was backed up via rsynce" >>/tmp/rsync.log 2>&1

done
