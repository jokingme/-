//
//  ImageModel.h
//  Kuitan
//
//  Created by laouhn on 15/10/18.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *dishes_id;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
+ (instancetype)ImageModelWithDictionary:(NSDictionary *)dic;

@end
