//
//  HeaderView.m
//  Kuitan
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "HeaderView.h"
#import "MeiShi.h"

@implementation HeaderView

- (void)dealloc {
    self.headerLabel = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR;
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 40, WIDTH / 80, WIDTH - WIDTH / 20, self.frame.size.height - WIDTH / 40)];
        _headerLabel.font = [UIFont systemFontOfSize:15];
        _headerLabel.textColor = [UIColor whiteColor];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.headerLabel];
        [_headerLabel release];
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
