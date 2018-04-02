//
//  YGHotSession+BLogic.m
//  DailyYoga
//
//  Created by lh on 2017/7/11.
//  Copyright © 2017年 lh. All rights reserved.
//
#import "YGNewBaseCoreModel+BLogic.h"
#import "YGHotSession+BLogic.h"
@implementation YGHotSession (BLogic)
+ (NSMutableArray *)allSession{
    WCTProperty sessionId_property = [self yg_wctPropertyByName:@"sessionId"];
    NSArray *array = [self selectWhereAction:(sessionId_property.isNotNull())];
    return [NSMutableArray arrayWithArray:array];
}
@end
