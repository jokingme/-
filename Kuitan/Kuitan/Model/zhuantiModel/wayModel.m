//
//  wayModel.m
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "wayModel.h"

@implementation wayModel

-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        [self  setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
