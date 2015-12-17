//
//  DownDetailUIViewController.m
//  Kuitan
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 S&G. All rights reserved.
//


#import "DownDetailUIViewController.h"
#import "DownDetileViewCell.h"
#import "AFNetworking.h"
#import "DownDetileModel.h"
#import "MJRefresh.h"
#import "NextDownViewController.h"
#import "NextDownModel.h"
#import "MainDataBaseHelper.h"
#import "MBProgressHUD.h"
#import "MeiShi.h"


@interface DownDetailUIViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;

@end

@implementation DownDetailUIViewController
- (void)dealloc {
    self.collectionView = nil;
    self.dataArr = nil;
    self.shuibian = nil;
    self.ID = nil;
    self.shouYeModel = nil;
    self.manager = nil;
    [super dealloc];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithArray:0];
    }
    return [[_dataArr retain] autorelease];
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

/**
 *  视图将要出现时隐藏tabBar
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

/**
 *  视图将要消失的时候停止请求数据
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.shuibian;

    //布局
    [self layoutCollectionView];
    //请求数据
    self.page = 1;
    [self requestData];
    
    [self shuaXin];
    //注册cell
    [self.collectionView registerClass:[DownDetileViewCell class] forCellWithReuseIdentifier:@"item"];

}

- (void)shuaXin {
    [self.collectionView addHeaderWithTarget:self action:@selector(handleHead)];
    [self.collectionView addFooterWithTarget:self action:@selector(handleFoot)];
}

- (void)handleHead{
    [self  requestData];
    [self.collectionView headerEndRefreshing];
}

- (void)handleFoot {
    self.page++;
    [self requestData];
    [self.collectionView footerEndRefreshing];
}

- (void)layoutCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //配置属性
  
    layout.itemSize = CGSizeMake((WIDTH - WIDTH * 3 / 20)/2, (WIDTH - WIDTH * 3 / 20)/2);
    layout.minimumInteritemSpacing = WIDTH / 40;
    layout.minimumLineSpacing = WIDTH / 20;
    layout.sectionInset = UIEdgeInsetsMake(WIDTH / 20, WIDTH / 40 + WIDTH / 80, WIDTH / 80, WIDTH / 40 + WIDTH / 80);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [layout release];
    [_collectionView release];
    
}
- (void)requestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:ShouYeDetailUrl,self.page,self.ID];
    __block DownDetailUIViewController *vc = self;
    [self.manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc handleData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }];
    [self.collectionView reloadData];
}
- (void)handleData:(id)dict {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *array = dict[@"data"][@"data"];
    for (NSDictionary *dic in array) {
        DownDetileModel *model = [[DownDetileModel alloc] initWithDict:dic];
        [self.dataArr addObject:model];
        [model release];
    }
    [self.collectionView reloadData];
}
#pragma mark -UICollectionViewDataSource-

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DownDetileViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    DownDetileModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
    
}
#pragma mark -UICollectionViewDelegate -

//选择了某个cell

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NextDownViewController *nextVC = [[NextDownViewController alloc] init];
    DownDetileModel *model = _dataArr[indexPath.row];
    nextVC.text = (NSString *)model.dishes_id;
    nextVC.dashes_name = model.title;
    nextVC.imageID = model.image;
    [self.navigationController pushViewController:nextVC animated:YES];
    [nextVC release];
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
