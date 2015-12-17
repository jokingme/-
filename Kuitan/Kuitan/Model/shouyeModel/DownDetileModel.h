//
//  DownDetileModel.h
//  Kuitan
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownDetileModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, retain) NSNumber *dishes_id;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
