#import "YGHotSession.h"
#import "NSDictionary+YG.h"
@implementation YGHotSession
/**
 通过dict生成model
 
 @param  dictionary 字典
 @return model
 */
- (id)updateByDict:(NSDictionary *)dictionary{
    self.sessionId = dictionary[@"sessionId"]?[dictionary intValue:@"sessionId"]:self.sessionId;
    self.lang =   [dictionary objectForKey:@"lang"]?[dictionary strValue:@"lang"]:self.lang;
    self.package =   [dictionary objectForKey:@"package"]?[dictionary strValue:@"package"]:self.package;
    [self bindHostID];
    return [super updateByDict:dictionary];
}

-(YGColdSession*)coldSession{
    YGColdSession *coldSession =  [YGColdSession getModel:self.hostID];
    if(!coldSession){
        coldSession = [YGColdSession new];
        coldSession.hostID = self.hostID;
        [coldSession updateSelf];
        [YGColdSession setModel:coldSession];
    }
    coldSession.hostID = self.hostID;//随时和热表保持一致hostID
    return coldSession;
}
- (void)bindHostID {
    self.hostID = [NSString stringWithFormat:@"%ld",(long)self.sessionId];
}
@end
