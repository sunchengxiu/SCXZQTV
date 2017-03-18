//
//  ViewController.m
//  承秀TV
//
//  Created by 孙承秀 on 16/8/20.
//  Copyright © 2016年 孙先森丶. All rights reserved.
//
static int page=0;
#import "ViewController.h"
#import "M_MainCell.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page=0;
    
    [self createView];
    [self createCollectionView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden=NO;
}
//设置支持的方向
-(BOOL)shouldAutorotate{
    return YES;

}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskPortrait;
}

-(void)createView{
    self.title=@"承秀TV丶";
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil]];
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];
    if (_data_Arr==nil) {
        _data_Arr=[[NSMutableArray alloc]initWithCapacity:0];
    }
}
-(void)createCollectionView{
 
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumInteritemSpacing=10;
    layout.minimumLineSpacing=10;
    layout.itemSize=CGSizeMake(kItemW, kItemH);
    _collectionViewController=[[UICollectionViewController alloc]initWithCollectionViewLayout:layout];
    _collectionViewController.collectionView.backgroundColor=[UIColor whiteColor];
    
    _collectionViewController.collectionView.delegate=self;
    _collectionViewController.collectionView.dataSource=self;
    [self.view addSubview:_collectionViewController.view];
    _collectionViewController.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=0;
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *url=[NSString stringWithFormat:@"%@%@%@",mainUrl,@1,MainUrlLastPage];
        [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            _data_Arr=[[responseObject objectForKey:@"data"] objectForKey:@"rooms"];
            [_collectionViewController.collectionView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        [_collectionViewController.collectionView.mj_header endRefreshing];
    }];
    [_collectionViewController.collectionView.mj_header beginRefreshing];
    _collectionViewController.collectionView.mj_footer =[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        page++;
         AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *url=[NSString stringWithFormat:@"%@%d%@",mainUrl,page,MainUrlLastPage];
        [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSMutableArray *newData =[[responseObject objectForKey:@"data"] objectForKey:@"rooms"];
           
            if (_data_Arr==nil) {
                _data_Arr=[[NSMutableArray alloc]initWithCapacity:0];
            }
            NSMutableArray *arr=[NSMutableArray arrayWithArray:_data_Arr];
            [arr addObjectsFromArray:newData];
            _data_Arr=arr;
            NSLog(@"%ld",_data_Arr.count    );
             NSLog(@"%ld",_data_Arr.count    );
            [_collectionViewController.collectionView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        [_collectionViewController.collectionView.mj_footer endRefreshing];
    }];
    [_collectionViewController.collectionView registerClass:[M_MainCell class] forCellWithReuseIdentifier:@"mainCell"];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data_Arr.count;
    

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    M_MainCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
    M_VideoModel *model=[[M_VideoModel alloc]init];
    [model mj_setKeyValues:_data_Arr[indexPath.row]];
    cell.model=model;
    return cell;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    M_PlayVideoViewController *controller=[[M_PlayVideoViewController alloc]init];
    M_VideoModel *model=[[M_VideoModel alloc]init];
    [model mj_setKeyValues:_data_Arr[indexPath.row]];
    controller.model=model;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
