#!/bin/bash
#等号左右不要有空格，否则无法赋值
Path=/BG
[ -d "$Path" ] || mkdir -p $Path
for i in $(seq 10); do
    random=$(openssl rand -base64 40 | sed 's@[^a-z]@@g' | cut -c 2-11)
    touch $Path/${random}_BG.html
done
