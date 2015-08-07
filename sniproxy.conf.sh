#!/bin/bash

guid=BLAH
tmp=$(mktemp)

wget --no-check-certificate -q -O $tmp \
  https://dns4me.net/user/hosts_file_api/$guid

echo "table {" >> /etc/sniproxy.conf

while IFS= read -r line; do
  if [ "x$line" != "x" ]; then
    host=$(echo $line | awk '{print $2}' | sed 's/\./\\./') 
    host="$host *"
    echo "    $host" >> /etc/sniproxy.conf
  fi
done < $tmp

echo "}" >> /etc/sniproxy.conf

rm "$tmp"
