//
//  M_PlayManager.h
//  承秀TV
//
//  Created by 孙承秀 on 16/8/22.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "M_PlayManager.h"

@interface M_PlayManager : UIView
@property(nonatomic,strong)NSString *videoURL;
@property (nonatomic, copy) NSString *videoId;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)UIButton *playButton;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic,assign)CGRect originalFrame;
@property(nonatomic,assign)BOOL original;
@property(nonatomic,strong)UIView *bottomBar;
@property (nonatomic, strong) UIButton *zoomScreenBtn;
@property (nonatomic, strong) UIButton *videoLow;
@property (nonatomic, strong) UIButton *videoMid;
@property (nonatomic, strong) UIButton *videoHigh;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL barHiden;

-(void)destroyPlayer;
@end
