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
@property (nonatomic, strong) WCTDatabase*dataBase;
+ (DBManager *)defaultManager;
+(BOOL)createTable:(Class<WCTTableCoding>)cls;
@end
