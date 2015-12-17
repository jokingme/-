//
//  showTableViewCell.m
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//


#import "showTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MeiShi.h"

@implementation showTableViewCell

- (void)dealloc {
    self.titleLabel = nil;
    self.contentLabel = nil;
    self.cookpicture = nil;
    self.model = nil;
    [super dealloc];
}

//初始化   设置布局
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.cookpicture];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (UIImageView *)cookpicture {
    if (!_cookpicture) {
        self.cookpicture = [[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 20, WIDTH - WIDTH / 20, WIDTH / 3)] autorelease];
    }
    return [[_cookpicture retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel  = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 3 + WIDTH / 20 + WIDTH / 40, WIDTH - WIDTH / 20, WIDTH / 20)] autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return [[_titleLabel retain] autorelease];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 3 + WIDTH / 20 + WIDTH / 40 + WIDTH / 20 + WIDTH / 80,WIDTH -  WIDTH / 20,WIDTH / 40)] autorelease];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return [[_contentLabel retain] autorelease];
}



//设置传递内容
- (void)setModel:(ztModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self.cookpicture sd_setImageWithURL:[NSURL URLWithString: model.image] placeholderImage:[UIImage imageNamed:@"meishi4"]];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.text;
    CGRect frame = CGRectMake(WIDTH / 40, WIDTH / 3 + WIDTH / 20 + WIDTH / 40 + WIDTH / 20 + WIDTH / 80,WIDTH - WIDTH / 20,  [[self class] heightForContent:model.text] );
    self.contentLabel.frame = frame;
}

+ (CGFloat)heightForRow:(ztModel *)model {
    return [[self class] heightForContent:model.text] + WIDTH / 3 + WIDTH / 20 + WIDTH / 40 + WIDTH / 20 + WIDTH / 80 + WIDTH / 20;
}



+ (CGFloat)heightForContent:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(WIDTH, 100000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
}



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end



