//
//  DataBaseHelper.h
//  Kuitan
//
//  Created by lanouhn on 15/10/22.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManager.h"
#import <sqlite3.h>
#import "DetailModel.h"

@interface DataBaseHelper : NSObject
/**
 *  返回分区的行数
 */
+ (NSInteger)numberOfRowAtSection;

/**
 *  返回cell的model对象
 */
+ (DetailModel *)modelAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  添加数据
 */
+ (void)addDataModel:(DetailModel *)model;

/**
 *  删除cell操作
 */
+ (void)deleteModelInSection:(NSIndexPath *)indexPath;

/**
 *  查询是否已经收藏过
 */
+ (BOOL)selectExistOrNotByKey:(NSString *)mainKey;


+ (void)moveFromIndexPath:(NSIndexPath *)sourceIndexPath ToIndexPath:(NSIndexPath *)destinationIndexPath;




#pragma mark ************** 数据库操作 *************
/**
 *  创建单例
 */
+ (DataBaseHelper *)sharedDataBaseHelper;

/**
 *  新建表操作
 */
+ (void)createNewTableInDataBase;

/**
 *  添加数据操作
 */
+ (void)insertIntoTableInDataBase:(DetailModel *)model;

/**
 *  删除数据操作
 */
+ (void)deleteDataInTableAtDataBase:(NSInteger)RecipeId;

/**
 *  查询数据库数据操作
 */
+ (void)selectDataInTableAtDataBase;

/**
 *  SQL指令集
 */
+ (sqlite3_stmt *)allSQLMethod:(NSString *)sqlString message:(NSString *)message;

@end
