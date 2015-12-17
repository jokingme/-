//
//  DetailViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "MeiShi.h"
#import "DetailModel.h"
#import "DetailTableViewCell.h"
#import "MJRefresh.h"
#import "MJRefreshFooterView.h"
#import "MovieStepViewController.h"
#import "PictureViewController.h"
#import "MBProgressHUD.h"
#import "MainNavigationController.h"
#import "ListViewController.h"
#import "MeiShi.h"

@interface DetailViewController ()

@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic, retain)AFHTTPRequestOperationManager *manager;
@property (nonatomic,assign) int  count;
@end


@implementation DetailViewController

- (void)dealloc {
    self.Id = nil;
    self.text = nil;
    self.dataSource = nil;
    self.manager = nil;
    [super dealloc];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return [[_dataSource retain] autorelease];
}

/**
 *  视图将要出现的时候隐藏tabBar
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

/**
 *  视图将要消失的时候停止请求数据
 */
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    [self setPrivateNaviBar];
    [self readData];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置不显示竖直滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addFooterWithTarget:self action:@selector(handleFooter:)];
   
}

- (void)setPrivateNaviBar {
    self.navigationItem.title = self.text;
}

- (void)handleFooter:(id)footer {
    self.count += 20;
    [self readData];
    [self.tableView reloadData];
    [self.tableView footerEndRefreshing];
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (void)readData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block DetailViewController *vc = self;
    [self.manager POST:[NSString stringWithFormat:FenLeiDetailUrl,vc.Id,vc.count] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc parserData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        NSLog(@"%@",error);
    }];
    
  
}

- (void)parserData:(id)data {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self registerCell];
    NSDictionary *dic = data[@"result"];
    NSArray *arr = dic[@"list"];
    for (NSDictionary *dic in arr) {
        DetailModel *model = [[DetailModel alloc] initWithDictionary:dic];
        [self.dataSource addObject:model];
        [model release];
    }
    [self.tableView reloadData];
}
- (void)registerCell {
    [self.tableView registerClass:[DetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = WIDTH  / 6 + WIDTH / 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.

    if (self.count + 20 > _dataSource.count ) {
        return _dataSource.count;
    }
    return self.count + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.videoImage.image = nil;
    // Configure the cell...
    DetailModel *model = self.dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    if (model.Duration.length != 0) {
        cell.videoImage.image = [UIImage imageNamed:@"shipin"];
    }
    return cell;
}

//- (void)saveData:(ButtonofCell *)sender {
//    DetailModel *model = self.dataSource[sender.indexOfCell.section];
//    model.isDianZan = !model.isDianZan;
//    if (model.isDianZan == YES) {
//        sender.backgroundColor = [UIColor redColor];
//    } else {
//        sender.backgroundColor = [UIColor cyanColor];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieStepViewController *mStepVC = [[MovieStepViewController alloc] init];
    PictureViewController *picVC = [[PictureViewController alloc] init];
    
    DetailModel *model = self.dataSource[indexPath.section];
    if (model.Duration.length != 0) {
        mStepVC.recipedId = [model.RecipeId stringValue];
        mStepVC.receiveModel = model;
        [self.navigationController pushViewController:mStepVC animated:YES];
    } else {
        picVC.recipedId = [NSString stringWithFormat:@"%@",model.RecipeId];
        picVC.receiveModel = model;
        [self.navigationController pushViewController:picVC animated:YES];
    }
    [mStepVC release];
    [picVC release];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
