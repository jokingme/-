//
//  stepsModel.h
//  Kuitan
//
//  Created by lanouhn on 15/10/19.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface stepsModel : NSObject
@property (nonatomic,copy) NSString *Intro;
@property (nonatomic,copy) NSString *StepPhoto;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
