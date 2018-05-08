ARCHS = arm64
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MitsuhaXISpringboard
$(TWEAK_NAME)_FILES = Tweak.xm $(wildcard ../MSH*.*m*)
$(TWEAK_NAME)_LIBRARIES += colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk