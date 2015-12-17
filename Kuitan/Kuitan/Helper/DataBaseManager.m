//
//  DataBaseManager.m
//  Kuitan
//
//  Created by lanouhn on 15/10/22.
//  Copyright (c) 2015年 S&G. All rights reserved.
//

#import "DataBaseManager.h"

//c创建数据库类对象 SQLite对象指向数据库文件的地址
static sqlite3 *sqlite = nil;
@implementation DataBaseManager
+ (sqlite3 *)openMyDataBase {
    //先判断数据库是否已经打开,数据库对象存在,表明该数据库存在,程序首次运行不会执行下面的判断
    if (sqlite) {
        return sqlite;
    }
    //根据路径创建数据库文件
    NSString *filePath = [self filePathForDataBase];
    //根据路径打开数据库
    if (sqlite3_open([filePath UTF8String], &sqlite) == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }
    return sqlite;
}

+ (void)closeMyDataBase {
    //先判断数据库是否已经打开
    if (sqlite) {
        int flag = sqlite3_close(sqlite);
        //将对象置空
        sqlite = nil;
        if (flag == SQLITE_OK) {
            NSLog(@"数据库关闭成功");
        }
    }
}


#warning 数据库文件路径
//创建数据库文件的方法
+ (NSString *)filePathForDataBase {
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [str stringByAppendingPathComponent:@"CaiPu666.sqlite"];
//    NSString *filePath = @"/Users/lanouhn/Desktop/CaiPu.sqlite";
    NSLog(@"%@",filePath);
    return filePath;
}

@end
