//
//  User.m
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/2.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//
#import <WCDB/WCDB.h>
#import "DBManager.h"
#import "YGNewBaseCoreModel+BLogic.h"
#import "CoreStatusDefine.h"
static YGCoreModelMapTPropertyList*YG_CoreModel_MapTPropertyList = new YGCoreModelMapTPropertyList();
static YGMapWCTBinding*YG_Map_WCTBinding = new YGMapWCTBinding();
static YGMapWCTPropertyList*YG_Map_WCTPropertyList = new YGMapWCTPropertyList();
@implementation YGNewBaseCoreModel (BLogic)

#pragma mark 自定义WCD绑定数据库
/****************自定义WCD绑定数据库*****************/
#define YGWCTPropertyType(propertyType,propertyName)\
WCTProperty([propertyName UTF8String],self.yg_class,yg_wctBinding.addColumnBinding<propertyType>([propertyName UTF8String],[propertyName UTF8String]))
+(WCTBinding*)yg_wctBinding{
    Class cls = self.yg_class;
    std::map<std::string, WCTBinding*>::iterator it = YG_Map_WCTBinding->find(NSStringFromClass(cls).UTF8String);
    if(it != YG_Map_WCTBinding->end()){
        return it->second;
    }else{
        WCTBinding * yg_wctBinding = new WCTBinding(cls);
        YG_Map_WCTBinding->insert(std::make_pair(NSStringFromClass(cls).UTF8String,yg_wctBinding));
        return yg_wctBinding;
    }
}
+(WCTPropertyList*)yg_wctPropertyList{
    Class cls = self.yg_class;
    std::map<std::string, WCTPropertyList*>::iterator it = YG_Map_WCTPropertyList->find(NSStringFromClass(cls).UTF8String);
    if(it != YG_Map_WCTPropertyList->end()){
        return it->second;
    }else{
        WCTPropertyList * yg_wctPropertyList = new WCTPropertyList();
        YG_Map_WCTPropertyList->insert(std::make_pair(NSStringFromClass(cls).UTF8String,yg_wctPropertyList));
        return yg_wctPropertyList;
    }
}

+(YGCoreModelMapTProperty*)yg_coreModelMapTProperty{
    Class cls = self.yg_class;
    std::map<std::string, YGCoreModelMapTProperty*>::iterator it = YG_CoreModel_MapTPropertyList->find(NSStringFromClass(cls).UTF8String);
    if(it != YG_CoreModel_MapTPropertyList->end()){
        return it->second;
    }else{
        YGCoreModelMapTProperty * yg_coreModelMapTProperty = new YGCoreModelMapTProperty();
        YG_CoreModel_MapTPropertyList->insert(std::make_pair(NSStringFromClass(cls).UTF8String,yg_coreModelMapTProperty));
        return yg_coreModelMapTProperty;
    }
}

+(WCTProperty)yg_wctPropertyByName:(NSString*)propertyName{
    YGCoreModelMapTProperty * yg_coreModelMapTProperty = [self yg_coreModelMapTProperty];
    std::map<std::string, WCTProperty>::iterator it = yg_coreModelMapTProperty->find(propertyName.UTF8String);
    if(it != yg_coreModelMapTProperty->end()){
        return it->second;
    }
    NSLog(@"error yg_wctPropertyByName:%@",propertyName);
    return [self getWCTProperty:propertyName attr:@"T@\"NSString" WCTBinding:*[self yg_wctBinding]];
}


