//
//  User.h
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/2.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YGNewBaseCoreModel : NSObject
@property (nonatomic,retain) NSString* hostID;
@property (nonatomic, strong) NSString* coldMd5Str;//详情是否更新冷表md5
@property (nonatomic, strong) NSString* listColdMd5Str;//列表是否更新冷表md5

-(void)saveSelf;
+(void)save:(YGNewBaseCoreModel*)model resBlock:(void(^)(BOOL res))resBlock;

+(void)queryAllData:(void(^)(NSArray *selectResults))selectResultsBlock;
+(BOOL)truncateTable;
@end







