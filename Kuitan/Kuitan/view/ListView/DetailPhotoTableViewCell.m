//
//  DetailPhotoTableViewCell.m
//  Kuitan
//
//  Created by lanouhn on 15/10/21.
//  Copyright (c) 2015年 S&G. All rights reserved.
//
#import "DetailPhotoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MeiShi.h"

@implementation DetailPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.coverImage];
    }
    return self;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        self.coverImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH / 2)] autorelease];
    }
    return [[_coverImage retain] autorelease];
}

- (void)setModel:(InfoModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.Cover] placeholderImage:[UIImage imageNamed:@"meishi4"]];
}

- (void)dealloc {
    self.coverImage = nil;
    self.model = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
