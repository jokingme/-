//
//  MainTabBarController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/15.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "MainTabBarController.h"
#import "ListViewController.h"
#import "MainViewController.h"
#import "FindViewController.h"
#import "MainNavigationController.h"
#import "UserViewController.h"
#import "MeiShi.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
}

- (void)loadSubviews {
    //设置导航栏的背景
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    //设置导航栏内容的渲染颜色
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.navigationItem.title = @"推荐";
    mainVC.tabBarItem.title = @"推荐";
    mainVC.tabBarItem.image = [UIImage imageNamed:@"iconfont-shouye"];
    MainNavigationController *mainNavi = [[MainNavigationController alloc] initWithRootViewController:mainVC];
    
    ListViewController *listVC = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
    listVC.navigationItem.title = @"分类";
    listVC.tabBarItem.title = @"分类";
    listVC.tabBarItem.image = [UIImage imageNamed:@"iconfont-fenlei"];
    MainNavigationController *listNavi = [[MainNavigationController alloc] initWithRootViewController:listVC];
    
    FindViewController *findVC = [[FindViewController alloc] initWithStyle:UITableViewStylePlain];
    findVC.navigationItem.title = @"食话";
    findVC.tabBarItem.title = @"食话";
    findVC.tabBarItem.image = [UIImage imageNamed:@"iconfont-zhuanti"];
    MainNavigationController *findNavi = [[MainNavigationController alloc] initWithRootViewController:findVC];
    
    UserViewController *userVC = [[UserViewController alloc] init];
    userVC.navigationItem.title = @"我的";
    userVC.tabBarItem.title = @"我的";
    userVC.tabBarItem.image = [UIImage imageNamed:@"iconfont-wode1"];
    MainNavigationController *userNavi = [[MainNavigationController alloc] initWithRootViewController:userVC];
    
    
    self.viewControllers = @[mainNavi,listNavi,findNavi,userNavi];
    //设置标签栏选中颜色
    self.tabBar.selectedImageTintColor = COLOR;
    self.tabBar.alpha = 1.0;
    [mainVC release];
    [mainNavi release];
    [listVC release];
    [listNavi release];
    [findVC release];
    [findNavi release];
    [userVC release];
    [userNavi release];
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
