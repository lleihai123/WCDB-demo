#import "YGColdSession.h"
#import "NSDictionary+YG.h"
@implementation YGColdSession
/**
 通过dict生成model
 
 @param  dictionary 字典
 @return model
 */
- (id)updateByDict:(NSDictionary *)dictionary{
    self.objDesc =   [dictionary objectForKey:@"objDesc"]?[dictionary strValue:@"objDesc" default:@""]:self.objDesc;
    self.currentLevel =          [dictionary objectForKey:@"currentLevel"]?[dictionary intValue:@"currentLevel"]:self.currentLevel;
    return [super updateByDict:dictionary];
}

@end
