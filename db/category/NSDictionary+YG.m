//
//  NSDictionary+YG.m
//  DailyYoga
//
//  Created by lh on 2017/6/20.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "NSDictionary+YG.h"

@implementation NSDictionary (YG)


- (float)floatValue:(NSString *)path {
    return [self floatValue:path default:0.0];
}

- (NSInteger)intValue:(NSString*)path {
    return [self intValue:path default:0];
}

- (NSString*)strValue:(NSString*)path {
    return [self strValue:path default:@""];
}


- (float)floatValue:(NSString*)path default:(float)defValue{
    NSObject* obj = [self valueForKeyPath:path];
    if ([obj isKindOfClass:[NSNumber class]])
    return [(NSNumber*)obj floatValue];
    else if ([obj isKindOfClass:[NSString class]])
    return [(NSString*)obj floatValue];
    else
    return defValue;
}


- (NSInteger)intValue:(NSString*)path default:(NSInteger)defValue {
    NSObject* obj = [self valueForKeyPath:path];
    if ([obj isKindOfClass:[NSNumber class]])
    return [(NSNumber*)obj intValue];
    else if ([obj isKindOfClass:[NSString class]])
    return [(NSString*)obj intValue];
    else
    return defValue;
}

- (NSString*)strValue:(NSString*)path default:(NSString*)defValue {
    NSObject* obj = [self valueForKeyPath:path];
    if ([obj isKindOfClass:[NSNumber class]])
    return [(NSNumber*)obj stringValue];
    else if ([obj isKindOfClass:[NSString class]])
    return [(NSString*)obj length] <= 0 ? defValue : (NSString*)obj;
    else
    return defValue;
}

- (NSDate *)dateValue:(NSString *)path{
    
    return [self dateValue:path default:nil];
}
- (NSDate *)dateValue:(NSString *)path default:(NSDate *)defValue{
    NSObject *obj = [self valueForKey:path];
    if ([obj isKindOfClass:[NSDate class]]) {
        return (NSDate *)obj;
    }
    else
    return defValue;
}
/**
 dict 提取 NSDictionary
 
 @param path 对应的key
 
 @return NSDictionary
 */
-(NSDictionary *)dictValue:(NSString *)path{
    return [self dictValue:path default:[NSDictionary dictionary]];
}
/**
 dict 提取 NSDictionary
 
 @param path 对应的key
 @param defValue 默认空的NSDictionary
 
 @return NSDictionary
 */
-(NSDictionary *)dictValue:(NSString *)path default:(NSDictionary *)defValue{
    
    NSObject *obj = [self valueForKeyPath:path];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }else
    return defValue;
}

@end
