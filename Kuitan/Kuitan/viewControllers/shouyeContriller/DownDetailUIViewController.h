//
//  DownDetailUIViewController.h
//  Kuitan
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownDetileModel.h"

@interface DownDetailUIViewController : UIViewController
@property (nonatomic, copy) NSString *shuibian;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic,retain) DownDetileModel *shouYeModel;
@end
