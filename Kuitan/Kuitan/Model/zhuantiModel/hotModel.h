//
//  hotModel.h
//  
//
//  Created by lanouhn on 15/10/21.
//
//

#import <Foundation/Foundation.h>

@interface hotModel : NSObject
//@property(nonatomic,copy)NSString *dishes_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *dishes_id;


-(instancetype)initWithDic:(NSDictionary *)dic;

+(instancetype)hotWithDic:(NSDictionary*)dic;
@end
