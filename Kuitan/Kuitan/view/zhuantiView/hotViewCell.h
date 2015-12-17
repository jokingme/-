//
//  hotViewCell.h
//  sssss
//
//  Created by lanouhn on 15/10/21.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hotModel.h"
@interface hotViewCell : UITableViewCell
@property(nonatomic,retain)UILabel* titleLabel;
@property(nonatomic,retain)UILabel* descripeLabel;
@property(nonatomic,retain)UIImageView *cookimage;
@property (nonatomic,retain) hotModel *model;
@property(nonatomic,retain)UIImageView *cookor;
@property(nonatomic,retain)UIScrollView *sc;
@property(nonatomic,retain)UIView *view;
+ (CGFloat)heightForRow:(hotModel *)model;
@end
