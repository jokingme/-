//
//  AppDelegate.m
//  Kuitan
//
//  Created by lanouhn on 15/10/14.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "FirstLaunchViewController.h"
#import "MarcoHeader.h"
#import "Reachability.h"

//#import "UMSocial.h"
@interface AppDelegate ()

@property (nonatomic,retain) Reachability *conn;

@end

@implementation AppDelegate

- (void)dealloc {
    self.window = nil;
    self.conn = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    [UMSocialData setAppKey:@"5626f92167e58eb94e004823"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkState) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];

    
    
    //判断程序是否是第一次安装启动
    //存储用户的偏好设置（NSUserDefaults 是数据持久化的一种方式）
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];//单例（程序运行期间只有这一个对象，只有在程序停止的时候空间才会被回收）
    BOOL isFirstLaunch = [user boolForKey:FIRST];//检测之前有没有保存过此字符串，有则返回YES，无则返回NO；
    //第一次安装启动时 加载用户引导页
    if (isFirstLaunch == NO) {
        //一旦发现为NO，说明程序是第一次启动，之前数据库里面没有存储过，指定launch为window的根视图控制器
        FirstLaunchViewController *launch = [[FirstLaunchViewController alloc] init];
        self.window.rootViewController = launch;
        [launch release];
    } else {
        MainTabBarController *tabBar = [[MainTabBarController alloc] init];
        self.window.rootViewController = tabBar;
//        [tabBar release];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)checkNetworkState {
    //1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //2.检测手机是否能上网
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前使用WIFI" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else if ([conn currentReachabilityStatus] != NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前使用数据流量" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无可用网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
