//
//  DBManager.m
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/15.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//

#import "DBManager.h"

#define DB_Name  @"/Model"

@interface DBManager()

@end


@implementation DBManager

+ (DBManager *)defaultManager
{
    static  DBManager   *manager    = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager     = [[DBManager alloc] init];
    });
    return manager;
}


- (WCTDatabase *)createDB
{
    NSString    *path       = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path        = [path stringByAppendingString:DB_Name];
    _dataBase    = [[WCTDatabase alloc] initWithPath:path];
    return _dataBase;
}

- (WCTDatabase *)dataBase
{
    if (nil == _dataBase) {
        _dataBase   = [self createDB];
    }
    return _dataBase;
}

- (void)deleteDB
{
    NSLog(@"删除数据库");
}


- (void)queryDB
{
    
}
@end
