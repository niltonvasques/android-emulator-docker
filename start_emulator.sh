#!/bin/bash
echo "no" | emulator64-x86 -avd test -noaudio -no-window -gpu off -verbose -qemu -usbdevice tablet &
