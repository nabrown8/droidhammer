STANDALONE_TOOLCHAIN ?= $(HOME)/android-ndk-r11c/sysroot-arm/bin

CPP   = $(STANDALONE_TOOLCHAIN)/arm-linux-androideabi-g++
STRIP = $(STANDALONE_TOOLCHAIN)/arm-linux-androideabi-strip

CPPFLAGS = -std=c++11 -O3 -Wall
LDFLAGS = -pthread -static
INCLUDES = -I$(PWD)/../include

TMPDIR = /data/local/tmp
TARGET ?= droidhammer

all: $(TARGET)

droidhammer: main.o
	$(CPP) $(CPPFLAGS) -o $@ $^ $(LDFLAGS)
	$(STRIP) $@

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