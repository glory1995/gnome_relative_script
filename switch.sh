#!/usr/bin/bash

# A bash run file for proxy and shadowsocks-libev switching

manual1="'manual'"
none1="'none'"
for mode1 in $(gsettings get org.gnome.system.proxy mode)
do
  if [[ "$mode1" == "$manual1" ]]
  then
    gsettings set org.gnome.system.proxy mode 'none'
    service shadowsocks-libev stop
  fi
  if [[ "$mode1" == "$none1" ]]
  then
    gsettings set org.gnome.system.proxy mode 'manual'
    service shadowsocks-libev start
  fi
done