#!/usr/bin/env bash
login=romaimperat
pass=BOIsX7YQF8Vo3Eip
host=hestia.feralhosting.com
remote_dir="private/rtorrent/lftp"
#remote_dir="private/rtorrent/completed"
local_dir="/Users/dan/other/torrents/testing_extraction"

SEGMENTS=15

trap "rm -f /tmp/syncferal.lock" SIGINT SIGTERM
lftp_download() {
  if [ -e /tmp/syncferal.lock ]
    then
    echo "Syncferal is running already."
    exit 1
  else
    touch /tmp/syncferal.lock

  #set ftp:ssl-allow no
    #lftp -u $login,$pass ftp://$host << EOF
    /usr/local/bin/lftp -p 22 -u $login,$pass sftp://$host << EOF
#set net:limit-total-rate 2560K:100K
set net:limit-total-rate 5500K:200K
#set sftp:connect-program sftp
#set ssl:verify-certificate no
set ftp:ssl-protect-data yes
#set ftp:ssl-protect-list yes
#set ftp:ssl-auth TLS
set ftp:ssl-allow yes
set ftp:ssl-force yes
set ftp:passive-mode on
#set net:connection-limit 20
set ftp:sync-mode false
set net:max-retries 5
set pget:save-status 1
set pget:default-n $SEGMENTS
set mirror:use-pget-n $SEGMENTS
set mirror:parallel-transfer-count 1
set mirror:parallel-directories true
set ftp:nop-interval 10
set cache:enable true
mirror -c --log=sync_feral_log.log $remote_dir $local_dir
#pget -c -n 30 $remote_dir $local_dir
quit
EOF
  echo "lftp sync complete."

#lftp_download

  /bin/rm -f /tmp/syncferal.lock
#exit 0
fi
}


# Tested command for using bbcp to transfer instead but the performance was lacking
# bbcp -V -P 10 -d private/rtorrent/ -z -r -v -a -s 30 -w 262144 -x 1M -S "ssh -p 22 -oCipher=aes256-ctr -oTcpRcvBufPoll=yes -x -a -oFallBackToRsh=no %I -l %U %H ~/bbcp" "romaimperat@hestia.feralhosting.com:lftp/" /Volumes/other/torrents/


# Login
# tar lftp
# split lftp
# download in parallel
# logout
# join locally
# untar

upload_tar_split_script() {
  #rsync -aqz ~/tar_split_directory.sh $login@$host:~/
  rsync -aqz ~/tar_split_file.sh $login@$host:~/
}

login_and_tar() {
  ssh feralnew << EOF
~/tar_split_directory.sh
exit
EOF
}

filter() {
  grep '^[A-Za-z]' | grep --invert-match 'Linux'
}

SEGMENT_BANDWIDTH=100

download() {
  parallel --bar -u -n 1 -P $SEGMENTS -I% rsync -Have/usr/local/bin/ssh --bwlimit=$SEGMENT_BANDWIDTH --partial --progress $login@$host:private/rtorrent/% $local_dir
}

join() {
  ls $local_dir/lftp.tar.* | xargs cat > lftp.tar
}

extract() {
  tar -xpf lftp.tar
}

cleanup_server() {
  ssh -n feralnew << EOF
cd private/rtorrent/
rm lftp.tar*
EOF
}

cleanup_local() {
  rm lftp.tar
  cd testing_extraction
  rm lftp.tar*
}

cleanup() {
  cleanup_server
  cleanup_local
}

main() {
  echo "Uploading script..."
  upload_tar_split_script
  echo "Logging in and preparing files..."
  (login_and_tar) |
  (filter) |
  download
  echo "Joining completed files and extracting..."
  cd $local_dir/.. && join && extract
  echo "Cleaning up..."
  #cd $local_dir/.. && cleanup
  echo "Done!"
}

get_file_list() {
  #ssh -n feralnew 'cd private/rtorrent/lftp; find . -type f ! -path . | sort'
  ssh -n feralnew 'cd private/rtorrent/lftp; find . -type f -regextype sed -not -path . -and -not -regex ".*\.[a-z]\{4\}$" | sort'
}

