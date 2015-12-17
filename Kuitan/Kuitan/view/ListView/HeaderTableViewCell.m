//
//  HeaderTableViewCell.m
//  Kuitan
//
//  Created by lanouhn on 15/10/26.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "HeaderTableViewCell.h"
#import "MeiShi.h"

@interface HeaderTableViewCell ()


@end

@implementation HeaderTableViewCell

- (void)dealloc {
    self.contentLabel = nil;
    self.model = nil;
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 40, WIDTH - WIDTH / 20, 100)] autorelease];
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return [[_contentLabel retain] autorelease];
}

- (void)setModel:(InfoModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.contentLabel.text = model.Tips;
    CGRect frame = CGRectMake(WIDTH / 40, WIDTH / 40, WIDTH - WIDTH / 20, [[self class] heightForContent:model.Tips]);
    self.contentLabel.frame = frame;
}


+ (CGFloat)heightForRow:(InfoModel *)model {
    return [[self class] heightForContent:model.Tips] + WIDTH / 20;
}

+ (CGFloat)heightForContent:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(WIDTH - WIDTH / 20, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
