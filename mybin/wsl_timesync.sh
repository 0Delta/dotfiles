#!/bin/bash
ps=$(ps aux | grep wsl_timesync.sh | wc -l)
if [ "$ps" -gt 3 ]; then
 echo "wsl2 time syncer already exists."
 exit
else
 echo "wsl2 time syncer stated."
  docker run --rm -p 19980:8080 custom_proxy
  while true; do
   sudo hwclock -s
   kinkan check 2>/dev/null > /tmp/kinkan_state
   sleep 180
  done
fi
