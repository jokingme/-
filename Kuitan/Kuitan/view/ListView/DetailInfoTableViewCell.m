//
//  DetailInfoTableViewCell.m
//  Kuitan
//
//  Created by lanouhn on 15/10/18.
//  Copyright (c) 2015年 S&G. All rights reserved.
//
#import "DetailInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MeiShi.h"

@implementation DetailInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.dishLabel];
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.ReviewTimeLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}


- (UILabel *)dishLabel {
    if (!_dishLabel) {
        self.dishLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 40, WIDTH - WIDTH / 20, WIDTH / 10)] autorelease];
        _dishLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return [[_dishLabel retain] autorelease];
}

- (UIImageView *)userImage {
    if (!_userImage) {
        self.userImage = [[[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 40 + WIDTH / 10 + WIDTH / 40, WIDTH * 3 / 20, WIDTH * 3 / 20)] autorelease];
        _userImage.layer.cornerRadius = WIDTH * 3 / 40;
        _userImage.layer.masksToBounds = YES;
        _userImage.image = [UIImage imageNamed:@"app"];
    }
    return [[_userImage retain] autorelease];
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        self.userNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40 + WIDTH * 3 / 20 + WIDTH / 80, WIDTH / 40 + WIDTH  / 10 + WIDTH / 40 + WIDTH / 80, WIDTH / 2, WIDTH / 20 + WIDTH / 80)] autorelease];
        _userNameLabel.text = @"时尚菜谱";
    }
    return [[_userNameLabel retain] autorelease];
}

- (UILabel *)ReviewTimeLabel {
    if (!_ReviewTimeLabel) {
        self.ReviewTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40 + WIDTH * 3 / 20 + WIDTH / 80, WIDTH / 40 + WIDTH / 10 + WIDTH / 40 + WIDTH / 80 + WIDTH / 20 + WIDTH / 80, WIDTH / 2,  WIDTH / 20 + WIDTH / 80)] autorelease];
        _ReviewTimeLabel.textColor = [UIColor grayColor];
    }
    return [[_ReviewTimeLabel retain] autorelease];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 40 + WIDTH / 10 + WIDTH / 40 + WIDTH * 3 / 20 + WIDTH / 20, WIDTH - WIDTH / 20, 40)] autorelease];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return [[_contentLabel retain] autorelease];
}

- (void)setModel:(InfoModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.dishLabel.text = model.Title;
    self.ReviewTimeLabel.text = model.ReviewTime;
    self.contentLabel.text = model.Intro;
    CGRect frame = CGRectMake(WIDTH / 40, WIDTH / 40 + WIDTH / 10 + WIDTH / 40 + WIDTH * 3 / 20 + WIDTH / 20, WIDTH - WIDTH / 20, [[self class] heightForContent:model.Intro]);
    self.contentLabel.frame = frame;
}

+ (CGFloat)heightForRow:(InfoModel *)model {
    return [[self class] heightForContent:model.Intro] + WIDTH / 40 + WIDTH / 10 + WIDTH / 40 + WIDTH * 3 / 20 + WIDTH / 20 + WIDTH / 40;
}

+ (CGFloat)heightForContent:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(WIDTH - WIDTH / 20, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.height;
}

- (void)dealloc {
    self.dishLabel = nil;
    self.userImage = nil;
    self.userNameLabel = nil;
    self.ReviewTimeLabel = nil;
    self.contentLabel = nil;
    self.model = nil;
    [super dealloc];
}

@end
