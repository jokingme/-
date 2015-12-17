//
//  HeaderTableViewCell.h
//  Kuitan
//
//  Created by lanouhn on 15/10/26.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"

@interface HeaderTableViewCell : UITableViewCell

@property (nonatomic,retain) UILabel *contentLabel;
@property (nonatomic,retain) InfoModel *model;

+ (CGFloat)heightForRow:(InfoModel *)model;

+ (CGFloat)heightForContent:(NSString *)text;

@end
