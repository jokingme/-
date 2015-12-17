//
//  MainNavigationController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/15.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "MainNavigationController.h"
#import "MeiShi.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = COLOR;
    //默认按钮的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    //导航栏标题字体和颜色
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.tabBarController.tabBar.backgroundColor = COLOR;

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
