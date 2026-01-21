ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoldSnapV10
GoldSnapV10_FILES = Tweak.x
GoldSnapV10_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
GoldSnapV10_FRAMEWORKS = UIKit Foundation
# هذا السطر يخلي الملف "رسمي" وإيساين يشوف مساراته
GoldSnapV10_LDFLAGS = -install_name @executable_path/GoldSnapV10.dylib

include $(THEOS_MAKE_PATH)/tweak.mk
