#import "MSHTidalPrefsListController.h"

@implementation MSHTidalPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"TidalPrefs" target:self] retain];
    }
    return _specifiers;
}
@end