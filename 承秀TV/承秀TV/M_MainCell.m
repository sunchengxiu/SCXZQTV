//
//  M_MainCell.m
//  承秀TV
//
//  Created by 孙承秀 on 16/8/20.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "M_MainCell.h"

@implementation M_MainCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 20)];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 20)];
        _name = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width - 60, 20)];
        _peopleNum = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 50, self.bounds.size.height - 20, 50, 20)];
        
        _title.font = [UIFont systemFontOfSize:13];
        _name.font = [UIFont systemFontOfSize:11];
        _peopleNum.font = [UIFont systemFontOfSize:11];
        
        _title.textColor = [UIColor whiteColor];
        _title.backgroundColor = [UIColor blackColor];
        _title.alpha = 0.5;
        _peopleNum.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_ImageView];
        [self addSubview:_title];
        [self addSubview:_name];
        [self addSubview:_peopleNum];
    }
    
    return self;
}

- (void)setModel:(M_VideoModel *)model {
    
    _model = model;
    
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:_model.bpic]];
    _title.text = _model.title;
    _name.text = _model.nickname;
    _peopleNum.text = (_model.online.intValue > 10000) ? [NSString stringWithFormat:@"%.1f万",(float)_model.online.intValue/10000] : [NSString stringWithFormat:@"%@",_model.online];
}



@end
