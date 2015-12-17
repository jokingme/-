//
//  DetailFoodTableViewCell.m
//  Kuitan
//
//  Created by lanouhn on 15/10/18.
//  Copyright (c) 2015年 S&G. All rights reserved.
//
#import "DetailFoodTableViewCell.h"
#import "MeiShi.h"

@implementation DetailFoodTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.foodLabel];
        [self.contentView addSubview:self.weightLabel];
    }
    return self;
}

- (UILabel *)foodLabel {
    if (!_foodLabel) {
        self.foodLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 40, (WIDTH - WIDTH / 20) / 2 , WIDTH * 3 / 40)] autorelease];
    }
    return _foodLabel;
}

- (UILabel *)weightLabel {
    if (!_weightLabel) {
        self.weightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40 + (WIDTH - WIDTH / 20) / 2, WIDTH / 40, (WIDTH - WIDTH / 20) / 2, WIDTH * 3 / 40)] autorelease];
        _weightLabel.textColor = [UIColor grayColor];
    }
    return _weightLabel;
}

- (void)setModel:(foodModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.foodLabel.text = model.name;
    self.weightLabel.text = model.weight;
}

- (void)dealloc {
    self.foodLabel = nil;
    self.weightLabel = nil;
    self.model = nil;
    [super dealloc];
}

@end
