//
//  UserViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/22.
//  Copyright (c) 2015年 S&G. All rights reserved.
//
#import "UserViewController.h"
#import "UserCollectionTableViewController.h"
#import "MeiShi.h"
#import "UIImageView+WebCache.h"

@interface UserViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property(nonatomic,retain) UITableView *table;
@property (nonatomic,retain) NSArray *filesCounts;
@property (nonatomic,assign) double fileSize;
@end

@implementation UserViewController

- (void)dealloc {
    self.table = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSubviews];

    
}

//- (double)jisuan {
//    
//    
//    double a = 0;
//    
//    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//    
//    self.filesCounts = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//    for (NSString *p in _filesCounts) {
//        NSString *path = [cachPath stringByAppendingPathComponent:p];
//        a += [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
//    }
//    
//    return a;
//}


- (void)setUpSubviews {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, WIDTH / 2)];
    imageView.image = [UIImage imageNamed:@"meishi4"];
    [self.view addSubview:imageView];
    [imageView release];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, WIDTH / 2 + 64, WIDTH, 300) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.scrollEnabled = NO;
    _table.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_table];
    [_table release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"清除缓存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"当前缓存%.1fM",[[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        UserCollectionTableViewController *collectVC = [[UserCollectionTableViewController alloc] init];
        collectVC.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self.navigationController pushViewController:collectVC animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        [collectVC release];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self clearCacheSuccess];
    }
}

- (void)clearCacheSuccess {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清理缓存"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [alertView show];
    [alertView release];

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
         [[SDImageCache sharedImageCache] clearDisk];
     
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清理成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alt show];
        [alt release];
        [self.table reloadData];
    }
    
}

/*
+ (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[FileService fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self.table reloadData];
//    [self jisuan];
    
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
