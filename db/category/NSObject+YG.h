//
//  NSObject+YG.h
//  DailyYoga
//
//  Created by yg on 2017/6/20.
//  Copyright © 2017年 yg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMemoryCache.h"
#import "ReactiveCocoa.h"
#pragma mark --基本方法扩展
#define YG_Valist(...)  yg_valist(metamacro_argcount(__VA_ARGS__),__VA_ARGS__)
NSMutableArray* yg_valist(NSUInteger count, NSString* value,...);
#define NullReturn(property) if (!property || [property isKindOfClass:[NSNull class]]) {NSLog(@"不能输入nill");return self;}
typedef  NSObject* (^NSObjectVoidBlock)(void);
typedef  void (^ClickBlock)(id value);
typedef  void (^SelfClickBlock)(id selfValue,id value);
typedef  void (^ClickIndexBlock)(id value,NSInteger index);
typedef  void (^KVOBlock)(id value);
typedef  NSObject * (^PropertyKVOBlock)(NSString*property,KVOBlock blcok);
typedef  NSObject * (^NSNotificationBlock)(NSString*property,KVOBlock blcok);
typedef  NSObject * (^NSNotificationObjectBlock)(NSString*property,id object,KVOBlock blcok);
typedef  NSObject * (^RemoveNSNotificationBlock)(NSString*name);
typedef  NSObject * (^PostNSNotificationBlock)(NSString*name,id value);
typedef  void (^UIViewAnimationBlock)(UIView* value);
typedef  NSObject * (^PropertyBlock)(NSString*propertyList,id value);
typedef  void (^ReturnBlock)(id value);
typedef  NSObject* (^SetWeakObjBlock)(NSString* key,id value);
typedef  id (^GetWeakObjBlock)(NSString* key);
typedef  void (^RACTupleBlock)(RACTuple *tuple);
typedef  NSObject* (^SignalForSelectorBlock)(SEL selector,RACTupleBlock value);
@interface NSObject (YG)
@property (nonatomic,readonly) PropertyBlock yg_propertyById;
@property (nonatomic,readonly) PropertyKVOBlock yg_kvo;
@property (nonatomic,readonly) NSNotificationObjectBlock yg_notificationObject;
@property (nonatomic,readonly) NSNotificationBlock yg_notification;
@property (nonatomic,readonly) RemoveNSNotificationBlock yg_removeNotification;
@property (nonatomic,readonly) PostNSNotificationBlock yg_postNotification;
@property (nonatomic,readonly) SignalForSelectorBlock yg_signalForSelector;
@property (nonatomic,readonly) SetWeakObjBlock yg_weakSet;
@property (nonatomic,readonly) SetWeakObjBlock yg_strongSet;
@property (nonatomic,readonly) GetWeakObjBlock yg_get;
@property (atomic,readonly) NSMutableDictionary* yg_Mudict;
@property (atomic,readonly) YYMemoryCache* yg_MemoryCache;
@property (nonatomic,readonly) NSCache* yg_Cache;
@property (nonatomic,readonly) NSString* yg_NSObjectId;
-(void)resetYGMudict;
-(void)resetYGCache;
+ (instancetype)return:(ReturnBlock)block;
+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;
@end
