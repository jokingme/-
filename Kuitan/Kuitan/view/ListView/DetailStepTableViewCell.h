//
//  DetailStepTableViewCell.h
//  Kuitan
//
//  Created by lanouhn on 15/10/20.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stepsModel.h"

@interface DetailStepTableViewCell : UITableViewCell
@property (nonatomic,retain) UIImageView *stepPhoto;//步骤图片
@property (nonatomic,retain) UILabel *stepIntro;//步骤介绍

@property (nonatomic,retain) stepsModel *model;

+ (CGFloat)heightForRow:(stepsModel *)model;

+ (CGFloat)heightForContent:(NSString *)text;
@end
