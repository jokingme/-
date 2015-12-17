//
//  stepsModel.m
//  Kuitan
//
//  Created by lanouhn on 15/10/19.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "stepsModel.h"

@implementation stepsModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)dealloc {
    self.StepPhoto = nil;
    self.Intro = nil;
    [super dealloc];
}

@end
