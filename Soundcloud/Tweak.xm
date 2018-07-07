#import "Tweak.h"
#import "../Utils/MSHColorUtils.mm"

%group MitsuhaVisuals

%hook PlayerArtworkView

-(void)layoutSubviews{
    %orig;

    MSHJelloView *mshJelloView = ((TrackPlayerViewController *)self.superview.nextResponder).mitsuhaJelloView;
    if (mshJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
        [self addObserver:self forKeyPath:@"artworkImage" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"artworkImage"]) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    MSHJelloView *mshJelloView = ((TrackPlayerViewController *)self.superview.nextResponder).mitsuhaJelloView;
    UIColor *dynamicColor = averageColor(self.artworkImage, mshJelloView.config.dynamicColorAlpha);
    [mshJelloView updateWaveColor:dynamicColor subwaveColor:dynamicColor];
}
%end

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
