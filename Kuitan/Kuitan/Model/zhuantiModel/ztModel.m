//
//  ztModel.m
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "ztModel.h"

@implementation ztModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
       self.IDs  = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.text = value;
    }
}

- (void)dealloc {
    self.title = nil;
    self.text = nil;
    self.image = nil;
    self.IDs = nil;
    [super dealloc];
}

@end
