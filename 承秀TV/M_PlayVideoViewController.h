//
//  M_PlayVideoViewController.h
//  承秀TV
//
//  Created by 孙承秀 on 16/8/21.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M_PlayManager.h"
#import "M_VideoModel.h"
#import "M_BottomTextFieldView.h"
#import "M_XMPPTableViewCell.h"
#import <BarrageRenderer.h>
#import "BarrageDescriptor.h"
#import <BarrageWalkTextSprite.h>
//#import <BarrageRenderer/BarrageRenderer.h>
#import "EMMessageBody.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

//#import "BarrageWalkTextSprite.h"
@interface M_PlayVideoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,BarrageRendererDelegate,UITextFieldDelegate>
@property(nonatomic,strong)M_PlayManager *viderPlayer;
@property(nonatomic,strong)M_VideoModel *model;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)M_BottomTextFieldView *bottomView;
@property (nonatomic, strong) UIButton *backBtn;
@property(nonatomic,strong)EMConversation *connection;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)BarrageRenderer *barrage;
@end
