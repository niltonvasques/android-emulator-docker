## Android Emulator Docker image

### Usage

```bash
# Starting emulator
echo "no" | emulator64-arm -avd test -noaudio -no-window -gpu off -verbose -qemu -usbdevice tablet &

git clone https://github.com/niltonvasques/redux-android-sample.git
cd redux-android-sample

# Run unit tests
./gradlew check --daemon -PdisablePreDex --stacktrace

# Waiting for device be ready
adb wait-for-device
A=$(adb shell getprop sys.boot_completed | tr -d '\r')
while [ "$A" != "1" ]; do
  sleep 2
  A=$(adb shell getprop sys.boot_completed | tr -d '\r')
done

# Unlocking device
adb shell input keyevent 82

# Running instrumentation tests
./gradlew cC --daemon -PdisablePreDex --stacktrace
```
