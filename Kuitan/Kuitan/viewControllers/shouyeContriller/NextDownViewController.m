//
//  NextDownViewController.m
//  Kuitan
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 S&G. All rights reserved.
//


#import "NextDownViewController.h"
#import "AFNetworking.h"
#import "NextDownModel.h"
#import "NextDownCell.h"
#import "MainDataBaseHelper.h"
#import "MBProgressHUD.h"
#import "MeiShi.h"

@interface NextDownViewController ()
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;
@end

@implementation NextDownViewController
- (void)dealloc {
    self.dataSource = nil;
    self.text = nil;
    self.dashes_name = nil;
    self.imageID = nil;
    self.manager = nil;
    [super dealloc];
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.dashes_name;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    //注册Cell
    [self.tableView registerClass:[NextDownCell class] forCellReuseIdentifier:@"ceshi"];

    [self loadData];//请求数据
    
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectionMothed1:)] autorelease];
}


- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:ShouYeDetailDetailUrl,self.text];
    __block NextDownViewController *vc = self;
    [self.manager POST:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc handleData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }];
}
- (void)handleData:(id)dict {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSArray *array = dict[@"data"][@"step"];
    for (NSDictionary *dic in array) {
        NextDownModel *model = [NextDownModel NextDownModelWithDict:dic];
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NextDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ceshi" forIndexPath:indexPath];
    NextDownModel *model = self.dataSource[indexPath.row];
    cell.nextModel = model;

    // Configure the cell...
    
    return cell;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WIDTH / 2 + WIDTH / 40 + WIDTH / 10 + WIDTH / 40;
}


/**
 *  收藏按钮的点击事件
 */
- (void)collectionMothed1:(UIBarButtonItem *)sender {
    if ([MainDataBaseHelper selectExistOrNotByKey1:self.text] == NO) {
        [self bulidAlertView:@"是否收藏?"];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

/**
 *  创建提示框
 */
- (void)bulidAlertView:(NSString *)messageStr {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
    [alertView release];
}

/**
 *  提示框上面button的点击事件
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DownDetileModel *model= [[DownDetileModel alloc]init];
    model.title = self.dashes_name;
    model.dishes_id = @([self.text integerValue]);
    model.image = self.imageID;
    if (buttonIndex == 1) {
        [MainDataBaseHelper addDataModel1:model];
        [model release];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
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
