//
//  MovieStepViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/17.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "MovieStepViewController.h"
#import "MeiShi.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DetailInfoTableViewCell.h"
#import "DetailFoodTableViewCell.h"
#import "InfoModel.h"
#import "foodModel.h"
#import "stepsModel.h"
#import "MBProgressHUD.h"
#import "DataBaseHelper.h"
#import "MeiShi.h"
#import "HeaderTableViewCell.h"

@interface MovieStepViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,retain) UIImageView *coverImage;
@property (nonatomic,retain) UISegmentedControl *segment;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) UITableView *infoTableView;
@property (nonatomic,retain) NSMutableArray *foodArray;
@property (nonatomic,retain) NSMutableArray *stepArray;
@property (nonatomic,retain) NSMutableArray *movieArray;
@property (nonatomic,retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;
@end

@interface MovieStepViewController ()

@end

@implementation MovieStepViewController

- (void)dealloc {
    self.coverImage = nil;
    self.segment = nil;
    self.dataSource = nil;
    self.infoTableView = nil;
    self.foodArray = nil;
    self.stepArray = nil;
    self.movieArray = nil;
    self.recipedId = nil;
    self.receiveModel = nil;
    self.moviePlayer = nil;
    self.text = nil;
    self.manager = nil;
    [super dealloc];
}

- (NSMutableArray *)movieArray {
    
    if (!_movieArray) {
        self.movieArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _movieArray;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (NSMutableArray *)foodArray {
    if (!_foodArray) {
        self.foodArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _foodArray;
}

- (NSMutableArray *)stepArray {
    if (!_stepArray) {
        self.stepArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _stepArray;
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

/**
 *  视图将要出现时隐藏tabBar
 */
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
    // Do any additional setup after loading the view.
  
    self.view.backgroundColor = [UIColor whiteColor];
    [self setPrivateNaviBar];
    [self readData];
}

/**
 *  设置导航栏的私有属性
 */
- (void)setPrivateNaviBar {
    //收藏
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectionMothed:)] autorelease];
    self.navigationItem.title = self.text;
}


#pragma mark ************* 读取数据 ***************
/**
 *  读取数据
 */
- (void)readData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block MovieStepViewController *vc = self;
    [self.manager POST:[NSString stringWithFormat:FenLeiMovieStepUrl,vc.recipedId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc praserData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        NSLog(@"%@",error);
    }];
    
    [self.manager POST:[NSString stringWithFormat:FenLeiMovieUrl,vc.recipedId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc praserMovieData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        NSLog(@"%@",error);
    }];
}

/**
 *  解析数据
 */
- (void)praserData:(id)responseObject {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self layoutImageview];
    [self layoutSegment];
    [self layoutFirstView];
    NSDictionary *dic = responseObject[@"result"][@"info"];
    InfoModel *model1 = [[InfoModel alloc] initWIthDictionary:dic];
    [self.dataSource addObject:model1];
    [model1 release];
    //给图片赋值
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:dic[@"Cover"]] placeholderImage:[UIImage imageNamed:@"meishi4"]];

    NSArray *array = dic[@"Stuff"];
    for (NSDictionary *dic in array) {
        foodModel *model = [[foodModel alloc] initWithDictionary:dic];
        [self.foodArray addObject:model];
        [model release];
    }
    
    NSArray *stepArray = dic[@"Steps"];
    for (NSDictionary *dic in stepArray) {
        stepsModel *model = [[stepsModel alloc] initWithDictionary:dic];
        [self.stepArray addObject:model];
        [model release];
    }
    [self.infoTableView reloadData];
}

/**
 *  解析视频数据
 */
- (void)praserMovieData:(id)responseObject {
    NSDictionary *dic = responseObject[@"result"];
    InfoModel *model = [[InfoModel alloc] initWIthDictionary:dic];
    [self.movieArray addObject:model];
    [model release];
}


#pragma mark ************ 布局页面 *************
/**
 *  布局上方图片和分段控件
 */
- (void)layoutImageview {
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, WIDTH / 2)];
    _coverImage.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(WIDTH / 2 - 25, WIDTH / 4 - 25, 50, 50);
    button.layer.cornerRadius = 25;
    [button setImage:[UIImage imageNamed:@"iconfont-zhibo"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [_coverImage addSubview:button];
    [self.view addSubview:_coverImage];
    [_coverImage release];
}

- (void)play:(UIButton *)sender {
    [self setPlayView];
}

- (void)setPlayView {
    
    InfoModel *model = self.movieArray[0];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:model.Url]];
    _moviePlayer.shouldAutoplay = YES;
