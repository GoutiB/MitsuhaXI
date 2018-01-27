#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface MSHPrefsListController : PSListController
    - (void)visitGithub:(id)sender;
@end

@interface HeaderCell : PSTableCell{
	UIImageView *_background;
}
@end