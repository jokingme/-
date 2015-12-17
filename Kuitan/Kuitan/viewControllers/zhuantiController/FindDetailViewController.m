//
//  FindDetailViewController.m
//  Kuitan
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "AFNetworking.h"//用来请求数据
#import "MBProgressHUD.h"//用来解析数据
#import "Xqmodel.h"//导入模型
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "FindDetailViewController.h"
#import "MeiShi.h"

@interface FindDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,retain)UIImageView *cookphoto;
@property(nonatomic,retain)UIImageView *manphoto;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain) UILabel *titleLabel ;
@property(nonatomic,retain)UIScrollView *sc;
@property(nonatomic,retain)NSMutableArray *datasource;
@property(nonatomic,retain)Xqmodel *model;
@property (nonatomic,retain) UILabel *kong;
@property (nonatomic,retain) AFHTTPRequestOperationManager *manager;
@end

@implementation FindDetailViewController

- (void)dealloc {
    self.ID = nil;
    self.text = nil;
    self.webView = nil;
    self.cookphoto = nil;
    self.manphoto = nil;
    self.nameLabel = nil;
    self.titleLabel = nil;
    self.sc = nil;
    self.datasource = nil;
    self.model = nil;
    self.kong = nil;
    self.manager = nil;
    [super dealloc];
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

-(NSMutableArray *)datasource {
    if (!_datasource)
    {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return  _datasource;
}

- (AFHTTPRequestOperationManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //    [self share];
    //数据请求
    [self  requestData];
    [self setupView];
    self.navigationItem.title = self.text;
}

- (void)setupView {
    
    self.sc = [[[UIScrollView alloc]initWithFrame:CGRectMake(WIDTH / 40, 64, WIDTH - WIDTH / 20, HEIGHT - 64)] autorelease];
    _sc.showsVerticalScrollIndicator = NO;
    //设置滚动条代理
    _sc.delegate = self;
    _sc.bounces = NO;
    
    self.cookphoto = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/40, WIDTH/20,WIDTH-WIDTH/20,WIDTH/2-WIDTH/20)];
    
    self.manphoto = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2 - WIDTH/10, WIDTH/2 + WIDTH/40, WIDTH/5, WIDTH/5)];
    _manphoto.layer.cornerRadius = WIDTH/10;
    _manphoto.layer.masksToBounds = YES;
    CGFloat nalY =WIDTH/2 + WIDTH/40 +WIDTH/20 +WIDTH/5;
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nalY, WIDTH,WIDTH/20)];
    _nameLabel.textAlignment =  NSTextAlignmentCenter;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nalY + WIDTH/20 +WIDTH/40 , WIDTH, WIDTH/20)];
    _titleLabel.textAlignment =  NSTextAlignmentCenter;
    
    self.kong = [[UILabel alloc]initWithFrame:CGRectMake(0, nalY + WIDTH/20 +WIDTH/40+WIDTH/20 + WIDTH / 40, WIDTH, WIDTH/20)];
    _kong.alpha = 0.1;
    
    self.webView  = [[[UIWebView alloc]initWithFrame:CGRectMake(0, WIDTH, WIDTH-WIDTH/20, 500)] autorelease];
    _webView.backgroundColor = [UIColor orangeColor];
    _webView.userInteractionEnabled = NO;
    
    
    
    
    [_sc addSubview:_kong];
    [_sc addSubview:_webView];
    [_sc addSubview:_cookphoto];
    [_sc addSubview:_manphoto];
    [_sc addSubview:_nameLabel];
    [_sc addSubview:_titleLabel];
    [self.view addSubview:_sc];
    
    [_cookphoto release];
    [_manphoto release];
    [_nameLabel release];
    [_titleLabel release];
}
//数据请求
-(void)requestData
{
    [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block FindDetailViewController *vc = self;
    [self.manager POST:[NSString  stringWithFormat: FindDetailUrl,[vc.ID intValue]]parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData *adata = [str dataUsingEncoding:NSUTF8StringEncoding];
         [str release];
         NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:adata options:NSJSONReadingMutableContainers error:nil];
         [_webView loadHTMLString:dic[@"data"][@"content"] baseURL:nil];
         _webView.delegate = vc;
         [vc parseData:dic[@"data"]];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请重新尝试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alertView show];
         [alertView release];
         NSLog(@"%@",error);
     }];
}
//数据解析
-(void)parseData:(NSDictionary *)dic
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.model = [[Xqmodel alloc]initWithDic:dic];
    [self.datasource addObject:_model];
    [self.cookphoto sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"meishi4"]];
    self.titleLabel.text = _model.title;
    [self.manphoto sd_setImageWithURL:[NSURL URLWithString:_model.headphoto] placeholderImage:[UIImage imageNamed:@"iconfont-wode"]];
    self.nameLabel.text = _model.nickname;
    [_model release];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    self.webView = webView;
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                      "script.type = 'text/javascript';"
                                                      "script.text = \"function ResizeImages() { "
                                                      "var myimg,oldwidth;"
                                                      "var maxwidth = %f;" // UIWebView中显示的图片宽度
                                                      "for(i=0;i <document.images.length;i++){"
                                                      "myimg = document.images[i];"
                                                      "if(myimg.width > maxwidth){"
                                                      "oldwidth = myimg.width;"
                                                      "myimg.width = maxwidth;"
                                                      "}"
                                                      "}"
                                                      "}\";"
                                                      "document.getElementsByTagName('head')[0].appendChild(script);",WIDTH-20]];
    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    CGRect frame = webView.frame;
    CGSize websize = [webView sizeThatFits:CGSizeZero];
    websize.width = WIDTH-20;
    frame.size = websize;
    _webView.frame = frame;
    CGFloat webh= WIDTH/2 + WIDTH/40 +WIDTH/20 +WIDTH/5 +WIDTH/20 +WIDTH/40+WIDTH/20 +WIDTH/10;
    self.sc.contentSize = CGSizeMake(WIDTH -  20,websize.height + webh - 150);
    _kong.backgroundColor = [UIColor grayColor];
    [_kong release];
}
/*
 -(void)share
 {
 UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shareicon"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
 self.navigationItem.rightBarButtonItem = rigthButton;
 
 }
 */
/*
 -(void)shareAction
 {
 //实现分享
 [UMSocialSnsService presentSnsIconSheetView:self
 appKey:@"5626f92167e58eb94e004823"
 shareText:@"请输入英文"
 shareImage:[UIImage imageNamed:@"beautifulgirl"]
 shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToSms,nil]
 delegate:nil];
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