+(WCTProperty)getWCTProperty:(NSString*)propertyName attr:(NSString*)attr WCTBinding:(WCTBinding&)yg_wctBinding{
    if ([attr hasPrefix:@"T@"]){
//        NSLog(@"class:%@",NSStringFromClass(self));
        return WCTProperty([propertyName UTF8String],[self yg_class],yg_wctBinding.addColumnBinding<decltype([[self.yg_class new] valueForKey:propertyName])>([propertyName UTF8String],[propertyName UTF8String]));
    }
    NSUInteger dotLoc = [attr rangeOfString:@","].location;
    NSString *code = nil;
    NSUInteger loc = 1;
    if (dotLoc == NSNotFound) { // 没有,
        code = [attr substringFromIndex:loc];
    } else {
        code = [attr substringWithRange:NSMakeRange(loc, dotLoc - loc)];
    }
    if ([CoreNSUInteger rangeOfString:code].location != NSNotFound) {
        return YGWCTPropertyType(NSUInteger,propertyName);
    } else if ([CoreNSInteger rangeOfString:code].location != NSNotFound) {
        return YGWCTPropertyType(NSInteger,propertyName);
    }else if([BLOB_TYPE rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(BOOL,propertyName);
    }else if([CoreCGFloat rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(float,propertyName);
    }else if([Coredouble rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(double,propertyName);
    }else if([Corelong rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(long,propertyName);
    }else if([Coreshort rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(short,propertyName);
    }else if([CoreUNShort rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(unsigned short,propertyName);
    }else if([Corechar rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(char,propertyName);
    }else if([CoreUNchar rangeOfString:code].location != NSNotFound){
        return YGWCTPropertyType(unsigned char,propertyName);
    }
    NSLog(@"code:%@  propertyName:%@",code,propertyName);
    return WCTProperty([propertyName UTF8String],[self yg_class],yg_wctBinding.addColumnBinding<decltype([[self.yg_class new] valueForKey:propertyName])>([propertyName UTF8String],[propertyName UTF8String]));
}


+(NSArray*)selectWhereAction:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList limit:(const WCTLimit &)limit{
    NSArray *array = [[DBManager defaultManager].dataBase  getObjectsOfClass:self.yg_class fromTable:[NSString stringWithFormat:@"%@",self.yg_class] where:condition orderBy:orderList limit:limit];
    return array?:@[];
}


+(NSArray*)selectWhereAction:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList limit:(const WCTLimit &)limit offset:(const WCTOffset &)offset{
    NSArray *array = [[DBManager defaultManager].dataBase  getObjectsOfClass:self.yg_class fromTable:[NSString stringWithFormat:@"%@",self.yg_class] where:condition orderBy:orderList limit:limit offset:offset];
    return array?:@[];
}


+(NSArray*)selectWhereAction:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList{
    NSArray *array = [[DBManager defaultManager].dataBase  getObjectsOfClass:self.yg_class fromTable:[NSString stringWithFormat:@"%@",self.yg_class] where:condition orderBy:orderList];
    return array?:@[];
}

+(NSArray*)selectWhereAction:(const WCTCondition &)condition limit:(const WCTLimit &)limit{
    NSArray *array = [[DBManager defaultManager].dataBase  getObjectsOfClass:self.yg_class fromTable:[NSString stringWithFormat:@"%@",self.yg_class] where:condition limit:limit];
    return array?:@[];
}

+(NSArray*)selectWhereAction:(const WCTCondition &)condition{
    NSArray *array = [[DBManager defaultManager].dataBase  getObjectsOfClass:self.yg_class fromTable:[NSString stringWithFormat:@"%@",self.yg_class] where:condition];
    return array?:@[];
}


+(NSArray*)selectWhereResultListAction:(const WCTResultList &)resultList condition:(const WCTCondition &)condition{
    NSArray *array = [[DBManager defaultManager].dataBase  getObjectsOnResults:resultList fromTable:[NSString stringWithFormat:@"%@",self.yg_class] where:condition];
    return array?:@[];
}


+(NSArray*)selectWhereResultListAction:(const WCTResultList &)resultList condition:(const WCTCondition &)condition orderBy:(const WCTOrderByList &)orderList groupBy:(const WCTGroupByList &)groupByList{
    WCTSelect *select = [[[[[DBManager defaultManager].dataBase prepareSelectObjectsOnResults:resultList fromTable:[NSString stringWithFormat:@"%@",self.yg_class]]
                           where:condition]
                          groupBy:{groupByList}]
                         orderBy:orderList];
    return select.allObjects?:@[];
}


+(BOOL)updateRowsInTable:(const WCTPropertyList &)propertyList withObject:(YGNewBaseCoreModel*)object where:(const WCTCondition &)condition{
    return [[DBManager defaultManager].dataBase updateRowsInTable:[NSString stringWithFormat:@"%@",self.yg_class] onProperties:propertyList withObject:(WCTObject *)object where:condition];
}
+(BOOL)deleteObjectsFromTable:(const WCTCondition &)condition{
    return [[DBManager defaultManager].dataBase deleteObjectsFromTable:[NSString stringWithFormat:@"%@",self.yg_class] where:condition];
}
@end

