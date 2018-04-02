//
//  NSDictionary+YG.h
//  DailyYoga
//
//  Created by lh on 2017/6/20.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YG)
- (float)floatValue:(NSString *)path;
- (NSInteger)intValue:(NSString*)path;
- (NSString*)strValue:(NSString*)path;


- (float)floatValue:(NSString*)path default:(float)defValue;


- (NSInteger)intValue:(NSString*)path default:(NSInteger)defValue;

- (NSString*)strValue:(NSString*)path default:(NSString*)defValue;

- (NSDate *)dateValue:(NSString *)path;
- (NSDate *)dateValue:(NSString *)path default:(NSDate *)defValue;
/**
 dict 提取 NSDictionary
 
 @param path 对应的key
 
 @return NSDictionary
 */
-(NSDictionary *)dictValue:(NSString *)path;
/**
 dict 提取 NSDictionary
 
 @param path 对应的key
 @param defValue 默认空的NSDictionary
 
 @return NSDictionary
 */
-(NSDictionary *)dictValue:(NSString *)path default:(NSDictionary *)defValue;
@end
