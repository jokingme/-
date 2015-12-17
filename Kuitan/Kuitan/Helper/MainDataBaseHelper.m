//
//  MainDataBaseHelper.m
//  Kuitan
//
//  Created by lanouhn on 15/10/24.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "MainDataBaseHelper.h"
#import <UIKit/UIKit.h>

@interface MainDataBaseHelper ()
@property (nonatomic,retain) NSMutableArray *dataArray;//存放数据
@end

static MainDataBaseHelper *helper = nil;
@implementation MainDataBaseHelper

- (void)dealloc {
    self.dataArray = nil;
    [super dealloc];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

/**
 *  返回分区的行数
 */
+ (NSInteger)numberOfRowAtSection1 {
    return [self sharedMainDataBaseHelper].dataArray.count;
}

/**
 *  返回cell的model对象
 */
+ (DownDetileModel *)modelAtIndexPath1:(NSIndexPath *)indexPath{
    DownDetileModel *model = [self sharedMainDataBaseHelper].dataArray[indexPath.row];
    return model;
}

/**
 *  添加数据
 */
+ (void)addDataModel1:(DownDetileModel *)model {
    [self sharedMainDataBaseHelper];
    //往数据库中添加
    [[self sharedMainDataBaseHelper].dataArray addObject:model];
    [self insertIntoTableInDataBase1:model];
}

/**
 *  删除cell操作
 */
+ (void)deleteModelInSection1:(NSIndexPath *)indexPath {
    //从内存中删除
    DownDetileModel *model = helper.dataArray[indexPath.row];
    [helper.dataArray removeObject:model];
    //从数据库中删除
    [self deleteDataInTableAtDataBase1:[model.dishes_id integerValue]];
}

/**
 *  查询是否已经收藏过
 */
+ (BOOL)selectExistOrNotByKey1:(NSString *)mainKey {
    [self sharedMainDataBaseHelper];
    for (int i = 0; i < helper.dataArray.count; i++) {
        DownDetileModel *model = helper.dataArray[i];
        if ([mainKey isEqualToString:[NSString stringWithFormat:@"%@",model.dishes_id]]) {
            return YES;
            break;
        }
    }
    return NO;
}


+ (void)moveFromIndexPath1:(NSIndexPath *)sourceIndexPath ToIndexPath1:(NSIndexPath *)destinationIndexPath {
    [helper.dataArray removeObjectAtIndex:sourceIndexPath.row];
    DownDetileModel *model = helper.dataArray[sourceIndexPath.row];
    [helper.dataArray insertObject:model atIndex:destinationIndexPath.row];
}

#pragma mark ************** 数据库操作 *************
/**
 *  创建单例
 */
+ (MainDataBaseHelper *)sharedMainDataBaseHelper {
    @synchronized(self) {
        if (helper == nil) {
            helper = [[MainDataBaseHelper alloc] init];
            [self createNewTableInDataBase1];
            [self selectDataInTableAtDataBase1];
        }
    }
    return helper;
}

/**
 *  新建表操作
 */
+ (void)createNewTableInDataBase1 {
    //创建SQL语句
    NSString *createString = @"create table if not exists CaiPuShou (con_dishesId integer primary key autoincrement,con_title text,con_image text)";
    NSString *message = @"创建表语句正确";
    //创建SQL指令集对象
    sqlite3_stmt *stmt = [MainDataBaseHelper allSQLMethod:createString message:message];
    //绑定参数
    //执行SQL语句
    int flag = sqlite3_step(stmt);
    if (flag == SQLITE_DONE) {
        NSLog(@"创建表操作成功");
    }
    //释放资源
    sqlite3_finalize(stmt);
    //关闭数据库
    [DataBaseManager closeMyDataBase];
}

/**
 *  添加数据操作
 */
+ (void)insertIntoTableInDataBase1:(DownDetileModel *)model {
    NSString *addString = @"insert into CaiPuShou (con_dishesId,con_title,con_image) values(?,?,?)";
    NSString *message = @"插入语法正确";
    sqlite3_stmt *stmt = [MainDataBaseHelper allSQLMethod:addString message:message];
    //绑定参数
    //Id
    sqlite3_bind_int(stmt, 1, (int)[model.dishes_id integerValue]);
    //title
    sqlite3_bind_text(stmt, 2, [model.title UTF8String], -1, nil);
    //image
    sqlite3_bind_text(stmt, 3, [model.image UTF8String], -1, nil);
    //执行SQL语句
    int flag = sqlite3_step(stmt);
    if (flag == SQLITE_DONE) {
        NSLog(@"插入操作成功");
    }
    //释放资源
    sqlite3_finalize(stmt);
    //关闭数据库
    [DataBaseManager closeMyDataBase];
}

/**
 *  删除数据操作
 */
+ (void)deleteDataInTableAtDataBase1:(NSInteger)dishes_id {
    NSString *deleteString = @"delete from CaiPuShou where dishesId = ?";
    NSString *message = @"删除语句正确";
    sqlite3_stmt *stmt = [self allSQLMethod:deleteString message:message];
    sqlite3_bind_int(stmt, 1, (int)dishes_id);
    //绑定参数
    //执行SQL语句
    int flag = sqlite3_step(stmt);
    if (flag == SQLITE_DONE) {
        NSLog(@"删除操作成功");
    }
    //释放资源
    sqlite3_finalize(stmt);
    //关闭数据库
    [DataBaseManager closeMyDataBase];
}

/**
 *  查询数据库数据操作
 */
+ (void)selectDataInTableAtDataBase1 {
    NSString *selectString = @"select * from CaiPuShou";
    NSString *message = @"查询语句正确";
    sqlite3_stmt *stmt = [self allSQLMethod:selectString message:message];
    //绑定参数
    //执行SQL语句
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSInteger dishes_id = sqlite3_column_int(stmt, 0);
        char *title = (char *)sqlite3_column_text(stmt, 1);
        char *image = (char *)sqlite3_column_text(stmt, 2);
        DownDetileModel *model = [[DownDetileModel alloc] init];
        model.dishes_id = @(dishes_id);
        model.title = [NSString stringWithUTF8String:title];
        model.image = [NSString stringWithUTF8String:image];
        [[self sharedMainDataBaseHelper].dataArray addObject:model];
    }
    //释放资源
    sqlite3_finalize(stmt);
    //关闭数据库
    [DataBaseManager closeMyDataBase];
}

/**
 *  SQL指令集
 */
+ (sqlite3_stmt *)allSQLMethod:(NSString *)sqlString message:(NSString *)message {
    //1.打开数据库
    sqlite3 *db = [DataBaseManager openMyDataBase];
    //2.SQL语句
    //3.创建指令集对象
    sqlite3_stmt *stmt = nil;
    //4.检查SQL语句是否正确
    int flag = sqlite3_prepare(db, [sqlString UTF8String], -1, &stmt, 0);
    if (flag == SQLITE_OK) {
        NSLog(@"%@",message);
    }
    return stmt;
}



@end
