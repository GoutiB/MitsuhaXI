#import "Tweak.h"
#import "../Utils/MSHColorUtils.mm"

%group MitsuhaVisuals

MSHJelloView *mshJelloView = NULL;

%hook MusicArtworkComponentImageView

-(void)layoutSubviews{
    %orig;
    if (mshJelloView == NULL) return;

    UIView *me = (UIView *)self;
    
    if ([NSStringFromClass([me.superview class]) isEqualToString:@"Music.NowPlayingContentView"] && mshJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
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
    if (mshJelloView == NULL) return;

    UIColor *dynamicColor = averageColor(((MusicArtworkComponentImageView*)self).image, mshJelloView.config.dynamicColorAlpha);
    [mshJelloView updateWaveColor:dynamicColor subwaveColor:dynamicColor];
}

%end

%hook MusicNowPlayingControlsViewController

-(void)viewDidLoad{
    %orig;
    
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Music"];
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height) andConfig:config];
    mshJelloView = self.mitsuhaJelloView;
    [self.view addSubview:self.mitsuhaJelloView];
    [self.view sendSubviewToBack:self.mitsuhaJelloView];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView reloadConfig];
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

%end

%ctor{
    if([MSHJelloViewConfig loadConfigForApplication:@"Music"].enabled){
        %init(MitsuhaVisuals, //MusicNowPlayingContentView = NSClassFromString(@"Music.NowPlayingContentView"),
            MusicArtworkComponentImageView = NSClassFromString(@"Music.ArtworkComponentImageView"));
    }
}
