###
# @Author: [MaxGu]
# @Date: 2021-07-14 10:38:53
# @LastEditors: [MaxGu]
# @LastEditTime: 2021-07-14 10:39:09
# @Description:
###
#!/bin/bash

src=/data1/psql_db/

dest=postgresqlBak

ip=xxxx

/usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y%H:%M' --format '%T %w %f' -e modify,delete,create,attrib $src | while read DATE TIME DIR FILE; do

	filechange=${DIR}${FILE}

	flock -xn /var/run/rsync.lock -c "/usr/bin/rsync -az --delete --progress $src psql@$ip::$dest --password-file=/etc/rsyncd.password"

	echo "At ${TIME} on ${DATE}, file $filechange was backed up via rsynce" >>/tmp/rsync.log 2>&1

done
