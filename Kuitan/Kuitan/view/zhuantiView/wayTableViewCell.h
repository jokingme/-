//
//  wayTableViewCell.h
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wayModel.h"
@interface wayTableViewCell : UITableViewCell
@property(nonatomic,retain)UILabel* titleLabel;
@property(nonatomic,retain)UIImageView *cookpicture;
@property(nonatomic,retain)UILabel* introduceLabel;
@property(nonatomic,retain)wayModel *wModel;
+ (CGFloat)heightForRow:(wayModel *)model;
@end
