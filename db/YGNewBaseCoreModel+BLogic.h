//
//  User.h
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/2.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YGNewBaseCoreModel.h"
#import <WCDB/WCDB.h>
typedef std::map<std::string,WCTBinding*> YGMapWCTBinding;
typedef std::map<std::string,WCTPropertyList*> YGMapWCTPropertyList;
typedef std::map<std::string,WCTProperty> YGCoreModelMapTProperty;
typedef std::map<std::string,YGCoreModelMapTProperty*> YGCoreModelMapTPropertyList;
@interface YGNewBaseCoreModel (BLogic)
+(WCTProperty)yg_wctPropertyByName:(NSString*)propertyName;
+(WCTBinding*)yg_wctBinding;
+(YGCoreModelMapTProperty*)yg_coreModelMapTProperty;
+(WCTPropertyList*)yg_wctPropertyList;
+(WCTProperty)getWCTProperty:(NSString*)propertyName attr:(NSString*)attr WCTBinding:(WCTBinding&)yg_wctBinding;
+(NSArray*)selectWhereAction:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList limit:(const WCTLimit &)limit offset:(const WCTOffset &)offset;
+(NSArray*)selectWhereAction:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList limit:(const WCTLimit &)limit;
+(NSArray*)selectWhereAction:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList;
+(NSArray*)selectWhereAction:(const WCTCondition &)condition limit:(const WCTLimit &)limit;
+(NSArray*)selectWhereAction:(const WCTCondition &)condition;
+(NSArray*)selectWhereResultListAction:(const WCTResultList &)resultList condition:(const WCTCondition &)condition;
+(NSArray*)selectWhereResultListAction:(const WCTResultList &)resultList condition:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList groupBy:(const WCTGroupByList &)groupByList;
+(BOOL)updateRowsInTable:(const WCTPropertyList &)propertyList withObject:(YGNewBaseCoreModel *)object where:(const WCTCondition &)condition;
+(BOOL)deleteObjectsFromTable:(const WCTCondition &)condition;
@end








