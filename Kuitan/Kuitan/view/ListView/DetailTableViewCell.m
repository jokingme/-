//
//  DetailTableViewCell.m
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//
#import "DetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MeiShi.h"

@implementation DetailTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImage];
        [self.coverImage addSubview:self.videoImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.label1];
        [self.contentView addSubview:self.stuffLabel];
    }
    return  self;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        self.coverImage = [[[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 40, WIDTH / 4, WIDTH  / 6)] autorelease];
    }
    return [[_coverImage retain] autorelease];
}

- (UIImageView *)videoImage {
    if (!_videoImage) {
        self.videoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 4 - WIDTH * 3 / 40, WIDTH / 40, WIDTH / 20, WIDTH / 20)] autorelease];
        _videoImage.layer.cornerRadius = WIDTH / 40;
        _videoImage.layer.masksToBounds = YES;
    }
    return [[_videoImage retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4 + WIDTH / 40 + WIDTH / 80, WIDTH / 40, WIDTH - WIDTH / 4 - WIDTH / 20 - WIDTH / 80, WIDTH  / 14)] autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return [[_titleLabel retain] autorelease];
}


- (UILabel *)label1 {
    if (!_label1) {
        self.label1 = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4 + WIDTH / 40 + WIDTH / 80, WIDTH / 40 + WIDTH  / 14 + WIDTH / 84, WIDTH - WIDTH / 4 - WIDTH / 20 - WIDTH / 80, WIDTH  / 28)] autorelease];
        _label1.textColor = [UIColor grayColor];
        _label1.font = [UIFont systemFontOfSize:12];
    }
    return [[_label1 retain] autorelease];
}


- (UILabel *)stuffLabel {
    if (!_stuffLabel) {
        self.stuffLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 4 + WIDTH / 40 + WIDTH / 80, WIDTH  / 6 - WIDTH  / 28 + WIDTH / 40, WIDTH - WIDTH / 4 - WIDTH / 16, WIDTH  / 28)]autorelease];
        _stuffLabel.textColor = [UIColor grayColor];
        _stuffLabel.font = [UIFont systemFontOfSize:12];
    }
    return [[_stuffLabel retain] autorelease];
}


- (void)setModel:(DetailModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }

    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.Cover] placeholderImage:[UIImage imageNamed:@"meishi5"]];
    self.titleLabel.text = model.Title;
    self.label1.text = model.Collection;
    self.stuffLabel.text = model.Stuff;
}

- (void)dealloc {
    self.coverImage = nil;
    self.titleLabel = nil;
    self.label1 = nil;
    self.stuffLabel = nil;
    self.videoImage = nil;
    self.model = nil;
//    self.saveButton = nil;
    [super dealloc];
}

@end
