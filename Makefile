
include $(THEOS)/makefiles/common.mk

export ARCHS = arm64
export TARGET = iphone:11.2:11.2

SUBPROJECTS += Music Spotify Springboard Prefs MSHook

include $(THEOS_MAKE_PATH)/aggregate.mk