//
//  PPPHeadView.m
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/26.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#define WIDTH  [[UIScreen mainScreen] applicationFrame].size.width
#import "PPPHeadView.h"
@implementation PPPHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.headLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH / 40)];
        _headLabel.backgroundColor = [UIColor whiteColor];
        _headLabel.textColor = [UIColor orangeColor];
        [self addSubview:_headLabel];
        [_headLabel release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
