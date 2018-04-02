//
//  User.h
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/2.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//
typedef  void (^YGNewBaseCoreModelUpdateViewBlock)(id value);
#import <Foundation/Foundation.h>
@interface YGNewBaseCoreModel : NSObject
@property(nonatomic,strong)YGNewBaseCoreModelUpdateViewBlock updateBindBlock;
@property (nonatomic,retain) NSString* hostID;
@property (nonatomic, strong) NSString* coldMd5Str;//详情是否更新冷表md5
@property (nonatomic, strong) NSString* listColdMd5Str;//列表是否更新冷表md5

+(Class)yg_class;
+(void)save:(YGNewBaseCoreModel*)model resBlock:(void(^)(BOOL res))resBlock;
+(void)queryAllData:(void(^)(NSArray *selectResults))selectResultsBlock;
+(BOOL)truncateTable;
- (id)copyWithZone:(NSZone *)zone;
- (id)updateByDict:(NSDictionary *)dict;
-(BOOL)isSaveDataBase;
-(BOOL)isNoCopyProperty:(NSString*)name;
-(void)refreshOtherModel;
-(YGNewBaseCoreModel*)saveSelf;
-(YGNewBaseCoreModel*)saveActionSelf;
-(YGNewBaseCoreModel*)updateSelf;
-(YGNewBaseCoreModel*)deleteSelf;
+(NSObject*)sharedManager;
+(instancetype)getModel:(NSString*)hostID;
+(instancetype)getByHostID:(NSString*)hostID;
+(void)setModel:(YGNewBaseCoreModel*)model;
+(BOOL)isNeedUpdateColdTable:(NSString*)hostID listColdMd5Str:(NSString*)listColdMd5Str;
+(BOOL)deleteObjectByHostID:(NSString*)hostID;

- (void)bindHostID;
@end







