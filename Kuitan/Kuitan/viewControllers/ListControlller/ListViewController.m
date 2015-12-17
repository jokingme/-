//
//  ListViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/15.
//  Copyright (c) 2015年 S&G. All rights reserved.
//
#import "ListViewController.h"
#import "MeiShi.h"
#import "AFNetworking.h"
#import "Model.h"
#import "Model1.h"
#import "ListCellTableViewCell.h"
#import "DetailViewController.h"
#import "ListListViewController.h"
#import "MBProgressHUD.h"
#import "MainNavigationController.h"
#import "MeiShi.h"

@interface ListViewController ()
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableArray *dataSource1;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;
@end

@implementation ListViewController

- (void)dealloc {
    self.dataSource = nil;
    self.dataSource1 = nil;
    self.manager = nil;
    [super dealloc];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return [[_dataSource retain] autorelease];
}

- (NSMutableArray *)dataSource1 {
    if (!_dataSource1) {
        self.dataSource1 = [NSMutableArray arrayWithCapacity:0];
    }
    return [[_dataSource1 retain] autorelease];
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置不显示竖直滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self readData];
}


- (void)registerCell {
    [self.tableView registerClass:[ListCellTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)readData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block ListViewController *vc = self;
    [self.manager POST:FenLeiListURL parameters:nil success:^(AFHTTPRequestOperation *operation, id data) {
        [vc parserData:data];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        NSLog(@"%@",error);
    }];
}

- (void)parserData:(id)data {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self registerCell];
    self.tableView.rowHeight = (WIDTH - 40) / 3;
    NSDictionary *dic = data[@"result"];
    NSArray *arr = dic[@"list"];
    for (NSDictionary *dict in arr) {
        Model *model = [[Model alloc] initWithDictionary:dict];
        [self.dataSource addObject:model];
        [model release];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dicc in dict[@"Tags"]) {
            NSNumber *tempID = [dicc objectForKey:@"Id"];
            NSString *name = [dicc objectForKey:@"Name"];
            Model1 *model2 = [[Model1 alloc] initWithId:tempID  Name:name];
            [temp addObject:model2];
            [model2 release];
        }
        [self.dataSource1 addObject:temp];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Model *model = self.dataSource[indexPath.section];
    cell.model = model;
    
    NSArray *arr = self.dataSource1[indexPath.section];
    Model1 *model1 = arr[0];
    Model1 *model2 = arr[1];
    Model1 *model3 = arr[2];
    Model1 *model4 = arr[3];
    Model1 *model5 = arr[4];
    Model1 *model6 = arr[5];
    
    [cell.button1 addTarget:self action:@selector(handleButton1:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button2 setTitle:model1.Name forState:UIControlStateNormal];
    [cell.button2 addTarget:self action:@selector(handleOtherButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button3 setTitle:model2.Name forState:UIControlStateNormal];
    [cell.button3 addTarget:self action:@selector(handleOtherButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button4 setTitle:model3.Name forState:UIControlStateNormal];
    [cell.button4 addTarget:self action:@selector(handleOtherButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button5 setTitle:model4.Name forState:UIControlStateNormal];
    [cell.button5 addTarget:self action:@selector(handleOtherButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button6 setTitle:model5.Name forState:UIControlStateNormal];
    [cell.button6 addTarget:self action:@selector(handleOtherButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button7 setTitle:model6.Name forState:UIControlStateNormal];
    [cell.button7 addTarget:self action:@selector(handleOtherButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)handleButton1:(UIButton *)sender {
    ListListViewController *listVC = [[ListListViewController alloc] init];
    
    ListCellTableViewCell *cell = (ListCellTableViewCell *)[[sender superview] superview];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    NSArray *arr = self.dataSource1[path.section];
    listVC.listArray = arr;
    Model *model = self.dataSource[path.section];
    listVC.text = model.Cate;
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];

    
}

- (void)handleOtherButton:(UIButton *)sender {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    ListCellTableViewCell *cell = (ListCellTableViewCell *)[[sender superview] superview];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    NSArray *arr = self.dataSource1[path.section];
    Model1 *model1 = arr[sender.tag - 102];
    detailVC.flag = 0;
    detailVC.Id = model1.Id;
    detailVC.text = model1.Name;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

/**
 *  视图将要出现时显示tabBar
 */
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
