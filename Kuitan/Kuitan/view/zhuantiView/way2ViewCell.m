//
//  way2ViewCell.m
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//
#define WIDTH  [[UIScreen mainScreen] applicationFrame].size.width
#import "way2ViewCell.h"

@implementation way2ViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.wayImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/20, WIDTH/40, WIDTH -  WIDTH/10,WIDTH / 2)];
        self.wayLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/20,WIDTH / 2  +WIDTH / 40,WIDTH  - WIDTH / 10,WIDTH /8 )];
        _wayLabel.font = [UIFont systemFontOfSize:16];
        _wayLabel.numberOfLines = 0;
        [self.contentView addSubview:_wayImage];
        [self.contentView addSubview:_wayLabel];
        [_wayImage release];
        [_wayLabel release];
    }
    return self;
}
+ (CGFloat)height2ForRow:(wayModel *)model {
    return [[self class] heightForContent:model.stepStr] + WIDTH / 2 +WIDTH / 6;
}

+ (CGFloat)heightForContent:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(WIDTH, 100000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}


@end
