//
//  hotViewCell.m
//  sssss
//
//  Created by lanouhn on 15/10/21.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//
#define WIDTH  [[UIScreen mainScreen] applicationFrame].size.width
#import "hotViewCell.h"
#import "hotModel.h"
#import "UIImageView+WebCache.h"

@implementation hotViewCell
//每一行的高度
+ (CGFloat)heightForRow:(hotModel *)model
{
    return WIDTH / 2 + WIDTH/10 +WIDTH/20;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        self.selectionStyle =UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/40, 5, WIDTH, WIDTH/30)];
        _titleLabel.textColor = [UIColor whiteColor];
                self.descripeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/40, WIDTH/20 +5, WIDTH, WIDTH/30)];
        _descripeLabel.font = [UIFont systemFontOfSize:15];
        _descripeLabel.textColor = [UIColor whiteColor];
        self.cookimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/20, WIDTH/40, WIDTH- WIDTH/10, WIDTH/2+WIDTH/10 + WIDTH/40)];
        _cookimage.alpha = 0.9;
        self.view = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH/2 , WIDTH- WIDTH/10, WIDTH/10+WIDTH/40)];
        _view.backgroundColor = [UIColor orangeColor];
        _view.alpha = 0.9;
        [_cookimage addSubview: _view];
        self.cookor =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - WIDTH / 5, WIDTH/ 50, WIDTH/11,WIDTH/10)];
        _cookor.image = [UIImage  imageNamed:@"cook.png"];
        [_cookimage addSubview:_cookor];
                                                                  
        [_view addSubview:_titleLabel];
        [_view addSubview:_descripeLabel];
        [self.contentView addSubview:_cookimage];
        [_titleLabel release];
        [_descripeLabel release];
        [_cookimage release];
    }
    return self;
}
-(void)setModel:(hotModel*)model
{
    if (_model != model)
    {
        [_model release];
        _model =[model retain];
    }
    [self.cookimage sd_setImageWithURL:[NSURL  URLWithString:model.image] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.descripeLabel.text = model.text;
}

@end
