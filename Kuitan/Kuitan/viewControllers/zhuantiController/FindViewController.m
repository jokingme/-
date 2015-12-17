//
//  FindViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/15.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "FindViewController.h"
#import "showTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ztModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "FindDetailViewController.h"
#import "MeiShi.h"
#import "hotViewController.h"

@interface FindViewController ()
@property(nonatomic,retain)NSMutableData *mudata;
@property(nonatomic,retain)NSMutableArray *datasource;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;
@end

@implementation FindViewController

- (void)dealloc {
    self.mudata = nil;
    self.datasource = nil;
    self.manager = nil;
    [super dealloc];
}

-(NSMutableArray*)datasource
{
    UIImageView *in = [[UIImageView alloc]init];
    if (!_datasource)
    {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (void)handleAction{
    self.page += 1;
    [self requestaData];
//    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tableView footerEndRefreshing];
}

/**
 *  视图将要出现时,显示tabBar
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if (self.datasource.count == 0) {
        [self requestaData];
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
    [self hotbutton];
//    [self requestaData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView addFooterWithTarget:self action:@selector(handleAction)];
    self.page = 1;
}

-(void)hotbutton
{
    UIBarButtonItem *rigthButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-baojifuben1.png"] style:UIBarButtonItemStylePlain target:self action:@selector(putHot)] autorelease];
    self.navigationItem.rightBarButtonItem = rigthButton;
}

-  (void)registerCell {
    [self.tableView registerClass:[showTableViewCell class] forCellReuseIdentifier:@"resue"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void)putHot
{
    hotViewController *hot = [[hotViewController alloc]init];
    [self.navigationController  pushViewController:hot animated:YES];
}
//获取数据
-(void)requestaData
{
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block FindViewController *fc = self;
    [self.manager GET:[NSString stringWithFormat:FindListUrl,fc.page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *adata = [str dataUsingEncoding:NSUTF8StringEncoding];
        [str release];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableContainers error:nil];
        [fc parserData:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:fc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        NSLog(@"%@",error);
    }];
}
//-(void)handleData:(NSDictionary *)dic
//{
//    UIImage *imagename = dic[@"user_info"][2];
//    UIImage *imagecook =  dic [@"photot"];
//    NSString *usname = dic[@"user_info"][1];
//    NSString *coname = dic[@"title"];
//}
//数据解析
-(void)parserData:(NSDictionary *)dic
{
    [MBProgressHUD  hideHUDForView:self.view  animated:YES];
    [self registerCell];
    NSArray *arr = dic[@"data"][@"data"];
    for (NSDictionary *dict in arr)
    {
        ztModel *model = [[ztModel alloc]initWithDic:dict];
        [self.datasource addObject:model];
        [model release];
    }
    [self.tableView reloadData];
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ztModel *model = self.datasource[indexPath.row];
    return [showTableViewCell heightForRow:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    showTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resue" forIndexPath:indexPath];
    ztModel *model = self.datasource[indexPath.row];
    cell.model = model;
     return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindDetailViewController *detail = [[FindDetailViewController alloc]init];
    ztModel *model = self.datasource[indexPath.row];
    detail.ID = model.IDs;
    detail.text = model.title;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
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
