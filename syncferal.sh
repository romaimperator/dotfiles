#!/bin/bash
login=romaimperat
pass=3flxElqyNb0ZxO64
host=dionysus.feralhosting.com
remote_dir="private/rtorrent/lftp"
local_dir="/Volumes/other/torrents/"

trap "rm -f /tmp/syncferal.lock" SIGINT SIGTERM
if [ -e /tmp/syncferal.lock ]
then
echo "Syncferal is running already."
exit 1
else
touch /tmp/syncferal.lock
#set ftp:ssl-allow no
#lftp -p 22 -u $login,$pass sftp://$host << EOF
lftp -u $login,$pass ftp://$host << EOF
#set net:limit-total-rate 2560K:100K
set net:limit-total-rate 2560K:100K
#set ssl:verify-certificate no
#set ftp:ssl-protect-data yes
#set ftp:ssl-protect-list yes
#set ftp:ssl-auth TLS
#set ftp:ssl-allow yes
#set ftp:ssl-force yes
#set ftp:passive-mode on
#set sftp:max-packets-in-flight 32
#set sftp:size-read 32k
#set sftp:size-write 32k
set net:connection-limit 25
set net:connection-takeover true
set pget:save-status 1
set pget:default-n 120
set mirror:use-pget-n 120
set mirror:parallel-transfer-count 2
set mirror:parallel-directories true
mirror -c --log=sync_feral_log.log $remote_dir $local_dir
#pget -c -n 30 $remote_dir $local_dir
quit
EOF
rm -f /tmp/syncferal.lock
exit 0
fi
