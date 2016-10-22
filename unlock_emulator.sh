#!/bin/bash

// Only works for emulators > Lollipop
if [ $(adb shell dumpsys input_method | grep mInteractive=false | wc -l) -eq 1 ]
then 
  adb shell input keyevent 82
else
  echo "the emulator already is unlocked"
fi

