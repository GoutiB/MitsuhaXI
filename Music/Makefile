include $(THEOS)/makefiles/common.mk

export TARGET = iphone:11.2:11.2
TWEAK_NAME = MitsuhaXIMusic
$(TWEAK_NAME)_FILES = Tweak.xmi $(wildcard ../MSH*.*m*)
$(TWEAK_NAME)_LIBRARIES += colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Music; open com.apple.Music"