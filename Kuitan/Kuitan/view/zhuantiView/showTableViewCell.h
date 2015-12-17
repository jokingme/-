//
//  showTableViewCell.h
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztModel.h"

@interface showTableViewCell : UITableViewCell
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *contentLabel;
@property(nonatomic,retain)UIImageView *cookpicture;
@property (nonatomic,retain) ztModel *model;


+ (CGFloat)heightForRow:(ztModel *)model;

+ (CGFloat)heightForContent:(NSString *)text;
@end
