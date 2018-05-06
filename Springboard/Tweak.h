//
//  Tweak.h
//  Mitsuha2
//
//  Created by c0ldra1n on 12/10/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../MSHJelloView.h"

@interface SBIconController : UIViewController
@property (retain,nonatomic) MSHJelloView *mitsuhaJelloView;
@end

@interface MediaControlsHeaderView : UIView
@property (retain,nonatomic) UIImageView *artworkView;
@end

@interface MediaControlsPanelViewController : UIViewController
@property (retain,nonatomic) MediaControlsHeaderView *headerView;
@end

@interface SBDashBoardMediaControlsViewController : UIViewController {
    MediaControlsPanelViewController *_mediaControlsPanelViewController;
}
- (NSString *)hexStringFromColor:(UIColor *)color;
@property (retain,nonatomic) MSHJelloView *mitsuhaJelloView;
@end