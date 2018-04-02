#import "DBMangeShare.h"
#import "NSObject+YG.h"
@implementation DBMangeShare
static DBMangeShare *shareGameModel = nil;
+ (DBMangeShare*)sharedDBMange{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareGameModel = [[DBMangeShare alloc] init];
        shareGameModel.tableDict = [YYMemoryCache return:^(YYMemoryCache* value) {
            value.shouldRemoveAllObjectsWhenEnteringBackground = NO;
            value.shouldRemoveAllObjectsOnMemoryWarning = NO;
        }];
        shareGameModel.queue = [[NSOperationQueue alloc] init];
        shareGameModel.queue.maxConcurrentOperationCount = 3;
    });
	return shareGameModel;
}

@end

@implementation DBTypeMangeShare
static DBTypeMangeShare *shareDBTypeMange = nil;
+ (DBTypeMangeShare*)sharedDBMange{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareDBTypeMange = [[DBTypeMangeShare alloc] init];
        shareDBTypeMange.sqliteTypeDict = [YYMemoryCache return:^(YYMemoryCache* value) {
            value.shouldRemoveAllObjectsWhenEnteringBackground = NO;
            value.shouldRemoveAllObjectsOnMemoryWarning = NO;
        }];
        shareDBTypeMange.sqliteDataTypeDict = [YYMemoryCache return:^(YYMemoryCache* value) {
            value.shouldRemoveAllObjectsWhenEnteringBackground = NO;
            value.shouldRemoveAllObjectsOnMemoryWarning = NO;
        }];
        shareDBTypeMange.skipFieldDict = [YYMemoryCache return:^(YYMemoryCache* value) {
            value.shouldRemoveAllObjectsWhenEnteringBackground = NO;
            value.shouldRemoveAllObjectsOnMemoryWarning = NO;
        }];
        shareDBTypeMange.enumeratePropertiesDict = [YYMemoryCache return:^(YYMemoryCache* value) {
            value.shouldRemoveAllObjectsWhenEnteringBackground = NO;
            value.shouldRemoveAllObjectsOnMemoryWarning = NO;
        }];
        shareDBTypeMange.moreHostidObj = [NSMutableDictionary dictionaryWithCapacity:10];
    });
    return shareDBTypeMange;
}

@end
