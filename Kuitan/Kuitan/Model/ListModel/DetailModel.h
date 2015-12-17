//
//  DetailModel.h
//  Kuitan
//
//  Created by lanouhn on 15/10/16.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Cover;
@property (nonatomic,copy) NSString *Collection;
@property (nonatomic,copy) NSString *Stuff;
@property (nonatomic,assign) NSInteger HasVideo;
@property (nonatomic,retain) NSNumber *RecipeId;
@property (nonatomic,copy) NSString *Duration;
@property (nonatomic,assign) BOOL isDianZan;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
