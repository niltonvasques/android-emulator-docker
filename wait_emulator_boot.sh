#!/bin/bash

adb wait-for-device
A=$(adb shell getprop sys.boot_completed | tr -d '\r'); 
sec=0; 
while [ "$A" != "1" ]; do 
  echo "waiting emulator boot for "$sec" seconds"; 
  sleep 10; 
  sec=$((sec + 10)); 
  A=$(adb shell getprop sys.boot_completed | tr -d '\r'); 
done
