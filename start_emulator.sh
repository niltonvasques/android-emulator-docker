#!/bin/bash
echo "no" | emulator -avd test -noaudio -no-window -gpu off -verbose -qemu -usbdevice tablet &
