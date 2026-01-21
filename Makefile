
ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Snapchat

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoldSnapV10
GoldSnapV10_FILES = Tweak.x
GoldSnapV10_CFLAGS = -fobjc-arc
GoldSnapV10_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
