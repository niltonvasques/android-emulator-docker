from catbagdev/android-env:1.2
  
#Install latest android tools and system images 
RUN echo y | android update sdk --no-ui --force -a --filter sys-img-armeabi-v7a-android-23 

# Install dependencies to run android tools 32bits binaries
RUN apt-get install gcc-multilib -y 

# Creating sdcard image
RUN mksdcard -l sdcard 100M sdcard.img 

# Creating a emulator with sdcard
RUN echo "no" | android create avd -f -n test -t android-23 --abi default/armeabi-v7a -c sdcard.img 

#Label
MAINTAINER Catbag <nilton.vasques@openmailbox.org>
LABEL Version="1.0" \
      Description="Android emulator environment"
