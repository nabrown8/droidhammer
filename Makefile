STANDALONE_TOOLCHAIN ?= C:\Users\Noah\Downloads\android-ndk-r26b-windows\android-ndk-r26b\toolchains\llvm\prebuilt\windows-x86_64\bin

CPP = $(STANDALONE_TOOLCHAIN)/armv7a-linux-androideabi21-clang++

CPPFLAGS = -std=c++11 -O3 -Wall
LDFLAGS = -pthread -static

TMPDIR = /data/local/tmp
TARGET ?= droidhammer

all: $(TARGET)

droidhammer: main.o
	$(CPP) $(CPPFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.cc
	$(CPP) $(CPPFLAGS) $(INCLUDES) -c -o $@ $<

install:
	make all
	adb push $(TARGET) $(TMPDIR)
	adb shell chmod 755 $(TMPDIR)$(TARGET)

clean:
	rm -f $(TARGET) *.o a.out

reboot:
	adb reboot

test:
	adb shell "$(TMPDIR)$(TARGET) -f/data/local/tmp/out.txt"