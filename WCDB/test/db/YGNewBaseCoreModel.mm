//
//  User.m
//  WCDB
//
//  Created by 每日瑜伽雷海 on 2018/1/2.
//  Copyright © 2018年 每日瑜伽雷海. All rights reserved.
//
#import <WCDB/WCDB.h>
#import "YGNewBaseCoreModel.h"
#import "CoreStatusDefine.h"
#import "DBManager.h"
#import "TableManager.h"
typedef std::map<std::string,WCTBinding*> YGMapWCTBinding;
typedef std::map<std::string,WCTPropertyList*> YGMapWCTPropertyList;
static YGMapWCTBinding*YG_Map_WCTBinding = new YGMapWCTBinding();
static YGMapWCTPropertyList*YG_Map_WCTPropertyList = new YGMapWCTPropertyList();
@interface YGNewBaseCoreModel()<WCTTableCoding>

@end

@implementation YGNewBaseCoreModel
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

+(void)initialize{
    NSString *modelName = [self modelName];
    if([modelName isEqualToString:@"YGNewBaseCoreModel"]) {
        return;
    }
    WCTBinding * yg_wctBinding = [self yg_wctBinding];
    WCTPropertyList * yg_wctPropertyList = [self yg_wctPropertyList];
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.yg_class, &outCount);
    // 2.遍历每一个成员变量
    for (unsigned int i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        // 1.属性名
        NSString *name = @(property_getName(property));
        NSString *attrs = @(property_getAttributes(property));
        NSLog(@"name:%@ ",name);
        WCTProperty s_property = [self getWCTProperty:name attr:attrs WCTBinding:*yg_wctBinding];
        yg_wctPropertyList->push_back(s_property);
        if([self.yg_class IsMakePrimary:name]){
            yg_wctBinding->getColumnBinding(s_property)->makePrimary(WCTOrderedAscending, YES, WCTConflictNotSet);
        }else if ([self.yg_class IsmakeUnique:name]){
            yg_wctBinding->getColumnBinding(s_property)->makeUnique();
        }
    }
    //绑定hostID
    WCTProperty s_property = [self getWCTProperty:@"hostID" attr:@"T@\"NSString" WCTBinding:*yg_wctBinding];
    yg_wctPropertyList->push_back(s_property);
    yg_wctBinding->getColumnBinding(s_property)->makeUnique();
    s_property = s_property = [self getWCTProperty:@"coldMd5Str" attr:@"T@\"NSString" WCTBinding:*yg_wctBinding];
    yg_wctPropertyList->push_back(s_property);
    s_property = s_property = [self getWCTProperty:@"listColdMd5Str" attr:@"T@\"NSString" WCTBinding:*yg_wctBinding];
    yg_wctPropertyList->push_back(s_property);
    
    [self createTable];
}
-(BOOL)isAutoIncrement{
    return YES;
}
+(WCTProperty)getWCTProperty:(NSString*)propertyName attr:(NSString*)attr WCTBinding:(WCTBinding&)yg_wctBinding{
    if ([attr hasPrefix:@"T@"]){
        NSLog(@"class:%@",NSStringFromClass(self));
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
    }
    NSLog(@"code:%@  propertyName:%@",code,propertyName);
    return WCTProperty([propertyName UTF8String],[self yg_class],yg_wctBinding.addColumnBinding<decltype([[self.yg_class new] valueForKey:propertyName])>([propertyName UTF8String],[propertyName UTF8String]));
}
+(const WCTBinding *) objectRelationalMappingForWCDB{
    return [self yg_wctBinding];
}

+(const WCTPropertyList &) AllProperties{
    WCTPropertyList * yg_wctPropertyList = [self yg_wctPropertyList];
    return *yg_wctPropertyList;
}
+(const WCTAnyProperty &) AnyProperty{
    static const WCTAnyProperty s_anyProperty(self.class);
    return s_anyProperty;
}
+(WCTPropertyNamed) PropertyNamed { return WCTProperty::PropertyNamed; }
+(BOOL)IsMakePrimary:(NSString*)propertyName{
    NSDictionary*dict = @{};
    if(propertyName && [dict objectForKey:propertyName]){
        return YES;
    }
    return NO;
}

+(BOOL)IsmakeUnique:(NSString*)propertyName{
    NSDictionary*dict = @{};
    if(propertyName && [dict objectForKey:propertyName]){
        return YES;
    }
    return NO;
}

+(NSString *)modelName{
    return [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
}

+(Class)yg_class{
    NSString*className = [self modelName];
    if(className){
        return NSClassFromString(className);
    }
    return self.class;
}
#pragma mark 数据库接口
/****************数据库操作*****************/
#pragma mark 创建表
+(void)createTable{
    [[TableManager defalutManager] createTable:[self modelName] path:@"" cls:self.yg_class];
}
#pragma mark 保存
-(void)saveSelf{
    [[self class] save:self resBlock:nil];
}
+(void)save:(YGNewBaseCoreModel*)model resBlock:(void(^)(BOOL res))resBlock{
    BOOL res = [[DBManager defaultManager].dataBase insertOrReplaceObject:model into:[self modelName]];
    if(!res){
        NSLog(@"%@:插入失败",[self modelName]);
    }
    if(resBlock){
        resBlock(res);
    }

}
#pragma mark 全表查询
+(void)queryAllData:(void(^)(NSArray *selectResults))selectResultsBlock{
    NSArray *msgArr =  [[DBManager defaultManager].dataBase getAllObjectsOfClass:self.yg_class fromTable:[self modelName]]?:@[];
    if(selectResultsBlock){
        selectResultsBlock(msgArr);
    }
}
#pragma mark 清空数据
+(BOOL)truncateTable{
    BOOL res = [[DBManager defaultManager].dataBase deleteAllObjectsFromTable:[self modelName]];
    if (!res) {
        NSLog(@"%@:truncate失败",[self modelName]);
    }
    return res;
}



/**
 注入kvo并绑定通知

 @param hostID
 */
-(void)setHostID:(NSString *)hostID{
    _hostID = hostID;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wshadow-ivar"
//    if(hostID && self.hostID && [self.hostID isEqualToString:hostID]){
//        return;
//    }
//    if(self.hostID){
//        self.yg_removeNotification([NSString stringWithFormat:@"%@_%@",[self class],self.hostID]);
//    }
//    self->hostID = hostID;
//#pragma clang diagnostic pop
//    @weakify(self);
//    if(self.hostID){
//        self.yg_notification([NSString stringWithFormat:@"%@_%@",[self class],self.hostID],^(NSNotification *notification){
//            @strongify(self);
//            if(self){
//                if(notification.object && [notification.object respondsToSelector:@selector(isEqualToString:)] && [notification.object isEqualToString:self.yg_NSObjectId]){
//
//                }else{
//                    [self updateSelf];
//                }
//                [GCDQueue executeInMainQueue:^{
//                    if(self.updateBindBlock){
//                        self.updateBindBlock(self);
//                    }
//                }];
//            }
//        });
//    }

}
@end


