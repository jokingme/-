//
//  wayTableViewController.m
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//
#define WIDTH  [[UIScreen mainScreen] applicationFrame].size.width
#import "AFNetworking.h"
#import "wayTableViewController.h"
#import "wayModel.h"
#import "wayTableViewCell.h"
#import "way2ViewCell.h"
#import "UIImageView+WebCache.h"
#import "PPPHeadView.h"
@interface wayTableViewController ()
@property(nonatomic,retain)wayModel *model;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property (nonatomic , retain) NSMutableArray *imageSource;

@end

@implementation wayTableViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource )
    {
        self.dataSource = [NSMutableArray arrayWithCapacity:0 ];
    }
    return _dataSource;
}
-(NSMutableArray *)imageSource{
    if (!_imageSource) {
        self.imageSource = [NSMutableArray array];
    }
    return _imageSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;
    [self.tableView registerClass:[way2ViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[wayTableViewCell class] forCellReuseIdentifier:@"hello"];
    [self  requestData];
}
-(void)requestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block wayTableViewController *tv =self;
    
    [manager POST:[ NSString  stringWithFormat:@"http://api.izhangchu.com/?user_id=963215&token=1ED248995C2F9E6D4D6340E362661CA7&methodName=DishesView&dishes_id=%d&version=4.02&",[self.page intValue]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *adata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableContainers error:nil];
        [tv parserData:dic[@"data"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误");
    }];
}
-(void)parserData:(NSDictionary *)dic
{
    _model = [[wayModel alloc]initWithDic:dic];
   for (NSDictionary *dict  in dic[@"step"]) {
    NSString *str =  [NSString stringWithFormat:@"%@ %@",dict[@"dishes_step_order"],dict[@"dishes_step_desc"]];
    [self.dataSource addObject:str];
        
    NSString *image = dict[@"dishes_step_image"];
    [self.imageSource addObject:image];
    }
    NSLog(@"%@",_dataSource);
    NSLog(@"%@",_imageSource);
    [self.tableView reloadData];
//    [self.dataSource addObject:_model];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    if (section == 0) {
        return 1;
    }
    return _imageSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
    wayTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:@"hello" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text  = _model.dashes_name;
    cell.introduceLabel.text = _model.material_desc;
    [cell.cookpicture sd_setImageWithURL:[NSURL  URLWithString:_model.image] placeholderImage:nil];
    return cell;
    }
    way2ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.wayImage sd_setImageWithURL:[NSURL URLWithString:_imageSource[indexPath.row]] placeholderImage:nil];
    cell.wayLabel.text  = _dataSource[indexPath.row];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PPPHeadView *p = [[PPPHeadView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/20)];
    p.headLabel.text = @"制作方法";
    return p ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 )
    {
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 )
    {
        return [wayTableViewCell  heightForRow:_model];
    }
    return [way2ViewCell height2ForRow:_model];
}
- (void)dealloc
{
    [_model release];
    [super dealloc];
}

@end
