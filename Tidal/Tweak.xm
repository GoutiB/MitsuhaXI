#import "Tweak.h"
#import "../Utils/MSHColorUtils.mm"

%group MitsuhaVisuals

MSHJelloView *mshJelloView = NULL;

%hook LeafletImageView

-(void)layoutSubviews{
    %orig;
    LeafletImageView *me = (LeafletImageView *)self;

    if (mshJelloView != NULL && mshJelloView.config.enableDynamicColor) {
        [me readjustWaveColor];
        [me addObserver:me forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        LeafletImageView *me = (LeafletImageView *)self;
        [me readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    LeafletImageView *me = (LeafletImageView *)self;
    UIColor *dynamicColor = averageColor(me.image, mshJelloView.config.dynamicColorAlpha);
    [mshJelloView updateWaveColor:dynamicColor subwaveColor:dynamicColor];
}
%end

%hook PlayerView

-(void)layoutSubviews{
    %orig;
    UIView *me = (UIView *)self;

    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Tidal"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(me.bounds);
    
    mshJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, config.waveOffset, me.bounds.size.width, height) andConfig:config];
    [me insertSubview:mshJelloView atIndex:0];
}

-(void)didMoveToSuperview{
    %orig;
    UIView *me = (UIView *)self;

    if (me.superview) {
        [mshJelloView reloadConfig];
        CGFloat height = CGRectGetHeight(me.bounds);
        mshJelloView.frame = CGRectMake(0, mshJelloView.config.waveOffset, me.bounds.size.width, height);
        [mshJelloView msdConnect];
        mshJelloView.center = CGPointMake(mshJelloView.center.x, mshJelloView.config.waveOffset);
    } else {
        [mshJelloView msdDisconnect];
    }
}

%end

%end

%ctor{
    if([MSHJelloViewConfig loadConfigForApplication:@"Tidal"].enabled){
        %init(MitsuhaVisuals,
            LeafletImageView = NSClassFromString(@"WiMP.LeafletImageView"),
            PlayerView = NSClassFromString(@"WiMP.PlayerView")
        );
    }
}