//
//  ztModel.h
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ztModel : NSObject
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString *text ;
@property(nonatomic,copy)NSString* image;
@property(nonatomic,copy)NSString *IDs;


-(instancetype)initWithDic:(NSDictionary *)dic;

@end
