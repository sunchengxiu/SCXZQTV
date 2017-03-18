//
//  M_PlayManager.m
//  承秀TV
//
//  Created by 孙承秀 on 16/8/22.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "M_PlayManager.h"
static CGFloat const bottomBaHeight = 40.0f;
static CGFloat const playBtnSideLength = 60.0f;
static CGFloat const barAnimateSpeed = 0.5f;
static CGFloat const opacity = 0.7f;
static CGFloat const barShowDuration = 5.0f;

@implementation M_PlayManager
- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self updateConstraintsIfNeeded];
        //screen orientation change
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChangeNotifacation:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHidenBar)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        
        self.barHiden=YES;
        
    }
    return self;
}
-(void)setVideoURL:(NSString *)videoURL{
    _videoURL=videoURL;
    [self.layer addSublayer:self.playerLayer];
     [self insertSubview:self.activityView belowSubview:self.playButton];
    
    
    //[self.activityView startAnimating];
  
    [self addSubview:self.bottomBar];
    [self playOrPause:self.playButton];
    
}
-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor=[UIColor blackColor].CGColor;
        _playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
        
        
    }
    return _playerLayer;

}
-(AVPlayer *)player{
    if (!_player){
        AVPlayerItem *playerItem=[self getPlayItem];
        self.playerItem=playerItem;
        _player=[AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        
        [self addObserverToPlayerItem:playerItem];
        
    }
    return _player;
}
-(void)addProgressObserver{
    
    AVPlayerItem *playerItem=self.player.currentItem;
    __weak typeof(self)weakSelf=self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds(playerItem.duration);
        float value=current/total;
    }];
}

-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status=[[change objectForKey:@"new"] integerValue];
        if (status==AVPlayerStatusReadyToPlay) {
            float durtion=CMTimeGetSeconds([playerItem duration]);
        }
    
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *arr=playerItem.loadedTimeRanges;
        CMTimeRange range=  [[arr firstObject] CMTimeRangeValue];
        CGFloat start=CMTimeGetSeconds(range.start);
        CGFloat rangeDurtion=CMTimeGetSeconds(range.duration);
        CGFloat totalTime=start+rangeDurtion;
       
    }



}
-(AVPlayerItem *)getPlayItem{
    NSLog(@"%@",self.videoURL);
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.videoURL]];
    return playerItem;

   
}
-(void)deviceOrientationChangeNotifacation:(NSNotification *)no{
    UIDeviceOrientation orition=[[UIDevice currentDevice] orientation];
    if (orition==UIDeviceOrientationLandscapeLeft) {
        [self removeFromSuperview];
        [self leftFullScreen];
        NSLog(@"方向为左");
    }
    if (orition==UIDeviceOrientationLandscapeRight) {
        NSLog(@"方向为右");
        [self removeFromSuperview];
        [self rightFullScreen];
    }
   
    if (orition==UIDeviceOrientationPortrait) {
        NSLog(@"正常");
        [self removeFromSuperview];
        [self smallScreen];
    }

}
-(void)leftFullScreen{
    self.isFullScreen = YES;
    [self.keyWindow addSubview:self];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
      
        self.frame = self.keyWindow.bounds;
       
                      
        
    }];
}
-(void)rightFullScreen{
    self.isFullScreen = YES;
    [self.keyWindow addSubview:self];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = self.keyWindow.bounds;
        
        
        
    }];

}
-(void)smallScreen{
    self.isFullScreen = NO;
    [self.keyWindow addSubview:self];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    NSLog(@"%f",self.originalFrame.origin.x);
    NSLog(@"%f",self.originalFrame.origin.y);
    NSLog(@"%f",self.originalFrame.size.width   );
    NSLog(@"%f",self.originalFrame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = self.originalFrame;
        self.playerLayer.frame=self.originalFrame;
        
        
        
    }];

}
-(void)applicationDidEnterBackgroundNotification:(NSNotification *)no{
    
    
}
-(void)applicationDidBecomeActiveNotification:(NSNotification *)no{
    [self playOrPause:self.playButton];
    
}
-(void)applicationWillEnterForegroundNotification:(NSNotification *)no{
    
    
}
-(void)applicationWillResignActiveNotification:(NSNotification *)no{
    [self playOrPause:self.playButton];
    
}
- (void)showOrHidenBar {
    if (self.barHiden) {
        [self show];
    }else {
        [self hiden];
    }
}

