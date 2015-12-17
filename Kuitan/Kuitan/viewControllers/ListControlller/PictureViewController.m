//
//  PictureViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/19.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "PictureViewController.h"
#import "MeiShi.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DetailInfoTableViewCell.h"
#import "DetailFoodTableViewCell.h"
#import "DetailStepTableViewCell.h"
#import "DetailPhotoTableViewCell.h"
#import "InfoModel.h"
#import "foodModel.h"
#import "stepsModel.h"
#import "MBProgressHUD.h"
#import "DataBaseHelper.h"
#import "MeiShi.h"

@interface PictureViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UIImageView *coverImage;
@property (nonatomic,retain) UITableView *infoTableView;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableArray *foodArray;
@property (nonatomic,retain) NSMutableArray *stepArray;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;
@end

@implementation PictureViewController

- (void)dealloc {
    self.coverImage = nil;
    self.infoTableView = nil;
    self.dataSource = nil;
    self.foodArray = nil;
    self.stepArray = nil;
    self.recipedId = nil;
    self.receiveModel = nil;
    self.text = nil;
    self.manager = nil;
    [super dealloc];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
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
 *  视图将要出现的时候隐藏tabBar
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

    self.view.backgroundColor = [UIColor whiteColor];
    [self setPrivateNaviBar];
    [self readData];
}


- (void)setPrivateNaviBar {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectionMothed:)] autorelease];
    self.navigationItem.title = self.text;
}


- (void)layoutView {

    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, HEIGHT - 44)];
//    _infoTableView.bounces = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    //设置不显示竖直滚动条
    _infoTableView.showsVerticalScrollIndicator = NO;
    [_infoTableView registerClass:[DetailInfoTableViewCell class] forCellReuseIdentifier:@"info"];
    [_infoTableView registerClass:[DetailFoodTableViewCell class] forCellReuseIdentifier:@"food"];
    [_infoTableView registerClass:[DetailStepTableViewCell class] forCellReuseIdentifier:@"steps"];
    [_infoTableView registerClass:[DetailPhotoTableViewCell class] forCellReuseIdentifier:@"cover"];
    
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"foodHeader"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cookTime"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCount"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"stepFeader"];
    [_infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Tips"];
    
    [self.view addSubview:_infoTableView];
    [_infoTableView release];
}

#pragma mark ************* 读取数据 ***************
- (void)readData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block PictureViewController *vc = self;
    [self.manager POST:[NSString stringWithFormat:FenLeiMovieStepUrl,vc.receiveModel.RecipeId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc praserData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        NSLog(@"%@",error);
    }];
}

- (void) praserData:(id)responseObject {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self layoutView];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource.count;
    } else if (section == 1){
        return self.dataSource.count;
    } else if (section == 2){
        return 1;
    } else if (section == 3){
        return self.foodArray.count;
    } else if (section == 4){
        return self.dataSource.count;
    } else if (section == 5){
        return self.dataSource.count;
    } else if (section == 6) {
        return 1;
    } else if (section == 7) {
        return self.stepArray.count;
    } else if (section == 8) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section == 0) {
        DetailPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cover"];
       InfoModel *model = self.dataSource[indexPath.row];
       cell.model = model;
        return cell;
    } else if (indexPath.section == 1) {
        DetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
        InfoModel *model = self.dataSource[indexPath.row];
        cell.model = model;
        return cell;
    }else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodHeader"];
        cell.contentView.backgroundColor = COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"食材";
        cell.textLabel.backgroundColor = COLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }  else if (indexPath.section == 3) {
        DetailFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"food" forIndexPath:indexPath];
        foodModel *model = self.foodArray[indexPath.row];
        cell.model = model;
        return cell;
    } else if (indexPath.section == 4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cookTime" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        InfoModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"制作时间: ",model.CookTime];
        return cell;
    } else if (indexPath.section == 5){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCount" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        InfoModel *model = self.dataSource[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"用餐人数: ",model.UserCount];
        return cell;
    } else if (indexPath.section == 6) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stepFeader" forIndexPath:indexPath];
        cell.contentView.backgroundColor = COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"步骤";
        cell.textLabel.backgroundColor = COLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    } else if (indexPath.section == 7) {
        DetailStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"steps" forIndexPath:indexPath];
        stepsModel *model = self.stepArray[indexPath.row];
        cell.model = model;
        cell.stepIntro.text = [NSString stringWithFormat:@"%ld %@",indexPath.row + 1,model.Intro];
        return cell;
    } else if (indexPath.section == 8) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodHeader" forIndexPath:indexPath];
        cell.contentView.backgroundColor = COLOR;
        cell.textLabel.backgroundColor = COLOR;
        cell.textLabel.text = @"小贴士";
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tips" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InfoModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.Tips;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return WIDTH / 2;
    }else if (indexPath.section == 1) {
        InfoModel *model = self.dataSource[indexPath.row];
        return [DetailInfoTableViewCell heightForRow:model];
    } else if (indexPath.section == 7) {
        stepsModel *model = self.stepArray[indexPath.row];
        return [DetailStepTableViewCell heightForRow:model];
    } else if (indexPath.section == 9) {
        InfoModel *model = self.dataSource[indexPath.row];
        return [[self class] heightForText:model.Tips] + WIDTH / 20;
    }
    return WIDTH * 3 / 40 + WIDTH / 20;
}

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
