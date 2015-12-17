//
//  Shouye.h
//  Kuitan
//
//  Created by laouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shouye : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *image;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
