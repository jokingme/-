
//
//  NextDownCell.m
//  Kuitan
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 S&G. All rights reserved.
//


#import "NextDownCell.h"
#import "NextDownModel.h"
#import "UIImageView+WebCache.h"
#import "MeiShi.h"

@interface NextDownCell ()
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *numLabel;
@property (nonatomic, retain) UIImageView *picView;

@end


@implementation NextDownCell
- (void)dealloc {
    self.picView = nil;
    self.label = nil;
    self.numLabel = nil;
    self.nextModel = nil;
    [super dealloc];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.picView];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.numLabel];
         self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UIImageView *)picView {
    if (!_picView) {
        self.picView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH / 2)] autorelease];
    }
    return [[_picView retain] autorelease];
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        self.numLabel = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 2 + WIDTH / 40, WIDTH / 10, WIDTH / 10)] autorelease];
        self.numLabel.layer.masksToBounds = YES;
        self.numLabel.layer.cornerRadius = WIDTH / 20;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.backgroundColor = COLOR;
        _numLabel.textColor = [UIColor whiteColor];
    }
    return [[_numLabel retain] autorelease];
}

- (UILabel *)label {
    if (!_label) {
        self.label = [[[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40 + WIDTH / 10 + WIDTH / 40, WIDTH / 2 + WIDTH / 40, WIDTH - WIDTH  * 3 / 40 - WIDTH / 10,  WIDTH / 10)] autorelease];
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.numberOfLines = 0;
        
    }
    return [[_label retain] autorelease];
}
- (void)setNextModel:(NextDownModel *)nextModel {
    if (_nextModel != nextModel) {
        [_nextModel release];
        _nextModel = [nextModel retain] ;
    }
    [self.picView sd_setImageWithURL:[NSURL URLWithString:nextModel.dishes_step_image] placeholderImage:[UIImage imageNamed:@"meishi4"]];
    self.label.text = nextModel.dishes_step_desc;
    self.numLabel.text = nextModel.dishes_step_order;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