- (void)show {
    [UIView animateWithDuration:barAnimateSpeed animations:^{
        self.bottomBar.layer.opacity = opacity;
        self.playButton.layer.opacity = opacity;
        self.playButton.hidden=NO;
    } completion:^(BOOL finished) {
        if (finished) {
            self.barHiden = !self.barHiden;
            [self performBlock:^{
                if (!self.barHiden) {
                    [self hiden];
                }
            } afterDelay:barShowDuration];
        }
    }];
}
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(callBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)callBlockAfterDelay:(void (^)(void))block {
    block();
}

- (void)hiden {
    
    [UIView animateWithDuration:barAnimateSpeed animations:^{
        self.bottomBar.layer.opacity = 0.0f;
        self.playButton.layer.opacity = 0.0f;
    } completion:^(BOOL finished){
        if (finished) {
            self.barHiden = !self.barHiden;
        }
    }];
}
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_playButton.frame=CGRectMake(kScreenW/2-25, kScreenW*kScreenW/kScreenH/2-25, 50, 50);
        
        //[_playButton setBackgroundColor:[UIColor redColor]];
        _playButton.contentMode = UIViewContentModeCenter;
        [_playButton setBackgroundImage:[UIImage imageNamed:@"movie_pause@2x"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"movie_play@2x"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchDown];
    }
    return _playButton;
}
-(void)playOrPause:(UIButton *)button{
    if (self.player.rate==0.0) {
        button.selected=NO;
        [self.player play];
    }
    else if (self.player.rate==1.0f){
        [self.player pause];
        button.selected=YES;
    }


}
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //_activityView.frame=CGRectMake(kScreenW/2-25, kScreenW*kScreenW/kScreenH/2-25, 40, 40);
        [self insertSubview:_activityView aboveSubview:self.playButton];
        
    }
    return _activityView;
}
- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] init];
        _bottomBar.backgroundColor = [UIColor blackColor];
        _bottomBar.layer.opacity = 0.0f;
        
        //        UILabel *label1 = [[UILabel alloc] init];
        //        label1.translatesAutoresizingMaskIntoConstraints = NO;
        //        label1.textAlignment = NSTextAlignmentCenter;
        //        label1.text = @"00:00:00";
        //        label1.font = [UIFont systemFontOfSize:12.0f];
        //        label1.textColor = [UIColor whiteColor];
        ////        [_bottomBar addSubview:label1];
        //        self.progressLabel = label1;
        //
        //        NSLayoutConstraint *label1Left = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        //        NSLayoutConstraint *label1Top = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        //        NSLayoutConstraint *label1Bottom = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        //        NSLayoutConstraint *label1Width = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:65.0f];
        //        [_bottomBar addConstraints:@[label1Left, label1Top, label1Bottom, label1Width]];
        
        
        UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
        fullScreenBtn.contentMode = UIViewContentModeCenter;
        [fullScreenBtn setImage:[UIImage imageNamed:@"movie_fullscreen@2x"] forState:UIControlStateNormal];
        [fullScreenBtn setImage:[UIImage imageNamed:@"movie_mini@2x"] forState:UIControlStateSelected];
        [fullScreenBtn addTarget:self action:@selector(actionFullScreen) forControlEvents:UIControlEventTouchDown];
        [_bottomBar addSubview:fullScreenBtn];
        self.zoomScreenBtn = fullScreenBtn;
        
        NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:40.0f];
        NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:40.0f];
        NSLayoutConstraint *btnRight = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        NSLayoutConstraint *btnCenterY = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        [_bottomBar addConstraints:@[btnWidth, btnHeight, btnRight, btnCenterY]];
        
        _videoLow = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 40)];
        //        videoLow.translatesAutoresizingMaskIntoConstraints = NO;
        _videoLow.contentMode = UIViewContentModeCenter;
        [_videoLow setImage:[UIImage imageNamed:@"btn_bq_normal.png"] forState:UIControlStateNormal];
        [_videoLow setImage:[UIImage imageNamed:@"btn_bq_pressed.png"] forState:UIControlStateSelected];
        [_videoLow addTarget:self action:@selector(videoLow:) forControlEvents:UIControlEventTouchDown];
        [_bottomBar addSubview:_videoLow];
        
        _videoMid = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 54, 40)];
        //        videoMid.translatesAutoresizingMaskIntoConstraints = NO;
        _videoMid.contentMode = UIViewContentModeCenter;
        [_videoMid setImage:[UIImage imageNamed:@"btn_gq_normal.png"] forState:UIControlStateNormal];
        [_videoMid setImage:[UIImage imageNamed:@"btn_gq_pressed.png"] forState:UIControlStateSelected];
        [_videoMid addTarget:self action:@selector(videoMid:) forControlEvents:UIControlEventTouchDown];
        [_bottomBar addSubview:_videoMid];
        
        _videoHigh = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 54, 40)];
        //        videoHigh.translatesAutoresizingMaskIntoConstraints = NO;
        _videoHigh.contentMode = UIViewContentModeCenter;
        [_videoHigh setImage:[UIImage imageNamed:@"btn_cq_normal.png"] forState:UIControlStateNormal];
        [_videoHigh setImage:[UIImage imageNamed:@"btn_cq_pressed.png"] forState:UIControlStateSelected];
        [_videoHigh addTarget:self action:@selector(videoHigh:) forControlEvents:UIControlEventTouchDown];
        [_bottomBar addSubview:_videoHigh];
        
        //        UILabel *label2 = [[UILabel alloc] init];
        //        label2.translatesAutoresizingMaskIntoConstraints = NO;
        //        label2.textAlignment = NSTextAlignmentCenter;
        //        label2.text = @"00:00:00";
        //        label2.font = [UIFont systemFontOfSize:12.0f];
        //        label2.textColor = [UIColor whiteColor];
        ////        [_bottomBar addSubview:label2];
        //        self.totalDurationLabel = label2;
        //
        //        NSLayoutConstraint *label2Right = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:fullScreenBtn attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        //        NSLayoutConstraint *label2Top = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        //        NSLayoutConstraint *label2Bottom = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        //        NSLayoutConstraint *label2Width = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:65.0f];
        //        [_bottomBar addConstraints:@[label2Right, label2Top, label2Bottom, label2Width]];
        //
        //        XLSlider *slider = [[XLSlider alloc] init];
        //        slider.value = 0.0f;
        //        slider.middleValue = 0.0f;
        //        slider.translatesAutoresizingMaskIntoConstraints = NO;
        //        [_bottomBar addSubview:slider];
        //        self.slider = slider;
        //        __weak typeof(self) weakSelf = self;
        //        slider.valueChangeBlock = ^(XLSlider *slider){
        //            [weakSelf sliderValueChange:slider];
        //        };
        //        slider.finishChangeBlock = ^(XLSlider *slider){
        //            [weakSelf finishChange];
        //        };
        //        slider.draggingSliderBlock = ^(XLSlider *slider){
        //            [weakSelf dragSlider];
        //        };
        //
        //        NSLayoutConstraint *sliderLeft = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        //        sliderLeft.priority = UILayoutPriorityDefaultLow;
        //        NSLayoutConstraint *sliderRight = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        //        NSLayoutConstraint *sliderTop = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        //        NSLayoutConstraint *sliderBottom = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        //        [_bottomBar addConstraints:@[sliderLeft, sliderRight, sliderTop, sliderBottom]];
        
        [self updateConstraintsIfNeeded];
    }
    return _bottomBar;
}
- (void)actionFullScreen {
    if (!self.isFullScreen) {
        [self leftFullScreen];
    }else {
        [self smallScreen];
    }
}
- (void)setStatusBarHidden:(BOOL)hidden {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden = hidden;
}
-(void)layoutSubviews{
    [super layoutSubviews];
     self.playerLayer.frame = self.bounds;
    
        if (!self.original) {
             self.originalFrame = self.bounds;
            self.bottomBar.frame = CGRectMake(0, self.originalFrame.size.height - bottomBaHeight, self.originalFrame.size.width, bottomBaHeight);
            self.playButton.frame = CGRectMake((self.originalFrame.size.width - playBtnSideLength) / 2, (self.originalFrame.size.height - playBtnSideLength) / 2, playBtnSideLength, playBtnSideLength);
            self.activityView.center = CGPointMake(self.originalFrame.size.width / 2, self.originalFrame.size.height / 2);
            self.original=YES;
        }
        else{
            if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationPortrait) {
                self.bottomBar.frame = CGRectMake(0, self.originalFrame.size.height - bottomBaHeight, self.originalFrame.size.width, bottomBaHeight);
            }
            else{
                self.bottomBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - bottomBaHeight, [UIScreen mainScreen].bounds.size.width, bottomBaHeight);
            }
        }
    
}
-(void)destroyPlayer{

    [self.player pause];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.playerLayer removeFromSuperlayer];
    self.player=nil;
    self.playerLayer=nil;
    [_bottomBar removeFromSuperview];
    _bottomBar=nil;
    [self removeFromSuperview];
  
}
@end
