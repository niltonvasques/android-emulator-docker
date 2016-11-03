# This Dockerfile creates a android enviroment prepared to run integration tests
from ubuntu:16.04

RUN apt-get update && apt-get install openjdk-8-jdk git wget -y

#Install Android
RUN wget -qO- https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz --show-progress \
  | tar -xz -C /opt/
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools

#Install Android Tools
ENV SDK_FILTERS platform-tools,android-23,android-24,build-tools-24.0.3,extra-android-m2repository,extra-google-m2repository
RUN ( sleep 4 && while [ 1 ]; do sleep 1; echo y; done ) \
	| android update sdk --no-ui --force -a --filter \ $SDK_FILTERS && android update adb

# Add platform-tools to path
ENV PATH $PATH:$ANDROID_HOME/platform-tools
  
#Install latest android tools and system images 
RUN echo y | android update sdk --no-ui --force -a --filter sys-img-x86-android-24

# Install dependencies to run android tools 32bits binaries
RUN apt-get install gcc-multilib -y 

# Creating sdcard image
RUN mksdcard -l sdcard 100M sdcard.img 

# Creating a emulator with sdcard
RUN echo "no" | android create avd -f -n test -t android-24 --abi default/x86 -c sdcard.img 

ADD start_emulator.sh /bin/start_emulator
RUN chmod +x /bin/start_emulator

ADD wait_emulator_boot.sh /bin/wait_emulator
RUN chmod +x /bin/wait_emulator

ADD unlock_emulator.sh /bin/unlock_emulator
RUN chmod +x /bin/unlock_emulator

#Label
MAINTAINER Nilton Vasques <nilton.vasques@openmailbox.org>
LABEL Version="1.3" \
      Description="Android emulator environment"
