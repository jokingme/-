//
//  way2ViewCell.h
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/25.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wayModel.h"
@interface way2ViewCell : UITableViewCell
@property(nonatomic,retain)UIImageView *wayImage;
@property(nonatomic,retain)UILabel *wayLabel;
+(CGFloat)heigthway2Height;
+ (CGFloat)height2ForRow:(wayModel *)model;
@end
