#!/bin/bash
SRC = /root/image
IN_FILE =$SRC /$1
OUT_FILE1 =$SRC/1-file.txt
OUT_FILE2 =$SRC/2-file.txt
OUT_FILE3 =$SRC/3-file.txt
OUT_FILE4 =$SRC/4-output.txt
C_NUM = 34
func1() {
    while read line; do
        NUM =$(echo $line | wc - c)
        if [$NUM - lt $C_NUM]; then
            continue
        else
            echo $line >>$OUT_FILE1
        fi

    done <$IN_FILE
}

func2() {
    while read line; do
        echo "$line" | awk - F'/' '{print $NF }' >>$OUT_FILE2
    done <$OUT_FILE1
}
func3() {
    sed - r - e 's/^#//g' - e 's/"//g' - e "s/'//g" $OUT_FILE2 >>$OUT_FILE3
    sort $OUT_FILE3 | uniq - c >>$OUT_FILE4
    rm $OUT_FILE{1..3}
}
func1
func2
func3

#过滤模版如下
#tempest
#images:
#  tags:
#    dep_check: cetccloud.com:31010/v0.1/airshipit/kubernetes-entrypoint:v1.0.0
#    tempest_run_tests: cetccloud.com:31010/v0.1/openstackhelm/tempest:latest-ubuntu_xenial
#    ks_user: cetccloud.com:31010/v0.1/openstackhelm/heat:ocata-ubuntu_xenial
#    image_repo_sync: cetccloud.com:31010/v0.1/docker:17.07.0
