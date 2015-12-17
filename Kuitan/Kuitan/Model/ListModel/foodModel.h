//
//  foodModel.h
//  Kuitan
//
//  Created by lanouhn on 15/10/19.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface foodModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *weight;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
