#!/usr/bin/env bash

kbdname="USB usb keyboard"
path=""

function finddev() {
  for dev in /sys/class/leds/input*scrolllock; do
    if [ "$(cat $dev/device/name)" = "$kbdname" ]; then
      echo $dev
    fi
  done
}

function lightkbd() {
  set -e
  while true; do
    path=$(finddev)
    # check if led is on
    if [ "$(cat $path/brightness)" = "1" ]; then
      sleep 1
    else
      echo 1 > $path/brightness
      sleep 1
    fi
  done
}

path=$(finddev)

if [ "$path" = "" ]; then
  echo "Home keyboard not found!"
  exit 1
fi

(lightkbd) &
