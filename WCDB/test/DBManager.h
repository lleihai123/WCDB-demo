//
//  DBManager.h
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/15.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

@interface DBManager : NSObject

@property (nonatomic, strong) WCTDatabase   *dataBase;

+ (DBManager *)defaultManager;

#pragma mark ------------创建数据库
- (WCTDatabase *)createDB;

#pragma mark ------------删除数据库
- (void)deleteDB;

#pragma mark ------------查询数据库
- (void)queryDB;

@end
