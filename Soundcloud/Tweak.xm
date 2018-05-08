#import "Tweak.h"
#import "../Utils/MSHColorUtils.mm"

%group MitsuhaVisuals

%hook TrackPlayerViewController

-(void)loadView{
    %orig;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Soundcloud"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, self.mitsuhaJelloView.config.waveOffset, self.view.bounds.size.width, height) andConfig:config];
    [self.view insertSubview:self.mitsuhaJelloView atIndex:2];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView reloadConfig];
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.mitsuhaJelloView.frame = CGRectMake(0, self.mitsuhaJelloView.config.waveOffset, self.view.bounds.size.width, height);
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.config.waveOffset);
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdDisconnect];
}

%new
-(void)setMitsuhaJelloView:(MSHJelloView *)mitsuhaJelloView{
    objc_setAssociatedObject(self, @selector(mitsuhaJelloView), mitsuhaJelloView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(MSHJelloView *)mitsuhaJelloView{
    return objc_getAssociatedObject(self, @selector(mitsuhaJelloView));
}

%end

%end

%ctor{
    if([MSHJelloViewConfig loadConfigForApplication:@"Soundcloud"].enabled){
        %init(MitsuhaVisuals);
    }
}
