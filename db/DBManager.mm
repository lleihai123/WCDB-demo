//
//  DBManager.m
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/15.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//

#import "DBManager.h"
#import "NSDictionary+YG.h"
@interface DBManager()

@end


@implementation DBManager

+ (DBManager *)defaultManager{
    static  DBManager   *manager    = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager     = [[DBManager alloc] init];
    });
    return manager;
}


+(BOOL)createTable:(Class<WCTTableCoding>)cls{
    BOOL res = YES;
    WCTDatabase *db    =  [DBManager defaultManager].dataBase;
    /// 数据库是否可以打开
    if ([db canOpen]) {
        /// 数据库是否已经打开
        if ([db isOpened]) {
            res = [db createTableAndIndexesOfName:NSStringFromClass(cls) withClass:cls];
        }
    }
    return res;
}
- (WCTDatabase *)createDB{
    //获取项目info文件
    NSDictionary *infoDict=[[NSBundle mainBundle] infoDictionary];
    //获取项目Bundle Name:英文(CFBundleName)
    NSString *key=(NSString *)kCFBundleNameKey;
    
    NSString *bundleName = [infoDict strValue:key default:@"DailyYoga"];
    //在沙盒中存入数据库文件
    NSString *documentFolder=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath=[NSString stringWithFormat:@"%@/%@",documentFolder,bundleName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dbPath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ){
        [fileManager createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dbPath        = [dbPath stringByAppendingString:@"/YGDB"];
    _dataBase    = [[WCTDatabase alloc] initWithPath:dbPath];
//    // 数据库加密
//    NSData *password = [@"f9y89q&*^asdMM,p" dataUsingEncoding:NSASCIIStringEncoding];
//    [_dataBase setCipherKey:password];
    return _dataBase;
}

- (WCTDatabase *)dataBase{
    if (!_dataBase) {
        _dataBase   = [self createDB];
    }
    return _dataBase;
}

@end
