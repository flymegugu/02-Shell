###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:02:25
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:02:50
# @Description:
###
#!/bin/bash

src=/WIKI_BAKUP/wikiAttach/

dest=wikiAttach

ip=xxxx

/usr/local/inotify/bin/inotifywait -mrq --timefmt '%d/%m/%y%H:%M' --format '%T %w %f' -e modify,delete,create,attrib $src | while read DATE TIME DIR FILE; do

	filechange=${DIR}${FILE}

	flock -xn /var/run/rsync.lock -c "/usr/bin/rsync -az --delete --progress $src wiki@$ip::$dest --password-file=/etc/rsyncd.password"

	echo "At ${TIME} on ${DATE}, file $filechange was backed up via rsynce" >>/tmp/rsync.log 2>&1

done
