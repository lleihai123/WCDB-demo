#import <Foundation/Foundation.h>
#import "YGNewBaseCoreModel.h"
#import "YGColdSession.h"
@interface YGHotSession : YGNewBaseCoreModel
@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * package;
-(YGColdSession*)coldSession;

@end