//    _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _moviePlayer.view.frame = CGRectMake(0, 0, WIDTH, WIDTH / 2);
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [_moviePlayer.view setFrame:self.coverImage.bounds];
    [_moviePlayer play];
    [self.coverImage addSubview:_moviePlayer.view];
    //注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMoviePlayerScaleDidChanged:) name:MPMoviePlayerScalingModeDidChangeNotification object:_moviePlayer];
    [_moviePlayer release];
}

- (void)myMoviePlayerScaleDidChanged:(NSNotification *)notify {
    MPMoviePlayerController *theMovie = [notify object];
    theMovie.scalingMode = MPMovieScalingModeAspectFill;
}

- (void)myMovieFinishedCallback:(NSNotification *)notify {
    //视频播放对象
    MPMoviePlayerController *theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    [theMovie.view removeFromSuperview];
    //释放视频对象
}



/**
 *  页面将要消失的时候停止播放
 */
//- (void)viewWillDisappear:(BOOL)animated {
//    [_moviePlayer stop];
//}

- (void)layoutSegment {
    NSArray *array = @[@"详情",@"步骤"];
    self.segment = [[UISegmentedControl alloc] initWithItems:array];
    //1、设置大小frame
    _segment.frame = CGRectMake(0, 44 + self.coverImage.frame.size.height, WIDTH, WIDTH / 10);
    
    //2、设置正常状态和按下状态的属性控制，比如字体的大小和颜色等
    //正常状态
    NSDictionary *unSelectedState = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]};
    [_segment setTitleTextAttributes:unSelectedState forState:UIControlStateNormal];
    //按下状态
    NSDictionary *selectedState = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]};
    [_segment setTitleTextAttributes:selectedState forState:UIControlStateHighlighted];
    
    //3、设置按钮按下时的颜色
    _segment.tintColor = [UIColor colorWithRed:244.0 / 256 green:122.0 / 256 blue:73.0 / 256 alpha:1.0];
    //4、设置默认选中的按钮索引
    _segment.selectedSegmentIndex = 0;
    //5、设置分段控件的点击相应事件
    [_segment addTarget:self action:@selector(doSomethingInSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
    [_segment release];
}

/**
 *  分段控件的点击事件
 */
- (void)doSomethingInSegment:(UISegmentedControl *)segment {
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self layoutFirstView];
            break;
        case 1:
            [self layoutSecondView];
            break;
        default:
            break;
    }
}

/**
 *  加载视图
 */
//详情
- (void)layoutFirstView {
    //放置tableView
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WIDTH / 2 + WIDTH / 10 + 44, WIDTH, HEIGHT - WIDTH / 2 - WIDTH / 10 - 44) style:UITableViewStylePlain];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    //设置不显示竖直滚动条
    _infoTableView.showsVerticalScrollIndicator = NO;
    [_infoTableView registerClass:[DetailInfoTableViewCell class] forCellReuseIdentifier:@"info"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"foodHeader"];
    [_infoTableView registerClass:[DetailFoodTableViewCell class] forCellReuseIdentifier:@"food"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cookTime"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCount"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xiaoTieShi"];
    [_infoTableView registerClass:[HeaderTableViewCell class] forCellReuseIdentifier:@"Tips"];
    [self.view addSubview:_infoTableView];
    [_infoTableView release];
    //添加轻扫手势（向左）
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFirstSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [_infoTableView addGestureRecognizer:swipe];
    [swipe release];
    
}
//步骤
- (void)layoutSecondView {
    //放置tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WIDTH / 2 + WIDTH / 10 + 44, WIDTH, HEIGHT - WIDTH / 2 - WIDTH / 10 - 44)];
    //设置不显示竖直滚动条
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    //添加手势（向右）
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSecondSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:swipe];
    [swipe release];
}

/**
 *  处理手势
 */
- (void)handleFirstSwipe:(UISwipeGestureRecognizer *)firstSwipe {
    [self layoutSecondView];
    self.segment.selectedSegmentIndex = 1;
}

- (void)handleSecondSwipe:(UISwipeGestureRecognizer *)swipe {
    [self layoutFirstView];
    self.segment.selectedSegmentIndex = 0;
}

