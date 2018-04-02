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
#import "YGNewBaseCoreModel+BLogic.h"
#import "NSDictionary+YG.h"
#import "NSString+YG.h"
#import "NSObject+YG.h"
#import "NSObject+MJProperty.h"
#import "MJProperty.h"
#import "MJFoundation.h"
#import "MJExtensionConst.h"
@interface YGNewBaseCoreModel()<WCTTableCoding>

@end

@implementation YGNewBaseCoreModel
+(void)initialize{
    NSString *modelName = [self modelName];
    if([modelName isEqualToString:@"YGNewBaseCoreModel"]) {return;}
    WCTBinding * yg_wctBinding = [self yg_wctBinding];
    WCTPropertyList * yg_wctPropertyList = [self yg_wctPropertyList];
    YGCoreModelMapTProperty * yg_coreModelMapTProperty = [self yg_coreModelMapTProperty];
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.yg_class, &outCount);
    // 2.遍历每一个成员变量
    for (unsigned int i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        // 1.属性名
        NSString *name = @(property_getName(property));
        NSString *attrs = @(property_getAttributes(property));
//        NSLog(@"name:%@ ",name);
        if(![attrs myContainsString:@"T@?,"]){
            WCTProperty s_property = [self getWCTProperty:name attr:attrs WCTBinding:*yg_wctBinding];
            yg_coreModelMapTProperty->insert(std::make_pair(name.UTF8String,s_property));
            yg_wctPropertyList->push_back(s_property);
            if([self.yg_class IsMakePrimary:name]){
                yg_wctBinding->getColumnBinding(s_property)->makePrimary(WCTOrderedAscending, YES, WCTConflictNotSet);
            }else if ([self.yg_class IsmakeUnique:name]){
                yg_wctBinding->getColumnBinding(s_property)->makeUnique();
            }
        }else{
            NSLog(@"请注意忽略的绑定参数: class:%@ (name:%@,attrs:%@)",self,name,attrs);
        }
        
    }
    //绑定hostID
    WCTProperty s_property = [self getWCTProperty:@"hostID" attr:@"T@\"NSString" WCTBinding:*yg_wctBinding];
    yg_coreModelMapTProperty->insert(std::make_pair(@"hostID".UTF8String,s_property));
    yg_wctPropertyList->push_back(s_property);
    yg_wctBinding->getColumnBinding(s_property)->makeUnique();
    s_property = s_property = [self getWCTProperty:@"coldMd5Str" attr:@"T@\"NSString" WCTBinding:*yg_wctBinding];
    yg_coreModelMapTProperty->insert(std::make_pair(@"coldMd5Str".UTF8String,s_property));
    yg_wctPropertyList->push_back(s_property);
    s_property = s_property = [self getWCTProperty:@"listColdMd5Str" attr:@"T@\"NSString" WCTBinding:*yg_wctBinding];
    yg_coreModelMapTProperty->insert(std::make_pair(@"listColdMd5Str".UTF8String,s_property));
    yg_wctPropertyList->push_back(s_property);
    [self createTable];
}
-(BOOL)isAutoIncrement{
    return YES;
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

/**
 是否保存数据库
 
 @return 保存数据库 YES  否则返回NO
 */
-(BOOL)isSaveDataBase{
    return YES;
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
    [DBManager createTable:self.yg_class];
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



+ (NSObject*)sharedManager{
    static NSObject *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [NSObject new];
    });
    @synchronized(_sharedManager) {
        NSString*key = [NSString stringWithFormat:@"%@",[self class]];
        NSMutableDictionary*yg_Mudict = _sharedManager.yg_Mudict?:[NSMutableDictionary new];
        NSObject*value = [yg_Mudict objectForKey:key];
        if(!value){
            value = [NSObject new];
            [yg_Mudict setObject:value forKey:key];
        }
        return value;
    }
}
/**
 动态读取属性 并赋值  无需子类实现
 
 @return self
 */
- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        if(!property || [self isNoCopyProperty:property.name] || [property.type.code isEqualToString:@"@?"]){
            return ;
        }
        id value =[self valueForKeyPath:property.name];
        if(value){
            @try{
                value = [value copy];
            }@catch(NSException* e) {
                NSLog(@"copy_error:%@",value);
            }
            [one setValue:value forKey:property.name];
        }
    }];
    return one;
}

/**
 通过dict生成model
 
 @param  dict 字典
 @return model
 */
- (id)updateByDict:(NSDictionary *)dict{
    return self;
}
/**
 无需copy的属性
 
 @param name 属性
 @return 无需copy的属性返回YES  否则返回NO
 */
-(BOOL)isNoCopyProperty:(NSString*)name{
    NSDictionary*dict = @{@"updateBindBlock":@"1",@"isAutoIncrement":@"1",@"lastInsertedRowID":@"1"};
    return [dict intValue:name];
}
/**
 刷新关联model的view
 */
