ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoldSnapV10
GoldSnapV10_FILES = Tweak.x
GoldSnapV10_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
# هذا السطر هو السر، يخلي المكتبات تظهر في إيساين
GoldSnapV10_LDFLAGS = -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk
