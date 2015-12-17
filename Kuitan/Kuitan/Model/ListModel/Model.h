//
//  Model.h
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic,copy) NSString *Cate;
@property (nonatomic,copy) NSString *ImgUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
