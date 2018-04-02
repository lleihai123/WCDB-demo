#import <Foundation/Foundation.h>
#import "YGNewBaseCoreModel.h"
@interface User : YGNewBaseCoreModel
@property int userid;
@property int localID;
@property (nonatomic, retain) NSString  *content;
@property (nonatomic ,retain) NSString  *name;
@property (nonatomic ,retain) NSString  *tmpname;
@end


//@interface UserManager : NSObject
//
//+ (UserManager *)defaultManager;
//
//#pragma mark ---------向表中插入数据
//- (void)insertData:(User *)msg;
//
//#pragma mark ---------查询表中数据
//- (void)queryData;
//
//#pragma mark ---------删除表中数据
//- (void)deleteDataFromTable:(NSString *)tableName;
//
//@end






