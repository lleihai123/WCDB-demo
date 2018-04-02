//
//  NSObject+YG.m
//  DailyYoga
//
//  Created by lh on 2017/6/20.
//  Copyright © 2017年 lh. All rights reserved.
//
#import "NSObject+YG.h"
#import <objc/runtime.h>
#define YG_Week_Number -9999999
static dispatch_queue_t yg_backgroundQueue(void){
    static dispatch_once_t onceToken;
    static dispatch_queue_t backgroundQueue = nil;
    dispatch_once(&onceToken, ^{
        backgroundQueue = dispatch_queue_create("YG_Mudict_Queue", DISPATCH_QUEUE_SERIAL);
    });
    return backgroundQueue;
}


NSMutableArray* yg_valist(NSUInteger count, NSString* value,...){
    NSMutableArray*array = [NSMutableArray array];
    va_list params;
    va_start(params, value);
    NSString*valueeee = [[NSString alloc] initWithFormat:@"%@" arguments:params];
    NSLog(@"%@",valueeee);
    [array addObject:value];
    NSString *temp = nil;
    while (--count) {
        @try{
            temp = va_arg(params, NSString*);
        }@catch(NSException* e) {
            NSLog(@"Error:动态读取属性错误");
            break;
        }
        if (temp ==nil) {
            break;
        }else{
            [array addObject:temp];
        }
    }
    NSLog(@"%@",array);
    return array;
}

@implementation NSObject (YG)
@dynamic yg_Mudict;
@dynamic yg_MemoryCache;
@dynamic yg_propertyById;
@dynamic yg_kvo;
@dynamic yg_notification;
@dynamic yg_removeNotification;
@dynamic yg_postNotification;
@dynamic yg_weakSet;
@dynamic yg_get;
@dynamic yg_NSObjectId;
const static void *yg_Mudict_Key = &yg_Mudict_Key;
const static void *yg_Cache_Key = &yg_Cache_Key;

-(PropertyBlock)yg_propertyById{
    @weakify(self);
    PropertyBlock tmppropertyById = ^(NSString*propertyList,id value){
        @strongify(self);
        NullReturn(propertyList)
        NSArray *aArray = [propertyList componentsSeparatedByString:@"."];
        __block id tmpValue = self;
        NSInteger count = aArray.count -1;
        for (NSInteger i = 0; i < count; i++) {
            @try{
                tmpValue = [tmpValue valueForKey:aArray[i]];
            }@catch(NSException* e) {
                NSLog(@"Error:传入的(%@)属性没有读取到",aArray[i]);
                return self;
            }
            
            if(!tmpValue || ![tmpValue isKindOfClass:[NSObject class]]){
                NSLog(@"Error:传入的(%@)属性没有读取到",aArray[i]);
                return self;
            }
        }
        if(value){
            @try{
                [tmpValue setValue:value forKey:aArray[count]];
            }@catch(NSException* e) {
                NSLog(@"Error:修改(%@)属性错误",aArray[count]);
            }
        }else{
            NSLog(@"warning:传入的value的类型和要修改的属性的类型一样");
        }
        
        return self;
    };
    return tmppropertyById;
}

+ (instancetype)return:(ReturnBlock)block {
    if(block){
        id value = self.new;
        block(value);
        return value;
    }
    return self.new;
}
-(NSString*)yg_NSObjectId{
    return ([NSString stringWithFormat:@"%ld",(long)((NSInteger)self)]);
}

-(PropertyKVOBlock)yg_kvo{
    @weakify(self);
    PropertyKVOBlock tmpBlock= ^(NSString*property,KVOBlock blcok){
        NullReturn(blcok)
        NullReturn(property)
        @strongify(self);
        [[self rac_valuesAndChangesForKeyPath:property options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
            blcok(x);
        }];
        return self;
    };
    return tmpBlock;
}

-(NSNotificationObjectBlock)yg_notificationObject{
    @weakify(self);
    NSNotificationObjectBlock tmpBlock= ^(NSString*property,id object,KVOBlock blcok){
        NullReturn(blcok)
        NullReturn(property)
        @strongify(self);
        self.yg_removeNotification(property);
        RACDisposable*disposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:property object:object] subscribeNext:^(NSNotification *notification) {
            blcok(notification);
        }];
        [self.yg_Mudict setObject:disposable forKey:property];
        return self;
    };
    return tmpBlock;
}

