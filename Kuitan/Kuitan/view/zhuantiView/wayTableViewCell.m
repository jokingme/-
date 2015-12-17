//
//  wayTableViewCell.m
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//
#define WIDTH  [[UIScreen mainScreen] applicationFrame].size.width
#import "wayTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation wayTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cookpicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH - WIDTH / 5)];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/20, WIDTH  - WIDTH / 6 , WIDTH - WIDTH / 10, WIDTH/40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    self.introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/20,WIDTH - WIDTH / 7,WIDTH -WIDTH  / 10 , WIDTH / 6 )];
    _introduceLabel.font = [UIFont systemFontOfSize:14];
    _introduceLabel.textColor = [UIColor grayColor];
    _introduceLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_introduceLabel];
    [self.contentView addSubview:_cookpicture];
        
        [_titleLabel release];
        [_introduceLabel release];
        [_cookpicture release];
    }
    return self;
}
+ (CGFloat)heightForRow:(wayModel *)model {
    return [[self class] heightForContent:model.material_desc] + WIDTH  - WIDTH / 15;
}



+ (CGFloat)heightForContent:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(WIDTH, 100000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
}
//-(void)setwModel:(wayModel *)model
//{
//    self.titleLabel.text  = model.dashes_name;
//    self.introduceLabel.text = model.material_desc;
//    [self.cookpicture sd_setImageWithURL:[NSURL  URLWithString:model.image] placeholderImage:nil];
//}
@end
