//
//  M_PlayVideoViewController.m
//  承秀TV
//
//  Created by 孙承秀 on 16/8/21.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//

#import "M_PlayVideoViewController.h"

@interface M_PlayVideoViewController ()<UITextFieldDelegate>

@end

@implementation M_PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self createXMPP];
    
    [self createPlayer];
    [self createTableView];
    [self createTextField];
    [self creatBackButton];
    [self createBarrage];
    
}
-(void)createBarrage{
_barrage=[[BarrageRenderer alloc]init];
    [_barrage start];
    _barrage.speed=5;
   
    [_viderPlayer addSubview:_barrage.view];
}
-(void)createXMPP{
    if (_connection==nil) {
        _connection=[[EMClient sharedClient].chatManager getConversation:@"test" type:EMConversationTypeGroupChat createIfNotExist:YES];
    }
    //从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息向前取
    NSArray *arr=[_connection loadMoreMessagesFromId:nil limit:20 direction:EMMessageSearchDirectionUp];
    for (EMMessage *message in arr) {
        [_dataArray addObject:message];
        [_barrage receive:[self warkTextSpriteDespetiorWithFrom:message.from andText:[message.body valueForKey:@"text"]]];
       
    }
    if (_dataArray.count!=0) {
         [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text!=nil) {
        EMMessageBody *body=[[EMTextMessageBody alloc]initWithText:textField.text];
        NSLog(@"%@",textField.text);
        EMMessage *message=[[EMMessage alloc]initWithConversationID:GroupId from:UserName to:GroupId body:body ext:nil];
        message.chatType=EMChatTypeGroupChat;
        [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            NSLog(@"%@",error);
            if ([message.body valueForKey:@"text"]!=nil) {
                [_dataArray addObject:message];
                [_tableView reloadData];
                [_barrage receive:[self warkTextSpriteDespetiorWithFrom:message.from andText:[message.body valueForKey:@"text"]]];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
         [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    }
    [_bottomView.textField endEditing:YES];
    return YES;
}

-(void)didReceiveMessages:(NSArray *)aMessages{

    for (EMMessage *message in aMessages) {
        [_dataArray addObject:message];
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [_barrage receive:[self warkTextSpriteDespetiorWithFrom:message.from andText:[message.body valueForKey:@"text"]]];
        EMMessageBody *body=[[EMMessageBody alloc]init];
        body=message.body;
      
        switch (body.type) {
            case EMMessageBodyTypeText:
            {
                  EMTextMessageBody *textBody = (EMTextMessageBody *)body;
                NSString *text=textBody.text;
                NSLog(@"收到文字信息");
            }
                break;
                case EMMessageBodyTypeImage :
                NSLog(@"收到图片信息");
                break;
                case EMMessageBodyTypeVideo:
               
                
            default:
                break;
        }
    }


}
-(void)setModel:(M_VideoModel *)model{
    _model=model;
    _viderPlayer.videoId=_model.videoId;
}
- (void)creatBackButton {
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    _backBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"movie_back@2x"]];
    
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    
    [self.viderPlayer addSubview:_backBtn];
    
    //    _bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 44, kScreenW * kScreenW / kScreenH - 44, 44, 44)];
    //
    //    _bigBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"movie_fullscreen.png"]];
    //
    //    [_bigBtn addTarget:self action:@selector(bigAction) forControlEvents:UIControlEventTouchDown];
    //
    //    [_playViewCV.view addSubview:_bigBtn];
    
}
- (void)backAction {
    
    [_viderPlayer destroyPlayer];
    [_viderPlayer removeFromSuperview];
    _viderPlayer =nil;
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self interfaceOrientation:1];
}
-(void)createPlayer{
    _viderPlayer=[[M_PlayManager alloc]init];
    [_viderPlayer setBackgroundColor:[UIColor whiteColor]];
    _viderPlayer.videoURL=[NSString stringWithFormat:@"%@%@%@",videoUrl,_model.videoId,videoUrlLastPage];
   // _viderPlayer.videoURL=@"https://pan.surdoc.net/lnk/act/preview?fileId=VVNEQVRBMVAxQTE5MkZUdmlzaXRpZDMxMTE=_1&password=ul2h&itemId=USDATA1P1A192FT";
    [_viderPlayer setFrame:CGRectMake(0, 0, kScreenW, kScreenW*(kScreenW/kScreenH))];
    _viderPlayer.videoId=_model.videoId;
    [self.view addSubview:_viderPlayer];
    
}
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenW * (kScreenW / kScreenH), kScreenW, kScreenH - kScreenW *( kScreenW / kScreenH)) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_tableView];

}
-(void)createTextField{
    _bottomView = [[M_BottomTextFieldView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
    
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, kScreenW - 4, 46)];
    [textField setBackgroundColor:[UIColor lightGrayColor]];
    _bottomView.textField = textField;
    
   // _bottomView.textField.backgroundColor = [UIColor lightGrayColor];
    
    _bottomView.textField.placeholder = @"发个弹幕呗";
    
    _bottomView.textField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHight:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [_bottomView addSubview:_bottomView.textField];
    
    [self.view addSubview:_bottomView];

}
-(void)keyboardHight:(NSNotification *)no{
    NSDictionary *userInfo=[no userInfo];
    int height=[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    float durtion=[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _bottomView.frame = CGRectMake(0, kScreenH - height - 50, kScreenW, 50);
    _bottomView.textField.frame = CGRectMake(2, 2, kScreenW, 50);
    
    [UIView animateWithDuration:durtion animations:^{
        [_bottomView.textField layoutIfNeeded];
        [_bottomView layoutIfNeeded];
        
    }];


}
- (void)keyboardHidden:(NSNotification *)notification {
    _bottomView.frame = CGRectMake(0, kScreenH - 49, kScreenW, 49);
    
    _bottomView.textField.frame = CGRectMake(2, 2, kScreenW - 4, 45);
    
    [UIView animateWithDuration:0.2 animations:^{
        [_bottomView.textField layoutIfNeeded];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    M_XMPPTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xmpp"];
    if (cell==nil) {
        cell=[[M_XMPPTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xmpp"];
    }
    EMMessage *message=_dataArray[indexPath.row];
    NSString *from=message.from;
    NSString *text=[message.body valueForKey:@"text"];
    cell.textLabel.text=[NSString stringWithFormat:@"%@:%@",from,text];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(BarrageDescriptor *)warkTextSpriteDespetiorWithFrom:(NSString *)from andText:(NSString *)text{
    BarrageDescriptor *descriptor=[[BarrageDescriptor alloc]init];
    descriptor.spriteName=NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"]=[NSString stringWithFormat:@"%@:%@",from,text];
    descriptor.params[@"textColor"]=[UIColor greenColor];
    descriptor.params[@"spreed"]=@5;
    descriptor.params[@"direction"]=@1;
    descriptor.params[@"clickAction"]=^{
        NSLog(@"点击弹幕了");
    };
    
    return descriptor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
