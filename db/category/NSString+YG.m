//
//  NSString+YG.m
//  DailyYoga
//
//  Created by lh on 2017/6/20.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "NSString+YG.h"
@implementation NSString (YG)
- (BOOL)myContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other options:NSCaseInsensitiveSearch];
    return range.length != 0;
}
@end