-(void)refreshOtherModel{
    if(self.hostID.length){
        self.yg_postNotification([NSString stringWithFormat:@"%@_%@",[self class],self.hostID],self.yg_NSObjectId);
    }
}

#pragma mark 保存
-(YGNewBaseCoreModel*)saveSelf{
    if([self isSaveDataBase]){
        [[self class] save:self resBlock:nil];
    }else{
        [[self class] setModel:self];//数据库保存的数据临时缓存
    }
    return self;
}
-(YGNewBaseCoreModel*)saveActionSelf{
    [[self class] save:self resBlock:nil];
    return self;
}

/**
 动态读取属性 并赋值  无需子类实现
 
 @return self
 */
-(YGNewBaseCoreModel*)updateSelf{
    __block id result = [self.class getModel:self.hostID];//可以用缓存
    if(!result && [self isSaveDataBase]){
        result = [self.class getByHostID:self.hostID];
    }
    if(result){
        [self.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
            if(![self isNoCopyProperty:property.name]){
                id value =[result valueForKeyPath:property.name];
                if(property && ![property.type.code isEqualToString:@"@?"]){
                    @try{
                        [self setValue:value forKey:property.name];
                    }@catch(NSException* e) {
                        NSLog(@"Error:数据库赋值出错(%@)",e);
                    }
                }
            }
        }];
        
    }
    return self;
}

/**
 删除自己从数据库
 
 @return self
 */
-(YGNewBaseCoreModel*)deleteSelf{
    if(self.hostID.length && [self isSaveDataBase]){
        WCTProperty hostID_property = [[self class] yg_wctPropertyByName:@"hostID"];
        [[self class] deleteObjectsFromTable:hostID_property == self.hostID];
    }
    return self;
}


/**
 返回缓存的model
 
 @param hostID hostID
 @return model
 */
+(instancetype)getModel:(NSString*)hostID{
    return [self sharedManager].yg_get([NSString stringWithFormat:@"%@_%@",[self class],hostID]);;
}


+(instancetype)getByHostID:(NSString*)hostID{
    WCTProperty hostID_property = [self yg_wctPropertyByName:@"hostID"];
    NSArray *array = [self selectWhereAction:hostID_property == hostID limit:1];
    return array.firstObject;
}

/**
 strong方式缓存model
 
 @param model model
 */
+(void)setModel:(YGNewBaseCoreModel*)model{
    if(model){
        @try{
            [self sharedManager].yg_strongSet([NSString stringWithFormat:@"%@_%@",[model class],model.hostID],model);
        }@catch(NSException* exception) {
//            [YGReportError reportErrorInfo:exception.description errorType:YGErrorReportSaveDBError];
        }
    }
}
/**
 注入kvo并绑定通知
 
 @param hostID
 */
-(void)setHostID:(NSString *)hostID{
    if(hostID && _hostID && [_hostID isEqualToString:hostID]){
        return;
    }
    if(self.hostID){
        self.yg_removeNotification([NSString stringWithFormat:@"%@_%@",[self class],_hostID]);
    }
    _hostID = hostID;
    @weakify(self);
    if(_hostID){
        self.yg_notification([NSString stringWithFormat:@"%@_%@",[self class],_hostID],^(NSNotification *notification){
            @strongify(self);
            if(self){
                if(notification.object && [notification.object respondsToSelector:@selector(isEqualToString:)] && [notification.object isEqualToString:self.yg_NSObjectId]){
                    
                }else{
                    [self updateSelf];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.updateBindBlock){
                        self.updateBindBlock(self);
                    }
                });
            }
        });
    }
    
}
+(BOOL)isNeedUpdateColdTable:(NSString*)hostID listColdMd5Str:(NSString*)listColdMd5Str{
    if(!listColdMd5Str.length){
        return YES;
    }else{
        WCTProperty hostID_property = [self yg_wctPropertyByName:@"hostID"];
        WCTProperty listColdMd5Str_property = [self yg_wctPropertyByName:@"listColdMd5Str"];
        WCTProperty coldMd5Str_property = [self yg_wctPropertyByName:@"coldMd5Str"];
        NSArray *array = [self selectWhereAction:hostID_property == hostID && (listColdMd5Str_property == listColdMd5Str || coldMd5Str_property == listColdMd5Str) limit:1];
        return !array.count;
    }
}

+(BOOL)deleteObjectByHostID:(NSString*)hostID{
    WCTProperty hostID_property = [self yg_wctPropertyByName:@"hostID"];
    return [self deleteObjectsFromTable:hostID_property == hostID];
}

- (void)bindHostID {
    
    
}

-(void)dealloc{
//    NSLog(@"dealloc %@",[self class]);
}
@end


