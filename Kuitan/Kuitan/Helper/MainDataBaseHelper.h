//
//  MainDataBaseHelper.h
//  Kuitan
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManager.h"
#import <sqlite3.h>
#import "DownDetileModel.h"

@interface MainDataBaseHelper : NSObject
/**
 *  返回分区的行数
 */
+ (NSInteger)numberOfRowAtSection1;

/**
 *  返回cell的model对象
 */
+ (DownDetileModel *)modelAtIndexPath1:(NSIndexPath *)indexPath;

/**
 *  添加数据
 */
+ (void)addDataModel1:(DownDetileModel *)model;

/**
 *  删除cell操作
 */
+ (void)deleteModelInSection1:(NSIndexPath *)indexPath;

/**
 *  查询是否已经收藏过
 */
+ (BOOL)selectExistOrNotByKey1:(NSString *)mainKey;


+ (void)moveFromIndexPath1:(NSIndexPath *)sourceIndexPath ToIndexPath1:(NSIndexPath *)destinationIndexPath;

#pragma mark ************** 数据库操作 *************
/**
 *  创建单例
 */
+ (MainDataBaseHelper *)sharedMainDataBaseHelper;

/**
 *  新建表操作
 */
+ (void)createNewTableInDataBase1;

/**
 *  添加数据操作
 */
+ (void)insertIntoTableInDataBase1:(DownDetileModel *)model;

/**
 *  删除数据操作
 */
+ (void)deleteDataInTableAtDataBase1:(NSInteger)dishes_id;

/**
 *  查询数据库数据操作
 */
+ (void)selectDataInTableAtDataBase1;

/**
 *  SQL指令集
 */
+ (sqlite3_stmt *)allSQLMethod:(NSString *)sqlString message:(NSString *)message;


@end