split_file() {
  ssh -n feralnew bash -c "'
~/tar_split_file.sh \"$(escape_single_quotes "$1")\"
'"
}

download_parts() {
  parallel -0 --delay 0.5 --no-notice --retries 10 --bar -u -n 1 -P $SEGMENTS -I% rsync -have/usr/bin/ssh --bwlimit=$SEGMENT_BANDWIDTH --partial --progress --quiet "$login@$host:\"private/rtorrent/lftp/%\"" $local_dir/%
}

create_directory_hierarchy() {
  directory_name="$1"
  if ! [ -d "$directory_name" ]; then
    echo "Creating $directory_name..."
    mkdir -p "$directory_name"
  fi
}

find_parts() {
  find "$1" -name $(iconv -f utf-8 -t utf-8-mac <<< "$2.*") -print0 # This iconv utility converts the unicode characters coming in to the decomposed format that they are stored in for filenames. See here for more http://apple.stackexchange.com/questions/95483/utf8-filenames-and-shell-utilities
}

escape_single_quotes() {
  echo "$1" | sed "s/\'/\'\\\"\'\\\"\'/g"
}

join_file() {
  local directory=$1
  local filename=$2
  local file_path=$3
  find_parts "$directory" "$filename" | xargs -0 cat >> "$file_path"
}

fetch_foreign_md5() {
  ssh -n feralnew bash -c "'
cd \"$1\"
openssl dgst -md5 \"$(escape_single_quotes "$2")\"
'"
}

verify_download() {
  local file=$1
  local remote_path="private/rtorrent/lftp/$file"
  local directory=$(dirname "$remote_path")
  local filename=$(basename "$remote_path")
  local server_checksum=$(fetch_foreign_md5 "$directory" "$filename" | grep '^MD5' | cut -d '=' -f 2 | tr -d ' ')
  local local_checksum=$(md5 "$local_dir/$file" | grep '^MD5' | cut -d '=' -f 2 | tr -d ' ')
  if [ $server_checksum != $local_checksum ]; then
    echo "Checksum failed for file: $filename"
    exit 1
  fi
}

process_file() {
  file_path="$local_dir/$1"
  directory=$(dirname "$file_path")
  filename=$(basename "$file_path")
  create_directory_hierarchy "$directory"
  (split_file "$1") |
  tail -n 1 |
  download_parts
  #(grep '^\.' | grep '\.[a-z]\{4\}$') #|
  echo "Joining $1..."
  join_file "$directory" "$filename" "$file_path"
  if [ -z "$(verify_download "$1")" ]; then
    echo "Verified download of $1..."
    echo "Cleaning up after $1..."
    find_parts "$directory" "$filename" | xargs -0 rm && \
    ssh -n feralnew bash -c "'
cd private/rtorrent/lftp
rm \"$(escape_single_quotes "$1").\"*
'"
  fi
}

get_and_filter_files() {
  #get_file_list | grep '^\.' | grep --invert-match '\.[a-z]\{4\}$'
  get_file_list
}

main2() {
  #echo "Uploading script..."
  #upload_tar_split_script
  echo "Finding files to download..."
  (get_and_filter_files) | while IFS=$'\n' read -r file; do
    echo "Processing $file..."
    if [ -z "$(ls "$local_dir/$file" 2>/dev/null)" ]; then
      (process_file "$file")
    else
      echo "Attempting to verify..."
      (verify_download "$file")
      echo "Verified download of $file..."
    fi
    echo "Done with $file!"
  done
  echo "Finished with all files!"
}

trap "rm -f /tmp/syncferal.lock && exit 1" SIGINT SIGTERM

#main
#main2

/usr/bin/ssh -n feralnew bash -c "'
python move_files_to_lftp.py
'" &&
lftp_download &&
/usr/bin/ssh -n feralnew bash -c "'
python multicall_xmlrpc.py
'"

