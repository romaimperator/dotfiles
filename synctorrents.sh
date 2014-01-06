#!/bin/bash
login=romaimperato
pass=xJk2eA6e27
host=romaimperato.srv.sn
#remote_dir="torrents/data/"
remote_dir="torrents/data/White\ House\ Down\ 2013\ BluRay\ 720p\ DD\ 5.1\ x264-BluEvo"
local_dir="/Volumes/other/torrents/"

trap "rm -f /tmp/synctorrent.lock" SIGINT SIGTERM
if [ -e /tmp/synctorrent.lock ]
then
echo "Synctorrent is running already."
exit 1
else
touch /tmp/synctorrent.lock
#set ftp:ssl-allow no
#lftp -u $login,$pass $host << EOF
lftp -p 31122 -u $login,$pass sftp://$host << EOF
#set net:limit-total-rate 2560K:100K
set net:limit-total-rate 3560K:100K
#set mirror:use-pget-n 15
#set ssl:verify-certificate no
#set ftp:ssl-protect-data yes
#set ftp:ssl-protect-list yes
#set ftp:ssl-auth TLS
#set ftp:ssl-allow yes
#set ftp:ssl-force yes
#set ftp:passive-mode on
#set sftp:max-packets-in-flight 256
#set sftp:size-read 0x80000
#set sftp:size-write 0x80000
#set net:connection-limit 40
set pget:save-status 1
set pget:default-n 30
set mirror:use-pget-n 30
set mirror:parallel-transfer-count 2
set mirror:parallel-directories true
mirror -c --log=synctorrents.log $remote_dir $local_dir
#pget -c -n 15 $remote_dir $local_dir
quit
EOF
rm -f /tmp/synctorrent.lock
exit 0
fi