#pragma mark ************ UITableViewDataSource ************
/**
 *  设置分区数目
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.segment.selectedSegmentIndex == 0) {
        return 7;
    }
    return 1;
}
/**
 *  设置分区的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segment.selectedSegmentIndex == 0) {
        if (section == 0) {
            return self.dataSource.count;
        } else if (section == 1){
            return 1;
        } else if (section == 2){
            return self.foodArray.count;
        } else if (section == 3){
            return self.dataSource.count;
        } else if (section == 4){
            return self.dataSource.count;
        } else if (section == 5){
            return self.dataSource.count;
        } else {
            return self.dataSource.count;
        }
    }
    return self.stepArray.count;
}

/**
 *  返回分区的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.segment.selectedSegmentIndex == 0) {
            if (indexPath.section == 0) {
                DetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
                InfoModel *model = self.dataSource[indexPath.row];
                cell.model = model;
                return cell;
            } else if (indexPath.section == 1){
               UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodHeader" forIndexPath:indexPath];
                self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                cell.contentView.backgroundColor = COLOR;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"食材";
                cell.textLabel.backgroundColor = COLOR;
                cell.textLabel.font = [UIFont systemFontOfSize:20];
                cell.textLabel.textColor = [UIColor whiteColor];
                return cell;
            }else if (indexPath.section == 2){
                DetailFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"food" forIndexPath:indexPath];
                foodModel *model = self.foodArray[indexPath.row];
                cell.model = model;
                return cell;
            } else if (indexPath.section == 3){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cookTime" forIndexPath:indexPath];
                InfoModel *model = self.dataSource[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"制作时间: ",model.CookTime];
                return cell;
            } else if (indexPath.section == 4){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCount" forIndexPath:indexPath];
                InfoModel *model = self.dataSource[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"用餐人数: ",model.UserCount];
                return cell;
            } else if (indexPath.section == 5){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xiaoTieShi" forIndexPath:indexPath];
                cell.contentView.backgroundColor = COLOR;
                cell.textLabel.backgroundColor = COLOR;
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:20];
                cell.textLabel.text = @"小贴士";
                return cell;
            } else {
                HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tips" forIndexPath:indexPath];
                InfoModel *model = self.dataSource[indexPath.row];
                cell.model = model;
                return cell;
            }
        }
    NSString *identifity = @"step";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    stepsModel *model = self.stepArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %@",indexPath.row + 1,model.Intro];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}



//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (self.segment.selectedSegmentIndex == 0) {
//        if (section == 5) {
//            UIView *tipsView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH  / 8)] autorelease];
//            tipsView.backgroundColor = COLOR;
//            UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, 0, WIDTH - WIDTH / 20, WIDTH  / 8)];
//            tipsLabel.text = @"小贴士";
//            tipsLabel.font = [UIFont systemFontOfSize:20];
//            tipsLabel.textColor = [UIColor whiteColor];
//            [tipsView addSubview:tipsLabel];
//            [tipsLabel release];
//            return tipsView;
//        }
//    }
//    return nil;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.segment.selectedSegmentIndex == 0) {
//        if (section == 5) {
//            return WIDTH / 8;
//        }
//    }
//    return 0;
//}


/**
 *  返回各个分区cell的行高
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segment.selectedSegmentIndex == 0) {
        if (indexPath.section == 0) {
            InfoModel *model = self.dataSource[indexPath.row];
            return [DetailInfoTableViewCell heightForRow:model];
        } else if (indexPath.section == 6) {
            InfoModel *model = self.dataSource[indexPath.row];
            return [HeaderTableViewCell heightForRow:model];
        }
        return WIDTH * 3 / 40 + WIDTH / 20;
    } else {
        stepsModel *model = self.stepArray[indexPath.row];
        return [[self class] heightForText:model.Intro] + WIDTH / 20;
    }
}

/**
 *  动态计算行高
 */
+ (CGFloat)heightForText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(WIDTH - 40, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}

- (void)collectionMothed:(UIBarButtonItem *)sender {
    if ([DataBaseHelper selectExistOrNotByKey:self.recipedId] == NO) {
        [self bulidAlertView:@"是否收藏?"];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)bulidAlertView:(NSString *)messageStr {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [DataBaseHelper addDataModel:self.receiveModel];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
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
