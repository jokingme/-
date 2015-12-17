//
//  NextDownModel.m
//  Kuitan
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "NextDownModel.h"

@implementation NextDownModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)NextDownModelWithDict:(NSDictionary *)dict {
    return [[[self alloc] initWithDict:dict] autorelease];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)dealloc {
    self.dishes_step_order = nil;
    self.dishes_step_image = nil;
    self.dishes_step_desc = nil;
    [super dealloc];
}
@end
