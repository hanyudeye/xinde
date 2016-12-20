#!/bin/bash
# 清除 /var/log 文件
#root 身份
LOG_DIR=/var/log
ROOT_UID=0   #$UID为0的时候,用户才具有根用户的权限
LINES=50   #默认的保存行数
E_XCD=66   #不能修改目录?
E_NOTROOT=67  #非根用户将以error退出

if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "Must be root to run this script."
    exit $E_NOTROOT
fi    

cd $LOG_DIR
cat /dev/null > messages
cat /dev/null > wtmp
echo "Logs cleaned up."

exit
