# This Dockerfile creates a android enviroment prepared to run integration tests
from debian:buster

RUN apt-get update && apt-get install gnupg -y

# Install java 11
RUN apt -y install wget curl
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
RUN apt install ./jdk-17_linux-x64_bin.deb
ENV JAVA_HOME=/usr/lib/jvm/jdk-17-oracle-x64/
ENV PATH=/usr/local/openjdk-17/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install another dependencies
RUN apt-get install gnupg2 git wget unzip gcc-multilib libglu1 -y

##Install Android
# ENV ANDROID_HOME /opt/android
ENV ANDROID_SDK_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
RUN wget --quiet --output-document=cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip
# RUN wget -O android-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip --show-progress \
# && unzip android-tools.zip -d $ANDROID_HOME && rm android-tools.zip
RUN mkdir -p ${ANDROID_SDK_HOME}/cmdline-tools
RUN unzip -d ${ANDROID_SDK_HOME}/cmdline-tools cmdline-tools.zip
RUN rm cmdline-tools.zip
ENV PATH=/usr/lib/android-sdk/cmdline-tools/tools/bin:/usr/local/openjdk-17/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

##Install Android Tools
RUN yes | sdkmanager --update --verbose
RUN yes | sdkmanager "platform-tools" --verbose
RUN yes | sdkmanager "platforms;android-27" --verbose
RUN yes | sdkmanager "build-tools;27.0.0" --verbose
RUN yes | sdkmanager "build-tools;28.0.3" --verbose
RUN yes | sdkmanager "build-tools;31.0.0" --verbose
RUN yes | sdkmanager "build-tools;33.0.0" --verbose
RUN yes | sdkmanager "extras;android;m2repository" --verbose
RUN yes | sdkmanager "extras;google;m2repository" --verbose

## Add platform-tools and emulator to path
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools
ENV PATH $PATH:$ANDROID_SDK_HOME/emulator

##Install latest android emulator system images
ENV EMULATOR_IMAGE "system-images;android-24;google_apis;x86_64"
RUN yes | sdkmanager $EMULATOR_IMAGE --verbose

## Copy Qt library files to system folder
RUN cp -a $ANDROID_SDK_HOME/emulator/lib64/qt/lib/. /usr/lib/x86_64-linux-gnu/

## Creating a emulator with sdcard
RUN echo "no" | avdmanager -v create avd -n test -k $EMULATOR_IMAGE -c 100M

ADD start_emulator.sh /bin/start_emulator
RUN chmod +x /bin/start_emulator

ADD wait_emulator_boot.sh /bin/wait_emulator
RUN chmod +x /bin/wait_emulator

ADD unlock_emulator.sh /bin/unlock_emulator
RUN chmod +x /bin/unlock_emulator

#Label
MAINTAINER Nilton Vasques <nilton.vasques@gmail.com>
LABEL Version="0.1.7" \
      Description="Android SDK and emulator environment"
