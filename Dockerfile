# This Dockerfile creates a android enviroment prepared to run integration tests
FROM debian:bookworm-slim

# Install dependencies and Java 22
RUN apt update && \
    apt install gnupg gnupg2 git wget unzip gcc-multilib libglu1 curl -y && \
    wget https://download.oracle.com/java/22/archive/jdk-22.0.2_linux-x64_bin.deb && \
    apt install ./jdk-22.0.2_linux-x64_bin.deb && \
    rm -rf jdk-22.0.2_linux-x64_bin.deb

ENV JAVA_HOME=/usr/lib/jvm/jdk-22.0.2-oracle-x64/
ENV PATH=/usr/lib/jvm/jdk-22.0.2-oracle-x64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

## Install Android
ENV ANDROID_SDK_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
RUN wget --quiet --output-document=cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip && \
    mkdir -p ${ANDROID_SDK_HOME}/cmdline-tools && \
    unzip -d ${ANDROID_SDK_HOME}/cmdline-tools cmdline-tools.zip && \
    rm -rf cmdline-tools.zip

ENV PATH=$ANDROID_SDK_HOME/cmdline-tools/tools/bin:$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV EMULATOR_IMAGE "system-images;android-24;google_apis;x86_64"

RUN yes | sdkmanager --update
RUN yes | sdkmanager "platform-tools" "platforms;android-27" "build-tools;27.0.0" "build-tools;28.0.3" "build-tools;31.0.0" "build-tools;33.0.0" "build-tools;35.0.0" "platforms;android-35" "extras;android;m2repository" "extras;google;m2repository" "emulator" $EMULATOR_IMAGE

ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/emulator

RUN cp -a $ANDROID_SDK_HOME/emulator/lib64/qt/lib/. /usr/lib/x86_64-linux-gnu/ && \
    echo "no" | avdmanager -v create avd -n test -k $EMULATOR_IMAGE -c 100M

ADD start_emulator.sh /bin/start_emulator
ADD wait_emulator_boot.sh /bin/wait_emulator
ADD unlock_emulator.sh /bin/unlock_emulator

RUN chmod +x /bin/start_emulator && \
    chmod +x /bin/wait_emulator && \
    chmod +x /bin/unlock_emulator

#Label
MAINTAINER Nilton Vasques <nilton.vasques@gmail.com>
LABEL Version="2.2" \
      Description="Android SDK and emulator environment"
