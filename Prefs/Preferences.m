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
@end

@implementation HeaderCell
	- (id)initWithSpecifier:(PSSpecifier *)specifier{
	    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell" specifier:specifier];
	    if (self) {
			UIImage *bkIm = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/bootstrap/Library/PreferenceBundles/MitsuhaXIPrefs.bundle"] pathForResource:@"banner" ofType:@"png"]];
			_background = [[UIImageView alloc] initWithImage:bkIm];
			[self addSubview:_background];
	    }

	    return self;
	}

	- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
	    return 164.f;
	}
@end