//
//  M_VideoModel.h
//  承秀TV
//
//  Created by 孙承秀 on 16/8/20.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M_VideoModel : NSObject
@property (nonatomic, copy) NSString *nickname;         //主播名字

@property (nonatomic, copy) NSString *online;           //观看人数

@property (nonatomic, copy) NSString *title;            //直播标题

@property (nonatomic, copy) NSString *bpic;             //缩略图大图    小图是sqic

@property (nonatomic, copy) NSString *videoId;          //HLS拼接关键词
@end
