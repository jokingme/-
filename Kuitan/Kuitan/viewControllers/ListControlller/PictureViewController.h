//
//  PictureViewController.h
//  Kuitan
//
//  Created by lanouhn on 15/10/19.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface PictureViewController : UIViewController
@property (nonatomic,copy) NSString *recipedId;
@property (nonatomic,retain) DetailModel *receiveModel;
@property (nonatomic,copy) NSString *text;
@end
