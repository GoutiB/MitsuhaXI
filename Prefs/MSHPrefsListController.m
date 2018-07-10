#import "MSHPrefsListController.h"

@implementation MSHPrefsListController
- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1];
        self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Prefs" target:self] retain];
    }
    return _specifiers;
}

- (void)visitGithub:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Ominousness/MitsuhaXI"] options:@{} completionHandler:nil];
}

- (void)donate:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ominous.cf/donate"] options:@{} completionHandler:nil];
}

- (void)donateColdrain:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/c0ldra1n"] options:@{} completionHandler:nil];
}

- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)restartmsd:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "mediaserverd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}
@end