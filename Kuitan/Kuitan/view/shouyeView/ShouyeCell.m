//
//  ShouyeCell.m
//  Kuitan
//
//  Created by laouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "ShouyeCell.h"
#import "Shouye.h"
#import "UIImageView+WebCache.h"
#import "MeiShi.h"
@interface ShouyeCell ()
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;

@end


@implementation ShouyeCell

- (void)dealloc {
    self.imageView = nil;
    self.titleLabel = nil;
    self.shouye = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - WIDTH * 3 / 40)] autorelease];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
    }
    return [[_imageView retain] autorelease];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - WIDTH * 3 / 40, self.frame.size.width, WIDTH * 3 / 40)] autorelease];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return [[_titleLabel retain] autorelease];
}
- (void)setShouye:(Shouye *)shouye {
    if (_shouye != shouye) {
        [_shouye release];
        _shouye = [shouye retain];
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shouye.image] placeholderImage:[UIImage imageNamed:@"meishi5"]];
    self.titleLabel.text = shouye.text;
}
@end
