FROM catbagdev/android-env:1.2
  
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
