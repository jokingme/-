//
//  DownDetileViewCell.m
//  Kuitan
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "DownDetileViewCell.h"
#import "DownDetileModel.h"
#import "UIImageView+WebCache.h"
#import "MeiShi.h"

@interface DownDetileViewCell ()
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;

@end

@implementation DownDetileViewCell
- (void)dealloc {
    self.imageView = nil;
    self.titleLabel = nil;
    self.model = nil;
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
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - WIDTH * 3 / 40)] autorelease];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 5;
    }
    return [[_imageView retain] autorelease];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - WIDTH * 3 / 40, self.contentView.frame.size.width, WIDTH * 3 / 40)] autorelease];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return [[_titleLabel retain] autorelease];
}
- (void)setModel:(DownDetileModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"meishi5"]];
    self.titleLabel.text = model.title;
    
    
    
}
@end
