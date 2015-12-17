//
//  wayModel.h
//  gdfgfgsdfsd
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wayModel : NSObject
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *dashes_name;
@property(nonatomic,copy)NSString *material_desc;

@property (nonatomic , copy) NSString *stepImage;
@property (nonatomic , copy)NSString *stepStr;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
