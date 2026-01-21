FINALPACKAGE = 1
# هذا السطر يخلي الملف حقيقي وقابل للقراءة في إيساين
THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoldSnapV10
GoldSnapV10_FILES = Tweak.x
GoldSnapV10_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
GoldSnapV10_FRAMEWORKS = UIKit Foundation
# إضافة هذه السطور لربط المكتبات صح
GoldSnapV10_LDFLAGS = -undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/tweak.mk
