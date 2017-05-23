#!/bin/bash

adb wait-for-device

# from https://github.com/travis-ci/travis-cookbooks/blob/master/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
# Originally written by Ralf Kistner <ralf@embarkmobile.com>, but placed in the public domain

set +e

bootanim=""
failcounter=0
timeout_in_sec=360

until [[ "$bootanim" =~ "stopped" ]]; do
  bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
  if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline"
    || "$bootanim" =~ "running" ]]; then
    let "failcounter += 1"
    echo "Waiting for emulator to start"
    if [[ $failcounter -gt timeout_in_sec ]]; then
      echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  fi
  sleep 1
done

# Fail proof way to detect emulator ready status
A=$(adb shell getprop sys.boot_completed | tr -d '\r');
sec=0;
while [ "$A" != "1" ]; do
  echo "waiting emulator boot for "$sec" seconds";
  sleep 10;
  sec=$((sec + 10));
  A=$(adb shell getprop sys.boot_completed | tr -d '\r');
done

echo "Emulator is ready"
