#import "Tweak.h"
#import "../Utils/MSHColorUtils.mm"

/*
%group MitsuhaVisuals

%hook SBIconController

-(void)loadView{
    %orig;
    
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Springboard"];
    if (!config.enabled) return;
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    config.waveOffset += height*(9/10) + 100;
    self.view.clipsToBounds = 1;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height) andConfig:config];
    [self.view addSubview:self.mitsuhaJelloView];
    [self.view sendSubviewToBack:self.mitsuhaJelloView];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
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

%end*/


%group MitsuhaVisualsNotification

%hook SBDashBoardMediaControlsViewController

-(void)loadView{
    %orig;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Springboard"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height) andConfig:config];
    [self.view addSubview:self.mitsuhaJelloView];
    [self.view sendSubviewToBack:self.mitsuhaJelloView];
}

-(BOOL)handleEvent:(id)event{
    NSLog(@"[MitsuhaXI] Handle event");
    BOOL stuff = %orig;

    if (self.mitsuhaJelloView.config.enableDynamicColor) {
        MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
        UIColor *dynamicColor = averageColor(mcpvc.headerView.artworkView.image, 0.6);
        [self.mitsuhaJelloView updateWaveColor:dynamicColor subwaveColor:dynamicColor];
        if (self.mitsuhaJelloView.config.enableAutoUIColor) {
            if (isDark(dynamicColor)) {
                [mcpvc.parentContainerView.mediaControlsContainerView setStyle:202024];
            } else {
                [mcpvc.parentContainerView.mediaControlsContainerView setStyle:3];
            }
        }
    }

    return stuff;
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;
    [self.mitsuhaJelloView reloadConfig];
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.config.waveOffset);
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.mitsuhaJelloView.config.enableAutoUIColor && isDark(self.mitsuhaJelloView.config.waveColor)) {
        MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
        MediaControlsContainerView *controlsView = mcpvc.parentContainerView.mediaControlsContainerView;
        [controlsView setStyle:202024];
    }
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
    if([MSHJelloViewConfig loadConfigForApplication:@"Springboard"].enabled){
        //%init(MitsuhaVisuals); disable homescreen for now
        %init(MitsuhaVisualsNotification);
    }
}
