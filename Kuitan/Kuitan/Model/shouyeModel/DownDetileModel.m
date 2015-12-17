

//
//  DownDetileModel.m
//  Kuitan
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "DownDetileModel.h"

@implementation DownDetileModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

-(void)dealloc {
    self.title = nil;
    self.image = nil;
    self.dishes_id = nil;
    [super dealloc];
}
@end
