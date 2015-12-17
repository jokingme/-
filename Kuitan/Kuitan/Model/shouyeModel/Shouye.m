//
//  Shouye.m
//  Kuitan
//
//  Created by laouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "Shouye.h"

@implementation Shouye
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}

- (void)dealloc {
    self.Id = nil;
    self.text = nil;
    self.image = nil;
    [super dealloc];
}

@end
