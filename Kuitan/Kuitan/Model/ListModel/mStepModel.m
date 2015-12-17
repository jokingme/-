//
//  mStepModel.m
//  Kuitan
//
//  Created by lanouhn on 15/10/17.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "mStepModel.h"

@implementation mStepModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

@end
