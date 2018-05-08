include $(THEOS)/makefiles/common.mk

export ARCHS = arm64
export TARGET = iphone:11.2:11.2
TWEAK_NAME = MitsuhaXISoundcloud
$(TWEAK_NAME)_FILES = Tweak.xmi $(wildcard ../MSH*.*m*)
$(TWEAK_NAME)_LIBRARIES += colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk