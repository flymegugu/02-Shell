#！/bin/bash
# -W 是超时时间，-w是截至时间
set -uex
set -o pipefail
CMD="ping -W 2 -c 2"
IP="192.168.100."
FILE="/tmp/ip.txt"
[ -e $FILE ] && rm ${FILE} -f
FILE_SORT="/tmp/ip_sort.txt"
for n in $(seq 254); do
    {
        $CMD $IP$n &>/dev/null
        if [ $? -eq 0 ]; then
            echo "$IP$n IS OK" >>$FILE
        else
            echo "$IP$n IS not OK" >>$FILE

        fi
    } &#后台并行
done
wait #可以让后台任务执行结束后退出
sort -nt '.' -k1,1 -k2,2 -k3,3 -k4,4 $FILE >${FILE_SORT}
