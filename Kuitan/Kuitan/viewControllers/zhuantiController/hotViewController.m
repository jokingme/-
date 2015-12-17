//
//  ViewController.m
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/22.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//
#define WIDTH    [[UIScreen mainScreen]applicationFrame].size.width
#define HEIGHT   [[UIScreen mainScreen]applicationFrame].size.height
#import "hotViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "hotModel.h"
#import "hotViewCell.h"
#import "wayTableViewController.h"
#import "UIImageView+WebCache.h"

@interface  hotViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,retain)NSMutableArray *firstdatasource;//左边tableView数据源
@property(nonatomic,retain)NSMutableArray *secondsource;//右边tableView数据源
@property(nonatomic,retain)hotModel *model;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,retain)UIScrollView *scroll ;
@property(nonatomic,retain)UITableView *leftTableView;
@property(nonatomic,retain)UITableView *rightTableView;
@property(nonatomic,retain) UISegmentedControl *segment ;
@end


@interface hotViewController ()

@end

@implementation hotViewController
//数据源 懒加载
-(NSMutableArray*)firstdatasource
{
    if (!_firstdatasource)
    {
        self.firstdatasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _firstdatasource ;
}
-(NSMutableArray *)secondsource
{
    if (!_secondsource)
    {
        self.secondsource = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondsource ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    // Do any additional setup after loading the view.

    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, WIDTH,HEIGHT)];
    
    _scroll.contentSize = CGSizeMake(WIDTH *2, HEIGHT);
    _scroll.directionalLockEnabled = YES;
    _scroll.pagingEnabled = YES;
    _scroll.delegate =self;
   
    
    
    NSArray *segArr = [[NSArray alloc]initWithObjects:@"热门",@"新品",nil];
    _segment  = [[UISegmentedControl alloc]initWithItems:segArr];
    _segment.frame = CGRectMake(0, 0, WIDTH / 2, WIDTH * 3 / 40);
    [self.navigationItem setTitleView:_segment];
    _segment.selectedSegmentIndex = 0;
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH , HEIGHT - 64) style:UITableViewStylePlain];
    //_leftTableView.backgroundColor = [UIColor yellowColor];
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [_scroll addSubview:_leftTableView];
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.showsVerticalScrollIndicator = NO;
    [_scroll addSubview:_rightTableView];
    [self.view addSubview:_scroll];
    [self leftrequestData:_segment];
    NSLog(@"viewdidload first");
    [self rightrequestData:_segment];
    NSLog(@"viewdidload second");
    [_segment addTarget:self action:@selector(changeweb:) forControlEvents: UIControlEventValueChanged ];
}
//segment 监听
-(void)changeweb:(UISegmentedControl*)seg
{
    NSLog(@"监听");
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
        
            _scroll.contentOffset = CGPointMake(0, 0);

        
            break;
        case 1:
//            NSLog(@"调换成2 ");
            _scroll.contentOffset = CGPointMake(WIDTH , 0);

            break;
        default:
            break;

}
}


//页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
//页脚高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

//左边tableView数据请求
-(void)leftrequestData:(UISegmentedControl*)seg
{
    [MBProgressHUD showHUDAddedTo:_scroll animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block hotViewController *tv =self;
    
   [manager GET:[ NSString  stringWithFormat:@"http://api.izhangchu.com/?user_id=963215&type=%d&page=1&token=1ED248995C2F9E6D4D6340E362661CA7&methodName=HomeMore&size=10&version=4.02&",1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *adata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableContainers error:nil];
        [tv leftparserData:dic[@"data"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误");
    }];
}
//左边数据解析
-(void)leftparserData:(NSDictionary*)dic
{
    [MBProgressHUD hideAllHUDsForView:_scroll animated:YES];
    NSArray *arr = dic[@"data"];
    
    for (NSDictionary *dict in arr)
    {
        _model = [[hotModel alloc]initWithDic:dict];
        [self.firstdatasource addObject:_model];
    }
    
    [self.leftTableView reloadData];
}

//右边tableView数据请求
-(void) rightrequestData:(UISegmentedControl*)seg
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block hotViewController *fv =self;
    
    [manager GET:[ NSString  stringWithFormat:@"http://api.izhangchu.com/?user_id=963215&type=%d&page=1&token=1ED248995C2F9E6D4D6340E362661CA7&methodName=HomeMore&size=10&version=4.02&",2] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *adata = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableContainers error:nil];
        [fv rightparserData:dic[@"data"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误");
    }];
}
//右边tableView数据解析
-(void)rightparserData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (NSDictionary *dict in arr)
    {
        _model = [[hotModel alloc]initWithDic:dict];
        [self.secondsource addObject:_model];
    }
    [self.rightTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if ([tableView  isEqual:_leftTableView]) {
        
        return self.firstdatasource.count;
    }else
    {
        return self.secondsource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [hotViewCell heightForRow:_model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *  ID = @"cellid";
    hotViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil)
    {
        cell = [[hotViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if ( [tableView isEqual:  _leftTableView])
    {
    cell.model = self.firstdatasource[indexPath.section];
          return cell;
    }
    cell.model = self.secondsource[indexPath.section];
        return cell;

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _segment.selectedSegmentIndex = scrollView.contentOffset.x/WIDTH;

}


//点击cell页面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    wayTableViewController *way = [[wayTableViewController alloc]init];
    if ([tableView isEqual:_leftTableView])
    {
        hotModel *mmodel = self.firstdatasource[indexPath.section];
        way.page = mmodel.dishes_id;
    }else
    {
        hotModel *mmodel = self.secondsource[indexPath.section];
        way.page = mmodel.dishes_id;
    }
    [self.navigationController pushViewController:way animated:YES];
    [way release];
}

-(void)dealloc
{
    [_model release];
    [_scroll release];
    [_leftTableView release];
    [_rightTableView release];
    [_segment release];
    [super dealloc];
}
/*
 // Override to support conditional edit ing of the table view.
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

    // Dispose of any resources that can be recreated.


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
