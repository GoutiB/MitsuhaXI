#import "Preferences.h"
#import "../MSHUtils.h"

@implementation MSHPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"MitsuhaXIPrefs" target:self] retain];
    }
    return _specifiers;
}

- (void)visitGithub:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Ominousness/MitsuhaXI"] options:@{} completionHandler:nil];
}

- (void)donate:(id)sender {
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