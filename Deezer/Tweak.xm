#import "Tweak.h"
#import "../Utils/MSHColorUtils.mm"

%group MitsuhaVisuals

MSHJelloView *mshJelloView = NULL;

%hook DeezerIllustrationView

-(void)layoutSubviews{
    %orig;

    if (mshJelloView != NULL && mshJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
        //[self addObserver:self forKeyPath:@"artworkImage" options:NSKeyValueObservingOptionNew context:NULL];
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
    UIColor *dynamicColor = averageColor(((DeezerIllustrationView*)self).image, mshJelloView.config.dynamicColorAlpha);
    [mshJelloView updateWaveColor:dynamicColor subwaveColor:dynamicColor];
}
%end

%hook DZRPassThroughView
-(void)layoutSubviews{
    %orig;
    [self insertSubview:mshJelloView atIndex:1];
}
%end

%hook DZRPlayerViewController

-(void)loadView{
    %orig;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Deezer"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    mshJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height) andConfig:config];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [mshJelloView reloadConfig];
    CGFloat height = CGRectGetHeight(self.view.bounds);
    mshJelloView.frame = CGRectMake(0, mshJelloView.config.waveOffset, self.view.bounds.size.width, height);
    [mshJelloView msdConnect];
    mshJelloView.center = CGPointMake(mshJelloView.center.x, mshJelloView.config.waveOffset);
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [mshJelloView msdDisconnect];
}

%end

%end

%ctor{
    if([MSHJelloViewConfig loadConfigForApplication:@"Deezer"].enabled){
        %init(MitsuhaVisuals,
            DeezerIllustrationView = NSClassFromString(@"Deezer.IllustrationView"));
    }
}
