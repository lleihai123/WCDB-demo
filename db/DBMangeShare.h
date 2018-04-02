#import <Foundation/Foundation.h>
#import "YYMemoryCache.h"
@interface DBMangeShare : NSObject{
}
@property(atomic,strong)  YYMemoryCache * tableDict;
@property(nonatomic,strong)  NSOperationQueue *queue;
+(DBMangeShare*)sharedDBMange;
@end


@interface DBTypeMangeShare : NSObject{
}
@property(atomic,strong)  YYMemoryCache* sqliteTypeDict;
@property(atomic,strong)  YYMemoryCache* sqliteDataTypeDict;
@property(atomic,strong)  YYMemoryCache* enumeratePropertiesDict;
@property(nonatomic,strong)  YYMemoryCache* skipFieldDict;

@property(atomic,strong)  NSMutableDictionary* moreHostidObj;
+(DBTypeMangeShare*)sharedDBMange;
@end
