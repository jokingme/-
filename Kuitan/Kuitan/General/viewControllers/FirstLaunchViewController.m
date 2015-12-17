//
//  FirstLaunchViewController.m
//  UserGuideDemo
//
//  Created by lanouhn on 15/9/7.
//  Copyright (c) 2015年 ZhiTieDong. All rights reserved.
//





#import "FirstLaunchViewController.h"
#import "MarcoHeader.h"
#import "MainTabBarController.h"

@interface FirstLaunchViewController () <UIScrollViewDelegate>

@end

@implementation FirstLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局子视图
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [self setUpScrollView];//布局scrollView
    [self setUpPageControl];//布局pageControl
}

#pragma mark - 布局UIScrollView -
- (void)setUpScrollView {
    //创建一个满屏的scrollView
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    //设置容量区域大小（宽度为屏幕宽度 * 图片的张数  高度为屏幕的高度）
    scroll.contentSize = CGSizeMake(kScreenWidth * kImageCount, kScreenHeight);
    //设置整页滑动
    scroll.pagingEnabled = YES;
    //设置滚动条状态(不显示水平滚动条)
    scroll.showsHorizontalScrollIndicator = NO;
    //设置tag值
    scroll.tag = kScrollTag;
    //设置scroll的代理
    scroll.delegate = self;
    
    
    [self.view addSubview:scroll];
    [scroll release];
    
    //放置引导图片
    for (int i = 0; i < kImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
//        [imageView setImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d",kPictureName,i + 1] ofType:@"png"]]];
        [imageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d",kPictureName,i + 1] ofType:@"png"]]];
        [scroll addSubview:imageView];
        [imageView release];
        //最后一张添加轻拍手势
        if (i == kImageCount - 1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
            [imageView addGestureRecognizer:tap];
            //打开imageView的用户交互
            imageView.userInteractionEnabled = YES;
            [tap release];
        }
    }
}

#pragma mark - 布局pageControl -
- (void)setUpPageControl {
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, kScreenHeight - 50, 200, 50)];
    //当前页点的颜色
    page.currentPageIndicatorTintColor = [UIColor orangeColor];
    //剩余页点的颜色
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    //设置总页数
    page.numberOfPages = kImageCount;
    //设置tag值
    page.tag = kPageTag;
    
    [page addTarget:self action:@selector(pageHandle:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:page];
    [page release];
}


#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:kPageTag];
    //获取当前页
    page.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

#pragma mark - UIPageControl -
- (void)pageHandle:(UIPageControl *)page {
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:kScrollTag];
    [scroll setContentOffset:CGPointMake(kScreenWidth * page.currentPage, 0) animated:YES];
}

#pragma mark - 轻拍进入程序主页面 -
- (void)tapHandle:(UITapGestureRecognizer *)tap {
    //当点击最后一张时，意味着用户引导页已经结束。将对应的key保存到NSUserDefaults
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:YES forKey:FIRST];
    //立即更新（同步）,立即执行保存操作，在这里保存的是字符串的key值
    [user synchronize];
    
    //进入程序主界面
    MainTabBarController *mainVC = [[MainTabBarController alloc] init];
    //更改window的根视图控制器 为主界面的视图控制器mainVC
    [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
    [mainVC release];
    
  
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
