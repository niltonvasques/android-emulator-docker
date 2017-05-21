# This Dockerfile creates a android enviroment prepared to run integration tests
from ubuntu:16.04

RUN apt-get update && apt-get install openjdk-8-jdk git wget unzip -y

#Install Android
ENV ANDROID_HOME /opt/android
RUN wget -O android-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip --show-progress \
&& unzip android-tools.zip -d $ANDROID_HOME && rm android-tools.zip
ENV PATH $PATH:$ANDROID_HOME/tools/bin

#Install Android Tools
RUN yes | sdkmanager --update --verbose
RUN yes | sdkmanager "platform-tools" --verbose
RUN yes | sdkmanager "platforms;android-25" --verbose
RUN yes | sdkmanager "build-tools;25.0.3" --verbose
RUN yes | sdkmanager "extras;android;m2repository" --verbose
RUN yes | sdkmanager "extras;google;m2repository" --verbose

# Add platform-tools and emulator to path
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_HOME/emulator

#Install latest android emulator system images
ENV EMULATOR_IMAGE "system-images;android-24;google_apis;x86_64"
RUN yes | sdkmanager $EMULATOR_IMAGE --verbose

# Install dependencies to run android tools binaries
RUN apt-get install gcc-multilib libqt5widgets5 -y

# Creating a emulator with sdcard
RUN echo "no" | avdmanager -v create avd -n test -k $EMULATOR_IMAGE -c 100M

ADD start_emulator.sh /bin/start_emulator
RUN chmod +x /bin/start_emulator

ADD wait_emulator_boot.sh /bin/wait_emulator
RUN chmod +x /bin/wait_emulator

ADD unlock_emulator.sh /bin/unlock_emulator
RUN chmod +x /bin/unlock_emulator

#Label
MAINTAINER Catbag <developer@catbag.com.br>
LABEL Version="0.1.2" \
      Description="Android SDK and emulator environment"