-(NSNotificationBlock)yg_notification{
    @weakify(self);
    NSNotificationBlock tmpBlock= ^(NSString*property,KVOBlock blcok){
        NullReturn(blcok)
        NullReturn(property)
        @strongify(self);
        self.yg_removeNotification(property);
        RACDisposable*disposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:property object:nil] subscribeNext:^(NSNotification *notification) {
            blcok(notification);
        }];
        [self.yg_MemoryCache setObject:disposable forKey:property];
        return self;
    };
    return tmpBlock;
}

-(RemoveNSNotificationBlock)yg_removeNotification{
    @weakify(self);
    RemoveNSNotificationBlock tmpBlock= ^(NSString*property){
        NullReturn(property)
        @strongify(self);
        RACDisposable*disposable = [self.yg_MemoryCache objectForKey:property];
        if(disposable){
            [disposable dispose];
            [self.yg_MemoryCache removeObjectForKey:property];
        }
        return self;
    };
    return tmpBlock;
}
-(PostNSNotificationBlock)yg_postNotification{
    @weakify(self);
    PostNSNotificationBlock tmpBlock= ^(NSString*property,id value){
        NullReturn(property)
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:property object:value];
        return self;
    };
    return tmpBlock;
}

- (NSMutableDictionary *)yg_Mudict {
    __block NSMutableDictionary *mudict;
    dispatch_sync(yg_backgroundQueue(), ^{
        mudict = objc_getAssociatedObject(self, _cmd);
        if (!mudict){
            mudict = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, _cmd, mudict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    });
    return mudict;
}


- (YYMemoryCache *)yg_MemoryCache {
    __block YYMemoryCache *memoryCache;
    dispatch_sync(yg_backgroundQueue(), ^{
        memoryCache = objc_getAssociatedObject(self, _cmd);
        if (!memoryCache){
            memoryCache = [YYMemoryCache return:^(YYMemoryCache* value) {
                value.shouldRemoveAllObjectsWhenEnteringBackground = NO;
            }];
            objc_setAssociatedObject(self, _cmd, memoryCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    });
    return memoryCache;
}

-(void)resetYGMudict{
    [self.yg_Mudict removeAllObjects];
}

-(void)resetYGCache{
    [self.yg_Mudict removeAllObjects];
    [self.yg_MemoryCache removeAllObjects];
}
- (NSCache *)yg_Cache {
    @synchronized(self) {
        NSCache *operations = objc_getAssociatedObject(self, &yg_Cache_Key);
        if (operations) {
            return operations;
        }
        operations = [[NSCache alloc] init];
        objc_setAssociatedObject(self, &yg_Cache_Key, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return operations;
    }
}
-(SetWeakObjBlock)yg_strongSet{
    @weakify(self);
    SetWeakObjBlock tmpBlock= ^(NSString*key,id value){
        NullReturn(key)
        @strongify(self);
        if(value){
            [self.yg_MemoryCache setObject:value forKey:key];
        }else{
            [self.yg_MemoryCache removeObjectForKey:key];
        }

        return self;
    };
    return tmpBlock;
    
}

-(SetWeakObjBlock)yg_weakSet{
    @weakify(self);
    SetWeakObjBlock tmpBlock= ^(NSString*key,id value){
        NullReturn(key)
        @strongify(self);
        NSNumber* objectKey = [[NSNumber alloc]initWithLong:YG_Week_Number];
        [self.yg_MemoryCache setObject:objectKey forKey:key];
        objc_setAssociatedObject(self,(__bridge const void *)(objectKey),value,OBJC_ASSOCIATION_ASSIGN);
        return self;
    };
    return tmpBlock;
    
}

-(GetWeakObjBlock)yg_get{
    @weakify(self);
    GetWeakObjBlock tmpBlock= ^(NSString*key){
        NullReturn(key)
        @strongify(self);
        __block NSObject* value = nil;
        NSObject* bridge =  [self.yg_MemoryCache objectForKey:key];
        if(bridge && [bridge isKindOfClass:[NSNumber class]]){
            NSInteger number = [(NSNumber*)bridge integerValue];
            if(number == YG_Week_Number){
                @try{
                    value = objc_getAssociatedObject(self,(__bridge const void *)(bridge));
                }@catch(NSException* e) {
                    NSLog(@"yg_get 读取失败，缓存值已经释放");
                }
                return value;
            }
        }
        return bridge;//strong的值
    };
    return tmpBlock;
}

-(SignalForSelectorBlock)yg_signalForSelector{
    @weakify(self);
    SignalForSelectorBlock tmpBlock= ^(SEL selector,RACTupleBlock value){
        @strongify(self);
        NullReturn(value)
        if([self respondsToSelector:selector]){
            [[self rac_signalForSelector:selector] subscribeNext:^(RACTuple *tuple) {
                value(tuple);
            }];
        }
        return self;
    };
    return tmpBlock;
}

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
