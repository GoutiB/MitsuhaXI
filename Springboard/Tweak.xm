#import "Tweak.h"
#import "../MSHUtils.h"
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

    if (self.mitsuhaJelloView.config.enableDynamicColor) {
        MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
        [mcpvc.headerView.artworkView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    UIColor *dynamicColor = averageColor(mcpvc.headerView.artworkView.image, self.mitsuhaJelloView.config.dynamicColorAlpha);
    [self.mitsuhaJelloView updateWaveColor:dynamicColor subwaveColor:dynamicColor];
    if (self.mitsuhaJelloView.config.enableAutoUIColor) {
        [self readjustUIColor:dynamicColor];
    }
}

%new;
-(void)readjustUIColor:(UIColor*)currentColor{
    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    MediaControlsContainerView *controlsView = mcpvc.parentContainerView.mediaControlsContainerView;
    if (isDark(currentColor)) {
        [controlsView setStyle:202024];
    } else {
        [controlsView setStyle:3];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;
    [self.mitsuhaJelloView reloadConfig];
    if (self.mitsuhaJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
    } else if (self.mitsuhaJelloView.config.enableAutoUIColor) {
        [self readjustUIColor:self.mitsuhaJelloView.config.waveColor];
    }
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.config.waveOffset);
}

-(void)viewDidDisappear:(BOOL)animated{
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

%group MitsuhaVisualsNotificationArtsy

%hook MediaControlsPanelViewController

-(void)loadView{
    %orig;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Springboard"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height) andConfig:config];
    [self.view addSubview:self.mitsuhaJelloView];
    [self.view sendSubviewToBack:self.mitsuhaJelloView];

    if (self.mitsuhaJelloView.config.enableDynamicColor) {
        [self.headerView.artworkView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"image"]) {
    [self readjustWaveColor];
  }
}

%new;
-(void)readjustWaveColor{
    UIColor *dynamicColor = averageColor(self.headerView.artworkView.image, self.mitsuhaJelloView.config.dynamicColorAlpha);
    [self.mitsuhaJelloView updateWaveColor:dynamicColor subwaveColor:dynamicColor];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.config.waveOffset);
    [self.mitsuhaJelloView reloadConfig];
    if (self.mitsuhaJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
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
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Springboard"];
    if(config.enabled){
        //%init(MitsuhaVisuals); disable homescreen for now

        //Check if Artsy is enabled.
        NSMutableDictionary *artsyPrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:ArtsyPreferencesFile];
        bool artsyEnabled = false;
        bool artsyLsEnabled = false;
        if (artsyPrefs) {
            NSLog(@"[MitsuhaXI] Artsy found");
            artsyEnabled = [([artsyPrefs objectForKey:@"enabled"] ?: @(YES)) boolValue];
            artsyLsEnabled = [([artsyPrefs objectForKey:@"lsEnabled"] ?: @(YES)) boolValue];
        }

        if (artsyLsEnabled) {
            NSLog(@"[MitsuhaXI] Artsy lsEnabled = true");
            %init(MitsuhaVisualsNotificationArtsy);
        } else {
            %init(MitsuhaVisualsNotification);
        }
    }
}
