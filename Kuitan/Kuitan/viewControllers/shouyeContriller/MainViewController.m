//
//  MainViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/15.
//  Copyright (c) 2015年 S&G. All rights reserved.
//




#import "MainViewController.h"
#import "ShouyeCell.h"
#import "Shouye.h"
#import "AFNetworking.h"
#import "SDCycleScrollView.h"
#import "DownDetailUIViewController.h"
#import "MBProgressHUD.h"
#import "ListViewController.h"
#import "NextDownViewController.h"
#import "MeiShi.h"


@interface MainViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) UICollectionView  *collection;
@property (nonatomic, retain) UICollectionReusableView *headerView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;

@end

@implementation MainViewController
static NSString *const ID = @"cell";

- (void)dealloc {
    self.dataArray = nil;
    self.dataSource = nil;
    self.collection = nil;
    self.headerView = nil;
    self.manager = nil;
    [super dealloc];
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return [[_dataArray retain] autorelease];
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if (self.dataSource.count == 0) {
        [self readData];
    }
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutCollectionView];
//    [self readData];
}

- (void)layoutCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];

    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49) collectionViewLayout:flowLayout];
    self.collection.backgroundColor = [UIColor whiteColor];
    self.collection.dataSource = self;
    self.collection.delegate = self;
    self.collection.bounces = NO;
    
    self.collection.showsVerticalScrollIndicator = NO;
    [self.collection registerClass:[ShouyeCell class] forCellWithReuseIdentifier:ID];
    flowLayout.headerReferenceSize = CGSizeMake(WIDTH, WIDTH / 2);
    //注册页眉
    [self.collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collection];
    [flowLayout release];
    [self.collection release];
}
- (void)readData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block MainViewController *vc = self;
    
    [self.manager POST:ShouYeListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc parserData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }];
    
    [self.manager POST:ShouYeListUrl2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc parserDownData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }];

}

- (void)parserData:(id)responseObject {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSArray *array = responseObject[@"data"][@"data"];
    for (NSDictionary *dic in array) {
        DownDetileModel *model = [[DownDetileModel alloc] initWithDict:dic];
        [self.dataSource addObject:model];
        [model release];
    }
    [self layoutSubview];
    
}

- (void)layoutSubview {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _dataSource.count; i++) {
        DownDetileModel *model = _dataSource[i];
        NSString *str = model.image;
        NSString *str1 = model.title;
        [imageArray addObject:str];
        [titleArray addObject:str1];
    }
    
    SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH , WIDTH / 2) imagesGroup:nil];
    cycle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"meishi4"]];
    cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycle.delegate = self;
    [self.headerView addSubview:cycle];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycle.imageURLStringsGroup = imageArray;
        cycle.titlesGroup = titleArray;
    });
    [self.headerView addSubview:cycle];
}

- (void)parserDownData:(id)responseObject {
    NSArray *array = responseObject[@"data"][@"category"][@"data"];
    for (NSDictionary *dict in array) {
        Shouye *shouye = [[Shouye alloc] initWithDictionary:dict];
        [self.dataArray addObject:shouye];
        [shouye release];
    }
    [self.collection reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    return _headerView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NextDownViewController *datailVC = [[NextDownViewController alloc] init];
    DownDetileModel *model = self.dataSource[index];
    datailVC.text = [NSString stringWithFormat:@"%@",model.dishes_id];
    datailVC.dashes_name = model.title;
    datailVC.imageID = model.image;
    [self.navigationController pushViewController:datailVC animated:YES];
    [datailVC release];
}

#pragma mark -UICollectionViewDataSource-
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShouyeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    Shouye *model = self.dataArray[indexPath.row];
    cell.shouye = model;
    return cell;
}



#pragma mark -UICollectionViewDelegate -

//选择了某个cell

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 7) {
        ListViewController *listVC = [[ListViewController alloc] init];
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        [listVC release];
    } else {
        DownDetailUIViewController *downVC = [[DownDetailUIViewController alloc] init];
        Shouye *model = _dataArray[indexPath.row];
        downVC.shuibian = model.text;
        downVC.ID = model.Id;
        [self.navigationController pushViewController:downVC animated:YES];
        [downVC release];
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -UICollectionViewDelegateFlowLayout -
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((WIDTH - 100) / 2 , (WIDTH - 60) / 2);
    return CGSizeMake((WIDTH - WIDTH  / 4) / 2 , (WIDTH - WIDTH * 3 / 20) / 2);
}
//定义每个section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(WIDTH * 3 / 40, WIDTH * 3 / 40, WIDTH * 3 / 40, WIDTH * 3 / 40);
}
//返回头headerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(WIDTH , WIDTH / 2);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return WIDTH / 20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
