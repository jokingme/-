//
//  hotModel.m
//  
//
//  Created by lanouhn on 15/10/21.
//
//

#import "hotModel.h"

@implementation hotModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        [self  setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(instancetype)hotWithDic:(NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"])
    {
        self.text = value;
    }

}
@end
