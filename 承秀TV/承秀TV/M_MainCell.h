//
//  M_MainCell.h
//  承秀TV
//
//  Created by 孙承秀 on 16/8/20.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M_VideoModel.h"
@interface M_MainCell : UICollectionViewCell
@property (nonatomic, strong) M_VideoModel *model;         //直播信息

@property (nonatomic, strong) UIImageView *ImageView;  //显示直播缩略图

@property (nonatomic, strong) UILabel *title;           //显示房间标题

@property (nonatomic, strong) UILabel *name;            //显示主播名字

@property (nonatomic, strong) UILabel *peopleNum;       //显示在线人数
@end
